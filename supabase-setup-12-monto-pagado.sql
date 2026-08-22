-- Glow21 · Guarda el monto pagado (para mostrarlo en el CRM)
-- Pega esto en: Supabase Dashboard → SQL Editor → New query → Run

alter table public.glow21_premium_leads
  add column if not exists monto_centavos integer,
  add column if not exists moneda text;
