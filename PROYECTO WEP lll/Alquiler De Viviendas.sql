-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3307
-- Tiempo de generación: 09-09-2024 a las 21:31:36
-- Versión del servidor: 11.5.0-MariaDB
-- Versión de PHP: 8.3.7

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- Crear tabla usuario
CREATE TABLE usuario (
    nro_documento VARCHAR(20) PRIMARY KEY,
    tipo_documento VARCHAR(20) NOT NULL,
    rol_usuario VARCHAR(20) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    telefono VARCHAR(15),
    fecha_nacimiento DATE,
    user_name VARCHAR(30) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    nacionalidad VARCHAR(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Insertar datos en la tabla usuario
INSERT INTO usuario (nro_documento, tipo_documento, rol_usuario, nombre, apellido, telefono, fecha_nacimiento, user_name, password, nacionalidad) VALUES 
    ('12345678', 'CI', 'inquilino', 'Juan', 'Perez', '123-456-7890', '2000-01-15', 'juanperez', 'hashed_password1', 'Argentina'),
    ('87654321', 'Pasaporte', 'propietario', 'Maria', 'Gonzalez', '098-765-4321', '1995-05-30', 'mariagonzalez', 'hashed_password2', 'España'),
    ('11223344', 'Licencia', 'inquilino', 'Carlos', 'Lopez', '321-654-9870', '1998-07-22', 'carloslopez', 'hashed_password3', 'Chile'),
    ('55667788', 'CI', 'propietario', 'Ana', 'Martinez', '789-123-4560', '1992-03-10', 'anamartinez', 'hashed_password4', 'México');

-- Crear tabla Vivienda
CREATE TABLE Vivienda (
    IdVivienda INT NOT NULL AUTO_INCREMENT,
    NroPuerta INT NOT NULL,
    Direccion VARCHAR(255) NOT NULL,
    TipoDeVivienda VARCHAR(50) NOT NULL,
    PrecioVivienda DECIMAL(10, 2) NOT NULL,
    Piso INT NOT NULL,
    NroDepartamento VARCHAR(10),
    Ciudad VARCHAR(50) NOT NULL,
    Estado VARCHAR(20) NOT NULL,
    Usuario_Propietario VARCHAR(20) NOT NULL,
    Descripcion TEXT,
    FolioReal VARCHAR(20) NOT NULL,
    NroDocumento VARCHAR(20) NOT NULL,
    PRIMARY KEY (IdVivienda),
    FOREIGN KEY (NroDocumento) REFERENCES usuario (nro_documento)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Insertar datos en la tabla Vivienda
INSERT INTO Vivienda (NroPuerta, Direccion, TipoDeVivienda, PrecioVivienda, Piso, NroDepartamento, Ciudad, Estado, Usuario_Propietario, Descripcion, FolioReal, NroDocumento) VALUES
(101, 'Calle Falsa 123', 'Apartamento', 50000.00, 3, '301', 'Ciudad A', 'Activo', '55667788', 'Apartamento amplio', 'FR123', '55667788'),  -- Propietario es Ana
(102, 'Av. Siempre 456', 'Casa', 75000.00, 1, '-', 'Ciudad B', 'Activo', '87654321', 'Casa familiar', 'FR124', '87654321'),  -- Propietario es Maria
(103, 'Calle Sur 789', 'Apartamento', 60000.00, 2, '204', 'Ciudad C', 'Activo', '11223344', 'Departamento comodo', 'FR125', '11223344'),  -- Propietario es Carlos
(104, 'Plaza Norte 321', 'Duplex', 120000.00, 5, '502', 'Ciudad A', 'Activo', '12345678', 'Duplex con terraza', 'FR126', '12345678');  -- Propietario es Juan

-- Crear tabla contrato
CREATE TABLE contrato (
    id_contrato INT AUTO_INCREMENT PRIMARY KEY,
    fecha_ini DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    us_inquilino VARCHAR(20) NOT NULL,
    us_propietario VARCHAR(20) NOT NULL,
    IdVivienda INT,  -- Nueva columna para referenciar Vivienda
    FOREIGN KEY (IdVivienda) REFERENCES Vivienda(IdVivienda)  -- Clave foránea
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Insertar datos en la tabla contrato
INSERT INTO contrato (fecha_ini, fecha_fin, us_inquilino, us_propietario) VALUES 
('2024-11-01', '2025-11-01', '12345678', '87654321'),  -- Referencia al Duplex de Juan
('2024-11-01', '2025-11-01', '11223344', '55667788');  -- Referencia al Apartamento de Carlos

-- Crear tabla cobro
CREATE TABLE cobro (
    id_Pago INT NOT NULL AUTO_INCREMENT,
    concepto_cobro VARCHAR(50) NOT NULL,
    observacion VARCHAR(255) NOT NULL,
    fecha_cobro DATE NOT NULL,
    cancelado TINYINT(1) NOT NULL,
    monto_cobrar DECIMAL(10, 2) NOT NULL,
    monto_cobrado DECIMAL(10, 2) DEFAULT 0,
    fecha DATE DEFAULT NULL,
    id_contrato INT,  -- Se elimina DEFAULT NULL
    PRIMARY KEY (id_Pago),
    FOREIGN KEY (id_contrato) REFERENCES contrato (id_contrato)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Insertar datos en la tabla cobro
INSERT INTO cobro (concepto_cobro, observacion, fecha_cobro, cancelado, monto_cobrar, monto_cobrado, fecha, id_contrato) VALUES
('Alquiler', 'Pago puntual', '2024-11-01', 1, 500.00, 500.00, '2024-11-01', 1),
('Alquiler', 'Pago puntual', '2024-11-02', 0, 500.00, 0.00, '2024-11-01', 2);  -- Cobro para el segundo contrato

-- Crear tabla recibo
CREATE TABLE recibo (
    nro_recibo INT NOT NULL AUTO_INCREMENT,
    id_recibo VARCHAR(255) NOT NULL,
    id_cobro INT,  -- Se elimina DEFAULT NULL
    monto DECIMAL(10, 2) NOT NULL,
    fecha_recibo DATE NOT NULL,
    observacion VARCHAR(255) NOT NULL,
    tipo_pago VARCHAR(255) DEFAULT NULL,
    usuario_operador VARCHAR(50) NOT NULL,
    PRIMARY KEY (nro_recibo),
    FOREIGN KEY (id_cobro) REFERENCES cobro (id_Pago)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Insertar datos en la tabla recibo
INSERT INTO recibo (id_recibo, id_cobro, monto, fecha_recibo, observacion, tipo_pago, usuario_operador) VALUES
('1', 1, 500.00, '2024-11-01', 'Pago mensual', 'Tarjeta', 'Cajero'),
('2', 2, 500.00, '2024-11-02', 'Pago mensual', 'Efectivo', 'Cajero');  -- Recibo para el segundo cobro

COMMIT;
