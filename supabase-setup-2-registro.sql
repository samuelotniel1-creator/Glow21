-- Glow21 · registro de asistentes + password de Zoom (Supabase, plan Free)
-- Pega y ejecuta esto en: Supabase Dashboard → SQL Editor → New query → Run
-- (requiere que ya hayas corrido supabase-setup.sql antes)

create extension if not exists pgcrypto;

-- Password de la reunión de Zoom, junto a los demás datos de la sesión.
alter table public.glow21_settings
  add column if not exists zoom_password text not null default '';

-- Datos de quienes se registran para entrar a la sesión en vivo.
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
create policy "glow21_profiles_public_insert"
  on public.glow21_profiles
  for insert
  with check (true);

-- ...pero nadie puede leer la lista con la publishable key: son datos de
-- contacto (correo, teléfono, dirección). Si más adelante quieres verlos
-- desde un panel propio, hazlo con la service_role key desde un backend,
-- nunca agregando una policy de SELECT pública aquí.
