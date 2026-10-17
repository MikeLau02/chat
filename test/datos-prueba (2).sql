-- SOLO PARA PRUEBAS LOCALES: datos inventados de horario y contenidos.
-- Los datos reales salen del Excel "HORARIO 2026" y del manual.
USE chatbot_vm;
SET NAMES utf8mb4;
INSERT INTO franjas_horarias (nivel_id, numero, hora_inicio, hora_fin, es_descanso) VALUES
  (4, 1, '06:45', '07:35', 0), (4, 2, '07:35', '08:25', 0), (4, 3, '08:25', '08:55', 1), (4, 4, '08:55', '09:45', 0);
INSERT INTO grupos (nivel_id, nombre, alias, orden) VALUES (4, '11B', 'once b', 16), (4, '10A', 'decimo a', 13);
INSERT INTO asignaturas (codigo_excel, nombre) VALUES ('MAT', 'Matemáticas'), ('L_CAST', 'Lengua Castellana');
INSERT INTO docentes (codigo_excel, nombre_mostrar, activo) VALUES ('L-GONZALEZ', 'Prof. Laura González', 1), ('RETIRADO', 'Prof. Retirado', 0);
INSERT INTO horarios (grupo_id, dia_semana, franja_id, asignatura_id, docente_id) VALUES
  (1, 2, 1, 1, 1), (1, 2, 2, 2, 2), (1, 2, 4, 1, 1), (2, 2, 1, 2, 1);
INSERT INTO contenidos (categoria_id, titulo, texto, referencia) VALUES
  (13, 'Uniforme de diario', 'Camisa blanca con el escudo del colegio y jean azul.', '3.1');
INSERT INTO actividades (titulo, fecha, publicada, imagen_url) VALUES
  ('Family Day', DATE_ADD(CURDATE(), INTERVAL 3 DAY), 1, 'https://example.com/comunicado.jpg'),
  ('Entrega de boletines', DATE_ADD(CURDATE(), INTERVAL 7 DAY), 1, NULL);
