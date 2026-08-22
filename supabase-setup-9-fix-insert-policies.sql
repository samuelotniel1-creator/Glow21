-- Glow21 · Corrige las políticas de INSERT público
-- Pega esto en: Supabase Dashboard → SQL Editor → New query → Run
--
-- Diagnóstico: los inserts públicos (registro a la masterclass y registro
-- de envío para Acceso Premium) estaban siendo rechazados con el error
-- "new row violates row-level security policy". Recrear solo la política
-- (primera versión de este archivo) no fue suficiente y el error siguió
-- igual — eso apunta a que además falta el permiso base de INSERT sobre
-- la tabla para los roles anon/authenticated (la política de RLS decide
-- QUÉ filas se pueden insertar, pero el rol también necesita el permiso
-- de tabla subyacente; sin ese GRANT, Postgres rechaza el insert antes
-- de siquiera evaluar la política). Este script agrega ambos.

grant insert on public.glow21_profiles to anon, authenticated;
grant insert on public.glow21_premium_leads to anon, authenticated;

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
