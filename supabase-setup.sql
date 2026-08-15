-- Glow21 · configuración compartida de la landing (Supabase, plan Free, sin Realtime)
-- Pega y ejecuta esto en: Supabase Dashboard → SQL Editor → New query → Run

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

-- La landing pública (anon/publishable key) necesita leer la config.
create policy "glow21_settings_public_read"
  on public.glow21_settings
  for select
  using (true);

-- El panel admin también usa la publishable key (no tiene login todavía),
-- así que necesita poder actualizar la fila. Si más adelante agregas
-- autenticación a /admin, cambia el "using (true)" de abajo por
-- "using (auth.uid() is not null)" para exigir sesión antes de escribir.
create policy "glow21_settings_public_update"
  on public.glow21_settings
  for update
  using (true)
  with check (true);
