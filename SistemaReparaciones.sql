/*====================================================
    CREACIÓN DE BASE DE DATOS
====================================================*/

IF DB_ID('SistemaReparaciones') IS NOT NULL
BEGIN
    DROP DATABASE SistemaReparaciones;
END
GO

CREATE DATABASE SistemaReparaciones;
GO

USE SistemaReparaciones;
GO

/*====================================================
    CREACIÓN DE TABLAS
====================================================*/

CREATE TABLE Usuarios
(
    UsuarioID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    CorreoElectronico VARCHAR(100) NOT NULL UNIQUE,
    Telefono VARCHAR(15) NULL
);
GO

CREATE TABLE Equipos
(
    EquipoID INT IDENTITY(1,1) PRIMARY KEY,
    TipoEquipo VARCHAR(30) NOT NULL,
    Modelo VARCHAR(30) NOT NULL,
    UsuarioID INT NOT NULL,
    CONSTRAINT FK_Equipos_Usuarios
        FOREIGN KEY (UsuarioID)
        REFERENCES Usuarios(UsuarioID)
);
GO

CREATE TABLE Tecnicos
(
    TecnicoID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Especialidad VARCHAR(100) NOT NULL
);
GO

CREATE TABLE Reparaciones
(
    ReparacionID INT IDENTITY(1,1) PRIMARY KEY,
    EquiposID INT NOT NULL,
    FechaSolicitud DATE NOT NULL,
    Estado VARCHAR(20) NOT NULL DEFAULT 'Pendiente',

    CONSTRAINT FK_Reparaciones_Equipos
        FOREIGN KEY (EquiposID)
        REFERENCES Equipos(EquipoID)
);
GO

CREATE TABLE Asignaciones
(
    AsignacionID INT IDENTITY(1,1) PRIMARY KEY,
    ReparacionID INT NOT NULL,
    TecnicoID INT NOT NULL,
    FechaAsignacion DATE NOT NULL,

    CONSTRAINT FK_Asignaciones_Reparaciones
        FOREIGN KEY (ReparacionID)
        REFERENCES Reparaciones(ReparacionID),

    CONSTRAINT FK_Asignaciones_Tecnicos
        FOREIGN KEY (TecnicoID)
        REFERENCES Tecnicos(TecnicoID)
);
GO

CREATE TABLE DetallesReparacion
(
    DetalleID INT IDENTITY(1,1) PRIMARY KEY,
    ReparacionID INT NOT NULL,
    Descripcion VARCHAR(100) NOT NULL,
    FechaInicio DATE NOT NULL,
    FechaFin DATE NULL,

    CONSTRAINT FK_Detalles_Reparaciones
        FOREIGN KEY (ReparacionID)
        REFERENCES Reparaciones(ReparacionID)
);
GO

/*====================================================
    INSERTAR DATOS
====================================================*/

/* Usuarios */

INSERT INTO Usuarios (Nombre, CorreoElectronico, Telefono)
VALUES
('Carlos Torrez', 'carlost@gmail.com', '15789189'),
('Ana Cascante', 'anac@gmail.com', '78954682'),
('Fabian Lopez', 'fabianl@gmail.com', '18205920'),
('Andrea Loria', 'andreal@gmail.com', '90460585'),
('Manuel Velasquez', 'manuelv@gmail.com', '71069850'),
('Karla Perez', 'karlap@gmail.com', '1828920'),
('Wilian Gutierrez', 'wiliang@gmail.com', '1852056');
GO

/* Equipos */

INSERT INTO Equipos (TipoEquipo, Modelo, UsuarioID)
VALUES
('Laptop', 'HP', 2),
('Computadora Escritorio', 'OptiPlex 7090', 7),
('Tablet', 'Galaxy Tab 7', 1),
('Celular', 'Samsung A72', 3),
('Laptop', 'Lenovo', 5),
('Laptop', 'Dell', 6),
('Computadora Escritorio', 'HP', 4);
GO

/* Técnicos */

INSERT INTO Tecnicos (Nombre, Especialidad)
VALUES
('Lucas Jimenez', 'Software'),
('Tatiana Rodriguez', 'Hardware'),
('Monica Quesada', 'Software'),
('Alejandro Salas', 'Software'),
('Daniela Rojas', 'Redes'),
('Sonia Araya', 'Redes'),
('Jeremy Alfaro', 'Hardware');
GO

/* Reparaciones */

INSERT INTO Reparaciones (EquiposID, FechaSolicitud, Estado)
VALUES
(6, '2026-11-25', 'Pendiente'),
(1, '2026-11-27', 'Pendiente'),
(7, '2026-11-29', 'Pendiente'),
(4, '2026-11-02', 'Pendiente'),
(5, '2026-11-02', 'Pendiente'),
(3, '2026-11-02', 'Pendiente'),
(2, '2026-11-05', 'Pendiente');
GO

/* Asignaciones */

INSERT INTO Asignaciones (ReparacionID, TecnicoID, FechaAsignacion)
VALUES
(6,1,'2026-11-25'),
(1,2,'2026-11-27'),
(7,3,'2026-11-29'),
(4,4,'2026-11-02'),
(5,5,'2026-11-02'),
(3,6,'2026-11-02'),
(2,7,'2026-11-05');
GO

/* Detalle Reparación */

INSERT INTO DetallesReparacion
(
    ReparacionID,
    Descripcion,
    FechaInicio,
    FechaFin
)
VALUES
(6, 'Revision del disco duro', '2026-11-25', '2026-11-28'),
(1, 'Revision del sistema operativo', '2026-11-27', '2026-11-30'),
(7, 'Revision de memoria', '2026-11-29', '2026-12-02'),
(4, 'Revision de pantalla', '2026-11-02', '2026-11-15'),
(5, 'Revision del teclado', '2026-11-02', '2026-11-05'),
(3, 'Revision de la conexion de red', '2026-12-02', '2026-12-05'),
(2, 'Revision del CPU', '2026-12-05', '2026-12-18');
GO

/*====================================================
    CONSULTAS READ
====================================================*/

SELECT Descripcion
FROM DetallesReparacion;

SELECT Nombre
FROM Tecnicos;

SELECT *
FROM Reparaciones
WHERE Estado = 'Pendiente';
GO

/*====================================================
    UPDATE
====================================================*/

UPDATE Usuarios
SET Telefono = '875381568'
WHERE CorreoElectronico = 'anac@gmail.com';

UPDATE Usuarios
SET Telefono = '1068456'
WHERE UsuarioID = 7;

UPDATE Reparaciones
SET Estado = 'Resuelto'
WHERE ReparacionID = 2;
GO

SELECT * FROM Usuarios;
SELECT * FROM Reparaciones;
GO

/*====================================================
    DELETE
====================================================*/

INSERT INTO Usuarios
(
    Nombre,
    CorreoElectronico,
    Telefono
)
VALUES
(
    'Andres Gutierrez',
    'andresg@gmail.com',
    '1852056'
);

DELETE FROM Usuarios
WHERE UsuarioID = 8;
GO

SELECT * FROM Usuarios;
GO

/*====================================================
    PROCEDIMIENTO REGISTRAR REPARACIÓN
====================================================*/

CREATE PROCEDURE SP_RegistrarReparacion
(
    @EquipoID INT,
    @FechaSolicitud DATE
)
AS
BEGIN

    INSERT INTO Reparaciones
    (
        EquiposID,
        FechaSolicitud,
        Estado
    )
    VALUES
    (
        @EquipoID,
        @FechaSolicitud,
        'Pendiente'
    );

END;
GO

EXEC SP_RegistrarReparacion
    @EquipoID = 1,
    @FechaSolicitud = '2026-12-20';
GO

/*====================================================
    PROCEDIMIENTO ASIGNAR TÉCNICO
====================================================*/

CREATE PROCEDURE SP_AsignarTecnico
(
    @ReparacionID INT,
    @TecnicoID INT,
    @FechaAsignacion DATE
)
AS
BEGIN

    INSERT INTO Asignaciones
    (
        ReparacionID,
        TecnicoID,
        FechaAsignacion
    )
    VALUES
    (
        @ReparacionID,
        @TecnicoID,
        @FechaAsignacion
    );

END;
GO

EXEC SP_AsignarTecnico
    @ReparacionID = 8,
    @TecnicoID = 1,
    @FechaAsignacion = '2026-12-15';
GO

/*====================================================
    TRIGGER
====================================================*/

CREATE TRIGGER TR_FinalizarReparacion
ON DetallesReparacion
AFTER INSERT, UPDATE
AS
BEGIN

    UPDATE R
    SET Estado = 'Completado'
    FROM Reparaciones R
    INNER JOIN inserted I
        ON R.ReparacionID = I.ReparacionID
    WHERE I.FechaFin IS NOT NULL;

END;
GO

UPDATE DetallesReparacion
SET FechaFin = '2026-12-20'
WHERE DetalleID = 1;
GO

SELECT *
FROM Reparaciones;
GO

/*====================================================
    INNER JOIN
====================================================*/

SELECT
    U.Nombre AS Usuario,
    E.Modelo AS Equipo,
    T.Nombre AS Tecnico
FROM Usuarios U
INNER JOIN Equipos E
    ON U.UsuarioID = E.UsuarioID
INNER JOIN Reparaciones R
    ON E.EquipoID = R.EquiposID
INNER JOIN Asignaciones A
    ON R.ReparacionID = A.ReparacionID
INNER JOIN Tecnicos T
    ON A.TecnicoID = T.TecnicoID;
GO

/*====================================================
    GROUP BY + COUNT
====================================================*/

SELECT
    T.Nombre AS Tecnico,
    COUNT(A.AsignacionID) AS CantidadReparaciones
FROM Tecnicos T
LEFT JOIN Asignaciones A
    ON T.TecnicoID = A.TecnicoID
GROUP BY
    T.TecnicoID,
    T.Nombre;
GO

/*====================================================
    WHERE (equipos HP del último mes)
====================================================*/

SELECT
    E.EquipoID,
    E.TipoEquipo,
    E.Modelo,
    R.FechaSolicitud
FROM Equipos E
INNER JOIN Reparaciones R
    ON E.EquipoID = R.EquiposID
WHERE E.Modelo = 'HP'
AND R.FechaSolicitud >= DATEADD(MONTH, -1, GETDATE());
GO