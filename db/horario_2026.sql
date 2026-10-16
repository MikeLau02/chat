-- Generado por scripts/horario.js a partir de horario_2026.csv. No editar a mano:
-- corregir el CSV y volver a generar. Se puede ejecutar varias veces.
USE chatbot_vm;
SET NAMES utf8mb4;
START TRANSACTION;

DELETE FROM horarios;
DELETE FROM franjas_horarias;

INSERT INTO grupos (nivel_id, nombre, alias, orden) VALUES
  (1, 'Jardín', 'jardin', 1),
  (1, 'Transición', 'transicion', 2),
  (2, '1A', '1°a|1-a|primero a|primero|1°', 4),
  (2, '2A', '2°a|2-a|segundo a|segundo|2°', 6),
  (2, '3A', '3°a|3-a|tercero a|tercero|3°', 8),
  (2, '4A', '4°a|4-a|cuarto a|cuarto|4°', 10),
  (2, '5A', '5°a|5-a|quinto a|quinto|5°', 12),
  (3, '6A', '6°a|6-a|sexto a|sexto|6°', 14),
  (3, '7A', '7°a|7-a|septimo a|septimo|7°', 16),
  (3, '8A', '8°a|8-a|octavo a', 18),
  (3, '8B', '8°b|8-b|octavo b', 19),
  (3, '9A', '9°a|9-a|noveno a|noveno|9°', 20),
  (4, '10A', '10°a|10-a|decimo a|decimo|10°', 22),
  (4, '11A', '11°a|11-a|once a|undecimo a', 24),
  (4, '11B', '11°b|11-b|once b|undecimo b', 25)
ON DUPLICATE KEY UPDATE nivel_id = VALUES(nivel_id), alias = VALUES(alias), orden = VALUES(orden), activo = 1;
UPDATE grupos SET activo = 0 WHERE nombre NOT IN ('Jardín', 'Transición', '1A', '2A', '3A', '4A', '5A', '6A', '7A', '8A', '8B', '9A', '10A', '11A', '11B');

INSERT INTO asignaturas (codigo_excel, nombre) VALUES
  ('C_NAT', 'Ciencias Naturales'),
  ('ESTADIST', 'Estadística'),
  ('C_SOC', 'Ciencias Sociales'),
  ('L_CAST', 'Lengua Castellana'),
  ('FISICA', 'Física'),
  ('MATEM', 'Matemáticas'),
  ('TEC_INFO', 'Tecnología e Informática'),
  ('FILOSOFIA', 'Filosofía'),
  ('QUIM', 'Química'),
  ('GEOMET', 'Geometría'),
  ('ETICA', 'Ética y Valores'),
  ('INGLES', 'Inglés'),
  ('C_POLITICA', 'Ciencias Políticas'),
  ('RELIG', 'Educación Religiosa'),
  ('ORIE', 'Orientación de grupo'),
  ('ARTIST', 'Educación Artística'),
  ('ED_FISICA', 'Educación Física'),
  ('EMPREND', 'Emprendimiento'),
  ('D_COM', 'Dimensión Comunicativa'),
  ('D_ETICA', 'Dimensión Ética'),
  ('D_COG', 'Dimensión Cognitiva'),
  ('VAR_ac9a1d53', 'Lengua Castellana / Inglés / Matemáticas'),
  ('VAR_0ed3eb2b', 'Lengua Castellana / Matemáticas'),
  ('VAR_048498ea', 'Lengua Castellana / Inglés'),
  ('VAR_518787a8', 'Orientación de grupo / Dimensión Comunicativa'),
  ('VAR_c93088e8', 'Dimensión Estética / Dimensión Cognitiva / Dimensión Comunicativa / Tecnología e Informática'),
  ('VAR_cb6780c7', 'Inglés / Matemáticas / Lengua Castellana / Ciencias Naturales / Ciencias Sociales'),
  ('VAR_cf491399', 'Inglés / Tecnología e Informática / Dimensión Comunicativa'),
  ('VAR_a8c8e9de', 'Educación Religiosa / Ética y Valores / Matemáticas / Lengua Castellana'),
  ('VAR_7f9f3c20', 'Inglés / Matemáticas'),
  ('VAR_660c15b8', 'Ética y Valores / Matemáticas / Ciencias Sociales'),
  ('VAR_e8c68cf9', 'Matemáticas / Ciencias Sociales / Ciencias Naturales'),
  ('VAR_d6071385', 'Orientación de grupo / Dimensión Estética / Dimensión Cognitiva'),
  ('VAR_00e1b018', 'Dimensión Comunicativa / Dimensión Estética / Dimensión Cognitiva'),
  ('VAR_b231106e', 'Ciencias Sociales / Ciencias Naturales'),
  ('VAR_ea677e30', 'Lengua Castellana / Ciencias Naturales')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), activo = 1;

-- Docentes que no aparecen en este horario quedan inactivos (ya no hacen parte del plantel).
INSERT INTO docentes (codigo_excel, nombre_mostrar) VALUES
  ('ALEJANDRO BABILONIA', 'Prof. Alejandro Babilonia'),
  ('ANA GOMEZ', 'Prof. Ana Gómez'),
  ('ARNOLD PEREZ', 'Prof. Arnold Pérez'),
  ('AURA CARABALLO', 'Prof. Aura Caraballo'),
  ('DILSON MAZA', 'Prof. Dilson Maza'),
  ('GISELLA CARTAGENA', 'Prof. Gisella Cartagena'),
  ('JEILE BERRIDO', 'Prof. Jeile Berrido'),
  ('JESUS ESQUIVEL', 'Prof. Jesús Esquivel'),
  ('JOSE HOYOS', 'Prof. José Hoyos'),
  ('KENIA CASTILLO', 'Prof. Kenia Castillo'),
  ('LAURA GONZALEZ', 'Prof. Laura González'),
  ('LIBIA PERNETT', 'Prof. Libia Pernett'),
  ('MANUEL WARNES', 'Prof. Manuel Warnes'),
  ('MARIA ALEJANDRA', 'Prof. María Alejandra'),
  ('MARIA CLAUDIA', 'Prof. María Claudia'),
  ('MAURICIO CUADRADO', 'Prof. Mauricio Cuadrado'),
  ('PETRONA ALTAMIRANDA', 'Prof. Petrona Altamiranda'),
  ('SHIRLEY PEDROZA', 'Prof. Shirley Pedroza'),
  ('WENDY PERTUZ', 'Prof. Wendy Pertuz')
ON DUPLICATE KEY UPDATE nombre_mostrar = VALUES(nombre_mostrar), activo = 1;
UPDATE docentes SET activo = 0 WHERE codigo_excel NOT IN ('ALEJANDRO BABILONIA', 'ANA GOMEZ', 'ARNOLD PEREZ', 'AURA CARABALLO', 'DILSON MAZA', 'GISELLA CARTAGENA', 'JEILE BERRIDO', 'JESUS ESQUIVEL', 'JOSE HOYOS', 'KENIA CASTILLO', 'LAURA GONZALEZ', 'LIBIA PERNETT', 'MANUEL WARNES', 'MARIA ALEJANDRA', 'MARIA CLAUDIA', 'MAURICIO CUADRADO', 'PETRONA ALTAMIRANDA', 'SHIRLEY PEDROZA', 'WENDY PERTUZ');

INSERT INTO franjas_horarias (nivel_id, numero, hora_inicio, hora_fin, es_descanso) VALUES
  (4, 1, '06:45', '07:35', 0),
  (4, 2, '07:35', '08:25', 0),
  (4, 3, '08:25', '09:05', 0),
  (4, 4, '09:05', '09:35', 1),
  (4, 5, '09:35', '10:30', 0),
  (4, 6, '10:30', '11:20', 0),
  (4, 7, '11:20', '12:00', 0),
  (4, 8, '12:00', '12:15', 1),
  (4, 9, '12:15', '13:00', 0),
  (4, 10, '13:00', '13:45', 0),
  (2, 1, '06:45', '07:35', 0),
  (2, 2, '07:35', '08:25', 0),
  (2, 3, '08:25', '09:05', 1),
  (2, 4, '09:05', '10:00', 0),
  (2, 5, '10:00', '11:00', 0),
  (2, 6, '11:00', '11:20', 1),
  (2, 7, '11:20', '12:10', 0),
  (2, 8, '12:10', '13:00', 0),
  (3, 1, '06:45', '07:35', 0),
  (3, 2, '07:35', '08:25', 0),
  (3, 3, '08:25', '09:05', 0),
  (3, 4, '09:05', '09:35', 1),
  (3, 5, '09:35', '10:30', 0),
  (3, 6, '10:30', '11:20', 0),
  (3, 7, '11:20', '11:40', 1),
  (3, 8, '11:40', '12:40', 0),
  (3, 9, '12:40', '13:45', 0),
  (1, 1, '07:00', '08:00', 0),
  (1, 2, '08:00', '08:40', 0),
  (1, 3, '08:40', '09:00', 1),
  (1, 4, '09:00', '10:00', 0),
  (1, 5, '10:00', '10:45', 0),
  (1, 6, '10:45', '11:10', 1),
  (1, 7, '11:10', '12:00', 0);

INSERT INTO horarios (grupo_id, dia_semana, franja_id, asignatura_id, docente_id)
SELECT g.id, v.dia, f.id, a.id, d.id FROM (
  SELECT '10A' AS grupo, 1 AS dia, '07:35' AS ini, '08:25' AS fin, 'C_NAT' AS asig, 'SHIRLEY PEDROZA' AS doc
  UNION ALL SELECT '10A' AS grupo, 1 AS dia, '08:25' AS ini, '09:05' AS fin, 'ESTADIST' AS asig, 'MANUEL WARNES' AS doc
  UNION ALL SELECT '10A' AS grupo, 1 AS dia, '09:35' AS ini, '10:30' AS fin, 'C_SOC' AS asig, 'ARNOLD PEREZ' AS doc
  UNION ALL SELECT '10A' AS grupo, 1 AS dia, '10:30' AS ini, '11:20' AS fin, 'C_SOC' AS asig, 'ARNOLD PEREZ' AS doc
  UNION ALL SELECT '10A' AS grupo, 1 AS dia, '11:20' AS ini, '12:00' AS fin, 'L_CAST' AS asig, 'ANA GOMEZ' AS doc
  UNION ALL SELECT '10A' AS grupo, 1 AS dia, '13:00' AS ini, '13:45' AS fin, 'FISICA' AS asig, 'MAURICIO CUADRADO' AS doc
  UNION ALL SELECT '10A' AS grupo, 2 AS dia, '07:35' AS ini, '08:25' AS fin, 'MATEM' AS asig, 'MANUEL WARNES' AS doc
  UNION ALL SELECT '10A' AS grupo, 2 AS dia, '08:25' AS ini, '09:05' AS fin, 'L_CAST' AS asig, 'ANA GOMEZ' AS doc
  UNION ALL SELECT '10A' AS grupo, 2 AS dia, '09:35' AS ini, '10:30' AS fin, 'TEC_INFO' AS asig, 'LAURA GONZALEZ' AS doc
  UNION ALL SELECT '10A' AS grupo, 2 AS dia, '10:30' AS ini, '11:20' AS fin, 'TEC_INFO' AS asig, 'LAURA GONZALEZ' AS doc
  UNION ALL SELECT '10A' AS grupo, 3 AS dia, '06:45' AS ini, '07:35' AS fin, 'TEC_INFO' AS asig, 'LAURA GONZALEZ' AS doc
  UNION ALL SELECT '10A' AS grupo, 3 AS dia, '07:35' AS ini, '08:25' AS fin, 'TEC_INFO' AS asig, 'LAURA GONZALEZ' AS doc
  UNION ALL SELECT '10A' AS grupo, 3 AS dia, '08:25' AS ini, '09:05' AS fin, 'C_NAT' AS asig, 'SHIRLEY PEDROZA' AS doc
  UNION ALL SELECT '10A' AS grupo, 3 AS dia, '10:30' AS ini, '11:20' AS fin, 'FILOSOFIA' AS asig, 'ARNOLD PEREZ' AS doc
  UNION ALL SELECT '10A' AS grupo, 3 AS dia, '11:20' AS ini, '12:00' AS fin, 'FILOSOFIA' AS asig, 'ARNOLD PEREZ' AS doc
  UNION ALL SELECT '10A' AS grupo, 3 AS dia, '12:15' AS ini, '13:00' AS fin, 'QUIM' AS asig, 'JESUS ESQUIVEL' AS doc
  UNION ALL SELECT '10A' AS grupo, 3 AS dia, '13:00' AS ini, '13:45' AS fin, 'QUIM' AS asig, 'JESUS ESQUIVEL' AS doc
  UNION ALL SELECT '10A' AS grupo, 4 AS dia, '06:45' AS ini, '07:35' AS fin, 'L_CAST' AS asig, 'ANA GOMEZ' AS doc
  UNION ALL SELECT '10A' AS grupo, 4 AS dia, '07:35' AS ini, '08:25' AS fin, 'L_CAST' AS asig, 'ANA GOMEZ' AS doc
  UNION ALL SELECT '10A' AS grupo, 4 AS dia, '08:25' AS ini, '09:05' AS fin, 'GEOMET' AS asig, 'MANUEL WARNES' AS doc
  UNION ALL SELECT '10A' AS grupo, 4 AS dia, '09:35' AS ini, '10:30' AS fin, 'ETICA' AS asig, 'JEILE BERRIDO' AS doc
  UNION ALL SELECT '10A' AS grupo, 4 AS dia, '10:30' AS ini, '11:20' AS fin, 'QUIM' AS asig, 'JESUS ESQUIVEL' AS doc
  UNION ALL SELECT '10A' AS grupo, 4 AS dia, '11:20' AS ini, '12:00' AS fin, 'QUIM' AS asig, 'JESUS ESQUIVEL' AS doc
  UNION ALL SELECT '10A' AS grupo, 4 AS dia, '12:15' AS ini, '13:00' AS fin, 'INGLES' AS asig, 'ALEJANDRO BABILONIA' AS doc
  UNION ALL SELECT '10A' AS grupo, 4 AS dia, '13:00' AS ini, '13:45' AS fin, 'INGLES' AS asig, 'ALEJANDRO BABILONIA' AS doc
  UNION ALL SELECT '10A' AS grupo, 5 AS dia, '06:45' AS ini, '07:35' AS fin, 'C_POLITICA' AS asig, 'ARNOLD PEREZ' AS doc
  UNION ALL SELECT '10A' AS grupo, 5 AS dia, '07:35' AS ini, '08:25' AS fin, 'C_POLITICA' AS asig, 'ARNOLD PEREZ' AS doc
  UNION ALL SELECT '10A' AS grupo, 5 AS dia, '08:25' AS ini, '09:05' AS fin, 'INGLES' AS asig, 'ALEJANDRO BABILONIA' AS doc
  UNION ALL SELECT '10A' AS grupo, 5 AS dia, '09:35' AS ini, '10:30' AS fin, 'INGLES' AS asig, 'ALEJANDRO BABILONIA' AS doc
  UNION ALL SELECT '10A' AS grupo, 5 AS dia, '13:00' AS ini, '13:45' AS fin, 'RELIG' AS asig, 'KENIA CASTILLO' AS doc
  UNION ALL SELECT '11A' AS grupo, 1 AS dia, '07:35' AS ini, '08:25' AS fin, 'C_POLITICA' AS asig, 'ARNOLD PEREZ' AS doc
  UNION ALL SELECT '11A' AS grupo, 1 AS dia, '08:25' AS ini, '09:05' AS fin, 'ETICA' AS asig, 'JEILE BERRIDO' AS doc
  UNION ALL SELECT '11A' AS grupo, 1 AS dia, '10:30' AS ini, '11:20' AS fin, 'QUIM' AS asig, 'JESUS ESQUIVEL' AS doc
  UNION ALL SELECT '11A' AS grupo, 1 AS dia, '12:15' AS ini, '13:00' AS fin, 'L_CAST' AS asig, 'ANA GOMEZ' AS doc
  UNION ALL SELECT '11A' AS grupo, 2 AS dia, '06:45' AS ini, '07:35' AS fin, 'L_CAST' AS asig, 'ANA GOMEZ' AS doc
  UNION ALL SELECT '11A' AS grupo, 2 AS dia, '07:35' AS ini, '08:25' AS fin, 'L_CAST' AS asig, 'ANA GOMEZ' AS doc
  UNION ALL SELECT '11A' AS grupo, 2 AS dia, '08:25' AS ini, '09:05' AS fin, 'INGLES' AS asig, 'ALEJANDRO BABILONIA' AS doc
  UNION ALL SELECT '11A' AS grupo, 2 AS dia, '11:20' AS ini, '12:00' AS fin, 'ESTADIST' AS asig, 'MAURICIO CUADRADO' AS doc
  UNION ALL SELECT '11A' AS grupo, 2 AS dia, '12:15' AS ini, '13:00' AS fin, 'QUIM' AS asig, 'JESUS ESQUIVEL' AS doc
  UNION ALL SELECT '11A' AS grupo, 2 AS dia, '13:00' AS ini, '13:45' AS fin, 'QUIM' AS asig, 'JESUS ESQUIVEL' AS doc
  UNION ALL SELECT '11A' AS grupo, 3 AS dia, '06:45' AS ini, '07:35' AS fin, 'FILOSOFIA' AS asig, 'ARNOLD PEREZ' AS doc
  UNION ALL SELECT '11A' AS grupo, 3 AS dia, '07:35' AS ini, '08:25' AS fin, 'FILOSOFIA' AS asig, 'ARNOLD PEREZ' AS doc
  UNION ALL SELECT '11A' AS grupo, 3 AS dia, '08:25' AS ini, '09:05' AS fin, 'TEC_INFO' AS asig, 'LAURA GONZALEZ' AS doc
  UNION ALL SELECT '11A' AS grupo, 3 AS dia, '09:35' AS ini, '10:30' AS fin, 'TEC_INFO' AS asig, 'LAURA GONZALEZ' AS doc
  UNION ALL SELECT '11A' AS grupo, 3 AS dia, '11:20' AS ini, '12:00' AS fin, 'GEOMET' AS asig, 'MAURICIO CUADRADO' AS doc
  UNION ALL SELECT '11A' AS grupo, 3 AS dia, '12:15' AS ini, '13:00' AS fin, 'C_SOC' AS asig, 'ARNOLD PEREZ' AS doc
  UNION ALL SELECT '11A' AS grupo, 3 AS dia, '13:00' AS ini, '13:45' AS fin, 'C_POLITICA' AS asig, 'ARNOLD PEREZ' AS doc
  UNION ALL SELECT '11A' AS grupo, 4 AS dia, '06:45' AS ini, '07:35' AS fin, 'RELIG' AS asig, 'PETRONA ALTAMIRANDA' AS doc
  UNION ALL SELECT '11A' AS grupo, 4 AS dia, '07:35' AS ini, '08:25' AS fin, 'INGLES' AS asig, 'ALEJANDRO BABILONIA' AS doc
  UNION ALL SELECT '11A' AS grupo, 4 AS dia, '08:25' AS ini, '09:05' AS fin, 'INGLES' AS asig, 'ALEJANDRO BABILONIA' AS doc
  UNION ALL SELECT '11A' AS grupo, 4 AS dia, '09:35' AS ini, '10:30' AS fin, 'FISICA' AS asig, 'MAURICIO CUADRADO' AS doc
  UNION ALL SELECT '11A' AS grupo, 4 AS dia, '11:20' AS ini, '12:00' AS fin, 'C_SOC' AS asig, 'ARNOLD PEREZ' AS doc
  UNION ALL SELECT '11A' AS grupo, 5 AS dia, '06:45' AS ini, '07:35' AS fin, 'QUIM' AS asig, 'JESUS ESQUIVEL' AS doc
  UNION ALL SELECT '11A' AS grupo, 5 AS dia, '07:35' AS ini, '08:25' AS fin, 'INGLES' AS asig, 'ALEJANDRO BABILONIA' AS doc
  UNION ALL SELECT '11A' AS grupo, 5 AS dia, '08:25' AS ini, '09:05' AS fin, 'FISICA' AS asig, 'MAURICIO CUADRADO' AS doc
  UNION ALL SELECT '11A' AS grupo, 5 AS dia, '09:35' AS ini, '10:30' AS fin, 'FISICA' AS asig, 'MAURICIO CUADRADO' AS doc
  UNION ALL SELECT '11A' AS grupo, 5 AS dia, '11:20' AS ini, '12:00' AS fin, 'TEC_INFO' AS asig, 'LAURA GONZALEZ' AS doc
  UNION ALL SELECT '11B' AS grupo, 1 AS dia, '06:45' AS ini, '07:35' AS fin, 'ORIE' AS asig, 'MANUEL WARNES' AS doc
  UNION ALL SELECT '11B' AS grupo, 1 AS dia, '07:35' AS ini, '08:25' AS fin, 'L_CAST' AS asig, 'ANA GOMEZ' AS doc
  UNION ALL SELECT '11B' AS grupo, 1 AS dia, '08:25' AS ini, '09:05' AS fin, 'L_CAST' AS asig, 'ANA GOMEZ' AS doc
  UNION ALL SELECT '11B' AS grupo, 1 AS dia, '09:35' AS ini, '10:30' AS fin, 'ESTADIST' AS asig, 'MAURICIO CUADRADO' AS doc
  UNION ALL SELECT '11B' AS grupo, 1 AS dia, '10:30' AS ini, '11:20' AS fin, 'FISICA' AS asig, 'MAURICIO CUADRADO' AS doc
  UNION ALL SELECT '11B' AS grupo, 1 AS dia, '11:20' AS ini, '12:00' AS fin, 'FISICA' AS asig, 'MAURICIO CUADRADO' AS doc
  UNION ALL SELECT '11B' AS grupo, 1 AS dia, '12:15' AS ini, '13:00' AS fin, 'C_SOC' AS asig, 'ARNOLD PEREZ' AS doc
  UNION ALL SELECT '11B' AS grupo, 1 AS dia, '13:00' AS ini, '13:45' AS fin, 'C_SOC' AS asig, 'ARNOLD PEREZ' AS doc
  UNION ALL SELECT '11B' AS grupo, 2 AS dia, '06:45' AS ini, '07:35' AS fin, 'INGLES' AS asig, 'ALEJANDRO BABILONIA' AS doc
  UNION ALL SELECT '11B' AS grupo, 2 AS dia, '07:35' AS ini, '08:25' AS fin, 'INGLES' AS asig, 'ALEJANDRO BABILONIA' AS doc
  UNION ALL SELECT '11B' AS grupo, 2 AS dia, '08:25' AS ini, '09:05' AS fin, 'ETICA' AS asig, 'JEILE BERRIDO' AS doc
  UNION ALL SELECT '11B' AS grupo, 2 AS dia, '09:35' AS ini, '10:30' AS fin, 'FISICA' AS asig, 'MAURICIO CUADRADO' AS doc
  UNION ALL SELECT '11B' AS grupo, 2 AS dia, '10:30' AS ini, '11:20' AS fin, 'FISICA' AS asig, 'MAURICIO CUADRADO' AS doc
  UNION ALL SELECT '11B' AS grupo, 3 AS dia, '06:45' AS ini, '07:35' AS fin, 'QUIM' AS asig, 'JESUS ESQUIVEL' AS doc
  UNION ALL SELECT '11B' AS grupo, 3 AS dia, '07:35' AS ini, '08:25' AS fin, 'QUIM' AS asig, 'JESUS ESQUIVEL' AS doc
  UNION ALL SELECT '11B' AS grupo, 3 AS dia, '08:25' AS ini, '09:05' AS fin, 'ARTIST' AS asig, 'WENDY PERTUZ' AS doc
  UNION ALL SELECT '11B' AS grupo, 3 AS dia, '09:35' AS ini, '10:30' AS fin, 'INGLES' AS asig, 'ALEJANDRO BABILONIA' AS doc
  UNION ALL SELECT '11B' AS grupo, 3 AS dia, '10:30' AS ini, '11:20' AS fin, 'TEC_INFO' AS asig, 'LAURA GONZALEZ' AS doc
  UNION ALL SELECT '11B' AS grupo, 3 AS dia, '11:20' AS ini, '12:00' AS fin, 'TEC_INFO' AS asig, 'LAURA GONZALEZ' AS doc
  UNION ALL SELECT '11B' AS grupo, 4 AS dia, '06:45' AS ini, '07:35' AS fin, 'C_NAT' AS asig, 'SHIRLEY PEDROZA' AS doc
  UNION ALL SELECT '11B' AS grupo, 4 AS dia, '07:35' AS ini, '08:25' AS fin, 'C_POLITICA' AS asig, 'ARNOLD PEREZ' AS doc
  UNION ALL SELECT '11B' AS grupo, 4 AS dia, '08:25' AS ini, '09:05' AS fin, 'FILOSOFIA' AS asig, 'ARNOLD PEREZ' AS doc
  UNION ALL SELECT '11B' AS grupo, 4 AS dia, '09:35' AS ini, '10:30' AS fin, 'FILOSOFIA' AS asig, 'ARNOLD PEREZ' AS doc
  UNION ALL SELECT '11B' AS grupo, 5 AS dia, '06:45' AS ini, '07:35' AS fin, 'L_CAST' AS asig, 'ANA GOMEZ' AS doc
  UNION ALL SELECT '11B' AS grupo, 5 AS dia, '07:35' AS ini, '08:25' AS fin, 'C_NAT' AS asig, 'SHIRLEY PEDROZA' AS doc
  UNION ALL SELECT '11B' AS grupo, 5 AS dia, '08:25' AS ini, '09:05' AS fin, 'C_POLITICA' AS asig, 'ARNOLD PEREZ' AS doc
  UNION ALL SELECT '11B' AS grupo, 5 AS dia, '09:35' AS ini, '10:30' AS fin, 'TEC_INFO' AS asig, 'LAURA GONZALEZ' AS doc
  UNION ALL SELECT '11B' AS grupo, 5 AS dia, '11:20' AS ini, '12:00' AS fin, 'INGLES' AS asig, 'ALEJANDRO BABILONIA' AS doc
  UNION ALL SELECT '11B' AS grupo, 5 AS dia, '12:15' AS ini, '13:00' AS fin, 'QUIM' AS asig, 'JESUS ESQUIVEL' AS doc
  UNION ALL SELECT '11B' AS grupo, 5 AS dia, '13:00' AS ini, '13:45' AS fin, 'QUIM' AS asig, 'JESUS ESQUIVEL' AS doc
  UNION ALL SELECT '1A' AS grupo, 1 AS dia, '06:45' AS ini, '07:35' AS fin, 'ORIE' AS asig, 'LIBIA PERNETT' AS doc
  UNION ALL SELECT '1A' AS grupo, 1 AS dia, '07:35' AS ini, '08:25' AS fin, 'TEC_INFO' AS asig, 'LIBIA PERNETT' AS doc
  UNION ALL SELECT '1A' AS grupo, 1 AS dia, '12:10' AS ini, '13:00' AS fin, 'ETICA' AS asig, 'GISELLA CARTAGENA' AS doc
  UNION ALL SELECT '1A' AS grupo, 2 AS dia, '06:45' AS ini, '07:35' AS fin, 'ED_FISICA' AS asig, 'DILSON MAZA' AS doc
  UNION ALL SELECT '1A' AS grupo, 2 AS dia, '07:35' AS ini, '08:25' AS fin, 'ED_FISICA' AS asig, 'DILSON MAZA' AS doc
  UNION ALL SELECT '1A' AS grupo, 3 AS dia, '06:45' AS ini, '07:35' AS fin, 'MATEM' AS asig, 'LIBIA PERNETT' AS doc
  UNION ALL SELECT '1A' AS grupo, 3 AS dia, '07:35' AS ini, '08:25' AS fin, 'MATEM' AS asig, 'LIBIA PERNETT' AS doc
  UNION ALL SELECT '1A' AS grupo, 4 AS dia, '06:45' AS ini, '07:35' AS fin, 'L_CAST' AS asig, 'LIBIA PERNETT' AS doc
  UNION ALL SELECT '1A' AS grupo, 4 AS dia, '07:35' AS ini, '08:25' AS fin, 'L_CAST' AS asig, 'LIBIA PERNETT' AS doc
  UNION ALL SELECT '1A' AS grupo, 5 AS dia, '06:45' AS ini, '07:35' AS fin, 'INGLES' AS asig, 'GISELLA CARTAGENA' AS doc
  UNION ALL SELECT '1A' AS grupo, 5 AS dia, '07:35' AS ini, '08:25' AS fin, 'C_NAT' AS asig, 'LIBIA PERNETT' AS doc
  UNION ALL SELECT '2A' AS grupo, 1 AS dia, '06:45' AS ini, '07:35' AS fin, 'ORIE' AS asig, 'MARIA CLAUDIA' AS doc
  UNION ALL SELECT '2A' AS grupo, 1 AS dia, '07:35' AS ini, '08:25' AS fin, 'INGLES' AS asig, 'GISELLA CARTAGENA' AS doc
  UNION ALL SELECT '2A' AS grupo, 1 AS dia, '11:20' AS ini, '12:10' AS fin, 'C_NAT' AS asig, 'MARIA CLAUDIA' AS doc
  UNION ALL SELECT '2A' AS grupo, 2 AS dia, '06:45' AS ini, '07:35' AS fin, 'TEC_INFO' AS asig, 'LIBIA PERNETT' AS doc
  UNION ALL SELECT '2A' AS grupo, 2 AS dia, '07:35' AS ini, '08:25' AS fin, 'TEC_INFO' AS asig, 'LIBIA PERNETT' AS doc
  UNION ALL SELECT '2A' AS grupo, 3 AS dia, '06:45' AS ini, '07:35' AS fin, 'L_CAST' AS asig, 'MARIA ALEJANDRA' AS doc
  UNION ALL SELECT '2A' AS grupo, 3 AS dia, '07:35' AS ini, '08:25' AS fin, 'L_CAST' AS asig, 'MARIA ALEJANDRA' AS doc
  UNION ALL SELECT '2A' AS grupo, 4 AS dia, '06:45' AS ini, '07:35' AS fin, 'ED_FISICA' AS asig, 'DILSON MAZA' AS doc
  UNION ALL SELECT '2A' AS grupo, 4 AS dia, '07:35' AS ini, '08:25' AS fin, 'ED_FISICA' AS asig, 'DILSON MAZA' AS doc
  UNION ALL SELECT '2A' AS grupo, 5 AS dia, '06:45' AS ini, '07:35' AS fin, 'ESTADIST' AS asig, 'JOSE HOYOS' AS doc
  UNION ALL SELECT '2A' AS grupo, 5 AS dia, '07:35' AS ini, '08:25' AS fin, 'RELIG' AS asig, 'MARIA CLAUDIA' AS doc
  UNION ALL SELECT '2A' AS grupo, 5 AS dia, '11:20' AS ini, '12:10' AS fin, 'C_SOC' AS asig, 'MARIA CLAUDIA' AS doc
  UNION ALL SELECT '2A' AS grupo, 5 AS dia, '12:10' AS ini, '13:00' AS fin, 'INGLES' AS asig, 'GISELLA CARTAGENA' AS doc
  UNION ALL SELECT '3A' AS grupo, 1 AS dia, '06:45' AS ini, '07:35' AS fin, 'ORIE' AS asig, 'MARIA ALEJANDRA' AS doc
  UNION ALL SELECT '3A' AS grupo, 1 AS dia, '07:35' AS ini, '08:25' AS fin, 'C_SOC' AS asig, 'MARIA CLAUDIA' AS doc
  UNION ALL SELECT '3A' AS grupo, 1 AS dia, '09:05' AS ini, '10:00' AS fin, 'ARTIST' AS asig, 'WENDY PERTUZ' AS doc
  UNION ALL SELECT '3A' AS grupo, 1 AS dia, '10:00' AS ini, '11:00' AS fin, 'ARTIST' AS asig, 'WENDY PERTUZ' AS doc
  UNION ALL SELECT '3A' AS grupo, 1 AS dia, '11:20' AS ini, '12:10' AS fin, 'TEC_INFO' AS asig, 'LAURA GONZALEZ' AS doc
  UNION ALL SELECT '3A' AS grupo, 1 AS dia, '12:10' AS ini, '13:00' AS fin, 'TEC_INFO' AS asig, 'LAURA GONZALEZ' AS doc
  UNION ALL SELECT '3A' AS grupo, 2 AS dia, '06:45' AS ini, '07:35' AS fin, 'MATEM' AS asig, 'JOSE HOYOS' AS doc
  UNION ALL SELECT '3A' AS grupo, 2 AS dia, '07:35' AS ini, '08:25' AS fin, 'MATEM' AS asig, 'JOSE HOYOS' AS doc
  UNION ALL SELECT '3A' AS grupo, 2 AS dia, '11:20' AS ini, '12:10' AS fin, 'C_NAT' AS asig, 'MARIA CLAUDIA' AS doc
  UNION ALL SELECT '3A' AS grupo, 2 AS dia, '12:10' AS ini, '13:00' AS fin, 'C_NAT' AS asig, 'MARIA CLAUDIA' AS doc
  UNION ALL SELECT '3A' AS grupo, 3 AS dia, '06:45' AS ini, '07:35' AS fin, 'ED_FISICA' AS asig, 'DILSON MAZA' AS doc
  UNION ALL SELECT '3A' AS grupo, 3 AS dia, '07:35' AS ini, '08:25' AS fin, 'ED_FISICA' AS asig, 'DILSON MAZA' AS doc
  UNION ALL SELECT '3A' AS grupo, 3 AS dia, '11:20' AS ini, '12:10' AS fin, 'INGLES' AS asig, 'GISELLA CARTAGENA' AS doc
  UNION ALL SELECT '3A' AS grupo, 3 AS dia, '12:10' AS ini, '13:00' AS fin, 'INGLES' AS asig, 'GISELLA CARTAGENA' AS doc
  UNION ALL SELECT '3A' AS grupo, 4 AS dia, '06:45' AS ini, '07:35' AS fin, 'L_CAST' AS asig, 'MARIA ALEJANDRA' AS doc
  UNION ALL SELECT '3A' AS grupo, 4 AS dia, '07:35' AS ini, '08:25' AS fin, 'L_CAST' AS asig, 'MARIA ALEJANDRA' AS doc
  UNION ALL SELECT '3A' AS grupo, 4 AS dia, '11:20' AS ini, '12:10' AS fin, 'C_SOC' AS asig, 'MARIA CLAUDIA' AS doc
  UNION ALL SELECT '3A' AS grupo, 4 AS dia, '12:10' AS ini, '13:00' AS fin, 'C_SOC' AS asig, 'MARIA CLAUDIA' AS doc
  UNION ALL SELECT '3A' AS grupo, 5 AS dia, '06:45' AS ini, '07:35' AS fin, 'RELIG' AS asig, 'MARIA ALEJANDRA' AS doc
  UNION ALL SELECT '3A' AS grupo, 5 AS dia, '07:35' AS ini, '08:25' AS fin, 'GEOMET' AS asig, 'JOSE HOYOS' AS doc
  UNION ALL SELECT '3A' AS grupo, 5 AS dia, '11:20' AS ini, '12:10' AS fin, 'INGLES' AS asig, 'GISELLA CARTAGENA' AS doc
  UNION ALL SELECT '3A' AS grupo, 5 AS dia, '12:10' AS ini, '13:00' AS fin, 'C_SOC' AS asig, 'MARIA CLAUDIA' AS doc
  UNION ALL SELECT '4A' AS grupo, 1 AS dia, '06:45' AS ini, '07:35' AS fin, 'ORIE' AS asig, 'GISELLA CARTAGENA' AS doc
  UNION ALL SELECT '4A' AS grupo, 1 AS dia, '07:35' AS ini, '08:25' AS fin, 'L_CAST' AS asig, 'MARIA ALEJANDRA' AS doc
  UNION ALL SELECT '4A' AS grupo, 2 AS dia, '06:45' AS ini, '07:35' AS fin, 'C_NAT' AS asig, 'MARIA CLAUDIA' AS doc
  UNION ALL SELECT '4A' AS grupo, 2 AS dia, '07:35' AS ini, '08:25' AS fin, 'C_NAT' AS asig, 'MARIA CLAUDIA' AS doc
  UNION ALL SELECT '4A' AS grupo, 3 AS dia, '06:45' AS ini, '07:35' AS fin, 'INGLES' AS asig, 'GISELLA CARTAGENA' AS doc
  UNION ALL SELECT '4A' AS grupo, 3 AS dia, '07:35' AS ini, '08:25' AS fin, 'INGLES' AS asig, 'GISELLA CARTAGENA' AS doc
  UNION ALL SELECT '4A' AS grupo, 3 AS dia, '11:20' AS ini, '12:10' AS fin, 'C_SOC' AS asig, 'MARIA CLAUDIA' AS doc
  UNION ALL SELECT '4A' AS grupo, 3 AS dia, '12:10' AS ini, '13:00' AS fin, 'C_SOC' AS asig, 'MARIA CLAUDIA' AS doc
  UNION ALL SELECT '4A' AS grupo, 4 AS dia, '06:45' AS ini, '07:35' AS fin, 'C_NAT' AS asig, 'MARIA CLAUDIA' AS doc
  UNION ALL SELECT '4A' AS grupo, 4 AS dia, '07:35' AS ini, '08:25' AS fin, 'C_SOC' AS asig, 'MARIA CLAUDIA' AS doc
  UNION ALL SELECT '4A' AS grupo, 5 AS dia, '06:45' AS ini, '07:35' AS fin, 'TEC_INFO' AS asig, 'LAURA GONZALEZ' AS doc
  UNION ALL SELECT '4A' AS grupo, 5 AS dia, '07:35' AS ini, '08:25' AS fin, 'TEC_INFO' AS asig, 'LAURA GONZALEZ' AS doc
  UNION ALL SELECT '5A' AS grupo, 1 AS dia, '06:45' AS ini, '07:35' AS fin, 'ORIE' AS asig, 'JOSE HOYOS' AS doc
  UNION ALL SELECT '5A' AS grupo, 1 AS dia, '07:35' AS ini, '08:25' AS fin, 'ESTADIST' AS asig, 'JOSE HOYOS' AS doc
  UNION ALL SELECT '5A' AS grupo, 1 AS dia, '12:10' AS ini, '13:00' AS fin, 'C_NAT' AS asig, 'MARIA CLAUDIA' AS doc
  UNION ALL SELECT '5A' AS grupo, 2 AS dia, '06:45' AS ini, '07:35' AS fin, 'L_CAST' AS asig, 'MARIA ALEJANDRA' AS doc
  UNION ALL SELECT '5A' AS grupo, 2 AS dia, '07:35' AS ini, '08:25' AS fin, 'L_CAST' AS asig, 'MARIA ALEJANDRA' AS doc
  UNION ALL SELECT '5A' AS grupo, 2 AS dia, '11:20' AS ini, '12:10' AS fin, 'ETICA' AS asig, 'GISELLA CARTAGENA' AS doc
  UNION ALL SELECT '5A' AS grupo, 2 AS dia, '12:10' AS ini, '13:00' AS fin, 'INGLES' AS asig, 'GISELLA CARTAGENA' AS doc
  UNION ALL SELECT '5A' AS grupo, 3 AS dia, '06:45' AS ini, '07:35' AS fin, 'C_SOC' AS asig, 'MARIA CLAUDIA' AS doc
  UNION ALL SELECT '5A' AS grupo, 3 AS dia, '07:35' AS ini, '08:25' AS fin, 'GEOMET' AS asig, 'JOSE HOYOS' AS doc
  UNION ALL SELECT '5A' AS grupo, 3 AS dia, '09:05' AS ini, '10:00' AS fin, 'ARTIST' AS asig, 'WENDY PERTUZ' AS doc
  UNION ALL SELECT '5A' AS grupo, 3 AS dia, '10:00' AS ini, '11:00' AS fin, 'ARTIST' AS asig, 'WENDY PERTUZ' AS doc
  UNION ALL SELECT '5A' AS grupo, 4 AS dia, '06:45' AS ini, '07:35' AS fin, 'MATEM' AS asig, 'JOSE HOYOS' AS doc
  UNION ALL SELECT '5A' AS grupo, 4 AS dia, '07:35' AS ini, '08:25' AS fin, 'MATEM' AS asig, 'JOSE HOYOS' AS doc
  UNION ALL SELECT '5A' AS grupo, 4 AS dia, '09:05' AS ini, '10:00' AS fin, 'TEC_INFO' AS asig, 'LAURA GONZALEZ' AS doc
  UNION ALL SELECT '5A' AS grupo, 4 AS dia, '10:00' AS ini, '11:00' AS fin, 'TEC_INFO' AS asig, 'LAURA GONZALEZ' AS doc
  UNION ALL SELECT '5A' AS grupo, 4 AS dia, '11:20' AS ini, '12:10' AS fin, 'INGLES' AS asig, 'GISELLA CARTAGENA' AS doc
  UNION ALL SELECT '5A' AS grupo, 4 AS dia, '12:10' AS ini, '13:00' AS fin, 'INGLES' AS asig, 'GISELLA CARTAGENA' AS doc
  UNION ALL SELECT '5A' AS grupo, 5 AS dia, '06:45' AS ini, '07:35' AS fin, 'ED_FISICA' AS asig, 'DILSON MAZA' AS doc
  UNION ALL SELECT '5A' AS grupo, 5 AS dia, '07:35' AS ini, '08:25' AS fin, 'ED_FISICA' AS asig, 'DILSON MAZA' AS doc
  UNION ALL SELECT '6A' AS grupo, 1 AS dia, '06:45' AS ini, '07:35' AS fin, 'ORIE' AS asig, 'PETRONA ALTAMIRANDA' AS doc
  UNION ALL SELECT '6A' AS grupo, 1 AS dia, '07:35' AS ini, '08:25' AS fin, 'TEC_INFO' AS asig, 'LAURA GONZALEZ' AS doc
  UNION ALL SELECT '6A' AS grupo, 1 AS dia, '08:25' AS ini, '09:05' AS fin, 'TEC_INFO' AS asig, 'LAURA GONZALEZ' AS doc
  UNION ALL SELECT '6A' AS grupo, 1 AS dia, '09:35' AS ini, '10:30' AS fin, 'INGLES' AS asig, 'ALEJANDRO BABILONIA' AS doc
  UNION ALL SELECT '6A' AS grupo, 1 AS dia, '10:30' AS ini, '11:20' AS fin, 'INGLES' AS asig, 'ALEJANDRO BABILONIA' AS doc
  UNION ALL SELECT '6A' AS grupo, 2 AS dia, '06:45' AS ini, '07:35' AS fin, 'C_SOC' AS asig, 'JESUS ESQUIVEL' AS doc
  UNION ALL SELECT '6A' AS grupo, 2 AS dia, '07:35' AS ini, '08:25' AS fin, 'ARTIST' AS asig, 'WENDY PERTUZ' AS doc
  UNION ALL SELECT '6A' AS grupo, 2 AS dia, '08:25' AS ini, '09:05' AS fin, 'ARTIST' AS asig, 'WENDY PERTUZ' AS doc
  UNION ALL SELECT '6A' AS grupo, 2 AS dia, '09:35' AS ini, '10:30' AS fin, 'MATEM' AS asig, 'JEILE BERRIDO' AS doc
  UNION ALL SELECT '6A' AS grupo, 2 AS dia, '10:30' AS ini, '11:20' AS fin, 'MATEM' AS asig, 'JEILE BERRIDO' AS doc
  UNION ALL SELECT '6A' AS grupo, 2 AS dia, '11:40' AS ini, '12:40' AS fin, 'L_CAST' AS asig, 'PETRONA ALTAMIRANDA' AS doc
  UNION ALL SELECT '6A' AS grupo, 2 AS dia, '12:40' AS ini, '13:45' AS fin, 'L_CAST' AS asig, 'PETRONA ALTAMIRANDA' AS doc
  UNION ALL SELECT '6A' AS grupo, 3 AS dia, '06:45' AS ini, '07:35' AS fin, 'L_CAST' AS asig, 'PETRONA ALTAMIRANDA' AS doc
  UNION ALL SELECT '6A' AS grupo, 3 AS dia, '07:35' AS ini, '08:25' AS fin, 'L_CAST' AS asig, 'PETRONA ALTAMIRANDA' AS doc
  UNION ALL SELECT '6A' AS grupo, 3 AS dia, '08:25' AS ini, '09:05' AS fin, 'C_SOC' AS asig, 'JESUS ESQUIVEL' AS doc
  UNION ALL SELECT '6A' AS grupo, 3 AS dia, '11:40' AS ini, '12:40' AS fin, 'MATEM' AS asig, 'JEILE BERRIDO' AS doc
  UNION ALL SELECT '6A' AS grupo, 3 AS dia, '12:40' AS ini, '13:45' AS fin, 'MATEM' AS asig, 'JEILE BERRIDO' AS doc
  UNION ALL SELECT '6A' AS grupo, 4 AS dia, '06:45' AS ini, '07:35' AS fin, 'INGLES' AS asig, 'ALEJANDRO BABILONIA' AS doc
  UNION ALL SELECT '6A' AS grupo, 4 AS dia, '07:35' AS ini, '08:25' AS fin, 'L_CAST' AS asig, 'PETRONA ALTAMIRANDA' AS doc
  UNION ALL SELECT '6A' AS grupo, 4 AS dia, '08:25' AS ini, '09:05' AS fin, 'L_CAST' AS asig, 'PETRONA ALTAMIRANDA' AS doc
  UNION ALL SELECT '6A' AS grupo, 4 AS dia, '09:35' AS ini, '10:30' AS fin, 'C_SOC' AS asig, 'JESUS ESQUIVEL' AS doc
  UNION ALL SELECT '6A' AS grupo, 4 AS dia, '12:40' AS ini, '13:45' AS fin, 'ESTADIST' AS asig, 'JEILE BERRIDO' AS doc
  UNION ALL SELECT '6A' AS grupo, 5 AS dia, '06:45' AS ini, '07:35' AS fin, 'INGLES' AS asig, 'ALEJANDRO BABILONIA' AS doc
  UNION ALL SELECT '6A' AS grupo, 5 AS dia, '07:35' AS ini, '08:25' AS fin, 'C_SOC' AS asig, 'JESUS ESQUIVEL' AS doc
  UNION ALL SELECT '6A' AS grupo, 5 AS dia, '08:25' AS ini, '09:05' AS fin, 'ED_FISICA' AS asig, 'DILSON MAZA' AS doc
  UNION ALL SELECT '6A' AS grupo, 5 AS dia, '10:30' AS ini, '11:20' AS fin, 'FISICA' AS asig, 'MAURICIO CUADRADO' AS doc
  UNION ALL SELECT '6A' AS grupo, 5 AS dia, '11:40' AS ini, '12:40' AS fin, 'GEOMET' AS asig, 'JEILE BERRIDO' AS doc
  UNION ALL SELECT '7A' AS grupo, 1 AS dia, '06:45' AS ini, '07:35' AS fin, 'ORIE' AS asig, 'WENDY PERTUZ' AS doc
  UNION ALL SELECT '7A' AS grupo, 1 AS dia, '07:35' AS ini, '08:25' AS fin, 'INGLES' AS asig, 'ALEJANDRO BABILONIA' AS doc
  UNION ALL SELECT '7A' AS grupo, 1 AS dia, '08:25' AS ini, '09:05' AS fin, 'INGLES' AS asig, 'ALEJANDRO BABILONIA' AS doc
  UNION ALL SELECT '7A' AS grupo, 1 AS dia, '09:35' AS ini, '10:30' AS fin, 'MATEM' AS asig, 'JEILE BERRIDO' AS doc
  UNION ALL SELECT '7A' AS grupo, 1 AS dia, '10:30' AS ini, '11:20' AS fin, 'MATEM' AS asig, 'JEILE BERRIDO' AS doc
  UNION ALL SELECT '7A' AS grupo, 1 AS dia, '11:40' AS ini, '12:40' AS fin, 'C_SOC' AS asig, 'JESUS ESQUIVEL' AS doc
  UNION ALL SELECT '7A' AS grupo, 1 AS dia, '12:40' AS ini, '13:45' AS fin, 'C_SOC' AS asig, 'JESUS ESQUIVEL' AS doc
  UNION ALL SELECT '7A' AS grupo, 2 AS dia, '06:45' AS ini, '07:35' AS fin, 'QUIM' AS asig, 'SHIRLEY PEDROZA' AS doc
  UNION ALL SELECT '7A' AS grupo, 2 AS dia, '07:35' AS ini, '08:25' AS fin, 'C_SOC' AS asig, 'JESUS ESQUIVEL' AS doc
  UNION ALL SELECT '7A' AS grupo, 2 AS dia, '08:25' AS ini, '09:05' AS fin, 'C_SOC' AS asig, 'JESUS ESQUIVEL' AS doc
  UNION ALL SELECT '7A' AS grupo, 2 AS dia, '11:40' AS ini, '12:40' AS fin, 'TEC_INFO' AS asig, 'LAURA GONZALEZ' AS doc
  UNION ALL SELECT '7A' AS grupo, 2 AS dia, '12:40' AS ini, '13:45' AS fin, 'TEC_INFO' AS asig, 'LAURA GONZALEZ' AS doc
  UNION ALL SELECT '7A' AS grupo, 3 AS dia, '06:45' AS ini, '07:35' AS fin, 'ARTIST' AS asig, 'WENDY PERTUZ' AS doc
  UNION ALL SELECT '7A' AS grupo, 3 AS dia, '07:35' AS ini, '08:25' AS fin, 'ARTIST' AS asig, 'WENDY PERTUZ' AS doc
  UNION ALL SELECT '7A' AS grupo, 3 AS dia, '08:25' AS ini, '09:05' AS fin, 'ED_FISICA' AS asig, 'DILSON MAZA' AS doc
  UNION ALL SELECT '7A' AS grupo, 3 AS dia, '10:30' AS ini, '11:20' AS fin, 'FISICA' AS asig, 'MAURICIO CUADRADO' AS doc
  UNION ALL SELECT '7A' AS grupo, 3 AS dia, '12:40' AS ini, '13:45' AS fin, 'RELIG' AS asig, 'AURA CARABALLO' AS doc
  UNION ALL SELECT '7A' AS grupo, 4 AS dia, '07:35' AS ini, '08:25' AS fin, 'MATEM' AS asig, 'JEILE BERRIDO' AS doc
  UNION ALL SELECT '7A' AS grupo, 4 AS dia, '08:25' AS ini, '09:05' AS fin, 'MATEM' AS asig, 'JEILE BERRIDO' AS doc
  UNION ALL SELECT '7A' AS grupo, 4 AS dia, '09:35' AS ini, '10:30' AS fin, 'INGLES' AS asig, 'ALEJANDRO BABILONIA' AS doc
  UNION ALL SELECT '7A' AS grupo, 4 AS dia, '10:30' AS ini, '11:20' AS fin, 'INGLES' AS asig, 'ALEJANDRO BABILONIA' AS doc
  UNION ALL SELECT '7A' AS grupo, 4 AS dia, '11:40' AS ini, '12:40' AS fin, 'L_CAST' AS asig, 'PETRONA ALTAMIRANDA' AS doc
  UNION ALL SELECT '7A' AS grupo, 4 AS dia, '12:40' AS ini, '13:45' AS fin, 'L_CAST' AS asig, 'PETRONA ALTAMIRANDA' AS doc
  UNION ALL SELECT '7A' AS grupo, 5 AS dia, '06:45' AS ini, '07:35' AS fin, 'GEOMET' AS asig, 'JEILE BERRIDO' AS doc
  UNION ALL SELECT '7A' AS grupo, 5 AS dia, '07:35' AS ini, '08:25' AS fin, 'GEOMET' AS asig, 'JEILE BERRIDO' AS doc
  UNION ALL SELECT '7A' AS grupo, 5 AS dia, '08:25' AS ini, '09:05' AS fin, 'C_NAT' AS asig, 'SHIRLEY PEDROZA' AS doc
  UNION ALL SELECT '7A' AS grupo, 5 AS dia, '10:30' AS ini, '11:20' AS fin, 'ETICA' AS asig, 'JEILE BERRIDO' AS doc
  UNION ALL SELECT '7A' AS grupo, 5 AS dia, '11:40' AS ini, '12:40' AS fin, 'L_CAST' AS asig, 'PETRONA ALTAMIRANDA' AS doc
  UNION ALL SELECT '7A' AS grupo, 5 AS dia, '12:40' AS ini, '13:45' AS fin, 'L_CAST' AS asig, 'PETRONA ALTAMIRANDA' AS doc
  UNION ALL SELECT '8A' AS grupo, 1 AS dia, '06:45' AS ini, '07:35' AS fin, 'ORIE' AS asig, 'JESUS ESQUIVEL' AS doc
  UNION ALL SELECT '8A' AS grupo, 1 AS dia, '07:35' AS ini, '08:25' AS fin, 'C_SOC' AS asig, 'JESUS ESQUIVEL' AS doc
  UNION ALL SELECT '8A' AS grupo, 1 AS dia, '08:25' AS ini, '09:05' AS fin, 'C_SOC' AS asig, 'JESUS ESQUIVEL' AS doc
  UNION ALL SELECT '8A' AS grupo, 1 AS dia, '11:40' AS ini, '12:40' AS fin, 'INGLES' AS asig, 'ALEJANDRO BABILONIA' AS doc
  UNION ALL SELECT '8A' AS grupo, 1 AS dia, '12:40' AS ini, '13:45' AS fin, 'INGLES' AS asig, 'ALEJANDRO BABILONIA' AS doc
  UNION ALL SELECT '8A' AS grupo, 2 AS dia, '06:45' AS ini, '07:35' AS fin, 'TEC_INFO' AS asig, 'LAURA GONZALEZ' AS doc
  UNION ALL SELECT '8A' AS grupo, 2 AS dia, '07:35' AS ini, '08:25' AS fin, 'TEC_INFO' AS asig, 'LAURA GONZALEZ' AS doc
  UNION ALL SELECT '8A' AS grupo, 2 AS dia, '08:25' AS ini, '09:05' AS fin, 'FISICA' AS asig, 'MAURICIO CUADRADO' AS doc
  UNION ALL SELECT '8A' AS grupo, 2 AS dia, '11:40' AS ini, '12:40' AS fin, 'ESTADIST' AS asig, 'JEILE BERRIDO' AS doc
  UNION ALL SELECT '8A' AS grupo, 2 AS dia, '12:40' AS ini, '13:45' AS fin, 'INGLES' AS asig, 'ALEJANDRO BABILONIA' AS doc
  UNION ALL SELECT '8A' AS grupo, 3 AS dia, '06:45' AS ini, '07:35' AS fin, 'MATEM' AS asig, 'JEILE BERRIDO' AS doc
  UNION ALL SELECT '8A' AS grupo, 3 AS dia, '07:35' AS ini, '08:25' AS fin, 'MATEM' AS asig, 'JEILE BERRIDO' AS doc
  UNION ALL SELECT '8A' AS grupo, 3 AS dia, '08:25' AS ini, '09:05' AS fin, 'L_CAST' AS asig, 'PETRONA ALTAMIRANDA' AS doc
  UNION ALL SELECT '8A' AS grupo, 3 AS dia, '12:40' AS ini, '13:45' AS fin, 'INGLES' AS asig, 'ALEJANDRO BABILONIA' AS doc
  UNION ALL SELECT '8A' AS grupo, 4 AS dia, '06:45' AS ini, '07:35' AS fin, 'ETICA' AS asig, 'JEILE BERRIDO' AS doc
  UNION ALL SELECT '8A' AS grupo, 4 AS dia, '07:35' AS ini, '08:25' AS fin, 'C_SOC' AS asig, 'JESUS ESQUIVEL' AS doc
  UNION ALL SELECT '8A' AS grupo, 4 AS dia, '08:25' AS ini, '09:05' AS fin, 'C_SOC' AS asig, 'JESUS ESQUIVEL' AS doc
  UNION ALL SELECT '8A' AS grupo, 4 AS dia, '10:30' AS ini, '11:20' AS fin, 'MATEM' AS asig, 'JEILE BERRIDO' AS doc
  UNION ALL SELECT '8A' AS grupo, 4 AS dia, '11:40' AS ini, '12:40' AS fin, 'MATEM' AS asig, 'JEILE BERRIDO' AS doc
  UNION ALL SELECT '8A' AS grupo, 4 AS dia, '12:40' AS ini, '13:45' AS fin, 'RELIG' AS asig, 'AURA CARABALLO' AS doc
  UNION ALL SELECT '8A' AS grupo, 5 AS dia, '06:45' AS ini, '07:35' AS fin, 'ARTIST' AS asig, 'WENDY PERTUZ' AS doc
  UNION ALL SELECT '8A' AS grupo, 5 AS dia, '07:35' AS ini, '08:25' AS fin, 'ARTIST' AS asig, 'WENDY PERTUZ' AS doc
  UNION ALL SELECT '8A' AS grupo, 5 AS dia, '08:25' AS ini, '09:05' AS fin, 'GEOMET' AS asig, 'JEILE BERRIDO' AS doc
  UNION ALL SELECT '8B' AS grupo, 1 AS dia, '07:35' AS ini, '08:25' AS fin, 'MATEM' AS asig, 'MAURICIO CUADRADO' AS doc
  UNION ALL SELECT '8B' AS grupo, 1 AS dia, '08:25' AS ini, '09:05' AS fin, 'MATEM' AS asig, 'MAURICIO CUADRADO' AS doc
  UNION ALL SELECT '8B' AS grupo, 1 AS dia, '09:35' AS ini, '10:30' AS fin, 'TEC_INFO' AS asig, 'LAURA GONZALEZ' AS doc
  UNION ALL SELECT '8B' AS grupo, 1 AS dia, '10:30' AS ini, '11:20' AS fin, 'TEC_INFO' AS asig, 'LAURA GONZALEZ' AS doc
  UNION ALL SELECT '8B' AS grupo, 1 AS dia, '11:40' AS ini, '12:40' AS fin, 'L_CAST' AS asig, 'PETRONA ALTAMIRANDA' AS doc
  UNION ALL SELECT '8B' AS grupo, 1 AS dia, '12:40' AS ini, '13:45' AS fin, 'L_CAST' AS asig, 'PETRONA ALTAMIRANDA' AS doc
  UNION ALL SELECT '8B' AS grupo, 2 AS dia, '06:45' AS ini, '07:35' AS fin, 'MATEM' AS asig, 'MAURICIO CUADRADO' AS doc
  UNION ALL SELECT '8B' AS grupo, 2 AS dia, '07:35' AS ini, '08:25' AS fin, 'MATEM' AS asig, 'MAURICIO CUADRADO' AS doc
  UNION ALL SELECT '8B' AS grupo, 2 AS dia, '08:25' AS ini, '09:05' AS fin, 'C_NAT' AS asig, 'SHIRLEY PEDROZA' AS doc
  UNION ALL SELECT '8B' AS grupo, 2 AS dia, '09:35' AS ini, '10:30' AS fin, 'INGLES' AS asig, 'ALEJANDRO BABILONIA' AS doc
  UNION ALL SELECT '8B' AS grupo, 2 AS dia, '10:30' AS ini, '11:20' AS fin, 'INGLES' AS asig, 'ALEJANDRO BABILONIA' AS doc
  UNION ALL SELECT '8B' AS grupo, 2 AS dia, '11:40' AS ini, '12:40' AS fin, 'C_SOC' AS asig, 'ARNOLD PEREZ' AS doc
  UNION ALL SELECT '8B' AS grupo, 2 AS dia, '12:40' AS ini, '13:45' AS fin, 'C_SOC' AS asig, 'ARNOLD PEREZ' AS doc
  UNION ALL SELECT '8B' AS grupo, 3 AS dia, '06:45' AS ini, '07:35' AS fin, 'INGLES' AS asig, 'ALEJANDRO BABILONIA' AS doc
  UNION ALL SELECT '8B' AS grupo, 3 AS dia, '07:35' AS ini, '08:25' AS fin, 'INGLES' AS asig, 'ALEJANDRO BABILONIA' AS doc
  UNION ALL SELECT '8B' AS grupo, 3 AS dia, '08:25' AS ini, '09:05' AS fin, 'ETICA' AS asig, 'JEILE BERRIDO' AS doc
  UNION ALL SELECT '8B' AS grupo, 3 AS dia, '09:35' AS ini, '10:30' AS fin, 'ESTADIST' AS asig, 'MAURICIO CUADRADO' AS doc
  UNION ALL SELECT '8B' AS grupo, 3 AS dia, '11:40' AS ini, '12:40' AS fin, 'L_CAST' AS asig, 'PETRONA ALTAMIRANDA' AS doc
  UNION ALL SELECT '8B' AS grupo, 3 AS dia, '12:40' AS ini, '13:45' AS fin, 'L_CAST' AS asig, 'PETRONA ALTAMIRANDA' AS doc
  UNION ALL SELECT '8B' AS grupo, 4 AS dia, '06:45' AS ini, '07:35' AS fin, 'GEOMET' AS asig, 'MAURICIO CUADRADO' AS doc
  UNION ALL SELECT '8B' AS grupo, 4 AS dia, '07:35' AS ini, '08:25' AS fin, 'C_NAT' AS asig, 'SHIRLEY PEDROZA' AS doc
  UNION ALL SELECT '8B' AS grupo, 4 AS dia, '08:25' AS ini, '09:05' AS fin, 'C_NAT' AS asig, 'SHIRLEY PEDROZA' AS doc
  UNION ALL SELECT '8B' AS grupo, 4 AS dia, '12:40' AS ini, '13:45' AS fin, 'RELIG' AS asig, 'KENIA CASTILLO' AS doc
  UNION ALL SELECT '8B' AS grupo, 5 AS dia, '06:45' AS ini, '07:35' AS fin, 'FISICA' AS asig, 'MAURICIO CUADRADO' AS doc
  UNION ALL SELECT '8B' AS grupo, 5 AS dia, '07:35' AS ini, '08:25' AS fin, 'L_CAST' AS asig, 'PETRONA ALTAMIRANDA' AS doc
  UNION ALL SELECT '8B' AS grupo, 5 AS dia, '08:25' AS ini, '09:05' AS fin, 'L_CAST' AS asig, 'PETRONA ALTAMIRANDA' AS doc
  UNION ALL SELECT '8B' AS grupo, 5 AS dia, '09:35' AS ini, '10:30' AS fin, 'C_SOC' AS asig, 'ARNOLD PEREZ' AS doc
  UNION ALL SELECT '8B' AS grupo, 5 AS dia, '10:30' AS ini, '11:20' AS fin, 'C_SOC' AS asig, 'ARNOLD PEREZ' AS doc
  UNION ALL SELECT '9A' AS grupo, 1 AS dia, '07:35' AS ini, '08:25' AS fin, 'ED_FISICA' AS asig, 'DILSON MAZA' AS doc
  UNION ALL SELECT '9A' AS grupo, 1 AS dia, '08:25' AS ini, '09:05' AS fin, 'ED_FISICA' AS asig, 'DILSON MAZA' AS doc
  UNION ALL SELECT '9A' AS grupo, 1 AS dia, '09:35' AS ini, '10:30' AS fin, 'INGLES' AS asig, 'ANA GOMEZ' AS doc
  UNION ALL SELECT '9A' AS grupo, 1 AS dia, '12:40' AS ini, '13:45' AS fin, 'ETICA' AS asig, 'JEILE BERRIDO' AS doc
  UNION ALL SELECT '9A' AS grupo, 2 AS dia, '06:45' AS ini, '07:35' AS fin, 'C_SOC' AS asig, 'ARNOLD PEREZ' AS doc
  UNION ALL SELECT '9A' AS grupo, 2 AS dia, '07:35' AS ini, '08:25' AS fin, 'C_SOC' AS asig, 'ARNOLD PEREZ' AS doc
  UNION ALL SELECT '9A' AS grupo, 2 AS dia, '08:25' AS ini, '09:05' AS fin, 'EMPREND' AS asig, 'MANUEL WARNES' AS doc
  UNION ALL SELECT '9A' AS grupo, 2 AS dia, '12:40' AS ini, '13:45' AS fin, 'INGLES' AS asig, 'ANA GOMEZ' AS doc
  UNION ALL SELECT '9A' AS grupo, 3 AS dia, '07:35' AS ini, '08:25' AS fin, 'MATEM' AS asig, 'MANUEL WARNES' AS doc
  UNION ALL SELECT '9A' AS grupo, 3 AS dia, '08:25' AS ini, '09:05' AS fin, 'C_SOC' AS asig, 'ARNOLD PEREZ' AS doc
  UNION ALL SELECT '9A' AS grupo, 3 AS dia, '09:35' AS ini, '10:30' AS fin, 'C_SOC' AS asig, 'ARNOLD PEREZ' AS doc
  UNION ALL SELECT '9A' AS grupo, 3 AS dia, '12:40' AS ini, '13:45' AS fin, 'RELIG' AS asig, 'KENIA CASTILLO' AS doc
  UNION ALL SELECT '9A' AS grupo, 4 AS dia, '06:45' AS ini, '07:35' AS fin, 'QUIM' AS asig, 'JESUS ESQUIVEL' AS doc
  UNION ALL SELECT '9A' AS grupo, 4 AS dia, '07:35' AS ini, '08:25' AS fin, 'TEC_INFO' AS asig, 'LAURA GONZALEZ' AS doc
  UNION ALL SELECT '9A' AS grupo, 4 AS dia, '08:25' AS ini, '09:05' AS fin, 'TEC_INFO' AS asig, 'LAURA GONZALEZ' AS doc
  UNION ALL SELECT '9A' AS grupo, 4 AS dia, '09:35' AS ini, '10:30' AS fin, 'ARTIST' AS asig, 'WENDY PERTUZ' AS doc
  UNION ALL SELECT '9A' AS grupo, 5 AS dia, '06:45' AS ini, '07:35' AS fin, 'GEOMET' AS asig, 'MANUEL WARNES' AS doc
  UNION ALL SELECT '9A' AS grupo, 5 AS dia, '07:35' AS ini, '08:25' AS fin, 'ESTADIST' AS asig, 'MANUEL WARNES' AS doc
  UNION ALL SELECT '9A' AS grupo, 5 AS dia, '08:25' AS ini, '09:05' AS fin, 'L_CAST' AS asig, 'ANA GOMEZ' AS doc
  UNION ALL SELECT 'Jardín' AS grupo, 1 AS dia, '08:00' AS ini, '08:40' AS fin, 'D_COM' AS asig, 'AURA CARABALLO' AS doc
  UNION ALL SELECT 'Jardín' AS grupo, 1 AS dia, '11:10' AS ini, '12:00' AS fin, 'D_ETICA' AS asig, 'AURA CARABALLO' AS doc
  UNION ALL SELECT 'Jardín' AS grupo, 2 AS dia, '07:00' AS ini, '08:00' AS fin, 'INGLES' AS asig, 'GISELLA CARTAGENA' AS doc
  UNION ALL SELECT 'Jardín' AS grupo, 2 AS dia, '08:00' AS ini, '08:40' AS fin, 'INGLES' AS asig, 'GISELLA CARTAGENA' AS doc
  UNION ALL SELECT 'Jardín' AS grupo, 2 AS dia, '11:10' AS ini, '12:00' AS fin, 'D_COG' AS asig, 'AURA CARABALLO' AS doc
  UNION ALL SELECT 'Jardín' AS grupo, 3 AS dia, '11:10' AS ini, '12:00' AS fin, 'D_COG' AS asig, 'AURA CARABALLO' AS doc
  UNION ALL SELECT 'Jardín' AS grupo, 4 AS dia, '07:00' AS ini, '08:00' AS fin, 'D_COG' AS asig, 'AURA CARABALLO' AS doc
  UNION ALL SELECT 'Jardín' AS grupo, 4 AS dia, '08:00' AS ini, '08:40' AS fin, 'D_COG' AS asig, 'AURA CARABALLO' AS doc
  UNION ALL SELECT 'Jardín' AS grupo, 4 AS dia, '11:10' AS ini, '12:00' AS fin, 'D_COG' AS asig, 'AURA CARABALLO' AS doc
  UNION ALL SELECT 'Jardín' AS grupo, 5 AS dia, '07:00' AS ini, '08:00' AS fin, 'D_COM' AS asig, 'AURA CARABALLO' AS doc
  UNION ALL SELECT 'Jardín' AS grupo, 5 AS dia, '08:00' AS ini, '08:40' AS fin, 'D_COM' AS asig, 'AURA CARABALLO' AS doc
  UNION ALL SELECT 'Jardín' AS grupo, 5 AS dia, '11:10' AS ini, '12:00' AS fin, 'D_ETICA' AS asig, 'AURA CARABALLO' AS doc
  UNION ALL SELECT 'Transición' AS grupo, 1 AS dia, '11:10' AS ini, '12:00' AS fin, 'D_ETICA' AS asig, 'KENIA CASTILLO' AS doc
  UNION ALL SELECT 'Transición' AS grupo, 2 AS dia, '11:10' AS ini, '12:00' AS fin, 'D_COG' AS asig, 'KENIA CASTILLO' AS doc
  UNION ALL SELECT 'Transición' AS grupo, 3 AS dia, '11:10' AS ini, '12:00' AS fin, 'D_COG' AS asig, 'KENIA CASTILLO' AS doc
  UNION ALL SELECT 'Transición' AS grupo, 4 AS dia, '07:00' AS ini, '08:00' AS fin, 'D_COM' AS asig, 'KENIA CASTILLO' AS doc
  UNION ALL SELECT 'Transición' AS grupo, 4 AS dia, '08:00' AS ini, '08:40' AS fin, 'D_COM' AS asig, 'KENIA CASTILLO' AS doc
  UNION ALL SELECT 'Transición' AS grupo, 4 AS dia, '11:10' AS ini, '12:00' AS fin, 'D_COG' AS asig, 'KENIA CASTILLO' AS doc
  UNION ALL SELECT 'Transición' AS grupo, 5 AS dia, '07:00' AS ini, '08:00' AS fin, 'D_COG' AS asig, 'KENIA CASTILLO' AS doc
  UNION ALL SELECT 'Transición' AS grupo, 5 AS dia, '08:00' AS ini, '08:40' AS fin, 'D_COG' AS asig, 'KENIA CASTILLO' AS doc
  UNION ALL SELECT 'Transición' AS grupo, 5 AS dia, '11:10' AS ini, '12:00' AS fin, 'D_ETICA' AS asig, 'KENIA CASTILLO' AS doc
  UNION ALL SELECT '9A' AS grupo, 2 AS dia, '09:35' AS ini, '10:30' AS fin, 'L_CAST' AS asig, 'ANA GOMEZ' AS doc
  UNION ALL SELECT '9A' AS grupo, 2 AS dia, '10:30' AS ini, '11:20' AS fin, 'VAR_ac9a1d53' AS asig, NULL AS doc
  UNION ALL SELECT '11A' AS grupo, 2 AS dia, '10:30' AS ini, '11:20' AS fin, 'VAR_0ed3eb2b' AS asig, NULL AS doc
  UNION ALL SELECT '9A' AS grupo, 2 AS dia, '11:40' AS ini, '12:40' AS fin, 'VAR_048498ea' AS asig, 'ANA GOMEZ' AS doc
  UNION ALL SELECT '11B' AS grupo, 2 AS dia, '13:00' AS ini, '13:45' AS fin, 'L_CAST' AS asig, 'ANA GOMEZ' AS doc
  UNION ALL SELECT 'Jardín' AS grupo, 1 AS dia, '07:00' AS ini, '08:00' AS fin, 'VAR_518787a8' AS asig, 'AURA CARABALLO' AS doc
  UNION ALL SELECT 'Jardín' AS grupo, 1 AS dia, '09:00' AS ini, '10:00' AS fin, 'VAR_c93088e8' AS asig, 'AURA CARABALLO' AS doc
  UNION ALL SELECT 'Jardín' AS grupo, 1 AS dia, '10:00' AS ini, '10:45' AS fin, 'VAR_c93088e8' AS asig, 'AURA CARABALLO' AS doc
  UNION ALL SELECT '2A' AS grupo, 1 AS dia, '09:05' AS ini, '10:00' AS fin, 'VAR_cb6780c7' AS asig, NULL AS doc
  UNION ALL SELECT '1A' AS grupo, 1 AS dia, '09:05' AS ini, '10:00' AS fin, 'INGLES' AS asig, 'GISELLA CARTAGENA' AS doc
  UNION ALL SELECT 'Transición' AS grupo, 1 AS dia, '09:00' AS ini, '10:00' AS fin, 'VAR_cf491399' AS asig, NULL AS doc
  UNION ALL SELECT '4A' AS grupo, 1 AS dia, '09:05' AS ini, '10:00' AS fin, 'VAR_a8c8e9de' AS asig, NULL AS doc
  UNION ALL SELECT '4A' AS grupo, 1 AS dia, '10:00' AS ini, '11:00' AS fin, 'VAR_7f9f3c20' AS asig, NULL AS doc
  UNION ALL SELECT '1A' AS grupo, 1 AS dia, '10:00' AS ini, '11:00' AS fin, 'INGLES' AS asig, 'GISELLA CARTAGENA' AS doc
  UNION ALL SELECT 'Transición' AS grupo, 1 AS dia, '10:00' AS ini, '10:45' AS fin, 'VAR_cf491399' AS asig, NULL AS doc
  UNION ALL SELECT '2A' AS grupo, 1 AS dia, '10:00' AS ini, '11:00' AS fin, 'VAR_660c15b8' AS asig, NULL AS doc
  UNION ALL SELECT '5A' AS grupo, 1 AS dia, '09:05' AS ini, '10:00' AS fin, 'VAR_e8c68cf9' AS asig, NULL AS doc
  UNION ALL SELECT 'Transición' AS grupo, 1 AS dia, '07:00' AS ini, '08:00' AS fin, 'VAR_d6071385' AS asig, 'KENIA CASTILLO' AS doc
  UNION ALL SELECT 'Transición' AS grupo, 1 AS dia, '08:00' AS ini, '08:40' AS fin, 'VAR_00e1b018' AS asig, 'KENIA CASTILLO' AS doc
  UNION ALL SELECT '11B' AS grupo, 3 AS dia, '12:15' AS ini, '13:00' AS fin, 'TEC_INFO' AS asig, 'LAURA GONZALEZ' AS doc
  UNION ALL SELECT '10A' AS grupo, 2 AS dia, '06:45' AS ini, '07:35' AS fin, 'MATEM' AS asig, 'MANUEL WARNES' AS doc
  UNION ALL SELECT '11A' AS grupo, 2 AS dia, '09:35' AS ini, '10:30' AS fin, 'MATEM' AS asig, 'MANUEL WARNES' AS doc
  UNION ALL SELECT '8A' AS grupo, 2 AS dia, '09:35' AS ini, '10:30' AS fin, 'EMPREND' AS asig, 'MANUEL WARNES' AS doc
  UNION ALL SELECT '11B' AS grupo, 2 AS dia, '11:20' AS ini, '12:00' AS fin, 'MATEM' AS asig, 'MANUEL WARNES' AS doc
  UNION ALL SELECT '10A' AS grupo, 2 AS dia, '11:20' AS ini, '12:00' AS fin, 'MATEM' AS asig, 'MANUEL WARNES' AS doc
  UNION ALL SELECT '5A' AS grupo, 1 AS dia, '10:00' AS ini, '11:00' AS fin, 'VAR_b231106e' AS asig, 'MARIA CLAUDIA' AS doc
  UNION ALL SELECT '10A' AS grupo, 1 AS dia, '12:15' AS ini, '13:00' AS fin, 'FISICA' AS asig, 'MAURICIO CUADRADO' AS doc
  UNION ALL SELECT '8A' AS grupo, 1 AS dia, '09:35' AS ini, '10:30' AS fin, 'VAR_ea677e30' AS asig, NULL AS doc
  UNION ALL SELECT '8A' AS grupo, 1 AS dia, '10:30' AS ini, '11:20' AS fin, 'L_CAST' AS asig, 'PETRONA ALTAMIRANDA' AS doc
  UNION ALL SELECT '11A' AS grupo, 1 AS dia, '09:35' AS ini, '10:30' AS fin, 'C_NAT' AS asig, 'SHIRLEY PEDROZA' AS doc
  UNION ALL SELECT '6A' AS grupo, 4 AS dia, '10:30' AS ini, '11:20' AS fin, 'ETICA' AS asig, 'WENDY PERTUZ' AS doc
  UNION ALL SELECT '9A' AS grupo, 4 AS dia, '10:30' AS ini, '11:20' AS fin, 'ARTIST' AS asig, 'WENDY PERTUZ' AS doc
) v
JOIN grupos g ON g.nombre = v.grupo COLLATE utf8mb4_unicode_ci
JOIN franjas_horarias f ON f.nivel_id = g.nivel_id AND f.hora_inicio = v.ini AND f.hora_fin = v.fin
JOIN asignaturas a ON a.codigo_excel = v.asig COLLATE utf8mb4_unicode_ci
LEFT JOIN docentes d ON d.codigo_excel = v.doc COLLATE utf8mb4_unicode_ci;

COMMIT;
