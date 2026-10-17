-- Generado por scripts/contenidos.js a partir de contenidos.json. No editar a mano.
-- Se puede ejecutar varias veces: reemplaza todos los contenidos.
SET NAMES utf8mb4;
START TRANSACTION;
DELETE FROM contenidos;
INSERT INTO contenidos (categoria_id, titulo, texto, referencia, palabras_clave, orden)
SELECT k.id, v.titulo, v.texto, v.referencia, v.palabras, v.orden FROM (
  SELECT 'identidad' AS modulo, 'Datos del colegio' AS categoria, 'Identificación del Colegio Visión Mundial' AS titulo, '*Colegio Visión Mundial ASODESI*
• NIT: 800208480-9
• Dirección: Calle 13 No. 14C-10, Barrio 6 de marzo
• Teléfono: +57 3102167826
• Sitio web: www.colegiovisionmundial.edu.co
• Lema: "Formando en Valores por un Nuevo Ciudadano"
• Municipio: Montería, Córdoba, Colombia
• Naturaleza: Privado
• Carácter: Mixto
• Calendario: A
• Jornada: Única (Mañana)' AS texto, '1.1' AS referencia, 'datos del colegio, direccion, telefono, contacto, pagina web, nit, lema, ubicacion, donde queda, asodesi, monteria, calendario, jornada, privado, mixto' AS palabras, 1 AS orden
  UNION ALL SELECT 'identidad' AS modulo, 'Datos del colegio' AS categoria, 'Horario por ciclo' AS titulo, '*Horario de la jornada única (mañana)* según el ciclo:
• Preescolar: 7:00 a.m. - 12:00 m
• Básica Primaria (1º a 5º): 6:00 a.m. - 12:30 p.m.
• Básica Secundaria (6º - 9º): 6:00 a.m. - 01:30 p.m.
• Media Técnica (10º y 11º): 6:00 a.m. - 01:30 p.m.' AS texto, '1.1' AS referencia, 'horario, hora de entrada, hora de salida, jornada, preescolar, primaria, secundaria, media tecnica, a que hora entran, a que hora salen, jornada unica' AS palabras, 2 AS orden
  UNION ALL SELECT 'identidad' AS modulo, 'Datos del colegio' AS categoria, 'Reconocimiento oficial, DANE e ICFES' AS titulo, '*Reconocimiento oficial y códigos del colegio*
• Reconocimiento oficial de estudios según Resolución No. 0934 del 15 de julio de 2013, emanada de la Secretaría de Educación Municipal de Montería (encabezado del manual).
• En la ficha de identificación también figura la Resolución No. 0916 del 25 de noviembre de 2010, de la Secretaría de Educación Municipal de Montería.
• Código DANE: 323001008970
• Código ICFES: 151084
• Clasificación A / Muy Superior – Saber 11' AS texto, '1.1' AS referencia, 'resolucion, reconocimiento oficial, licencia, codigo dane, dane, icfes, codigo icfes, saber 11, clasificacion, muy superior, legal, aprobado' AS palabras, 3 AS orden
  UNION ALL SELECT 'identidad' AS modulo, 'Visión' AS categoria, 'Visión del Colegio Visión Mundial' AS titulo, '*Visión del Colegio Visión Mundial*
Formar de manera integral a NNAJ (niños, niñas, adolescentes y jóvenes) residentes en la ciudad de Montería, con un perfil Técnico en Sistemas, orientados con principios cristianos, ambientales, culturales, científicos, tecnológicos, deportivos y recreativos.

Respondiendo, de esta manera, a un ideal de un nuevo ciudadano colombiano que pueda aprender a ser, aprender a aprender, aprender a hacer y aprender a convivir con sus deberes y derechos; promoviendo así el desarrollo y la transformación humana.' AS texto, '2.1.1' AS referencia, 'vision, vision del colegio, filosofia institucional, tecnico en sistemas, nuevo ciudadano, aprender a ser, formacion integral' AS palabras, 1 AS orden
  UNION ALL SELECT 'identidad' AS modulo, 'Misión' AS categoria, 'Misión del Colegio Visión Mundial' AS titulo, '*Misión del Colegio Visión Mundial*
El COLEGIO VISIÓN MUNDIAL pretende ser una Institución Certificada en Procesos de Calidad, que ofrece el Servicio de Educación Técnica en Sistemas a la sociedad monteriana, promoviendo el desarrollo y transformación en la vida de los niños, niñas, adolescentes y jóvenes (NNAJ), para que contribuyan de manera significativa en la transformación de la sociedad y en la conservación del medio ambiente.

Dentro del plan de mejoramiento institucional del 2023 se plantean cuatro estrategias proyectadas hasta el año 2030:
• Estrategias pedagógicas para educar con ternura.
• Fortalecimiento del inglés con la estrategia "camino al bilingüismo".
• Educar para el cuidado del medio, logrando un "colegio verde".
• Ampliación de alianzas y socios estratégicos para la auto-sostenibilidad del colegio.' AS texto, '2.1.2' AS referencia, 'mision, mision del colegio, filosofia institucional, educacion tecnica en sistemas, calidad, colegio verde, bilinguismo, plan de mejoramiento, 2030' AS palabras, 1 AS orden
  UNION ALL SELECT 'identidad' AS modulo, 'Principios' AS categoria, 'Principios institucionales' AS titulo, '*Principios institucionales*
• Formar una persona capaz de reconocer su realidad y transformarla para el bienestar común.
• Fortalecer de manera crítica el conocimiento científico, tecnológico y técnico para alcanzar una mejor calidad de vida.
• Construir comunidad con identidad cultural, valores de convivencia, paz y justicia social.
• Fortalecer la identidad local, regional y nacional para la construcción de Colombia y su posicionamiento en el contexto global.
• Desarrollar las competencias básicas para la productividad y competitividad.
• Propender por nuevos escenarios para garantizar el avance científico, tecnológico y técnico de los procesos educativos.
• Reconocer e implementar el Modelo Pedagógico Enseñanza para la Comprensión (EpC), respondiendo a las necesidades de la sociedad y de los NNAJ monterianos.' AS texto, '2.2.1' AS referencia, 'principios, principios institucionales, ensenanza para la comprension, epc, modelo pedagogico, identidad, calidad de vida' AS palabras, 1 AS orden
  UNION ALL SELECT 'identidad' AS modulo, 'Propósitos' AS categoria, 'Propósitos institucionales' AS titulo, '*Propósitos institucionales*
El COLEGIO VISIÓN MUNDIAL busca formar a los NNAJ para ejercer sus derechos y asumir sus responsabilidades, con alto sentido de pertenencia a su familia, a su institución y a su entorno social.

Esto se logra a través de la construcción de la cultura ciudadana y la convivencia pacífica, orientadas por el desarrollo de habilidades en las diferentes áreas del saber y en los procesos de investigación científica y tecnológica, con un excelente nivel de exigencia académica.' AS texto, '2.2.2' AS referencia, 'propositos, proposito del colegio, para que forma el colegio, sentido de pertenencia, cultura ciudadana, convivencia pacifica' AS palabras, 1 AS orden
  UNION ALL SELECT 'identidad' AS modulo, 'Valores' AS categoria, 'Valores institucionales' AS titulo, '*Valores institucionales*
• Responsabilidad
• Honestidad
• Actitud de servicio
• Credibilidad
• Sensibilidad
• Tolerancia

Estos valores guían los pasos de la institución, cimentados en el amor por la labor y el interés por la formación integral de los estudiantes, con la participación de toda la comunidad educativa.' AS texto, '2.2.3' AS referencia, 'valores, valores institucionales, responsabilidad, honestidad, tolerancia, actitud de servicio, credibilidad, sensibilidad' AS palabras, 1 AS orden
  UNION ALL SELECT 'identidad' AS modulo, 'Objetivos' AS categoria, 'Objetivos institucionales (parte 1)' AS titulo, '*Objetivos institucionales (1/2)*
• Estructurar un proyecto educativo que responda a los intereses, necesidades y proyección de los NNAJ, padres de familia, comunidad educativa, la sociedad y el país.
• Constituir una comunidad educativa integrada por padres de familia, profesores, educandos, personal administrativo y de servicios.
• Recibir un trato equitativo sin ser discriminado por creencias, condición social o étnica, y recibir buen trato de toda la comunidad.
• Presentar una cosmovisión del hombre, la historia, el mundo, la vida y el saber a la luz del Evangelio, mediante la enseñanza y el compromiso cristianos.
• Considerar al educando como razón de ser del colegio, centro de su acción educativa y futuro líder de la sociedad colombiana.
• Orientar al educando para que tome conciencia de su valor como persona y agente de su propio desarrollo.' AS texto, '2.3' AS referencia, 'objetivos, objetivos institucionales, objetivos del pei, proyecto educativo, comunidad educativa, evangelio, cristiano' AS palabras, 1 AS orden
  UNION ALL SELECT 'identidad' AS modulo, 'Objetivos' AS categoria, 'Objetivos institucionales (parte 2)' AS titulo, '*Objetivos institucionales (2/2)*
• Preparar al educando para dar respuestas innovadoras a situaciones cotidianas en un mundo de constante cambio.
• Adelantar planes concretos de ayuda social y comunitaria que involucren a la comunidad educativa.
• Lograr que el educando asuma con responsabilidad su vocación de ciudadano y su compromiso cívico y político, con actitud solidaria frente a la pobreza.
• Proponer medios para que el educando aproveche la ciencia, la técnica y los medios de comunicación modernos para construir un mundo mejor.
• Interpretar los horarios, programas y normas como instrumentos para formar hábitos de disciplina y responsabilidad.
• Generar espacios pedagógicos y educativos para la vivencia de valores cristianos y éticos.' AS texto, '2.3' AS referencia, 'objetivos, objetivos institucionales, ayuda social, justicia social, ciencia y tecnica, disciplina, valores cristianos y eticos' AS palabras, 2 AS orden
  UNION ALL SELECT 'identidad' AS modulo, 'Perfil del egresado' AS categoria, 'Perfil del egresado' AS titulo, '*Perfil del egresado*
El estudiante formado bajo la orientación en investigación, ciencia, tecnología y artes será capaz de hacer uso de todas sus competencias, especialmente las tecnológicas, investigativas, académicas y actitudinales.

• *Tecnológico:* competencias básicas para la solución de problemas a través de herramientas tecnológicas.
• *Académico:* competencias interpretativas, argumentativas y propositivas; disciplina de aprender a aprender.
• *Actitudinal:* construir su realidad a partir del análisis del entorno, la valoración de la responsabilidad y la búsqueda de su proyecto de vida.
• *Laboral:* capacidad para crear y liderar una empresa con una visión que responda a la realidad local, regional, nacional e internacional, trabajar en equipo, plantearse nuevos retos, adquirir compromisos y tomar decisiones.' AS texto, '2.4' AS referencia, 'perfil del egresado, egresado, bachiller, como sale el estudiante, competencias, perfil, graduado, proyecto de vida, emprendimiento' AS palabras, 1 AS orden
  UNION ALL SELECT 'identidad' AS modulo, 'Himno y emblemas' AS categoria, 'Emblemas del colegio' AS titulo, '*Emblemas del Colegio Visión Mundial*
El Manual de Convivencia presenta como emblemas institucionales:
• Logo Símbolo
• Isologo
• Logo Horizontal
• La bandera institucional
• El himno del colegio

Los logos y la bandera aparecen en el manual como imágenes, sin una descripción escrita de sus colores o elementos.
El lema del colegio es: "Formando en Valores por un Nuevo Ciudadano".' AS texto, '1.2' AS referencia, 'emblemas, escudo, logo, logotipo, isologo, bandera, simbolos, simbolos institucionales, lema' AS palabras, 1 AS orden
  UNION ALL SELECT 'identidad' AS modulo, 'Himno y emblemas' AS categoria, 'Himno del colegio' AS titulo, '*Himno del Colegio Visión Mundial*

Con furor nuestra voz elevemos
Que se escuche con fuerte pasión
Esta insignia de fe que hoy añora
Paz, amor, justicia y educación
Valores en ti aprenderemos
Construyendo hacia un mundo mejor
Y en la ardua tarea lograremos
Los senderos de transformación

*Coro*
ASODESI mentes grandes
En tu seno se formarán
Y el sonido de tu nombre
En el cielo siempre se oirán' AS texto, '1.2' AS referencia, 'himno, himno del colegio, letra del himno, coro, cancion del colegio, asodesi mentes grandes' AS palabras, 2 AS orden
  UNION ALL SELECT 'identidad' AS modulo, 'Marco legal' AS categoria, 'Fundamento legal del Manual de Convivencia' AS titulo, '*Fundamento legal del Manual de Convivencia*
• Artículos 73 y 87 de la Ley 115 de 1994 (Ley General de Educación): todo establecimiento educativo debe tener un Manual de Convivencia como parte del PEI.
• Decreto 1860 de 1994, que reglamenta la Ley 115.
• Ley 1620 de 2013 y su Decreto Reglamentario 1965 de 2013: crean el Sistema Nacional de Convivencia Escolar y dan lineamientos sobre derechos humanos, educación para la sexualidad y prevención de la violencia escolar.

El manual, elaborado con participación de la comunidad educativa, define normas, derechos, deberes y procedimientos para resolver conflictos, con el propósito de formar en la paz, el respeto, la democracia y la convivencia armónica.' AS texto, '1.3' AS referencia, 'marco legal, leyes, ley 115, ley general de educacion, decreto 1860, ley 1620, decreto 1965, por que existe el manual, normatividad' AS palabras, 1 AS orden
  UNION ALL SELECT 'identidad' AS modulo, 'Marco legal' AS categoria, 'Otras normas que sustentan el manual' AS titulo, '*Otras normas citadas en el manual*
• Ley 715 de 2001 y Ley 1098 de 2006 (Código de Infancia y Adolescencia): base de las obligaciones del colegio con la comunidad educativa.
• Decreto 1290 de 2009: los docentes deben evaluar con criterios justos y transparentes conforme a él.
• Decreto 1075 de 2015 y Ley 2025 de 2020: fundamentan, junto con la Ley 1620 y el Decreto 1965, las pautas de convivencia y cuidado del entorno. La Ley 2025 de 2020 sustenta la Escuela de Padres, Madres y Cuidadores.
• Sentencia T-345 de 2008 de la Corte Constitucional: respaldo al libre desarrollo de la personalidad en la presentación personal.
• Artículo 14 del Decreto 1860 de 1994: servicios complementarios y medios de comunicación escolares.' AS texto, '2.6' AS referencia, 'marco legal, ley 715, ley 1098, codigo de infancia, decreto 1075, ley 2025, decreto 1290, evaluacion, sentencia t-345, normas' AS palabras, 2 AS orden
  UNION ALL SELECT 'identidad' AS modulo, 'Marco legal' AS categoria, 'Decreto 1965 de 2013: artículos 42, 43 y 44' AS titulo, '*Protocolos de atención integral (Decreto 1965 de 2013)*
• *Ley 1620 de 2013:* establece el Sistema Nacional de Convivencia Escolar y Formación para el Ejercicio de los Derechos Humanos, para garantizar ambientes escolares seguros, pacíficos y libres de violencia.
• *Artículo 42:* cada institución debe implementar un protocolo de atención integral con mecanismos de prevención, identificación, atención y seguimiento.
• *Artículo 43:* el protocolo incluye estrategias de prevención y promoción, procedimientos de identificación y reporte, atención y reparación para las víctimas, intervención educativa y disciplinaria, y seguimiento y evaluación periódica.
• *Artículo 44:* la ejecución recae principalmente en los directivos docentes y el equipo de convivencia; docentes, estudiantes y familias tienen un papel activo en la prevención y el reporte.' AS texto, '15.1.1' AS referencia, 'decreto 1965, articulo 42, articulo 43, articulo 44, protocolos, ley 1620, sistema nacional de convivencia escolar, marco legal' AS palabras, 3 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Derechos y deberes' AS categoria, 'Derechos y deberes de los estudiantes' AS titulo, '*Derechos de los estudiantes*
• Recibir una educación integral, de calidad y en condiciones de equidad.
• Ser tratados con respeto y dignidad, sin discriminación alguna.
• Participar en los órganos del gobierno escolar (Consejo Estudiantil, Personería, etc.).
• Expresar sus opiniones de forma libre y respetuosa.
• Acceder a ambientes seguros y propicios para su desarrollo.

*Deberes de los estudiantes*
• Respetar a todos los miembros de la comunidad educativa.
• Cumplir con las normas del Manual de Convivencia.
• Asistir puntualmente a clases y participar activamente en las actividades escolares.
• Cuidar los bienes de la institución y del entorno.
• Resolver los conflictos de manera pacífica y dialogada, apoyándose en los mecanismos de la Ley 1620 y el Comité Escolar de Convivencia.' AS texto, '2.5.6' AS referencia, 'derechos del estudiante, deberes del estudiante, derechos y deberes, que debo cumplir, mis derechos, obligaciones del alumno, alumno, estudiante' AS palabras, 1 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Derechos y deberes' AS categoria, 'Derechos y deberes de padres, madres y acudientes' AS titulo, '*Derechos de padres, madres y/o acudientes*
• Participar activamente en el proceso educativo de sus hijos e hijas.
• Recibir información clara y oportuna sobre el desempeño académico y convivencial de sus hijos.
• Ser escuchados y tenidos en cuenta en la toma de decisiones institucionales.
• Ser tratados con respeto y equidad.

*Deberes de padres, madres y/o acudientes*
• Cumplir con los compromisos adquiridos con la institución educativa.
• Establecer una relación de corresponsabilidad con la formación de sus hijos.
• Asistir a las reuniones y convocatorias institucionales.
• Promover el respeto por la autoridad escolar y el cumplimiento del Manual de Convivencia.' AS texto, '2.5.5' AS referencia, 'derechos de los padres, deberes de los padres, acudiente, padres de familia, madres, obligaciones de los padres, reuniones, acudientes' AS palabras, 2 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Derechos y deberes' AS categoria, 'Obligaciones del colegio con los estudiantes' AS titulo, '*Obligaciones del colegio con los estudiantes*
La institución educativa debe:
• Garantizar el acceso, permanencia y culminación del proceso educativo en condiciones de equidad y calidad.
• Promover el respeto, la protección y la garantía de los derechos de los estudiantes, según la Ley 1098 de 2006.
• Crear un ambiente escolar libre de violencia, discriminación y maltrato.
• Fomentar el desarrollo de competencias ciudadanas, académicas y socioemocionales.
• Atender oportunamente las situaciones que afecten el bienestar físico, emocional y psicológico del estudiante.
• Implementar mecanismos de participación estudiantil y promover la formación en valores democráticos.' AS texto, '2.6.3' AS referencia, 'obligaciones del colegio, que debe garantizar el colegio, derechos del estudiante, ambiente sin violencia, permanencia, ley 1098' AS palabras, 3 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Derechos y deberes' AS categoria, 'Obligaciones del colegio con padres y acudientes' AS titulo, '*Obligaciones del colegio con padres, madres y/o acudientes*
La institución educativa debe:
• Facilitar canales efectivos de comunicación familia-escuela.
• Incluir a los padres en los procesos formativos y convivenciales de sus hijos e hijas.
• Informar con claridad y oportunidad sobre el rendimiento académico y comportamiento de los estudiantes.
• Respetar el derecho de los padres a participar en el gobierno escolar.
• Brindar orientación y acompañamiento para fortalecer el rol formativo de las familias.
• Fomentar la corresponsabilidad en la educación integral de los niños, niñas y adolescentes.' AS texto, '2.6.4' AS referencia, 'obligaciones del colegio con los padres, comunicacion familia escuela, informes, acudientes, padres de familia, corresponsabilidad' AS palabras, 4 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Derechos y deberes' AS categoria, 'Derechos y deberes de los docentes' AS titulo, '*Derechos de los docentes*
• Ejercer su labor pedagógica con autonomía profesional dentro del marco del PEI.
• Recibir formación continua y condiciones laborales dignas.
• Ser escuchados y participar activamente en las decisiones institucionales.
• Ser tratados con respeto por estudiantes, familias y demás actores escolares.

*Deberes de los docentes*
• Promover el desarrollo integral de los estudiantes.
• Evaluar con criterios justos, transparentes y conforme al Decreto 1290 de 2009.
• Fomentar la convivencia, la inclusión y el respeto por la diversidad.
• Reportar situaciones que afecten la convivencia escolar al Comité correspondiente.
• Cumplir con el cronograma institucional y las funciones asignadas.' AS texto, '2.5.2' AS referencia, 'docentes, profesores, derechos de los docentes, deberes de los docentes, obligaciones del profesor, evaluacion, decreto 1290' AS palabras, 5 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Derechos y deberes' AS categoria, 'Derechos y deberes de los directivos docentes' AS titulo, '*Derechos de los directivos docentes*
• Ser respetados por todos los miembros de la comunidad educativa.
• Ejercer su función directiva en un ambiente institucional sano y participativo.
• Contar con el respaldo del equipo docente y administrativo.
• Participar en procesos de formación continua.
• Tomar decisiones dentro del marco legal y del PEI.

*Deberes de los directivos docentes*
• Liderar la implementación del PEI y del Manual de Convivencia.
• Promover una cultura institucional basada en el respeto, la equidad y la participación.
• Garantizar la aplicación de la normativa educativa nacional.
• Velar por el bienestar físico, emocional y académico de toda la comunidad educativa.
• Apoyar el funcionamiento del Comité Escolar de Convivencia (Ley 1620 de 2013).' AS texto, '2.5.1' AS referencia, 'directivos, rector, coordinador, directivos docentes, derechos, deberes, liderazgo, pei' AS palabras, 6 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Derechos y deberes' AS categoria, 'Personal administrativo y de servicios generales' AS titulo, '*Personal administrativo*
Derechos: ser tratado con dignidad y respeto; desempeñar sus funciones en condiciones laborales seguras y adecuadas; participar en capacitaciones institucionales.
Deberes: cumplir con eficacia sus funciones; contribuir a la ejecución del PEI desde su rol; resguardar la información institucional con confidencialidad; ser agente de convivencia.

*Personal de servicios generales* (2.5.4)
Derechos: disfrutar de un ambiente laboral digno, seguro y respetuoso; recibir orientación sobre normas institucionales y protocolos básicos.
Deberes: cumplir con responsabilidad sus funciones de aseo, mantenimiento y apoyo; mantener relaciones cordiales y respetuosas; reportar cualquier situación anómala o de riesgo dentro de la institución.' AS texto, '2.5.3' AS referencia, 'personal administrativo, secretaria, servicios generales, aseo, mantenimiento, derechos, deberes, trabajadores' AS palabras, 7 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Derechos y deberes' AS categoria, 'Respeto por la diversidad' AS titulo, '*Respeto por la diversidad*
El colegio reconoce y valora la diversidad como pilar de una convivencia sana, inclusiva y democrática. Promueve el respeto de todas las formas de diferencia humana: étnicas, culturales, religiosas, ideológicas, de género, orientación sexual, identidad de género, capacidades físicas o cognitivas, condición socioeconómica, entre otras.

La institución rechaza categóricamente cualquier forma de discriminación, exclusión, estigmatización, violencia o trato desigual que atente contra la dignidad y el libre desarrollo de la personalidad.

Para ello implementa estrategias que:
• Fomentan el reconocimiento del otro como legítimo diferente.
• Fortalecen la empatía, la solidaridad y la justicia.
• Garantizan entornos libres de violencia o discriminación.
• Involucran a toda la comunidad en formación en diversidad, inclusión y derechos humanos.' AS texto, NULL AS referencia, 'diversidad, discriminacion, inclusion, orientacion sexual, identidad de genero, etnia, religion, discapacidad, igualdad, respeto' AS palabras, 8 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Derechos y deberes' AS categoria, 'Rol activo de los estudiantes en la Ruta de Atención' AS titulo, '*Rol activo de los estudiantes en la Ruta de Atención Integral*
El colegio reconoce a los estudiantes como actores fundamentales de la convivencia. En el marco de la Ruta de Atención Integral, los estudiantes pueden:
• Participar en espacios de diálogo y construcción de estrategias para prevenir conflictos y violencias.
• Proponer campañas e iniciativas sobre acoso escolar, discriminación, diversidad, salud mental, entre otros.
• Ser escuchados de manera activa y respetuosa cuando manifiesten inquietudes, denuncien hechos o aporten soluciones.
• Integrarse al Gobierno Escolar, los Comités de Convivencia, la representación estudiantil o los grupos de mediación escolar.
• Colaborar con docentes, orientadores y directivos en acuerdos restaurativos y acciones de reparación simbólica.' AS texto, NULL AS referencia, 'participacion estudiantil, rol del estudiante, denunciar, ser escuchado, mediacion, campanas, ruta de atencion, voz del estudiante' AS palabras, 9 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Gobierno escolar' AS categoria, 'Gobierno escolar: fundamento e instancias' AS titulo, '*Participación democrática y Gobierno Escolar*
Se basa en el Decreto 1860 de 1994 en lo que respecta a:
• Elección de representantes estudiantiles y demás miembros del Gobierno Escolar.
• Participación activa de la comunidad educativa.
• Fomento de la democracia escolar y el respeto por la institucionalidad.

*Instancias de participación:*
• Consejo Directivo
• Consejo Académico
• Consejo Estudiantil
• Personero de los Estudiantes
• Consejo de Padres de Familia
• Asociación de Padres de Familia
• Otros comités (convivencia, ambiental, cultura, etc.)

Estas disposiciones son revisadas anualmente por el Consejo Directivo y toda modificación debe socializarse con la comunidad educativa (2.7.11).' AS texto, '2.7.1' AS referencia, 'gobierno escolar, participacion democratica, instancias, organos, democracia escolar, decreto 1860, quienes conforman el gobierno escolar' AS palabras, 1 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Gobierno escolar' AS categoria, 'Consejo Directivo' AS titulo, '*Consejo Directivo*
• *Función:* es la máxima instancia directiva, de participación de la comunidad educativa y de orientación académica y administrativa del establecimiento.
• *Integrantes:* Rector(a); dos representantes del personal docente; dos representantes de los padres de familia elegidos por la Junta Directiva de la Asociación de Padres; un representante de los estudiantes elegido por el Consejo de Estudiantes; un representante de los exalumnos elegido por el Consejo Directivo; y un representante de los sectores productivos organizados en el ámbito local o, subsidiariamente, de las entidades que patrocinen el establecimiento.
• *Elección:* los representantes son elegidos para períodos anuales por sus respectivos estamentos.' AS texto, '2.7.2' AS referencia, 'consejo directivo, maxima instancia, integrantes consejo directivo, representante de padres, representante estudiantil, exalumnos' AS palabras, 2 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Gobierno escolar' AS categoria, 'Consejo Académico' AS titulo, '*Consejo Académico*
• *Función:* es la instancia superior para participar en la orientación pedagógica del establecimiento.
• *Integrantes:* Rector(a), los directivos docentes y un docente por cada área definida en el plan de estudios.
• *Elección:* los integrantes son designados según los lineamientos del rector y el Proyecto Educativo Institucional (PEI).' AS texto, '2.7.3' AS referencia, 'consejo academico, orientacion pedagogica, docentes por area, integrantes consejo academico, plan de estudios' AS palabras, 3 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Gobierno escolar' AS categoria, 'Consejo Estudiantil' AS titulo, '*Consejo Estudiantil*
• *Función:* es el máximo órgano colegiado que asegura y garantiza el continuo ejercicio de la participación por parte de los educandos.
• *Integrantes:* un vocero de cada uno de los grados ofrecidos por el establecimiento.
• *Elección:* cada grado elige un vocero mediante votación secreta en las primeras cuatro semanas del calendario académico.
• Los alumnos de preescolar y de los tres primeros grados de primaria se reúnen en una asamblea conjunta para elegir un vocero único entre los estudiantes de tercer grado.' AS texto, '2.7.4' AS referencia, 'consejo estudiantil, consejo de estudiantes, vocero, representante de grado, eleccion de voceros, votacion' AS palabras, 4 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Gobierno escolar' AS categoria, 'Personero de los Estudiantes' AS titulo, '*Personero de los Estudiantes*
• *Función:* promueve el ejercicio de los deberes y derechos de los estudiantes consagrados en la Constitución Política, las leyes, los reglamentos y el Manual de Convivencia.
• *Elección:* se elige por votación directa entre los estudiantes, en las primeras cuatro semanas del calendario académico.

Además, los estudiantes pueden acudir al Personero Estudiantil o al Consejo de Estudiantes para pedir acompañamiento o representación en situaciones de conflicto (4.4), y el personero puede acompañar al estudiante durante un proceso disciplinario (5.3).' AS texto, '2.7.5' AS referencia, 'personero, personero estudiantil, personeria, eleccion de personero, representante de los estudiantes, defensa del estudiante' AS palabras, 5 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Gobierno escolar' AS categoria, 'Consejo y Asociación de Padres de Familia' AS titulo, '*Consejo de Padres de Familia*
• *Función:* promueve la comunicación entre padres y escuela, y apoya el PEI.
• *Elección:* cada grupo elige un padre de familia como su representante ante el consejo. El consejo elige entre sus miembros un presidente y un representante ante el Consejo Directivo.

*Asociación de Padres de Familia* (2.7.7)
• *Función:* organización legalmente constituida que puede colaborar con el funcionamiento del colegio.
• *Elección:* se rige por sus propios estatutos. Debe registrarse ante la Secretaría de Educación y cumplir con la normatividad vigente.' AS texto, '2.7.6' AS referencia, 'consejo de padres, asociacion de padres, representante de padres, padres de familia, participacion de padres, asopadres' AS palabras, 6 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Gobierno escolar' AS categoria, 'Elecciones escolares y Comité Electoral' AS titulo, '*Normas generales para la elección de representantes*
• *Transparencia:* proceso público, democrático y en igualdad de condiciones para todos los candidatos.
• *Participación:* todos los miembros del estamento deben ser convocados oportunamente.
• *Publicidad:* se divulgan fechas, requisitos y procesos con anticipación.
• *Votación:* secreta, directa y libre, preferiblemente con urnas o medios digitales si se permite.
• *Resultados:* los publica oficialmente la Rectoría, el Consejo Directivo o el Comité Electoral.

*Comité Electoral Escolar* (2.7.10)
Garantiza la legalidad y transparencia del proceso. Lo integran el Rector(a) (o delegado), un docente, un representante estudiantil y un padre de familia. Prepara el calendario electoral, inscribe candidatos, vigila la votación y resuelve reclamaciones.

También se pueden conformar otros comités (convivencia, ambiental, cultura, etc.) por votación o designación (2.7.8).' AS texto, '2.7.9' AS referencia, 'elecciones, votacion, comite electoral, candidatos, inscripcion, voto secreto, resultados, reclamaciones, otros comites' AS palabras, 7 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Gobierno escolar' AS categoria, 'Comité Escolar de Convivencia: qué es y quiénes lo integran' AS titulo, '*Comité Escolar de Convivencia (CEC)*
Órgano institucional obligatorio creado por la Ley 1620 de 2013 y reglamentado por el Decreto 1965 de 2013. Lidera las estrategias de promoción de la convivencia, la prevención de la violencia y la garantía de los derechos de los estudiantes, con funciones pedagógicas, preventivas, restaurativas y de seguimiento.

*Integrantes:*
• El rector (quien lo preside).
• El coordinador de convivencia o quien haga sus veces.
• Un docente con formación en convivencia o educación para la ciudadanía.
• El orientador escolar (psicólogo o trabajador social).
• Un representante de los estudiantes del grado más alto.
• Un representante de los padres de familia.
• Un representante del consejo estudiantil (cuando aplique).

Se reúne como mínimo una vez al mes o de forma extraordinaria cuando la situación lo exija.' AS texto, '12.2' AS referencia, 'comite de convivencia, comite escolar de convivencia, cec, integrantes, quienes conforman, rector, orientador, ley 1620' AS palabras, 8 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Uniforme y presentación personal' AS categoria, 'Porte del uniforme institucional' AS titulo, '*Presentación personal y uniforme*
El uniforme es un símbolo de pertenencia e igualdad, en armonía con los derechos fundamentales de los estudiantes.

• *Diario y de Educación Física:* los estudiantes deben portar el uniforme correspondiente al horario de manera completa, digna y aseada. El diseño oficial busca la comodidad y la identidad institucional.
• *Principio de realidad y flexibilidad:* el colegio comprende que pueden existir situaciones económicas o de fuerza mayor que dificulten temporalmente el porte completo del uniforme. En esos casos, el padre, madre o acudiente debe informar a la Coordinación para buscar soluciones conjuntas y evitar procesos que afecten al estudiante.' AS texto, '3.1.2' AS referencia, 'uniforme, uniforme de diario, uniforme de educacion fisica, sudadera, no tengo uniforme, falta de uniforme, presentacion personal, como llevar el uniforme' AS palabras, 1 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Uniforme y presentación personal' AS categoria, 'Cabello, accesorios y maquillaje (libre desarrollo de la personalidad)' AS titulo, '*Respeto al libre desarrollo de la personalidad*
• En concordancia con la Corte Constitucional (ej. Sentencia T-345 de 2008), el Colegio Visión Mundial *no establecerá prohibiciones* sobre estilos o cortes de cabello, uso de accesorios personales o maquillaje sobrio.
• La autonomía del estudiante sobre su presentación será respetada, siempre que no represente un riesgo para su integridad o la de sus compañeros (por ejemplo, en laboratorio o educación física se pueden dar indicaciones de seguridad) ni interfiera con el ambiente académico.

*Docentes, directivos y personal administrativo:* como figuras de referencia, deben mantener una presentación profesional, pulcra y apropiada para el entorno educativo.' AS texto, '3.1.3' AS referencia, 'corte de cabello, pelo, peinado, accesorios, aretes, piercing, maquillaje, tintes, libre desarrollo de la personalidad, presentacion personal' AS palabras, 2 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Salud y cuidado del entorno' AS categoria, 'Higiene personal, enfermedad y excusas médicas' AS titulo, '*Reglas de higiene personal y salud pública*
La salud es un bien individual y una responsabilidad colectiva.
• Todo miembro de la comunidad educativa debe practicar hábitos de higiene personal diarios.
• Es un deber reportar a la coordinación o a orientación cualquier síntoma de enfermedad, para activar los protocolos de salud y prevenir su propagación.
• Los estudiantes con enfermedades que representen un riesgo para la comunidad deben permanecer en casa y presentar la excusa médica correspondiente a su regreso, garantizando la flexibilidad académica necesaria.' AS texto, '3.2' AS referencia, 'higiene, salud, enfermedad, enfermo, sintomas, excusa medica, incapacidad, faltar por enfermedad, salud publica' AS palabras, 1 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Salud y cuidado del entorno' AS categoria, 'Cuidado de los recursos, daños y biblioteca' AS titulo, '*Cuidado y uso de los recursos institucionales*
El cuidado de los bienes del colegio es un deber de corresponsabilidad.
• *Mobiliario, planta física y material didáctico:* todos deben usar los recursos de manera responsable. Cualquier daño se analiza desde un enfoque pedagógico y restaurativo, buscando la reparación del daño más que la simple sanción. El proceso debe ser proporcional y formativo, considerando la edad y madurez del estudiante.
• *Biblioteca escolar y bibliobanco:* son espacios de conocimiento; se debe mantener un comportamiento que facilite el estudio y la lectura. El cuidado de los libros es responsabilidad compartida y su devolución oportuna permite que otros también accedan a ellos.' AS texto, '3.3' AS referencia, 'danos, romper, mobiliario, pupitre, reparar dano, biblioteca, bibliobanco, libros, devolucion de libros, cuidado de bienes' AS palabras, 2 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Salud y cuidado del entorno' AS categoria, 'Prevención del consumo de sustancias psicoactivas' AS titulo, '*Prevención del consumo de sustancias psicoactivas (SPA)*
• *Enfoque:* se prohíbe el porte, consumo o distribución de SPA. Sin embargo, el abordaje de estas situaciones es primordialmente pedagógico y de salud pública.
• *Protocolo:* se aplica el protocolo específico garantizando el debido proceso. La situación se clasifica según su naturaleza, evitando catalogar el consumo como Situación Tipo III, a menos que esté asociado a un presunto delito de la ley penal colombiana, como el tráfico o la venta. El objetivo es activar rutas de apoyo y no de exclusión.
• *Estrategias:* campañas de prevención, talleres formativos y articulación con las familias y las entidades de salud.' AS texto, '3.4.2' AS referencia, 'drogas, sustancias psicoactivas, spa, consumo, marihuana, alcohol, cigarrillo, vapeador, prevencion, porte de drogas' AS palabras, 3 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Salud y cuidado del entorno' AS categoria, 'Embarazo en la adolescencia: prevención y apoyo' AS titulo, '*Protocolo de prevención y apoyo en casos de embarazo en la adolescencia*
• *Prevención:* proyectos pedagógicos transversales de educación para la sexualidad y construcción de ciudadanía, basados en los Derechos Humanos, Sexuales y Reproductivos (proyecto de vida, decisiones responsables, equidad de género).
• *Atención y acompañamiento (no discriminación):*
1. Se garantiza el derecho a la educación y la permanencia en el colegio de la estudiante en embarazo y del padre adolescente, sin discriminación ni exclusión.
2. Se activa una ruta de apoyo con Orientación Escolar, Coordinación y la familia, con un plan de acompañamiento flexible que se ajuste a sus necesidades académicas y citas de control médico.
3. La confidencialidad es un pilar fundamental en todo el proceso.
• *Seguimiento:* Orientación Escolar estará atenta a signos de alarma y factores de riesgo para fortalecer la prevención y el apoyo.' AS texto, '3.4.3' AS referencia, 'embarazo, embarazada, embarazo adolescente, padre adolescente, educacion sexual, permanencia, controles medicos, maternidad' AS palabras, 4 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Salud y cuidado del entorno' AS categoria, 'Cuidado del medio ambiente escolar' AS titulo, '*Pautas para el cuidado del medio ambiente escolar*
Formar ciudadanos ambientalmente responsables es un compromiso del PEI.
• Se promoverá el uso racional de recursos como el agua y la energía.
• Se fomentará una cultura de manejo adecuado de residuos, incentivando el reciclaje.
• Se protegerán y cuidarán activamente las zonas verdes y espacios comunes del colegio, como manifestación de respeto por nuestro entorno.
• Se incentivará la participación en proyectos ambientales como parte del desarrollo de competencias ciudadanas.' AS texto, '3.5' AS referencia, 'medio ambiente, reciclaje, residuos, basura, agua, energia, zonas verdes, proyectos ambientales, colegio verde' AS palabras, 5 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Salud y cuidado del entorno' AS categoria, 'Plan de contingencia por emergencia sanitaria' AS titulo, '*Protocolos de bioseguridad y plan de contingencia*
Busca prevenir, mitigar y responder a emergencias sanitarias (como la del COVID-19), protegiendo la salud de la comunidad y garantizando la continuidad del proceso formativo. Principios: corresponsabilidad, prevención, información y comunicación, adaptabilidad.

• *Prevención y preparación:* insumos para higiene de manos, ventilación de aulas, capacitación y campañas de autocuidado.
• *Respuesta:* el Consejo Directivo, con el Comité Escolar de Convivencia, activa el plan; se informa a las autoridades sanitarias, a la Secretaría de Educación de Montería y a las familias. Según la emergencia se podrán aplicar: tapabocas, distanciamiento, filtros sanitarios al ingreso, aislamiento de casos con la EPS y modelos flexibles (virtualidad, alternancia o trabajo en casa).
• *Recuperación:* retorno gradual a la presencialidad, apoyo psicosocial y evaluación del plan.' AS texto, '19.1' AS referencia, 'bioseguridad, emergencia sanitaria, pandemia, covid, tapabocas, plan de contingencia, virtualidad, alternancia, aislamiento' AS palabras, 6 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Resolución de conflictos' AS categoria, 'Conducto regular: instancias para resolver conflictos' AS titulo, '*Instancias para la solución de conflictos (en orden)*
1. *Docente director de grupo:* primera instancia. Escucha a las partes, orienta la solución pacífica y hace mediación temprana.
2. *Coordinador(a):* actúa si el conflicto no se resolvió en el aula o con el director de grupo; puede derivar el caso al orientador o al Comité de Convivencia según la gravedad.
3. *Orientador escolar:* acompaña la mediación, orienta a estudiantes y familias; su intervención es pedagógica y preventiva.
4. *Comité Escolar de Convivencia:* analiza los casos, formula estrategias, aplica medidas pedagógicas y hace seguimiento a compromisos.
5. *Rector:* máxima autoridad administrativa; interviene en casos complejos, garantiza el debido proceso y puede imponer medidas disciplinarias.
6. *Consejo Directivo:* última instancia escolar; atiende los casos más delicados, como no renovación o cancelación de matrícula.' AS texto, '4.3' AS referencia, 'conducto regular, a quien acudo, instancias, director de grupo, coordinador, orientador, rector, consejo directivo, queja, conflicto' AS palabras, 1 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Resolución de conflictos' AS categoria, 'Etapas del procedimiento para resolver conflictos' AS titulo, '*Etapas del procedimiento*
1. *Detección:* cualquier miembro de la comunidad puede informar un conflicto, de forma verbal o escrita, ante un docente, coordinador, orientador o directivo.
2. *Diálogo directo:* antes de instancias formales, se promueve el diálogo entre las partes guiado por un mediador (docente u orientador) para aclarar hechos y buscar una solución voluntaria.
3. *Conciliación o mediación institucional:* si no hay acuerdo, se activa la conciliación con acompañamiento del Comité Escolar de Convivencia, que propone acuerdos y busca restaurar el daño.
4. *Medidas formativas o pedagógicas:* si el conflicto persiste o hay vulneración de derechos o incumplimiento del manual, se aplican medidas pedagógicas, proporcionales y reparadoras, con debido proceso.
5. *Remisión a instancias externas (si aplica):* si hay faltas graves o presuntas conductas punibles, se remite a autoridades (ICBF, Comisaría de Familia, Policía de Infancia y Adolescencia, entre otros).' AS texto, '4.2' AS referencia, 'procedimiento, pasos, como se resuelve un conflicto, dialogo, mediacion, conciliacion, pelea, problema con un companero, reportar' AS palabras, 2 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Resolución de conflictos' AS categoria, 'Principios para resolver conflictos' AS titulo, '*Principios orientadores en la resolución de conflictos*
• *Respeto por la dignidad humana:* trato con consideración, sin discriminación ni humillaciones.
• *Escucha activa e imparcialidad:* todas las voces son escuchadas sin prejuicios ni favoritismos.
• *Debido proceso:* los estudiantes deben ser informados, poder defenderse, presentar pruebas y recibir una decisión motivada y justa.
• *Confidencialidad:* la información personal o sensible se trata con reserva.
• *Restauración de relaciones:* más allá de sancionar, se busca reparar el daño, promover el perdón y reconstruir la confianza.
• *Oportunidad:* la atención debe ser pronta, evitando prolongar situaciones que afecten el ambiente escolar.

Los casos atendidos son registrados y evaluados periódicamente por el Comité de Convivencia (4.5).' AS texto, '4.1' AS referencia, 'principios, debido proceso, confidencialidad, imparcialidad, escucha, enfoque restaurativo, dignidad, resolucion de conflictos' AS palabras, 3 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Resolución de conflictos' AS categoria, 'Funciones del Comité Escolar de Convivencia' AS titulo, '*Funciones del Comité Escolar de Convivencia*
• Diseñar e implementar estrategias de convivencia pacífica y respeto por los derechos humanos.
• Hacer seguimiento a los casos de conflictos, acoso escolar u otras situaciones, en coordinación con la Ruta de Atención Integral.
• Activar y coordinar las rutas de atención con autoridades (ICBF, Policía de Infancia y Adolescencia, EPS, Comisarías de Familia, entre otros).
• Promover procesos restaurativos y pedagógicos, más allá de la sanción.
• Formar a la comunidad en derechos humanos, diversidad, inclusión y manejo de conflictos.
• Llevar registro de los casos y remitir informes periódicos.

*Funcionamiento (18.4):* se reúne al menos una vez al mes y extraordinariamente cuando sea necesario; decide por consenso o mayoría simple; lleva actas; y sus miembros deben respetar la confidencialidad de los casos.' AS texto, '12.3' AS referencia, 'funciones del comite de convivencia, comite escolar de convivencia, cec, seguimiento de casos, rutas de atencion, actas, reuniones' AS palabras, 4 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Resolución de conflictos' AS categoria, 'Estrategias para fortalecer la convivencia' AS titulo, '*Estrategias para fortalecer la convivencia escolar*
• *Mediación escolar y acuerdos restaurativos:* formación de estudiantes y docentes como mediadores; círculos restaurativos y encuentros de diálogo.
• *Educación socioemocional:* autoconocimiento, autorregulación, empatía, habilidades sociales y decisiones responsables, desde preescolar hasta media.
• *Escuelas de padres y encuentros familiares:* comunicación no violenta, disciplina positiva, salud mental y crianza respetuosa.
• *Reconocimiento positivo:* incentivos a la buena convivencia, como "Taller soy visionario" y "Paz a la Bien".
• *Formación en derechos humanos, sexuales y reproductivos:* prevención del acoso, diversidad, equidad de género y cuidado del cuerpo.
• *Observatorios estudiantiles de convivencia:* grupos de estudiantes que hacen seguimiento, proponen mejoras y lideran campañas.
• *Medios institucionales:* mensajes positivos en página web, mural, redes sociales, circulares y actividades radiales o teatrales.' AS texto, '8.3' AS referencia, 'estrategias de convivencia, mediacion escolar, circulos restaurativos, educacion socioemocional, reconocimiento, taller soy visionario, observatorio estudiantil' AS palabras, 5 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Resolución de conflictos' AS categoria, 'Reconciliación y reparación del daño' AS titulo, '*Medidas de reconciliación y reparación*
• *Mediación escolar:* espacios dirigidos por personal capacitado para que las partes dialoguen y lleguen a acuerdos restaurativos.
• *Actividades restaurativas:* trabajo comunitario, dinámicas de grupo o proyectos colaborativos que promuevan la reparación del daño y el reconocimiento del impacto de las acciones.
• *Acompañamiento psicológico y social:* apoyo a víctimas y agresores para superar la situación y prevenir recaídas.
• *Reintegración y seguimiento:* estrategias para facilitar el retorno de los involucrados a un ambiente armonioso, con monitoreo de su evolución.

Para restablecer relaciones constructivas se promueve el diálogo abierto, el refuerzo positivo de las buenas conductas y el trabajo colaborativo entre estudiantes, docentes, familias y autoridades (16.5).' AS texto, '16.4' AS referencia, 'reparacion, reconciliacion, restaurativo, disculpas, mediacion, acompanamiento psicologico, reintegracion, clima escolar' AS palabras, 6 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Resolución de conflictos' AS categoria, 'El educador como orientador, mediador y detector temprano' AS titulo, '*Rol del educador*
Más allá de su función académica, el educador cumple un papel clave como:
• *Orientador:* guía a los estudiantes en su formación integral, promoviendo respeto, empatía, tolerancia y resolución pacífica de conflictos.
• *Mediador:* interviene oportunamente ante situaciones conflictivas con enfoques restaurativos y pedagógicos que busquen la reparación del daño y la reconciliación.
• *Agente de detección temprana:* identifica señales de alerta de violencia escolar, acoso, abuso, maltrato, discriminación, consumo de sustancias o afectaciones a la salud mental, y activa de inmediato las rutas de atención con el Comité Escolar de Convivencia.

Los docentes reciben formación permanente en convivencia escolar, habilidades socioemocionales, diversidad y prevención de violencias.' AS texto, NULL AS referencia, 'rol del docente, profesor, mediador, orientador, deteccion temprana, senales de alerta, docente reporta, maltrato' AS palabras, 7 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Resolución de conflictos' AS categoria, 'Resolución pacífica de conflictos y protección de derechos' AS titulo, '*Resolución pacífica de conflictos y protección de derechos*
En el marco de la Ley 1620 y el Decreto 1965 de 2013, el colegio establece como principio fundamental la resolución pacífica de los conflictos, fomentando el diálogo, la empatía y la participación de estudiantes, docentes, directivos, padres y personal administrativo.

• Las medidas pedagógicas y restaurativas son los mecanismos primarios para atender los conflictos.
• Toda conducta que vulnere los derechos de los estudiantes o amenace su integridad física, psicológica o emocional se atiende mediante rutas de atención integral y protocolos.
• Situaciones como acoso escolar (bullying), discriminación, intimidación o maltrato físico o verbal se abordan con enfoque formativo y restaurativo, garantizando el debido proceso.' AS texto, NULL AS referencia, 'resolucion pacifica, cultura de paz, dialogo, bullying, maltrato, discriminacion, enfoque restaurativo, proteccion de derechos' AS palabras, 8 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Sanciones y derecho a la defensa' AS categoria, 'Principios para aplicar sanciones' AS titulo, '*Principios rectores de las medidas disciplinarias*
• *Debido proceso:* todo estudiante tiene derecho a conocer los hechos que se le atribuyen, presentar su versión, ser escuchado y recibir una decisión fundamentada. Ninguna sanción podrá aplicarse sin garantizar este proceso.
• *Proporcionalidad:* la sanción debe ser adecuada a la gravedad de la falta, evitando excesos.
• *Respeto por la dignidad:* las acciones disciplinarias nunca deberán ser humillantes, discriminatorias o punitivas en exceso.
• *Carácter pedagógico y restaurativo:* las sanciones buscan formar, corregir y reparar el daño causado.
• *Participación del estudiante:* será escuchado, podrá presentar su versión y pruebas, y participar en las soluciones.

Las sanciones se aplican de forma gradual, según gravedad, intencionalidad, reincidencia y contexto, con comunicación formal a los padres o acudientes (5.2).' AS texto, '5.1' AS referencia, 'sanciones, castigo, principios, proporcionalidad, debido proceso, dignidad, medidas disciplinarias, disciplina' AS palabras, 1 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Sanciones y derecho a la defensa' AS categoria, 'Tipos de sanciones (formativas y correctivas)' AS titulo, '*Tipos de sanciones (1/2)*
• *Llamado de atención verbal:* privado o en el contexto escolar, para advertir sobre una conducta inapropiada y orientar al estudiante.
• *Compromiso escrito de mejoramiento:* documento firmado por el estudiante (y si es necesario por su acudiente) en el que reconoce su conducta y se compromete a mejorar; puede incluir metas y seguimiento del docente o coordinador.
• *Actividades pedagógicas o de reparación simbólica:* cartas de disculpas, jornadas de servicio, talleres de convivencia, entre otros.
• *Suspensión temporal de actividades recreativas o extracurriculares:* restricción de participar en salidas pedagógicas, celebraciones o encuentros deportivos, ante faltas menores o reincidentes.' AS texto, '5.2' AS referencia, 'tipos de sanciones, llamado de atencion, compromiso, acta de compromiso, reparacion, castigo, suspension de actividades, sancion leve' AS palabras, 2 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Sanciones y derecho a la defensa' AS categoria, 'Tipos de sanciones (suspensión y matrícula)' AS titulo, '*Tipos de sanciones (2/2)*
• *Suspensión interna con trabajo pedagógico:* el estudiante permanece en el colegio durante la jornada, separado de sus actividades habituales, realizando tareas formativas bajo supervisión.
• *Suspensión externa por un tiempo determinado:* por falta grave, el estudiante se retira temporalmente, con acompañamiento del orientador escolar y entrega de un plan de reflexión o trabajo pedagógico.
• *Matrícula condicional:* continúa en el colegio bajo condiciones definidas por el Comité de Convivencia, con seguimiento continuo. Incumplirlas puede llevar a medidas más severas.
• *No renovación de matrícula:* medida excepcional cuando se han agotado todas las acciones pedagógicas y disciplinarias posibles. Solo la decide el Consejo Directivo, garantizando el debido proceso.' AS texto, '5.2' AS referencia, 'suspension, suspendido, suspension externa, suspension interna, matricula condicional, no renovacion de matricula, expulsion, sancion grave' AS palabras, 3 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Sanciones y derecho a la defensa' AS categoria, 'Derecho a la defensa' AS titulo, '*Derecho a la defensa*
Todo estudiante tiene derecho a:
• Conocer las faltas que se le imputan.
• Presentar su versión de los hechos y ser escuchado en presencia de sus padres o acudientes.
• Aportar pruebas y solicitar testigos.
• Recibir acompañamiento del personero estudiantil o del orientador escolar durante el proceso.

El procedimiento disciplinario busca una actuación justa, pedagógica y transparente, respetando especialmente el derecho del estudiante a ser escuchado, a la defensa y a un trato digno.' AS texto, '5.3' AS referencia, 'derecho a la defensa, descargos, debido proceso, pruebas, testigos, me van a sancionar, defenderme, personero, apelar' AS palabras, 4 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Sanciones y derecho a la defensa' AS categoria, 'Pasos del proceso disciplinario' AS titulo, '*Etapas del proceso disciplinario*
1. *Identificación de la conducta:* se documenta la situación; cualquier miembro de la comunidad puede reportarla por los canales establecidos.
2. *Citación al estudiante y sus acudientes:* reunión formal para informar los hechos y abrir un diálogo inicial.
3. *Presentación de descargos:* el estudiante explica su versión, aporta pruebas y manifiesta lo pertinente para su defensa.
4. *Evaluación:* el Comité Escolar de Convivencia o autoridad competente analiza evidencias, contexto, gravedad, intencionalidad y antecedentes, y define si existe falta.
5. *Decisión motivada:* se comunica una decisión formal y justificada; la sanción (si aplica) debe ser proporcional, pedagógica y restaurativa, e informarse por escrito al estudiante y su familia.
6. *Seguimiento y acompañamiento pedagógico:* se acompaña al estudiante y se documenta el seguimiento.' AS texto, '5.3' AS referencia, 'proceso disciplinario, pasos, citacion, citacion de acudientes, descargos, decision, seguimiento, falta, que pasa si cometo una falta' AS palabras, 5 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Servicios complementarios' AS categoria, 'Alimentación escolar y tienda' AS titulo, '*Alimentación escolar*
• Se brinda a través de un tercero (arrendatario) que maneja la tienda escolar mediante contrato de arrendamiento.
• La alimentación debe cumplir con estándares de calidad, nutrición e higiene, supervisados por las autoridades competentes.
• Se promoverá una cultura alimentaria saludable, incluyendo la formación en hábitos de nutrición adecuados desde preescolar hasta media.

Los servicios complementarios no son obligatorios; apoyan el logro de los fines de la educación (Art. 14, Decreto 1860 de 1994).' AS texto, '6.2.1' AS referencia, 'alimentacion, comida, tienda escolar, cafeteria, refrigerio, almuerzo, nutricion, lonchera, restaurante' AS palabras, 1 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Servicios complementarios' AS categoria, 'Transporte escolar' AS titulo, '*Transporte escolar*
• El servicio de transporte, cuando sea ofrecido o gestionado por el colegio, debe garantizar seguridad, puntualidad y trato digno a los estudiantes.
• Se exigirá que el personal conductor y acompañante esté debidamente capacitado y cumpla los requisitos legales para el transporte escolar.
• Las rutas serán asignadas teniendo en cuenta criterios de eficiencia, seguridad y distancia.

Los servicios complementarios están sujetos a disponibilidad de recursos y convenios, y los estudiantes beneficiarios deben cumplir las normas de uso y convivencia de cada servicio.' AS texto, '6.2.2' AS referencia, 'transporte, ruta, bus, buseta, ruta escolar, conductor, transporte escolar, recogida' AS palabras, 2 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Servicios complementarios' AS categoria, 'Recreación, orientación y otros servicios' AS titulo, '*Recreación dirigida*
• Actividades lúdicas, deportivas, culturales y recreativas para fortalecer habilidades socioemocionales y físicas, adaptadas a cada nivel, con personal idóneo y garantizando la inclusión de todos.

*Otros servicios conexos* (6.2.4)
• El colegio podrá ofrecer orientación escolar, apoyo psicosocial, programas de refuerzo académico y espacios extracurriculares según los recursos disponibles.
• Se promoverá la articulación con entidades de salud, cultura y deporte.

*Condiciones generales:* los servicios dependen de recursos, convenios y criterios definidos con la Secretaría de Educación y el Consejo Directivo; los padres pueden participar en su seguimiento y mejora.' AS texto, '6.2.3' AS referencia, 'recreacion, deportes, actividades extracurriculares, orientacion escolar, psicologo, apoyo psicosocial, refuerzo academico, servicios' AS palabras, 3 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Servicios complementarios' AS categoria, 'Derechos y deberes en los servicios complementarios' AS titulo, '*Derechos de los estudiantes en los servicios complementarios*
• Acceder a los servicios en condiciones de equidad y respeto.
• Recibir una atención segura, oportuna y de calidad.
• Participar activamente en las actividades recreativas y culturales.

*Deberes*
• Utilizar de manera adecuada los servicios prestados.
• Cumplir las normas establecidas para el uso de dichos servicios.
• Reportar comportamientos inadecuados, daños o situaciones de riesgo durante su uso.

El Comité de Convivencia y el Consejo Directivo evalúan periódicamente estos servicios con participación de estudiantes y familias (6.4).' AS texto, '6.3' AS referencia, 'derechos en servicios, deberes en servicios, uso de la tienda, uso del transporte, reportar, evaluacion de servicios' AS palabras, 4 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Servicios complementarios' AS categoria, 'PQRS: peticiones, quejas, reclamos y sugerencias' AS titulo, '*PQRS (Peticiones, Quejas, Reclamos y Sugerencias)*
• Sistema institucional para escuchar, tramitar y responder inquietudes, quejas o sugerencias de la comunidad educativa.
• Se rige por criterios de oportunidad, confidencialidad, respeto y mejora continua.
• Medio: virtual (formulario en la página web o correo).
• Toda solicitud se remite al área o dependencia correspondiente según su contenido.
• *Tiempo de respuesta:* cinco (5) días hábiles contados desde la fecha de radicación. Si se requiere más tiempo, se informará oportunamente al solicitante.

Las respuestas por correo institucional se dan exclusivamente dentro del horario de la jornada académica (7.3.1).' AS texto, '7.2.1' AS referencia, 'pqrs, queja, reclamo, peticion, sugerencia, como poner una queja, tiempo de respuesta, cinco dias habiles, formulario' AS palabras, 5 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Servicios complementarios' AS categoria, 'Correos institucionales y circulares' AS titulo, '*Correos institucionales*
• Herramienta oficial de comunicación entre directivos, docentes, estudiantes y familias.
• Su uso debe ser responsable, respetuoso y estrictamente relacionado con temas académicos o administrativos.
• Está prohibido usarlos para fines personales, políticos o discriminatorios.

*Circulares informativas* (7.2.3)
• Medio formal entre el colegio y las familias para informar sobre eventos, decisiones académicas, procesos administrativos o situaciones especiales.
• Pueden ser físicas (impresas) o digitales (correo, Classroom, WhatsApp institucional).' AS texto, '7.2.2' AS referencia, 'correo institucional, email, circulares, comunicados, whatsapp institucional, como se comunica el colegio, avisos' AS palabras, 6 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Servicios complementarios' AS categoria, 'Classroom, agenda escolar y página web' AS titulo, '*Plataforma institucional (Google Classroom)*
• Espacio virtual oficial para el proceso pedagógico: tareas, retroalimentaciones, anuncios e interacción segura entre docentes y estudiantes.
• Se accede con el correo institucional, respetando las normas de convivencia digital.

*Agendas escolares y libretas de notas* (7.2.5)
• Comunicación diaria entre padres y docentes, especialmente en preescolar y primaria. Deben revisarse y firmarse con regularidad; sirven para observaciones académicas, disciplinarias o solicitudes.

*Página web institucional* (7.2.6)
• Medio oficial de consulta sobre noticias, cronogramas, reglamentos, informes y acceso a PQRS: www.colegiovisionmundial.edu.co' AS texto, '7.2.4' AS referencia, 'classroom, google classroom, tareas, agenda, libreta, pagina web, plataforma, cronograma, notas' AS palabras, 7 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Servicios complementarios' AS categoria, 'Reglas para el uso de los medios de comunicación' AS titulo, '*Principios y reglas para el uso de los medios*
• Principios: libertad de expresión respetuosa, responsabilidad sobre lo que se comunica, confidencialidad, veracidad y uso formativo.
• Toda comunicación institucional debe estar alineada con los valores del colegio.
• Las publicaciones estudiantiles (periódicos, murales, blogs, radio escolar) cuentan con supervisión docente previa a su difusión y deben evitar expresiones ofensivas, discriminatorias o violentas.
• El mal uso de los medios (difundir información falsa, ofensiva o privada sin autorización) dará lugar a medidas formativas y disciplinarias según el Manual.
• Las comunicaciones a la comunidad y las respuestas por correo institucional se realizan exclusivamente dentro del horario de la jornada académica.' AS texto, '7.3.1' AS referencia, 'uso de medios, redes sociales, informacion falsa, publicaciones, periodico escolar, radio escolar, horario de respuesta, libertad de expresion' AS palabras, 8 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Servicios complementarios' AS categoria, 'Escuela de Padres, Madres y Cuidadores' AS titulo, '*Escuela de Padres, Madres y Cuidadores*
Con base en la Ley 2025 de 2020, es un espacio permanente de formación y acompañamiento a las familias para contribuir a la convivencia y al desarrollo integral de los estudiantes.

*Temas:* derechos y deberes de estudiantes y familias; convivencia pacífica en el hogar y la escuela; prevención del acoso escolar y otras violencias; valores y desarrollo socioemocional; uso responsable de tecnologías y redes sociales; participación en la comunidad educativa.

*Cómo se realiza:* talleres, charlas y encuentros periódicos con docentes, psicólogos o expertos externos; metodologías participativas; horarios y modalidades presenciales, virtuales o mixtas; entrega de materiales y guías para el hogar.' AS texto, '17.1' AS referencia, 'escuela de padres, talleres para padres, formacion de padres, cuidadores, ley 2025, crianza, reuniones de padres' AS palabras, 9 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Situaciones Tipo I, II y III' AS categoria, '¿Qué es la Ruta de Atención Integral?' AS titulo, '*Ruta de Atención Integral para la Convivencia Escolar*
Es el conjunto de procedimientos que permiten identificar, atender, remitir y hacer seguimiento a situaciones que afectan la convivencia escolar y/o vulneran los derechos de niñas, niños y adolescentes.

Las situaciones se clasifican en tres niveles:
• *Tipo I:* conflictos manejables en el entorno escolar (peleas, faltas de respeto, desobediencia leve).
• *Tipo II:* acoso escolar, discriminación, ciberacoso, maltrato persistente.
• *Tipo III:* hechos que constituyen presuntos delitos (abuso sexual, lesiones, amenazas, consumo o porte de sustancias, etc.).

*Nota importante:* todas las situaciones se tratan con enfoque de derechos, confidencialidad, debido proceso, no revictimización y participación de estudiantes y familias, de forma proporcional a la gravedad.' AS texto, '13.1' AS referencia, 'ruta de atencion integral, situaciones tipo, tipo 1, tipo 2, tipo 3, clasificacion de faltas, faltas, que tipo de falta es' AS palabras, 1 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Situaciones Tipo I, II y III' AS categoria, 'Situaciones Tipo I' AS titulo, '*Situaciones Tipo I*
Conflictos cotidianos que pueden alterar la convivencia pero no son una vulneración grave de derechos. Se resuelven con acciones pedagógicas y restaurativas por los docentes y el equipo institucional.

*Ejemplos:*
• Peleas o discusiones verbales sin agresión física.
• Burlas o bromas ofensivas ocasionales.
• Falta de respeto a compañeros o docentes.
• Desobediencia a normas escolares.
• Incumplimiento de tareas o responsabilidades.
• Lenguaje inadecuado.
• Pequeños actos de indisciplina o rebeldía.

*Manejo:*
• Diálogo directo y mediación del docente.
• Reporte al Coordinador de Convivencia si es necesario.
• Acuerdos restaurativos (compromisos, disculpas, reparación simbólica).
• Seguimiento del docente o directivo de grupo.
• Firma de acta de compromiso.' AS texto, '13.2.1' AS referencia, 'tipo 1, tipo i, situacion tipo 1, falta leve, pelea, discusion, burla, falta de respeto, desobediencia, lenguaje inadecuado, indisciplina' AS palabras, 2 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Situaciones Tipo I, II y III' AS categoria, 'Situaciones Tipo II' AS titulo, '*Situaciones Tipo II*
Hechos persistentes, sistemáticos o de mayor gravedad que vulneran los derechos de los estudiantes y requieren intervención del Comité Escolar de Convivencia, sin que necesariamente sean delitos.

*Ejemplos:*
• Acoso escolar (bullying) verbal, físico, psicológico o social.
• Ciberacoso o difusión de contenido ofensivo en redes sociales.
• Discriminación por género, etnia, orientación sexual, discapacidad u otras razones.
• Maltrato verbal o físico con intención de humillar o dominar.
• Exclusión sistemática o aislamiento de un estudiante.
• Difamación o rumores persistentes.

*Manejo:*
• Informe formal al Comité Escolar de Convivencia.
• Valoración por el equipo psicosocial.
• Intervenciones pedagógicas y restaurativas.
• Acompañamiento emocional y posible remisión a apoyo externo.
• Participación de las familias.
• Registro en el libro de convivencia, firma de actas de compromiso y anotación en el Observador del alumno.' AS texto, '13.2.2' AS referencia, 'tipo 2, tipo ii, situacion tipo 2, falta grave, bullying, acoso, ciberacoso, discriminacion, maltrato, exclusion, rumores, observador del alumno' AS palabras, 3 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Situaciones Tipo I, II y III' AS categoria, 'Situaciones Tipo III' AS titulo, '*Situaciones Tipo III*
Hechos que pueden constituir delitos según el Código Penal y amenazan la vida, integridad o dignidad de un miembro de la comunidad. Exigen activar de inmediato la ruta interinstitucional.

*Ejemplos:*
• Violencia o abuso sexual.
• Agresiones físicas graves o con armas.
• Amenazas de muerte o lesiones.
• Porte, consumo o comercialización de sustancias psicoactivas dentro o fuera del colegio.
• Autoagresiones o ideación suicida.
• Violencia intrafamiliar detectada en el contexto escolar.
• Porte de armas blancas o de fuego.
• Robo, extorsión o daños graves a la propiedad.

*Manejo:*
• Activación inmediata de la Ruta de Protección y comunicación con ICBF, Policía de Infancia y Adolescencia, Fiscalía, Comisaría de Familia y EPS o servicio de salud mental.
• Protección urgente del menor afectado.
• Registro confidencial y seguimiento del proceso externo.
• Apoyo emocional permanente y acompañamiento institucional.

(Sobre consumo de SPA, ver también el numeral 3.4.2: el consumo no se cataloga como Tipo III salvo que esté asociado a un presunto delito como tráfico o venta.)' AS texto, '13.2.3' AS referencia, 'tipo 3, tipo iii, situacion tipo 3, delito, abuso sexual, armas, amenazas, drogas, robo, extorsion, suicidio, violencia intrafamiliar, falta gravisima' AS palabras, 4 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Situaciones Tipo I, II y III' AS categoria, 'Protocolo 1: acoso escolar (bullying)' AS titulo, '*Protocolo 1: Prevención, detección y atención del acoso escolar (incluye ciberacoso)*

*Prevención:* formación en habilidades socioemocionales y respeto por la diversidad, campañas de sensibilización y cultura del buen trato.

*Detección:* observación de docentes u orientadores; reportes anónimos o confidenciales; información de estudiantes, padres o acudientes.

*Atención:*
1. Valoración inicial por el orientador/a y/o coordinación de convivencia.
2. Activación del Comité Escolar de Convivencia.
3. Estrategias restaurativas (círculos de diálogo, acuerdos de paz, reparación simbólica).
4. Si el caso lo requiere, remisión a entidades externas competentes.

*Seguimiento:* acompañamiento psicológico individual o grupal y reuniones periódicas para verificar el cumplimiento de acuerdos.' AS texto, '14.1' AS referencia, 'protocolo acoso escolar, bullying, ciberacoso, mi hijo sufre bullying, me hacen bullying, denunciar acoso, reporte anonimo, matoneo' AS palabras, 5 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Situaciones Tipo I, II y III' AS categoria, 'Protocolo 2: presunta violencia o abuso sexual' AS titulo, '*Protocolo 2: Atención a situaciones de presunta violencia o abuso sexual*
Objetivo: actuar con inmediatez ante cualquier sospecha, señal o reporte, garantizando la protección integral del menor.

*Ante una sospecha o revelación:*
1. El docente u orientador/a escucha sin presionar y no interroga.
2. Se informa de inmediato a la rectoría y al Comité Escolar de Convivencia.
3. Se activa con urgencia la Ruta de Protección: se contacta al ICBF, Comisaría de Familia o Policía de Infancia y Adolescencia.
4. Se diligencia el registro de situación de vulneración de derechos, con confidencialidad.

*Importante:*
• No se confronta al presunto agresor.
• Se garantiza la atención médica, psicológica y legal.
• Se notifica a los padres o acudientes, salvo que sean los presuntos agresores.' AS texto, '14.2' AS referencia, 'abuso sexual, violencia sexual, acoso sexual, tocamientos, protocolo abuso, denunciar abuso, proteccion del menor' AS palabras, 6 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Situaciones Tipo I, II y III' AS categoria, 'Protocolo 3: consumo o porte de sustancias psicoactivas' AS titulo, '*Protocolo 3: Consumo o porte de sustancias psicoactivas*
Objetivo: prevenir el consumo y actuar de forma pedagógica, restaurativa y protectora.

*Prevención:* talleres y charlas con entidades especializadas, educación para la salud y fortalecimiento de factores protectores familiares y escolares.

*Atención:*
1. Identificación del caso (por evidencia directa o sospecha).
2. Citación inmediata del estudiante y sus padres/acudientes.
3. Valoración por el equipo psicosocial.
4. Activación del Comité Escolar de Convivencia para definir el plan de acción.

*El plan de acción puede incluir:* remisión a entidades de salud, acompañamiento psicológico, medidas pedagógicas (acuerdos, compromisos) y acciones restaurativas.

*Seguimiento:* evaluaciones periódicas, informes de avance y reincorporación activa del estudiante.' AS texto, '14.3' AS referencia, 'protocolo drogas, consumo, porte de drogas, sustancias psicoactivas, spa, marihuana, que pasa si encuentran drogas, citacion padres' AS palabras, 7 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Situaciones Tipo I, II y III' AS categoria, 'Protocolo 4: salud mental y conductas de riesgo' AS titulo, '*Protocolo 4: Alteraciones en salud mental y conductas de riesgo*
Objetivo: detectar y atender situaciones que afecten el bienestar emocional y mental, incluyendo ideación suicida, autolesiones, ansiedad, depresión, entre otros.

*Detección temprana:* cambios de conducta, ausentismo, aislamiento, lenguaje autodestructivo; canales de confianza con docentes, orientadores o compañeros.

*Atención:*
1. Valoración inmediata por el orientador o psicólogo del colegio.
2. Información a padres/acudientes y activación de red de apoyo.
3. Remisión al sistema de salud si se requiere atención clínica.
4. Plan de intervención individual.

*Seguimiento:* reuniones de apoyo escolar y familiar, registro confidencial y adaptaciones pedagógicas cuando sea necesario.' AS texto, '14.4' AS referencia, 'salud mental, depresion, ansiedad, suicidio, ideacion suicida, autolesiones, cortarse, tristeza, psicologo, conductas de riesgo' AS palabras, 8 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Situaciones Tipo I, II y III' AS categoria, 'Protocolo 5: activación de rutas externas' AS titulo, '*Protocolo 5: Activación de rutas externas e interinstitucionales*
Se usa para casos que sobrepasan la competencia del colegio: presunto delito, vulneración grave de derechos o riesgo extremo para la integridad del estudiante.

*Entidades a contactar según el caso:*
• ICBF: protección y restablecimiento de derechos.
• Comisaría de Familia: conflictos familiares, violencia intrafamiliar.
• Policía de Infancia y Adolescencia: delitos o riesgo inminente.
• EPS o servicios de salud mental.
• Fiscalía General de la Nación.

*Proceso:*
1. Diligenciamiento del formato de activación de ruta externa.
2. Registro del caso en el libro de convivencia y archivo de evidencias.
3. Seguimiento institucional al proceso, sin interferir en las investigaciones.

La activación de rutas externas en situaciones Tipo II y III es obligación institucional, liderada por el Comité Escolar de Convivencia o las directivas (19.3).' AS texto, '14.5' AS referencia, 'rutas externas, icbf, comisaria, policia, fiscalia, eps, remision, denuncia, cuando interviene una entidad externa' AS palabras, 9 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Situaciones Tipo I, II y III' AS categoria, 'Definiciones: acoso, ciberacoso, conflicto y más' AS titulo, '*Glosario (Art. 39 del Decreto 1965 de 2013)*
• *Acoso escolar (bullying):* conducta negativa, intencional, metódica y sistemática de agresión, intimidación, humillación, ridiculización, difamación, coacción o maltrato psicológico, verbal, físico o social, que ejerce un estudiante o grupo sobre otro de forma reiterada.
• *Ciberacoso (cyberbullying):* acoso escolar por medios digitales: redes sociales, mensajería instantánea, correos, entre otros.
• *Conflicto:* incompatibilidad real o percibida de intereses entre personas; puede manejarse con diálogo y mediación.
• *Discriminación:* trato desigual o excluyente por etnia, identidad de género, orientación sexual, discapacidad, creencias, condición socioeconómica u otras.
• *Debido proceso:* garantía de que toda actuación respete reglas, procedimientos y derechos, con justicia, imparcialidad y posibilidad de defensa.
• *Enfoque restaurativo:* manejar conflictos reparando el daño y buscando la reconciliación, más allá de la sanción.' AS texto, '19.2' AS referencia, 'que es bullying, que es acoso escolar, ciberacoso, cyberbullying, conflicto, discriminacion, debido proceso, glosario, definiciones' AS palabras, 10 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Directorio de entidades' AS categoria, 'ICBF - Regional Córdoba' AS titulo, '*Instituto Colombiano de Bienestar Familiar (ICBF) - Regional Córdoba*
Entidad rectora de la protección integral de niños, niñas y adolescentes. Atiende casos de abuso, maltrato, violencia intrafamiliar y restablecimiento de derechos.
• Dirección: Carrera 9 # 10 - 26 Urbanización Samaria, frente al Colegio COMFACOR, Montería - Córdoba
• Línea Nacional: 141 (protección a niños, niñas y adolescentes)
• Línea gratuita nacional ICBF: 018000 91 80 80 (lunes a viernes, 8:00 am a 5:00 pm)
• Centro Zonal Montería: Calle 30 # 01 - 48 Barrio Centro, Montería – Córdoba

Nota del manual: se recomienda verificar los números de contacto, ya que pueden cambiar.' AS texto, '19.3.1' AS referencia, 'icbf, bienestar familiar, linea 141, maltrato infantil, abuso, denunciar, proteccion de ninos, telefono icbf' AS palabras, 1 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Directorio de entidades' AS categoria, 'Policía de Infancia y Adolescencia Montería' AS titulo, '*Policía de Infancia y Adolescencia - Grupo de Protección a la Infancia y Adolescencia (GINAD) Montería*
Atiende de manera inmediata los casos que constituyan un delito contra menores de edad y situaciones de riesgo inminente.
• Línea Nacional: 123 (Línea de Emergencia Nacional)
• Teléfono: +57 3123482625
• Policía Metropolitana de Montería: Calle 29 N° 5-61 Barrio Centro

Nota del manual: se recomienda verificar los números de contacto, ya que pueden cambiar.' AS texto, '19.3.2' AS referencia, 'policia, policia de infancia, ginad, 123, emergencia, delito contra menores, telefono policia, riesgo inminente' AS palabras, 2 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Directorio de entidades' AS categoria, 'Comisarías de Familia de Montería' AS titulo, '*Comisarías de Familia de Montería*
Previenen, garantizan, restablecen y reparan los derechos de los miembros de la familia en situaciones de violencia intrafamiliar y maltrato infantil.
• Ubicación: consultar la Comisaría correspondiente al barrio o comuna en la Alcaldía de Montería; generalmente están en las Casas de Justicia o sedes de la alcaldía.
• Dirección: Cl. 20 #32-41, Montería, Córdoba

Nota del manual: se recomienda verificar los números de contacto, ya que pueden cambiar.' AS texto, '19.3.3' AS referencia, 'comisaria de familia, violencia intrafamiliar, maltrato infantil, casa de justicia, alcaldia, problemas familiares' AS palabras, 3 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Directorio de entidades' AS categoria, 'Fiscalía General de la Nación - Seccional Montería' AS titulo, '*Fiscalía General de la Nación - Seccional Montería*
Recibe denuncias sobre hechos que constituyen delitos, como lesiones personales graves, delitos sexuales, amenazas, hurto, entre otros.
• Dirección: Palacio de Justicia, Calle 27 con Carrera 3, Montería, Córdoba
• Línea Nacional: 122 (para presentar denuncias)
• Línea Nacional gratuita: 01 8000 9197 48

Nota del manual: se recomienda verificar los números de contacto, ya que pueden cambiar.' AS texto, '19.3.4' AS referencia, 'fiscalia, denuncia, denunciar delito, 122, lesiones, delitos sexuales, amenazas, hurto, robo' AS palabras, 4 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Directorio de entidades' AS categoria, 'Medicina Legal - Seccional Montería' AS titulo, '*Instituto Nacional de Medicina Legal y Ciencias Forenses - Seccional Montería*
Realiza valoraciones médico-legales en casos de presunto abuso sexual, agresiones físicas y otros delitos, como prueba técnica en procesos judiciales.
• Dirección: Carrera 14 #27-57, Montería, Córdoba
• Líneas gratuitas desde cualquier lugar del país: 01800-5190565

Nota del manual: se recomienda verificar los números de contacto, ya que pueden cambiar.' AS texto, '19.3.5' AS referencia, 'medicina legal, valoracion medico legal, abuso sexual, agresiones, prueba, forense' AS palabras, 5 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Directorio de entidades' AS categoria, 'Secretaría de Salud de Montería' AS titulo, '*Secretaría de Salud de Montería*
Coordina la atención en salud. Para urgencias, salud mental y activación de rutas de atención médica se debe contactar a la EPS del estudiante.
• Contacto: a través de la Alcaldía de Montería o la línea de atención al ciudadano.
• Ubicación: Centro Verde de la Ciudad, Cra. 1W # 32A - 49, Montería, Córdoba
• Dirección Alcaldía: Calle 27 # 3-16, Edificio Antonio de la Torre y Miranda, Montería, Córdoba
• Línea de atención ciudadana: +57 (4) 791 07 20

Nota del manual: se recomienda verificar los números de contacto, ya que pueden cambiar.' AS texto, '19.3.6' AS referencia, 'secretaria de salud, eps, urgencias, salud mental, alcaldia, atencion medica, linea de atencion ciudadana' AS palabras, 6 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Directorio de entidades' AS categoria, 'Defensoría del Pueblo - Regional Córdoba' AS titulo, '*Defensoría del Pueblo - Regional Córdoba*
Vela por la promoción, el ejercicio y la divulgación de los Derechos Humanos. Ofrece orientación y puede interceder cuando hay vulneración de derechos por parte de entidades públicas.
• Dirección: Cl 22 #8b-17 #8b-105 a, Montería, Córdoba
• Única línea nacional: 01-8000-914-814

Nota del manual: se recomienda verificar los números de contacto, ya que pueden cambiar.' AS texto, '19.3.7' AS referencia, 'defensoria del pueblo, derechos humanos, vulneracion de derechos, queja contra entidad, orientacion' AS palabras, 7 AS orden
  UNION ALL SELECT 'manual' AS modulo, 'Directorio de entidades' AS categoria, 'Secretaría de Educación de Montería' AS titulo, '*Secretaría de Educación de Montería*
Ente rector de la política educativa en el municipio. Supervisa el cumplimiento de la normativa de convivencia escolar en las instituciones.
• Contacto: a través de la Alcaldía de Montería.
• Dirección: Cra 15 No 22a-40, Antiguas Oficinas del Seguro Social, Montería, Córdoba
• Dirección secundaria: Carrera 15 N° 22 A-40, Barrio Costa de Oro, Montería-Córdoba
• Teléfonos: 57 (4) 791 166 (tal como aparece en el manual)

Nota del manual: se recomienda verificar los números de contacto, ya que pueden cambiar.' AS texto, '19.3.8' AS referencia, 'secretaria de educacion, sem, queja ante secretaria, supervision, alcaldia, educacion monteria' AS palabras, 8 AS orden
) v
JOIN categorias k ON k.modulo = v.modulo COLLATE utf8mb4_unicode_ci AND k.nombre = v.categoria COLLATE utf8mb4_unicode_ci;
COMMIT;
