-- Glow21 · Crea las columnas de seguimiento del CRM que faltaban
-- Pega esto en: Supabase Dashboard → SQL Editor → New query → Run
--
-- Diagnóstico: el webhook de Stripe fallaba con "column ... does not
-- exist" (42703, no un error de caché) al intentar marcar pagado=true, y
-- los toggles de "contactado"/nota del CRM tampoco tenían dónde guardarse.
-- Estas columnas estaban en supabase-setup-completo.sql pero nunca se
-- aplicaron de verdad en la base de datos en vivo.

alter table public.glow21_profiles
  add column if not exists contactado boolean not null default false,
  add column if not exists nota text not null default '';

alter table public.glow21_premium_leads
  add column if not exists contactado boolean not null default false,
  add column if not exists nota text not null default '',
  add column if not exists pagado boolean not null default false,
  add column if not exists paid_at timestamptz,
  add column if not exists stripe_session_id text;
