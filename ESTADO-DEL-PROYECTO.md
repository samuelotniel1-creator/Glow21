# Estado del proyecto Glow21

Referencia rápida de qué existe, cómo está conectado, y qué falta. Útil al
retomar el proyecto en otra máquina o sesión.

## Estructura

- `public/` — landing pública (`glow21.vercel.app`)
- `admin/` — panel de control (`/admin`), requiere login
- `crm/` — CRM de leads (`/crm`), requiere login
- `api/stripe-webhook.js` — función serverless de Vercel, recibe pagos de Stripe
- `server.js` — servidor Express solo para desarrollo local (`npm start`)
- `supabase-setup*.sql` — migraciones, en orden; `supabase-setup-completo.sql` las trae todas juntas y es seguro re-correrlo

## Qué hace la landing (`public/`)

- Hero con temporizador de cuenta regresiva real (hora local de cada visitante) hacia la fecha que pongas en el admin.
- Sección "en vivo": antes de que actives el toggle "en vivo" muestra un CTA normal; en cuanto lo activas, todos los que ya estén en la página ven aparecer un aviso "¡Estamos en vivo!" solo, sin recargar (polling cada 10s).
- Registro obligatorio (nombre, correo, teléfono) antes de entrar al Zoom embebido — el nombre y la contraseña de la reunión se precargan solos en Zoom. Si ya te registraste antes, no vuelve a pedir datos.
- Botón "Acceso Premium 3 meses" (lo prendes/apagas desde el admin) que abre un formulario aparte (nombre, correo, teléfono, **dirección** — porque esa oferta envía un producto físico) antes de mandar al link de pago configurado en el admin. Si aún no hay link, se le avisa a la persona que el pago todavía no está disponible (sus datos ya quedan guardados).
- Todo el contenido y la identidad visual siguen la guía de marca (`brand-glow21.skill`).

## Panel admin (`/admin`)

Configura: Zoom Meeting ID, password de Zoom, fecha/hora de la sesión (selector nativo), link de pago de Stripe, toggle "en vivo ahora", toggle "Acceso Premium". Ahora pide login (antes no tenía ninguna protección).

## CRM (`/crm`)

Dos pestañas:
- **Interesados** — todos los que se registraron para ver la masterclass (`glow21_profiles`). Aquí caen tanto los que se registran el día de la clase como los que lleguen por la pauta publicitaria antes (mismo formulario).
- **Premium / Pago** — todos los que llenaron el formulario de Acceso Premium (`glow21_premium_leads`), incluidos los que no pagaron, con estado de pago (lo actualiza el webhook de Stripe automáticamente).

Cada lead tiene un toggle "Contactado" y un campo de nota, editable en la tabla. Botón para exportar la vista actual a CSV.

## Base de datos (Supabase)

Proyecto: `yosammtxqqcwgvkaczyd`. Tablas: `glow21_settings` (config, fila única), `glow21_profiles` (leads masterclass), `glow21_premium_leads` (leads premium + estado de pago). RLS: lectura/escritura de leads y config solo con sesión autenticada; el registro público (insertar un lead nuevo) sigue abierto para cualquier visitante, como debe ser.

## Pendiente para que el pago funcione

1. **Crear el Payment Link en Stripe** — esperando que definan el precio del producto.
2. **Variables de entorno en Vercel** (Project Settings → Environment Variables):
   - `STRIPE_SECRET_KEY` — usar una **Restricted key** (no la Secret key completa), con todo en "None" salvo "Checkout Sessions: Read".
   - `STRIPE_WEBHOOK_SECRET` — se obtiene al crear el webhook en Stripe (ver siguiente punto).
   - `SUPABASE_URL` — `https://yosammtxqqcwgvkaczyd.supabase.co`
   - `SUPABASE_SERVICE_ROLE_KEY` — Supabase → Project Settings → API → `service_role` (secreta, nunca en el código).
3. **Crear el webhook en Stripe**: Developers → Webhooks → Add endpoint → `https://<dominio>.vercel.app/api/stripe-webhook` → evento `checkout.session.completed`.
4. **Pegar el link de pago real** en el panel admin (campo "Link de pago (Stripe)"). El botón de Acceso Premium ya no depende de una ruta fija `/pago`: usa `glow21_settings.payment_link_url`, editable sin tocar código ni redeploy. Mientras esté vacío, a quien complete el formulario se le avisa que el pago todavía no está disponible (sus datos ya quedaron guardados).
5. **Crear la cuenta de login** para `/admin` y `/crm`: Supabase → Authentication → Users → Add user (una sola cuenta sirve para ambos).
