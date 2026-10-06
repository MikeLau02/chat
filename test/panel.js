// Prueba el panel en un navegador (Playwright) con WhatsApp simulado.
// Requiere la base con test/datos-prueba.sql, una solicitud de asesor abierta (npm run simular)
// y una cuenta creada con scripts/crear-admin.js. Uso:
//   CORREO_PRUEBA=... CLAVE_PRUEBA=... node test/panel.js
process.env.DATABASE_URL ||= 'mysql://bot:bot@127.0.0.1:3306/chatbot_vm';
Object.assign(process.env, { WHATSAPP_TOKEN: 't', WHATSAPP_PHONE_NUMBER_ID: '1', WHATSAPP_VERIFY_TOKEN: 'v' });
const assert = require('assert');
const enviados = [];
const fetchReal = global.fetch;
global.fetch = async (url, opts) => {
  if (String(url).startsWith('https://graph.facebook.com')) { enviados.push(JSON.parse(opts.body)); return new Response('{}'); }
  return fetchReal(url, opts);
};
const { chromium } = require(process.env.PLAYWRIGHT_PATH || 'playwright');
const app = require('../src/server');
const { pool } = require('../src/db');
const pass = process.env.CLAVE_PRUEBA;

(async () => {
  const srv = app.listen(0);
  const base = `http://127.0.0.1:${srv.address().port}`;
  const browser = await chromium.launch();
  const page = await browser.newPage({ viewport: { width: 390, height: 844 } });
  await page.goto(`${base}/panel`);
  assert.ok(page.url().endsWith('/panel/ingresar'));
  await page.fill('input[name=correo]', process.env.CORREO_PRUEBA);
  await page.fill('input[name=contrasena]', 'mala');
  await page.click('button.boton');
  assert.ok(await page.isVisible('text=Correo o contraseña incorrectos'));
  await page.fill('input[name=correo]', process.env.CORREO_PRUEBA);
  await page.fill('input[name=contrasena]', pass);
  await page.click('button.boton');
  await page.waitForSelector('text=personas distintas');
  await page.screenshot({ path: '/tmp/p-inicio.png', fullPage: true });

  await page.click('nav >> text=Asesor');
  await page.fill('textarea[name=respuesta]', 'La reunión es el viernes a las 6:30 a.m.');
  await page.click('text=Enviar respuesta y cerrar');
  await page.waitForSelector('text=Respuesta enviada.');
  await page.screenshot({ path: '/tmp/p-asesor.png', fullPage: true });
  assert.equal(enviados.length, 1);
  assert.ok(enviados[0].text.body.includes('viernes'));

  await page.click('nav >> text=Actividades');
  await page.fill('input[name=titulo]', 'Reunión de padres');
  await page.fill('input[name=fecha]', '2026-10-06');
  await page.fill('input[name=hora_inicio]', '06:30');
  await page.click('form.caja button.boton');
  await page.waitForSelector('text=Actividad guardada.');
  await page.screenshot({ path: '/tmp/p-actividades.png', fullPage: true });

  await page.click('nav >> text=Circular');
  await page.fill('input[name=numero]', '10');
  await page.fill('input[name=fecha_publicacion]', '2026-10-05');
  await page.fill('input[name=titulo]', 'Semana de la ciencia');
  await page.click('text=Publicar como circular actual');
  await page.waitForSelector('text=Circular N° 10 publicada.');

  await page.click('nav >> text=Enlaces y textos');
  await page.click('nav >> text=Sin respuesta');
  await page.waitForSelector('text=xyzzy');
  await page.screenshot({ path: '/tmp/p-sinresp.png', fullPage: true });

  const ancho = await page.evaluate(() => document.documentElement.scrollWidth);
  console.log('scrollWidth', ancho);
  await page.click('text=Salir');
  await page.goto(`${base}/panel/asesor`);
  assert.ok(page.url().endsWith('/panel/ingresar'));
  console.log('Panel OK');
  await browser.close(); srv.close(); await pool.end();
})().catch(async (e) => { console.error(e); process.exit(1); });
