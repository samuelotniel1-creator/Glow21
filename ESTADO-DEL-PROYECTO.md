# Estado del proyecto Glow21

Referencia rápida de qué existe, cómo está conectado, y qué falta. Útil al
retomar el proyecto en otra máquina o sesión. Última actualización: 2026-09-15.

Para el panorama de negocio/producto (qué es la marca, la masterclass, la
oferta, reglas como "no mencionar Glow21 en /preregistro") ver
`GLOW21-CONTEXTO.md` — este archivo es el complemento técnico: qué existe,
cómo está conectado, y los pendientes.

## Estructura

- `public/index.html` — landing pública completa, marca Glow21 (`glow21.vercel.app`)
- `public/preregistro.html` — landing corta de preregistro para la pauta paga (`/preregistro`) — **no menciona "Glow21"** en el copy visible (ver `GLOW21-CONTEXTO.md`)
- `admin/` — panel de control (`/admin`), requiere login
- `crm/` — CRM de leads (`/crm`), requiere login
- `api/stripe-webhook.js` — función serverless de Vercel, recibe pagos de Stripe
- `api/registro.js` — función serverless que guarda preregistro, diagnóstico de piel, y leads premium usando la `service_role` key (ver sección "Por qué `/api/registro` y no Supabase directo desde el navegador")
- `server.js` — servidor Express solo para desarrollo local (`npm start`)
- `supabase-setup-completo.sql` — único archivo de setup de la base de datos; es seguro re-correrlo aunque ya lo hayas corrido antes (usa `if not exists` / `drop policy if exists` + `create policy`)
- `GLOW21-CONTEXTO.md` — contexto de negocio/producto (qué es la marca, el embudo, la oferta de la masterclass, pagos, correos, comunidad) — léelo primero si la tarea es sobre negocio/copy, no solo código. También cargable como skill (`.claude/skills/glow21-contexto/`).
- `MASTERCLASS-PRESENTACION.md` — guion completo de la clase en vivo y de la oferta ("Programa Premium Glow 21"), con precios y bonos.
- `brand-glow21.skill` — guía de marca completa de Glow21 (ADN + identidad visual)
- `TEST_GLOW_Rapido.md` — contenido del cuestionario de diagnóstico de piel usado en `/preregistro` (5 preguntas, lógica de resultado por tipo de piel)
- `brief-imagenes-pauta.md` — brief de marca para generar imágenes de anuncios con IA
- `Glow21 - recursos/` y `Glow21 - pauta/` — carpetas locales con imágenes/assets de trabajo, **no están en git**, solo existen en la máquina donde se crearon
- Archivos sueltos en la raíz sin usar por el sitio (housekeeping pendiente, ver Pendientes): `Aranza Circulo.png`, `Aranza Malagon.png`, `glow21-landing-*.html/js/json`

## Vercel — convención de rutas

`public/` es la raíz web implícita de Vercel (como Create React App): las
rutas en `vercel.json` apuntan a `/index.html`, `/preregistro.html`, etc. —
**sin** el prefijo `/public/`, aunque el archivo físico viva en
`public/index.html`. Ya hubo un bug por esto (rewrites apuntando a un
`public/public/` anidado que no existe) — si tocas `vercel.json`, no le
agregues `/public/` a los destinos.

## Qué hace la landing principal (`public/index.html`)

- Hero con temporizador de cuenta regresiva real hacia la fecha que pongas en el admin.
- Sección "en vivo": el toggle `session_live` del admin es el único interruptor real de acceso al Zoom — incluso para alguien ya registrado antes (había un bug donde entraba directo sin importar este valor; corregido 2026-09-05).
- Registro obligatorio (nombre, correo, teléfono) antes de entrar al Zoom embebido — nombre y contraseña de la reunión se precargan solos. Comparte `localStorage` con `/preregistro`, así que quien ya se registró en cualquiera de las dos no vuelve a captar datos.
- Zoom embebido, agrandado en escritorio; responsivo en móvil, con botón de pantalla completa fuera del recuadro. (Se probó reemplazar Zoom por YouTube y luego por Jitsi Meet como alternativas — ambos experimentos se revirtieron, el proveedor sigue siendo Zoom.)
- Botón de compra ("Obtén tu Paquete Glow21", 4 productos físicos) — el "+ Colágeno de regalo" se quitó de todo el copy/imágenes el 2026-09-05, no está aprobado por la empresa todavía. Abre un formulario de envío con **dos formas de pago**:
  - Pago de contado → Stripe Payment Link (configurado en `/admin`).
  - Pago a meses sin intereses → Mercado Pago, link fijo hardcodeado en el JS (`MERCADOPAGO_MSI_URL`, no configurable desde el admin todavía).
  - Ambos botones guardan el lead primero (vía `/api/registro`) antes de redirigir, para no perderlo si abandona el pago.
- Aura de fondo sutil y animada (pausada fuera de viewport) en hero/origen/cierre.

## `/preregistro` — landing de pauta

- Hero de dos columnas en escritorio, foto con degradado en la parte de abajo; en móvil la foto va arriba con el título superpuesto.
- Formulario inline (nombre, correo, teléfono) → guarda el lead de inmediato (vía `/api/registro`, `origen = 'preregistro'`) → muestra el **cuestionario de diagnóstico de piel** (5 preguntas, `TEST_GLOW_Rapido.md`) en la misma página.
- Al terminar, calcula el tipo de piel por mayoría de respuesta y **lo guarda** en `glow21_profiles.tipo_piel` (vía `/api/registro`, acción `diagnostico`) — visible en el CRM. Luego muestra confirmación con la fecha real de la sesión, botón de WhatsApp Comunidad (link configurable desde `/admin`) y botón "Agendar en mi calendario" (Google Calendar, con el link de acceso a la clase incluido en el evento).
- Logo propio de la masterclass (no "G21"): `public/assets/logos/logo-masterclass.png`/`.webp`.
- **Meta Pixel instalado** (2026-08-31): pixel `1416585077128417` ("Masterclass Skincare"), con `fbq('track', 'CompleteRegistration')` justo después de que el registro se guarda sin error. Solo en `/preregistro`, no en la landing principal.
- **Pendiente de decisión**: el footer todavía dice "Glow21" (chico, pie de página) — el resto de la página ya no menciona la marca en ningún lado.

## Panel admin (`/admin`)

Configura: invitación de Zoom (pegas el "Copiar invitación" completo de Zoom, el panel extrae ID/password), fecha/hora de la sesión, link de pago de Stripe, link de la comunidad de WhatsApp, toggle "en vivo ahora" (`session_live`), toggle "mostrar botón de compra". Requiere login (Supabase Auth).

## CRM (`/crm`)

Lista compacta + panel de detalle, con pestañas:

- **Interesados** (`glow21_profiles`, `origen = 'preregistro'`) — leads de la pauta paga.
- **Registrados** (`glow21_profiles`, `origen = 'masterclass'`) — leads de la landing principal.
- **Premium / Pago** (`glow21_premium_leads`) — quienes llenaron el formulario de compra, con estado real de pago, monto, e ID de pago de Stripe.
- **Correos** — plantillas (placeholder `{nombre}`) + cola de envío (`glow21_email_queue`). Ver "Correos" más abajo — no hay envío automático, es semi-manual.

Cada lead: toggle "Contactado", nota editable, botón de WhatsApp directo. Importar leads desde CSV externo. Exportar la vista actual a CSV.

## Correos

No hay proveedor transaccional conectado (Resend/SendGrid/etc.) — Glow21 no
tiene dominio propio todavía, solo el subdominio de Vercel, y eso afecta la
entregabilidad. El flujo actual es semi-manual:

1. En `/crm` → pestaña Correos: eliges destinatarios (Interesados, Registrados, o CSV subido), escribes la plantilla, la agregas a la cola (`glow21_email_queue`, estado `pendiente`).
2. Un asistente de Claude Code, con el conector de Gmail de `somosglow21@gmail.com` autorizado, procesa la cola cuando se le pide: manda cada correo (convirtiendo links en botones HTML) y marca la fila como `enviado`.

Limitación conocida: sin dominio propio, riesgo de spam/avisos de "redirección sospechosa" en links, y no hay tracking de aperturas/clics.

## Base de datos (Supabase)

Proyecto: `yosammtxqqcwgvkaczyd`. Tablas: `glow21_settings` (config, fila única, incluye `payment_link_url` y `whatsapp_community_url`), `glow21_profiles` (leads — nombre, correo, telefono, created_at, contactado, nota, origen, **tipo_piel**), `glow21_premium_leads` (leads de compra — incluye direccion, pagado, paid_at, stripe_session_id, monto_centavos, moneda), `glow21_email_templates` y `glow21_email_queue` (ver Correos).

RLS: lectura/escritura de leads y config requiere sesión autenticada (`to authenticated`); el registro público sigue abierto (`to anon, authenticated`) — pero ver la sección siguiente, porque en la práctica los inserts de `anon` no se usan.

### Por qué `/api/registro` y no Supabase directo desde el navegador

Las políticas RLS de `glow21_profiles` y `glow21_premium_leads` están
correctas (verificadas letra por letra), pero el proyecto de Supabase tiene
un **bug de infraestructura** que rechaza cualquier INSERT/UPDATE del rol
`anon` sin importar qué política exista — hasta una tabla de prueba nueva
con policy trivial `with check (true)` falla igual. Mientras Supabase
soporte lo resuelve, `api/registro.js` rodea el problema por completo:
corre en el servidor de Vercel (nunca en el navegador) y usa la
`service_role` key, que ignora RLS. Si en algún momento Supabase confirma
que arregló el bug, se podría volver a escribir directo desde el navegador,
pero no asumas que ya se arregló sin verificar primero.

**Lección de RLS también vigente**: una policy sola no basta si falta el
`GRANT` de tabla correspondiente — el `supabase-setup-completo.sql` actual
ya incluye los GRANT explícitos.

## Pago — estado

**Stripe**: completo y probado end-to-end (pago real de $20 MXN, 2026-08-22) — Payment Link en `/admin`, 4 variables de entorno en Vercel (`STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`, `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY` — esta última debe ser la clave nueva `sb_secret_...`, no la legacy), webhook en `/api/stripe-webhook` para `checkout.session.completed`. El webhook cruza por correo (insensible a mayúsculas) y, si no coincide, por los últimos 10 dígitos del teléfono como plan B (solo funciona si el Payment Link de Stripe pide teléfono en el checkout — ajuste del lado de Stripe, no del código).

**Mercado Pago**: opción de pago a meses sin intereses agregada en la landing principal, link fijo (no configurable desde admin). No hay webhook de Mercado Pago — el CRM no se entera automáticamente de estos pagos, solo de los de Stripe.

Importante: llenar el formulario de compra **no significa que la persona pagó** — el único indicador confiable es el campo `pagado` en `/crm` → Premium/Pago, que solo lo actualiza el webhook de Stripe cuando confirma el cobro real.

## Meta Pixel / pauta paga

Instalado en `/preregistro` (ver arriba). El pixel es `1416585077128417`
("Masterclass Skincare" en Events Manager). El evento `CompleteRegistration`
fue lo que desbloqueó configurar el "Evento de conversión" en Ads Manager.

## Pendientes

1. Decidir si quitar la mención de "Glow21" del footer de `/preregistro` (sigue ahí, el resto de la página ya no menciona la marca).
2. Housekeeping menor, no urgente: archivos sueltos en la raíz sin usar por el sitio (`Aranza Circulo.png`, `Aranza Malagon.png`, `glow21-landing-*`) — no tocar salvo que se pida.
3. Sistema de correo real (Resend/SendGrid) — requiere dominio propio verificado primero; hoy el envío es semi-manual vía CRM + Gmail (ver "Correos").
4. El link de Mercado Pago está hardcodeado en el JS — si se quiere editable sin tocar código, habría que agregarlo a `glow21_settings` como se hizo con el de Stripe.
5. No hay webhook de Mercado Pago — los pagos a meses no actualizan el estado `pagado` en el CRM automáticamente, hay que verificarlos a mano en el dashboard de Mercado Pago si se necesita saber quién pagó por esa vía.

## Cómo continuar en otra máquina

1. `git pull` en `github.com/samuelotniel1-creator/Glow21` (rama `main`).
2. `npm install` si hace falta, `npm start` para probar en local (`http://localhost:3000`, `/admin`, `/crm`, `/preregistro`).
3. Las claves de Supabase (`SUPABASE_URL`, `sb_publishable_...`) ya están en el código cliente (públicas a propósito). Las claves secretas (Stripe, `sb_secret_...` de Supabase) solo viven en Vercel → Environment Variables — pídelas si necesitas probar el webhook o `/api/registro` en local.
4. Para tocar la base de datos: Supabase Dashboard → SQL Editor, o pide un token/clave para probar por API.
5. Para subir a GitHub: se necesita un Personal Access Token nuevo cada vez que se pide (no se guarda entre sesiones) — el usuario lo pega en el chat cuando se necesita. (Nota: en máquinas con Git Credential Manager configurado, esto no hace falta — la sesión ya queda autenticada de antes.)
6. Preferencia confirmada del usuario: subir los cambios a GitHub automáticamente después de probarlos, sin preguntar cada vez, salvo que pida explícitamente esperar.
