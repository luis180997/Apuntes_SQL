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

DROP TABLE clientes;


/*
Comentarios para mas de una linea
*/


CREATE TABLE Empleados (
    ID INT PRIMARY KEY,
    Nombre VARCHAR(50),
    Departamento VARCHAR(50),
    Salario DECIMAL(10, 2)
);

INSERT INTO Empleados VALUES (1,'luis', 'TI', 1500);
INSERT INTO Empleados VALUES (2,'manuel', 'TI', 1800);
INSERT INTO Empleados VALUES (3,'alfredo', 'comercial', 2500);
INSERT INTO Empleados VALUES (4,'juan', 'ventas', 1400);
INSERT INTO Empleados VALUES (5,'andrea', 'ventas', 1000);
INSERT INTO Empleados VALUES (6,'jose', 'TI', 2000);

SELECT * FROM Empleados;

SELECT Departamento, COUNT(*) AS Cantidad 
FROM Empleados
GROUP BY Departamento
ORDER BY Cantidad  DESC;

SELECT Nombre, Salario
FROM Empleados
WHERE Salario > (SELECT AVG(Salario) FROM Empleados);

SELECT Nombre, Salario
FROM Empleados
GROUP BY Nombre
HAVING Salario > AVG(Salario);


CREATE TABLE Empleados (
    ID INT PRIMARY KEY,
    Nombre VARCHAR(50),
    DepartamentoID INT,
    Salario DECIMAL(10, 2)
);

CREATE TABLE Departamentos (
    ID INT PRIMARY KEY,
    Nombre VARCHAR(50)
);

INSERT INTO Departamentos (ID, Nombre)
VALUES
(1, 'Ventas'),
(2, 'TI'),
(3, 'Recursos Humanos');

INSERT INTO Empleados (ID, Nombre, DepartamentoID, Salario)
VALUES
(1, 'Juan Pérez', 1, 60000.00),
(2, 'María González', 1, 55000.00),
(3, 'Carlos Rodríguez', 2, 70000.00),
(4, 'Ana López', 2, 75000.00),
(5, 'José Martínez', 3, 50000.00),
(6, 'Laura Sánchez', 3, 48000.00),
(7, 'Pedro Ramírez', 1, 62000.00),
(8, 'Sofía García', 2, 72000.00);

SELECT * FROM Departamentos;
SELECT * FROM Empleados;

SELECT * FROM Empleados AS E
JOIN Departamentos AS D ON E.DepartamentoID = D.ID;

-- pregunta 2
SELECT Nombre, Salario FROM Empleados
WHERE Salario > (SELECT MAX(E.Salario) FROM Empleados AS E 
					JOIN Departamentos AS D ON E.DepartamentoID = D.ID 
					WHERE D.Nombre = 'Ventas');

SELECT E.Nombre FROM Empleados E
WHERE E.Salario > ALL (SELECT Salario FROM Empleados WHERE DepartamentoID = (SELECT ID FROM Departamentos WHERE Nombre = 'Ventas'));

-- pregunta 3
SELECT D.Nombre, (MAX(E.Salario) - MIN(E.Salario)) AS Diferencia
FROM Departamentos AS D
JOIN Empleados AS E
ON E.DepartamentoID = D.ID 
GROUP BY D.Nombre;

-- pregunta 4
ALTER TABLE Departamentos
ADD CONSTRAINT UQ_departamento UNIQUE (Nombre);

-- pregunta 5
SELECT D.Nombre
FROM Departamentos AS D
JOIN Empleados AS E
ON D.ID = E.DepartamentoID
WHERE E.Salario > (SELECT Salario FROM )
