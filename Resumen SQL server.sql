USE data_23_12_2023;

-- Muestra todas las bases de datos
SELECT * FROM sys.databases;

-- Muestra todas las tablas
SELECT * FROM sys.tables;

-- Descripcion de las columnas de una tabla
SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'COA_31122020';

-- Detalles de la tabla
EXEC sp_help tabla_importada;

-- Cambiar el nombre del DB
ALTER DATABASE data_24_12_2023 modify name = data_23_12_2023;
RENAME DATABASE data_23_12_2023 TO nombre_nuevo;

-- Tipo de variables
char --alamcena tipo de datos de ancho fijo
varchar --almacena tipo de datos alfanumericos de ancho variable
text -- alamacena tipo de datos texto
nchar -- almacena tipo de datos de ancho fijo
nvarchar -- almacena tipo de datos alfanumericos de ancho variable
bit -- alamcena valores de 1 y 0
int -- almacena valores entre -2,147,483,648 y 2,147,483,647
bigint -- almacena valores entre -9,223,373,036,854,,775,808 y 9,223,373,036,854,,775,807
decimal -- almacena valores entre -10^38 + 1 hasta 10^38 -1
money -- almacena valores entre -10^38 + 1 hasta 10^38 -1
float -- almacena valores entre -1.79E+308 hasta 1.79E+308
numeric -- es lo mismo que decimal

-- Creacion de una base de datos
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'curso_sql')
    CREATE DATABASE curso_sql;

-- Creacion de una tabla
CREATE TABLE tabla_importada(
	nombre varchar(50),
	edad int,
	sueldo decimal(19,2)
);

-- Importacion de datos
BULK INSERT
	tabla_importada
FROM
	'C:\Users\luis_\Desktop\Prueba.csv' --con extension xslx no funciona pero si con csv
WITH (
    FIRSTROW = 2,  -- Si hay encabezados en la primera fila
    FIELDTERMINATOR = ';',  -- Delimitador de campos
    ROWTERMINATOR = '\n'  -- Delimitador de filas
);

-- Insertar datos a otra tabla
INSERT INTO tabla2(nombre, sueldo) SELECT nombre, sueldo FROM tabla_importada;

-- Trabajado con INSERT
INSERT INTO dbo.tabla_importada(nombre, edad, sueldo) VALUES ('nombre2', 19, 1450);
INSERT INTO dbo.tabla_importada VALUES ('nombre3', 21, 1850);
INSERT INTO dbo.tabla_importada(nombre, sueldo) VALUES ('nombre4', 1900);

-- Trabajando con SELECT
SELECT * FROM tabla_importada;
SELECT nombre, edad FROM tabla_importada;

-- Trabajando con la condicion WHERE
SELECT nombre, edad FROM tabla_importada WHERE nombre = 'luis';
SELECT nombre, edad FROM tabla_importada WHERE edad IN(18,25);
SELECT nombre, edad FROM tabla_importada WHERE edad IS NOT NULL;

-- Elimina toda las filas de la tabla
TRUNCATE TABLE nombre_tabla;

-- Trabajando con DELETE
DELETE FROM tabla_importada; -- Elimina toda las filas de la tabla
DELETE FROM tabla_importada WHERE nombre ='luis'; -- Es importante el WHERE para no eliminar toda la tabla

-- Trabajando con UPDATE
UPDATE tabla_importada SET edad = 33; -- Actualiza toda la tabla
UPDATE tabla_importada SET edad = 28, sueldo = 1600 WHERE nombre ='luis'; -- Es importante el WHERE

-- Eliminacion de tablas
DROP TABLE prueba_csv;

-- Eliminacion de base de datos
DROP DATABASE  data_prueba;

-- Cambia de nombre a una tabla
EXEC sp_rename 'tabla_antigua', 'tabla_nueva'; 

-- Cambiar el nombre de un campo
EXEC sp_rename 'tabla.campo_antiguo', 'tabla.campo_nuevo'; 

-- Agregando un campo ADD
ALTER TABLE tabla_importada ADD precio_1 int, precio_2 int;

-- Eliminando un campo DROP
ALTER TABLE tabla_importada DROP COLUMN precio_1, precio_2;  -- En MySQL no es necesario poner COLUMN

-- Seleccion de los 2 primeros datos
SELECT TOP 2 * FROM tabla_importada;
-- Seleccion del 50% de los datos
SELECT TOP 50 PERCENT * FROM tabla_importada;

CREATE TABLE tabla_prueba(
	id varchar(20) not null, -- al utilizar NOT NULL el campo no puede estar vacio
	nombre varchar(50) null, -- no es necesario poner NULLL para que el campo pueda estar vacio
	edad int,
	sueldo decimal(19,2)
);

-- CONSTRAINTS - PRIMARY KEY
CREATE TABLE tabla_prueba(
	id varchar(20) primary key,
	nombre varchar(50),
	edad int,
	sueldo decimal(19,2)
	-- primary key (id) --otra forma de definir primary key
	-- constraint PK_enlace_persona primary key (id) --otra forma de definir primary key
);
-- Si ya se creo la tabla sin primary key (id tiene que ser not null)
ALTER TABLE tabla_prueba 
ADD constraint PL_enlace primary key (id);
-- Borrar la llave primaria
ALTER TABLE tabla_prueba DROP constraint PK_enlace;

-- CONSTRAINTS - UNIQUE
CREATE TABLE tabla_prueba(
	id varchar(20) not null unique,
	nombre varchar(50),
	edad int,
	sueldo decimal(19,2)
	-- constraint UQ_enlace_persona unique(id) --otra forma
);
-- Si ya se creo la tabla sin primary key (id tiene que ser not null)
ALTER TABLE tabla_prueba 
ADD constraint UQ_enlace unique(id);
-- Borrar el constraint
ALTER TABLE tabla_prueba DROP constraint UQ_enlace;

-- CONSTRAINTS - CHECK
CREATE TABLE tabla_prueba(
	id varchar(20) not null,
	nombre varchar(50),
	edad int CHECK (edad>=18),
	sueldo decimal(19,2)
	-- CHECK (edad>=18) -- Otra forma
	-- CONSTRAINT check_edad CHECK(edad>=18) -- Otra forma
);
-- Si ya se creo la tabla
ALTER TABLE tabla_prueba 
ADD CONSTRAINT check_edad CHECK(edad>=18);
-- Borrar el constraint
ALTER TABLE tabla_prueba DROP CONSTRAINT check_edad;

-- CONSTRAINTS - DEFAULT
CREATE TABLE tabla_prueba(
	id varchar(20) not null,
	nombre varchar(50) DEFAULT 'SIN NOMBRE',
	--nombre varchar(50) CONSTRAINT DF_nombre DEFAULT 'sin nombre', -- Otra forma
	edad int,
	sueldo decimal(19,2)
);
-- Si ya se creo la tabla
ALTER TABLE tabla_prueba 
ADD CONSTRAINT DF_nombre DEFAULT 'Sin nombre' FOR nombre;
-- Borrar el constraint
ALTER TABLE tabla_prueba DROP CONSTRAINT DF_nombre;
-- Insertar un valor por default
INSERT INTO tabla_prueba VALUES (1,DEFAULT,20,1600)

-- CONTRAINTS IDENTITY
-- Crea un valor unico que aumenta con cada fila
CREATE TABLE libros(
	codigo int IDENTITY(10,2), -- comienza con el valor 10 y luego continua de 2 en 2
	titulo varchar(60) not null,
	autor varchar(60) not null
);
-- Ver el valor inicial
SELECT IDENT_SEED('libros');
-- Ver el incremento
SELECT IDENT_INCR('libros');
-- Permite insertar valores en el identity
SET IDENTITY_INSERT libros ON;

-- CONSTRAINTS - FOREIGN KEY
CREATE TABLE clientes(
	id_cliente int,
	nombre varchar(20) not null,
	apellido varchar(30) not null,
	edad int not null,
	constraint PK_clientes primary key (id_cliente)
);
CREATE TABLE ordenes(
	id_orden int not null,
	articulo varchar(50) not null,
	id_cliente int
	constraint FK_ordenes_clientes foreign key references clientes(id_cliente)
);
-- otra forma (la mejor)
CREATE TABLE ordenes(
	id_orden int not null,
	articulo varchar(50) not null,
	id_cliente int
	constraint FK_ordenes_clientes foreign key (id_cliente) references clientes(id_cliente) -- el segundo id_cliente es de la tabla cliente
);

DROP TABLE clientes;


/*
Comentarios para mas de una linea
*/

-- Vistas
CREATE VIEW clientes_nacionales
AS
SELECT * FROM clientes WHERE edad < 25;

-- Indices
CREATE CLUSTERED INDEX I_idempleado --nombre del indice
ON tabla_empleados(columna_id);
CREATE NONCLUSTERED INDEX I_edad_empleado --nombre del indice
ON tabla_empleados(columna_edad);
-- Cambia el nombre del indice
EXEC sp_rename 'tabla_empleado.I_idempleado', 'I_id', 'INDEX';
-- Eliminar indice
DROP INDEX I_id ON tabla_empleado;

-- DISTINCT 
SELECT DISTINCT pais FROM clientes;

-- ALIAS Y CONCATENACION
SELECT nombre + ' ' + apellido + CAST(edad AS VARCHAR(2)) nombre_apellido_edad FROM empleados;

-- ESQUEMAS
CREATE SCHEMA ventas;
CREATE TABLE ventas.cliente(
 idclientes int
);

-- ORDER BY
SELECT * FROM Empleados ORDER BY Nombre DESC;

-- FUNCIONES DE AGRUPACION: COUNT, SUM, AVG
SELECT COUNT(*) FROM Empleados; -- Hace un conteo de registros
SELECT COUNT(DepartamentoID) FROM Empleados;

-- OPERADORES: AND, OR Y NOT 
SELECT * FROM clientes
WHERE pais = 'Italia' AND ciudad IN ('Roma','Venecia') AND NOT pais = 'Canada';

-- BETWEEN
SELECT * FROM empleados WHERE id_empleado IN(1,3,5,7);
SELECT * FROM empleados WHERE id_empleado BETWEEN 1 AND 7 OR cantidad BETWEEN 1 AND 3;
SELECT * FROM empleados WHERE pais BETWEEN 'Alemania' AND 'Mexico';
SELECT * FROM empleados WHERE fecha BETWEEN '1999-06-01' AND '2005-06-01';

-- OPERADORES: LIKE Y NOT LIKE
SELECT * FROM clientes
WHERE nombre LIKE 'A%'; -- Nombres que comiencen con a
SELECT * FROM clientes
WHERE nombre LIKE '%A'; -- Nombres que acaben en a 
SELECT * FROM clientes
WHERE nombre LIKE '%A%'; -- Nombres que tengan una a
SELECT * FROM clientes
WHERE nombre LIKE '__A%'; -- ignora el primer y segundo caracter
SELECT * FROM clientes
WHERE nombre LIKE 'a%o'; -- Nombre que comienza con a y termina en o
SELECT * FROM clientes
WHERE nombre NOT LIKE '%A'; -- Nombres que no terminan en A

-- INNER JOIN, LEFT JOIN, RIGHT JOIN, FULL JOIN
-- https://youtu.be/a4sMtXZjmHk?si=O4Lw0_hkq8Vqg_US

-- CLAUSULA UNION, se debe terner el mismo numero de columnas
SELECT columna1, columna2 FROM tabla1
UNION
SELECT columna1, columna2 FROM tabla2;
-- muestra los datos dublicados UNION ALL
SELECT columna1, columna2 FROM tabla1
UNION ALL
SELECT columna1, columna2 FROM tabla2;

-- GROUP BY
SELECT AVG(idcliente) AS promedio, pais
FROM clientes
GROUP BY pais ORDER BY promedio DESC;

-- HAVING
SELECT producto, SUM(cantidad) AS cantidad_total, AVG(precio_unitario) AS precio_promedio
FROM ventas
WHERE precio_unitario > 10
GROUP BY producto
HAVING SUM(cantidad) > 1000;

-- SUBCONSULTAS
-- Reglas:
-- * Las subconsuiltas deben ir entre parentesis
-- * No pueden contener IN, ANY, ALL y EXISTS
-- * No pueden contener BETWEEN ni LIKE ni ORDER BY
-- Ejemplo 1: Cuales empleados ganan mas o igual al salario promedio
SELECT id_empleado, nombre, apellido, sueldo
FROM empleados WHERE sueldo >= (SELECT AVG(sueldo) FROM empleados);
-- Ejemplo 2:  Buscar todos los nombre de clientes con idcliente de Mexico
SELECT nombre, ciudad FROM clientes
WHERE idcliente = ANY(SELECT idcliente FROM clientes
						WHERE pais = 'Mexico');
-- Ejemplo 3: Cuales clientes han comprado lapices
SELECT cliente, numero, fecha FROM facturas f
WHERE NOT EXISTS (SELECT * FROM detalles d
					WHERE f.numero = d.numerofactura
					AND d.articulo = 'Lapiz');

-- ISNULL, COALESCE
-- reemplaza los valores NULL por '0'
SELECT nombre, precio_unidad, ISNULL(vendidos, 0) FROM productos;
SELECT nombre, precio_unidad, COALESCE(vendidos, 0) FROM productos;

-- CASE
-- Ejemplo 1
SELECT nombre, cantidad,
CASE
	WHEN cantidad > 30 THEN 'Articulo con sobre existencia'
	WHEN cantidad < 10 THEN 'Se debe realizar pedido'
	ELSE 'Existencia normal'
END AS Inventario
FROM articulos;
-- Ejemplo 2
SELECT nombre, ciudad, pais FROM clientes
ORDER BY
(CASE
	WHEN ciudad IS NULL THEN pais
	ELSE ciudad
END);

-- FUNCIONES MATEMATICAS
SELECT CEILING($321.19); -- funcion para maximo entero (funcion con datos de moneda)
SELECT FLOOR(321.12); -- funcion para eliminar los decimales
SELECT ROUND(123.1245, 4); -- funcion para rendondear
SELECT POWER(4,2); -- funcion para potencia (a^b)
SELECT RAND(); -- funcion para valores aleatorios
SELECT SIN(PI()/2), TAN(PI()/4); -- funciones trignonometricas
SELECT SQRT(81); -- funcion para raiz cuadrada

-- FUNCIONES STRING
SELECT nombre + CHAR(65);
SELECT CONCAT('Hola ', nombre,' bienvenido');
SELECT LEN('SQL server'); -- Funcion para saber el numero de caracteres incluyendo espacios
SELECT LOWER('SQL server'); -- Convierte todo a minisculas
SELECT UPPER('SQL server'); -- Convierte todo a mayusculas
SELECT LEFT('hola a todos',1); -- Trae la cantidad de letras de izquierda
SELECT RIGHT('hola a todos',1); -- Trae la cantidad de letras de derecha
SELECT STUFF('hola a todos', 3, 5, 'amigos'); -- Reemplaza un rango de caracteres determinados
-- Convierte la primera letra en mayuscula
SELECT CONCAT(UPPER(LEFT('hola a todos',1)), LOWER(RIGHT('hola a todos', RIGHT('hola a todos')-1)));
SELECT ltrim('  hola mundo'); -- Elimina espacios de lado izquierdo
SELECT rtrim('hola mundo   '); -- Elimina espacios de lado derecho
SELECT trim('  hola mundo  '); -- Elimina espacios de lado izquierdo y derecho
SELECT REPLACE('hola mundo', 'h', 'H'); -- Reemplaza caracteres en los registros
SELECT TRANSLATE('abcdef', 'ab', '00'); -- Reemplaza mas de un caracter
SELECT TRANSLATE('[123.4,72.3]','[,]','( )') AS punto;
SELECT REPLICATE('hola',6); -- Reeplica n veces los caracteres
SELECT REVERSE('SQLserver'); -- Devuelve la cadena de caracteres al reves
SELECT REVERSE(654321);

-- FUNCIONES DATE  
SELECT getdate() AS fecha; -- Se obtiene la fecha actual
SELECT dateadd(DAY, 2, getdate()); -- Agrega una cantidad de dias
SELECT dateadd(MONTH, 2, getdate()); -- Agrega una cantidad de meses
SELECT dateadd(YEAR, -2, getdate()); -- Agrega una cantidad de años
SELECT dateadd(HOUR, -2, getdate()); -- Agrega una cantidad de horas
SELECT dateadd(MINUTE, -2, getdate()); -- Agrega una cantidad de dias

SELECT * FROM facturas
WHERE fecha BETWEEN '2018-01-01' AND dateadd(YEAR, 1, '2018-01-01')

SELECT DATENAME(MONTH, GETDATE()) AS MES; -- ver el nombre del mes
SET LANGUAGE SPANISH; -- Esablecer idioma para la fecha
SELECT DATEPART(MONTH, GETDATE()) AS MES; -- Ver mes en numero
SELECT DATENAME(DAY, GETDATE()) AS MES;
SELECT DATENAME(WEEKDAY, GETDATE()) AS MES; -- ver el nombre del dia

-- TRANSACT-SQL, ROW_NUMBER(), FIRST_VALUE()
SELECT * FROM (SELECT row_number() over(ORDER BY a.columna1 DESC) AS contador,
a.id, a.columna1 FROM ventas AS a) AS a
WHERE a.contador = 1;

SELECT * FROM ventas a
WHERE a.idvendedor = (
					SELECT DISTINCT FIRST_VALUE(a.idvendedor) 
					over(ORDER BY a.columna1 DESC) AS contador
					FROM ventas a);

-- CONTROL DE FLUJO
DECLARE
	--Variable1
	--Variable2
	--Variable3
BEGIN
--Codigo principal
	if else
	return
	waitfor
	while
	for
	do while
	case
-- control de eventualidades
	continue
	break
END;

-- T-SQL, IF EXIST() - ELSE
IF EXISTS (SELECT * FROM articulos WHERE cantidad = 0)
	(SELECT nombre, precio, cantidad
	FROM articulos WHERE cantidad = 0)
ELSE
	SELECT 'No hay articulos en 0' AS resultado;

SELECT * FROM sys.objects WHERE name = 'prueba';

IF OBJECT_ID('prueba') IS NULL
	DROP TABLE prueba;

-- T-SQL VARIABLES
DECLARE
	@id_valor int,
	@nombre VARCHAR(20),
	@telefono numeric(10),
	@fecha_nac date,
	@activo bit;
BEGIN
	SET @id_valor = 40;
	SET @nombre = 'Luis';
	SET @telefono = 123456789;
	SET @fecha_nac = '1980/10/01';
	SET @activo = 'false';
	SELECT @id_valor, @nombre;
END;

DECLARE
	@patron VARCHAR(20);
BEGIN
	SET @patron = '%Lap%';
	SELECT * FROM articulos WHERE nombre LIKE @patron;
END;

DECLARE
	@mayorprecio DECIMAL(6,2);
BEGIN
	SELECT @mayorprecio = MAX(precio) FROM articulos;
	SELECT * FROM articulos WHERE precio = @mayorprecio;
END;

-- VARIABLES TIPO TABLA
-- Se tiene que ejecutar todo a la vez
DECLARE
	@tabla1 table(
		id INT,
		nombre VARCHAR(20),
		telefono NUMERIC(20)
	);
	INSERT INTO @tabla1 VALUES (1,'Jose',123456);
	SELECT * FROM @tabla1;

-- PROCEDIMIENTOS ALMACENADOS (STORE PROCEDURE)
-- Hay 4 prefijos:
-- * sp_ (en master)
-- * locales (del usuario)
-- * temporales (#)
-- * globales (##)
CREATE PROC p_existencia
AS
SELECT * FROM articulos WHERE cantidad < 20;

EXEC p_existencia; -- Ejecutar el procesimiento

CREATE PROCEDURE p_bonificacion
AS
BEGIN 
	IF EXISTS(SELECT * FROM empleados WHERE cantidad_hijos > 3)
		BEGIN
			UPDATE empleados SET sueldo = sueldo*0.20;
			PRINT 'Se ha aplicado la bonificacion';
		END
	ELSE
		BEGIN
			PRINT 'No hay empleados con mas de 3 hijos';
		END
END;

-- https://youtu.be/8sCrjt5e2Yk?si=waJrPohnD1fh5CxC


