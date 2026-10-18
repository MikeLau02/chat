const mysql = require('mysql2/promise');
const { databaseUrl } = require('./config');

// Los servicios en la nube (por ejemplo Aiven) entregan una URL con
// "?ssl-mode=REQUIRED": se quita de la URL y se activa SSL.
function opciones(url) {
  const u = new URL(url);
  const pideSsl = /required|verify/i.test(u.searchParams.get('ssl-mode') || '') || process.env.DATABASE_SSL === 'true';
  u.searchParams.delete('ssl-mode');
  return {
    uri: u.toString(),
    ssl: pideSsl ? { rejectUnauthorized: false } : undefined,
  };
}

const pool = mysql.createPool({
  ...opciones(databaseUrl),
  connectionLimit: 5,
  charset: 'utf8mb4',
  timezone: '-05:00',
  dateStrings: true,
});

// La base guarda y compara fechas en hora de Colombia (CURDATE, NOW).
pool.pool.on('connection', (conexion) => conexion.query("SET time_zone = '-05:00'"));

async function consulta(sql, params = []) {
  const [filas] = await pool.execute(sql, params);
  return filas;
}

async function una(sql, params = []) {
  const filas = await consulta(sql, params);
  return filas[0] || null;
}

module.exports = { pool, consulta, una, opciones };
