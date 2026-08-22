-- Glow21 · Corrige las políticas de INSERT público
-- Pega esto en: Supabase Dashboard → SQL Editor → New query → Run
--
-- Diagnóstico: los inserts públicos (registro a la masterclass y registro
-- de envío para Acceso Premium) estaban siendo rechazados con el error
-- "new row violates row-level security policy" — las políticas de INSERT
-- para visitantes anónimos no existían (o se perdieron) en la base de
-- datos en vivo, aunque sí estaban en supabase-setup-completo.sql. Esto
-- vuelve a crearlas explícitamente.

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
