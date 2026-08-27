# Estado del proyecto Glow21

Referencia rápida de qué existe, cómo está conectado, y qué falta. Útil al
retomar el proyecto en otra máquina o sesión.

## Estructura

- `public/` — landing pública (`glow21.vercel.app`)
- `admin/` — panel de control (`/admin`), requiere login
- `crm/` — CRM de leads (`/crm`), requiere login
- `api/stripe-webhook.js` — función serverless de Vercel, recibe pagos de Stripe
- `server.js` — servidor Express solo para desarrollo local (`npm start`)
- `supabase-setup-completo.sql` — único archivo de setup de la base de datos; es seguro re-correrlo aunque ya lo hayas corrido antes

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

## Pago — estado

Completo desde 2026-08-19. Ya está: migración de `payment_link_url` corrida
en Supabase, Payment Link creado en Stripe y pegado en `/admin`, las 4
variables de entorno cargadas en Vercel (`STRIPE_SECRET_KEY` como
restricted key con solo "Checkout Sessions: Read", `STRIPE_WEBHOOK_SECRET`,
`SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY`), webhook creado en Stripe
apuntando a `/api/stripe-webhook` para `checkout.session.completed`, y
cuenta de login creada para `/admin` y `/crm`. Verificado con un POST de
prueba al webhook: responde `400` por firma faltante (no `500` de "no
configurado"), lo que confirma que las 4 variables están presentes en el
deploy.

Pendiente real: hacer una compra de prueba end-to-end y confirmar que el
lead correspondiente aparece como "pagado" en la pestaña Premium/Pago del
CRM.
