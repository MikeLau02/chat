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

// Política de privacidad: Meta pide su enlace para publicar la app.
const PRIVACIDAD = `<!doctype html><html lang="es"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Política de privacidad · Chatbot Colegio Visión Mundial</title>
<style>body{font-family:system-ui,sans-serif;max-width:760px;margin:2rem auto;padding:0 16px;line-height:1.55;color:#1f2933}h1{font-size:1.5rem}h2{font-size:1.1rem;margin-top:1.6rem}</style>
</head><body>
<h1>Política de privacidad del chatbot de WhatsApp del Colegio Visión Mundial</h1>
<p>El Colegio Visión Mundial (Montería, Colombia) usa este chatbot para responder por WhatsApp preguntas de la comunidad educativa sobre horarios, circulares, actividades, plataformas y normas institucionales. Esta política explica qué datos trata y cómo, de acuerdo con la Ley 1581 de 2012 de Colombia.</p>
<h2>Datos que se recogen</h2>
<p>El número de WhatsApp de quien escribe, los mensajes que envía al chatbot, las respuestas dadas y la fecha y hora de cada conversación. Si la persona pide hablar con un asesor, también se guarda la pregunta que deja.</p>
<h2>Para qué se usan</h2>
<p>Solo para responder las consultas, atender las solicitudes de asesor y mejorar el servicio a partir de las preguntas que el chatbot no supo responder. No se venden ni se comparten con terceros, ni se usan con fines publicitarios.</p>
<h2>Quién tiene acceso</h2>
<p>Únicamente el personal autorizado por el colegio que administra el chatbot. Los mensajes viajan por la plataforma de WhatsApp de Meta, que tiene su propia política de privacidad.</p>
<h2>Cuánto tiempo se guardan</h2>
<p>Mientras dure el piloto del chatbot y el tiempo necesario para su evaluación. Después se eliminan o se anonimizan.</p>
<h2>Sus derechos</h2>
<p>Cualquier persona puede conocer, actualizar, rectificar o pedir que se eliminen sus datos, o dejar de usar el chatbot en cualquier momento. Para hacerlo, puede escribir "asesor" en el chatbot o dirigirse a la secretaría del colegio.</p>
<p>Última actualización: 7 de octubre de 2026.</p>
</body></html>`;
app.get('/privacidad', (_req, res) => res.type('html').send(PRIVACIDAD));

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

