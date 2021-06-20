1
SELECT COUNT(*) as Cantidad
FROM envios env
WHERE env.idOrganization = 1 AND
env.idEstado = 1 AND
env.fechaCarga > JULIANDAY('now','-15 day','localtime')
ORDER BY env.fechaCarga DESC;

SELECT env.idEnvio as Envio,date(env.fechaCarga) as FechaCarga,cli.descCliente as Cliente,
tra.descTransportista as Transportista,est.descEstado as Estado
FROM envios env, transportistas tra, clientes cli, estados est
WHERE tra.idTransportista = env.idTransportista AND
cli.idCliente = env.idCliente AND
est.idEstado = env.idEstado AND
env.idOrganization = 1 AND
env.idEstado = 1 AND
env.fechaCarga > JULIANDAY('now','-15 day','localtime')
ORDER BY env.fechaCarga DESC;

2

SELECT CAST(AVG(env.fechaEnvio - env.fechaCarga) AS INTEGER) AS Dias
FROM envios env
WHERE env.idOrganization = 1 AND
env.idEstado = 2 AND
env.fechaCarga > JULIANDAY('now','-30 day','localtime');

SELECT env.idEnvio as Envio,date(env.fechaCarga) as FechaCarga,cli.descCliente as Cliente,
tra.descTransportista as Transportista,est.descEstado as Estado, CAST(env.fechaEnvio - env.fechaCarga AS INTEGER) AS Dias
FROM envios env, transportistas tra, clientes cli, estados est
WHERE tra.idTransportista = env.idTransportista AND
cli.idCliente = env.idCliente AND
est.idEstado = env.idEstado AND env.idOrganization = 1 AND
env.idEstado = 2 AND
env.fechaCarga > JULIANDAY('now','-30 day','localtime')
ORDER BY CAST(env.fechaEnvio - env.fechaCarga AS INTEGER) DESC;

3

SELECT COUNT(*) as Cantidad
FROM envios env
WHERE env.idOrganization = 1 AND
env.idEstado = 1 AND
env.fechaCarga < JULIANDAY('now','-15 day','localtime')
ORDER BY env.fechaCarga DESC;

SELECT env.idEnvio as Envio,date(env.fechaCarga) as FechaCarga,cli.descCliente as Cliente,
tra.descTransportista as Transportista,est.descEstado as Estado
FROM envios env, transportistas tra, clientes cli, estados est
WHERE tra.idTransportista = env.idTransportista AND
cli.idCliente = env.idCliente AND
est.idEstado = env.idEstado AND
env.idOrganization = 1 AND
env.idEstado = 1 AND
env.fechaCarga < JULIANDAY('now','-15 day','localtime')
ORDER BY env.fechaCarga DESC;



DROP TABLE roles;
CREATE TABLE "roles" (
	"idRol"	INTEGER NOT NULL UNIQUE,
	"descRol"	VARCHAR(20) NOT NULL,
	PRIMARY KEY("idRol")
);
INSERT INTO roles VALUES (1,"Admin");
INSERT INTO roles VALUES (2,"Transportista");
INSERT INTO roles VALUES (3,"Cliente");

DROP TABLE transportistas;
CREATE TABLE "transportistas" (
	"idTransportista"	INTEGER NOT NULL UNIQUE,
	"descTransportista"	VARCHAR(100) NOT NULL,
	"idOrganization"	INTEGER NOT NULL,
	PRIMARY KEY("idTransportista")
);
INSERT INTO transportistas VALUES (002,"TN LOGISTICA ,WALTER S.NICOLAS",1);
INSERT INTO transportistas VALUES (004,"CORREO ANDREANI",1);
INSERT INTO transportistas VALUES (005,"COMEX",1);
INSERT INTO transportistas VALUES (006,"TRANSPORTE ALMADA",1);
INSERT INTO transportistas VALUES (007,"TRANSRED",1);
INSERT INTO transportistas VALUES (008,"DIMARCO",1);
INSERT INTO transportistas VALUES (017,"CHAPUY EXPRESS",1);
INSERT INTO transportistas VALUES (018,"SANTIAGO VEIGA",1);
INSERT INTO transportistas VALUES (019,"PELAYO GONZALO",1);
INSERT INTO transportistas VALUES (020,"EZEQUIEL LANZAVECHIA",1);
INSERT INTO transportistas VALUES (021,"ALAN WARGNER",1);
INSERT INTO transportistas VALUES (012,"OPTICAL EXPRESS",1);
INSERT INTO transportistas VALUES (010,"WALTER OMAR BENITEZ",1);
INSERT INTO transportistas VALUES (022,"TRANS-BAN",1);
INSERT INTO transportistas VALUES (009,"CREDIFIN",1);


DROP TABLE clientes;
CREATE TABLE "clientes" (
	"idCliente"	INTEGER NOT NULL UNIQUE,
	"descCliente"	VARCHAR(100) NOT NULL,
	"idOrganization"	INTEGER NOT NULL,
	PRIMARY KEY("idCliente")
);
INSERT INTO clientes VALUES (0000014445,'ALCORTA VISION',1);
INSERT INTO clientes VALUES (0000015316,'ALEJANDRO GIORDANO Y ADELMA OCAMPO SH',1);
INSERT INTO clientes VALUES (0000011395,'AMUR VENADO TUERTO',1);
INSERT INTO clientes VALUES (0000111438,'ANDRADA PAULA Y MUSSETTI SILVINA',1);
INSERT INTO clientes VALUES (0000111829,'ARMASE S.R.L.',1);
INSERT INTO clientes VALUES (0000111684,'ASOCIACIÓN MUTUAL FERROVIARIA',1);
INSERT INTO clientes VALUES (0000000749,'BEGINO JUAN JOSE',1);
INSERT INTO clientes VALUES (0000111456,'BELKIS VIVIANA GRAZIOSI',1);
INSERT INTO clientes VALUES (0000013231,'BELTRAMINO J. PABLO Y RACCARO OSCAR NATA',1);
INSERT INTO clientes VALUES (0000000510,'BELTRAMINO RICARDO HUGO',1);
INSERT INTO clientes VALUES (0000000332,'BOCCO FERNANDO',1);
INSERT INTO clientes VALUES (0000000720,'BONFIGLI JUAN IGNACIO',1);
INSERT INTO clientes VALUES (0000111824,'BOULEVARD AVENIDA DE Pussetto Mónica Cla',1);
INSERT INTO clientes VALUES (0000000095,'BRITOS CARINA ELIZABET',1);
INSERT INTO clientes VALUES (0000015194,'CENTRO INTEGRAL DE LA VISION. TONSICH.',1);
INSERT INTO clientes VALUES (0000000647,'CENTRO OPTICO ARMSTRONG',1);
INSERT INTO clientes VALUES (0000111517,'CENTRO OPTICO BEL MAR',1);
INSERT INTO clientes VALUES (0000000418,'CENTRO OPTICO CAÑADA',1);
INSERT INTO clientes VALUES (0000000485,'CENTRO OPTICO INTEGRAL ROSARIO',1);
INSERT INTO clientes VALUES (0000111286,'CENTRO OPTICO MACIEL',1);
INSERT INTO clientes VALUES (0000000043,'CENTRO OPTICO MAIPU',1);
INSERT INTO clientes VALUES (0000000467,'CENTRO OPTICO ROSARIO - HIMELFARB',1);
INSERT INTO clientes VALUES (0000000002,'CORNEALENT ROSARIO S.R.L.',1);
INSERT INTO clientes VALUES (0000111644,'CREMA OBERTTI LEANDRO T',1);
INSERT INTO clientes VALUES (0000111368,'DOTTI MARIA JOSE Y MARIA BELEN S.H.',1);
INSERT INTO clientes VALUES (0000009505,'Espacio Optico de Camila Belbuzzi',1);
INSERT INTO clientes VALUES (0000111826,'FIDEICOMISO CAMARA DE OPTICAS',1);
INSERT INTO clientes VALUES (0000000646,'GOERNER CARLOS ERNESTO Y GOERNER DIEGO S',1);
INSERT INTO clientes VALUES (0000000494,'GRUPO OPTICO S.R.L.',1);
INSERT INTO clientes VALUES (0000111660,'GRUPO SER VISION',1);
INSERT INTO clientes VALUES (0000000433,'IB LABORATORIO OPTICO',1);
INSERT INTO clientes VALUES (0000000037,'INDUSTRIAS JOHN DEERE ARGENTINA S.A.',1);
INSERT INTO clientes VALUES (0000000004,'INSTITUTO OPTICO MICROLUX',1);
INSERT INTO clientes VALUES (0000000198,'Ivone Bizet',1);
INSERT INTO clientes VALUES (0000000741,'JORDAN VALERIA',1);
INSERT INTO clientes VALUES (0000015283,'KOCAK CLARISA MABEL',1);
INSERT INTO clientes VALUES (0000111759,'LA OPTICA  (Villa Ocampo)',1);
INSERT INTO clientes VALUES (0000111680,'LA OPTICA - Arroyo Seco',1);
INSERT INTO clientes VALUES (0000111113,'LABORATORIO DANLENS de Mariano Danjelic',1);
INSERT INTO clientes VALUES (0000111457,'LABORATORIO OPTICO CRISTALENT',1);
INSERT INTO clientes VALUES (0000000044,'LABORATORIO OPTICO GUATIMOZIN',1);
INSERT INTO clientes VALUES (0000000033,'LABORATORIO OPTICO INTEGRAL',1);
INSERT INTO clientes VALUES (0000111416,'LARGACHA FERNANDO Y LARGACHA ROCIO',1);
INSERT INTO clientes VALUES (0000111443,'LAS GAVIOLI',1);
INSERT INTO clientes VALUES (0000111239,'LE MIRAGE',1);
INSERT INTO clientes VALUES (0000000426,'LINET CENTRO OPTICO',1);
INSERT INTO clientes VALUES (0000000067,'LOPEZ DELIA SUSANA',1);
INSERT INTO clientes VALUES (0000111301,'MAS ÓPTICA',1);
INSERT INTO clientes VALUES (0000015336,'MEGAVISION OPTICA',1);
INSERT INTO clientes VALUES (0000000038,'MILANO RODOLFO JOSE',1);
INSERT INTO clientes VALUES (0000015379,'MONDO VISION',1);
INSERT INTO clientes VALUES (0000000476,'MONTERO CARLOS ADRIÁN Y MONTERO ARIEL',1);
INSERT INTO clientes VALUES (0000111459,'MULTI VISION de Ingrid Lang',1);
INSERT INTO clientes VALUES (0000000744,'MUNDO VISUAL',1);
INSERT INTO clientes VALUES (0000000327,'Maxivision VOSS CARLOS BENJAM',1);
INSERT INTO clientes VALUES (0000000464,'NEO VISiON DE JULIETA TOIA',1);
INSERT INTO clientes VALUES (0000000055,'NEW LENS S.R.L.',1);
INSERT INTO clientes VALUES (0000011133,'NOVOVISION OPTICA Y CONTACTOLOGIA',1);
INSERT INTO clientes VALUES (0000014020,'OBANDO DANIELA ANDREA (Neovision Venado)',1);
INSERT INTO clientes VALUES (0000111414,'OLIVER GONZALO LUCAS',1);
INSERT INTO clientes VALUES (0000111562,'OPT. Y CONT. BALFAGON',1);
INSERT INTO clientes VALUES (0000014644,'OPTI.NET',1);
INSERT INTO clientes VALUES (0000111670,'OPTIBELL',1);
INSERT INTO clientes VALUES (0000000030,'OPTICA ADRIANA GIRAUDO',1);
INSERT INTO clientes VALUES (0000000348,'OPTICA ANDRADE SAS',1);
INSERT INTO clientes VALUES (0000000195,'OPTICA ANDREOLA DE M',1);
INSERT INTO clientes VALUES (0000111582,'OPTICA ANDRICH',1);
INSERT INTO clientes VALUES (0000000040,'OPTICA ANER de HECTOR OMAR GENTILI',1);
INSERT INTO clientes VALUES (0000111541,'OPTICA ARAGON',1);
INSERT INTO clientes VALUES (0000000058,'OPTICA AVENIDA de Rothamel Fabian',1);
INSERT INTO clientes VALUES (0000014992,'OPTICA BELLETTI',1);
INSERT INTO clientes VALUES (0000111681,'OPTICA BELLUCCINI',1);
INSERT INTO clientes VALUES (0000000777,'OPTICA BISTOTTO SOCIEDAD DE HECHO',1);
INSERT INTO clientes VALUES (0000013810,'OPTICA BONAZZOLA DE ALFONSO EMILIA GUADA',1);
INSERT INTO clientes VALUES (0000111433,'OPTICA BOULEVARD RECOLETA',1);
INSERT INTO clientes VALUES (0000111148,'OPTICA BURKI DE EXEQUIEL BURKI',1);
INSERT INTO clientes VALUES (0000000317,'OPTICA CECILIA MILANO',1);
INSERT INTO clientes VALUES (0000111267,'OPTICA CELIA',1);
INSERT INTO clientes VALUES (0000111401,'OPTICA CIELO',1);
INSERT INTO clientes VALUES (0000111481,'OPTICA COLOMBA',1);
INSERT INTO clientes VALUES (0000000072,'OPTICA CONTINI Flores Nora  y Nanzer M.J',1);
INSERT INTO clientes VALUES (0000111278,'OPTICA CORREA',1);
INSERT INTO clientes VALUES (0000000669,'OPTICA COSATTO',1);
INSERT INTO clientes VALUES (0000111589,'OPTICA CRISOL ( CORRAL DE BUSTOS)',1);
INSERT INTO clientes VALUES (0000111214,'OPTICA CRISTAL (LAS ROSAS)',1);
INSERT INTO clientes VALUES (0000000087,'OPTICA DE FILIPPI',1);
INSERT INTO clientes VALUES (0000111624,'OPTICA DEL BELLO',1);
INSERT INTO clientes VALUES (0000000375,'OPTICA DEL FANTE (DIEGO D. FANTE)',1);
INSERT INTO clientes VALUES (0000000686,'OPTICA DEL SIGLO DE ANALIA ALJARAL Y FRA',1);
INSERT INTO clientes VALUES (0000111553,'OPTICA DEL SOL (PERGAMINO)',1);
INSERT INTO clientes VALUES (0000111633,'OPTICA DEL SOL (SALTO)',1);
INSERT INTO clientes VALUES (0000111653,'OPTICA DEL SOL CENTENARIO',1);
INSERT INTO clientes VALUES (0000000308,'OPTICA DI BENEDETTO',1);
INSERT INTO clientes VALUES (0000000012,'OPTICA ESTERLIZI DE SUSANA ESTERLIZI',1);
INSERT INTO clientes VALUES (0000111246,'OPTICA FALCO LENT',1);
INSERT INTO clientes VALUES (0000013964,'OPTICA FAYOLLE',1);
INSERT INTO clientes VALUES (0000015562,'OPTICA FERNANDA AGUADA',1);
INSERT INTO clientes VALUES (0000000008,'OPTICA FERRARI',1);
INSERT INTO clientes VALUES (0000111591,'OPTICA FERRARI (CORRAL DE BUSTOS)',1);
INSERT INTO clientes VALUES (0000000725,'OPTICA FERRARI DE CABALLERO DELIA BEATRI',1);
INSERT INTO clientes VALUES (0000111642,'OPTICA FIGUN',1);
INSERT INTO clientes VALUES (0000000468,'OPTICA FOTO GASTALDI',1);
INSERT INTO clientes VALUES (0000000001,'OPTICA FOTO WIDMER S.H.',1);
INSERT INTO clientes VALUES (0000111630,'OPTICA FREITAS',1);
INSERT INTO clientes VALUES (0000000018,'OPTICA GAFAS DE BOMPADRE GRACIELA',1);
INSERT INTO clientes VALUES (0000111245,'OPTICA GAVIOLI',1);
INSERT INTO clientes VALUES (0000000066,'OPTICA GIACCHINO DE MIRTA L. GIACCHINO',1);
INSERT INTO clientes VALUES (0000000014,'OPTICA GIULIANO',1);
INSERT INTO clientes VALUES (0000111637,'OPTICA KAIZEN',1);
INSERT INTO clientes VALUES (0000111304,'OPTICA LINCE',1);
INSERT INTO clientes VALUES (0000111542,'OPTICA LISERRA',1);
INSERT INTO clientes VALUES (0000111581,'OPTICA LLAMOSAS',1);
INSERT INTO clientes VALUES (0000000019,'OPTICA LORENTE S.R.L.',1);
INSERT INTO clientes VALUES (0000111465,'OPTICA LUCIANO VIRGALA',1);
INSERT INTO clientes VALUES (0000111646,'OPTICA LUENGO',1);
INSERT INTO clientes VALUES (0000111802,'OPTICA LUZ (Concordia)',1);
INSERT INTO clientes VALUES (0000111312,'OPTICA MARCHIORI',1);
INSERT INTO clientes VALUES (0000000338,'OPTICA MARIA JUANA DE MARIA SILVINA MI',1);
INSERT INTO clientes VALUES (0000011639,'OPTICA MUNDO',1);
INSERT INTO clientes VALUES (0000000330,'OPTICA NIETO DE LIS JUDITH NIETO',1);
INSERT INTO clientes VALUES (0000000537,'OPTICA NORTE DE ANALIA LORENA MACH',1);
INSERT INTO clientes VALUES (0000111640,'OPTICA OJITO DE SOL',1);
INSERT INTO clientes VALUES (0000111587,'OPTICA Q`VER',1);
INSERT INTO clientes VALUES (0000000542,'OPTICA SALADILLO DE CANIGLIA FRANCESCA',1);
INSERT INTO clientes VALUES (0000111388,'OPTICA SAN AGUSTIN',1);
INSERT INTO clientes VALUES (0000000099,'OPTICA SANZ PEÑA',1);
INSERT INTO clientes VALUES (0000000439,'OPTICA SELLARES DE JAVIER SELLARES',1);
INSERT INTO clientes VALUES (0000000738,'OPTICA SENTIDOS',1);
INSERT INTO clientes VALUES (0000000319,'OPTICA SETTECASE',1);
INSERT INTO clientes VALUES (0000000005,'OPTICA SOCIAL de JOSE LUIS CANZANI',1);
INSERT INTO clientes VALUES (0000111651,'OPTICA SOL (CONCORDIA)',1);
INSERT INTO clientes VALUES (0000000053,'OPTICA SORBAZ de Frustagli Vanina A.',1);
INSERT INTO clientes VALUES (0000000797,'OPTICA STELLA MARIS',1);
INSERT INTO clientes VALUES (0000000309,'OPTICA TRILENT CORRIENTES',1);
INSERT INTO clientes VALUES (0000111421,'OPTICA TRINI',1);
INSERT INTO clientes VALUES (0000000061,'OPTICA VACCHINO',1);
INSERT INTO clientes VALUES (0000000042,'OPTICA VISION DE COLON ,FRANETOVICH JOSE',1);
INSERT INTO clientes VALUES (0000000491,'OPTICA VISO',1);
INSERT INTO clientes VALUES (0000111434,'OPTICA YOCCO',1);
INSERT INTO clientes VALUES (0000013084,'OPTICALL',1);
INSERT INTO clientes VALUES (0000111639,'OPTIGRAFIA',1);
INSERT INTO clientes VALUES (0000111625,'OPTIK CENTER',1);
INSERT INTO clientes VALUES (0000000677,'OPTILENT S.R.L.',1);
INSERT INTO clientes VALUES (0000000678,'OPTIMA VISIÓN',1);
INSERT INTO clientes VALUES (0000000558,'OPTIMAX S.R.L.',1);
INSERT INTO clientes VALUES (0000111464,'OPTINOVA',1);
INSERT INTO clientes VALUES (0000000509,'OPTIVISION',1);
INSERT INTO clientes VALUES (0000010004,'OPTOVISION',1);
INSERT INTO clientes VALUES (0000111710,'Opt. CONTINI Pto San Martin',1);
INSERT INTO clientes VALUES (0000000611,'Optica Boulevard',1);
INSERT INTO clientes VALUES (0000000571,'Optica Estilo Rafaela USEGLIO CLAUDIA',1);
INSERT INTO clientes VALUES (0000111264,'Optica GASSER.KLEIN',1);
INSERT INTO clientes VALUES (0000013865,'Optica KNUDSEN',1);
INSERT INTO clientes VALUES (0000000511,'Optica Real Imagen GIRAUDO WALTER',1);
INSERT INTO clientes VALUES (0000000668,'Optica Sol Ferreyra Cecilia',1);
INSERT INTO clientes VALUES (0000000333,'Optica Stigma',1);
INSERT INTO clientes VALUES (0000000336,'Opticenter',1);
INSERT INTO clientes VALUES (0000015279,'Optika Kalkov',1);
INSERT INTO clientes VALUES (0000000434,'Optilent Hughes ANA MARIA PEROTTO',1);
INSERT INTO clientes VALUES (0000000329,'PIRAMIDE DEL SOL',1);
INSERT INTO clientes VALUES (0000111809,'PRECISION LENS S.A.',1);
INSERT INTO clientes VALUES (0000000685,'PROPERZI M. CECILIA',1);
INSERT INTO clientes VALUES (0000015919,'PUNTO DE VISTA',1);
INSERT INTO clientes VALUES (0000111425,'PUNTO OPTICO',1);
INSERT INTO clientes VALUES (0000000466,'RED OPTIMUR',1);
INSERT INTO clientes VALUES (0000000410,'RED OPTIMUR (ROSARIO)',1);
INSERT INTO clientes VALUES (0000111429,'RENGHINI MARIANO ( LOOK ÓPTICA)',1);
INSERT INTO clientes VALUES (0000000335,'RODOLFO ARIEL CABALLERO',1);
INSERT INTO clientes VALUES (0000015485,'ROGER BACON',1);
INSERT INTO clientes VALUES (0000111782,'ROSSET MARÍA ALEJANDRA',1);
INSERT INTO clientes VALUES (0000111761,'RUBIO DANIEL OSVALDO ( MONTEVIDEO)',1);
INSERT INTO clientes VALUES (0000111454,'RUBIO DANIEL OSVALDO (FUNES)',1);
INSERT INTO clientes VALUES (0000111532,'RUBIO Daniel O. (Arroyo Seco)',1);
INSERT INTO clientes VALUES (0000000715,'RUFFO ESTEBAN MARCOS',1);
INSERT INTO clientes VALUES (0000111578,'Rubio D.O. (San Nicolas)',1);
INSERT INTO clientes VALUES (0000000411,'Rubio Daniel Osvaldo (Calle San Luis)',1);
INSERT INTO clientes VALUES (0000111552,'SANOPX SAN NICOLAS S.A.',1);
INSERT INTO clientes VALUES (0000000071,'SBODIO S.A',1);
INSERT INTO clientes VALUES (0000000649,'SCIARRESI M. EUGENIA - OPT. MESI',1);
INSERT INTO clientes VALUES (0000000796,'SERGIO GOMEZ',1);
INSERT INTO clientes VALUES (0000000395,'SERVICIO OPTICA MECAC',1);
INSERT INTO clientes VALUES (0000000048,'SILVINA BISTOTTO',1);
INSERT INTO clientes VALUES (0000111563,'SINDICATO DE EMPLEADOS DE COMERCIO',1);
INSERT INTO clientes VALUES (0000111426,'SITIO OPTICO',1);
INSERT INTO clientes VALUES (0000000648,'SU-VISION DE SUSANA BEATRIZ CONCHA',1);
INSERT INTO clientes VALUES (0000000027,'SUIZA EXPRESS',1);
INSERT INTO clientes VALUES (0000111783,'TALLER OPTICO GLOBAL',1);
INSERT INTO clientes VALUES (0000013509,'TECNOPTIKA',1);
INSERT INTO clientes VALUES (0000000035,'TRILENT MENDOZA de Crema Alejandro',1);
INSERT INTO clientes VALUES (0000111439,'TRILENT RECONQUISTA, de Cristián Crema',1);
INSERT INTO clientes VALUES (0000000495,'VEROPTIMO S.A.',1);
INSERT INTO clientes VALUES (0000013787,'VISION LAB',1);
INSERT INTO clientes VALUES (0000111352,'VISTA PREMIUM Sergio Amarilla',1);
INSERT INTO clientes VALUES (0000000196,'VNT SRL',1);
INSERT INTO clientes VALUES (0000111609,'VNT SRL (SUR)',1);
INSERT INTO clientes VALUES (0000000519,'ZACUTTI ENRIQUE GABRIEL',1);

DROP TABLE rel_clientes_transportistas;
CREATE TABLE "rel_clientes_transportistas" (
	"idCliente"	INTEGER NOT NULL,
	"idTransportista"	INTEGER NOT NULL,
	PRIMARY KEY("idCliente","idTransportista")
);
INSERT INTO rel_clientes_transportistas VALUES (0000014445,1);
INSERT INTO rel_clientes_transportistas VALUES (0000015316,2);
INSERT INTO rel_clientes_transportistas VALUES (0000011395,3);
INSERT INTO rel_clientes_transportistas VALUES (0000111438,4);
INSERT INTO rel_clientes_transportistas VALUES (0000111829,5);
INSERT INTO rel_clientes_transportistas VALUES (0000111684,6);
INSERT INTO rel_clientes_transportistas VALUES (0000000749,7);
INSERT INTO rel_clientes_transportistas VALUES (0000111456,1);
INSERT INTO rel_clientes_transportistas VALUES (0000013231,6);
INSERT INTO rel_clientes_transportistas VALUES (0000000510,2);
INSERT INTO rel_clientes_transportistas VALUES (0000000332,8);
INSERT INTO rel_clientes_transportistas VALUES (0000000720,4);
INSERT INTO rel_clientes_transportistas VALUES (0000111824,1);
INSERT INTO rel_clientes_transportistas VALUES (0000000095,7);
INSERT INTO rel_clientes_transportistas VALUES (0000015194,3);
INSERT INTO rel_clientes_transportistas VALUES (0000000647,6);
INSERT INTO rel_clientes_transportistas VALUES (0000111517,5);
INSERT INTO rel_clientes_transportistas VALUES (0000000418,6);
INSERT INTO rel_clientes_transportistas VALUES (0000000485,5);
INSERT INTO rel_clientes_transportistas VALUES (0000111286,7);
INSERT INTO rel_clientes_transportistas VALUES (0000000043,5);
INSERT INTO rel_clientes_transportistas VALUES (0000000467,5);
INSERT INTO rel_clientes_transportistas VALUES (0000000002,5);
INSERT INTO rel_clientes_transportistas VALUES (0000111644,5);
INSERT INTO rel_clientes_transportistas VALUES (0000111368,5);
INSERT INTO rel_clientes_transportistas VALUES (0000009505,3);
INSERT INTO rel_clientes_transportistas VALUES (0000111826,2);
INSERT INTO rel_clientes_transportistas VALUES (0000000646,5);
INSERT INTO rel_clientes_transportistas VALUES (0000000494,5);
INSERT INTO rel_clientes_transportistas VALUES (0000111660,5);
INSERT INTO rel_clientes_transportistas VALUES (0000000433,1);
INSERT INTO rel_clientes_transportistas VALUES (0000000037,5);
INSERT INTO rel_clientes_transportistas VALUES (0000000004,8);
INSERT INTO rel_clientes_transportistas VALUES (0000000198,4);
INSERT INTO rel_clientes_transportistas VALUES (0000000741,9);
INSERT INTO rel_clientes_transportistas VALUES (0000015283,7);
INSERT INTO rel_clientes_transportistas VALUES (0000111759,2);
INSERT INTO rel_clientes_transportistas VALUES (0000111680,7);
INSERT INTO rel_clientes_transportistas VALUES (0000111113,10);
INSERT INTO rel_clientes_transportistas VALUES (0000111457,4);
INSERT INTO rel_clientes_transportistas VALUES (0000000044,8);
INSERT INTO rel_clientes_transportistas VALUES (0000000033,1);
INSERT INTO rel_clientes_transportistas VALUES (0000111416,5);
INSERT INTO rel_clientes_transportistas VALUES (0000111443,6);
INSERT INTO rel_clientes_transportistas VALUES (0000111239,7);
INSERT INTO rel_clientes_transportistas VALUES (0000000426,6);
INSERT INTO rel_clientes_transportistas VALUES (0000000067,5);
INSERT INTO rel_clientes_transportistas VALUES (0000015336,8);
INSERT INTO rel_clientes_transportistas VALUES (0000000038,8);
INSERT INTO rel_clientes_transportistas VALUES (0000015379,5);
INSERT INTO rel_clientes_transportistas VALUES (0000000476,1);
INSERT INTO rel_clientes_transportistas VALUES (0000111459,2);
INSERT INTO rel_clientes_transportistas VALUES (0000000744,2);
INSERT INTO rel_clientes_transportistas VALUES (0000000327,6);
INSERT INTO rel_clientes_transportistas VALUES (0000000464,5);
INSERT INTO rel_clientes_transportistas VALUES (0000000055,5);
INSERT INTO rel_clientes_transportistas VALUES (0000011133,2);
INSERT INTO rel_clientes_transportistas VALUES (0000014020,3);
INSERT INTO rel_clientes_transportistas VALUES (0000111414,2);
INSERT INTO rel_clientes_transportistas VALUES (0000111562,8);
INSERT INTO rel_clientes_transportistas VALUES (0000014644,9);
INSERT INTO rel_clientes_transportistas VALUES (0000111670,2);
INSERT INTO rel_clientes_transportistas VALUES (0000000030,5);
INSERT INTO rel_clientes_transportistas VALUES (0000000348,5);
INSERT INTO rel_clientes_transportistas VALUES (0000000195,1);
INSERT INTO rel_clientes_transportistas VALUES (0000111582,8);
INSERT INTO rel_clientes_transportistas VALUES (0000000040,8);
INSERT INTO rel_clientes_transportistas VALUES (0000000058,5);
INSERT INTO rel_clientes_transportistas VALUES (0000014992,4);
INSERT INTO rel_clientes_transportistas VALUES (0000111681,4);
INSERT INTO rel_clientes_transportistas VALUES (0000000777,7);
INSERT INTO rel_clientes_transportistas VALUES (0000013810,1);
INSERT INTO rel_clientes_transportistas VALUES (0000111433,1);
INSERT INTO rel_clientes_transportistas VALUES (0000111148,4);
INSERT INTO rel_clientes_transportistas VALUES (0000000317,5);
INSERT INTO rel_clientes_transportistas VALUES (0000111267,7);
INSERT INTO rel_clientes_transportistas VALUES (0000111401,2);
INSERT INTO rel_clientes_transportistas VALUES (0000111481,1);
INSERT INTO rel_clientes_transportistas VALUES (0000000072,7);
INSERT INTO rel_clientes_transportistas VALUES (0000111278,4);
INSERT INTO rel_clientes_transportistas VALUES (0000000669,5);
INSERT INTO rel_clientes_transportistas VALUES (0000111589,8);
INSERT INTO rel_clientes_transportistas VALUES (0000111214,4);
INSERT INTO rel_clientes_transportistas VALUES (0000000087,3);
INSERT INTO rel_clientes_transportistas VALUES (0000111624,5);
INSERT INTO rel_clientes_transportistas VALUES (0000000375,5);
INSERT INTO rel_clientes_transportistas VALUES (0000000686,5);
INSERT INTO rel_clientes_transportistas VALUES (0000111553,2);
INSERT INTO rel_clientes_transportistas VALUES (0000111633,2);
INSERT INTO rel_clientes_transportistas VALUES (0000111653,2);
INSERT INTO rel_clientes_transportistas VALUES (0000000308,3);
INSERT INTO rel_clientes_transportistas VALUES (0000111246,6);
INSERT INTO rel_clientes_transportistas VALUES (0000013964,5);
INSERT INTO rel_clientes_transportistas VALUES (0000015562,7);
INSERT INTO rel_clientes_transportistas VALUES (0000000008,8);
INSERT INTO rel_clientes_transportistas VALUES (0000111591,8);
INSERT INTO rel_clientes_transportistas VALUES (0000000725,4);
INSERT INTO rel_clientes_transportistas VALUES (0000111642,2);
INSERT INTO rel_clientes_transportistas VALUES (0000000468,2);
INSERT INTO rel_clientes_transportistas VALUES (0000000001,3);
INSERT INTO rel_clientes_transportistas VALUES (0000111630,11);
INSERT INTO rel_clientes_transportistas VALUES (0000111245,6);
INSERT INTO rel_clientes_transportistas VALUES (0000000066,5);
INSERT INTO rel_clientes_transportistas VALUES (0000111637,11);
INSERT INTO rel_clientes_transportistas VALUES (0000111304,1);
INSERT INTO rel_clientes_transportistas VALUES (0000111542,5);
INSERT INTO rel_clientes_transportistas VALUES (0000111581,8);
INSERT INTO rel_clientes_transportistas VALUES (0000000019,5);
INSERT INTO rel_clientes_transportistas VALUES (0000111465,2);
INSERT INTO rel_clientes_transportistas VALUES (0000111646,11);
INSERT INTO rel_clientes_transportistas VALUES (0000111802,2);
INSERT INTO rel_clientes_transportistas VALUES (0000111312,2);
INSERT INTO rel_clientes_transportistas VALUES (0000000338,4);
INSERT INTO rel_clientes_transportistas VALUES (0000011639,5);
INSERT INTO rel_clientes_transportistas VALUES (0000000330,5);
INSERT INTO rel_clientes_transportistas VALUES (0000000537,5);
INSERT INTO rel_clientes_transportistas VALUES (0000111640,3);
INSERT INTO rel_clientes_transportistas VALUES (0000111587,8);
INSERT INTO rel_clientes_transportistas VALUES (0000000542,5);
INSERT INTO rel_clientes_transportistas VALUES (0000111388,2);
INSERT INTO rel_clientes_transportistas VALUES (0000000099,5);
INSERT INTO rel_clientes_transportistas VALUES (0000000439,2);
INSERT INTO rel_clientes_transportistas VALUES (0000000738,6);
INSERT INTO rel_clientes_transportistas VALUES (0000000319,5);
INSERT INTO rel_clientes_transportistas VALUES (0000000005,8);
INSERT INTO rel_clientes_transportistas VALUES (0000111651,2);
INSERT INTO rel_clientes_transportistas VALUES (0000000053,5);
INSERT INTO rel_clientes_transportistas VALUES (0000000797,4);
INSERT INTO rel_clientes_transportistas VALUES (0000000309,5);
INSERT INTO rel_clientes_transportistas VALUES (0000111421,5);
INSERT INTO rel_clientes_transportistas VALUES (0000000061,6);
INSERT INTO rel_clientes_transportistas VALUES (0000000042,1);
INSERT INTO rel_clientes_transportistas VALUES (0000000491,5);
INSERT INTO rel_clientes_transportistas VALUES (0000111434,1);
INSERT INTO rel_clientes_transportistas VALUES (0000013084,8);
INSERT INTO rel_clientes_transportistas VALUES (0000111639,11);
INSERT INTO rel_clientes_transportistas VALUES (0000111625,5);
INSERT INTO rel_clientes_transportistas VALUES (0000000677,1);
INSERT INTO rel_clientes_transportistas VALUES (0000000678,5);
INSERT INTO rel_clientes_transportistas VALUES (0000000558,5);
INSERT INTO rel_clientes_transportistas VALUES (0000111464,2);
INSERT INTO rel_clientes_transportistas VALUES (0000000509,5);
INSERT INTO rel_clientes_transportistas VALUES (0000111710,7);
INSERT INTO rel_clientes_transportistas VALUES (0000000611,1);
INSERT INTO rel_clientes_transportistas VALUES (0000000571,2);
INSERT INTO rel_clientes_transportistas VALUES (0000111264,2);
INSERT INTO rel_clientes_transportistas VALUES (0000013865,5);
INSERT INTO rel_clientes_transportistas VALUES (0000000511,6);
INSERT INTO rel_clientes_transportistas VALUES (0000000668,1);
INSERT INTO rel_clientes_transportistas VALUES (0000000333,4);
INSERT INTO rel_clientes_transportistas VALUES (0000000336,1);
INSERT INTO rel_clientes_transportistas VALUES (0000015279,5);
INSERT INTO rel_clientes_transportistas VALUES (0000000434,1);
INSERT INTO rel_clientes_transportistas VALUES (0000000329,9);
INSERT INTO rel_clientes_transportistas VALUES (0000111809,2);
INSERT INTO rel_clientes_transportistas VALUES (0000000685,5);
INSERT INTO rel_clientes_transportistas VALUES (0000015919,7);
INSERT INTO rel_clientes_transportistas VALUES (0000111425,4);
INSERT INTO rel_clientes_transportistas VALUES (0000000466,1);
INSERT INTO rel_clientes_transportistas VALUES (0000000410,5);
INSERT INTO rel_clientes_transportistas VALUES (0000111429,5);
INSERT INTO rel_clientes_transportistas VALUES (0000000335,5);
INSERT INTO rel_clientes_transportistas VALUES (0000015485,5);
INSERT INTO rel_clientes_transportistas VALUES (0000111782,2);
INSERT INTO rel_clientes_transportistas VALUES (0000111761,5);
INSERT INTO rel_clientes_transportistas VALUES (0000111454,8);
INSERT INTO rel_clientes_transportistas VALUES (0000111532,7);
INSERT INTO rel_clientes_transportistas VALUES (0000000715,8);
INSERT INTO rel_clientes_transportistas VALUES (0000111578,7);
INSERT INTO rel_clientes_transportistas VALUES (0000000411,5);
INSERT INTO rel_clientes_transportistas VALUES (0000111552,7);
INSERT INTO rel_clientes_transportistas VALUES (0000000071,1);
INSERT INTO rel_clientes_transportistas VALUES (0000000649,5);
INSERT INTO rel_clientes_transportistas VALUES (0000000796,2);
INSERT INTO rel_clientes_transportistas VALUES (0000000395,2);
INSERT INTO rel_clientes_transportistas VALUES (0000000048,7);
INSERT INTO rel_clientes_transportistas VALUES (0000111563,2);
INSERT INTO rel_clientes_transportistas VALUES (0000111426,5);
INSERT INTO rel_clientes_transportistas VALUES (0000000648,4);
INSERT INTO rel_clientes_transportistas VALUES (0000000027,5);
INSERT INTO rel_clientes_transportistas VALUES (0000111783,2);
INSERT INTO rel_clientes_transportistas VALUES (0000013509,5);
INSERT INTO rel_clientes_transportistas VALUES (0000000035,5);
INSERT INTO rel_clientes_transportistas VALUES (0000111439,5);
INSERT INTO rel_clientes_transportistas VALUES (0000000495,2);
INSERT INTO rel_clientes_transportistas VALUES (0000013787,1);
INSERT INTO rel_clientes_transportistas VALUES (0000111352,2);
INSERT INTO rel_clientes_transportistas VALUES (0000000196,5);
INSERT INTO rel_clientes_transportistas VALUES (0000111609,5);
INSERT INTO rel_clientes_transportistas VALUES (0000000519,7);

DROP TABLE usuarios;
CREATE TABLE "usuarios" (
	"usuario"	VARCHAR(12),
	"claveEncriptada"	VARCHAR(100) NOT NULL,
	"idTransportista"	INTEGER,
	"idCliente"	INTEGER,
	"idRol"	INTEGER NOT NULL,
	"ultimoLogin"	REAL,
	"idOrganization"	INTEGER NOT NULL,
	PRIMARY KEY("usuario")
);
INSERT INTO usuarios VALUES ("Admin","3b612c75a7b5048a435fb6ec81e52ff92d6d795a8b5a9c17070f6a63c97a53b2",NULL,NULL,1,NULL,1);
INSERT INTO usuarios VALUES ("jperez","3b612c75a7b5048a435fb6ec81e52ff92d6d795a8b5a9c17070f6a63c97a53b2",1,NULL,2,JULIANDAY('now','localtime'),1);
INSERT INTO usuarios VALUES ("jgomez","3b612c75a7b5048a435fb6ec81e52ff92d6d795a8b5a9c17070f6a63c97a53b2",NULL,491,3,JULIANDAY('now','localtime'),1);

DROP TABLE estados;
CREATE TABLE "estados" (
	"idEstado"	INTEGER NOT NULL,
	"descEstado"	VARCHAR NOT NULL,
	PRIMARY KEY("idEstado")
);
INSERT INTO estados VALUES (1,"Ingresado");
INSERT INTO estados VALUES (2,"Entregado");

DROP TABLE envios;
CREATE TABLE "envios" (
	"idEnvio"	INTEGER NOT NULL,
	"idCliente"	INTEGER NOT NULL,
	"idTransportista"	INTEGER,
	"fechaCarga"	REAL NOT NULL,
	"fechaEnvio"	REAL,
	"idEstado"	INTEGER NOT NULL,
	"geoLatitud"	NUMERIC(6, 3),
	"geoLongitud"	NUMERIC(6, 3),
	"idOrganization"	INTEGER NOT NULL,
	PRIMARY KEY("idEnvio" AUTOINCREMENT)
);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,2,'0000014445',JULIANDAY('now','-1 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,2,'0000015316',JULIANDAY('now','-3 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,2,'0000011395',JULIANDAY('now','-3 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,4,'0000111438',JULIANDAY('now','-2 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,5,'0000111829',JULIANDAY('now','-4 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,6,'0000111684',JULIANDAY('now','-10 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,7,'0000000749',JULIANDAY('now','+15 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,1,'0000111456',JULIANDAY('now','+3 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,8,'0000000332',JULIANDAY('now','-1 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,4,'0000000720',JULIANDAY('now','-3 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,2,'0000015194',JULIANDAY('now','-3 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,6,'0000000647',JULIANDAY('now','-2 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,7,'0000111286',JULIANDAY('now','-4 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,5,'0000000043',JULIANDAY('now','-10 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,5,'0000000467',JULIANDAY('now','+15 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,5,'0000111644',JULIANDAY('now','+3 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,7,'0000000749',JULIANDAY('now','-1 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,1,'0000014445',JULIANDAY('now','-3 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,6,'0000111684',JULIANDAY('now','-3 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,2,'0000000510',JULIANDAY('now','-2 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,2,'0000000510',JULIANDAY('now','-4 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,5,'0000111644',JULIANDAY('now','-10 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,5,'0000000002',JULIANDAY('now','+15 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,2,'0000015194',JULIANDAY('now','+3 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,1,'0000014445',JULIANDAY('now','-10 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,2,'0000015316',JULIANDAY('now','-20 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,2'0000011395',JULIANDAY('now','-30 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,4,'0000111438',JULIANDAY('now','-20 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,5,'0000111829',JULIANDAY('now','-40 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,6,'0000111684',JULIANDAY('now','-100 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,7,'0000000749',JULIANDAY('now','+20 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,1,'0000111456',JULIANDAY('now','+30 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,8,'0000000332',JULIANDAY('now','-10 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,4,'0000000720',JULIANDAY('now','-30 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,2,'0000015194',JULIANDAY('now','-30 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,6,'0000000647',JULIANDAY('now','-20 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,7,'0000111286',JULIANDAY('now','-40 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,5,'0000000043',JULIANDAY('now','-100 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,5,'0000000467',JULIANDAY('now','+80 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,5,'0000111644',JULIANDAY('now','+30 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,7,'0000000749',JULIANDAY('now','-10 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,1,'0000014445',JULIANDAY('now','-30 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,6,'0000111684',JULIANDAY('now','-30 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,2,'0000000510',JULIANDAY('now','-20 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,2,'0000000510',JULIANDAY('now','-40 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,5,'0000111644',JULIANDAY('now','-100 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,5,'0000000002',JULIANDAY('now','+150 day','localtime'), NULL,1,NULL,NULL,1);
INSERT INTO envios (idEnvio, idTransportista, idCliente, fechaCarga, fechaEnvio, idEstado, geoLatitud, geoLongitud, idOrganization) VALUES (NULL,3,'0000015194',JULIANDAY('now','+30 day','localtime'), NULL,1,NULL,NULL,1);


DROP TABLE versiones;
CREATE TABLE "versiones" (
	"componente"	VARCHAR NOT NULL,
	"version"	VARCHAR NOT NULL
);
INSERT INTO versiones VALUES ('ApiLogistica','1.0.0');

CREATE TABLE "mensajes" (
	"idMensaje"	INTEGER NOT NULL,
	"descMensaje"	TEXT NOT NULL,
	"idTransportista"	TEXT,
	"idCliente"	TEXT,
	"fecDesde"	REAL,
	"fecHasta"	REAL,
	"fecLeido"	REAL,
	PRIMARY KEY("idMensaje" AUTOINCREMENT)
);
INSERT INTO mensajes VALUES (NULL,'Prueba Todos Clientes',NULL,'*',JULIANDAY('now','-30 day','localtime'),JULIANDAY('now','+60 day','localtime'),NULL)
INSERT INTO mensajes VALUES (NULL,'Prueba Todos Transportistas','*',NULL,JULIANDAY('now','-30 day','localtime'),JULIANDAY('now','+60 day','localtime'),NULL)