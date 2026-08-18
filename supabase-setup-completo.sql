-- Glow21 · SQL completo (todo de una sola vez)
-- Pega esto entero en: Supabase Dashboard → SQL Editor → New query → Run
--
-- Es seguro correrlo aunque ya hayas ejecutado antes alguno de los archivos
-- supabase-setup*.sql por separado: cada paso usa "if not exists" / "on
-- conflict do nothing", así que no duplica ni rompe nada si ya existía.

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
  using (auth.uid() is not null)
  with check (auth.uid() is not null);

-- ---------- Registro de asistentes + password de Zoom ----------
create extension if not exists pgcrypto;

alter table public.glow21_settings
  add column if not exists zoom_password text not null default '';

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

alter table public.glow21_profiles enable row level security;

-- Cualquier visitante (publishable key) puede registrarse...
drop policy if exists "glow21_profiles_public_insert" on public.glow21_profiles;
create policy "glow21_profiles_public_insert"
  on public.glow21_profiles
  for insert
  with check (true);

-- ...pero nadie puede leer la lista con la publishable key: son datos de
-- contacto (correo, teléfono, dirección). Si más adelante quieres verlos
-- desde un panel propio, hazlo con la service_role key desde un backend,
-- nunca agregando una policy de SELECT pública aquí.

-- ---------- Estado "en vivo ahora" ----------
alter table public.glow21_settings
  add column if not exists session_live boolean not null default false;

-- ---------- Fecha/hora real de la sesión (para el temporizador) ----------
alter table public.glow21_settings
  add column if not exists session_datetime timestamptz;

-- Nota: la columna vieja "session_date" (texto libre) ya no se usa desde el
-- admin ni la landing. Se deja tal cual por si quieres conservarla; puedes
-- borrarla tú mismo más adelante con:
--   alter table public.glow21_settings drop column session_date;

-- ---------- Datos de envío para el Acceso Premium (producto físico) ----------
-- Formulario aparte del registro de la masterclass (glow21_profiles): este
-- se llena solo al dar clic en "Acceso Premium 3 meses", porque esa oferta
-- incluye un producto físico y necesita dirección de envío.
create table if not exists public.glow21_premium_leads (
  id uuid primary key default gen_random_uuid(),
  nombre text not null,
  correo text not null,
  telefono text not null,
  direccion text not null,
  created_at timestamptz not null default now()
);

alter table public.glow21_premium_leads enable row level security;

drop policy if exists "glow21_premium_leads_public_insert" on public.glow21_premium_leads;
create policy "glow21_premium_leads_public_insert"
  on public.glow21_premium_leads
  for insert
  with check (true);

-- ---------- CRM (seguimiento) + estado de pago de Stripe ----------
alter table public.glow21_profiles
  add column if not exists contactado boolean not null default false,
  add column if not exists nota text not null default '';

alter table public.glow21_premium_leads
  add column if not exists contactado boolean not null default false,
  add column if not exists nota text not null default '',
  add column if not exists pagado boolean not null default false,
  add column if not exists paid_at timestamptz,
  add column if not exists stripe_session_id text;

-- Solo gente logueada (CRM) puede leer o actualizar los leads — nunca la
-- publishable key anónima, para proteger los datos de contacto.
drop policy if exists "glow21_profiles_authenticated_select" on public.glow21_profiles;
create policy "glow21_profiles_authenticated_select"
  on public.glow21_profiles for select using (auth.uid() is not null);

drop policy if exists "glow21_profiles_authenticated_update" on public.glow21_profiles;
create policy "glow21_profiles_authenticated_update"
  on public.glow21_profiles for update
  using (auth.uid() is not null) with check (auth.uid() is not null);

drop policy if exists "glow21_premium_leads_authenticated_select" on public.glow21_premium_leads;
create policy "glow21_premium_leads_authenticated_select"
  on public.glow21_premium_leads for select using (auth.uid() is not null);

drop policy if exists "glow21_premium_leads_authenticated_update" on public.glow21_premium_leads;
create policy "glow21_premium_leads_authenticated_update"
  on public.glow21_premium_leads for update
  using (auth.uid() is not null) with check (auth.uid() is not null);

-- Nota: el webhook de Stripe (api/stripe-webhook.js) no usa la publishable
-- key ni pasa por estas políticas — usa la service_role key desde el
-- servidor, que siempre puede escribir sin importar RLS.
