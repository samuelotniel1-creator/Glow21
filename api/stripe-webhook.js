// Recibe el evento "checkout.session.completed" de Stripe cuando alguien
// paga el Acceso Premium, y marca ese lead como pagado en Supabase.
//
// Variables de entorno requeridas (Vercel → Project Settings → Environment
// Variables, nunca en el código):
//   STRIPE_SECRET_KEY      — Stripe Dashboard → Developers → API keys
//   STRIPE_WEBHOOK_SECRET  — Stripe Dashboard → Developers → Webhooks → (tu endpoint) → Signing secret
//   SUPABASE_URL           — https://yosammtxqqcwgvkaczyd.supabase.co
//   SUPABASE_SERVICE_ROLE_KEY — Supabase Dashboard → Project Settings → API → service_role (secret)
//
// La service_role key bypassa RLS a propósito: este endpoint corre en el
// servidor de Vercel, nunca en el navegador, así que puede escribir aunque
// las políticas de glow21_premium_leads solo dejen pasar a usuarios logueados.

const Stripe = require('stripe');
const { createClient } = require('@supabase/supabase-js');

// El cuerpo debe llegar sin parsear: la firma de Stripe se calcula sobre
// los bytes crudos, no sobre el JSON ya interpretado.
module.exports.config = {
  api: { bodyParser: false },
};

function leerCuerpoCrudo(req) {
  return new Promise((resolve, reject) => {
    const chunks = [];
    req.on('data', (chunk) => chunks.push(chunk));
    req.on('end', () => resolve(Buffer.concat(chunks)));
    req.on('error', reject);
  });
}

// Nos quedamos solo con los últimos 10 dígitos (ignora +52, espacios,
// guiones, etc.) para poder comparar el teléfono tal cual lo captura
// Stripe contra el que la persona escribió en nuestro formulario.
function normalizarTelefono(valor) {
  return (valor || '').replace(/\D/g, '').slice(-10);
}

module.exports = async (req, res) => {
  if (req.method !== 'POST') {
    res.status(405).send('Method Not Allowed');
    return;
  }

  if (!process.env.STRIPE_SECRET_KEY || !process.env.STRIPE_WEBHOOK_SECRET || !process.env.SUPABASE_URL || !process.env.SUPABASE_SERVICE_ROLE_KEY) {
    console.error('Glow21 webhook: faltan variables de entorno (STRIPE_SECRET_KEY, STRIPE_WEBHOOK_SECRET, SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)');
    res.status(500).send('Webhook not configured');
    return;
  }

  const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);
  const supabase = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_SERVICE_ROLE_KEY);

  const firma = req.headers['stripe-signature'];
  let evento;

  try {
    const cuerpoCrudo = await leerCuerpoCrudo(req);
    evento = stripe.webhooks.constructEvent(cuerpoCrudo, firma, process.env.STRIPE_WEBHOOK_SECRET);
  } catch (err) {
    console.error('Glow21 webhook: firma inválida', err.message);
    res.status(400).send(`Webhook Error: ${err.message}`);
    return;
  }

  if (evento.type === 'checkout.session.completed') {
    const session = evento.data.object;
    const correo = (session.customer_details && session.customer_details.email) || session.customer_email;
    const telefonoStripe = session.customer_details && session.customer_details.phone;

    const datosPago = {
      pagado: true,
      paid_at: new Date().toISOString(),
      stripe_session_id: session.id,
      monto_centavos: session.amount_total ?? null,
      moneda: session.currency ?? null,
    };

    let coincidencias = [];

    if (correo) {
      const { data, error } = await supabase
        .from('glow21_premium_leads')
        .update(datosPago)
        .ilike('correo', correo)
        .select('id');

      if (error) console.error('Glow21 webhook: error marcando pagado por correo', error);
      else coincidencias = data || [];
    }

    // Plan B: si no hubo match por correo (p. ej. usó uno distinto al
    // pagar), intenta cruzar por los últimos 10 dígitos del teléfono.
    // Solo funciona si el Payment Link de Stripe pide teléfono en el checkout.
    if (!coincidencias.length) {
      const telNormalizado = normalizarTelefono(telefonoStripe);

      if (telNormalizado.length === 10) {
        const { data: candidatos, error: errorCandidatos } = await supabase
          .from('glow21_premium_leads')
          .select('id, telefono')
          .eq('pagado', false);

        if (errorCandidatos) {
          console.error('Glow21 webhook: error buscando candidatos por teléfono', errorCandidatos);
        } else {
          const match = (candidatos || []).find((r) => normalizarTelefono(r.telefono) === telNormalizado);

          if (match) {
            const { error: errorUpdate } = await supabase
              .from('glow21_premium_leads')
              .update(datosPago)
              .eq('id', match.id);

            if (errorUpdate) console.error('Glow21 webhook: error marcando pagado por teléfono', errorUpdate);
            else coincidencias = [match];
          }
        }
      }
    }

    if (!coincidencias.length) {
      console.warn('Glow21 webhook: checkout.session.completed sin match por correo ni teléfono', { correo, telefonoStripe });
    }
  }

  res.status(200).json({ received: true });
};
