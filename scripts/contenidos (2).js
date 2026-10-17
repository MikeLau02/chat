// Convierte contenidos.json (textos del manual de convivencia y de la identidad
// institucional) en db/contenidos.sql. El servidor lo vuelve a cargar solo cuando cambia.
//
// Uso: node scripts/contenidos.js <contenidos.json> <db/contenidos.sql>
const fs = require('fs');

const [entrada, salida] = process.argv.slice(2);
if (!entrada || !salida) {
  console.error('Uso: node scripts/contenidos.js <contenidos.json> <db/contenidos.sql>');
  process.exit(1);
}

const sql = (v) => (v === null || v === undefined ? 'NULL' : `'${String(v).replace(/\\/g, '\\\\').replace(/'/g, "''")}'`);
const items = JSON.parse(fs.readFileSync(entrada, 'utf8'));

const orden = {};
const filas = items.map((c) => {
  const k = `${c.modulo}|${c.categoria}`;
  orden[k] = (orden[k] || 0) + 1;
  return `  ${filasSql(c, orden[k])}`;
});

function filasSql(c, n) {
  return `SELECT ${sql(c.modulo)} AS modulo, ${sql(c.categoria)} AS categoria, ${sql(c.titulo)} AS titulo, ` +
    `${sql(c.texto)} AS texto, ${sql(c.referencia)} AS referencia, ${sql(c.palabras_clave)} AS palabras, ${n} AS orden`;
}

const lineas = [
  '-- Generado por scripts/contenidos.js a partir de contenidos.json. No editar a mano.',
  '-- Se puede ejecutar varias veces: reemplaza todos los contenidos.',
  'SET NAMES utf8mb4;',
  'START TRANSACTION;',
  'DELETE FROM contenidos;',
  'INSERT INTO contenidos (categoria_id, titulo, texto, referencia, palabras_clave, orden)',
  'SELECT k.id, v.titulo, v.texto, v.referencia, v.palabras, v.orden FROM (',
  filas.map((f, i) => (i ? f.replace(/^ {2}/, '  UNION ALL ') : f)).join('\n'),
  ') v',
  'JOIN categorias k ON k.modulo = v.modulo COLLATE utf8mb4_unicode_ci AND k.nombre = v.categoria COLLATE utf8mb4_unicode_ci;',
  'COMMIT;',
  '',
];
fs.writeFileSync(salida, lineas.join('\n'));
console.log(`${items.length} contenidos en ${salida}`);
