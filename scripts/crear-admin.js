// Crea o actualiza una cuenta del panel y muestra una contraseña temporal.
// Uso: node scripts/crear-admin.js "Laura González" correo@colegiovisionmundial.edu.co docente_encargada
//      node scripts/crear-admin.js "Abraham Candanoza" correo@... estudiante_admin
const crypto = require('crypto');
const bcrypt = require('bcryptjs');
const { consulta, pool } = require('../src/db');

(async () => {
  const [nombre, correo, rol] = process.argv.slice(2);
  if (!nombre || !correo || !['docente_encargada', 'estudiante_admin'].includes(rol)) {
    console.error('Uso: node scripts/crear-admin.js "Nombre" correo docente_encargada|estudiante_admin');
    process.exit(1);
  }
  const contrasena = crypto.randomBytes(9).toString('base64url');
  const hash = await bcrypt.hash(contrasena, 10);
  await consulta(
    `INSERT INTO administradores (nombre, correo, contrasena_hash, rol) VALUES (?, ?, ?, ?)
     ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), contrasena_hash = VALUES(contrasena_hash), rol = VALUES(rol), activo = 1`,
    [nombre, correo.toLowerCase(), hash, rol]);
  console.log(`Cuenta lista para ${nombre} (${correo}). Contraseña temporal: ${contrasena}`);
  await pool.end();
})().catch(async (e) => { console.error(e.message); await pool.end(); process.exit(1); });
