// Crea las tablas y carga el horario la primera vez que arranca el servidor,
// para no tener que usar una terminal en el servicio de la nube.
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

async function instalarSiHaceFalta() {
  const conexion = await mysql.createConnection({ ...opciones(databaseUrl), multipleStatements: true, charset: 'utf8mb4' });
  try {
    const [tablas] = await conexion.query("SHOW TABLES LIKE 'configuracion'");
    if (tablas.length) return false;
    console.log('Base vacía: creando tablas y cargando el horario…');
    for (const archivo of ['schema.sql', 'horario_2026.sql']) {
      const ruta = path.join(CARPETA, archivo);
      if (fs.existsSync(ruta)) await conexion.query(adaptar(fs.readFileSync(ruta, 'utf8')));
    }
    console.log('Base lista.');
    return true;
  } finally {
    await conexion.end();
  }
}

module.exports = { instalarSiHaceFalta, adaptar };
