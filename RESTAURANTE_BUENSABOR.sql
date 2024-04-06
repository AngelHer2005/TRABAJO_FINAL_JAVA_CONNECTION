CREATE DATABASE PROYECTO_BUENSABOR;
GO
USE PROYECTO_BUENSABOR;
GO

--CREAR MI TABLA CLIENTE

CREATE TABLE FACTURA(
ID_FAC CHAR(4) PRIMARY KEY CHECK(ID_FAC LIKE'F[0-9][0-9][0-9]'),
CONSUMO MONEY NOT NULL,
IMPUESTO MONEY NOT NULL,
TOTAL MONEY NOT NULL,
SERVICIO MONEY NOT NULL,
TOTAL_GENERAL MONEY NOT NULL
)
GO

CREATE TABLE BOLETA(
ID_BOL CHAR(4) PRIMARY KEY CHECK(ID_BOL LIKE'B[0-9][0-9][0-9]'),
TOTAL MONEY NOT NULL,
SERVICIO MONEY NOT NULL,
TOTAL_GENERAL MONEY NOT NULL
)
GO

CREATE TABLE CARGO(
ID_CAR CHAR(5) PRIMARY KEY CHECK(ID_CAR LIKE'CA[0-9][0-9][0-9]'),
CARGO VARCHAR(20) NOT NULL,
SALARIO MONEY NOT NULL,
DESCRIPCION VARCHAR(MAX) NOT NULL
)
GO

CREATE TABLE EMPLEADO(
ID_EMP CHAR(4) PRIMARY KEY CHECK(ID_EMP LIKE'E[0-9][0-9][0-9]'),
NOMBRE VARCHAR(30) NOT NULL,
DNI CHAR(8) UNIQUE NOT NULL CHECK(DNI LIKE'[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
DIRECCION VARCHAR(50),
EDAD INT NOT NULL,
TELEFONO CHAR(11) UNIQUE NULL CHECK(TELEFONO LIKE'[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9]'),
ID_CAR CHAR(5) NOT NULL FOREIGN KEY(ID_CAR) REFERENCES CARGO(ID_CAR)
)
GO

CREATE TABLE COMPROBANTE(
ID_COM CHAR(5) PRIMARY KEY CHECK(ID_COM LIKE'CO[0-9][0-9][0-9]'),
MET_PAGO VARCHAR(20) NOT NULL,
ID_FAC CHAR(4) NULL FOREIGN KEY(ID_FAC) REFERENCES FACTURA(ID_FAC),
ID_BOL CHAR(4) NULL FOREIGN KEY(ID_BOL) REFERENCES BOLETA(ID_BOL),
ID_EMP CHAR(4) NOT NULL FOREIGN KEY(ID_EMP) REFERENCES EMPLEADO(ID_EMP)
)
GO

CREATE TABLE CLIENTE(
ID_CLI CHAR(4) PRIMARY KEY CHECK(ID_CLI LIKE'C[0-9][0-9][0-9]'),
NOMBRE VARCHAR(30) NOT NULL,
APELLIDO VARCHAR(30) NOT NULL,
EDAD INT NOT NULL,
TELEFONO CHAR(11) UNIQUE NULL CHECK(TELEFONO LIKE'[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9]'),
DIRECCION VARCHAR(50),
DNI CHAR(8) UNIQUE NOT NULL CHECK(DNI LIKE'[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
ID_COM CHAR(5) NOT NULL FOREIGN KEY(ID_COM) REFERENCES COMPROBANTE(ID_COM)
)
GO

-- INSERTAR REGISTROS

-- FACTURA
DECLARE @contador INT = 1
WHILE @contador <= 5
BEGIN
	DECLARE @total INT = RAND() * 100
    INSERT INTO FACTURA 
    VALUES ('F0' + RIGHT('0' + CAST(@contador AS VARCHAR(3)), 2), ROUND(@total/1.18,2), @total-ROUND(@total/1.18,2), @total, ROUND(@total*0.10,2), @total + ROUND(@total*1.10,2))
    SET @contador = @contador + 1
END
GO

-- BOLETA
DECLARE @contador INT = 1
WHILE @contador <= 5
BEGIN
	DECLARE @total INT = RAND() * 100
    INSERT INTO BOLETA
    VALUES ('B0' + RIGHT('0' + CAST(@contador AS VARCHAR(3)), 2), @total, ROUND(@total*0.10,2), @total + ROUND(@total*0.10,2))
    SET @contador = @contador + 1
END
GO

-- CARGO
INSERT INTO CARGO VALUES('CA001', 'Camarero', 1200, 'Encargado de atender a los clientes en las mesas'),
						('CA002', 'Cajero', 1100, 'Encargado de gestionar el cobro de los pedidos'),
						('CA003', 'Limpieza', 1000, 'Encargado de mantener limpio el restaurante')
GO

-- EMPLEADO
INSERT INTO EMPLEADO VALUES('E001', 'Luis', '88323421', 'Av. Kong #132', 24, '993-321-237', 'CA002'),
						   ('E002', 'María', '34214213', 'Jr. Godzilla #521', 21, '906-521-342', 'CA001'),
						   ('E003', 'Raúl', '52213423', 'Av. Callao #4552', 30, '990-200-213', 'CA003'),
						   ('E004', 'Emmy', '76313232', 'Av. Selva #953', 20, '909-423-128', 'CA002')
GO

-- COMPROBANTE
INSERT INTO COMPROBANTE VALUES('CO001', 'TARJETA', 'F002', NULL, 'E003'),
							  ('CO002', 'TARJETA', 'F001', NULL, 'E001'),
							  ('CO003', 'EFECTIVO', 'F005', NULL, 'E001'),
							  ('CO004', 'TARJETA', NULL, 'B003', 'E003'),
							  ('CO005', 'TARJETA', NULL, 'B002', 'E003'),
							  ('CO006', 'TARJETA', 'F003', NULL, 'E001'),
							  ('CO007', 'EFECTIVO', NULL, 'B004', 'E001'),
							  ('CO008', 'EFECTIVO', NULL, 'B001', 'E003'),
							  ('CO009', 'TARJETA', NULL, 'B005', 'E003'),
							  ('CO010', 'EFECTIVO', 'F004', NULL, 'E001')
GO

-- CLIENTE
INSERT INTO CLIENTE VALUES('C001', 'Ángel Hernán Alberto', 'Patricio Arroyo', 18, '997-150-226', 'Callao, Av. Júpiter #185', '74307947', 'CO003'),
						  ('C002', 'Jared Julio', 'Galindo Davila', 18, '945-707-294', 'Rímac, Jr. Arandáz #1223', '60914823', 'CO007'),
						  ('C003', 'Francesco', 'Virgolini', 19, '966-421-421', 'Av. Pacasmayo #661', '66221345', 'CO005'),
						  ('C004', 'Carlos', 'Gómez Flores', 20, '900-312-532', 'Av. Paloma #251', '88040321', 'CO009'),
						  ('C005', 'Franyelys', 'Ramírez Tovar', 19, '993-652-672', 'Jr. Poo #561', '66121345', 'CO002'),
						  ('C006', 'Gabriela Ariana', 'Peña Valencia', 18, '996-632-992', 'Av. Ayacucho #732', '55313243', 'CO006'),
						  ('C007', 'Cristina', 'Rodríguez Palacios', 17, '983-677-003', 'Av. Perro #531', '66313232', 'CO001'),
						  ('C008', 'Mariafé', 'Zevallos Rojas', 18, '995-442-315', 'Av. Aguilar #585', '99742433', 'CO004'),
						  ('C009', 'Maria Fernanda', 'Rodas', 18, '923-621-532', 'Av. Salvador #21', '90741213', 'CO008'),
						  ('C010', 'Stive Dennis', 'Hinostroza Chavez', 18, '996-643-425', 'Av. Neptuno #62', '50923422', 'CO010')
GO					

ALTER AUTHORIZATION ON DATABASE::PROYECTO_BUENSABOR TO sa;
