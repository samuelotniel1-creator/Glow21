-- Agrega la frase final "Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21." al cierre de cada pieza (y al caption, salvo historias).
-- Solo añade texto al final: no pisa lo demás que hayas editado. Se puede correr más de una vez sin duplicar.

update public.glow21_contenido set data = jsonb_set(jsonb_set(data, '{partes,-1,2}', to_jsonb((data->'partes'->-1->>2) || ' Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')), '{partes,-1,1}', to_jsonb('32–46 s · Cierre'::text)) where dia = 1 and not ((data->'partes'->-1->>2) like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{cap}', to_jsonb((data->>'cap') || E'
Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 1 and not ((data->>'cap') like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{partes,-1,2}', to_jsonb((data->'partes'->-1->>2) || ' Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 2 and not ((data->'partes'->-1->>2) like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{cap}', to_jsonb((data->>'cap') || E'
Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 2 and not ((data->>'cap') like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(jsonb_set(data, '{partes,-1,2}', to_jsonb((data->'partes'->-1->>2) || ' Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')), '{partes,-1,1}', to_jsonb('35–45 s · Cierre'::text)) where dia = 3 and not ((data->'partes'->-1->>2) like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{cap}', to_jsonb((data->>'cap') || E'
Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 3 and not ((data->>'cap') like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(jsonb_set(data, '{partes,-1,2}', to_jsonb((data->'partes'->-1->>2) || ' Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')), '{partes,-1,1}', to_jsonb('39–47 s · Cierre'::text)) where dia = 4 and not ((data->'partes'->-1->>2) like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{cap}', to_jsonb((data->>'cap') || E'
Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 4 and not ((data->>'cap') like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{partes,-1,2}', to_jsonb((data->'partes'->-1->>2) || ' Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 5 and not ((data->'partes'->-1->>2) like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{cap}', to_jsonb((data->>'cap') || E'
Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 5 and not ((data->>'cap') like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(jsonb_set(data, '{partes,-1,2}', to_jsonb((data->'partes'->-1->>2) || ' Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')), '{partes,-1,1}', to_jsonb('37–48 s · Cierre'::text)) where dia = 6 and not ((data->'partes'->-1->>2) like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{cap}', to_jsonb((data->>'cap') || E'
Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 6 and not ((data->>'cap') like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(jsonb_set(data, '{partes,-1,2}', to_jsonb((data->'partes'->-1->>2) || ' Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')), '{partes,-1,1}', to_jsonb('33–41 s · Cierre'::text)) where dia = 7 and not ((data->'partes'->-1->>2) like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{cap}', to_jsonb((data->>'cap') || E'
Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 7 and not ((data->>'cap') like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{partes,-1,2}', to_jsonb((data->'partes'->-1->>2) || ' Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 8 and not ((data->'partes'->-1->>2) like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{cap}', to_jsonb((data->>'cap') || E'
Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 8 and not ((data->>'cap') like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(jsonb_set(data, '{partes,-1,2}', to_jsonb((data->'partes'->-1->>2) || ' Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')), '{partes,-1,1}', to_jsonb('35–47 s · Cierre'::text)) where dia = 9 and not ((data->'partes'->-1->>2) like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{cap}', to_jsonb((data->>'cap') || E'
Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 9 and not ((data->>'cap') like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(jsonb_set(data, '{partes,-1,2}', to_jsonb((data->'partes'->-1->>2) || ' Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')), '{partes,-1,1}', to_jsonb('35–47 s · Cierre'::text)) where dia = 10 and not ((data->'partes'->-1->>2) like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{cap}', to_jsonb((data->>'cap') || E'
Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 10 and not ((data->>'cap') like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{partes,-1,2}', to_jsonb((data->'partes'->-1->>2) || ' Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 11 and not ((data->'partes'->-1->>2) like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{cap}', to_jsonb((data->>'cap') || E'
Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 11 and not ((data->>'cap') like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(jsonb_set(data, '{partes,-1,2}', to_jsonb((data->'partes'->-1->>2) || ' Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')), '{partes,-1,1}', to_jsonb('34–44 s · Cierre'::text)) where dia = 12 and not ((data->'partes'->-1->>2) like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{cap}', to_jsonb((data->>'cap') || E'
Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 12 and not ((data->>'cap') like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{partes,-1,2}', to_jsonb((data->'partes'->-1->>2) || ' Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 13 and not ((data->'partes'->-1->>2) like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(jsonb_set(data, '{partes,-1,2}', to_jsonb((data->'partes'->-1->>2) || ' Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')), '{partes,-1,1}', to_jsonb('32–41 s · Cierre'::text)) where dia = 14 and not ((data->'partes'->-1->>2) like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{cap}', to_jsonb((data->>'cap') || E'
Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 14 and not ((data->>'cap') like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(jsonb_set(data, '{partes,-1,2}', to_jsonb((data->'partes'->-1->>2) || ' Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')), '{partes,-1,1}', to_jsonb('34–45 s · Cierre'::text)) where dia = 15 and not ((data->'partes'->-1->>2) like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{cap}', to_jsonb((data->>'cap') || E'
Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 15 and not ((data->>'cap') like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{partes,-1,2}', to_jsonb((data->'partes'->-1->>2) || ' Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 16 and not ((data->'partes'->-1->>2) like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{cap}', to_jsonb((data->>'cap') || E'
Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 16 and not ((data->>'cap') like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(jsonb_set(data, '{partes,-1,2}', to_jsonb((data->'partes'->-1->>2) || ' Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')), '{partes,-1,1}', to_jsonb('42–50 s · Cierre'::text)) where dia = 17 and not ((data->'partes'->-1->>2) like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{cap}', to_jsonb((data->>'cap') || E'
Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 17 and not ((data->>'cap') like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(jsonb_set(data, '{partes,-1,2}', to_jsonb((data->'partes'->-1->>2) || ' Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')), '{partes,-1,1}', to_jsonb('34–42 s · Cierre'::text)) where dia = 18 and not ((data->'partes'->-1->>2) like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{cap}', to_jsonb((data->>'cap') || E'
Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 18 and not ((data->>'cap') like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{partes,-1,2}', to_jsonb((data->'partes'->-1->>2) || ' Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 19 and not ((data->'partes'->-1->>2) like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{cap}', to_jsonb((data->>'cap') || E'
Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 19 and not ((data->>'cap') like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(jsonb_set(data, '{partes,-1,2}', to_jsonb((data->'partes'->-1->>2) || ' Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')), '{partes,-1,1}', to_jsonb('27–38 s · Cierre'::text)) where dia = 20 and not ((data->'partes'->-1->>2) like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{cap}', to_jsonb((data->>'cap') || E'
Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 20 and not ((data->>'cap') like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{partes,-1,2}', to_jsonb((data->'partes'->-1->>2) || ' Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 21 and not ((data->'partes'->-1->>2) like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{cap}', to_jsonb((data->>'cap') || E'
Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 21 and not ((data->>'cap') like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(jsonb_set(data, '{partes,-1,2}', to_jsonb((data->'partes'->-1->>2) || ' Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')), '{partes,-1,1}', to_jsonb('29–39 s · Cierre'::text)) where dia = 22 and not ((data->'partes'->-1->>2) like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{cap}', to_jsonb((data->>'cap') || E'
Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 22 and not ((data->>'cap') like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{partes,-1,2}', to_jsonb((data->'partes'->-1->>2) || ' Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 23 and not ((data->'partes'->-1->>2) like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{cap}', to_jsonb((data->>'cap') || E'
Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 23 and not ((data->>'cap') like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{partes,-1,2}', to_jsonb((data->'partes'->-1->>2) || ' Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 24 and not ((data->'partes'->-1->>2) like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(jsonb_set(data, '{partes,-1,2}', to_jsonb((data->'partes'->-1->>2) || ' Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')), '{partes,-1,1}', to_jsonb('33–42 s · Cierre'::text)) where dia = 25 and not ((data->'partes'->-1->>2) like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{cap}', to_jsonb((data->>'cap') || E'
Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 25 and not ((data->>'cap') like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(jsonb_set(data, '{partes,-1,2}', to_jsonb((data->'partes'->-1->>2) || ' Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')), '{partes,-1,1}', to_jsonb('26–35 s · Cierre'::text)) where dia = 26 and not ((data->'partes'->-1->>2) like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{cap}', to_jsonb((data->>'cap') || E'
Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 26 and not ((data->>'cap') like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{partes,-1,2}', to_jsonb((data->'partes'->-1->>2) || ' Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 27 and not ((data->'partes'->-1->>2) like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{cap}', to_jsonb((data->>'cap') || E'
Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 27 and not ((data->>'cap') like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(jsonb_set(data, '{partes,-1,2}', to_jsonb((data->'partes'->-1->>2) || ' Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')), '{partes,-1,1}', to_jsonb('31–39 s · Cierre'::text)) where dia = 28 and not ((data->'partes'->-1->>2) like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{cap}', to_jsonb((data->>'cap') || E'
Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 28 and not ((data->>'cap') like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(jsonb_set(data, '{partes,-1,2}', to_jsonb((data->'partes'->-1->>2) || ' Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')), '{partes,-1,1}', to_jsonb('30–39 s · Cierre'::text)) where dia = 29 and not ((data->'partes'->-1->>2) like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{cap}', to_jsonb((data->>'cap') || E'
Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 29 and not ((data->>'cap') like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{partes,-1,2}', to_jsonb((data->'partes'->-1->>2) || ' Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 30 and not ((data->'partes'->-1->>2) like '%todas somos Glow21%');
update public.glow21_contenido set data = jsonb_set(data, '{cap}', to_jsonb((data->>'cap') || E'
Tu piel habla. Aquí aprendemos a escucharla, porque todas somos Glow21.')) where dia = 30 and not ((data->>'cap') like '%todas somos Glow21%');
