-- Glow21 · datos de envío para el Acceso Premium (producto físico)
-- Pega y ejecuta esto en: Supabase Dashboard → SQL Editor → New query → Run
--
-- Formulario aparte del registro de la masterclass (glow21_profiles): este
-- se llena solo cuando alguien da clic en "Acceso Premium 3 meses", porque
-- esa oferta incluye un producto físico y necesita dirección de envío.

create table if not exists public.glow21_premium_leads (
  id uuid primary key default gen_random_uuid(),
  nombre text not null,
  correo text not null,
  telefono text not null,
  direccion text not null,
  created_at timestamptz not null default now()
);

alter table public.glow21_premium_leads enable row level security;

-- Cualquier visitante (publishable key) puede registrarse...
drop policy if exists "glow21_premium_leads_public_insert" on public.glow21_premium_leads;
create policy "glow21_premium_leads_public_insert"
  on public.glow21_premium_leads
  for insert
  with check (true);

-- ...pero nadie puede leer la lista con la publishable key: son datos de
-- contacto y envío. Si más adelante quieres verlos desde un panel propio o
-- conectarlos a un CRM, hazlo con la service_role key desde un backend,
-- nunca agregando una policy de SELECT pública aquí.
