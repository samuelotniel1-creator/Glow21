-- Glow21 · el registro ya no pide dirección (solo nombre, correo, teléfono)
-- Pega y ejecuta esto en: Supabase Dashboard → SQL Editor → New query → Run

alter table public.glow21_profiles
  drop column if exists direccion;
