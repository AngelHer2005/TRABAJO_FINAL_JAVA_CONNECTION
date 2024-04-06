CREATE DATABASE PROYECTO_BUENSABOR;
GO
USE PROYECTO_BUENSABOR;
GO

--CREAR MI TABLA CLIENTE

CREATE TABLE FACTURA(
ID_FAC CHAR(4) PRIMARY KEY CHECK(ID_FAC LIKE'F[0-9][0-9][0-9]'),
FECHA_EMI DATE NOT NULL DEFAULT(GETDATE()),
TOTAL MONEY NOT NULL,
DESCRIPCION VARCHAR(MAX)
)
GO

CREATE TABLE BOLETA(
ID_BOL CHAR(4) PRIMARY KEY CHECK(ID_BOL LIKE'B[0-9][0-9][0-9]'),
FECHA_EMI DATE NOT NULL DEFAULT(GETDATE()),
TOTAL MONEY NOT NULL,
DESCRIPCION VARCHAR(MAX)
)
GO

CREATE TABLE COMPROBANTE(
ID_COM CHAR(5) PRIMARY KEY CHECK(ID_COM LIKE'CO[0-9][0-9][0-9]'),
CONSUMO VARCHAR(40) NOT NULL,
MET_PAGO VARCHAR(20) NOT NULL,
ID_FAC CHAR(4) NOT NULL FOREIGN KEY(ID_FAC) REFERENCES FACTURA(ID_FAC),
ID_BOL CHAR(4) NOT NULL FOREIGN KEY(ID_BOL) REFERENCES BOLETA(ID_BOL)
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
TELEFONO CHAR(9) UNIQUE NULL CHECK(TELEFONO LIKE'[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
ID_COM CHAR(5) NOT NULL FOREIGN KEY(ID_COM) REFERENCES COMPROBANTE(ID_COM),
ID_CAR CHAR(5) NOT NULL FOREIGN KEY(ID_CAR) REFERENCES CARGO(ID_CAR)
)
GO

CREATE TABLE CLIENTE(
ID_CLI CHAR(4) PRIMARY KEY CHECK(ID_CLI LIKE'C[0-9][0-9][0-9]'),
NOMBRE VARCHAR(30) NOT NULL,
APELLIDO VARCHAR(30) NOT NULL,
EDAD INT NOT NULL,
TELEFONO CHAR(9) UNIQUE NULL CHECK(TELEFONO LIKE'[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
DIRECCION VARCHAR(50),
DNI CHAR(8) UNIQUE NOT NULL CHECK(DNI LIKE'[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
ID_COM CHAR(5) NOT NULL FOREIGN KEY(ID_COM) REFERENCES COMPROBANTE(ID_COM)
)
GO