# Estado del proyecto Glow21

Referencia rápida de qué existe, cómo está conectado, y qué falta. Útil al
retomar el proyecto en otra máquina o sesión. Última actualización: 2026-08-27.

## Estructura

- `public/index.html` — landing pública completa, marca Glow21 (`glow21.vercel.app`)
- `public/preregistro.html` — landing corta de preregistro para la pauta paga (`/preregistro`) — **no menciona "Glow21"**, ver sección de abajo
- `admin/` — panel de control (`/admin`), requiere login
- `crm/` — CRM de leads (`/crm`), requiere login
- `api/stripe-webhook.js` — función serverless de Vercel, recibe pagos de Stripe
- `server.js` — servidor Express solo para desarrollo local (`npm start`)
- `supabase-setup-completo.sql` — único archivo de setup de la base de datos (todos los `supabase-setup-N-*.sql` viejos se fusionaron aquí y se borraron); es seguro re-correrlo aunque ya lo hayas corrido antes
- `brand-glow21.skill` — guía de marca completa de Glow21 (ADN + identidad visual), úsala como referencia para cualquier pieza de contenido o diseño de la marca real
- `TEST_GLOW_Rapido.md` — contenido ya redactado del "diagnóstico de piel" (5 preguntas, lógica de resultado por tipo de piel) — **este es el contenido a usar para el cuestionario pendiente en `/preregistro`**, ver Pendientes
- `Glow21 - recursos/` y `Glow21 - pauta/` — carpetas locales con imágenes/assets de trabajo (fotos, logos, artes de la pauta), **no están en git**, solo existen en la máquina donde se crearon — si trabajas desde otra máquina y necesitas un archivo de ahí, pide que te lo pasen o se genere de nuevo

## ⚠️ Importante: la Masterclass ("Tu piel habla antes que tú") vs. la marca Glow21

Son dos capas distintas del mismo embudo — no confundirlas al editar contenido:

- **Glow21** es la marca real: el programa educativo de 21 días de Aranza Malagón (Mentora de Reinvención Femenina), con su ADN de marca completo (misión, 5 pilares, método, voz) documentado en `brand-glow21.skill`. La landing principal (`public/index.html`), `/admin` y `/crm` sí usan el nombre y el logo "G21" abiertamente — es la experiencia de marca completa.
- **"Tu piel habla antes que tú"** es el nombre de la Masterclass específica que se está promocionando por pauta paga ahora mismo. La estrategia de esta campaña es **ocultar deliberadamente que es Glow21** hasta que la persona ya esté dentro de la masterclass — es una táctica de curiosidad/reveal, no un descuido. Por eso `/preregistro`:
  - No dice "Glow21" en ningún texto (headline, subtítulo, beneficios, `<title>`, meta description) — se corrigió explícitamente varias veces cuando se colaba.
  - Sigue mostrando el ícono "G21" en el hero y "Glow21" en el footer (chico, pie de página) — **esto quedó pendiente de decisión** (ver Pendientes): el usuario pidió reemplazar el logo del hero por uno nuevo sin relación visible a "Glow21".
  - Guarda los leads en la misma tabla `glow21_profiles` que el registro del día en vivo, con `origen = 'preregistro'` para poder diferenciarlos en el CRM — el ocultamiento es solo de cara al visitante, no en el backend.
- El arte de referencia de la pauta (`Glow21 - pauta/Ganador 1.png`) muestra el mensaje real del anuncio: título "Tu piel habla antes que tú", badge "MASTERCLASS", fecha/hora, CTA "Prerregístrate hoy — Asegura tu lugar y recibe gratis: Diagnóstico de tu piel + Ebook", y nota "Al registrarte, respondes un breve cuestionario y obtienes tu diagnóstico." — esto es lo que impulsó el diseño actual de `/preregistro` y el diagnóstico pendiente.

**Regla práctica:** cualquier cambio a `/preregistro` debe evitar mencionar "Glow21" en el copy visible. Cualquier cambio a `public/index.html`, `/admin` o `/crm` sí puede (y debe) usar la marca completa.

## Qué hace la landing principal (`public/index.html`)

- Hero con temporizador de cuenta regresiva real (hora local de cada visitante) hacia la fecha que pongas en el admin.
- Sección "en vivo": antes de que actives el toggle "en vivo" muestra un CTA normal; en cuanto lo activas, todos los que ya estén en la página ven aparecer un aviso "¡Estamos en vivo!" solo, sin recargar (polling cada 10s).
- Registro obligatorio (nombre, correo, teléfono) antes de entrar al Zoom embebido — el nombre y la contraseña de la reunión se precargan solos en Zoom. Si ya te registraste antes (en esta página o en `/preregistro`, comparten la misma llave de `localStorage`), no vuelve a pedir datos.
- Embed de Zoom responsivo en móvil (ya no se corta), con botón de pantalla completa fuera del recuadro para no encimarse con los controles propios de Zoom.
- Botón "Obtén tu paquete Glow21 + Colágeno de regalo" (lo prendes/apagas desde el admin) que abre un formulario aparte con dirección de envío (nombre, correo, teléfono, calle/número/colonia/CP/ciudad/estado en grid) — porque esa oferta envía un producto físico — antes de mandar al link de pago configurado en el admin. Al abrirse, una animación revela la imagen del producto (Ganador + Colágeno) a un lado del formulario.
- Aura de fondo sutil y animada (pausada fuera de viewport) en hero/origen/cierre.
- Todo el contenido y la identidad visual de esta página siguen la guía de marca (`brand-glow21.skill`).

## `/preregistro` — landing de pauta

- Hero de dos columnas en escritorio (texto+temporizador a la izquierda, foto pegada al borde derecho de la pantalla, foto con degradado de desvanecido en la parte de abajo); en móvil la foto va arriba con el título "Tu piel habla antes que tú" superpuesto en cursiva/negrita sobre el espacio vacío de la imagen, y el H1 duplicado de abajo se oculta (ya que se repetiría).
- 4 bullets de beneficio + formulario inline (nombre, correo, teléfono) que al enviarse se reemplaza por un mensaje de confirmación en la misma página (sin redirigir), mostrando la fecha real de la sesión.
- Guarda en `glow21_profiles` con `origen = 'preregistro'`.
- Reutiliza la misma llave `glow21_registro` de `localStorage` que el registro de la landing principal.
- Foto del hero: `public/assets/hero/mujer-hero.webp`/`.png` (fondo transparente real, viene de `Glow21 - recursos/Imagen para landing.png`).
- Brief de marca para generar imágenes de anuncios con IA: `brief-imagenes-pauta.md` (pégalo en ChatGPT junto con el pedido de imagen).

## Panel admin (`/admin`)

Configura: invitación de Zoom (un solo campo donde pegas el "Copiar invitación" completo de Zoom — el panel extrae el ID y el código de acceso encriptado solo), fecha/hora de la sesión (selector nativo), link de pago de Stripe, toggle "en vivo ahora", toggle "Acceso Premium". Requiere login (Supabase Auth).

## CRM (`/crm`)

Rediseñado como lista compacta + panel de detalle (ya no es una tabla ancha con scroll horizontal):

- Cada fila = un lead (avatar con inicial, nombre, correo, indicador rápido de pago/contactado, fecha). Clic abre el panel de detalle.
- El panel de detalle muestra todos los datos con botón de copiar en cada campo, y un botón de WhatsApp (`wa.me`) junto al teléfono. Ahí mismo se edita el toggle "Contactado" y la nota.
- **Interesados** (`glow21_profiles`) — todos los que se registraron para ver la masterclass, con indicador de si ya pagó el premium (cruzado por correo) y de qué origen vienen (Masterclass = registro el día en vivo, Preregistro = pauta).
- **Premium / Pago** (`glow21_premium_leads`) — todos los que llenaron el formulario de Acceso Premium, incluidos los que no pagaron, con badge de estado de pago, **monto pagado** (lo manda Stripe en el webhook), e **ID de pago** copiable (para buscarlo en el Dashboard de Stripe).
- Botón para exportar la vista actual a CSV (incluye todas las columnas, incluido origen y monto).

## Base de datos (Supabase)

Proyecto: `yosammtxqqcwgvkaczyd`. Tablas: `glow21_settings` (config, fila única), `glow21_profiles` (leads masterclass — columnas: nombre, correo, telefono, created_at, contactado, nota, **origen**), `glow21_premium_leads` (leads premium — columnas: nombre, correo, telefono, direccion, created_at, contactado, nota, pagado, paid_at, stripe_session_id, **monto_centavos**, **moneda**).

RLS: lectura/escritura de leads y config solo con sesión autenticada (`to authenticated`); el registro público (insertar un lead nuevo) sigue abierto para cualquier visitante (`to anon, authenticated`).

**Lección importante de este proyecto** (ya corregida, pero vale la pena recordarla): una política de RLS sola **no basta** si el rol no tiene además el `GRANT` de tabla correspondiente — varias veces las políticas existían pero los inserts fallaban en silencio porque faltaba el `grant insert ... to anon`. El `supabase-setup-completo.sql` actual ya incluye los GRANT explícitos para evitar que se repita.

## Pago (Stripe) — estado

Completo desde 2026-08-19: Payment Link creado en Stripe y pegado en `/admin`, las 4 variables de entorno cargadas en Vercel (`STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`, `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY` — esta última debe ser la clave nueva `sb_secret_...`, no la legacy), webhook apuntando a `/api/stripe-webhook` para `checkout.session.completed`.

Verificado end-to-end el 2026-08-22 con un pago de prueba real ($20 MXN): el lead se marcó "pagado" correctamente en el CRM, con monto e ID de pago visibles.

## Pendientes

1. **Cambiar el logo de `/preregistro`** — el usuario pidió reemplazar el ícono "G21" del hero por el logo nuevo `Glow21 - recursos/Logo Tu piel habla antes que tu.png` (una gota + hojas en tono oro rosado, sin relación visual directa a "G21"). Ese archivo tiene fondo sólido rosa (no transparente) — probablemente hay que quitarle el fondo (o generar una versión con fondo transparente) antes de usarlo, igual que se hizo con la foto del hero. Pendiente también decidir si el footer ("Glow21" en texto chico) se deja o se quita para ser consistente con el resto de la página.
2. **Cuestionario/diagnóstico funcional después de registrarse en `/preregistro`** — el usuario confirmó que quiere un cuestionario real (no solo mencionarlo en texto), que se muestre justo después de enviar el formulario de registro y termine mostrando un resultado/diagnóstico. **El contenido ya existe**: `TEST_GLOW_Rapido.md` en la raíz del repo trae las 5 preguntas (opción A/B/C/D cada una) y la lógica de resultado (mayoría de una letra → tipo de piel: Normal/Equilibrada, Seca, Mixta o Grasa, con su descripción). Falta: diseñar la UI (pantallas de pregunta a pregunta o todo en una página, cómo se ve el resultado), decidir si el resultado se guarda en Supabase junto al lead (ej. una columna `tipo_piel` en `glow21_profiles`) y construirlo.
3. Housekeeping menor, no urgente: hay archivos sueltos en la raíz del repo (`Aranza Circulo.png`, `Aranza Malagon.png`, `glow21-landing-*.html/js/json`) que quedaron de antes de la separación en `public/`/`admin`/`crm` — no tocar salvo que se pida.

## Cómo continuar en otra máquina

1. `git pull` en `github.com/samuelotniel1-creator/Glow21` (rama `main`).
2. `npm install` si hace falta, `npm start` para probar en local (`http://localhost:3000`, `/admin`, `/crm`, `/preregistro`).
3. Las claves de Supabase (`SUPABASE_URL`, `sb_publishable_...`) ya están en el código cliente (son públicas a propósito). Las claves secretas (Stripe, `sb_secret_...` de Supabase) solo viven en Vercel → Environment Variables — pídelas si necesitas probar el webhook o hacer una consulta directa a la base de datos con permisos elevados.
4. Para tocar la base de datos: Supabase Dashboard → SQL Editor, o pide un token/clave para probar por API.
5. Para subir a GitHub: se necesita un Personal Access Token nuevo cada vez que se pide (no se guarda entre sesiones) — el usuario lo pega en el chat cuando se necesita.
6. Preferencia confirmada del usuario: subir los cambios a GitHub automáticamente después de probarlos, sin preguntar cada vez, salvo que pida explícitamente esperar.
