# Glow21 — Contexto de negocio y producto

Documento de referencia para consultar (no un changelog). Última revisión: 2026-09-05.
Para detalle técnico línea por línea usa el repo directamente; esto es para entender
el "qué" y el "por qué" sin tener que leer código.

## Qué es Glow21

Glow21 es el programa educativo de skincare de **Aranza Malagón** (Mentora de
Reinvención Femenina): 21 días de método, con 5 pilares, enfocado en enseñar a
cuidar la piel desde el conocimiento (ciencia + comunidad), no desde la venta
agresiva. La guía completa de voz de marca e identidad visual vive en
`brand-glow21.skill` (ADN de marca, paleta, tipografía: Playfair Display
italic + Montserrat) — consúltalo para cualquier pieza de copy o diseño nueva.

## La Masterclass y la regla de "no mencionar Glow21"

Todo el negocio corre a través de un embudo de una **masterclass en vivo**
gratuita, usada como puerta de entrada al programa completo. Ahora mismo esa
clase se llama **"Tu piel habla antes que tú"** y se promociona con pauta
paga (Meta Ads).

Regla de negocio importante, no un descuido: **`/preregistro` (la landing de
la pauta) nunca menciona "Glow21" en el copy visible.** Es una táctica
deliberada de curiosidad — la gente descubre que es Glow21 hasta que ya está
dentro de la clase. Cualquier copy nuevo en esa página debe respetar esto.
`public/index.html` (landing principal), `/admin` y `/crm` sí usan la marca
completa y abiertamente.

Ambas capas comparten backend: un registro en `/preregistro` y uno en la
landing principal caen en la misma tabla (`glow21_profiles`), diferenciados
por la columna `origen` ('preregistro' vs 'masterclass').

## El embudo — 4 superficies

1. **`public/index.html`** (`glow21.vercel.app`) — landing con marca completa.
   Cuenta regresiva a la fecha de la clase, gate de registro antes de entrar
   al Zoom embebido (una vez registrado, ya no vuelve a pedir datos), y una
   oferta de compra ("Paquete Glow21", 4 productos físicos — **el colágeno de
   regalo se quitó de todo el copy e imágenes hasta que la empresa lo
   apruebe**, ver más abajo) que abre un formulario de envío y manda a un
   Payment Link de Stripe.
2. **`/preregistro`** — landing corta para la pauta paga, sin mencionar
   "Glow21". Registro → cuestionario de diagnóstico de piel (5 preguntas,
   contenido en `TEST_GLOW_Rapido.md`) → confirmación con botón de WhatsApp
   Comunidad (configurable desde admin) y botón de "agendar en Google
   Calendar" (el evento incluye el link de acceso a la clase).
3. **`/admin`** — panel de configuración (requiere login): datos de Zoom,
   fecha/hora de la sesión, toggle `session_live` ("en vivo ahora"), toggle
   de mostrar el botón de compra, link de pago de Stripe, link de la
   comunidad de WhatsApp.
4. **`/crm`** — gestión de leads (requiere login), con pestañas:
   - **Interesados** — leads de la pauta (`origen = 'preregistro'`).
   - **Registrados** — leads de la landing principal (`origen = 'masterclass'`).
   - **Premium / Pago** — quienes llenaron el formulario de compra, con
     estado real de pago (ver sección Pagos).
   - **Correos** — plantillas + cola de envío (ver sección Correos).

## Arquitectura técnica

- Sitio estático (HTML/CSS/JS sin build, sin framework) + una función
  serverless (`api/stripe-webhook.js`), todo hosteado en **Vercel**
  (`glow21.vercel.app`, deploy automático al hacer push a `main` en GitHub).
- **Supabase** (proyecto `yosammtxqqcwgvkaczyd`) como backend: tablas
  `glow21_settings` (config, fila única), `glow21_profiles` (leads de
  masterclass/preregistro), `glow21_premium_leads` (leads de compra + estado
  de pago), `glow21_email_templates` y `glow21_email_queue` (ver Correos).
  Todo el SQL vive en un único archivo idempotente:
  `supabase-setup-completo.sql` — es seguro re-correrlo aunque ya se haya
  corrido antes.
- RLS: cualquier visitante puede insertar un lead nuevo (`to anon`); leer o
  actualizar leads/config requiere sesión autenticada (`to authenticated`).
  Lección aprendida en este proyecto: una policy de RLS sola no basta, hace
  falta además el `grant` de tabla correspondiente — el SQL actual ya lo
  incluye explícito.
- `server.js` (Express) existe **solo para desarrollo local** — en
  producción Vercel sirve los archivos directamente vía `vercel.json`.

## Pagos (Stripe)

Un Payment Link de Stripe (configurado en `/admin`) recibe el pago; el
webhook (`api/stripe-webhook.js`) escucha `checkout.session.completed` y
marca `pagado = true` en `glow21_premium_leads`, cruzando por correo
(insensible a mayúsculas). Si el correo no coincide (p. ej. pagó con uno
distinto al que registró), hay un plan B: cruza por los últimos 10 dígitos
del teléfono — pero **solo funciona si el Payment Link de Stripe está
configurado para pedir teléfono en el checkout** (ajuste en el dashboard de
Stripe, no en el código).

Importante: llenar el formulario de compra **no significa que la persona
pagó** — el formulario guarda los datos de envío antes de mandar a Stripe
(para no perder el lead si abandona el pago). El único indicador confiable
es el campo `pagado` en el CRM (pestaña Premium/Pago), que solo lo cambia el
webhook cuando Stripe confirma el cobro de verdad.

## Correos

No hay un servicio de envío transaccional real (Resend, SendGrid, etc.)
conectado todavía — se necesitaría un dominio propio verificado para que
funcione bien (Glow21 no tiene dominio propio hoy, solo el subdominio de
Vercel). Mientras tanto, el envío es semi-manual:

1. En `/crm` → pestaña **Correos**, se seleccionan destinatarios (de
   Interesados, Registrados, o subiendo un CSV externo), se escribe una
   plantilla (con placeholder `{nombre}`), y se agrega a una cola
   (`glow21_email_queue`, con estado `pendiente`).
2. Un asistente de Claude Code (con el conector de Gmail de la cuenta
   `somosglow21@gmail.com` autorizado) procesa esa cola cuando se le pide en
   el chat: manda cada correo (convirtiendo los links en botones HTML reales)
   y marca la fila como `enviado`.

Limitaciones conocidas de este approach: sin dominio propio, los correos
pueden caer en spam o mostrar un aviso de "redirección sospechosa" en los
links (reputación de remitente nueva) — no es un bug de código, es
reputación. Tampoco hay manera de saber quién abrió el correo o le dio clic
al link sin un servicio real con tracking.

## Comunidad

Dos comunidades distintas, no confundirlas:
- **Skool** (`skool.com/glow21-4957`) — comunidad general de Glow21, con
  marca visible. Enlazada desde la landing principal ("Acceso Free a la
  comunidad") — **no** desde `/preregistro` (revelaría el nombre Glow21
  antes de tiempo).
- **WhatsApp** — comunidad específica de cada masterclass en vivo, con link
  configurable desde `/admin`, mostrada en la confirmación de `/preregistro`
  después de registrarse.

## Decisiones/reglas de negocio a tener presentes

- El colágeno de regalo ("+ Colágeno de regalo") **no está aprobado por la
  empresa todavía** — se quitó de botones, títulos e imágenes del formulario
  de compra el 2026-09-05. El paquete de 4 productos en sí sigue siendo una
  oferta real con envío físico.
- `session_live` es el único interruptor real de acceso al Zoom — antes del
  2026-09-05 había un bug donde alguien ya registrado entraba directo al
  Zoom sin importar este valor; ya está corregido (ver `ESTADO-DEL-PROYECTO.md`
  o el historial de git para el detalle técnico).
- Preferencia del usuario: subir cambios probados a GitHub automáticamente,
  sin preguntar cada vez.

## Dónde encontrar más detalle

- `ESTADO-DEL-PROYECTO.md` — estado técnico línea por línea, pendientes,
  cómo retomar el proyecto en otra máquina.
- `brand-glow21.skill` — voz de marca e identidad visual completas.
- `supabase-setup-completo.sql` — esquema completo de la base de datos.
- Historial de git en `github.com/samuelotniel1-creator/Glow21` — decisiones
  y arreglos específicos, con mensajes de commit descriptivos.
