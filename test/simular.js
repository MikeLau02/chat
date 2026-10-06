// Simula conversaciones contra la base de datos local, sin llamar a Meta.
// Uso: node test/simular.js
process.env.DATABASE_URL ||= 'mysql://bot:bot@127.0.0.1:3306/chatbot_vm';
const { responder } = require('../src/bot');
const { pool } = require('../src/db');

const guiones = {
  '573000000001': ['hola', '1', '2', '1', '1', '2', 'jueves', 'semana', '0', '5', '3', 'asesor', '¿Cuándo es la reunión de padres?', '9', 'me hacen bullying', 'xyzzy'],
  '573000000002': ['horario 11B martes', 'mi horario', 'pqrs', '8', '2', '8', '1', 'uniforme', 'evaluacion', '4', '6', '1', 'audio'],
};

(async () => {
  let fallas = 0;
  for (const [tel, mensajes] of Object.entries(guiones)) {
    console.log(`\n========== ${tel} ==========`);
    for (const m of mensajes) {
      const esTexto = m !== 'audio';
      const salida = await responder(tel, m, { esTexto });
      console.log(`\n>>> ${m}`);
      for (const s of salida) console.log(s.tipo === 'texto' ? s.texto : `[${s.tipo}] ${s.url} | ${s.texto}`);
      if (!salida.length) { fallas++; console.log('!!! sin respuesta'); }
    }
  }
  await pool.end();
  process.exit(fallas ? 1 : 0);
})().catch(async (e) => { console.error(e); await pool.end(); process.exit(1); });
