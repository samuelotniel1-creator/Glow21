-- Glow21 · Corrige las políticas de SELECT/UPDATE para el CRM
-- Pega esto en: Supabase Dashboard → SQL Editor → New query → Run
--
-- Diagnóstico: el CRM (logueado con Supabase Auth) mostraba "Nada por
-- aquí todavía" aunque los registros sí se estaban guardando. La consulta
-- de pg_policies mostró que en glow21_profiles y glow21_premium_leads solo
-- existía la política de INSERT — las de SELECT/UPDATE para usuarios
-- autenticados (las que necesita el CRM para leer y marcar "contactado")
-- también se perdieron, igual que pasó con la de INSERT. Sin una política
-- de SELECT, RLS niega la lectura a cualquiera, incluso ya logueado.

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
