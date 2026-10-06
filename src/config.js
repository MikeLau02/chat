require('dotenv').config();

function requerida(nombre) {
  const valor = process.env[nombre];
  if (!valor) throw new Error(`Falta la variable de entorno ${nombre}`);
  return valor;
}

module.exports = {
  port: Number(process.env.PORT || 3000),
  databaseUrl: process.env.DATABASE_URL || 'mysql://root@localhost:3306/chatbot_vm',
  whatsapp: {
    // Se leen al usarlas para que las pruebas locales funcionen sin credenciales.
    get token() { return requerida('WHATSAPP_TOKEN'); },
    get phoneNumberId() { return requerida('WHATSAPP_PHONE_NUMBER_ID'); },
    get verifyToken() { return requerida('WHATSAPP_VERIFY_TOKEN'); },
    appSecret: process.env.WHATSAPP_APP_SECRET || '',
    graphVersion: process.env.GRAPH_API_VERSION || 'v23.0',
  },
  // Minutos que el bot recuerda en qué paso del menú va cada usuario.
  minutosSesion: Number(process.env.MINUTOS_SESION || 30),
};
