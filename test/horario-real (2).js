// Consulta el horario real cargado (después de ejecutar horario_2026.sql).
process.env.DATABASE_URL ||= 'mysql://bot:bot@127.0.0.1:3306/chatbot_vm';
const { responder } = require('../src/bot');
const { pool } = require('../src/db');
(async () => {
  for (const m of ['horario 11B martes', 'cuarto a lunes', 'horario jardin viernes', '2', '2', '15', 'miercoles']) {
    const s = await responder('573000000003', m);
    console.log(`\n>>> ${m}`);
    s.forEach((x) => console.log(x.texto));
  }
  await pool.end();
})();
