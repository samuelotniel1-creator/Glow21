-- Glow21 · estado "en vivo ahora" (Supabase, plan Free)
-- Pega y ejecuta esto en: Supabase Dashboard → SQL Editor → New query → Run
-- Independiente de supabase-setup-2-registro.sql — puedes correr este aunque
-- todavía no hayas corrido aquel.

alter table public.glow21_settings
  add column if not exists session_live boolean not null default false;
