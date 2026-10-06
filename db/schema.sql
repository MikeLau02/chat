-- =====================================================================
-- Chatbot institucional - Colegio Visión Mundial (Montería)
-- Esquema MySQL 8 - modelo simplificado v2 (20 tablas)
-- Piloto: 30 de septiembre al 14 de octubre de 2026
--
-- Reglas generales:
--   * Nada se borra desde el panel: los registros se desactivan (activo = 0).
--   * Contraseñas con bcrypt (solo se guarda el hash).
--   * El número de WhatsApp del bot NO se guarda aquí: va en variables
--     de entorno (WHATSAPP_PHONE_NUMBER_ID, WHATSAPP_TOKEN, etc.).
-- =====================================================================

CREATE DATABASE IF NOT EXISTS chatbot_vm
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE chatbot_vm;

SET NAMES utf8mb4;
SET time_zone = '-05:00';  -- Hora de Colombia

-- ---------------------------------------------------------------------
-- 1. ADMINISTRACIÓN
-- ---------------------------------------------------------------------

CREATE TABLE administradores (
  id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre          VARCHAR(120) NOT NULL,
  correo          VARCHAR(160) NOT NULL,
  contrasena_hash VARCHAR(255) NOT NULL,
  rol             ENUM('docente_encargada','estudiante_admin') NOT NULL,
  activo          TINYINT(1) NOT NULL DEFAULT 1,
  ultimo_acceso   DATETIME NULL,
  creado_en       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_administradores_correo (correo)
) ENGINE=InnoDB;

CREATE TABLE configuracion (
  clave           VARCHAR(60) PRIMARY KEY,
  valor           TEXT NOT NULL,
  descripcion     VARCHAR(255) NULL,
  actualizado_en  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE enlaces (
  id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  clave           VARCHAR(60) NOT NULL,
  titulo          VARCHAR(160) NOT NULL,
  url             VARCHAR(500) NOT NULL,
  descripcion     VARCHAR(255) NULL,
  activo          TINYINT(1) NOT NULL DEFAULT 1,
  actualizado_en  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_enlaces_clave (clave)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 2. HORARIOS
-- ---------------------------------------------------------------------

CREATE TABLE niveles (
  id      TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre  VARCHAR(40) NOT NULL,
  orden   TINYINT UNSIGNED NOT NULL,
  UNIQUE KEY uq_niveles_nombre (nombre)
) ENGINE=InnoDB;

CREATE TABLE franjas_horarias (
  id           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nivel_id     TINYINT UNSIGNED NOT NULL,
  numero       TINYINT UNSIGNED NOT NULL,          -- orden de la franja en el día
  hora_inicio  TIME NOT NULL,
  hora_fin     TIME NOT NULL,
  es_descanso  TINYINT(1) NOT NULL DEFAULT 0,
  UNIQUE KEY uq_franja (nivel_id, numero),
  CONSTRAINT fk_franjas_nivel FOREIGN KEY (nivel_id) REFERENCES niveles(id),
  CONSTRAINT ck_franja_horas CHECK (hora_fin > hora_inicio)
) ENGINE=InnoDB;

CREATE TABLE grupos (
  id        INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nivel_id  TINYINT UNSIGNED NOT NULL,
  nombre    VARCHAR(30) NOT NULL,                  -- "Jardín", "4B", "11A"
  alias     VARCHAR(255) NULL,                     -- separados por "|": "4-b|cuarto b|4 b"
  orden     TINYINT UNSIGNED NOT NULL,
  activo    TINYINT(1) NOT NULL DEFAULT 1,
  UNIQUE KEY uq_grupos_nombre (nombre),
  CONSTRAINT fk_grupos_nivel FOREIGN KEY (nivel_id) REFERENCES niveles(id)
) ENGINE=InnoDB;

CREATE TABLE asignaturas (
  id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  codigo_excel  VARCHAR(30) NOT NULL,              -- "L_CAST", "TEC_INFO"
  nombre        VARCHAR(100) NOT NULL,             -- "Lengua Castellana"
  activo        TINYINT(1) NOT NULL DEFAULT 1,
  UNIQUE KEY uq_asignaturas_codigo (codigo_excel)
) ENGINE=InnoDB;

CREATE TABLE docentes (
  id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  codigo_excel    VARCHAR(40) NOT NULL,            -- "L-GONZALEZ", "DMAZA"
  nombre_mostrar  VARCHAR(120) NOT NULL,           -- "Prof. Laura González"
  activo          TINYINT(1) NOT NULL DEFAULT 1,   -- 0 = ya no hace parte del plantel
  UNIQUE KEY uq_docentes_codigo (codigo_excel)
) ENGINE=InnoDB;

CREATE TABLE horarios (
  id             INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  grupo_id       INT UNSIGNED NOT NULL,
  dia_semana     TINYINT UNSIGNED NOT NULL,        -- 1 = lunes ... 5 = viernes
  franja_id      INT UNSIGNED NOT NULL,
  asignatura_id  INT UNSIGNED NOT NULL,
  docente_id     INT UNSIGNED NULL,                -- NULL = docente que ya no está; se muestra solo la asignatura
  UNIQUE KEY uq_horario (grupo_id, dia_semana, franja_id),
  KEY ix_horario_docente (docente_id, dia_semana),
  CONSTRAINT fk_horario_grupo      FOREIGN KEY (grupo_id)      REFERENCES grupos(id),
  CONSTRAINT fk_horario_franja     FOREIGN KEY (franja_id)     REFERENCES franjas_horarias(id),
  CONSTRAINT fk_horario_asignatura FOREIGN KEY (asignatura_id) REFERENCES asignaturas(id),
  CONSTRAINT fk_horario_docente    FOREIGN KEY (docente_id)    REFERENCES docentes(id),
  CONSTRAINT ck_horario_dia CHECK (dia_semana BETWEEN 1 AND 5)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 3. CIRCULARES Y PLATAFORMAS
-- ---------------------------------------------------------------------

CREATE TABLE circulares (
  id                 INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  numero             VARCHAR(20) NOT NULL,
  titulo             VARCHAR(200) NOT NULL,
  fecha_publicacion  DATE NOT NULL,
  archivo_url        VARCHAR(500) NULL,            -- URL pública del PDF que envía el bot
  es_actual          TINYINT(1) NOT NULL DEFAULT 0,
  -- Solo una circular puede estar marcada como actual:
  actual_unica       TINYINT GENERATED ALWAYS AS (IF(es_actual = 1, 1, NULL)) STORED,
  creado_en          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_circulares_numero (numero),
  UNIQUE KEY uq_circular_actual (actual_unica)
) ENGINE=InnoDB;

CREATE TABLE plataformas (
  id                  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre              VARCHAR(80) NOT NULL,
  descripcion         TEXT NULL,
  url                 VARCHAR(500) NULL,
  instrucciones       TEXT NULL,
  recuperacion_clave  TEXT NULL,
  app_movil           VARCHAR(255) NULL,
  orden               TINYINT UNSIGNED NOT NULL DEFAULT 0,
  activo              TINYINT(1) NOT NULL DEFAULT 1,
  UNIQUE KEY uq_plataformas_nombre (nombre)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 4. CONTENIDOS (identidad y manual de convivencia)
-- ---------------------------------------------------------------------

CREATE TABLE categorias (
  id      INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  modulo  ENUM('identidad','manual') NOT NULL,
  nombre  VARCHAR(120) NOT NULL,
  orden   TINYINT UNSIGNED NOT NULL DEFAULT 0,
  activo  TINYINT(1) NOT NULL DEFAULT 1,
  UNIQUE KEY uq_categoria (modulo, nombre)
) ENGINE=InnoDB;

CREATE TABLE contenidos (
  id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  categoria_id    INT UNSIGNED NOT NULL,
  titulo          VARCHAR(200) NOT NULL,
  texto           TEXT NOT NULL,
  referencia      VARCHAR(40) NULL,                -- numeral del manual, ej. "2.5"
  palabras_clave  VARCHAR(500) NULL,
  orden           TINYINT UNSIGNED NOT NULL DEFAULT 0,
  activo          TINYINT(1) NOT NULL DEFAULT 1,
  actualizado_en  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY ix_contenidos_categoria (categoria_id, orden),
  FULLTEXT KEY ft_contenidos (titulo, texto, palabras_clave),
  CONSTRAINT fk_contenidos_categoria FOREIGN KEY (categoria_id) REFERENCES categorias(id)
) ENGINE=InnoDB;

-- Reemplaza la IA: cada término lleva a un destino del menú.
-- destino: "modulo:horarios", "categoria:12", "contenido:45", "enlace:pqrs_formulario"
CREATE TABLE palabras_clave (
  id       INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  termino  VARCHAR(80) NOT NULL,                   -- en minúsculas y sin tildes
  destino  VARCHAR(80) NOT NULL,
  activo   TINYINT(1) NOT NULL DEFAULT 1,
  UNIQUE KEY uq_palabras_termino (termino)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 5. USO (datos mínimos para el análisis de utilidad)
-- Los teléfonos se borran 30 días después de cerrar el piloto.
-- ---------------------------------------------------------------------

CREATE TABLE usuarios_whatsapp (
  id                  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  telefono            VARCHAR(20) NOT NULL,        -- formato E.164 sin "+": 573001234567
  grupo_preferido_id  INT UNSIGNED NULL,
  primer_contacto     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ultimo_contacto     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_usuarios_telefono (telefono),
  CONSTRAINT fk_usuarios_grupo FOREIGN KEY (grupo_preferido_id) REFERENCES grupos(id)
    ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE conversaciones (
  id                INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  usuario_id        INT UNSIGNED NOT NULL,
  paso_actual       VARCHAR(60) NOT NULL DEFAULT 'menu',
  datos_temporales  JSON NULL,
  expira_en         DATETIME NOT NULL,
  UNIQUE KEY uq_conversacion_usuario (usuario_id),
  CONSTRAINT fk_conversaciones_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios_whatsapp(id)
    ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE interacciones (
  id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  usuario_id  INT UNSIGNED NULL,                   -- queda NULL al borrar los teléfonos; se conservan las cifras
  modulo      ENUM('menu','circulares','horarios','plataformas','evaluacion_docente',
                   'manual','identidad','pqrs','proxima_actividad','asesor','sin_respuesta') NOT NULL,
  opcion      VARCHAR(80) NULL,
  fecha       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY ix_interacciones_fecha (fecha),
  KEY ix_interacciones_modulo (modulo, fecha),
  CONSTRAINT fk_interacciones_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios_whatsapp(id)
    ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE consultas_sin_respuesta (
  id      INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  texto   VARCHAR(1000) NOT NULL,
  fecha   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  estado  ENUM('pendiente','revisada','agregada') NOT NULL DEFAULT 'pendiente',
  KEY ix_sin_respuesta_estado (estado, fecha)
) ENGINE=InnoDB;

CREATE TABLE solicitudes_asesor (
  id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  usuario_id    INT UNSIGNED NULL,
  fecha         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  estado        ENUM('pendiente','en_atencion','atendida') NOT NULL DEFAULT 'pendiente',
  mensaje       VARCHAR(1000) NULL,                -- lo que la persona quiere preguntar
  respuesta     TEXT NULL,                         -- lo que se le respondió desde el panel
  atendida_por  INT UNSIGNED NULL,
  atendida_en   DATETIME NULL,
  KEY ix_asesor_estado (estado, fecha),
  CONSTRAINT fk_asesor_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios_whatsapp(id)
    ON DELETE SET NULL,
  CONSTRAINT fk_asesor_admin FOREIGN KEY (atendida_por) REFERENCES administradores(id)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 6. PRÓXIMA ACTIVIDAD
-- El bot muestra la publicada con fecha más cercana desde hoy:
--   SELECT * FROM actividades
--    WHERE publicada = 1 AND fecha >= CURDATE()
--    ORDER BY fecha, hora_inicio LIMIT 1;   -- LIMIT 1, 3 para "ver las siguientes"
-- ---------------------------------------------------------------------

CREATE TABLE actividades (
  id                   INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  titulo               VARCHAR(200) NOT NULL,
  descripcion          TEXT NULL,
  materiales           TEXT NULL,
  recordatorios        TEXT NULL,
  fecha                DATE NOT NULL,
  hora_inicio          TIME NULL,
  hora_fin             TIME NULL,
  lugar                VARCHAR(160) NULL,
  dirigido_a           VARCHAR(160) NULL,
  enlace_url           VARCHAR(500) NULL,
  imagen_url           VARCHAR(500) NULL,          -- comunicado completo, se envía solo si lo piden
  publicada            TINYINT(1) NOT NULL DEFAULT 1,
  creada_por           INT UNSIGNED NULL,
  fecha_actualizacion  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY ix_actividades_proxima (publicada, fecha, hora_inicio),
  CONSTRAINT fk_actividades_admin FOREIGN KEY (creada_por) REFERENCES administradores(id)
) ENGINE=InnoDB;

-- =====================================================================
-- DATOS INICIALES (solo lo ya confirmado en el análisis v2)
-- Administradores: se crean con el script del panel, que genera el hash.
-- Horarios: los carga el script de "HORARIO 2026".
-- =====================================================================

INSERT INTO niveles (nombre, orden) VALUES
  ('Preescolar', 1), ('Primaria', 2), ('Secundaria', 3), ('Media', 4);

INSERT INTO configuracion (clave, valor, descripcion) VALUES
  ('bienvenida',
   '¡Hola! 👋 Soy el asistente virtual del Colegio Visión Mundial. Elige una opción escribiendo su número:',
   'Saludo del primer mensaje'),
  ('aviso_datos',
   'Registramos tus consultas solo para mejorar este servicio. Política de datos: {enlace:politica_datos}',
   'Aviso de tratamiento de datos (Ley 1581 de 2012)'),
  ('sin_respuesta',
   'No encontré información sobre eso. Elige una opción del menú o escribe *asesor* para que una persona del colegio te atienda.',
   'Respuesta cuando el bot no entiende'),
  ('horario_atencion', 'Pendiente de definir', 'Horario en que Abraham Candanoza atiende solicitudes de asesor'),
  ('direccion', 'Cra. 14C #12-9, Barrio 6 de Marzo, Montería', 'Dirección oficial'),
  ('telefono', '+57 310 2167827', 'Teléfono del membrete'),
  ('correo', 'comunicaciones@colegiovisionmundial.edu.co', 'Correo del membrete'),
  ('hora_ingreso', 'El ingreso es a las 6:45 a.m.; los estudiantes deben llegar 10 minutos antes (6:35 a.m.).', 'Jornada'),
  ('pqrs_plazo', '5 días hábiles', 'Plazo de respuesta de PQRS'),
  ('fin_piloto', '2026-10-14', 'Último día del piloto');

INSERT INTO enlaces (clave, titulo, url, descripcion) VALUES
  ('evaluacion_docente', 'Evaluación docente',
   'https://www.colegiovisionmundial.edu.co/evaluacion-docente', 'Formulario de evaluación docente'),
  ('pqrs_formulario', 'Formulario de PQRS',
   'https://docs.google.com/forms/d/e/1FAIpQLSdgx49L3GGk8F8-cfjRCiKzXaYDuza5k_OKOXQs7LSAaIvZMQ/viewform', NULL),
  ('pqrs_correo', 'Correo de PQRS', 'mailto:soporte@colegiovisionmundial.edu.co', NULL),
  ('comunicaciones', 'Comunicaciones (todas las circulares)',
   'https://www.colegiovisionmundial.edu.co/comunicaciones', NULL),
  ('politica_datos', 'Política de tratamiento de datos',
   'https://www.colegiovisionmundial.edu.co', 'Pendiente: URL exacta de la política');

INSERT INTO circulares (numero, titulo, fecha_publicacion, archivo_url, es_actual) VALUES
  ('09', 'Primer Family Day – Semana Visionaria', '2026-09-25', NULL, 1);

INSERT INTO plataformas (nombre, orden) VALUES
  ('EducaCity', 1), ('Google Classroom', 2);

INSERT INTO categorias (modulo, nombre, orden) VALUES
  ('identidad', 'Misión', 1),
  ('identidad', 'Visión', 2),
  ('identidad', 'Principios', 3),
  ('identidad', 'Propósitos', 4),
  ('identidad', 'Valores', 5),
  ('identidad', 'Objetivos', 6),
  ('identidad', 'Perfil del egresado', 7),
  ('identidad', 'Himno y emblemas', 8),
  ('identidad', 'Marco legal', 9),
  ('identidad', 'Datos del colegio', 10),
  ('manual', 'Derechos y deberes', 1),
  ('manual', 'Gobierno escolar', 2),
  ('manual', 'Uniforme y presentación personal', 3),
  ('manual', 'Salud y cuidado del entorno', 4),
  ('manual', 'Resolución de conflictos', 5),
  ('manual', 'Sanciones y derecho a la defensa', 6),
  ('manual', 'Servicios complementarios', 7),
  ('manual', 'Situaciones Tipo I, II y III', 8),
  ('manual', 'Directorio de entidades', 9);

INSERT INTO palabras_clave (termino, destino) VALUES
  ('circular', 'modulo:circulares'),
  ('circulares', 'modulo:circulares'),
  ('horario', 'modulo:horarios'),
  ('horarios', 'modulo:horarios'),
  ('plataforma', 'modulo:plataformas'),
  ('educacity', 'modulo:plataformas'),
  ('classroom', 'modulo:plataformas'),
  ('evaluacion', 'enlace:evaluacion_docente'),
  ('manual', 'modulo:manual'),
  ('convivencia', 'modulo:manual'),
  ('mision', 'modulo:identidad'),
  ('vision', 'modulo:identidad'),
  ('pqrs', 'modulo:pqrs'),
  ('queja', 'modulo:pqrs'),
  ('reclamo', 'modulo:pqrs'),
  ('actividad', 'modulo:proxima_actividad'),
  ('proxima actividad', 'modulo:proxima_actividad'),
  ('eventos', 'modulo:proxima_actividad'),
  ('asesor', 'modulo:asesor');

-- Palabras que llevan directo a un tema del manual
INSERT INTO palabras_clave (termino, destino)
SELECT t.termino, CONCAT('categoria:', c.id)
  FROM (SELECT 'uniforme' AS termino, 'Uniforme y presentación personal' AS categoria
        UNION ALL SELECT 'presentacion personal', 'Uniforme y presentación personal'
        UNION ALL SELECT 'acoso', 'Situaciones Tipo I, II y III'
        UNION ALL SELECT 'bullying', 'Situaciones Tipo I, II y III'
        UNION ALL SELECT 'matoneo', 'Situaciones Tipo I, II y III'
        UNION ALL SELECT 'pelea', 'Resolución de conflictos'
        UNION ALL SELECT 'conflicto', 'Resolución de conflictos'
        UNION ALL SELECT 'sancion', 'Sanciones y derecho a la defensa'
        UNION ALL SELECT 'personero', 'Gobierno escolar'
        UNION ALL SELECT 'gobierno escolar', 'Gobierno escolar'
        UNION ALL SELECT 'derechos', 'Derechos y deberes'
        UNION ALL SELECT 'deberes', 'Derechos y deberes') t
  JOIN categorias c ON c.modulo = 'manual' AND c.nombre = t.categoria COLLATE utf8mb4_unicode_ci;

INSERT INTO actividades
  (titulo, descripcion, materiales, recordatorios, fecha, lugar, dirigido_a, enlace_url)
VALUES
  ('Misión Colegio Verde y Día Deportivo',
   '1) Devocional Comunitario y apertura del Mes de la Biblia, dirigido por 11A y 11B. 2) Misión Colegio Verde: brigadas por grado para aseo, ornamentación y embellecimiento. 3) Primer Torneo de Ping-Pong Visionario, fase eliminatoria.',
   'Escobas, recogedores y bolsas grandes; guantes, alcohol y paños; abono, macetas y plantas; pintura de aceite, brochas, rodillos y tíner (por equipos).',
   'Sudadera de Educación Física y camiseta de los partidos (o uniforme completo). No se permite traer celular.',
   '2026-10-01', 'Colegio', 'Estudiantes de todos los grados',
   'https://forms.gle/aRBVP7PsEkcHYdws6');
