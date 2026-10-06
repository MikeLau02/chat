# Chatbot Colegio Visión Mundial

Bot de WhatsApp (Cloud API de Meta) con Node.js, Express y MySQL. Sin IA: menú numerado y palabras clave.

## Archivos

- `src/server.js`: webhook que recibe los mensajes de Meta y envía las respuestas.
- `src/bot.js`: lógica de la conversación (menú de 8 opciones, horarios, manual, actividades, asesor).
- `src/panel.js`: panel en `/panel` para Laura y Abraham (asesor, actividades, circular, enlaces y textos, cifras del piloto).
- `src/whatsapp.js`: envío de textos, PDF e imágenes, y validación de la firma de Meta.
- `db/schema.sql` y `db/horario_2026.sql`: base de datos. El servidor los ejecuta solo la primera vez que arranca con una base vacía (`src/instalar.js`).
- `render.yaml`: configuración para publicarlo gratis en Render.
- `test/`: conversaciones simuladas y prueba del webhook con datos inventados.

## Ponerlo a funcionar

1. Crear una base MySQL vacía (por ejemplo, el plan gratuito de Aiven). Las tablas se crean solas al arrancar.
2. Copiar `.env.example` como `.env` y completar los datos de Meta y de la base.
3. `npm install` y `npm start`.
4. En developers.facebook.com > la app > WhatsApp > Configuración: URL del webhook
   `https://<servidor>/webhook`, el mismo `WHATSAPP_VERIFY_TOKEN`, y suscribirse al campo `messages`.

Mientras se espera la conexión del 318 188 6319 se usa el número de prueba que da Meta.
Para cambiar de número solo se cambian `WHATSAPP_PHONE_NUMBER_ID` y `WHATSAPP_TOKEN`.

## Pruebas locales

```
mysql -u root < ../schema.sql && mysql -u root < test/datos-prueba.sql
npm run simular
npm run test:webhook
```

## Cargar el horario

El horario sale de `../horario_2026.csv` (una fila por docente, día y periodo):

```
node scripts/horario.js ../horario_2026.csv ..
mysql -u root < ../horario_2026.sql
```

El script genera `horario_2026.sql` y deja en `horario_revisar.csv` las filas que no pudo
interpretar (varias clases o grupos en un mismo periodo, horas vacías). Se corrigen en el CSV
y se vuelve a generar; el SQL se puede ejecutar varias veces sin duplicar datos.

## Cuentas del panel

La primera vez que se abre `/panel` con la base vacía aparece "Crear la primera cuenta"; pide el
valor de `PANEL_SECRET` como clave de instalación. Desde esa cuenta, en "Cuentas", se crean las demás.
En una instalación local también se puede usar:

```
node scripts/crear-admin.js "Laura González" correo@colegiovisionmundial.edu.co docente_encargada
node scripts/crear-admin.js "Abraham Candanoza" correo@... estudiante_admin
```

Cada comando muestra una contraseña temporal. Volver a ejecutarlo con el mismo correo genera una nueva.
