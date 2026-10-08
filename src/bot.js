// Lógica de conversación del chatbot. No envía nada: recibe el teléfono y el
// texto del usuario y devuelve la lista de mensajes que se deben responder.
const { consulta, una } = require('./db');
const { minutosSesion } = require('./config');
const archivos = require('./archivos');

const DIAS = ['', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes'];
const PALABRAS_DIA = { lunes: 1, martes: 2, miercoles: 3, jueves: 4, viernes: 5 };
const SALUDOS = new Set(['0', 'menu', 'inicio', 'hola', 'buenas', 'buenos dias', 'buenas tardes', 'buenas noches', 'volver']);
const PALABRAS_RIESGO = ['acoso', 'matoneo', 'bullying', 'violencia', 'abuso', 'maltrato', 'ciberacoso', 'amenaza', 'suicid', 'autolesion'];
const LINEA_RIESGO =
  '⚠️ Si tú o alguien más está en riesgo, acude a Orientación Escolar o a Coordinación del colegio. ' +
  'Líneas de ayuda: 123 (emergencias) y 141 (ICBF).';

const OPCIONES_MENU = [
  ['circulares', 'Circulares'],
  ['horarios', 'Horarios'],
  ['plataformas', 'Plataformas educativas'],
  ['evaluacion_docente', 'Evaluación docente'],
  ['manual', 'Manual de convivencia'],
  ['identidad', 'Identidad institucional'],
  ['pqrs', 'PQRS'],
  ['proxima_actividad', 'Próxima actividad'],
];

// ---------------------------------------------------------------------
// Utilidades
// ---------------------------------------------------------------------

function normalizar(texto) {
  return String(texto || '')
    .toLowerCase()
    .normalize('NFD').replace(/[̀-ͯ]/g, '')
    .replace(/[^a-z0-9ñ\s]/g, ' ')
    .replace(/\s+/g, ' ')
    .trim();
}

function contienePalabra(texto, palabra) {
  return new RegExp(`(^| )${palabra}( |$)`).test(texto);
}

const texto = (t) => ({ tipo: 'texto', texto: t });
const imagen = (url, t) => ({ tipo: 'imagen', url, texto: t });

// "13:45:00" -> "1:45", como se escribe en el colegio.
function hora(h) {
  const [hh, mm] = String(h).split(':');
  const n = Number(hh);
  return `${n > 12 ? n - 12 : n}:${mm}`;
}

function fechaLarga(iso) {
  const [a, m, d] = iso.split('-').map(Number);
  return new Intl.DateTimeFormat('es-CO', {
    weekday: 'long', day: 'numeric', month: 'long', timeZone: 'UTC',
  }).format(new Date(Date.UTC(a, m - 1, d)));
}

// Día de la semana en Colombia (1 = lunes ... 7 = domingo), con desplazamiento en días.
function diaColombia(desplazamiento = 0) {
  const nombre = new Intl.DateTimeFormat('en-US', { weekday: 'short', timeZone: 'America/Bogota' })
    .format(new Date(Date.now() + desplazamiento * 86400000));
  return { Mon: 1, Tue: 2, Wed: 3, Thu: 4, Fri: 5, Sat: 6, Sun: 7 }[nombre];
}

async function configuracion(clave) {
  const fila = await una('SELECT valor FROM configuracion WHERE clave = ?', [clave]);
  return fila ? fila.valor : '';
}

async function enlace(clave) {
  return una('SELECT titulo, url FROM enlaces WHERE clave = ? AND activo = 1', [clave]);
}

// Reemplaza {enlace:clave} por la URL correspondiente.
async function conEnlaces(t) {
  const claves = [...t.matchAll(/\{enlace:([a-z_]+)\}/g)].map((m) => m[1]);
  for (const clave of claves) {
    const e = await enlace(clave);
    t = t.replace(`{enlace:${clave}}`, e ? e.url : '');
  }
  return t;
}

function listaNumerada(items, etiqueta) {
  return items.map((it, i) => `${i + 1}. ${etiqueta(it)}`).join('\n');
}

const PIE = '\n\n0. Menú principal';

// ---------------------------------------------------------------------
// Usuarios, estado de la conversación y registro de uso
// ---------------------------------------------------------------------

async function obtenerUsuario(telefono) {
  const existente = await una('SELECT * FROM usuarios_whatsapp WHERE telefono = ?', [telefono]);
  if (existente) {
    await consulta('UPDATE usuarios_whatsapp SET ultimo_contacto = NOW() WHERE id = ?', [existente.id]);
    return { ...existente, nuevo: false };
  }
  const res = await consulta('INSERT INTO usuarios_whatsapp (telefono) VALUES (?)', [telefono]);
  return { id: res.insertId, telefono, grupo_preferido_id: null, nuevo: true };
}

async function leerEstado(usuarioId) {
  const fila = await una(
    'SELECT paso_actual, datos_temporales FROM conversaciones WHERE usuario_id = ? AND expira_en > NOW()',
    [usuarioId],
  );
  if (!fila) return { paso: 'menu', datos: {} };
  const datos = typeof fila.datos_temporales === 'string'
    ? JSON.parse(fila.datos_temporales || '{}')
    : (fila.datos_temporales || {});
  return { paso: fila.paso_actual, datos };
}

async function guardarEstado(usuarioId, paso, datos = {}) {
  await consulta(
    `INSERT INTO conversaciones (usuario_id, paso_actual, datos_temporales, expira_en)
     VALUES (?, ?, ?, NOW() + INTERVAL ? MINUTE)
     ON DUPLICATE KEY UPDATE paso_actual = VALUES(paso_actual),
       datos_temporales = VALUES(datos_temporales), expira_en = VALUES(expira_en)`,
    [usuarioId, paso, JSON.stringify(datos), minutosSesion],
  );
}

async function registrar(usuarioId, modulo, opcion = null) {
  await consulta('INSERT INTO interacciones (usuario_id, modulo, opcion) VALUES (?, ?, ?)',
    [usuarioId, modulo, opcion ? String(opcion).slice(0, 80) : null]);
}

// ---------------------------------------------------------------------
// Menú principal
// ---------------------------------------------------------------------

async function proximasActividades(limite) {
  return consulta(
    `SELECT * FROM actividades
      WHERE publicada = 1 AND fecha >= CURDATE()
      ORDER BY fecha, hora_inicio IS NULL, hora_inicio
      LIMIT ${Number(limite)}`,
  );
}

async function menu(u) {
  await guardarEstado(u.id, 'menu');
  const [proxima] = await proximasActividades(1);
  let t = await configuracion('bienvenida');
  if (proxima) t += `\n📅 Próxima actividad: ${proxima.titulo}, ${fechaLarga(proxima.fecha)}`;
  t += '\n\n' + OPCIONES_MENU.map(([, nombre], i) => `${i + 1}. ${nombre}`).join('\n');
  t += '\n\nEn cualquier momento escribe *0* para volver aquí o *asesor* para hablar con una persona.';
  return [texto(t)];
}

async function abrirModulo(u, modulo) {
  switch (modulo) {
    case 'circulares': return circulares(u);
    case 'horarios': return horariosInicio(u);
    case 'plataformas': return plataformasInicio(u);
    case 'evaluacion_docente': return evaluacionDocente(u);
    case 'manual':
    case 'identidad': return categoriasInicio(u, modulo);
    case 'pqrs': return pqrs(u);
    case 'proxima_actividad': return actividad(u, 0);
    case 'asesor': return asesor(u);
    default: return menu(u);
  }
}

// ---------------------------------------------------------------------
// 1. Circulares
// ---------------------------------------------------------------------

async function urlCircular(c) {
  return (await archivos.urlDe('circular', c.id)) || c.archivo_url;
}

function tituloCircular(c) {
  return `📄 Circular N° ${c.numero}: ${c.titulo}\nPublicada el ${fechaLarga(c.fecha_publicacion)}`;
}

// Circulares anteriores que tienen PDF (subido en el panel o con enlace).
async function circularesConPdf() {
  const lista = await consulta(
    `SELECT c.* FROM circulares c
      WHERE c.es_actual = 0
        AND (c.archivo_url IS NOT NULL OR EXISTS (SELECT 1 FROM archivos a WHERE a.tipo = 'circular' AND a.ref_id = c.id))
      ORDER BY c.fecha_publicacion DESC, c.id DESC LIMIT 5`);
  return lista;
}

async function circulares(u) {
  await registrar(u.id, 'circulares', 'actual');
  await guardarEstado(u.id, 'menu');
  const c = await una('SELECT * FROM circulares WHERE es_actual = 1');
  const com = await enlace('comunicaciones');
  const anteriores = await circularesConPdf();
  let pie = '';
  if (anteriores.length) {
    await guardarEstado(u.id, 'circulares', { lista: anteriores.map((a) => a.id) });
    pie = `Circulares anteriores (escribe el número para recibirla):\n\n${listaNumerada(anteriores, (a) => `N° ${a.numero}: ${a.titulo}`)}`;
  }
  if (com) pie += `${pie ? '\n\n' : ''}¿Buscas otra circular? Encuéntralas todas aquí: ${com.url}`;
  if (!c) return [texto(`Por ahora no hay una circular publicada.${pie ? `\n\n${pie}` : ''}${PIE}`)];
  const url = await urlCircular(c);
  if (url) {
    return [
      { tipo: 'documento', url, nombre: `Circular ${c.numero}.pdf`, texto: tituloCircular(c) },
      texto(`${pie}${PIE}`.replace(/^\n+/, '')),
    ];
  }
  return [texto(`${tituloCircular(c)}${pie ? `\n\n${pie}` : ''}${PIE}`)];
}

async function enviarCircular(u, id) {
  const c = await una('SELECT * FROM circulares WHERE id = ?', [id]);
  const url = c && await urlCircular(c);
  if (!url) return null;
  await registrar(u.id, 'circulares', `anterior:${c.numero}`);
  return [
    { tipo: 'documento', url, nombre: `Circular ${c.numero}.pdf`, texto: tituloCircular(c) },
    texto(`Escribe otro número de la lista para recibir otra circular.${PIE}`),
  ];
}

// ---------------------------------------------------------------------
// 2. Horarios
// ---------------------------------------------------------------------

async function gruposActivos() {
  return consulta('SELECT id, nombre, alias FROM grupos WHERE activo = 1 ORDER BY orden');
}

function variantesGrupo(g) {
  const base = normalizar(g.nombre);
  const variantes = new Set([base, base.replace(/^(\d+)\s*([a-z])$/, '$1 $2'), base.replace(/\s+/g, '')]);
  for (const a of String(g.alias || '').split('|')) if (a.trim()) variantes.add(normalizar(a));
  return [...variantes].filter(Boolean);
}

async function buscarGrupoEnTexto(t) {
  const candidatos = [];
  for (const g of await gruposActivos()) {
    for (const v of variantesGrupo(g)) if (contienePalabra(t, v)) candidatos.push([v.length, g]);
  }
  candidatos.sort((a, b) => b[0] - a[0]);
  return candidatos.length ? candidatos[0][1] : null;
}

// Devuelve 1-5, 'semana' o null.
function buscarDiaEnTexto(t) {
  if (contienePalabra(t, 'semana')) return 'semana';
  for (const [palabra, n] of Object.entries(PALABRAS_DIA)) if (contienePalabra(t, palabra)) return n;
  if (contienePalabra(t, 'manana') && !contienePalabra(t, 'de la manana')) return diaColombia(1);
  if (contienePalabra(t, 'hoy')) return diaColombia(0);
  return null;
}

async function textoHorarioGrupo(grupoId, dia) {
  const filas = await consulta(
    `SELECT f.hora_inicio, f.hora_fin, f.es_descanso, a.nombre AS asignatura, d.nombre_mostrar AS docente
       FROM grupos g
       JOIN franjas_horarias f ON f.nivel_id = g.nivel_id
       LEFT JOIN horarios h ON h.grupo_id = g.id AND h.franja_id = f.id AND h.dia_semana = ?
       LEFT JOIN asignaturas a ON a.id = h.asignatura_id
       LEFT JOIN docentes d ON d.id = h.docente_id AND d.activo = 1
      WHERE g.id = ?
      ORDER BY f.numero`,
    [dia, grupoId],
  );
  const lineas = filas
    .filter((f) => f.es_descanso || f.asignatura)
    .map((f) => {
      const rango = `${hora(f.hora_inicio)}–${hora(f.hora_fin)}`;
      if (f.es_descanso) return `${rango} | ☕ Descanso`;
      return f.docente ? `${rango} | ${f.asignatura} | ${f.docente}` : `${rango} | ${f.asignatura}`;
    });
  return lineas.some((l) => !l.includes('Descanso')) ? lineas.join('\n') : null;
}

async function textoHorarioDocente(docenteId, dia) {
  const filas = await consulta(
    `SELECT f.hora_inicio, f.hora_fin, a.nombre AS asignatura, g.nombre AS grupo
       FROM horarios h
       JOIN franjas_horarias f ON f.id = h.franja_id
       JOIN asignaturas a ON a.id = h.asignatura_id
       JOIN grupos g ON g.id = h.grupo_id
      WHERE h.docente_id = ? AND h.dia_semana = ?
      ORDER BY f.hora_inicio`,
    [docenteId, dia],
  );
  if (!filas.length) return 'Sin clases asignadas: día libre.';
  return filas.map((f) => `${hora(f.hora_inicio)}–${hora(f.hora_fin)} | ${f.asignatura} | ${f.grupo}`).join('\n') +
    '\n_Las horas que no aparecen son horas libres._';
}

async function mostrarHorario(u, { grupoId, docenteId }, dia, { conImagen = false } = {}) {
  let nombre;
  let generar;
  if (grupoId) {
    nombre = (await una('SELECT nombre FROM grupos WHERE id = ?', [grupoId])).nombre;
    generar = (d) => textoHorarioGrupo(grupoId, d);
  } else {
    nombre = (await una('SELECT nombre_mostrar FROM docentes WHERE id = ?', [docenteId])).nombre_mostrar;
    generar = (d) => textoHorarioDocente(docenteId, d);
  }
  await registrar(u.id, 'horarios', `${grupoId ? 'grupo' : 'docente'}:${nombre}:${dia}`);
  await guardarEstado(u.id, 'horarios_dia', { grupoId, docenteId });

  let aviso = '';
  if (dia !== 'semana' && dia > 5) {
    aviso = 'Ese día no hay clases. Este es el horario del lunes:\n\n';
    dia = 1;
  }
  const dias = dia === 'semana' ? [1, 2, 3, 4, 5] : [dia];
  const bloques = [];
  for (const d of dias) {
    const contenido = await generar(d);
    bloques.push(`*${DIAS[d]}*\n${contenido || 'Sin clases registradas.'}`);
  }
  const otroDia = '\n\nEscribe otro día (por ejemplo, *martes*) o *semana* para ver la semana completa.';
  const url = grupoId && (conImagen || dia === 'semana') ? await archivos.urlDe('horario_grupo', grupoId) : null;
  if (url && dia === 'semana') {
    return [imagen(url, `🕒 Horario de ${nombre}`),
      texto(`Escribe un día (por ejemplo, *martes*) para verlo en texto.${PIE}`)];
  }
  const salida = [texto(`🕒 Horario de ${nombre}\n\n${aviso}${bloques.join('\n\n')}${otroDia}${PIE}`)];
  if (url) salida.unshift(imagen(url, `🕒 Horario de ${nombre}`));
  return salida;
}

async function horariosInicio(u) {
  await registrar(u.id, 'horarios', 'inicio');
  let t = '🕒 *Horarios*\n\n1. Por grupo\n2. Por docente';
  if (u.grupo_preferido_id) {
    const g = await una('SELECT nombre FROM grupos WHERE id = ?', [u.grupo_preferido_id]);
    if (g) t += `\n3. Mi grupo (${g.nombre})`;
  }
  t += '\n\nAtajo: escribe por ejemplo *horario 11B* o *4A martes*.';
  await guardarEstado(u.id, 'horarios');
  return [texto(t + PIE)];
}

async function pedirDia(u, datos, nombre) {
  await guardarEstado(u.id, 'horarios_dia', datos);
  const url = datos.grupoId ? await archivos.urlDe('horario_grupo', datos.grupoId) : null;
  if (url) {
    await registrar(u.id, 'horarios', `imagen:${nombre}`);
    return [imagen(url, `🕒 Horario de ${nombre}`),
      texto(`Si quieres verlo en texto, elige el día:\n\n1. Lunes\n2. Martes\n3. Miércoles\n4. Jueves\n5. Viernes\n6. Semana completa\n7. Hoy${PIE}`)];
  }
  return [texto(`¿Qué día quieres ver de ${nombre}?\n\n1. Lunes\n2. Martes\n3. Miércoles\n4. Jueves\n5. Viernes\n6. Semana completa\n7. Hoy${PIE}`)];
}

async function pasoHorarios(u, n) {
  if (n === 1) {
    const grupos = await gruposActivos();
    await guardarEstado(u.id, 'horarios_grupo', { lista: grupos.map((g) => g.id) });
    return [texto(`Elige el grupo:\n\n${listaNumerada(grupos, (g) => g.nombre)}${PIE}`)];
  }
  if (n === 2) {
    const docentes = await consulta('SELECT id, nombre_mostrar FROM docentes WHERE activo = 1 ORDER BY nombre_mostrar');
    await guardarEstado(u.id, 'horarios_docente', { lista: docentes.map((d) => d.id) });
    return [texto(`Elige el docente:\n\n${listaNumerada(docentes, (d) => d.nombre_mostrar)}${PIE}`)];
  }
  if (n === 3 && u.grupo_preferido_id) {
    const g = await una('SELECT nombre FROM grupos WHERE id = ?', [u.grupo_preferido_id]);
    return pedirDia(u, { grupoId: u.grupo_preferido_id }, g.nombre);
  }
  return null;
}

async function recordarGrupo(u, grupoId) {
  if (u.grupo_preferido_id === grupoId) return;
  await consulta('UPDATE usuarios_whatsapp SET grupo_preferido_id = ? WHERE id = ?', [grupoId, u.id]);
  u.grupo_preferido_id = grupoId;
}

// ---------------------------------------------------------------------
// 3. Plataformas
// ---------------------------------------------------------------------

async function plataformasInicio(u) {
  await registrar(u.id, 'plataformas', 'inicio');
  const lista = await consulta('SELECT id, nombre FROM plataformas WHERE activo = 1 ORDER BY orden');
  await guardarEstado(u.id, 'plataformas', { lista: lista.map((p) => p.id) });
  return [texto(`💻 *Plataformas educativas*\n\n${listaNumerada(lista, (p) => p.nombre)}${PIE}`)];
}

async function mostrarPlataforma(u, id) {
  const p = await una('SELECT * FROM plataformas WHERE id = ?', [id]);
  await registrar(u.id, 'plataformas', p.nombre);
  const partes = [`💻 *${p.nombre}*`];
  if (p.descripcion) partes.push(p.descripcion);
  if (p.url) partes.push(`Ingreso: ${p.url}`);
  if (p.instrucciones) partes.push(`*Cómo ingresar*\n${p.instrucciones}`);
  if (p.recuperacion_clave) partes.push(`*Si olvidaste la contraseña*\n${p.recuperacion_clave}`);
  if (p.app_movil) partes.push(`*App móvil*\n${p.app_movil}`);
  partes.push('Nunca compartas tu contraseña por WhatsApp; el colegio no te la pedirá.');
  return [texto(partes.join('\n\n') + PIE)];
}

// ---------------------------------------------------------------------
// 4. Evaluación docente y 7. PQRS
// ---------------------------------------------------------------------

async function evaluacionDocente(u) {
  await registrar(u.id, 'evaluacion_docente', 'enlace');
  await guardarEstado(u.id, 'menu');
  const e = await enlace('evaluacion_docente');
  return [texto(`📝 *Evaluación docente*\n\nResponde la evaluación en este formulario:\n${e ? e.url : 'enlace no disponible'}${PIE}`)];
}

async function pqrs(u) {
  await registrar(u.id, 'pqrs', 'enlace');
  await guardarEstado(u.id, 'menu');
  const form = await enlace('pqrs_formulario');
  const correo = await enlace('pqrs_correo');
  const plazo = await configuracion('pqrs_plazo');
  const lineas = ['📮 *PQRS* (peticiones, quejas, reclamos y sugerencias)', ''];
  if (form) lineas.push(`Formulario: ${form.url}`);
  if (correo) lineas.push(`Correo: ${correo.url.replace(/^mailto:/, '')}`);
  if (plazo) lineas.push('', `El colegio responde en un plazo de ${plazo}.`);
  return [texto(lineas.join('\n') + PIE)];
}

// ---------------------------------------------------------------------
// 5. Manual de convivencia y 6. Identidad
// ---------------------------------------------------------------------

async function categoriasInicio(u, modulo) {
  await registrar(u.id, modulo, 'inicio');
  const lista = await consulta(
    'SELECT id, nombre FROM categorias WHERE modulo = ? AND activo = 1 ORDER BY orden', [modulo]);
  await guardarEstado(u.id, 'categorias', { modulo, lista: lista.map((c) => c.id) });
  const titulo = modulo === 'manual' ? '📘 *Manual de convivencia*' : '🏫 *Identidad institucional*';
  return [texto(`${titulo}\n\n${listaNumerada(lista, (c) => c.nombre)}${PIE}`)];
}

function textoContenido(c) {
  const ref = c.referencia ? `\n\n(Manual de convivencia, numeral ${c.referencia})` : '';
  return `*${c.titulo}*\n\n${c.texto}${ref}`;
}

async function mostrarCategoria(u, categoriaId, modulo) {
  const cat = await una('SELECT nombre, modulo FROM categorias WHERE id = ?', [categoriaId]);
  await registrar(u.id, modulo || cat.modulo, cat.nombre);
  const lista = await consulta(
    'SELECT * FROM contenidos WHERE categoria_id = ? AND activo = 1 ORDER BY orden, id', [categoriaId]);
  if (!lista.length) {
    await guardarEstado(u.id, 'menu');
    return [texto(`Todavía no hay información cargada sobre *${cat.nombre}*.${PIE}`)];
  }
  if (lista.length === 1) {
    await guardarEstado(u.id, 'menu');
    return [texto(textoContenido(lista[0]) + PIE)];
  }
  await guardarEstado(u.id, 'contenidos', { lista: lista.map((c) => c.id) });
  return [texto(`*${cat.nombre}*\n\n${listaNumerada(lista, (c) => c.titulo)}${PIE}`)];
}

async function mostrarContenido(u, id) {
  const c = await una(
    'SELECT c.*, k.modulo FROM contenidos c JOIN categorias k ON k.id = c.categoria_id WHERE c.id = ?', [id]);
  if (!c) return null;
  await registrar(u.id, c.modulo, c.titulo);
  await guardarEstado(u.id, 'menu');
  return [texto(textoContenido(c) + PIE)];
}

// ---------------------------------------------------------------------
// 8. Próxima actividad
// ---------------------------------------------------------------------

function textoActividad(a) {
  const partes = [`*${a.titulo}*`];
  let cuando = fechaLarga(a.fecha);
  if (a.hora_inicio) cuando += `, ${hora(a.hora_inicio)}${a.hora_fin ? `–${hora(a.hora_fin)}` : ''}`;
  partes.push(cuando.charAt(0).toUpperCase() + cuando.slice(1));
  if (a.lugar) partes.push(`Lugar: ${a.lugar}`);
  if (a.dirigido_a) partes.push(`Dirigido a: ${a.dirigido_a}`);
  let t = partes.join('\n');
  if (a.descripcion) t += `\n\n${a.descripcion}`;
  if (a.materiales) t += `\n\nTrae: ${a.materiales}`;
  if (a.recordatorios) t += `\n\n${a.recordatorios}`;
  if (a.enlace_url) t += `\n\n🔗 ${a.enlace_url}`;
  return t;
}

async function actividad(u, opcion) {
  if (opcion === 0) {
    await registrar(u.id, 'proxima_actividad', 'proxima');
    const [a] = await proximasActividades(1);
    if (!a) {
      await guardarEstado(u.id, 'menu');
      return [texto(`📅 Por ahora no hay actividades programadas.${PIE}`)];
    }
    await guardarEstado(u.id, 'actividad', { id: a.id });
    const opciones = [];
    if (a.imagen_url) opciones.push('1. Ver comunicado completo');
    opciones.push(`${a.imagen_url ? 2 : 1}. Ver las siguientes`);
    return [texto(`📅 *PRÓXIMA ACTIVIDAD*\n\n${textoActividad(a)}\n\n${opciones.join('\n')}${PIE}`)];
  }
  return null;
}

async function pasoActividad(u, n, datos) {
  const a = await una('SELECT * FROM actividades WHERE id = ?', [datos.id]);
  if (!a) return null;
  if (a.imagen_url && n === 1) {
    await registrar(u.id, 'proxima_actividad', 'comunicado');
    return [{ tipo: 'imagen', url: a.imagen_url, texto: a.titulo }, texto(`0. Menú principal`)];
  }
  if (n === (a.imagen_url ? 2 : 1)) {
    await registrar(u.id, 'proxima_actividad', 'siguientes');
    const siguientes = (await proximasActividades(4)).filter((x) => x.id !== a.id).slice(0, 3);
    await guardarEstado(u.id, 'menu');
    if (!siguientes.length) return [texto(`No hay más actividades programadas por ahora.${PIE}`)];
    return [texto(`📅 *Siguientes actividades*\n\n${siguientes.map(textoActividad).join('\n\n— — —\n\n')}${PIE}`)];
  }
  return null;
}

// ---------------------------------------------------------------------
// Atención humana
// ---------------------------------------------------------------------

async function asesor(u) {
  await registrar(u.id, 'asesor', 'solicitud');
  const pendiente = await una(
    "SELECT id FROM solicitudes_asesor WHERE usuario_id = ? AND estado <> 'atendida' AND fecha > NOW() - INTERVAL 1 DAY",
    [u.id]);
  const id = pendiente
    ? pendiente.id
    : (await consulta('INSERT INTO solicitudes_asesor (usuario_id) VALUES (?)', [u.id])).insertId;
  await guardarEstado(u.id, 'asesor_mensaje', { solicitudId: id });
  return [texto('🙋 Con gusto. Escribe en un solo mensaje qué necesitas y se lo paso a una persona del colegio.\n\n0. Cancelar y volver al menú')];
}

async function guardarMensajeAsesor(u, datos, original) {
  await consulta(
    "UPDATE solicitudes_asesor SET mensaje = TRIM(CONCAT_WS('\\n', mensaje, ?)) WHERE id = ?",
    [String(original).slice(0, 900), datos.solicitudId]);
  await guardarEstado(u.id, 'menu');
  const horario = await configuracion('horario_atencion');
  let t = '✅ Listo, una persona del colegio te responderá por este mismo chat lo antes posible.';
  if (horario && !/pendiente/i.test(horario)) t += `\nHorario de atención: ${horario}.`;
  return [texto(t + '\n\nMientras tanto puedes seguir usando el menú.' + PIE)];
}

// ---------------------------------------------------------------------
// Palabras clave y búsqueda (reemplazan la IA)
// ---------------------------------------------------------------------

async function irADestino(u, destino) {
  const [tipo, valor] = destino.split(':');
  if (tipo === 'modulo') return abrirModulo(u, valor);
  if (tipo === 'categoria') return mostrarCategoria(u, Number(valor));
  if (tipo === 'contenido') return mostrarContenido(u, Number(valor));
  if (tipo === 'enlace') {
    const e = await enlace(valor);
    if (!e) return null;
    await guardarEstado(u.id, 'menu');
    await registrar(u.id, valor === 'evaluacion_docente' ? 'evaluacion_docente' : 'menu', `enlace:${valor}`);
    return [texto(`🔗 ${e.titulo}: ${e.url}${PIE}`)];
  }
  return null;
}

async function porPalabraClave(u, t) {
  const terminos = await consulta(
    'SELECT termino, destino FROM palabras_clave WHERE activo = 1 ORDER BY CHAR_LENGTH(termino) DESC');
  for (const { termino, destino } of terminos) {
    if (contienePalabra(t, normalizar(termino))) return irADestino(u, destino);
  }
  return null;
}

async function porBusqueda(u, original) {
  if (normalizar(original).length < 4) return null;
  try {
    const c = await una(
      `SELECT c.id, MATCH(c.titulo, c.texto, c.palabras_clave) AGAINST (?) AS puntaje
         FROM contenidos c JOIN categorias k ON k.id = c.categoria_id
        WHERE c.activo = 1 AND k.activo = 1 AND MATCH(c.titulo, c.texto, c.palabras_clave) AGAINST (?)
        ORDER BY puntaje DESC LIMIT 1`,
      [original, original]);
    return c ? mostrarContenido(u, c.id) : null;
  } catch {
    return null;
  }
}

async function sinRespuesta(u, original) {
  await consulta('INSERT INTO consultas_sin_respuesta (texto) VALUES (?)', [String(original).slice(0, 1000)]);
  await registrar(u.id, 'sin_respuesta');
  return [texto(await configuracion('sin_respuesta'))];
}

// ---------------------------------------------------------------------
// Pasos numerados: interpreta un número según dónde está el usuario
// ---------------------------------------------------------------------

async function pasoNumerado(u, estado, n) {
  const { paso, datos } = estado;
  const elegido = (lista) => (n >= 1 && n <= (lista || []).length ? lista[n - 1] : null);

  switch (paso) {
    case 'menu':
      return n >= 1 && n <= OPCIONES_MENU.length ? abrirModulo(u, OPCIONES_MENU[n - 1][0]) : null;
    case 'horarios':
      return pasoHorarios(u, n);
    case 'horarios_grupo': {
      const id = elegido(datos.lista);
      if (!id) return null;
      await recordarGrupo(u, id);
      const g = await una('SELECT nombre FROM grupos WHERE id = ?', [id]);
      return pedirDia(u, { grupoId: id }, g.nombre);
    }
    case 'horarios_docente': {
      const id = elegido(datos.lista);
      if (!id) return null;
      const d = await una('SELECT nombre_mostrar FROM docentes WHERE id = ?', [id]);
      return pedirDia(u, { docenteId: id }, d.nombre_mostrar);
    }
    case 'horarios_dia':
      if (n >= 1 && n <= 5) return mostrarHorario(u, datos, n);
      if (n === 6) return mostrarHorario(u, datos, 'semana');
      if (n === 7) return mostrarHorario(u, datos, diaColombia(0));
      return null;
    case 'plataformas': {
      const id = elegido(datos.lista);
      return id ? mostrarPlataforma(u, id) : null;
    }
    case 'categorias': {
      const id = elegido(datos.lista);
      return id ? mostrarCategoria(u, id, datos.modulo) : null;
    }
    case 'contenidos': {
      const id = elegido(datos.lista);
      return id ? mostrarContenido(u, id) : null;
    }
    case 'actividad':
      return pasoActividad(u, n, datos);
    case 'circulares': {
      const id = elegido(datos.lista);
      return id ? enviarCircular(u, id) : null;
    }
    default:
      return null;
  }
}

// ---------------------------------------------------------------------
// Atajos de horario: "horario 11B", "4A martes", "mi horario de mañana"
// ---------------------------------------------------------------------

async function atajoHorario(u, t, estado) {
  const dia = buscarDiaEnTexto(t);
  const pideHorario = contienePalabra(t, 'horario') || contienePalabra(t, 'clases');

  const grupo = await buscarGrupoEnTexto(t);

  // "martes" o "semana" estando ya en un horario
  if (!grupo && estado.paso === 'horarios_dia' && dia && !pideHorario) return mostrarHorario(u, estado.datos, dia);

  if (grupo && (pideHorario || dia)) {
    await recordarGrupo(u, grupo.id);
    return mostrarHorario(u, { grupoId: grupo.id }, dia || diaColombia(0), { conImagen: !dia });
  }
  if (contienePalabra(t, 'mi horario') && u.grupo_preferido_id) {
    return mostrarHorario(u, { grupoId: u.grupo_preferido_id }, dia || diaColombia(0), { conImagen: !dia });
  }
  return null;
}

// ---------------------------------------------------------------------
// Punto de entrada
// ---------------------------------------------------------------------

async function responder(telefono, entrada, { esTexto = true } = {}) {
  const u = await obtenerUsuario(telefono);
  const salida = [];

  if (u.nuevo) salida.push(texto(await conEnlaces(await configuracion('aviso_datos'))));

  if (!esTexto) {
    salida.push(texto('Por ahora solo entiendo mensajes de texto. Escribe *0* para ver el menú.'));
    return salida;
  }

  const t = normalizar(entrada);
  const estado = await leerEstado(u.id);
  let respuesta = null;

  if (!t || SALUDOS.has(t) || u.nuevo && /^(hola|buen)/.test(t)) {
    await registrar(u.id, 'menu');
    respuesta = await menu(u);
  } else if (estado.paso === 'asesor_mensaje') {
    respuesta = await guardarMensajeAsesor(u, estado.datos, entrada);
  } else if (contienePalabra(t, 'asesor')) {
    respuesta = await asesor(u);
  } else if (/^\d{1,2}$/.test(t)) {
    respuesta = await pasoNumerado(u, estado, Number(t));
  }

  if (!respuesta) respuesta = await atajoHorario(u, t, estado);
  if (!respuesta) respuesta = await porPalabraClave(u, t);
  if (!respuesta) respuesta = await porBusqueda(u, entrada);
  if (!respuesta) respuesta = /^\d{1,2}$/.test(t)
    ? [texto('Esa opción no está en la lista. Escribe el número de una opción o *0* para el menú.')]
    : await sinRespuesta(u, entrada);

  salida.push(...respuesta);
  if (PALABRAS_RIESGO.some((p) => t.includes(p))) salida.push(texto(LINEA_RIESGO));
  return salida;
}

module.exports = { responder, normalizar };
