// Convierte horario_2026.csv (una fila por docente, día y periodo) en
// horario_2026.sql para la base del chatbot, y deja en horario_revisar.csv
// las filas que no se pueden cargar sin ayuda de una persona.
//
// Uso: node scripts/horario.js <horario_2026.csv> <carpeta de salida>
const fs = require('fs');
const path = require('path');

const [entrada, salida = '.'] = process.argv.slice(2);
if (!entrada) {
  console.error('Uso: node scripts/horario.js <horario_2026.csv> <carpeta de salida>');
  process.exit(1);
}

// ---------------------------------------------------------------------
// Catálogos
// ---------------------------------------------------------------------

// Código del CSV -> [código guardado, nombre]. El orden importa: primero los más largos.
const ASIGNATURAS = [
  ['TEC_INFO', 'TEC_INFO', 'Tecnología e Informática'],
  ['C_POLITICA', 'C_POLITICA', 'Ciencias Políticas'],
  ['ED_FISICA', 'ED_FISICA', 'Educación Física'],
  ['C_SOC', 'C_SOC', 'Ciencias Sociales'],
  ['C_NAT', 'C_NAT', 'Ciencias Naturales'],
  ['L_CAST', 'L_CAST', 'Lengua Castellana'],
  ['D[-_]ETICA', 'D_ETICA', 'Dimensión Ética'],
  ['D[-_]EST', 'D_EST', 'Dimensión Estética'],
  ['D[-_]COG', 'D_COG', 'Dimensión Cognitiva'],
  ['D[-_]COM', 'D_COM', 'Dimensión Comunicativa'],
  ['FILOSOFIA', 'FILOSOFIA', 'Filosofía'],
  ['ESTADIST', 'ESTADIST', 'Estadística'],
  ['ESTAD', 'ESTADIST', 'Estadística'],
  ['GEOMET', 'GEOMET', 'Geometría'],
  ['GEO', 'GEOMET', 'Geometría'],
  ['MATEM', 'MATEM', 'Matemáticas'],
  ['QUIM', 'QUIM', 'Química'],
  ['FISICA', 'FISICA', 'Física'],
  ['EMPREND', 'EMPREND', 'Emprendimiento'],
  ['ARTIST', 'ARTIST', 'Educación Artística'],
  ['INGLES', 'INGLES', 'Inglés'],
  ['RELIGI?', 'RELIG', 'Educación Religiosa'],
  ['ORIEN?', 'ORIE', 'Orientación de grupo'],
  ['ETICA?', 'ETICA', 'Ética y Valores'],
  ['TEC', 'TEC_INFO', 'Tecnología e Informática'],
];
const RE_ASIGNATURA = new RegExp(`(?<![A-Z])(${ASIGNATURAS.map((a) => a[0]).join('|')})(?![A-Z])`, 'g');

const RE_GRUPO = /(?<![0-9A-Z])(1[01]|[1-9])\s*°?\s*([AB])(?![A-Z0-9])|JARD[IÍ]N|TRANSICI[OÓ]N/g;

const NIVELES = { Preescolar: 1, Primaria: 2, Secundaria: 3, Media: 4 };
const ORDINALES = ['', 'primero', 'segundo', 'tercero', 'cuarto', 'quinto', 'sexto',
  'septimo', 'octavo', 'noveno', 'decimo', 'once'];
const DIAS = { lunes: 1, martes: 2, miercoles: 3, jueves: 4, viernes: 5 };

// Descansos de cada nivel (el CSV no los trae). Deducidos de los huecos entre
// clases el 5 de octubre de 2026; corregir aquí si el colegio indica otras horas.
const DESCANSOS = {
  Preescolar: [['08:40', '09:00'], ['10:45', '11:10']],
  Primaria: [['08:25', '09:05'], ['11:00', '11:20']],
  Secundaria: [['09:05', '09:35'], ['11:20', '11:40']],
  Media: [['09:05', '09:35'], ['12:00', '12:15']],
};

// Tildes de nombres propios que el CSV trae en mayúsculas sin tilde.
const TILDES = { GONZALEZ: 'González', GOMEZ: 'Gómez', PEREZ: 'Pérez', JESUS: 'Jesús', JOSE: 'José', MARIA: 'María' };

// ---------------------------------------------------------------------
// Utilidades
// ---------------------------------------------------------------------

const sinTildes = (t) => t.normalize('NFD').replace(/[̀-ͯ]/g, '');

function leerCsv(texto) {
  const filas = [];
  for (const linea of texto.split(/\r?\n/)) {
    if (!linea.trim()) continue;
    const celdas = [];
    let actual = '';
    let comillas = false;
    for (let i = 0; i < linea.length; i++) {
      const c = linea[i];
      if (c === '"' && linea[i + 1] === '"' && comillas) { actual += '"'; i++; }
      else if (c === '"') comillas = !comillas;
      else if (c === ',' && !comillas) { celdas.push(actual); actual = ''; }
      else actual += c;
    }
    celdas.push(actual);
    filas.push(celdas.map((c) => c.trim()));
  }
  return filas;
}

function nombreGrupo(texto) {
  const t = sinTildes(texto.toUpperCase());
  if (t.startsWith('JARDIN')) return 'Jardín';
  if (t.startsWith('TRANSICION')) return 'Transición';
  const m = t.match(/(1[01]|[1-9])\s*°?\s*([AB])/);
  return m ? `${m[1]}${m[2]}` : null;
}

function nivelDe(grupo) {
  if (grupo === 'Jardín' || grupo === 'Transición') return 'Preescolar';
  const n = parseInt(grupo, 10);
  if (n <= 5) return 'Primaria';
  if (n <= 9) return 'Secundaria';
  return 'Media';
}

function ordenGrupo(grupo) {
  if (grupo === 'Jardín') return 1;
  if (grupo === 'Transición') return 2;
  return 2 + parseInt(grupo, 10) * 2 + (grupo.endsWith('B') ? 1 : 0);
}

// "12:40 a 1:45" -> ['12:40', '13:45']. Las horas de 1 a 5 son de la tarde.
function rangoHoras(texto) {
  const m = String(texto).match(/^(\d{1,2}):(\d{2})\s*a\s*(\d{1,2}):(\d{2})$/);
  if (!m) return null;
  const h = (hh, mm) => {
    let n = Number(hh);
    if (n < 6) n += 12;
    return `${String(n).padStart(2, '0')}:${mm}`;
  };
  return [h(m[1], m[2]), h(m[3], m[4])];
}

function nombreDocente(texto) {
  const palabras = texto.split(/\s+/).map((p) => TILDES[p] || p.charAt(0) + p.slice(1).toLowerCase());
  return `Prof. ${palabras.join(' ')}`;
}

const sql = (v) => (v === null ? 'NULL' : `'${String(v).replace(/\\/g, '\\\\').replace(/'/g, "''")}'`);

// ---------------------------------------------------------------------
// Lectura e interpretación de cada fila
// ---------------------------------------------------------------------

const filas = leerCsv(fs.readFileSync(entrada, 'utf8'));
const encabezado = filas.shift().map((c) => sinTildes(c.toLowerCase()));
const col = (nombre) => encabezado.findIndex((c) => c.startsWith(nombre));
const iDoc = col('docente');
const iRol = col('asignatura');
const iDia = col('dia');
const iHora = col('hora');
const iClase = col('clases');
if ([iDoc, iRol, iDia, iHora, iClase].includes(-1)) {
  console.error('El CSV no tiene las columnas esperadas: Docente, Asignatura, Día, Periodo, Hora, Clases / actividades');
  process.exit(1);
}

const bloques = [];
const revisar = [];

filas.forEach((f, i) => {
  const numeroFila = i + 2;
  const docente = f[iDoc];
  const clase = f[iClase] || '';
  const motivo = (m) => revisar.push({ fila: numeroFila, docente, dia: f[iDia], hora: f[iHora], clase, motivo: m });

  const dia = DIAS[sinTildes(f[iDia].toLowerCase())];
  if (!dia) return motivo('Día no reconocido');

  const horas = rangoHoras(f[iHora]);
  if (!horas) return motivo('Hora vacía, doble o no determinada');

  const asignaturas = new Set();
  for (const m of sinTildes(clase.toUpperCase()).matchAll(RE_ASIGNATURA)) {
    asignaturas.add(ASIGNATURAS.find((a) => new RegExp(`^(${a[0]})$`).test(m[1])));
  }
  const grupos = new Set();
  for (const m of clase.toUpperCase().matchAll(RE_GRUPO)) grupos.add(nombreGrupo(m[0]));

  // Docentes de preescolar: si la celda no dice el grupo, es el suyo.
  if (!grupos.size) {
    const propio = nombreGrupo(f[iRol]);
    if (propio === 'Jardín' || propio === 'Transición') grupos.add(propio);
  }

  if (asignaturas.size !== 1) {
    return motivo(asignaturas.size ? 'Varias asignaturas en el mismo periodo' : 'Asignatura no reconocida');
  }
  if (grupos.size !== 1) return motivo(grupos.size ? 'Varios grupos en el mismo periodo' : 'Sin grupo');

  const [[, codigo, asignatura]] = asignaturas;
  const [grupo] = grupos;
  bloques.push({ numeroFila, docente, dia, inicio: horas[0], fin: horas[1], codigo, asignatura, grupo });
});

// Choques: dos clases del mismo grupo que se cruzan en el tiempo.
bloques.sort((a, b) => a.grupo.localeCompare(b.grupo) || a.dia - b.dia || a.inicio.localeCompare(b.inicio));
const validos = [];
for (const b of bloques) {
  const choque = validos.find((v) => v.grupo === b.grupo && v.dia === b.dia && b.inicio < v.fin && v.inicio < b.fin);
  if (choque) {
    revisar.push({
      fila: b.numeroFila, docente: b.docente, dia: Object.keys(DIAS)[b.dia - 1], hora: `${b.inicio}-${b.fin}`,
      clase: `${b.asignatura} - ${b.grupo}`,
      motivo: `Se cruza con ${choque.asignatura} (${choque.docente}, ${choque.inicio}-${choque.fin}, fila ${choque.numeroFila})`,
    });
  } else validos.push(b);
}

// ---------------------------------------------------------------------
// Generación del SQL
// ---------------------------------------------------------------------

const grupos = [...new Set(validos.map((b) => b.grupo))].sort((a, b) => ordenGrupo(a) - ordenGrupo(b));
const conteoGrado = {};
for (const g of grupos) { const n = parseInt(g, 10); if (n) conteoGrado[n] = (conteoGrado[n] || 0) + 1; }

function alias(g) {
  const n = parseInt(g, 10);
  if (!n) return sinTildes(g.toLowerCase());
  const letra = g.slice(-1).toLowerCase();
  const lista = [`${n}°${letra}`, `${n}-${letra}`, `${ORDINALES[n]} ${letra}`];
  if (n === 11) lista.push(`undecimo ${letra}`);
  if (conteoGrado[n] === 1) lista.push(ORDINALES[n], `${n}°`);
  return lista.join('|');
}

const franjas = {}; // nivel -> lista ordenada de [inicio, fin]
for (const b of validos) {
  const nivel = nivelDe(b.grupo);
  franjas[nivel] ||= new Map();
  franjas[nivel].set(`${b.inicio}-${b.fin}`, [b.inicio, b.fin]);
}

const docentes = [...new Set(validos.map((b) => b.docente))].sort();
const asignaturasUsadas = new Map(validos.map((b) => [b.codigo, b.asignatura]));

const lineas = [
  '-- Generado por scripts/horario.js a partir de horario_2026.csv. No editar a mano:',
  '-- corregir el CSV y volver a generar. Se puede ejecutar varias veces.',
  'USE chatbot_vm;',
  'SET NAMES utf8mb4;',
  'START TRANSACTION;',
  '',
  'DELETE FROM horarios;',
  'DELETE FROM franjas_horarias;',
  '',
];

lineas.push('INSERT INTO grupos (nivel_id, nombre, alias, orden) VALUES');
lineas.push(grupos.map((g) => `  (${NIVELES[nivelDe(g)]}, ${sql(g)}, ${sql(alias(g))}, ${ordenGrupo(g)})`).join(',\n') +
  '\nON DUPLICATE KEY UPDATE nivel_id = VALUES(nivel_id), alias = VALUES(alias), orden = VALUES(orden), activo = 1;');
lineas.push(`UPDATE grupos SET activo = 0 WHERE nombre NOT IN (${grupos.map(sql).join(', ')});`, '');

lineas.push('INSERT INTO asignaturas (codigo_excel, nombre) VALUES');
lineas.push([...asignaturasUsadas].map(([c, n]) => `  (${sql(c)}, ${sql(n)})`).join(',\n') +
  '\nON DUPLICATE KEY UPDATE nombre = VALUES(nombre), activo = 1;', '');

lineas.push('-- Docentes que no aparecen en este horario quedan inactivos (ya no hacen parte del plantel).');
lineas.push('INSERT INTO docentes (codigo_excel, nombre_mostrar) VALUES');
lineas.push(docentes.map((d) => `  (${sql(d)}, ${sql(nombreDocente(d))})`).join(',\n') +
  '\nON DUPLICATE KEY UPDATE nombre_mostrar = VALUES(nombre_mostrar), activo = 1;');
lineas.push(`UPDATE docentes SET activo = 0 WHERE codigo_excel NOT IN (${docentes.map(sql).join(', ')});`, '');

lineas.push('INSERT INTO franjas_horarias (nivel_id, numero, hora_inicio, hora_fin) VALUES');
lineas[lineas.length - 1] = 'INSERT INTO franjas_horarias (nivel_id, numero, hora_inicio, hora_fin, es_descanso) VALUES';
const valoresFranjas = [];
for (const [nivel, mapa] of Object.entries(franjas)) {
  const lista = [...mapa.values()].map(([ini, fin]) => [ini, fin, 0])
    .concat((DESCANSOS[nivel] || []).map(([ini, fin]) => [ini, fin, 1]));
  lista.sort((a, b) => a[0].localeCompare(b[0]) || a[1].localeCompare(b[1]))
    .forEach(([ini, fin, desc], i) => valoresFranjas.push(`  (${NIVELES[nivel]}, ${i + 1}, '${ini}', '${fin}', ${desc})`));
}
lineas.push(valoresFranjas.join(',\n') + ';', '');

lineas.push('INSERT INTO horarios (grupo_id, dia_semana, franja_id, asignatura_id, docente_id)');
lineas.push('SELECT g.id, v.dia, f.id, a.id, d.id FROM (');
lineas.push(validos.map((b, i) =>
  `  ${i ? 'UNION ALL ' : ''}SELECT ${sql(b.grupo)} AS grupo, ${b.dia} AS dia, '${b.inicio}' AS ini, '${b.fin}' AS fin, ${sql(b.codigo)} AS asig, ${sql(b.docente)} AS doc`,
).join('\n'));
lineas.push(') v');
lineas.push('JOIN grupos g ON g.nombre = v.grupo COLLATE utf8mb4_unicode_ci');
lineas.push('JOIN franjas_horarias f ON f.nivel_id = g.nivel_id AND f.hora_inicio = v.ini AND f.hora_fin = v.fin');
lineas.push('JOIN asignaturas a ON a.codigo_excel = v.asig COLLATE utf8mb4_unicode_ci');
lineas.push('JOIN docentes d ON d.codigo_excel = v.doc COLLATE utf8mb4_unicode_ci;', '');
lineas.push('COMMIT;', '');

fs.writeFileSync(path.join(salida, 'horario_2026.sql'), lineas.join('\n'));

const csvRevisar = ['fila,docente,dia,hora,clase,motivo',
  ...revisar.sort((a, b) => a.fila - b.fila)
    .map((r) => [r.fila, r.docente, r.dia, r.hora, r.clase, r.motivo].map((v) => `"${String(v ?? '').replace(/"/g, '""')}"`).join(','))];
fs.writeFileSync(path.join(salida, 'horario_revisar.csv'), csvRevisar.join('\n') + '\n');

console.log(JSON.stringify({
  filas: filas.length, cargadas: validos.length, revisar: revisar.length,
  grupos, docentes: docentes.length, asignaturas: asignaturasUsadas.size,
  motivos: revisar.reduce((acc, r) => { const k = r.motivo.startsWith('Se cruza') ? 'Choque con otra clase' : r.motivo; acc[k] = (acc[k] || 0) + 1; return acc; }, {}),
}, null, 2));
