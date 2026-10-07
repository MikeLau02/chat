// Crea las tablas la primera vez que arranca el servidor y, en cada arranque,
// vuelve a cargar los archivos de datos (horario, contenidos) que hayan cambiado,
// para no tener que usar una terminal en el servicio de la nube.
const crypto = require('crypto');
const fs = require('fs');
const path = require('path');
const mysql = require('mysql2/promise');
const { databaseUrl } = require('./config');
const { opciones } = require('./db');

const CARPETA = path.join(__dirname, '..', 'db');

// Los archivos .sql traen "CREATE DATABASE" y "USE chatbot_vm" para uso local;
// en la nube se usan sobre la base que indica DATABASE_URL.
function adaptar(sql) {
  return sql
    .replace(/^CREATE DATABASE[\s\S]*?;\s*$/m, '')
    .replace(/^USE \w+;\s*$/gm, '');
}

// Archivos de datos que se recargan cuando cambian. Cada uno debe poder
// ejecutarse varias veces (borra y vuelve a insertar lo suyo).
const DATOS = ['horario_2026.sql', 'contenidos.sql'];

async function instalarSiHaceFalta() {
  const conexion = await mysql.createConnection({ ...opciones(databaseUrl), multipleStatements: true, charset: 'utf8mb4' });
  try {
    const [tablas] = await conexion.query("SHOW TABLES LIKE 'configuracion'");
    const nueva = !tablas.length;
    if (nueva) {
      console.log('Base vacía: creando tablas…');
      await conexion.query(adaptar(fs.readFileSync(path.join(CARPETA, 'schema.sql'), 'utf8')));
    }
    await conexion.query(`CREATE TABLE IF NOT EXISTS cargas_datos (
      archivo VARCHAR(60) PRIMARY KEY,
      huella CHAR(32) NOT NULL,
      cargado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    ) ENGINE=InnoDB`);
    for (const archivo of DATOS) {
      const ruta = path.join(CARPETA, archivo);
      if (!fs.existsSync(ruta)) continue;
      const texto = fs.readFileSync(ruta, 'utf8');
      const huella = crypto.createHash('md5').update(texto).digest('hex');
      const [[previa]] = await conexion.query('SELECT huella FROM cargas_datos WHERE archivo = ?', [archivo]);
      if (previa?.huella === huella) continue;
      console.log(`Cargando ${archivo}…`);
      await conexion.query(adaptar(texto));
      await conexion.query(
        'INSERT INTO cargas_datos (archivo, huella) VALUES (?, ?) ON DUPLICATE KEY UPDATE huella = VALUES(huella)',
        [archivo, huella]);
    }
    if (nueva) console.log('Base lista.');
    return nueva;
  } finally {
    await conexion.end();
  }
}

module.exports = { instalarSiHaceFalta, adaptar };
