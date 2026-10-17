// Simula el primer arranque en la nube: base vacía, instalación automática,
// creación de la primera cuenta con PANEL_SECRET y alta de una segunda cuenta.
// Uso: DATABASE_URL=mysql://.../base_vacia PLAYWRIGHT_PATH=... node test/instalacion.js
Object.assign(process.env, {
  WHATSAPP_TOKEN: 't', WHATSAPP_PHONE_NUMBER_ID: '1', WHATSAPP_VERIFY_TOKEN: 'v',
  PANEL_SECRET: 'clave-de-instalacion-de-prueba-123',
});
const assert = require('assert');
const { chromium } = require(process.env.PLAYWRIGHT_PATH || 'playwright');
const { instalarSiHaceFalta } = require('../src/instalar');
const app = require('../src/server');
const { pool, una } = require('../src/db');

(async () => {
  assert.equal(await instalarSiHaceFalta(), true, 'debe instalar en base vacía');
  assert.equal(await instalarSiHaceFalta(), false, 'la segunda vez no hace nada');
  const { n } = await una('SELECT COUNT(*) AS n FROM horarios');
  assert.ok(n > 300, `horario cargado (${n})`);

  const srv = app.listen(0);
  const base = `http://127.0.0.1:${srv.address().port}`;
  const browser = await chromium.launch();
  const page = await browser.newPage({ viewport: { width: 390, height: 844 } });
  await page.goto(`${base}/panel`);
  await page.waitForSelector('text=Crear la primera cuenta');
  await page.fill('input[name=nombre]', 'Laura González');
  await page.fill('input[name=correo]', 'laura@prueba.co');
  await page.fill('input[name=contrasena]', 'contrasena-segura');
  await page.fill('input[name=clave]', 'clave-equivocada-1234567');
  await page.click('button.boton');
  await page.waitForSelector('text=no coincide');
  await page.fill('input[name=nombre]', 'Laura González');
  await page.fill('input[name=correo]', 'laura@prueba.co');
  await page.fill('input[name=contrasena]', 'contrasena-segura');
  await page.fill('input[name=clave]', process.env.PANEL_SECRET);
  await page.click('button.boton');
  await page.waitForSelector('text=Cuenta creada');

  await page.click('nav >> text=Cuentas');
  await page.fill('input[name=nombre]', 'Abraham Candanoza');
  await page.fill('input[name=correo]', 'abraham@prueba.co');
  await page.click('text=Crear cuenta');
  const temporal = (await page.textContent('.aviso b')).trim();
  await page.screenshot({ path: '/tmp/cuentas.png', fullPage: true });
  assert.ok(!page.url().includes(temporal), 'la contraseña no va en la URL');
  await page.click('text=Salir');

  await page.goto(`${base}/panel/ingresar`);
  await page.fill('input[name=correo]', 'abraham@prueba.co');
  await page.fill('input[name=contrasena]', temporal);
  await page.click('button.boton');
  await page.waitForSelector('text=personas distintas');
  await page.click('nav >> text=Cuentas');
  assert.ok(!(await page.isVisible('text=Nueva cuenta')), 'el estudiante no crea cuentas');
  console.log('Instalación OK');
  await browser.close(); srv.close(); await pool.end();
})().catch(async (e) => { console.error(e); process.exit(1); });
