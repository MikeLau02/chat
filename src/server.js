const express = require('express');
const config = require('./config');
const { responder } = require('./bot');
const whatsapp = require('./whatsapp');
const panel = require('./panel');

const app = express();

// Se guarda el cuerpo crudo para validar la firma de Meta.
app.use(express.json({ verify: (req, _res, buf) => { req.cuerpoCrudo = buf; } }));

app.get('/', (_req, res) => res.send('Chatbot Colegio Visión Mundial: en línea'));
app.use('/panel', panel);

// Verificación del webhook (Meta la hace una sola vez al configurarlo).
app.get('/webhook', (req, res) => {
  const ok = req.query['hub.mode'] === 'subscribe' && req.query['hub.verify_token'] === config.whatsapp.verifyToken;
  if (ok) return res.status(200).send(req.query['hub.challenge']);
  return res.sendStatus(403);
});

// Meta reintenta si no recibe 200 rápido, así que se responde de inmediato
// y se descartan los mensajes repetidos.
const procesados = new Set();
function yaProcesado(id) {
  if (procesados.has(id)) return true;
  procesados.add(id);
  if (procesados.size > 5000) procesados.delete(procesados.values().next().value);
  return false;
}

app.post('/webhook', (req, res) => {
  if (!whatsapp.firmaValida(req.cuerpoCrudo, req.get('x-hub-signature-256'))) return res.sendStatus(401);
  res.sendStatus(200);

  for (const entry of req.body.entry || []) {
    for (const change of entry.changes || []) {
      for (const msg of change.value?.messages || []) {
        if (yaProcesado(msg.id)) continue;
        atender(msg).catch((err) => console.error('Error atendiendo mensaje', msg.id, err));
      }
    }
  }
});

async function atender(msg) {
  const telefono = msg.from;
  let entrada = '';
  let esTexto = true;
  if (msg.type === 'text') entrada = msg.text.body;
  else if (msg.type === 'interactive') entrada = msg.interactive?.button_reply?.title || msg.interactive?.list_reply?.title || '';
  else if (msg.type === 'button') entrada = msg.button?.text || '';
  else esTexto = false;

  whatsapp.marcarLeido(msg.id).catch(() => {});
  const mensajes = await responder(telefono, entrada, { esTexto });
  for (const m of mensajes) await whatsapp.enviar(telefono, m);
}

if (require.main === module) {
  require('./instalar').instalarSiHaceFalta()
    .catch((err) => console.error('No se pudo preparar la base de datos:', err.message))
    .finally(() => app.listen(config.port, () => console.log(`Bot escuchando en el puerto ${config.port}`)));
}

module.exports = app;
