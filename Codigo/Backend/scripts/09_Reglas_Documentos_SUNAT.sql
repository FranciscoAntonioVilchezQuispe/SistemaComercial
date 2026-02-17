
-- Script 09: Reglas de Documentos de Identidad y Comprobantes SUNAT
-- Nombres de tabla solicitados: DOCUMENTOIDENTIDAD, DOCUMENTOIDENTIDAD_DOCUMENTOCOMPROBANTE

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'configuracion')
BEGIN
    EXEC('CREATE SCHEMA configuracion')
END
GO

-- 1. Tabla de Reglas de Documentos
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[configuracion].[DOCUMENTOIDENTIDAD]') AND type in (N'U'))
BEGIN
    CREATE TABLE [configuracion].[DOCUMENTOIDENTIDAD](
        [id_regla] [bigint] IDENTITY(1,1) NOT NULL,
        [codigo] [nvarchar](10) NOT NULL, -- Código SUNAT (1: DNI, 6: RUC, etc)
        [nombre] [nvarchar](100) NOT NULL,
        [longitud] [int] NOT NULL,
        [es_numerico] [bit] NOT NULL DEFAULT (1),
        [estado] [bit] NOT NULL DEFAULT (1),
        [usuario_creacion] [nvarchar](50) NULL,
        [fecha_creacion] [datetime2](7) NOT NULL DEFAULT (GETUTCDATE()),
        [usuario_actualizacion] [nvarchar](50) NULL,
        [fecha_actualizacion] [datetime2](7) NULL,
        CONSTRAINT [PK_DOCUMENTOIDENTIDAD] PRIMARY KEY CLUSTERED ([id_regla] ASC)
    )
END
GO

-- 2. Tabla de Relación Documento - Comprobante
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[configuracion].[DOCUMENTOIDENTIDAD_DOCUMENTOCOMPROBANTE]') AND type in (N'U'))
BEGIN
    CREATE TABLE [configuracion].[DOCUMENTOIDENTIDAD_DOCUMENTOCOMPROBANTE](
        [id_relacion] [bigint] IDENTITY(1,1) NOT NULL,
        [codigo_documento] [nvarchar](10) NOT NULL, -- FK virtual al código de DOCUMENTOIDENTIDAD
        [id_tipo_comprobante] [bigint] NOT NULL, -- FK a configuracion.tipos_comprobantes
        CONSTRAINT [PK_DOCUMENTOIDENTIDAD_DOCUMENTOCOMPROBANTE] PRIMARY KEY CLUSTERED ([id_relacion] ASC)
    )
END
GO

-- 3. Carga de Datos Iniciales (Reglas de Documentos)
INSERT INTO [configuracion].[DOCUMENTOIDENTIDAD] ([codigo], [nombre], [longitud], [es_numerico], [usuario_creacion])
VALUES 
('1', 'DNI', 8, 1, 'SISTEMA'),
('6', 'RUC', 11, 1, 'SISTEMA'),
('4', 'CARNET EXTRANJERIA', 12, 0, 'SISTEMA'),
('7', 'PASAPORTE', 12, 0, 'SISTEMA');
GO

-- 4. Carga de Relaciones (Basado en códigos SUNAT de comprobantes: 01 Factura, 03 Boleta)
-- Primero necesitamos obtener los IDs de los tipos de comprobante existentes
DECLARE @IdFactura BIGINT = (SELECT TOP 1 id_tipo_comprobante FROM [configuracion].[tipos_comprobantes] WHERE codigo = '01');
DECLARE @IdBoleta BIGINT = (SELECT TOP 1 id_tipo_comprobante FROM [configuracion].[tipos_comprobantes] WHERE codigo = '03');

IF @IdFactura IS NOT NULL AND @IdBoleta IS NOT NULL
BEGIN
    INSERT INTO [configuracion].[DOCUMENTOIDENTIDAD_DOCUMENTOCOMPROBANTE] ([codigo_documento], [id_tipo_comprobante])
    VALUES 
    ('6', @IdFactura), -- RUC -> Factura
    ('1', @IdBoleta),  -- DNI -> Boleta
    ('1', @IdFactura), -- DNI -> Factura (algunos casos permiten, pero SUNAT prefiere RUC para factura)
    ('4', @IdBoleta),  -- CE -> Boleta
    ('7', @IdBoleta);  -- PAS -> Boleta
END
GO
