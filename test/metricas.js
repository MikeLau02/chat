// Prueba en el navegador las páginas Métricas e Historial del panel.
// Uso: CORREO_PRUEBA=... CLAVE_PRUEBA=... PLAYWRIGHT_PATH=... node test/metricas.js
process.env.DATABASE_URL ||= 'mysql://bot:bot@127.0.0.1:3306/chatbot_vm';
Object.assign(process.env, { WHATSAPP_TOKEN: 't', WHATSAPP_PHONE_NUMBER_ID: '1', WHATSAPP_VERIFY_TOKEN: 'v' });
const assert = require('assert');
const { chromium } = require(process.env.PLAYWRIGHT_PATH || 'playwright');
const app = require('../src/server');
const { pool } = require('../src/db');
const capturas = process.env.CAPTURAS || '/tmp';

(async () => {
  const srv = app.listen(0);
  const base = `http://127.0.0.1:${srv.address().port}`;
  const browser = await chromium.launch(process.env.CHROMIUM ? { executablePath: process.env.CHROMIUM } : {});
  const page = await browser.newPage({ viewport: { width: 1100, height: 900 } });
  const errores = [];
  page.on('response', (r) => { if (r.status() >= 500) errores.push(r.url()); });
  await page.goto(`${base}/panel/ingresar`);
  await page.fill('input[name=correo]', process.env.CORREO_PRUEBA);
  await page.fill('input[name=contrasena]', process.env.CLAVE_PRUEBA);
  await page.click('button.boton');
  await page.waitForSelector('text=personas distintas');

  await page.click('nav >> text=Métricas');
  await page.waitForSelector('text=personas escribieron');
  assert.ok(await page.isVisible('text=Respuestas que no llegaron'));
  await page.screenshot({ path: `${capturas}/panel-metricas.png`, fullPage: true });

  const descarga = page.waitForEvent('download');
  await page.click('a:has-text("mensajes")');
  const csv = await (await descarga).createReadStream();
  let texto = ''; for await (const t of csv) texto += t;
  assert.ok(texto.startsWith('﻿Fecha;Nombre;Teléfono'), 'CSV con encabezado');

  await page.click('nav >> text=Historial');
  await page.waitForSelector('text=Primer contacto');
  await page.screenshot({ path: `${capturas}/panel-historial.png`, fullPage: true });
  await page.fill('input[name=buscar]', 'Carlos');
  await page.click('form.filtro button');
  await page.click('table a >> nth=0');
  await page.waitForSelector('text=Conversación');
  assert.ok(await page.locator('.burbuja').count() > 0, 'muestra la conversación');
  await page.screenshot({ path: `${capturas}/panel-conversacion.png`, fullPage: true });

  const movil = await browser.newPage({ viewport: { width: 390, height: 844 } });
  await movil.context().addCookies(await page.context().cookies());
  await movil.goto(`${base}/panel/metricas`);
  const ancho = await movil.evaluate(() => document.documentElement.scrollWidth);
  assert.ok(ancho <= 390, `sin desplazamiento horizontal en el celular (${ancho})`);

  assert.deepEqual(errores, []);
  console.log('Métricas e historial OK');
  await browser.close(); srv.close(); await pool.end();
})().catch((e) => { console.error(e); process.exit(1); });
