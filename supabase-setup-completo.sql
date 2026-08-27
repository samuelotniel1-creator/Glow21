-- Glow21 · SQL completo (todo de una sola vez)
-- Pega esto entero en: Supabase Dashboard → SQL Editor → New query → Run
--
-- Es seguro correrlo aunque ya hayas corrido esto antes: cada paso usa
-- "if not exists" / "drop policy if exists" + "create policy", así que no
-- duplica ni rompe nada si ya existía. Este archivo reemplaza a todos los
-- supabase-setup-N-*.sql anteriores (ya están fusionados aquí) — de aquí
-- en adelante, este es el único SQL que hace falta correr.
--
-- Lección de este proyecto, por si algo similar vuelve a pasar: una policy
-- de RLS sola NO basta si el rol (anon/authenticated) no tiene además el
-- GRANT de tabla correspondiente — sin el GRANT, Postgres rechaza la
-- operación antes de siquiera evaluar la policy. Por eso este archivo
-- incluye los GRANT explícitos, no solo las policies.

-- ---------- Config compartida de la landing ----------
create table if not exists public.glow21_settings (
  id integer primary key default 1,
  zoom_id text not null default '',
  session_date text not null default '',
  show_premium_button boolean not null default false,
  updated_at timestamptz not null default now(),
  constraint glow21_settings_single_row check (id = 1)
);

insert into public.glow21_settings (id)
values (1)
on conflict (id) do nothing;

alter table public.glow21_settings enable row level security;

drop policy if exists "glow21_settings_public_read" on public.glow21_settings;
create policy "glow21_settings_public_read"
  on public.glow21_settings
  for select
  using (true);

-- El panel admin tiene login (Supabase Auth): solo una sesión autenticada
-- puede actualizar la fila.
drop policy if exists "glow21_settings_public_update" on public.glow21_settings;
drop policy if exists "glow21_settings_authenticated_update" on public.glow21_settings;
create policy "glow21_settings_authenticated_update"
  on public.glow21_settings
  for update
  to authenticated
  using (auth.uid() is not null)
  with check (auth.uid() is not null);

-- ---------- Zoom password, fecha/hora real de la sesión, "en vivo ahora", link de pago ----------
create extension if not exists pgcrypto;

alter table public.glow21_settings
  add column if not exists zoom_password text not null default '',
  add column if not exists session_live boolean not null default false,
  add column if not exists session_datetime timestamptz,
  add column if not exists payment_link_url text not null default '';

-- Nota: la columna vieja "session_date" (texto libre) ya no se usa desde el
-- admin ni la landing. Se deja tal cual por si quieres conservarla; puedes
-- borrarla tú mismo más adelante con:
--   alter table public.glow21_settings drop column session_date;

-- ---------- Registro de asistentes (gate de la masterclass + preregistro) ----------
create table if not exists public.glow21_profiles (
  id uuid primary key default gen_random_uuid(),
  nombre text not null,
  correo text not null,
  telefono text not null,
  created_at timestamptz not null default now()
);

-- El registro ya no pide dirección (solo nombre, correo, teléfono). Si tu
-- tabla se creó con una corrida anterior de este SQL, esto la quita.
alter table public.glow21_profiles
  drop column if exists direccion;

-- CRM: seguimiento (contactado/nota) + origen del lead (masterclass el día
-- en vivo, o preregistro desde /preregistro con la pauta paga).
alter table public.glow21_profiles
  add column if not exists contactado boolean not null default false,
  add column if not exists nota text not null default '',
  add column if not exists origen text not null default 'masterclass';

alter table public.glow21_profiles enable row level security;

-- ---------- Datos de envío para el Acceso Premium (producto físico) ----------
-- Formulario aparte del registro de la masterclass (glow21_profiles): este
-- se llena solo al dar clic en "Acceso Premium", porque esa oferta incluye
-- un producto físico y necesita dirección de envío.
create table if not exists public.glow21_premium_leads (
  id uuid primary key default gen_random_uuid(),
  nombre text not null,
  correo text not null,
  telefono text not null,
  direccion text not null,
  created_at timestamptz not null default now()
);

-- CRM: seguimiento + estado de pago de Stripe (lo llena api/stripe-webhook.js
-- con la service_role/secret key, que siempre bypassa RLS).
alter table public.glow21_premium_leads
  add column if not exists contactado boolean not null default false,
  add column if not exists nota text not null default '',
  add column if not exists pagado boolean not null default false,
  add column if not exists paid_at timestamptz,
  add column if not exists stripe_session_id text,
  add column if not exists monto_centavos integer,
  add column if not exists moneda text;

alter table public.glow21_premium_leads enable row level security;

-- ---------- Permisos base de tabla (ver la lección al inicio del archivo) ----------
grant insert on public.glow21_profiles to anon, authenticated;
grant select, update on public.glow21_profiles to authenticated;

grant insert on public.glow21_premium_leads to anon, authenticated;
grant select, update on public.glow21_premium_leads to authenticated;

-- ---------- Políticas RLS ----------
-- Cualquier visitante (publishable key, sin login) puede registrarse...
drop policy if exists "glow21_profiles_public_insert" on public.glow21_profiles;
create policy "glow21_profiles_public_insert"
  on public.glow21_profiles
  for insert
  to anon, authenticated
  with check (true);

drop policy if exists "glow21_premium_leads_public_insert" on public.glow21_premium_leads;
create policy "glow21_premium_leads_public_insert"
  on public.glow21_premium_leads
  for insert
  to anon, authenticated
  with check (true);

-- ...pero nadie puede leer la lista con la publishable key: son datos de
-- contacto (correo, teléfono, dirección). Solo gente logueada (CRM) puede
-- leer o actualizar los leads.
drop policy if exists "glow21_profiles_authenticated_select" on public.glow21_profiles;
create policy "glow21_profiles_authenticated_select"
  on public.glow21_profiles
  for select
  to authenticated
  using (auth.uid() is not null);

drop policy if exists "glow21_profiles_authenticated_update" on public.glow21_profiles;
create policy "glow21_profiles_authenticated_update"
  on public.glow21_profiles
  for update
  to authenticated
  using (auth.uid() is not null)
  with check (auth.uid() is not null);

drop policy if exists "glow21_premium_leads_authenticated_select" on public.glow21_premium_leads;
create policy "glow21_premium_leads_authenticated_select"
  on public.glow21_premium_leads
  for select
  to authenticated
  using (auth.uid() is not null);

drop policy if exists "glow21_premium_leads_authenticated_update" on public.glow21_premium_leads;
create policy "glow21_premium_leads_authenticated_update"
  on public.glow21_premium_leads
  for update
  to authenticated
  using (auth.uid() is not null)
  with check (auth.uid() is not null);
