// Panel administrativo para la docente encargada y el estudiante administrador.
// Páginas HTML sencillas, sin dependencias de interfaz.
const crypto = require('crypto');
const express = require('express');
const bcrypt = require('bcryptjs');
const { consulta, una } = require('./db');
const whatsapp = require('./whatsapp');

const router = express.Router();
router.use(express.urlencoded({ extended: false }));

const SECRETO = process.env.PANEL_SECRET || crypto.randomBytes(32).toString('hex');
const HORAS_SESION = 12;

// ---------------------------------------------------------------------
// Sesión: cookie firmada "idAdmin.vence.firma"
// ---------------------------------------------------------------------

function firmar(valor) {
  return crypto.createHmac('sha256', SECRETO).update(valor).digest('hex');
}

function leerCookie(req, nombre) {
  const par = (req.headers.cookie || '').split(';').map((c) => c.trim()).find((c) => c.startsWith(`${nombre}=`));
  return par ? decodeURIComponent(par.slice(nombre.length + 1)) : null;
}

function abrirSesion(res, adminId) {
  const valor = `${adminId}.${Date.now() + HORAS_SESION * 3600000}`;
  res.setHeader('Set-Cookie',
    `panel=${encodeURIComponent(`${valor}.${firmar(valor)}`)}; HttpOnly; SameSite=Strict; Path=/panel; Max-Age=${HORAS_SESION * 3600}` +
    (process.env.NODE_ENV === 'production' ? '; Secure' : ''));
}

async function adminDeSesion(req) {
  const cookie = leerCookie(req, 'panel');
  if (!cookie) return null;
  const [id, vence, firma] = cookie.split('.');
  const esperada = firmar(`${id}.${vence}`);
  if (!firma || firma.length !== esperada.length ||
      !crypto.timingSafeEqual(Buffer.from(firma), Buffer.from(esperada))) return null;
  if (Number(vence) < Date.now()) return null;
  return una('SELECT id, nombre, rol FROM administradores WHERE id = ? AND activo = 1', [id]);
}

// ---------------------------------------------------------------------
// HTML
// ---------------------------------------------------------------------

const esc = (v) => String(v ?? '').replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));

function pagina(titulo, cuerpo, admin, aviso = '') {
  const menu = admin ? `
    <nav>
      <a href="/panel">Inicio</a>
      <a href="/panel/asesor">Asesor</a>
      <a href="/panel/actividades">Actividades</a>
      <a href="/panel/circular">Circular</a>
      <a href="/panel/enlaces">Enlaces y textos</a>
      <a href="/panel/sin-respuesta">Sin respuesta</a>
      <a href="/panel/cuentas">Cuentas</a>
      <a href="/panel/whatsapp">WhatsApp</a>
      <form method="post" action="/panel/salir"><button class="link">Salir (${esc(admin.nombre)})</button></form>
    </nav>` : '';
  return `<!doctype html><html lang="es"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${esc(titulo)} · Panel del chatbot</title>
<style>
  :root { --verde:#1f7a4d; --borde:#d9dee3; --suave:#f4f6f8; --texto:#1d2329; }
  * { box-sizing:border-box; }
  body { margin:0; font:15px/1.5 system-ui, sans-serif; color:var(--texto); background:#fff; }
  header { background:var(--verde); color:#fff; padding:12px 16px; font-weight:600; }
  nav { display:flex; flex-wrap:wrap; gap:4px 14px; padding:10px 16px; border-bottom:1px solid var(--borde); background:var(--suave); }
  a { color:var(--verde); }
  nav a, .link { color:var(--verde); text-decoration:none; background:none; border:0; padding:0; font:inherit; cursor:pointer; }
  nav form { margin-left:auto; }
  main { max-width:960px; margin:0 auto; padding:16px; }
  h1 { font-size:22px; margin:8px 0 16px; }
  h2 { font-size:17px; margin:24px 0 8px; }
  table { width:100%; border-collapse:collapse; margin:8px 0 16px; }
  th, td { text-align:left; padding:8px; border-bottom:1px solid var(--borde); vertical-align:top; }
  th { background:var(--suave); font-weight:600; }
  form.caja { border:1px solid var(--borde); border-radius:8px; padding:14px; margin:12px 0; display:grid; gap:10px; }
  label { display:grid; gap:4px; font-weight:600; }
  input, textarea, select { font:inherit; padding:8px; border:1px solid var(--borde); border-radius:6px; width:100%; font-weight:400; }
  textarea { min-height:80px; }
  button.boton { background:var(--verde); color:#fff; border:0; border-radius:6px; padding:9px 16px; font:inherit; cursor:pointer; justify-self:start; }
  button.secundario { background:#fff; color:var(--verde); border:1px solid var(--verde); }
  .aviso { background:#e8f5ee; border:1px solid #b9dfc9; padding:10px; border-radius:6px; margin-bottom:12px; }
  .error { background:#fdecea; border-color:#f5c2bd; }
  .cifras { display:grid; grid-template-columns:repeat(auto-fit,minmax(150px,1fr)); gap:10px; }
  .cifra { border:1px solid var(--borde); border-radius:8px; padding:12px; }
  .cifra b { display:block; font-size:26px; }
  .gris { color:#5f6b76; font-size:13px; }
  .fila2 { display:grid; grid-template-columns:repeat(auto-fit,minmax(200px,1fr)); gap:10px; }
  .scroll { overflow-x:auto; }
</style></head><body>
<header>Chatbot Colegio Visión Mundial · Panel</header>${menu}
<main>${aviso}<h1>${esc(titulo)}</h1>${cuerpo}</main></body></html>`;
}

const avisoDe = (req) => {
  const ok = req.query.ok;
  const err = req.query.error;
  if (ok) return `<div class="aviso">${esc(ok)}</div>`;
  if (err) return `<div class="aviso error">${esc(err)}</div>`;
  return '';
};

const volver = (res, ruta, mensaje, error = false) =>
  res.redirect(`${ruta}?${error ? 'error' : 'ok'}=${encodeURIComponent(mensaje)}`);

const envolver = (fn) => (req, res, next) => fn(req, res, next).catch(next);

// ---------------------------------------------------------------------
// Ingreso
// ---------------------------------------------------------------------

const intentos = new Map(); // correo -> { n, desde }

router.get('/ingresar', envolver(async (req, res) => {
  const { n } = await una('SELECT COUNT(*) AS n FROM administradores');
  if (!n) {
    return res.send(pagina('Crear la primera cuenta', `
    <p>Todavía no hay cuentas en el panel. Crea la de la docente encargada; desde ella se crean las demás.</p>
    <form class="caja" method="post" action="/panel/primera-cuenta" style="max-width:420px">
      <label>Nombre <input name="nombre" required maxlength="120"></label>
      <label>Correo <input type="email" name="correo" required></label>
      <label>Contraseña (mínimo 10 caracteres) <input type="password" name="contrasena" required minlength="10"></label>
      <label>Clave de instalación <input type="password" name="clave" required>
        <span class="gris" style="font-weight:400">Es el valor de PANEL_SECRET que se puso al crear el servidor.</span></label>
      <button class="boton">Crear cuenta</button>
    </form>`, null, avisoDe(req)));
  }
  return res.send(pagina('Ingresar', `
    <form class="caja" method="post" action="/panel/ingresar" style="max-width:360px">
      <label>Correo <input type="email" name="correo" required autofocus></label>
      <label>Contraseña <input type="password" name="contrasena" required></label>
      <button class="boton">Ingresar</button>
    </form>`, null, avisoDe(req)));
}));

router.post('/primera-cuenta', envolver(async (req, res) => {
  const { n } = await una('SELECT COUNT(*) AS n FROM administradores');
  if (n) return res.redirect('/panel/ingresar');
  const clave = String(req.body.clave || '');
  const esperada = process.env.PANEL_SECRET || '';
  const claveOk = esperada.length >= 16 && clave.length === esperada.length &&
    crypto.timingSafeEqual(Buffer.from(clave), Buffer.from(esperada));
  if (!claveOk) return volver(res, '/panel/ingresar', 'La clave de instalación no coincide con PANEL_SECRET (debe tener al menos 16 caracteres).', true);
  const contrasena = String(req.body.contrasena || '');
  if (contrasena.length < 10) return volver(res, '/panel/ingresar', 'La contraseña debe tener al menos 10 caracteres.', true);
  const r = await consulta(
    "INSERT INTO administradores (nombre, correo, contrasena_hash, rol) VALUES (?, ?, ?, 'docente_encargada')",
    [String(req.body.nombre).trim(), String(req.body.correo).trim().toLowerCase(), await bcrypt.hash(contrasena, 10)]);
  abrirSesion(res, r.insertId);
  return res.redirect('/panel?ok=' + encodeURIComponent('Cuenta creada. Ahora crea la de Abraham en "Cuentas".'));
}));

router.post('/ingresar', envolver(async (req, res) => {
  const correo = String(req.body.correo || '').trim().toLowerCase();
  const registro = intentos.get(correo) || { n: 0, desde: Date.now() };
  if (Date.now() - registro.desde > 15 * 60000) { registro.n = 0; registro.desde = Date.now(); }
  if (registro.n >= 5) return volver(res, '/panel/ingresar', 'Demasiados intentos. Espera 15 minutos.', true);

  const admin = await una('SELECT id, contrasena_hash FROM administradores WHERE correo = ? AND activo = 1', [correo]);
  const valida = admin && await bcrypt.compare(String(req.body.contrasena || ''), admin.contrasena_hash);
  if (!valida) {
    registro.n += 1;
    intentos.set(correo, registro);
    return volver(res, '/panel/ingresar', 'Correo o contraseña incorrectos.', true);
  }
  intentos.delete(correo);
  await consulta('UPDATE administradores SET ultimo_acceso = NOW() WHERE id = ?', [admin.id]);
  abrirSesion(res, admin.id);
  return res.redirect('/panel');
}));

router.post('/salir', (req, res) => {
  res.setHeader('Set-Cookie', 'panel=; HttpOnly; SameSite=Strict; Path=/panel; Max-Age=0');
  res.redirect('/panel/ingresar');
});

// Todo lo demás requiere sesión.
router.use(envolver(async (req, res, next) => {
  req.admin = await adminDeSesion(req);
  if (!req.admin) return res.redirect('/panel/ingresar');
  return next();
}));

// ---------------------------------------------------------------------
// Inicio: cifras del piloto
// ---------------------------------------------------------------------

const NOMBRES_MODULO = {
  menu: 'Menú', circulares: 'Circulares', horarios: 'Horarios', plataformas: 'Plataformas',
  evaluacion_docente: 'Evaluación docente', manual: 'Manual', identidad: 'Identidad', pqrs: 'PQRS',
  proxima_actividad: 'Próxima actividad', asesor: 'Asesor', sin_respuesta: 'Sin respuesta',
};

router.get('/', envolver(async (req, res) => {
  const c = await una(`SELECT
      (SELECT COUNT(*) FROM usuarios_whatsapp) AS usuarios,
      (SELECT COUNT(*) FROM interacciones WHERE fecha >= CURDATE()) AS hoy,
      (SELECT COUNT(*) FROM interacciones) AS total,
      (SELECT COUNT(*) FROM solicitudes_asesor WHERE estado <> 'atendida') AS asesor,
      (SELECT COUNT(*) FROM consultas_sin_respuesta WHERE estado = 'pendiente') AS sin_respuesta`);
  const modulos = await consulta(
    "SELECT modulo, COUNT(*) AS n FROM interacciones WHERE modulo NOT IN ('menu') GROUP BY modulo ORDER BY n DESC");
  const dias = await consulta(
    `SELECT DATE(fecha) AS dia, COUNT(*) AS consultas, COUNT(DISTINCT usuario_id) AS usuarios
       FROM interacciones GROUP BY DATE(fecha) ORDER BY dia DESC LIMIT 15`);
  res.send(pagina('Inicio', `
    <div class="cifras">
      <div class="cifra"><b>${c.usuarios}</b>personas distintas</div>
      <div class="cifra"><b>${c.hoy}</b>consultas hoy</div>
      <div class="cifra"><b>${c.total}</b>consultas en total</div>
      <div class="cifra"><b>${c.asesor}</b><a href="/panel/asesor">solicitudes de asesor abiertas</a></div>
      <div class="cifra"><b>${c.sin_respuesta}</b><a href="/panel/sin-respuesta">preguntas sin respuesta</a></div>
    </div>
    <h2>Consultas por módulo</h2>
    <table><tr><th>Módulo</th><th>Consultas</th></tr>
      ${modulos.map((m) => `<tr><td>${esc(NOMBRES_MODULO[m.modulo] || m.modulo)}</td><td>${m.n}</td></tr>`).join('') || '<tr><td colspan="2">Todavía no hay consultas.</td></tr>'}
    </table>
    <h2>Por día</h2>
    <table><tr><th>Día</th><th>Consultas</th><th>Personas</th></tr>
      ${dias.map((d) => `<tr><td>${esc(d.dia)}</td><td>${d.consultas}</td><td>${d.usuarios}</td></tr>`).join('') || '<tr><td colspan="3">Sin datos.</td></tr>'}
    </table>`, req.admin, avisoDe(req)));
}));

// ---------------------------------------------------------------------
// Bandeja de asesor
// ---------------------------------------------------------------------

function telefonoVisible(t) {
  return t ? `+${t.slice(0, 2)} ${t.slice(2, 5)} ${t.slice(5, 8)} ${t.slice(8)}` : '(borrado)';
}

router.get('/asesor', envolver(async (req, res) => {
  const abiertas = await consulta(
    `SELECT s.*, u.telefono FROM solicitudes_asesor s LEFT JOIN usuarios_whatsapp u ON u.id = s.usuario_id
      WHERE s.estado <> 'atendida' ORDER BY s.fecha`);
  const cerradas = await consulta(
    `SELECT s.*, u.telefono, a.nombre AS admin FROM solicitudes_asesor s
       LEFT JOIN usuarios_whatsapp u ON u.id = s.usuario_id LEFT JOIN administradores a ON a.id = s.atendida_por
      WHERE s.estado = 'atendida' ORDER BY s.atendida_en DESC LIMIT 20`);
  const tarjetas = abiertas.map((s) => {
    const horas = (Date.now() - new Date(s.fecha.replace(' ', 'T') + '-05:00')) / 3600000;
    const fueraDeVentana = horas > 23.5;
    return `
    <form class="caja" method="post" action="/panel/asesor/${s.id}">
      <div><b>${esc(telefonoVisible(s.telefono))}</b> <span class="gris">· ${esc(s.fecha)}</span></div>
      <div>${s.mensaje ? esc(s.mensaje).replace(/\n/g, '<br>') : '<span class="gris">Todavía no escribe su pregunta.</span>'}</div>
      ${fueraDeVentana ? '<div class="aviso error">Pasaron más de 24 horas: WhatsApp ya no permite responder gratis por el bot. Escríbele desde el celular del colegio o márcala como atendida.</div>' : ''}
      <label>Respuesta <textarea name="respuesta" ${fueraDeVentana ? 'disabled' : ''} placeholder="Escribe la respuesta que recibirá por WhatsApp"></textarea></label>
      <div style="display:flex;gap:8px;flex-wrap:wrap">
        <button class="boton" name="accion" value="responder" ${fueraDeVentana ? 'disabled' : ''}>Enviar respuesta y cerrar</button>
        <button class="boton secundario" name="accion" value="cerrar">Marcar como atendida sin enviar</button>
      </div>
    </form>`;
  }).join('');
  res.send(pagina('Solicitudes de asesor', `
    <p class="gris">Quien escribe <i>asesor</i> en el bot aparece aquí. La respuesta le llega por WhatsApp desde el número del bot.</p>
    ${tarjetas || '<p>No hay solicitudes abiertas. 🎉</p>'}
    <h2>Últimas atendidas</h2>
    <div class="scroll"><table><tr><th>Fecha</th><th>Teléfono</th><th>Pregunta</th><th>Respuesta</th><th>Atendió</th></tr>
      ${cerradas.map((s) => `<tr><td>${esc(s.atendida_en)}</td><td>${esc(telefonoVisible(s.telefono))}</td><td>${esc(s.mensaje)}</td><td>${esc(s.respuesta)}</td><td>${esc(s.admin)}</td></tr>`).join('') || '<tr><td colspan="5">Ninguna todavía.</td></tr>'}
    </table></div>`, req.admin, avisoDe(req)));
}));

router.post('/asesor/:id', envolver(async (req, res) => {
  const s = await una(
    `SELECT s.*, u.telefono FROM solicitudes_asesor s LEFT JOIN usuarios_whatsapp u ON u.id = s.usuario_id
      WHERE s.id = ? AND s.estado <> 'atendida'`, [req.params.id]);
  if (!s) return volver(res, '/panel/asesor', 'Esa solicitud ya fue atendida.', true);
  const respuesta = String(req.body.respuesta || '').trim();
  if (req.body.accion === 'responder') {
    if (!respuesta) return volver(res, '/panel/asesor', 'Escribe la respuesta antes de enviarla.', true);
    try {
      await whatsapp.enviar(s.telefono, { tipo: 'texto', texto: `👩‍🏫 Colegio Visión Mundial:\n\n${respuesta}` });
    } catch (err) {
      console.error('No se pudo enviar la respuesta de asesor', err);
      return volver(res, '/panel/asesor', 'WhatsApp no aceptó el mensaje. Revisa la conexión del bot e inténtalo de nuevo.', true);
    }
  }
  await consulta(
    `UPDATE solicitudes_asesor SET estado = 'atendida', respuesta = ?, atendida_por = ?, atendida_en = NOW() WHERE id = ?`,
    [respuesta || null, req.admin.id, s.id]);
  return volver(res, '/panel/asesor', req.body.accion === 'responder' ? 'Respuesta enviada.' : 'Solicitud cerrada.');
}));

// ---------------------------------------------------------------------
// Próxima actividad
// ---------------------------------------------------------------------

const CAMPOS_ACTIVIDAD = ['titulo', 'fecha', 'hora_inicio', 'hora_fin', 'lugar', 'dirigido_a',
  'descripcion', 'materiales', 'recordatorios', 'enlace_url', 'imagen_url'];

function formularioActividad(a = {}, accion = '/panel/actividades') {
  const v = (k) => esc(a[k] ? String(a[k]).slice(0, k.startsWith('hora') ? 5 : undefined) : '');
  return `
  <form class="caja" method="post" action="${accion}">
    <label>Título <input name="titulo" required maxlength="200" value="${v('titulo')}"></label>
    <div class="fila2">
      <label>Fecha <input type="date" name="fecha" required value="${v('fecha')}"></label>
      <label>Hora de inicio <input type="time" name="hora_inicio" value="${v('hora_inicio')}"></label>
      <label>Hora de fin <input type="time" name="hora_fin" value="${v('hora_fin')}"></label>
    </div>
    <div class="fila2">
      <label>Lugar <input name="lugar" maxlength="160" value="${v('lugar')}"></label>
      <label>Dirigido a <input name="dirigido_a" maxlength="160" value="${v('dirigido_a')}" placeholder="Ej. Estudiantes de todos los grados"></label>
    </div>
    <label>Descripción <textarea name="descripcion">${v('descripcion')}</textarea></label>
    <label>Qué deben traer <textarea name="materiales">${v('materiales')}</textarea></label>
    <label>Recordatorios <textarea name="recordatorios">${v('recordatorios')}</textarea></label>
    <div class="fila2">
      <label>Enlace (inscripción, formulario) <input type="url" name="enlace_url" value="${v('enlace_url')}"></label>
      <label>Imagen del comunicado (enlace público) <input type="url" name="imagen_url" value="${v('imagen_url')}"></label>
    </div>
    <button class="boton">Guardar</button>
  </form>`;
}

function valoresActividad(body) {
  return CAMPOS_ACTIVIDAD.map((k) => {
    const valor = String(body[k] ?? '').trim();
    return valor === '' ? null : valor;
  });
}

router.get('/actividades', envolver(async (req, res) => {
  const proximas = await consulta(
    'SELECT * FROM actividades WHERE fecha >= CURDATE() ORDER BY fecha, hora_inicio IS NULL, hora_inicio');
  const pasadas = await consulta('SELECT * FROM actividades WHERE fecha < CURDATE() ORDER BY fecha DESC LIMIT 10');
  const fila = (a) => `<tr>
      <td>${esc(a.fecha)}${a.hora_inicio ? ` ${esc(String(a.hora_inicio).slice(0, 5))}` : ''}</td>
      <td>${esc(a.titulo)}</td>
      <td>${a.publicada ? 'Publicada' : '<span class="gris">Oculta</span>'}</td>
      <td style="white-space:nowrap"><a href="/panel/actividades/${a.id}">Editar</a>
        <form method="post" action="/panel/actividades/${a.id}/publicar" style="display:inline">
          <button class="link">${a.publicada ? 'Ocultar' : 'Publicar'}</button></form></td></tr>`;
  res.send(pagina('Próxima actividad', `
    <p class="gris">El bot muestra la actividad publicada con la fecha más cercana. Cuando pasa la fecha, sale sola.</p>
    <table><tr><th>Fecha</th><th>Actividad</th><th>Estado</th><th></th></tr>
      ${proximas.map(fila).join('') || '<tr><td colspan="4">No hay actividades programadas.</td></tr>'}
    </table>
    <h2>Nueva actividad</h2>${formularioActividad()}
    <h2>Pasadas</h2>
    <table><tr><th>Fecha</th><th>Actividad</th><th>Estado</th><th></th></tr>${pasadas.map(fila).join('')}</table>`,
  req.admin, avisoDe(req)));
}));

router.post('/actividades', envolver(async (req, res) => {
  await consulta(
    `INSERT INTO actividades (${CAMPOS_ACTIVIDAD.join(', ')}, creada_por) VALUES (${CAMPOS_ACTIVIDAD.map(() => '?').join(', ')}, ?)`,
    [...valoresActividad(req.body), req.admin.id]);
  volver(res, '/panel/actividades', 'Actividad guardada.');
}));

router.get('/actividades/:id', envolver(async (req, res) => {
  const a = await una('SELECT * FROM actividades WHERE id = ?', [req.params.id]);
  if (!a) return volver(res, '/panel/actividades', 'No existe esa actividad.', true);
  return res.send(pagina('Editar actividad', formularioActividad(a, `/panel/actividades/${a.id}`), req.admin));
}));

router.post('/actividades/:id', envolver(async (req, res) => {
  await consulta(
    `UPDATE actividades SET ${CAMPOS_ACTIVIDAD.map((k) => `${k} = ?`).join(', ')} WHERE id = ?`,
    [...valoresActividad(req.body), req.params.id]);
  volver(res, '/panel/actividades', 'Actividad actualizada.');
}));

router.post('/actividades/:id/publicar', envolver(async (req, res) => {
  await consulta('UPDATE actividades SET publicada = 1 - publicada WHERE id = ?', [req.params.id]);
  volver(res, '/panel/actividades', 'Listo.');
}));

// ---------------------------------------------------------------------
// Circular actual
// ---------------------------------------------------------------------

router.get('/circular', envolver(async (req, res) => {
  const actual = await una('SELECT * FROM circulares WHERE es_actual = 1');
  const anteriores = await consulta('SELECT * FROM circulares WHERE es_actual = 0 ORDER BY fecha_publicacion DESC LIMIT 10');
  res.send(pagina('Circular actual', `
    ${actual ? `<p>El bot envía la <b>Circular N° ${esc(actual.numero)}</b>: ${esc(actual.titulo)} (${esc(actual.fecha_publicacion)}).
      ${actual.archivo_url ? `<a href="${esc(actual.archivo_url)}" target="_blank" rel="noopener">Ver PDF</a>` : '<br><span class="gris">Sin PDF: el bot solo envía el título y el enlace de Comunicaciones.</span>'}</p>` : '<p>No hay circular actual.</p>'}
    <h2>Publicar una circular nueva</h2>
    <p class="gris">La nueva reemplaza a la actual en el bot. El PDF debe estar en un enlace público que termine en .pdf o se abra directo (por ejemplo, la página del colegio).</p>
    <form class="caja" method="post" action="/panel/circular">
      <div class="fila2">
        <label>Número <input name="numero" required maxlength="20" placeholder="10"></label>
        <label>Fecha <input type="date" name="fecha_publicacion" required></label>
      </div>
      <label>Título <input name="titulo" required maxlength="200"></label>
      <label>Enlace del PDF <input type="url" name="archivo_url"></label>
      <button class="boton">Publicar como circular actual</button>
    </form>
    ${actual ? `<h2>Cambiar el PDF de la circular actual</h2>
    <form class="caja" method="post" action="/panel/circular/${actual.id}/pdf">
      <label>Enlace del PDF <input type="url" name="archivo_url" value="${esc(actual.archivo_url || '')}"></label>
      <button class="boton secundario">Guardar enlace</button>
    </form>` : ''}
    <h2>Anteriores</h2>
    <table><tr><th>N°</th><th>Título</th><th>Fecha</th></tr>
      ${anteriores.map((c) => `<tr><td>${esc(c.numero)}</td><td>${esc(c.titulo)}</td><td>${esc(c.fecha_publicacion)}</td></tr>`).join('') || '<tr><td colspan="3">—</td></tr>'}
    </table>`, req.admin, avisoDe(req)));
}));

router.post('/circular', envolver(async (req, res) => {
  const numero = String(req.body.numero || '').trim();
  const existe = await una('SELECT id FROM circulares WHERE numero = ?', [numero]);
  if (existe) return volver(res, '/panel/circular', `Ya existe la circular N° ${numero}.`, true);
  await consulta('UPDATE circulares SET es_actual = 0 WHERE es_actual = 1');
  await consulta(
    'INSERT INTO circulares (numero, titulo, fecha_publicacion, archivo_url, es_actual) VALUES (?, ?, ?, ?, 1)',
    [numero, String(req.body.titulo).trim(), req.body.fecha_publicacion, String(req.body.archivo_url || '').trim() || null]);
  return volver(res, '/panel/circular', `Circular N° ${numero} publicada.`);
}));

router.post('/circular/:id/pdf', envolver(async (req, res) => {
  await consulta('UPDATE circulares SET archivo_url = ? WHERE id = ?',
    [String(req.body.archivo_url || '').trim() || null, req.params.id]);
  volver(res, '/panel/circular', 'Enlace guardado.');
}));

// ---------------------------------------------------------------------
// Enlaces y textos del bot
// ---------------------------------------------------------------------

router.get('/enlaces', envolver(async (req, res) => {
  const enlaces = await consulta('SELECT * FROM enlaces ORDER BY id');
  const textos = await consulta('SELECT * FROM configuracion ORDER BY clave');
  res.send(pagina('Enlaces y textos', `
    <h2>Enlaces que envía el bot</h2>
    ${enlaces.map((e) => `
      <form class="caja" method="post" action="/panel/enlaces/${e.id}">
        <label>${esc(e.titulo)} <input name="url" required value="${esc(e.url)}"></label>
        ${e.descripcion ? `<span class="gris">${esc(e.descripcion)}</span>` : ''}
        <button class="boton secundario">Guardar</button>
      </form>`).join('')}
    <h2>Textos del bot</h2>
    ${textos.map((t) => `
      <form class="caja" method="post" action="/panel/textos/${esc(t.clave)}">
        <label>${esc(t.descripcion || t.clave)} <textarea name="valor" required>${esc(t.valor)}</textarea></label>
        <button class="boton secundario">Guardar</button>
      </form>`).join('')}`, req.admin, avisoDe(req)));
}));

router.post('/enlaces/:id', envolver(async (req, res) => {
  await consulta('UPDATE enlaces SET url = ? WHERE id = ?', [String(req.body.url).trim(), req.params.id]);
  volver(res, '/panel/enlaces', 'Enlace guardado.');
}));

router.post('/textos/:clave', envolver(async (req, res) => {
  await consulta('UPDATE configuracion SET valor = ? WHERE clave = ?', [String(req.body.valor).trim(), req.params.clave]);
  volver(res, '/panel/enlaces', 'Texto guardado.');
}));

// ---------------------------------------------------------------------
// Preguntas sin respuesta
// ---------------------------------------------------------------------

router.get('/sin-respuesta', envolver(async (req, res) => {
  const filas = await consulta(
    "SELECT * FROM consultas_sin_respuesta ORDER BY estado = 'pendiente' DESC, fecha DESC LIMIT 100");
  res.send(pagina('Preguntas sin respuesta', `
    <p class="gris">Lo que la gente escribió y el bot no supo responder. Sirve para agregar palabras clave o contenidos.</p>
    <div class="scroll"><table><tr><th>Fecha</th><th>Pregunta</th><th>Estado</th><th></th></tr>
      ${filas.map((f) => `<tr><td>${esc(f.fecha)}</td><td>${esc(f.texto)}</td><td>${esc(f.estado)}</td>
        <td>${f.estado === 'pendiente' ? `<form method="post" action="/panel/sin-respuesta/${f.id}"><button class="link">Marcar revisada</button></form>` : ''}</td></tr>`).join('') || '<tr><td colspan="4">Ninguna.</td></tr>'}
    </table></div>`, req.admin, avisoDe(req)));
}));

router.post('/sin-respuesta/:id', envolver(async (req, res) => {
  await consulta("UPDATE consultas_sin_respuesta SET estado = 'revisada' WHERE id = ?", [req.params.id]);
  volver(res, '/panel/sin-respuesta', 'Marcada como revisada.');
}));

// ---------------------------------------------------------------------
// Cuentas del panel
// ---------------------------------------------------------------------

const ROLES = { docente_encargada: 'Docente encargada', estudiante_admin: 'Estudiante administrador' };

async function paginaCuentas(req, res, temporalNueva = null) {
  const lista = await consulta('SELECT id, nombre, correo, rol, activo, ultimo_acceso FROM administradores ORDER BY id');
  const puedeAdministrar = req.admin.rol === 'docente_encargada';
  const temporal = temporalNueva
    ? `<div class="aviso">Contraseña temporal de la nueva cuenta: <b>${esc(temporalNueva)}</b><br>
       Cópiala ahora y entrégasela en persona; no se vuelve a mostrar.</div>` : '';
  res.send(pagina('Cuentas', `${temporal}
    <table><tr><th>Nombre</th><th>Correo</th><th>Rol</th><th>Último ingreso</th><th></th></tr>
      ${lista.map((a) => `<tr><td>${esc(a.nombre)}</td><td>${esc(a.correo)}</td><td>${esc(ROLES[a.rol])}</td>
        <td>${esc(a.ultimo_acceso || '—')}</td>
        <td>${puedeAdministrar && a.id !== req.admin.id ? `<form method="post" action="/panel/cuentas/${a.id}/activo">
          <button class="link">${a.activo ? 'Desactivar' : 'Activar'}</button></form>` : (a.activo ? '' : 'Inactiva')}</td></tr>`).join('')}
    </table>
    ${puedeAdministrar ? `<h2>Nueva cuenta</h2>
    <form class="caja" method="post" action="/panel/cuentas">
      <div class="fila2">
        <label>Nombre <input name="nombre" required maxlength="120"></label>
        <label>Correo <input type="email" name="correo" required></label>
      </div>
      <label>Rol <select name="rol">
        <option value="estudiante_admin">Estudiante administrador</option>
        <option value="docente_encargada">Docente encargada</option></select></label>
      <button class="boton">Crear cuenta</button>
    </form>` : ''}
    <h2>Cambiar mi contraseña</h2>
    <form class="caja" method="post" action="/panel/cuentas/mi-clave" style="max-width:420px">
      <label>Contraseña actual <input type="password" name="actual" required></label>
      <label>Nueva contraseña (mínimo 10 caracteres) <input type="password" name="nueva" required minlength="10"></label>
      <button class="boton secundario">Cambiar</button>
    </form>`, req.admin, avisoDe(req)));
}

router.get('/cuentas', envolver((req, res) => paginaCuentas(req, res)));

router.post('/cuentas', envolver(async (req, res) => {
  if (req.admin.rol !== 'docente_encargada') return volver(res, '/panel/cuentas', 'Solo la docente encargada crea cuentas.', true);
  const correo = String(req.body.correo || '').trim().toLowerCase();
  if (await una('SELECT id FROM administradores WHERE correo = ?', [correo])) {
    return volver(res, '/panel/cuentas', 'Ya existe una cuenta con ese correo.', true);
  }
  const rol = ROLES[req.body.rol] ? req.body.rol : 'estudiante_admin';
  const temporal = crypto.randomBytes(9).toString('base64url');
  await consulta('INSERT INTO administradores (nombre, correo, contrasena_hash, rol) VALUES (?, ?, ?, ?)',
    [String(req.body.nombre).trim(), correo, await bcrypt.hash(temporal, 10), rol]);
  return paginaCuentas(req, res, temporal);
}));

router.post('/cuentas/mi-clave', envolver(async (req, res) => {
  const fila = await una('SELECT contrasena_hash FROM administradores WHERE id = ?', [req.admin.id]);
  if (!await bcrypt.compare(String(req.body.actual || ''), fila.contrasena_hash)) {
    return volver(res, '/panel/cuentas', 'La contraseña actual no es correcta.', true);
  }
  const nueva = String(req.body.nueva || '');
  if (nueva.length < 10) return volver(res, '/panel/cuentas', 'La nueva contraseña debe tener al menos 10 caracteres.', true);
  await consulta('UPDATE administradores SET contrasena_hash = ? WHERE id = ?', [await bcrypt.hash(nueva, 10), req.admin.id]);
  return volver(res, '/panel/cuentas', 'Contraseña cambiada.');
}));

router.post('/cuentas/:id/activo', envolver(async (req, res) => {
  if (req.admin.rol !== 'docente_encargada' || Number(req.params.id) === req.admin.id) {
    return volver(res, '/panel/cuentas', 'No permitido.', true);
  }
  await consulta('UPDATE administradores SET activo = 1 - activo WHERE id = ?', [req.params.id]);
  return volver(res, '/panel/cuentas', 'Listo.');
}));

// ---------------------------------------------------------------------
// Estado del número de WhatsApp y registro en la Cloud API
// ---------------------------------------------------------------------

const ESTADOS = { CLOUD_API: 'Conectado a la Cloud API (registrado)', NOT_APPLICABLE: 'Sin registrar', ON_PREMISE: 'Otra plataforma' };

router.get('/whatsapp', envolver(async (req, res) => {
  let info = null;
  let error = null;
  try { info = await whatsapp.infoNumero(); } catch (e) { error = e.message; }
  const filas = info ? `
    <table>
      <tr><th>Número</th><td>${esc(info.display_phone_number)}</td></tr>
      <tr><th>Nombre visible</th><td>${esc(info.verified_name)} <span class="gris">(${esc(info.name_status || '—')})</span></td></tr>
      <tr><th>Estado</th><td>${esc(ESTADOS[info.platform_type] || info.platform_type || '—')}</td></tr>
      <tr><th>Verificación del código</th><td>${esc(info.code_verification_status || '—')}</td></tr>
      <tr><th>Calidad</th><td>${esc(info.quality_rating || '—')}</td></tr>
    </table>` : `<div class="aviso error">No se pudo consultar el número en Meta: ${esc(error)}</div>`;
  const puedeRegistrar = req.admin.rol === 'docente_encargada';
  res.send(pagina('Número de WhatsApp', `
    <p class="gris">Datos del número configurado en WHATSAPP_PHONE_NUMBER_ID.</p>
    ${filas}
    ${puedeRegistrar ? `<h2>Registrar el número en la Cloud API</h2>
    <p class="gris">Solo se usa una vez, al conectar un número real (parte 4 de la guía). El PIN son 6 dígitos que tú eliges; guárdalo, Meta lo pide si el número se vuelve a registrar.</p>
    <form class="caja" method="post" action="/panel/whatsapp/registrar" style="max-width:360px">
      <label>PIN de 6 dígitos <input name="pin" required pattern="[0-9]{6}" inputmode="numeric" maxlength="6"></label>
      <button class="boton">Registrar número</button>
    </form>` : ''}`, req.admin, avisoDe(req)));
}));

router.post('/whatsapp/registrar', envolver(async (req, res) => {
  if (req.admin.rol !== 'docente_encargada') return volver(res, '/panel/whatsapp', 'No permitido.', true);
  const pin = String(req.body.pin || '');
  if (!/^\d{6}$/.test(pin)) return volver(res, '/panel/whatsapp', 'El PIN debe tener 6 dígitos.', true);
  try {
    await whatsapp.registrarNumero(pin);
  } catch (e) {
    return volver(res, '/panel/whatsapp', `Meta no registró el número: ${e.message}`, true);
  }
  return volver(res, '/panel/whatsapp', 'Número registrado. Ya puede recibir y responder mensajes.');
}));

module.exports = router;
