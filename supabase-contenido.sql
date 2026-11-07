-- Tabla del banco de contenido (/contenido).
-- Pégalo completo en Supabase → SQL Editor y ejecútalo una sola vez.
-- Es seguro volver a correrlo: usa "if not exists" y "drop policy if exists".
--
-- Solo los usuarios con sesión iniciada (los mismos de /admin y /crm) pueden
-- leer y escribir. El público no ve esta tabla. Como en las demás tablas, no
-- basta con la política de RLS: hay que dar también el "grant" al rol.

create table if not exists public.glow21_contenido (
  id uuid primary key default gen_random_uuid(),
  dia integer,                               -- número de día (opcional, define el orden)
  etapa text not null default 'guion',       -- idea | guion | produccion | listo | publicado
  tipo text not null default 'A',            -- A | B | C
  data jsonb not null default '{}'::jsonb,   -- título, gancho, escenas, caption, cta, hashtags...
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create or replace function public.glow21_contenido_touch()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists glow21_contenido_touch on public.glow21_contenido;
create trigger glow21_contenido_touch
  before update on public.glow21_contenido
  for each row execute function public.glow21_contenido_touch();

alter table public.glow21_contenido enable row level security;

grant select, insert, update, delete on public.glow21_contenido to authenticated;

drop policy if exists "glow21_contenido_authenticated_all" on public.glow21_contenido;
create policy "glow21_contenido_authenticated_all"
  on public.glow21_contenido
  for all
  to authenticated
  using (true)
  with check (true);
