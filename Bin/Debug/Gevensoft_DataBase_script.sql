CREATE DATABASE bdgevensoftbase;
CREATE DATABASE empresa1;

\c bdgevensoftbase;

CREATE TABLE empresa (
    id SERIAL PRIMARY KEY,
    bdname VARCHAR(100) NOT NULL,          -- Nombre de la base de datos de la empresa
    orden INTEGER NOT NULL DEFAULT 0,      -- Orden de aparición en el ComboBox
    host VARCHAR(100) NOT NULL,            -- Dirección del servidor
    port INTEGER NOT NULL DEFAULT 5432,    -- Puerto de conexión (por defecto 5432)
    userbd VARCHAR(100) NOT NULL,          -- Usuario para conectar a la BD
    passbd VARCHAR(100) NOT NULL,          -- Contraseña de conexión
    empresaname VARCHAR(100) NOT NULL,     -- Nombre visible de la empresa
    activa BOOLEAN NOT NULL DEFAULT TRUE   -- Indica si la empresa está activa
);

INSERT INTO empresa (bdname, orden, host, port, userbd, passbd, empresaname, activa)
VALUES ('empresa1', 1, 'localhost', 5432, 'postgres', '2003', 'Empresa 1', TRUE);

-- =========================
-- TABLAS BASE
-- =========================
\c empresa1;

CREATE TABLE tipo_documento_identidad (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL,
    observacion TEXT,
    activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE tarifa (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(100),
    activa BOOLEAN DEFAULT TRUE
);

CREATE TABLE permisos (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre CHARACTER VARYING(50),

    ccrearcliente BOOLEAN,
    ceditarcliente BOOLEAN,
    clistarcliente BOOLEAN,

    ccrearproveedor BOOLEAN,
    ceditarproveedor BOOLEAN,
    clistarproveedor BOOLEAN,

    ccrearempleado BOOLEAN,
    ceditarempleado BOOLEAN,
    clistarempleado BOOLEAN,

    activo BOOLEAN DEFAULT TRUE
);


-- =========================
-- TABLAS PRINCIPALES
-- =========================

CREATE TABLE cliente (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_tipo_documento INTEGER,
    detalle_documento VARCHAR(30),
    nombre VARCHAR(100),
    apellidos VARCHAR(150),
    empresa VARCHAR(150),
    email VARCHAR(150),
    observaciones TEXT,
    telefono1 VARCHAR(20),
    telefono2 VARCHAR(20),
    id_tarifa INTEGER,
    persona_contacto VARCHAR(150),
    url_web VARCHAR(200),
    user_login VARCHAR(50),
    pass_login VARCHAR(100),
    activo BOOLEAN DEFAULT TRUE,
    id_permiso INTEGER,

    CONSTRAINT fk_cliente_tipo_documento
        FOREIGN KEY (id_tipo_documento)
        REFERENCES tipo_documento_identidad(id),

    CONSTRAINT fk_cliente_tarifa
        FOREIGN KEY (id_tarifa)
        REFERENCES tarifa(id),

    CONSTRAINT fk_cliente_permiso
        FOREIGN KEY (id_permiso)
        REFERENCES permisos(id)
);

CREATE TABLE proveedores (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_tipo_documento INTEGER,
    detalle_documento VARCHAR(30),
    nombre VARCHAR(100),
    apellidos VARCHAR(150),
    empresa VARCHAR(150),
    email VARCHAR(150),
    observaciones TEXT,
    telefono1 VARCHAR(20),
    telefono2 VARCHAR(20),
    id_tarifa INTEGER,
    persona_contacto VARCHAR(150),
    url_web VARCHAR(200),
    user_login VARCHAR(50),
    pass_login VARCHAR(100),
    activo BOOLEAN DEFAULT TRUE,
    id_permiso INTEGER,

    CONSTRAINT fk_proveedor_tipo_documento
        FOREIGN KEY (id_tipo_documento)
        REFERENCES tipo_documento_identidad(id),

    CONSTRAINT fk_proveedor_tarifa
        FOREIGN KEY (id_tarifa)
        REFERENCES tarifa(id),

    CONSTRAINT fk_proveedor_permiso
        FOREIGN KEY (id_permiso)
        REFERENCES permisos(id)
);

CREATE TABLE empleado (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_tipo_documento INTEGER,
    detalle_documento VARCHAR(30),
    nombre VARCHAR(100),
    apellidos VARCHAR(150),
    empresa VARCHAR(150),
    email VARCHAR(150),
    observaciones TEXT,
    telefono1 VARCHAR(20),
    telefono2 VARCHAR(20),
    persona_contacto VARCHAR(150),
    url_web VARCHAR(200),
    user_login VARCHAR(50),
    pass_login VARCHAR(100),
    activo BOOLEAN DEFAULT TRUE,
    id_permiso INTEGER,

    CONSTRAINT fk_empleado_tipo_documento
        FOREIGN KEY (id_tipo_documento)
        REFERENCES tipo_documento_identidad(id),

    CONSTRAINT fk_empleado_permiso
        FOREIGN KEY (id_permiso)
        REFERENCES permisos(id)
);

-- =========================
-- TABLAS AUXILIARES
-- =========================

CREATE TABLE datos_banco (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_entidad INTEGER,
    sucursal VARCHAR(50),
    ccc VARCHAR(50),
    observacion VARCHAR(200),
    tabla VARCHAR(10)
);

CREATE TABLE datos_direccion (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_entidad INTEGER,
    detalle VARCHAR(50),
    direccion VARCHAR(150),
    poblacion VARCHAR(50),
    provincia VARCHAR(50),
    pais VARCHAR(50),
    cp VARCHAR(20),
    tabla VARCHAR(10)
);

-- =========================
-- LOG
-- =========================

CREATE TABLE logbd (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    tipo INTEGER,
    observaciones VARCHAR(200),
    "USER" VARCHAR(50),
    tipodoc VARCHAR(50),
    iddoc INTEGER,
    fechahora TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    id_empleado INTEGER,

    CONSTRAINT fk_logbd_empleado
        FOREIGN KEY (id_empleado)
        REFERENCES empleado(id)
);

-- Insertar permiso predeterminado de Administrador
INSERT INTO permisos (
    nombre, ccrearcliente, ceditarcliente, clistarcliente,
    ccrearproveedor, ceditarproveedor, clistarproveedor,
    ccrearempleado, ceditarempleado, clistarempleado
) VALUES (
    'Administrador', TRUE, TRUE, TRUE,
    TRUE, TRUE, TRUE,
    TRUE, TRUE, TRUE
);

-- Insertar empleado administrador
INSERT INTO empleado (nombre, user_login, pass_login, id_permiso)
VALUES ('Admin', 'admin', 'admin', 1);

-- Actualizar la contraseña del empleado con user_login = 'admin'
UPDATE empleado
SET pass_login = '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918'
WHERE user_login = 'admin';

-- Insertar tipo de documentos de identidad predeterminados
INSERT INTO tipo_documento_identidad (nombre, observacion) VALUES
('DNI', 'Documento Nacional de Identidad'),
('NIE', 'Número de Identificación de Extranjero'),
('Pasaporte', 'Documento de viaje internacional');

-- Insertar tarifa predeterminada
INSERT INTO tarifa (nombre, descripcion) VALUES
('Tarifa General', 'Tarifa estándar para todos los clientes y proveedores');
