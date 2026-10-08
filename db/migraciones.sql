-- Cambios a la base que se aplican solos al arrancar (src/instalar.js).
-- Cada sentencia debe poder ejecutarse varias veces.
SET NAMES utf8mb4;

-- Imágenes de horario por grupo y PDF de circulares subidos en el panel.
CREATE TABLE IF NOT EXISTS archivos (
  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  tipo        VARCHAR(20) NOT NULL,                -- 'horario_grupo' | 'circular'
  ref_id      INT UNSIGNED NOT NULL,               -- id del grupo o de la circular
  nombre      VARCHAR(120) NOT NULL,
  mime        VARCHAR(60) NOT NULL,
  tamano      INT UNSIGNED NOT NULL,
  token       CHAR(32) NOT NULL,                   -- va en la URL pública; cambia en cada subida
  datos       MEDIUMBLOB NOT NULL,
  subido_por  INT UNSIGNED NULL,
  creado_en   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_archivo (tipo, ref_id),
  UNIQUE KEY uq_archivo_token (token)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
