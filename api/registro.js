// Guarda el preregistro (y el resultado del diagnóstico de piel) usando la
// service_role key, en vez de dejar que el navegador escriba directo a
// Supabase con la llave pública.
//
// Por qué existe este endpoint: las políticas RLS de glow21_profiles están
// correctas (verificado a mano letra por letra), pero el proyecto de
// Supabase tiene un bug de infraestructura que rechaza cualquier INSERT/UPDATE
// del rol "anon" sin importar qué política exista — hasta una tabla de
// prueba nueva con una política trivial "with check (true)" falla igual.
// Mientras Supabase soporte lo resuelve, este endpoint rodea el problema
// por completo: corre en el servidor de Vercel (nunca en el navegador), así
// que puede usar la service_role key, que ignora RLS.
//
// Variables de entorno requeridas (Vercel → Project Settings → Environment
// Variables, ya configuradas porque api/stripe-webhook.js las usa igual):
//   SUPABASE_URL
//   SUPABASE_SERVICE_ROLE_KEY

const { createClient } = require('@supabase/supabase-js');

module.exports = async (req, res) => {
  if (req.method !== 'POST') {
    res.status(405).json({ error: 'Method Not Allowed' });
    return;
  }

  if (!process.env.SUPABASE_URL || !process.env.SUPABASE_SERVICE_ROLE_KEY) {
    console.error('Glow21 registro: faltan variables de entorno (SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)');
    res.status(500).json({ error: 'Servidor no configurado' });
    return;
  }

  const supabase = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_SERVICE_ROLE_KEY);
  const body = req.body || {};

  if (body.action === 'crear') {
    const nombre = (body.nombre || '').trim();
    const correo = (body.correo || '').trim();
    const telefono = (body.telefono || '').trim();

    if (!nombre || !correo || !telefono) {
      res.status(400).json({ error: 'Faltan datos' });
      return;
    }

    const { data, error } = await supabase
      .from('glow21_profiles')
      .insert({ nombre, correo, telefono, origen: 'preregistro' })
      .select('id')
      .single();

    if (error) {
      console.error('Glow21 registro: error guardando preregistro', error);
      res.status(500).json({ error: 'No se pudo guardar' });
      return;
    }

    res.status(200).json({ id: data.id });
    return;
  }

  if (body.action === 'diagnostico') {
    const id = body.id;
    const tipoPiel = (body.tipo_piel || '').trim();

    if (!id || !tipoPiel) {
      res.status(400).json({ error: 'Faltan datos' });
      return;
    }

    const { error } = await supabase
      .from('glow21_profiles')
      .update({ tipo_piel: tipoPiel })
      .eq('id', id);

    if (error) {
      console.error('Glow21 registro: error guardando tipo_piel', error);
      res.status(500).json({ error: 'No se pudo guardar' });
      return;
    }

    res.status(200).json({ ok: true });
    return;
  }

  res.status(400).json({ error: 'Acción desconocida' });
};
