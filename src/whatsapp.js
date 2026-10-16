// Cliente mínimo de la WhatsApp Cloud API.
const crypto = require('crypto');
const config = require('./config');

const LIMITE_TEXTO = 4000; // WhatsApp acepta hasta 4096 caracteres por mensaje

function url() {
  return `https://graph.facebook.com/${config.whatsapp.graphVersion}/${config.whatsapp.phoneNumberId}/messages`;
}

async function llamar(cuerpo) {
  const res = await fetch(url(), {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${config.whatsapp.token}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ messaging_product: 'whatsapp', ...cuerpo }),
  });
  if (!res.ok) {
    const detalle = await res.text();
    throw new Error(`WhatsApp respondió ${res.status}: ${detalle}`);
  }
  return res.json();
}

function partirTexto(texto) {
  const partes = [];
  let resto = texto;
  while (resto.length > LIMITE_TEXTO) {
    let corte = resto.lastIndexOf('\n', LIMITE_TEXTO);
    if (corte < LIMITE_TEXTO / 2) corte = LIMITE_TEXTO;
    partes.push(resto.slice(0, corte));
    resto = resto.slice(corte).replace(/^\n+/, '');
  }
  partes.push(resto);
  return partes;
}

// A quién va el mensaje: un teléfono (solo dígitos) va en "to"; el identificador
// por negocio (BSUID, p. ej. "CO.1234…") de quien usa nombre de usuario va en "recipient".
function destino(id) {
  return /^\d+$/.test(String(id)) ? { to: String(id) } : { recipient: String(id) };
}

// Envía un mensaje del formato que produce bot.js:
//   { tipo: 'texto', texto } | { tipo: 'documento', url, nombre, texto } | { tipo: 'imagen', url, texto }
async function enviar(para, mensaje) {
  const a = destino(para);
  if (mensaje.tipo === 'documento') {
    return llamar({
      ...a, type: 'document',
      document: { link: mensaje.url, filename: mensaje.nombre, caption: mensaje.texto },
    });
  }
  if (mensaje.tipo === 'imagen') {
    return llamar({ ...a, type: 'image', image: { link: mensaje.url, caption: mensaje.texto } });
  }
  for (const parte of partirTexto(mensaje.texto)) {
    await llamar({ ...a, type: 'text', text: { body: parte, preview_url: true } });
  }
}

async function graph(ruta, opciones = {}) {
  const res = await fetch(`https://graph.facebook.com/${config.whatsapp.graphVersion}/${ruta}`, {
    ...opciones,
    headers: { Authorization: `Bearer ${config.whatsapp.token}`, 'Content-Type': 'application/json' },
  });
  const cuerpo = await res.json().catch(() => ({}));
  if (!res.ok) throw new Error(cuerpo.error?.message || `Meta respondió ${res.status}`);
  return cuerpo;
}

// Datos del número conectado (para revisar desde el panel).
function infoNumero() {
  return graph(`${config.whatsapp.phoneNumberId}?fields=display_phone_number,verified_name,name_status,quality_rating,code_verification_status,platform_type`);
}

// Registro del número en la Cloud API con el PIN de verificación en dos pasos (6 dígitos).
function registrarNumero(pin) {
  return graph(`${config.whatsapp.phoneNumberId}/register`, {
    method: 'POST', body: JSON.stringify({ messaging_product: 'whatsapp', pin }),
  });
}

async function marcarLeido(idMensaje) {
  return llamar({ status: 'read', message_id: idMensaje });
}

// Comprueba la cabecera X-Hub-Signature-256 que Meta agrega a cada webhook.
function firmaValida(cuerpoCrudo, cabecera) {
  if (!config.whatsapp.appSecret) return true; // sin secreto configurado (solo desarrollo)
  if (!cabecera || !cabecera.startsWith('sha256=')) return false;
  const esperada = crypto.createHmac('sha256', config.whatsapp.appSecret).update(cuerpoCrudo).digest('hex');
  const recibida = cabecera.slice(7);
  return recibida.length === esperada.length &&
    crypto.timingSafeEqual(Buffer.from(recibida), Buffer.from(esperada));
}

module.exports = { enviar, destino, marcarLeido, firmaValida, partirTexto, infoNumero, registrarNumero };
