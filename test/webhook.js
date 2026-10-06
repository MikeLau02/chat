// Prueba el webhook de punta a punta con un fetch simulado (no llama a Meta).
process.env.DATABASE_URL ||= 'mysql://bot:bot@127.0.0.1:3306/chatbot_vm';
Object.assign(process.env, {
  WHATSAPP_TOKEN: 'prueba', WHATSAPP_PHONE_NUMBER_ID: '123', WHATSAPP_VERIFY_TOKEN: 'secreto', WHATSAPP_APP_SECRET: 'clave',
});
const crypto = require('crypto');
const assert = require('assert');
const enviados = [];
const fetchReal = global.fetch;
global.fetch = async (url, opts) => {
  if (String(url).startsWith('https://graph.facebook.com')) {
    enviados.push(JSON.parse(opts.body));
    return new Response('{}', { status: 200 });
  }
  return fetchReal(url, opts);
};
const app = require('../src/server');
const { pool } = require('../src/db');

(async () => {
  const srv = app.listen(0);
  const base = `http://127.0.0.1:${srv.address().port}`;

  let r = await fetchReal(`${base}/webhook?hub.mode=subscribe&hub.verify_token=secreto&hub.challenge=abc`);
  assert.equal(await r.text(), 'abc');
  r = await fetchReal(`${base}/webhook?hub.mode=subscribe&hub.verify_token=malo&hub.challenge=abc`);
  assert.equal(r.status, 403);

  const cuerpo = JSON.stringify({ entry: [{ changes: [{ value: { messages: [
    { id: 'wamid.1', from: '573009998877', type: 'text', text: { body: 'hola' } },
  ] } }] }] });
  const firma = 'sha256=' + crypto.createHmac('sha256', 'clave').update(cuerpo).digest('hex');
  r = await fetchReal(`${base}/webhook`, { method: 'POST', body: cuerpo, headers: { 'content-type': 'application/json', 'x-hub-signature-256': 'sha256=00' } });
  assert.equal(r.status, 401);
  for (let i = 0; i < 2; i++) { // el segundo es un reintento de Meta y se ignora
    r = await fetchReal(`${base}/webhook`, { method: 'POST', body: cuerpo, headers: { 'content-type': 'application/json', 'x-hub-signature-256': firma } });
    assert.equal(r.status, 200);
  }
  await new Promise((ok) => setTimeout(ok, 500));
  const textos = enviados.filter((e) => e.type === 'text');
  assert.equal(textos.length, 2, 'aviso de datos + menú');
  assert.equal(enviados.filter((e) => e.status === 'read').length, 1);
  assert.ok(textos[1].text.body.includes('1. Circulares'));
  console.log('Webhook OK:', enviados.length, 'llamadas a Meta');
  srv.close(); await pool.end();
})().catch(async (e) => { console.error(e); process.exit(1); });
