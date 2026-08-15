-- Glow21 · fecha/hora real de la sesión, para el temporizador (Supabase, plan Free)
-- Pega y ejecuta esto en: Supabase Dashboard → SQL Editor → New query → Run
-- Independiente de los SQL anteriores.

alter table public.glow21_settings
  add column if not exists session_datetime timestamptz;

-- Nota: la columna vieja "session_date" (texto libre) ya no se usa desde el
-- admin ni la landing. La dejamos tal cual por si quieres conservarla; puedes
-- borrarla tú mismo más adelante con:
--   alter table public.glow21_settings drop column session_date;
