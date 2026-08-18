-- Glow21 · CRM (seguimiento) + estado de pago de Stripe
-- Pega y ejecuta esto en: Supabase Dashboard → SQL Editor → New query → Run

-- ---------- Seguimiento (ambas tablas de leads) ----------
alter table public.glow21_profiles
  add column if not exists contactado boolean not null default false,
  add column if not exists nota text not null default '';

alter table public.glow21_premium_leads
  add column if not exists contactado boolean not null default false,
  add column if not exists nota text not null default '';

-- ---------- Estado de pago (solo premium, viene del webhook de Stripe) ----------
alter table public.glow21_premium_leads
  add column if not exists pagado boolean not null default false,
  add column if not exists paid_at timestamptz,
  add column if not exists stripe_session_id text;

-- ---------- Acceso del CRM: solo gente logueada, nunca la publishable key anónima ----------
-- Hasta ahora nadie podía leer estas tablas (ni con la publishable key) para
-- proteger los datos de contacto. El CRM va a tener su propio login
-- (Supabase Auth), así que estas políticas solo dejan pasar a quien esté
-- autenticado (auth.uid() is not null) — nunca a un visitante anónimo.

drop policy if exists "glow21_profiles_authenticated_select" on public.glow21_profiles;
create policy "glow21_profiles_authenticated_select"
  on public.glow21_profiles
  for select
  using (auth.uid() is not null);

drop policy if exists "glow21_profiles_authenticated_update" on public.glow21_profiles;
create policy "glow21_profiles_authenticated_update"
  on public.glow21_profiles
  for update
  using (auth.uid() is not null)
  with check (auth.uid() is not null);

drop policy if exists "glow21_premium_leads_authenticated_select" on public.glow21_premium_leads;
create policy "glow21_premium_leads_authenticated_select"
  on public.glow21_premium_leads
  for select
  using (auth.uid() is not null);

drop policy if exists "glow21_premium_leads_authenticated_update" on public.glow21_premium_leads;
create policy "glow21_premium_leads_authenticated_update"
  on public.glow21_premium_leads
  for update
  using (auth.uid() is not null)
  with check (auth.uid() is not null);

-- Nota: el webhook de Stripe (api/stripe-webhook.js) no usa la publishable
-- key ni pasa por estas políticas — usa la service_role key desde el
-- servidor, que siempre puede escribir sin importar RLS.

-- ---------- El admin también necesita login ahora ----------
-- Antes /admin escribía en glow21_settings con la publishable key sin
-- sesión (solo "nadie conoce la URL"). Ahora que tiene login, esto exige
-- sesión real antes de guardar cualquier cambio.
drop policy if exists "glow21_settings_public_update" on public.glow21_settings;
drop policy if exists "glow21_settings_authenticated_update" on public.glow21_settings;
create policy "glow21_settings_authenticated_update"
  on public.glow21_settings
  for update
  using (auth.uid() is not null)
  with check (auth.uid() is not null);
