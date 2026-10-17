// Prueba la subida de la imagen de horario por grupo y del PDF de una circular
// desde el panel, que /archivos los sirva y que el bot los envíe. Uso:
//   PLAYWRIGHT_PATH=... node test/archivos.js
process.env.DATABASE_URL ||= 'mysql://bot:bot@127.0.0.1:3306/chatbot_vm';
Object.assign(process.env, { WHATSAPP_TOKEN: 't', WHATSAPP_PHONE_NUMBER_ID: '1', WHATSAPP_VERIFY_TOKEN: 'v' });
const assert = require('assert');
const fs = require('fs');
const os = require('os');
const path = require('path');
const bcrypt = require('bcryptjs');
const { chromium } = require(process.env.PLAYWRIGHT_PATH || 'playwright');
const { instalarSiHaceFalta } = require('../src/instalar');
const app = require('../src/server');
const { responder } = require('../src/bot');
const { pool, consulta, una } = require('../src/db');

// PNG de 1x1 y un PDF mínimo.
const PNG = Buffer.from('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==', 'base64');
const PDF = Buffer.from('%PDF-1.4\n1 0 obj<<>>endobj\ntrailer<<>>\n%%EOF\n');

(async () => {
  await instalarSiHaceFalta();
  const correo = 'prueba-archivos@colegio.co';
  await consulta('DELETE FROM administradores WHERE correo = ?', [correo]);
  await consulta("INSERT INTO administradores (nombre, correo, contrasena_hash, rol) VALUES ('Prueba', ?, ?, 'docente_encargada')",
    [correo, await bcrypt.hash('contrasena-prueba', 4)]);
  await consulta("DELETE FROM circulares WHERE numero = 'T-08'");
  await consulta("INSERT INTO circulares (numero, titulo, fecha_publicacion, es_actual) VALUES ('T-08', 'Anterior de prueba', '2026-09-01', 0)");
  const anterior = await una("SELECT id FROM circulares WHERE numero = 'T-08'");
  const actual = await una('SELECT id, numero FROM circulares WHERE es_actual = 1');
  assert.ok(actual, 'hay circular actual');
  const g11b = await una("SELECT id FROM grupos WHERE nombre = '11B'");
  await consulta("DELETE FROM archivos WHERE tipo = 'horario_grupo' AND ref_id = ?", [g11b.id]);

  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'arch-'));
  fs.writeFileSync(path.join(dir, 'horario 11B.png'), PNG);
  fs.writeFileSync(path.join(dir, 'circular.pdf'), PDF);
  fs.writeFileSync(path.join(dir, 'falso.png'), Buffer.from('no soy imagen'));

  const srv = app.listen(0);
  const base = `http://127.0.0.1:${srv.address().port}`;
  process.env.PUBLIC_URL = base;
  const browser = await chromium.launch();
  const page = await browser.newPage({ viewport: { width: 390, height: 844 } });
  await page.goto(`${base}/panel/ingresar`);
  await page.fill('input[name=correo]', correo);
  await page.fill('input[name=contrasena]', 'contrasena-prueba');
  await page.click('button.boton');
  await page.waitForURL(`${base}/panel`);

  // Imagen de horario: primero un archivo que no es imagen, luego uno válido.
  await page.click('nav >> text=Horarios');
  const fila = page.locator('tr', { hasText: '11B' });
  await fila.locator('input[type=file]').setInputFiles(path.join(dir, 'falso.png'));
  await fila.locator('button.boton').click();
  await page.waitForSelector('text=La imagen debe ser JPG o PNG.');
  await page.locator('tr', { hasText: '11B' }).locator('input[type=file]').setInputFiles(path.join(dir, 'horario 11B.png'));
  await page.locator('tr', { hasText: '11B' }).locator('button.boton').click();
  await page.waitForSelector('text=Imagen del horario de 11B guardada.');
  await page.screenshot({ path: '/tmp/p-horarios.png', fullPage: true });

  // PDF de la circular actual y de una anterior.
  await page.click('nav >> text=Circular');
  await page.locator('form.subida').first().locator('input[type=file]').setInputFiles(path.join(dir, 'circular.pdf'));
  await page.locator('form.subida').first().locator('button.boton').click();
  await page.waitForSelector(`text=PDF de la circular N° ${actual.numero} guardado.`);
  const filaAnterior = page.locator('tr', { hasText: 'T-08' });
  await filaAnterior.locator('summary').click();
  await filaAnterior.locator('input[type=file]').setInputFiles(path.join(dir, 'circular.pdf'));
  await filaAnterior.locator('button.boton').click();
  await page.waitForSelector('text=PDF de la circular N° T-08 guardado.');
  await page.screenshot({ path: '/tmp/p-circular.png', fullPage: true });
  await browser.close();

  // Lo que envía el bot.
  const tel = '573005550101';
  await consulta('DELETE FROM usuarios_whatsapp WHERE telefono = ?', [tel]);
  await responder(tel, 'hola');
  let r = await responder(tel, 'horario 11B');
  assert.equal(r[0].tipo, 'imagen', 'horario 11B sin día manda la imagen');
  assert.ok(r[0].url.startsWith(`${base}/archivos/`));
  const img = await fetch(r[0].url);
  assert.equal(img.headers.get('content-type'), 'image/png');
  assert.ok(Buffer.from(await img.arrayBuffer()).equals(PNG), 'sirve la misma imagen');
  r = await responder(tel, 'horario 11B martes');
  assert.equal(r[0].tipo, 'texto', 'con día pedido responde solo texto');
  r = await responder(tel, 'semana');
  assert.equal(r[0].tipo, 'imagen', 'semana manda la imagen');
  r = await responder(tel, 'horario 10A');
  assert.equal(r[0].tipo, 'texto', 'grupo sin imagen sigue en texto');

  r = await responder(tel, '1');
  r = await responder(tel, '0');
  r = await responder(tel, '1'); // Circulares
  assert.equal(r[0].tipo, 'documento', 'circular actual como documento');
  assert.ok(r[1].texto.includes('T-08'), 'lista las anteriores con PDF');
  const pdf = await fetch(r[0].url);
  assert.equal(pdf.headers.get('content-type'), 'application/pdf');
  const n = r[1].texto.split('\n').find((l) => l.includes('T-08')).split('.')[0];
  r = await responder(tel, n);
  assert.equal(r[0].tipo, 'documento', 'circular anterior como documento');
  assert.equal(r[0].nombre, 'Circular T-08.pdf');

  assert.equal((await fetch(`${base}/archivos/${'0'.repeat(32)}/x.pdf`)).status, 404);
  console.log(JSON.stringify(r, null, 1).slice(0, 400));
  await consulta("DELETE FROM archivos WHERE tipo = 'circular' AND ref_id = ?", [anterior.id]);
  await consulta('DELETE FROM circulares WHERE id = ?', [anterior.id]);
  srv.close();
  await pool.end();
  console.log('OK archivos');
})().catch((e) => { console.error(e); process.exit(1); });
