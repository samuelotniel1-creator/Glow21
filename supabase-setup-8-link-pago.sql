-- Glow21 · Link de pago configurable desde el admin
-- Antes el botón "Acceso Premium" mandaba siempre a /pago (una ruta que
-- nunca se creó). Ahora el link de pago de Stripe se guarda en
-- glow21_settings y se pega desde el panel admin en cuanto exista.

alter table public.glow21_settings
  add column if not exists payment_link_url text not null default '';
