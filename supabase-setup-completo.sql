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

-- El panel admin usa la publishable key (no tiene login todavía), así que
-- necesita poder actualizar la fila. Si más adelante agregas autenticación
-- a /admin, cambia el "using (true)" de abajo por
-- "using (auth.uid() is not null)" para exigir sesión antes de escribir.
drop policy if exists "glow21_settings_public_update" on public.glow21_settings;
create policy "glow21_settings_public_update"
  on public.glow21_settings
  for update
  using (true)
  with check (true);

-- ---------- Registro de asistentes + password de Zoom ----------
create extension if not exists pgcrypto;

alter table public.glow21_settings
  add column if not exists zoom_password text not null default '';

create table if not exists public.glow21_profiles (
  id uuid primary key default gen_random_uuid(),
  nombre text not null,
  correo text not null,
  telefono text not null,
  direccion text not null,
  created_at timestamptz not null default now()
);

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
