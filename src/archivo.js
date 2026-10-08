// Imágenes de horario y PDF de circulares que se suben desde el panel. Se guardan
// en la base de datos (el disco de Render se borra en cada despliegue) y se sirven
// en /archivos/<token>/<nombre> para que Meta los descargue al enviarlos.
const crypto = require('crypto');
const express = require('express');
const { consulta, una } = require('./db');
const config = require('./config');

const TIPOS = {
  imagen: { maximo: 5 * 1024 * 1024, mimes: ['image/jpeg', 'image/png'] },
  pdf: { maximo: 10 * 1024 * 1024, mimes: ['application/pdf'] },
};

// Tipo real del archivo según sus primeros bytes (no se confía en el nombre).
function mimeReal(buffer) {
  if (buffer.subarray(0, 4).toString('latin1') === '%PDF') return 'application/pdf';
  if (buffer[0] === 0x89 && buffer.subarray(1, 4).toString('latin1') === 'PNG') return 'image/png';
  if (buffer[0] === 0xff && buffer[1] === 0xd8 && buffer[2] === 0xff) return 'image/jpeg';
  return null;
}

// Devuelve el mensaje de error, o null si el archivo sirve.
function validar(buffer, clase) {
  const regla = TIPOS[clase];
  if (!buffer?.length) return 'Elige un archivo.';
  if (buffer.length > regla.maximo) return `El archivo pesa más de ${regla.maximo / 1024 / 1024} MB.`;
  if (!regla.mimes.includes(mimeReal(buffer))) {
    return clase === 'pdf' ? 'El archivo debe ser un PDF.' : 'La imagen debe ser JPG o PNG.';
  }
  return null;
}

// El panel envía el archivo como data URL ("data:image/png;base64,...").
function desdeDataUrl(valor) {
  const m = /^data:[^;,]*;base64,(.*)$/s.exec(String(valor || ''));
  return m ? Buffer.from(m[1], 'base64') : null;
}

function nombreSeguro(nombre, mime) {
  const ext = { 'application/pdf': 'pdf', 'image/png': 'png', 'image/jpeg': 'jpg' }[mime];
  const base = String(nombre).normalize('NFD').replace(/[̀-ͯ]/g, '').replace(/[^A-Za-z0-9-]+/g, '-')
    .replace(/^-|-$/g, '').slice(0, 80) || 'archivo';
  return `${base}.${ext}`;
}

async function guardar(tipo, refId, nombre, buffer, adminId) {
  const mime = mimeReal(buffer);
  await consulta(
    `INSERT INTO archivos (tipo, ref_id, nombre, mime, tamano, token, datos, subido_por) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
     ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), mime = VALUES(mime), tamano = VALUES(tamano),
       token = VALUES(token), datos = VALUES(datos), subido_por = VALUES(subido_por), creado_en = NOW()`,
    [tipo, refId, nombreSeguro(nombre, mime), mime, buffer.length, crypto.randomBytes(16).toString('hex'), buffer, adminId]);
}

function borrar(tipo, refId) {
  return consulta('DELETE FROM archivos WHERE tipo = ? AND ref_id = ?', [tipo, refId]);
}

// Datos de los archivos de un tipo (sin el contenido), por ref_id.
async function listar(tipo) {
  const filas = await consulta('SELECT ref_id, nombre, tamano, token, creado_en FROM archivos WHERE tipo = ?', [tipo]);
  return new Map(filas.map((f) => [f.ref_id, { ...f, ruta: `/archivos/${f.token}/${f.nombre}` }]));
}

// URL pública para que Meta descargue el archivo, o null si no hay.
async function urlDe(tipo, refId) {
  if (!config.urlPublica) return null;
  const f = await una('SELECT token, nombre FROM archivos WHERE tipo = ? AND ref_id = ?', [tipo, refId]);
  return f ? `${config.urlPublica}/archivos/${f.token}/${f.nombre}` : null;
}

const router = express.Router();
router.get('/:token/:nombre', async (req, res, next) => {
  try {
    if (!/^[0-9a-f]{32}$/.test(req.params.token)) return res.sendStatus(404);
    const f = await una('SELECT nombre, mime, datos FROM archivos WHERE token = ?', [req.params.token]);
    if (!f) return res.sendStatus(404);
    res.set({
      'Content-Type': f.mime,
      'Content-Disposition': `inline; filename="${f.nombre}"`,
      'Cache-Control': 'public, max-age=300',
      'X-Content-Type-Options': 'nosniff',
    });
    res.send(f.datos);
  } catch (err) {
    next(err);
  }
});

module.exports = { validar, desdeDataUrl, guardar, borrar, listar, urlDe, router };
