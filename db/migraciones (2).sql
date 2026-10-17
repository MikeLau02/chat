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

-- Usuarios de WhatsApp con nombre de usuario: desde 2026 Meta puede no enviar el
-- teléfono y en su lugar manda un identificador por negocio (BSUID, p. ej. "CO.1234…").
-- Se guarda aparte; el teléfono pasa a ser opcional. También se guarda el nombre del perfil.
ALTER TABLE usuarios_whatsapp MODIFY telefono VARCHAR(20) NULL;
SET @falta := (SELECT COUNT(*) = 0 FROM information_schema.columns
                WHERE table_schema = DATABASE() AND table_name = 'usuarios_whatsapp' AND column_name = 'bsuid');
SET @sql := IF(@falta, 'ALTER TABLE usuarios_whatsapp ADD COLUMN bsuid VARCHAR(80) NULL AFTER telefono, ADD UNIQUE KEY uq_usuarios_bsuid (bsuid)', 'DO 0');
PREPARE paso FROM @sql; EXECUTE paso; DEALLOCATE PREPARE paso;
SET @falta := (SELECT COUNT(*) = 0 FROM information_schema.columns
                WHERE table_schema = DATABASE() AND table_name = 'usuarios_whatsapp' AND column_name = 'nombre');
SET @sql := IF(@falta, 'ALTER TABLE usuarios_whatsapp ADD COLUMN nombre VARCHAR(120) NULL AFTER bsuid', 'DO 0');
PREPARE paso FROM @sql; EXECUTE paso; DEALLOCATE PREPARE paso;

-- Historial: cada mensaje recibido y cada respuesta enviada (para métricas y control).
CREATE TABLE IF NOT EXISTS mensajes (
  id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  usuario_id  INT UNSIGNED NULL,
  direccion   ENUM('entrante','saliente') NOT NULL,
  tipo        VARCHAR(20) NOT NULL,                -- texto, imagen, documento, audio…
  texto       TEXT NULL,
  error       VARCHAR(500) NULL,                   -- si WhatsApp no aceptó la respuesta
  origen      VARCHAR(20) NOT NULL DEFAULT 'bot',  -- 'bot' o 'asesor' (respuesta desde el panel)
  fecha       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY ix_mensajes_usuario (usuario_id, fecha),
  KEY ix_mensajes_fecha (fecha),
  CONSTRAINT fk_mensajes_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios_whatsapp(id)
    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
