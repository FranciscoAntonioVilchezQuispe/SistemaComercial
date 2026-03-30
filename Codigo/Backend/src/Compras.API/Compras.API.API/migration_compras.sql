DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM pg_namespace WHERE nspname = 'compras') THEN
        CREATE SCHEMA compras;
    END IF;
END $EF$;
CREATE TABLE IF NOT EXISTS compras.__ef_migrations_history (
    migration_id character varying(150) NOT NULL,
    product_version character varying(32) NOT NULL,
    CONSTRAINT pk___ef_migrations_history PRIMARY KEY (migration_id)
);

START TRANSACTION;

INSERT INTO compras.__ef_migrations_history (migration_id, product_version)
VALUES ('20260129231053_Inicial', '8.0.8');

COMMIT;

START TRANSACTION;

INSERT INTO compras.__ef_migrations_history (migration_id, product_version)
VALUES ('20260206190831_FixDetalleAudit', '8.0.8');

COMMIT;

START TRANSACTION;

INSERT INTO compras.__ef_migrations_history (migration_id, product_version)
VALUES ('20260213160911_AddCompraIdToOrdenCompra', '8.0.8');

COMMIT;

START TRANSACTION;

INSERT INTO compras.__ef_migrations_history (migration_id, product_version)
VALUES ('20260217183807_UpdateOrdenCompraSerieNumero', '8.0.8');

COMMIT;

START TRANSACTION;

INSERT INTO compras.__ef_migrations_history (migration_id, product_version)
VALUES ('20260217203920_AddSerieNumeroCorrelativoToOrdenCompra', '8.0.8');

COMMIT;

START TRANSACTION;

INSERT INTO compras.__ef_migrations_history (migration_id, product_version)
VALUES ('20260219175334_AddObservacionesToCompra', '8.0.8');

COMMIT;

START TRANSACTION;

INSERT INTO compras.__ef_migrations_history (migration_id, product_version)
VALUES ('20260221132104_AddCamposSunatPle81', '8.0.8');

COMMIT;

START TRANSACTION;

INSERT INTO compras.__ef_migrations_history (migration_id, product_version)
VALUES ('20260316050748_UpdateSunatFieldsCompras', '8.0.8');

COMMIT;

START TRANSACTION;

INSERT INTO compras.__ef_migrations_history (migration_id, product_version)
VALUES ('20260322232250_FixTypoIdCompra', '8.0.8');

COMMIT;

START TRANSACTION;


                DO $$
                DECLARE
                    t text;
                BEGIN
                    FOR t IN SELECT unnest(ARRAY['proveedores', 'ordenes_compra', 'notas', 'compras', 'detalle_compra', 'detalle_orden_compra', 'detalle_notas'])
                    LOOP
                        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='compras' AND table_name=t AND column_name='fecha_creacion') THEN
                            EXECUTE format('ALTER TABLE compras.%I ADD COLUMN fecha_creacion timestamp with time zone NOT NULL DEFAULT now()', t);
                        END IF;
                        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='compras' AND table_name=t AND column_name='usuario_creacion') THEN
                            EXECUTE format('ALTER TABLE compras.%I ADD COLUMN usuario_creacion varchar(50) NOT NULL DEFAULT ''SISTEMA''', t);
                        END IF;
                        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='compras' AND table_name=t AND column_name='fecha_modificacion') THEN
                            EXECUTE format('ALTER TABLE compras.%I ADD COLUMN fecha_modificacion timestamp with time zone', t);
                        END IF;
                        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='compras' AND table_name=t AND column_name='usuario_modificacion') THEN
                            EXECUTE format('ALTER TABLE compras.%I ADD COLUMN usuario_modificacion varchar(50)', t);
                        END IF;
                        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='compras' AND table_name=t AND column_name='activado') THEN
                            EXECUTE format('ALTER TABLE compras.%I ADD COLUMN activado boolean NOT NULL DEFAULT true', t);
                        END IF;
                    END LOOP;
                END $$;
            

ALTER TABLE compras.proveedores ADD condicion_sunat character varying(20);

ALTER TABLE compras.proveedores ADD es_agente_percepcion boolean NOT NULL DEFAULT FALSE;

ALTER TABLE compras.proveedores ADD es_agente_retencion boolean NOT NULL DEFAULT FALSE;

ALTER TABLE compras.proveedores ADD es_buen_contribuyente boolean NOT NULL DEFAULT FALSE;

ALTER TABLE compras.proveedores ADD estado_sunat character varying(20);

ALTER TABLE compras.proveedores ADD fecha_ultima_consulta_sunat timestamp without time zone;

ALTER TABLE compras.proveedores ADD ubigeo character varying(6);


                DO $$
                BEGIN
                    -- Reseteo de secuencia para evitar error 23505 (llave duplicada)
                    PERFORM setval('compras.proveedores_id_proveedor_seq', (SELECT COALESCE(MAX(id_proveedor), 0) FROM compras.proveedores) + 1);
                END $$;
            


                CREATE UNIQUE INDEX IF NOT EXISTS uq_proveedores_numero_documento 
                ON compras.proveedores(numero_documento) WHERE activado = true;
                
                -- Índice GIN para búsqueda rápida por razón social (requiere pg_trgm o to_tsvector)
                CREATE INDEX IF NOT EXISTS idx_proveedores_razon_social 
                ON compras.proveedores USING gin(to_tsvector('spanish', razon_social));
            

INSERT INTO compras.__ef_migrations_history (migration_id, product_version)
VALUES ('20260327220128_AddSunatFieldsAndResetSequence', '8.0.8');

COMMIT;

START TRANSACTION;

ALTER TABLE compras.proveedores ALTER COLUMN usuario_modificacion TYPE character varying(100);

ALTER TABLE compras.proveedores ALTER COLUMN usuario_creacion TYPE character varying(100);

ALTER TABLE compras.ordenes_compra ALTER COLUMN usuario_modificacion TYPE character varying(100);

ALTER TABLE compras.ordenes_compra ALTER COLUMN usuario_creacion TYPE character varying(100);

ALTER TABLE compras.notas ALTER COLUMN usuario_modificacion TYPE character varying(100);

ALTER TABLE compras.notas ALTER COLUMN usuario_creacion TYPE character varying(100);

ALTER TABLE compras.detalle_orden_compra ALTER COLUMN usuario_modificacion TYPE character varying(100);

ALTER TABLE compras.detalle_orden_compra ALTER COLUMN usuario_creacion TYPE character varying(100);

ALTER TABLE compras.detalle_notas ALTER COLUMN usuario_modificacion TYPE character varying(100);

ALTER TABLE compras.detalle_notas ALTER COLUMN usuario_creacion TYPE character varying(100);

ALTER TABLE compras.detalle_compra ALTER COLUMN usuario_modificacion TYPE character varying(100);

ALTER TABLE compras.detalle_compra ALTER COLUMN usuario_creacion TYPE character varying(100);

ALTER TABLE compras.compras ALTER COLUMN usuario_modificacion TYPE character varying(100);

ALTER TABLE compras.compras ALTER COLUMN usuario_creacion TYPE character varying(100);

ALTER TABLE compras.compras ADD estado_sunat text NOT NULL DEFAULT '';

ALTER TABLE compras.compras ADD fecha_anulacion timestamp without time zone;

ALTER TABLE compras.compras ADD motivo_anulacion text;

CREATE TABLE compras.nota_credito (
    id_nota bigint GENERATED BY DEFAULT AS IDENTITY,
    serie character varying(10) NOT NULL,
    numero character varying(20) NOT NULL,
    tipo_comprobante character varying(2) NOT NULL,
    id_compra_referencia bigint NOT NULL,
    serie_referencia character varying(10) NOT NULL,
    numero_referencia character varying(20) NOT NULL,
    tipo_doc_referencia character varying(2) NOT NULL,
    id_tipo_nota bigint NOT NULL,
    motivo_sustento text NOT NULL,
    id_proveedor bigint NOT NULL,
    proveedor_tipo_doc character varying(2) NOT NULL,
    proveedor_nro_doc character varying(15) NOT NULL,
    proveedor_razon_social character varying(250) NOT NULL,
    subtotal numeric(12,2) NOT NULL,
    igv numeric(12,2) NOT NULL,
    total numeric(12,2) NOT NULL,
    moneda character varying(3) NOT NULL,
    tipo_cambio numeric(10,4),
    afecta_stock boolean NOT NULL,
    fecha_emision date NOT NULL,
    estado character varying(20) NOT NULL,
    activado boolean NOT NULL,
    fecha_creacion timestamp without time zone NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp without time zone,
    usuario_modificacion character varying(100),
    CONSTRAINT pk_nota_credito PRIMARY KEY (id_nota),
    CONSTRAINT fk_nota_credito_compras_id_compra_referencia FOREIGN KEY (id_compra_referencia) REFERENCES compras.compras (id_compra) ON DELETE CASCADE,
    CONSTRAINT fk_nota_credito_proveedores_id_proveedor FOREIGN KEY (id_proveedor) REFERENCES compras.proveedores (id_proveedor) ON DELETE CASCADE
);

CREATE TABLE compras.nota_debito (
    id_nota bigint GENERATED BY DEFAULT AS IDENTITY,
    serie character varying(10) NOT NULL,
    numero character varying(20) NOT NULL,
    tipo_comprobante character varying(2) NOT NULL,
    id_compra_referencia bigint NOT NULL,
    serie_referencia character varying(10) NOT NULL,
    numero_referencia character varying(20) NOT NULL,
    tipo_doc_referencia character varying(2) NOT NULL,
    id_tipo_nota bigint NOT NULL,
    motivo_sustento text NOT NULL,
    id_proveedor bigint NOT NULL,
    proveedor_tipo_doc character varying(2) NOT NULL,
    proveedor_nro_doc character varying(15) NOT NULL,
    proveedor_razon_social character varying(250) NOT NULL,
    subtotal numeric(12,2) NOT NULL,
    igv numeric(12,2) NOT NULL,
    total numeric(12,2) NOT NULL,
    moneda character varying(3) NOT NULL,
    tipo_cambio numeric(10,4),
    afecta_stock boolean NOT NULL,
    fecha_emision date NOT NULL,
    estado character varying(20) NOT NULL,
    activado boolean NOT NULL,
    fecha_creacion timestamp without time zone NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp without time zone,
    usuario_modificacion character varying(100),
    CONSTRAINT pk_nota_debito PRIMARY KEY (id_nota),
    CONSTRAINT fk_nota_debito_compras_id_compra_referencia FOREIGN KEY (id_compra_referencia) REFERENCES compras.compras (id_compra) ON DELETE CASCADE,
    CONSTRAINT fk_nota_debito_proveedores_id_proveedor FOREIGN KEY (id_proveedor) REFERENCES compras.proveedores (id_proveedor) ON DELETE CASCADE
);

CREATE TABLE compras.nota_credito_detalle (
    id_detalle bigint GENERATED BY DEFAULT AS IDENTITY,
    id_nota_credito bigint NOT NULL,
    id_compra_detalle bigint,
    id_producto bigint NOT NULL,
    descripcion character varying(500) NOT NULL,
    unidad_medida character varying(10) NOT NULL,
    cantidad numeric(12,4) NOT NULL,
    precio_unitario numeric(12,4) NOT NULL,
    subtotal numeric(12,2) NOT NULL,
    igv numeric(12,2) NOT NULL,
    total numeric(12,2) NOT NULL,
    activado boolean NOT NULL,
    fecha_creacion timestamp without time zone NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp without time zone,
    usuario_modificacion character varying(100),
    CONSTRAINT pk_nota_credito_detalle PRIMARY KEY (id_detalle),
    CONSTRAINT fk_nota_credito_detalle_detalle_compra_id_compra_detalle FOREIGN KEY (id_compra_detalle) REFERENCES compras.detalle_compra (id_detalle_compra),
    CONSTRAINT fk_nota_credito_detalle_nota_credito_id_nota_credito FOREIGN KEY (id_nota_credito) REFERENCES compras.nota_credito (id_nota) ON DELETE CASCADE
);

CREATE TABLE compras.nota_debito_detalle (
    id_detalle bigint GENERATED BY DEFAULT AS IDENTITY,
    id_nota_debito bigint NOT NULL,
    id_compra_detalle bigint,
    id_producto bigint NOT NULL,
    descripcion character varying(500) NOT NULL,
    unidad_medida character varying(10) NOT NULL,
    cantidad numeric(12,4) NOT NULL,
    precio_unitario numeric(12,4) NOT NULL,
    subtotal numeric(12,2) NOT NULL,
    igv numeric(12,2) NOT NULL,
    total numeric(12,2) NOT NULL,
    activado boolean NOT NULL,
    fecha_creacion timestamp without time zone NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp without time zone,
    usuario_modificacion character varying(100),
    CONSTRAINT pk_nota_debito_detalle PRIMARY KEY (id_detalle),
    CONSTRAINT fk_nota_debito_detalle_detalle_compra_id_compra_detalle FOREIGN KEY (id_compra_detalle) REFERENCES compras.detalle_compra (id_detalle_compra),
    CONSTRAINT fk_nota_debito_detalle_nota_debito_id_nota_debito FOREIGN KEY (id_nota_debito) REFERENCES compras.nota_debito (id_nota) ON DELETE CASCADE
);

CREATE INDEX ix_nota_credito_id_compra_referencia ON compras.nota_credito (id_compra_referencia);

CREATE INDEX ix_nota_credito_id_proveedor ON compras.nota_credito (id_proveedor);

CREATE INDEX ix_nota_credito_detalle_id_compra_detalle ON compras.nota_credito_detalle (id_compra_detalle);

CREATE INDEX ix_nota_credito_detalle_id_nota_credito ON compras.nota_credito_detalle (id_nota_credito);

CREATE INDEX ix_nota_debito_id_compra_referencia ON compras.nota_debito (id_compra_referencia);

CREATE INDEX ix_nota_debito_id_proveedor ON compras.nota_debito (id_proveedor);

CREATE INDEX ix_nota_debito_detalle_id_compra_detalle ON compras.nota_debito_detalle (id_compra_detalle);

CREATE INDEX ix_nota_debito_detalle_id_nota_debito ON compras.nota_debito_detalle (id_nota_debito);

INSERT INTO compras.__ef_migrations_history (migration_id, product_version)
VALUES ('20260329205312_AddSunatNotasCompras', '8.0.8');

COMMIT;

