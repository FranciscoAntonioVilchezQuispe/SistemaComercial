--
-- PostgreSQL database cluster dump
--

-- Started on 2026-03-29 12:58:15

\restrict 6eciAlQH2LHb0BRFjDixnoFnxUQwHb8ilC6mKbdbNaNWhcHXPdQui2iSEHdBg51

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE odoo;
ALTER ROLE odoo WITH SUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS;






\unrestrict 6eciAlQH2LHb0BRFjDixnoFnxUQwHb8ilC6mKbdbNaNWhcHXPdQui2iSEHdBg51

--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

\restrict CsC4o95Aq1i1mKeNzLUTXtnvrSexhBKMOn3HDqp3MFdd3VebQrR3IlFuoCuuh5W

-- Dumped from database version 14.22
-- Dumped by pg_dump version 14.22

-- Started on 2026-03-29 12:58:15

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- Completed on 2026-03-29 12:58:16

--
-- PostgreSQL database dump complete
--

\unrestrict CsC4o95Aq1i1mKeNzLUTXtnvrSexhBKMOn3HDqp3MFdd3VebQrR3IlFuoCuuh5W

--
-- Database "sistema_comercial" dump
--

--
-- PostgreSQL database dump
--

\restrict VeLFI1idzRelRDyfy7FTXJwbCK6pfq5o3Yf9wAENjpVhFeFC3EzYOYieoQlDcF2

-- Dumped from database version 14.22
-- Dumped by pg_dump version 14.22

-- Started on 2026-03-29 12:58:16

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4586 (class 1262 OID 16394)
-- Name: sistema_comercial; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE sistema_comercial WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Spanish_Peru.1252';


\unrestrict VeLFI1idzRelRDyfy7FTXJwbCK6pfq5o3Yf9wAENjpVhFeFC3EzYOYieoQlDcF2
\connect sistema_comercial
\restrict VeLFI1idzRelRDyfy7FTXJwbCK6pfq5o3Yf9wAENjpVhFeFC3EzYOYieoQlDcF2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 6 (class 2615 OID 46213)
-- Name: catalogo; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA catalogo;


--
-- TOC entry 7 (class 2615 OID 46214)
-- Name: clientes; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA clientes;


--
-- TOC entry 8 (class 2615 OID 46215)
-- Name: compras; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA compras;


--
-- TOC entry 9 (class 2615 OID 46216)
-- Name: configuracion; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA configuracion;


--
-- TOC entry 10 (class 2615 OID 46217)
-- Name: contabilidad; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA contabilidad;


--
-- TOC entry 11 (class 2615 OID 46218)
-- Name: identidad; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA identidad;


--
-- TOC entry 12 (class 2615 OID 46219)
-- Name: inventario; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA inventario;


--
-- TOC entry 13 (class 2615 OID 46220)
-- Name: ventas; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA ventas;


--
-- TOC entry 14 (class 2615 OID 18605)
-- Name: vistas; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA vistas;


--
-- TOC entry 376 (class 1255 OID 46221)
-- Name: update_fecha_modificacion_column(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_fecha_modificacion_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.fecha_modificacion = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 355 (class 1259 OID 62613)
-- Name: __ef_migrations; Type: TABLE; Schema: catalogo; Owner: -
--

CREATE TABLE catalogo.__ef_migrations (
    migration_id character varying(150) NOT NULL,
    product_version character varying(32) NOT NULL
);


--
-- TOC entry 219 (class 1259 OID 46222)
-- Name: categorias; Type: TABLE; Schema: catalogo; Owner: -
--

CREATE TABLE catalogo.categorias (
    id_categoria bigint NOT NULL,
    nombre_categoria character varying(100) NOT NULL,
    descripcion character varying(255),
    id_categoria_padre bigint,
    imagen_url character varying(500),
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion character varying(100)
);


--
-- TOC entry 220 (class 1259 OID 46230)
-- Name: categorias_id_categoria_seq; Type: SEQUENCE; Schema: catalogo; Owner: -
--

CREATE SEQUENCE catalogo.categorias_id_categoria_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4587 (class 0 OID 0)
-- Dependencies: 220
-- Name: categorias_id_categoria_seq; Type: SEQUENCE OWNED BY; Schema: catalogo; Owner: -
--

ALTER SEQUENCE catalogo.categorias_id_categoria_seq OWNED BY catalogo.categorias.id_categoria;


--
-- TOC entry 221 (class 1259 OID 46231)
-- Name: imagenes_producto; Type: TABLE; Schema: catalogo; Owner: -
--

CREATE TABLE catalogo.imagenes_producto (
    id_imagen bigint NOT NULL,
    id_producto bigint NOT NULL,
    url_imagen character varying(500) NOT NULL,
    es_principal boolean DEFAULT false,
    orden integer DEFAULT 0,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion character varying(100)
);


--
-- TOC entry 222 (class 1259 OID 46241)
-- Name: imagenes_producto_id_imagen_seq; Type: SEQUENCE; Schema: catalogo; Owner: -
--

CREATE SEQUENCE catalogo.imagenes_producto_id_imagen_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4588 (class 0 OID 0)
-- Dependencies: 222
-- Name: imagenes_producto_id_imagen_seq; Type: SEQUENCE OWNED BY; Schema: catalogo; Owner: -
--

ALTER SEQUENCE catalogo.imagenes_producto_id_imagen_seq OWNED BY catalogo.imagenes_producto.id_imagen;


--
-- TOC entry 223 (class 1259 OID 46242)
-- Name: listas_precios; Type: TABLE; Schema: catalogo; Owner: -
--

CREATE TABLE catalogo.listas_precios (
    id_lista_precio bigint NOT NULL,
    nombre_lista character varying(50) NOT NULL,
    es_base boolean DEFAULT false,
    porcentaje_ganancia_sugerido numeric(5,2),
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion character varying(100)
);


--
-- TOC entry 224 (class 1259 OID 46249)
-- Name: listas_precios_id_lista_precio_seq; Type: SEQUENCE; Schema: catalogo; Owner: -
--

CREATE SEQUENCE catalogo.listas_precios_id_lista_precio_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4589 (class 0 OID 0)
-- Dependencies: 224
-- Name: listas_precios_id_lista_precio_seq; Type: SEQUENCE OWNED BY; Schema: catalogo; Owner: -
--

ALTER SEQUENCE catalogo.listas_precios_id_lista_precio_seq OWNED BY catalogo.listas_precios.id_lista_precio;


--
-- TOC entry 225 (class 1259 OID 46250)
-- Name: marcas; Type: TABLE; Schema: catalogo; Owner: -
--

CREATE TABLE catalogo.marcas (
    id_marca bigint NOT NULL,
    nombre_marca character varying(100) NOT NULL,
    pais_origen character varying(100),
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion character varying(100)
);


--
-- TOC entry 226 (class 1259 OID 46256)
-- Name: marcas_id_marca_seq; Type: SEQUENCE; Schema: catalogo; Owner: -
--

CREATE SEQUENCE catalogo.marcas_id_marca_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4590 (class 0 OID 0)
-- Dependencies: 226
-- Name: marcas_id_marca_seq; Type: SEQUENCE OWNED BY; Schema: catalogo; Owner: -
--

ALTER SEQUENCE catalogo.marcas_id_marca_seq OWNED BY catalogo.marcas.id_marca;


--
-- TOC entry 227 (class 1259 OID 46257)
-- Name: productos; Type: TABLE; Schema: catalogo; Owner: -
--

CREATE TABLE catalogo.productos (
    id_producto bigint NOT NULL,
    codigo_producto character varying(50) NOT NULL,
    codigo_barras character varying(100),
    sku character varying(100),
    nombre_producto character varying(255) NOT NULL,
    descripcion text,
    id_categoria bigint NOT NULL,
    id_marca bigint NOT NULL,
    id_unidad bigint NOT NULL,
    tiene_variantes boolean DEFAULT false NOT NULL,
    precio_compra numeric(12,2) DEFAULT 0,
    precio_venta_publico numeric(12,2) DEFAULT 0 NOT NULL,
    precio_venta_mayorista numeric(12,2) DEFAULT 0,
    precio_venta_distribuidor numeric(12,2) DEFAULT 0,
    stock_minimo numeric(10,3) DEFAULT 0,
    stock_maximo numeric(10,3),
    permite_inventario_negativo boolean DEFAULT false NOT NULL,
    gravado_impuesto boolean DEFAULT true NOT NULL,
    porcentaje_impuesto numeric(5,2) DEFAULT 18.00,
    imagen_principal_url character varying(500),
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion character varying(100),
    id_tipo_producto bigint,
    metodo_valuacion character varying(2) DEFAULT ''::character varying NOT NULL,
    CONSTRAINT productos_precio_compra_check CHECK ((precio_compra >= (0)::numeric)),
    CONSTRAINT productos_precio_venta_distribuidor_check CHECK ((precio_venta_distribuidor >= (0)::numeric)),
    CONSTRAINT productos_precio_venta_mayorista_check CHECK ((precio_venta_mayorista >= (0)::numeric)),
    CONSTRAINT productos_precio_venta_publico_check CHECK ((precio_venta_publico >= (0)::numeric))
);


--
-- TOC entry 4591 (class 0 OID 0)
-- Dependencies: 227
-- Name: TABLE productos; Type: COMMENT; Schema: catalogo; Owner: -
--

COMMENT ON TABLE catalogo.productos IS 'Catálogo maestro de productos';


--
-- TOC entry 228 (class 1259 OID 46278)
-- Name: productos_id_producto_seq; Type: SEQUENCE; Schema: catalogo; Owner: -
--

CREATE SEQUENCE catalogo.productos_id_producto_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4592 (class 0 OID 0)
-- Dependencies: 228
-- Name: productos_id_producto_seq; Type: SEQUENCE OWNED BY; Schema: catalogo; Owner: -
--

ALTER SEQUENCE catalogo.productos_id_producto_seq OWNED BY catalogo.productos.id_producto;


--
-- TOC entry 229 (class 1259 OID 46279)
-- Name: unidades_medida; Type: TABLE; Schema: catalogo; Owner: -
--

CREATE TABLE catalogo.unidades_medida (
    id_unidad bigint NOT NULL,
    codigo_sunat character varying(10),
    nombre_unidad character varying(50) NOT NULL,
    simbolo character varying(10) NOT NULL,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion character varying(100)
);


--
-- TOC entry 230 (class 1259 OID 46285)
-- Name: unidades_medida_id_unidad_seq; Type: SEQUENCE; Schema: catalogo; Owner: -
--

CREATE SEQUENCE catalogo.unidades_medida_id_unidad_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4593 (class 0 OID 0)
-- Dependencies: 230
-- Name: unidades_medida_id_unidad_seq; Type: SEQUENCE OWNED BY; Schema: catalogo; Owner: -
--

ALTER SEQUENCE catalogo.unidades_medida_id_unidad_seq OWNED BY catalogo.unidades_medida.id_unidad;


--
-- TOC entry 231 (class 1259 OID 46286)
-- Name: variantes_producto; Type: TABLE; Schema: catalogo; Owner: -
--

CREATE TABLE catalogo.variantes_producto (
    id_variante bigint NOT NULL,
    id_producto bigint NOT NULL,
    sku_variante character varying(100) NOT NULL,
    codigo_barras_variante character varying(100),
    nombre_completo_variante character varying(255) NOT NULL,
    atributos_json jsonb,
    precio_adicional numeric(12,2) DEFAULT 0,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion character varying(100)
);


--
-- TOC entry 232 (class 1259 OID 46295)
-- Name: variantes_producto_id_variante_seq; Type: SEQUENCE; Schema: catalogo; Owner: -
--

CREATE SEQUENCE catalogo.variantes_producto_id_variante_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4594 (class 0 OID 0)
-- Dependencies: 232
-- Name: variantes_producto_id_variante_seq; Type: SEQUENCE OWNED BY; Schema: catalogo; Owner: -
--

ALTER SEQUENCE catalogo.variantes_producto_id_variante_seq OWNED BY catalogo.variantes_producto.id_variante;


--
-- TOC entry 371 (class 1259 OID 66654)
-- Name: __EFMigrationsHistory; Type: TABLE; Schema: clientes; Owner: -
--

CREATE TABLE clientes."__EFMigrationsHistory" (
    "MigrationId" character varying(150) NOT NULL,
    "ProductVersion" character varying(32) NOT NULL
);


--
-- TOC entry 374 (class 1259 OID 66796)
-- Name: __ef_migrations_history; Type: TABLE; Schema: clientes; Owner: -
--

CREATE TABLE clientes.__ef_migrations_history (
    migration_id character varying(150) NOT NULL,
    product_version character varying(32) NOT NULL
);


--
-- TOC entry 233 (class 1259 OID 46296)
-- Name: clientes; Type: TABLE; Schema: clientes; Owner: -
--

CREATE TABLE clientes.clientes (
    id_cliente bigint NOT NULL,
    numero_documento character varying(20) NOT NULL,
    razon_social character varying(255) NOT NULL,
    nombre_comercial character varying(255),
    direccion character varying(500),
    telefono character varying(50),
    email character varying(100),
    limite_credito numeric(12,2) DEFAULT 0,
    dias_credito integer DEFAULT 0,
    id_lista_precio_asignada bigint,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion character varying(100),
    id_tipo_documento bigint,
    id_tipo_cliente bigint,
    condicion_sunat character varying(20),
    es_agente_percepcion boolean DEFAULT false NOT NULL,
    es_agente_retencion boolean DEFAULT false NOT NULL,
    es_buen_contribuyente boolean DEFAULT false NOT NULL,
    estado_sunat character varying(20),
    fecha_ultima_consulta_sunat timestamp with time zone,
    ubigeo character varying(6)
);


--
-- TOC entry 234 (class 1259 OID 46306)
-- Name: clientes_id_cliente_seq; Type: SEQUENCE; Schema: clientes; Owner: -
--

CREATE SEQUENCE clientes.clientes_id_cliente_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4595 (class 0 OID 0)
-- Dependencies: 234
-- Name: clientes_id_cliente_seq; Type: SEQUENCE OWNED BY; Schema: clientes; Owner: -
--

ALTER SEQUENCE clientes.clientes_id_cliente_seq OWNED BY clientes.clientes.id_cliente;


--
-- TOC entry 235 (class 1259 OID 46307)
-- Name: contactos_cliente; Type: TABLE; Schema: clientes; Owner: -
--

CREATE TABLE clientes.contactos_cliente (
    id_contacto bigint NOT NULL,
    id_cliente bigint NOT NULL,
    nombres character varying(100) NOT NULL,
    cargo character varying(100),
    telefono character varying(50),
    email character varying(100),
    es_principal boolean DEFAULT false,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion character varying(100)
);


--
-- TOC entry 236 (class 1259 OID 46316)
-- Name: contactos_cliente_id_contacto_seq; Type: SEQUENCE; Schema: clientes; Owner: -
--

CREATE SEQUENCE clientes.contactos_cliente_id_contacto_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4596 (class 0 OID 0)
-- Dependencies: 236
-- Name: contactos_cliente_id_contacto_seq; Type: SEQUENCE OWNED BY; Schema: clientes; Owner: -
--

ALTER SEQUENCE clientes.contactos_cliente_id_contacto_seq OWNED BY clientes.contactos_cliente.id_contacto;


--
-- TOC entry 373 (class 1259 OID 66791)
-- Name: __ef_migrations_history; Type: TABLE; Schema: compras; Owner: -
--

CREATE TABLE compras.__ef_migrations_history (
    migration_id character varying(150) NOT NULL,
    product_version character varying(32) NOT NULL
);


--
-- TOC entry 237 (class 1259 OID 46317)
-- Name: compras; Type: TABLE; Schema: compras; Owner: -
--

CREATE TABLE compras.compras (
    id_compra bigint NOT NULL,
    id_proveedor bigint NOT NULL,
    id_almacen bigint NOT NULL,
    id_orden_compra_ref bigint,
    serie_comprobante character varying(10) NOT NULL,
    numero_comprobante character varying(20) NOT NULL,
    fecha_emision date NOT NULL,
    fecha_contable date NOT NULL,
    moneda character varying(3) DEFAULT 'PEN'::character varying,
    tipo_cambio numeric(10,4) DEFAULT 1,
    subtotal numeric(12,2) DEFAULT 0,
    impuesto numeric(12,2) DEFAULT 0,
    total numeric(12,2) DEFAULT 0,
    saldo_pendiente numeric(12,2),
    fecha_vencimiento date,
    base_gravada numeric(12,2) DEFAULT 0.00 NOT NULL,
    base_exonerada numeric(12,2) DEFAULT 0.00 NOT NULL,
    base_inafecta numeric(12,2) DEFAULT 0.00 NOT NULL,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion character varying(100),
    id_tipo_comprobante bigint,
    id_estado_pago bigint,
    observaciones text
);


--
-- TOC entry 238 (class 1259 OID 46331)
-- Name: compras_id_compra_seq; Type: SEQUENCE; Schema: compras; Owner: -
--

CREATE SEQUENCE compras.compras_id_compra_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4597 (class 0 OID 0)
-- Dependencies: 238
-- Name: compras_id_compra_seq; Type: SEQUENCE OWNED BY; Schema: compras; Owner: -
--

ALTER SEQUENCE compras.compras_id_compra_seq OWNED BY compras.compras.id_compra;


--
-- TOC entry 239 (class 1259 OID 46332)
-- Name: detalle_compra; Type: TABLE; Schema: compras; Owner: -
--

CREATE TABLE compras.detalle_compra (
    id_detalle_compra bigint NOT NULL,
    id_compra bigint NOT NULL,
    id_producto bigint NOT NULL,
    id_variante bigint,
    descripcion character varying(255),
    cantidad numeric(10,3) NOT NULL,
    precio_unitario_compra numeric(12,2) NOT NULL,
    subtotal numeric(12,2) NOT NULL,
    afectacion_igv character varying(2) DEFAULT 'G'::character varying NOT NULL,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion character varying(100),
    codigo_tributo character varying(4),
    precio_unitario_base numeric(12,4),
    descuento_item numeric(12,4) DEFAULT 0,
    valor_item numeric(12,4)
);


--
-- TOC entry 240 (class 1259 OID 46339)
-- Name: detalle_compra_id_detalle_compra_seq; Type: SEQUENCE; Schema: compras; Owner: -
--

CREATE SEQUENCE compras.detalle_compra_id_detalle_compra_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4598 (class 0 OID 0)
-- Dependencies: 240
-- Name: detalle_compra_id_detalle_compra_seq; Type: SEQUENCE OWNED BY; Schema: compras; Owner: -
--

ALTER SEQUENCE compras.detalle_compra_id_detalle_compra_seq OWNED BY compras.detalle_compra.id_detalle_compra;


--
-- TOC entry 335 (class 1259 OID 47555)
-- Name: detalle_notas; Type: TABLE; Schema: compras; Owner: -
--

CREATE TABLE compras.detalle_notas (
    id_detalle_nota bigint NOT NULL,
    id_nota bigint NOT NULL,
    id_producto bigint NOT NULL,
    cantidad numeric(10,3) NOT NULL,
    precio_unitario numeric(12,2) NOT NULL,
    subtotal numeric(12,2) NOT NULL,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp with time zone DEFAULT now() NOT NULL,
    usuario_creacion character varying(50) DEFAULT 'SISTEMA'::character varying NOT NULL,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(50)
);


--
-- TOC entry 334 (class 1259 OID 47554)
-- Name: detalle_notas_id_detalle_nota_seq; Type: SEQUENCE; Schema: compras; Owner: -
--

ALTER TABLE compras.detalle_notas ALTER COLUMN id_detalle_nota ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME compras.detalle_notas_id_detalle_nota_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 241 (class 1259 OID 46340)
-- Name: detalle_orden_compra; Type: TABLE; Schema: compras; Owner: -
--

CREATE TABLE compras.detalle_orden_compra (
    id_detalle_oc bigint NOT NULL,
    id_orden_compra bigint NOT NULL,
    id_producto bigint NOT NULL,
    id_variante bigint,
    cantidad_solicitada numeric(10,3) NOT NULL,
    precio_unitario_pactado numeric(12,2) NOT NULL,
    subtotal numeric(12,2) NOT NULL,
    cantidad_recibida numeric(10,3) DEFAULT 0,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion character varying(100)
);


--
-- TOC entry 242 (class 1259 OID 46347)
-- Name: detalle_orden_compra_id_detalle_oc_seq; Type: SEQUENCE; Schema: compras; Owner: -
--

CREATE SEQUENCE compras.detalle_orden_compra_id_detalle_oc_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4599 (class 0 OID 0)
-- Dependencies: 242
-- Name: detalle_orden_compra_id_detalle_oc_seq; Type: SEQUENCE OWNED BY; Schema: compras; Owner: -
--

ALTER SEQUENCE compras.detalle_orden_compra_id_detalle_oc_seq OWNED BY compras.detalle_orden_compra.id_detalle_oc;


--
-- TOC entry 372 (class 1259 OID 66762)
-- Name: ef_migrations_history; Type: TABLE; Schema: compras; Owner: -
--

CREATE TABLE compras.ef_migrations_history (
    migration_id character varying(150) NOT NULL,
    product_version character varying(32) NOT NULL
);


--
-- TOC entry 325 (class 1259 OID 47272)
-- Name: notas; Type: TABLE; Schema: compras; Owner: -
--

CREATE TABLE compras.notas (
    id_nota bigint NOT NULL,
    id_compra_referencia bigint,
    id_tipo_comprobante bigint,
    serie_comprobante character varying(10),
    numero_comprobante character varying(20),
    fecha_emision timestamp with time zone,
    motivo_sustento text,
    total numeric(12,2),
    activado boolean DEFAULT true,
    codigo_tipo_comprobante_ref character varying(10),
    serie_ref character varying(10),
    numero_ref character varying(20),
    descripcion_motivo character varying(200),
    codigo_motivo_nc character varying(2),
    codigo_motivo_nd character varying(2),
    id_tipo_doc_ref character varying(4),
    fecha_creacion timestamp with time zone DEFAULT now() NOT NULL,
    usuario_creacion character varying(50) DEFAULT 'SISTEMA'::character varying NOT NULL,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(50)
);


--
-- TOC entry 324 (class 1259 OID 47271)
-- Name: notas_id_nota_seq; Type: SEQUENCE; Schema: compras; Owner: -
--

ALTER TABLE compras.notas ALTER COLUMN id_nota ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME compras.notas_id_nota_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 243 (class 1259 OID 46348)
-- Name: ordenes_compra; Type: TABLE; Schema: compras; Owner: -
--

CREATE TABLE compras.ordenes_compra (
    id_orden_compra bigint NOT NULL,
    codigo_orden character varying(20) NOT NULL,
    id_proveedor bigint NOT NULL,
    id_almacen_destino bigint NOT NULL,
    fecha_emision date NOT NULL,
    fecha_entrega_estimada date,
    total_importe numeric(12,2) DEFAULT 0,
    observaciones text,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion character varying(100),
    id_estado bigint,
    compra_id bigint,
    id_tipo_comprobante bigint,
    serie character varying(10),
    numero character varying(20)
);


--
-- TOC entry 4600 (class 0 OID 0)
-- Dependencies: 243
-- Name: COLUMN ordenes_compra.compra_id; Type: COMMENT; Schema: compras; Owner: -
--

COMMENT ON COLUMN compras.ordenes_compra.compra_id IS 'ID de la compra vinculada a esta orden';


--
-- TOC entry 244 (class 1259 OID 46357)
-- Name: ordenes_compra_id_orden_compra_seq; Type: SEQUENCE; Schema: compras; Owner: -
--

CREATE SEQUENCE compras.ordenes_compra_id_orden_compra_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4601 (class 0 OID 0)
-- Dependencies: 244
-- Name: ordenes_compra_id_orden_compra_seq; Type: SEQUENCE OWNED BY; Schema: compras; Owner: -
--

ALTER SEQUENCE compras.ordenes_compra_id_orden_compra_seq OWNED BY compras.ordenes_compra.id_orden_compra;


--
-- TOC entry 245 (class 1259 OID 46358)
-- Name: proveedores; Type: TABLE; Schema: compras; Owner: -
--

CREATE TABLE compras.proveedores (
    id_proveedor bigint NOT NULL,
    numero_documento character varying(20) NOT NULL,
    razon_social character varying(255) NOT NULL,
    nombre_comercial character varying(255),
    direccion character varying(500),
    telefono character varying(50),
    email character varying(100),
    pagina_web character varying(255),
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion character varying(100),
    id_tipo_documento bigint,
    condicion_sunat character varying(20),
    es_agente_percepcion boolean DEFAULT false NOT NULL,
    es_agente_retencion boolean DEFAULT false NOT NULL,
    es_buen_contribuyente boolean DEFAULT false NOT NULL,
    estado_sunat character varying(20),
    fecha_ultima_consulta_sunat timestamp without time zone,
    ubigeo character varying(6)
);


--
-- TOC entry 246 (class 1259 OID 46366)
-- Name: proveedores_id_proveedor_seq; Type: SEQUENCE; Schema: compras; Owner: -
--

CREATE SEQUENCE compras.proveedores_id_proveedor_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4602 (class 0 OID 0)
-- Dependencies: 246
-- Name: proveedores_id_proveedor_seq; Type: SEQUENCE OWNED BY; Schema: compras; Owner: -
--

ALTER SEQUENCE compras.proveedores_id_proveedor_seq OWNED BY compras.proveedores.id_proveedor;


--
-- TOC entry 247 (class 1259 OID 46367)
-- Name: configuraciones; Type: TABLE; Schema: configuracion; Owner: -
--

CREATE TABLE configuracion.configuraciones (
    id_configuracion bigint NOT NULL,
    clave character varying(100) NOT NULL,
    valor text NOT NULL,
    descripcion character varying(255),
    grupo character varying(50),
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion character varying(100)
);


--
-- TOC entry 4603 (class 0 OID 0)
-- Dependencies: 247
-- Name: TABLE configuraciones; Type: COMMENT; Schema: configuracion; Owner: -
--

COMMENT ON TABLE configuracion.configuraciones IS 'Variables de configuración global del sistema';


--
-- TOC entry 248 (class 1259 OID 46375)
-- Name: configuraciones_id_configuracion_seq; Type: SEQUENCE; Schema: configuracion; Owner: -
--

CREATE SEQUENCE configuracion.configuraciones_id_configuracion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4604 (class 0 OID 0)
-- Dependencies: 248
-- Name: configuraciones_id_configuracion_seq; Type: SEQUENCE OWNED BY; Schema: configuracion; Owner: -
--

ALTER SEQUENCE configuracion.configuraciones_id_configuracion_seq OWNED BY configuracion.configuraciones.id_configuracion;


--
-- TOC entry 249 (class 1259 OID 46376)
-- Name: empresa; Type: TABLE; Schema: configuracion; Owner: -
--

CREATE TABLE configuracion.empresa (
    id_empresa bigint NOT NULL,
    ruc character varying(20) NOT NULL,
    razon_social character varying(255) NOT NULL,
    nombre_comercial character varying(255),
    direccion_fiscal character varying(500) NOT NULL,
    telefono character varying(50),
    correo_contacto character varying(100),
    sitio_web character varying(255),
    logo_url character varying(500),
    moneda_principal character varying(3) DEFAULT 'PEN'::character varying NOT NULL,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion character varying(100)
);


--
-- TOC entry 4605 (class 0 OID 0)
-- Dependencies: 249
-- Name: TABLE empresa; Type: COMMENT; Schema: configuracion; Owner: -
--

COMMENT ON TABLE configuracion.empresa IS 'Datos generales de la empresa emisora';


--
-- TOC entry 250 (class 1259 OID 46385)
-- Name: empresa_id_empresa_seq; Type: SEQUENCE; Schema: configuracion; Owner: -
--

CREATE SEQUENCE configuracion.empresa_id_empresa_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4606 (class 0 OID 0)
-- Dependencies: 250
-- Name: empresa_id_empresa_seq; Type: SEQUENCE OWNED BY; Schema: configuracion; Owner: -
--

ALTER SEQUENCE configuracion.empresa_id_empresa_seq OWNED BY configuracion.empresa.id_empresa;


--
-- TOC entry 329 (class 1259 OID 47333)
-- Name: impuestos; Type: TABLE; Schema: configuracion; Owner: -
--

CREATE TABLE configuracion.impuestos (
    id_impuesto bigint NOT NULL,
    codigo_sunat character varying(10) NOT NULL,
    nombre character varying(100) NOT NULL,
    porcentaje numeric(5,2) DEFAULT 0 NOT NULL,
    es_porcentaje boolean DEFAULT true NOT NULL,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT now() NOT NULL,
    usuario_creacion character varying(100) DEFAULT 'SYSTEM'::character varying NOT NULL,
    fecha_modificacion timestamp without time zone,
    usuario_modificacion character varying(100)
);


--
-- TOC entry 328 (class 1259 OID 47332)
-- Name: impuestos_id_impuesto_seq; Type: SEQUENCE; Schema: configuracion; Owner: -
--

CREATE SEQUENCE configuracion.impuestos_id_impuesto_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4607 (class 0 OID 0)
-- Dependencies: 328
-- Name: impuestos_id_impuesto_seq; Type: SEQUENCE OWNED BY; Schema: configuracion; Owner: -
--

ALTER SEQUENCE configuracion.impuestos_id_impuesto_seq OWNED BY configuracion.impuestos.id_impuesto;


--
-- TOC entry 319 (class 1259 OID 47241)
-- Name: matriz_regla_sunat; Type: TABLE; Schema: configuracion; Owner: -
--

CREATE TABLE configuracion.matriz_regla_sunat (
    id_regla integer NOT NULL,
    id_tipo_operacion integer,
    id_tipo_comprobante integer,
    nivel_obligatoriedad integer DEFAULT 0,
    activado boolean DEFAULT true,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_creacion character varying(100) DEFAULT 'SYSTEM'::character varying,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(50)
);


--
-- TOC entry 318 (class 1259 OID 47240)
-- Name: matriz_regla_sunat_id_regla_seq; Type: SEQUENCE; Schema: configuracion; Owner: -
--

CREATE SEQUENCE configuracion.matriz_regla_sunat_id_regla_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4608 (class 0 OID 0)
-- Dependencies: 318
-- Name: matriz_regla_sunat_id_regla_seq; Type: SEQUENCE OWNED BY; Schema: configuracion; Owner: -
--

ALTER SEQUENCE configuracion.matriz_regla_sunat_id_regla_seq OWNED BY configuracion.matriz_regla_sunat.id_regla;


--
-- TOC entry 345 (class 1259 OID 47710)
-- Name: motivo_nota_credito; Type: TABLE; Schema: configuracion; Owner: -
--

CREATE TABLE configuracion.motivo_nota_credito (
    id_motivo bigint NOT NULL,
    codigo character varying(2) NOT NULL,
    nombre character varying(200) NOT NULL,
    devuelve_stock boolean DEFAULT false NOT NULL,
    activo boolean DEFAULT true NOT NULL,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp with time zone DEFAULT now() NOT NULL,
    usuario_creacion character varying(50) DEFAULT 'SYSTEM'::character varying NOT NULL,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(50)
);


--
-- TOC entry 344 (class 1259 OID 47709)
-- Name: motivo_nota_credito_id_motivo_seq; Type: SEQUENCE; Schema: configuracion; Owner: -
--

ALTER TABLE configuracion.motivo_nota_credito ALTER COLUMN id_motivo ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME configuracion.motivo_nota_credito_id_motivo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 347 (class 1259 OID 47723)
-- Name: motivo_nota_debito; Type: TABLE; Schema: configuracion; Owner: -
--

CREATE TABLE configuracion.motivo_nota_debito (
    id_motivo bigint NOT NULL,
    codigo character varying(2) NOT NULL,
    nombre character varying(200) NOT NULL,
    activo boolean DEFAULT true NOT NULL,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp with time zone DEFAULT now() NOT NULL,
    usuario_creacion character varying(50) DEFAULT 'SYSTEM'::character varying NOT NULL,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(50)
);


--
-- TOC entry 346 (class 1259 OID 47722)
-- Name: motivo_nota_debito_id_motivo_seq; Type: SEQUENCE; Schema: configuracion; Owner: -
--

ALTER TABLE configuracion.motivo_nota_debito ALTER COLUMN id_motivo ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME configuracion.motivo_nota_debito_id_motivo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 331 (class 1259 OID 47345)
-- Name: parametros_configuracion; Type: TABLE; Schema: configuracion; Owner: -
--

CREATE TABLE configuracion.parametros_configuracion (
    id_parametro bigint NOT NULL,
    codigo character varying(50) NOT NULL,
    valor character varying(255),
    descripcion character varying(500),
    grupo character varying(50),
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT now() NOT NULL,
    usuario_creacion character varying(100) DEFAULT 'SYSTEM'::character varying NOT NULL,
    fecha_modificacion timestamp without time zone,
    usuario_modificacion character varying(100)
);


--
-- TOC entry 330 (class 1259 OID 47344)
-- Name: parametros_configuracion_id_parametro_seq; Type: SEQUENCE; Schema: configuracion; Owner: -
--

CREATE SEQUENCE configuracion.parametros_configuracion_id_parametro_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4609 (class 0 OID 0)
-- Dependencies: 330
-- Name: parametros_configuracion_id_parametro_seq; Type: SEQUENCE OWNED BY; Schema: configuracion; Owner: -
--

ALTER SEQUENCE configuracion.parametros_configuracion_id_parametro_seq OWNED BY configuracion.parametros_configuracion.id_parametro;


--
-- TOC entry 321 (class 1259 OID 47253)
-- Name: regla_documento_comprobante; Type: TABLE; Schema: configuracion; Owner: -
--

CREATE TABLE configuracion.regla_documento_comprobante (
    id_relacion bigint NOT NULL,
    codigo_documento character varying(10) NOT NULL,
    id_tipo_comprobante bigint NOT NULL,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp with time zone DEFAULT now() NOT NULL,
    usuario_creacion character varying(50) DEFAULT 'SYSTEM'::character varying NOT NULL,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(50)
);


--
-- TOC entry 320 (class 1259 OID 47252)
-- Name: regla_documento_comprobante_id_relacion_seq; Type: SEQUENCE; Schema: configuracion; Owner: -
--

ALTER TABLE configuracion.regla_documento_comprobante ALTER COLUMN id_relacion ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME configuracion.regla_documento_comprobante_id_relacion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 251 (class 1259 OID 46386)
-- Name: series_comprobantes; Type: TABLE; Schema: configuracion; Owner: -
--

CREATE TABLE configuracion.series_comprobantes (
    id_serie bigint NOT NULL,
    serie character varying(10) NOT NULL,
    correlativo_actual bigint DEFAULT 0 NOT NULL,
    id_almacen bigint,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion character varying(100),
    id_tipo_comprobante bigint
);


--
-- TOC entry 4610 (class 0 OID 0)
-- Dependencies: 251
-- Name: TABLE series_comprobantes; Type: COMMENT; Schema: configuracion; Owner: -
--

COMMENT ON TABLE configuracion.series_comprobantes IS 'Gestión de series y correlativos para facturación';


--
-- TOC entry 252 (class 1259 OID 46393)
-- Name: series_comprobantes_id_serie_seq; Type: SEQUENCE; Schema: configuracion; Owner: -
--

CREATE SEQUENCE configuracion.series_comprobantes_id_serie_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4611 (class 0 OID 0)
-- Dependencies: 252
-- Name: series_comprobantes_id_serie_seq; Type: SEQUENCE OWNED BY; Schema: configuracion; Owner: -
--

ALTER SEQUENCE configuracion.series_comprobantes_id_serie_seq OWNED BY configuracion.series_comprobantes.id_serie;


--
-- TOC entry 327 (class 1259 OID 47315)
-- Name: sucursales; Type: TABLE; Schema: configuracion; Owner: -
--

CREATE TABLE configuracion.sucursales (
    id_sucursal bigint NOT NULL,
    id_empresa bigint NOT NULL,
    codigo character varying(20) NOT NULL,
    nombre character varying(100) NOT NULL,
    direccion character varying(255),
    telefono character varying(50),
    es_principal boolean DEFAULT false NOT NULL,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT now() NOT NULL,
    usuario_creacion character varying(100) DEFAULT 'SYSTEM'::character varying NOT NULL,
    fecha_modificacion timestamp without time zone,
    usuario_modificacion character varying(100)
);


--
-- TOC entry 326 (class 1259 OID 47314)
-- Name: sucursales_id_sucursal_seq; Type: SEQUENCE; Schema: configuracion; Owner: -
--

CREATE SEQUENCE configuracion.sucursales_id_sucursal_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4612 (class 0 OID 0)
-- Dependencies: 326
-- Name: sucursales_id_sucursal_seq; Type: SEQUENCE OWNED BY; Schema: configuracion; Owner: -
--

ALTER SEQUENCE configuracion.sucursales_id_sucursal_seq OWNED BY configuracion.sucursales.id_sucursal;


--
-- TOC entry 253 (class 1259 OID 46394)
-- Name: tablas_generales; Type: TABLE; Schema: configuracion; Owner: -
--

CREATE TABLE configuracion.tablas_generales (
    id_tabla bigint NOT NULL,
    codigo character varying(50) NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion text,
    es_sistema boolean DEFAULT false NOT NULL,
    fecha_creacion timestamp with time zone DEFAULT now() NOT NULL,
    usuario_creacion character varying(50) NOT NULL,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(50),
    activado boolean DEFAULT true NOT NULL
);


--
-- TOC entry 254 (class 1259 OID 46402)
-- Name: tablas_generales_detalle; Type: TABLE; Schema: configuracion; Owner: -
--

CREATE TABLE configuracion.tablas_generales_detalle (
    id_detalle bigint NOT NULL,
    id_tabla bigint NOT NULL,
    codigo character varying(50) NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion text,
    orden integer DEFAULT 0 NOT NULL,
    estado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp with time zone DEFAULT now() NOT NULL,
    usuario_creacion character varying(50) NOT NULL,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(50),
    activado boolean DEFAULT true NOT NULL
);


--
-- TOC entry 255 (class 1259 OID 46411)
-- Name: tablas_generales_detalle_id_detalle_seq; Type: SEQUENCE; Schema: configuracion; Owner: -
--

CREATE SEQUENCE configuracion.tablas_generales_detalle_id_detalle_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4613 (class 0 OID 0)
-- Dependencies: 255
-- Name: tablas_generales_detalle_id_detalle_seq; Type: SEQUENCE OWNED BY; Schema: configuracion; Owner: -
--

ALTER SEQUENCE configuracion.tablas_generales_detalle_id_detalle_seq OWNED BY configuracion.tablas_generales_detalle.id_detalle;


--
-- TOC entry 256 (class 1259 OID 46412)
-- Name: tablas_generales_id_tabla_seq; Type: SEQUENCE; Schema: configuracion; Owner: -
--

CREATE SEQUENCE configuracion.tablas_generales_id_tabla_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4614 (class 0 OID 0)
-- Dependencies: 256
-- Name: tablas_generales_id_tabla_seq; Type: SEQUENCE OWNED BY; Schema: configuracion; Owner: -
--

ALTER SEQUENCE configuracion.tablas_generales_id_tabla_seq OWNED BY configuracion.tablas_generales.id_tabla;


--
-- TOC entry 343 (class 1259 OID 47695)
-- Name: tipo_afectacion_igv; Type: TABLE; Schema: configuracion; Owner: -
--

CREATE TABLE configuracion.tipo_afectacion_igv (
    id_afectacion bigint NOT NULL,
    codigo character varying(2) NOT NULL,
    nombre character varying(100) NOT NULL,
    afecta_igv boolean NOT NULL,
    es_exportacion boolean DEFAULT false NOT NULL,
    activo boolean DEFAULT true NOT NULL,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp with time zone DEFAULT now() NOT NULL,
    usuario_creacion character varying(50) DEFAULT 'SYSTEM'::character varying NOT NULL,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(50)
);


--
-- TOC entry 342 (class 1259 OID 47694)
-- Name: tipo_afectacion_igv_id_afectacion_seq; Type: SEQUENCE; Schema: configuracion; Owner: -
--

ALTER TABLE configuracion.tipo_afectacion_igv ALTER COLUMN id_afectacion ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME configuracion.tipo_afectacion_igv_id_afectacion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 315 (class 1259 OID 47212)
-- Name: tipo_comprobante; Type: TABLE; Schema: configuracion; Owner: -
--

CREATE TABLE configuracion.tipo_comprobante (
    id_tipo_comprobante bigint NOT NULL,
    codigo character varying(10) NOT NULL,
    nombre character varying(100) NOT NULL,
    mueve_stock boolean DEFAULT false NOT NULL,
    tipo_movimiento_stock character varying(20) DEFAULT 'NEUTRO'::character varying NOT NULL,
    es_venta boolean DEFAULT false NOT NULL,
    es_compra boolean DEFAULT false NOT NULL,
    es_orden_compra boolean DEFAULT false NOT NULL,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_creacion character varying(50) DEFAULT 'SYSTEM'::character varying,
    es_emitible boolean DEFAULT true NOT NULL,
    es_referenciable boolean DEFAULT false NOT NULL,
    movimiento_stock_venta character varying(10) DEFAULT 'NEUTRO'::character varying NOT NULL,
    movimiento_stock_compra character varying(10) DEFAULT 'NEUTRO'::character varying NOT NULL,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(50)
);


--
-- TOC entry 314 (class 1259 OID 47211)
-- Name: tipo_comprobante_id_tipo_comprobante_seq; Type: SEQUENCE; Schema: configuracion; Owner: -
--

ALTER TABLE configuracion.tipo_comprobante ALTER COLUMN id_tipo_comprobante ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME configuracion.tipo_comprobante_id_tipo_comprobante_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 313 (class 1259 OID 47198)
-- Name: tipo_documento; Type: TABLE; Schema: configuracion; Owner: -
--

CREATE TABLE configuracion.tipo_documento (
    id_regla bigint NOT NULL,
    codigo character varying(10) NOT NULL,
    nombre character varying(100) NOT NULL,
    longitud integer DEFAULT 0 NOT NULL,
    longitud_maxima integer,
    es_numerico boolean DEFAULT true NOT NULL,
    estado boolean DEFAULT true NOT NULL,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_creacion character varying(50) DEFAULT 'SYSTEM'::character varying,
    es_persona_natural boolean DEFAULT false NOT NULL,
    es_empresa boolean DEFAULT false NOT NULL,
    aplica_sin_ruc boolean DEFAULT false NOT NULL,
    es_documento_relacionado boolean DEFAULT false NOT NULL,
    es_documento_identidad boolean DEFAULT true NOT NULL,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(50)
);


--
-- TOC entry 312 (class 1259 OID 47197)
-- Name: tipo_documento_id_regla_seq; Type: SEQUENCE; Schema: configuracion; Owner: -
--

ALTER TABLE configuracion.tipo_documento ALTER COLUMN id_regla ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME configuracion.tipo_documento_id_regla_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 317 (class 1259 OID 47228)
-- Name: tipo_operacion_sunat; Type: TABLE; Schema: configuracion; Owner: -
--

CREATE TABLE configuracion.tipo_operacion_sunat (
    id_tipo_operacion integer NOT NULL,
    codigo character varying(4) NOT NULL,
    nombre character varying(200) NOT NULL,
    activado boolean DEFAULT true,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_creacion character varying(100) DEFAULT 'SYSTEM'::character varying,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(50)
);


--
-- TOC entry 316 (class 1259 OID 47227)
-- Name: tipo_operacion_sunat_id_tipo_operacion_seq; Type: SEQUENCE; Schema: configuracion; Owner: -
--

CREATE SEQUENCE configuracion.tipo_operacion_sunat_id_tipo_operacion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4615 (class 0 OID 0)
-- Dependencies: 316
-- Name: tipo_operacion_sunat_id_tipo_operacion_seq; Type: SEQUENCE OWNED BY; Schema: configuracion; Owner: -
--

ALTER SEQUENCE configuracion.tipo_operacion_sunat_id_tipo_operacion_seq OWNED BY configuracion.tipo_operacion_sunat.id_tipo_operacion;


--
-- TOC entry 375 (class 1259 OID 66867)
-- Name: ubigeos; Type: TABLE; Schema: configuracion; Owner: -
--

CREATE TABLE configuracion.ubigeos (
    codigo character varying(6) NOT NULL,
    nombre character varying(100) NOT NULL,
    nivel smallint NOT NULL,
    parent_id character varying(6),
    id bigint NOT NULL,
    activado boolean NOT NULL,
    fecha_creacion timestamp with time zone NOT NULL,
    usuario_creacion character varying(50) NOT NULL,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(50)
);


--
-- TOC entry 257 (class 1259 OID 46413)
-- Name: asientos_contables; Type: TABLE; Schema: contabilidad; Owner: -
--

CREATE TABLE contabilidad.asientos_contables (
    id_asiento bigint NOT NULL,
    fecha_contable date NOT NULL,
    periodo character varying(7) NOT NULL,
    glosa character varying(255) NOT NULL,
    origen_modulo character varying(50) NOT NULL,
    id_origen_referencia bigint,
    total_debe numeric(12,2) DEFAULT 0,
    total_haber numeric(12,2) DEFAULT 0,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion character varying(100),
    id_estado bigint
);


--
-- TOC entry 258 (class 1259 OID 46423)
-- Name: asientos_contables_id_asiento_seq; Type: SEQUENCE; Schema: contabilidad; Owner: -
--

CREATE SEQUENCE contabilidad.asientos_contables_id_asiento_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4616 (class 0 OID 0)
-- Dependencies: 258
-- Name: asientos_contables_id_asiento_seq; Type: SEQUENCE OWNED BY; Schema: contabilidad; Owner: -
--

ALTER SEQUENCE contabilidad.asientos_contables_id_asiento_seq OWNED BY contabilidad.asientos_contables.id_asiento;


--
-- TOC entry 259 (class 1259 OID 46424)
-- Name: centros_costo; Type: TABLE; Schema: contabilidad; Owner: -
--

CREATE TABLE contabilidad.centros_costo (
    id_centro_costo bigint NOT NULL,
    codigo character varying(20) NOT NULL,
    nombre character varying(100) NOT NULL,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion character varying(100)
);


--
-- TOC entry 260 (class 1259 OID 46430)
-- Name: centros_costo_id_centro_costo_seq; Type: SEQUENCE; Schema: contabilidad; Owner: -
--

CREATE SEQUENCE contabilidad.centros_costo_id_centro_costo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4617 (class 0 OID 0)
-- Dependencies: 260
-- Name: centros_costo_id_centro_costo_seq; Type: SEQUENCE OWNED BY; Schema: contabilidad; Owner: -
--

ALTER SEQUENCE contabilidad.centros_costo_id_centro_costo_seq OWNED BY contabilidad.centros_costo.id_centro_costo;


--
-- TOC entry 261 (class 1259 OID 46431)
-- Name: detalle_asiento; Type: TABLE; Schema: contabilidad; Owner: -
--

CREATE TABLE contabilidad.detalle_asiento (
    id_detalle_asiento bigint NOT NULL,
    id_asiento bigint NOT NULL,
    id_cuenta bigint NOT NULL,
    id_centro_costo bigint,
    debe numeric(12,2) DEFAULT 0,
    haber numeric(12,2) DEFAULT 0,
    referencia_doc character varying(50),
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(50)
);


--
-- TOC entry 262 (class 1259 OID 46436)
-- Name: detalle_asiento_id_detalle_asiento_seq; Type: SEQUENCE; Schema: contabilidad; Owner: -
--

CREATE SEQUENCE contabilidad.detalle_asiento_id_detalle_asiento_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4618 (class 0 OID 0)
-- Dependencies: 262
-- Name: detalle_asiento_id_detalle_asiento_seq; Type: SEQUENCE OWNED BY; Schema: contabilidad; Owner: -
--

ALTER SEQUENCE contabilidad.detalle_asiento_id_detalle_asiento_seq OWNED BY contabilidad.detalle_asiento.id_detalle_asiento;


--
-- TOC entry 263 (class 1259 OID 46437)
-- Name: plan_cuentas; Type: TABLE; Schema: contabilidad; Owner: -
--

CREATE TABLE contabilidad.plan_cuentas (
    id_cuenta bigint NOT NULL,
    codigo_cuenta character varying(20) NOT NULL,
    nombre_cuenta character varying(255) NOT NULL,
    nivel integer DEFAULT 1 NOT NULL,
    id_cuenta_padre bigint,
    permite_asientos boolean DEFAULT true,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion character varying(100),
    id_tipo_cuenta bigint
);


--
-- TOC entry 264 (class 1259 OID 46445)
-- Name: plan_cuentas_id_cuenta_seq; Type: SEQUENCE; Schema: contabilidad; Owner: -
--

CREATE SEQUENCE contabilidad.plan_cuentas_id_cuenta_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4619 (class 0 OID 0)
-- Dependencies: 264
-- Name: plan_cuentas_id_cuenta_seq; Type: SEQUENCE OWNED BY; Schema: contabilidad; Owner: -
--

ALTER SEQUENCE contabilidad.plan_cuentas_id_cuenta_seq OWNED BY contabilidad.plan_cuentas.id_cuenta;


--
-- TOC entry 265 (class 1259 OID 46446)
-- Name: areas; Type: TABLE; Schema: identidad; Owner: -
--

CREATE TABLE identidad.areas (
    id_area bigint NOT NULL,
    nombre_area character varying(100) NOT NULL,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion character varying(100)
);


--
-- TOC entry 266 (class 1259 OID 46452)
-- Name: areas_id_area_seq; Type: SEQUENCE; Schema: identidad; Owner: -
--

CREATE SEQUENCE identidad.areas_id_area_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4620 (class 0 OID 0)
-- Dependencies: 266
-- Name: areas_id_area_seq; Type: SEQUENCE OWNED BY; Schema: identidad; Owner: -
--

ALTER SEQUENCE identidad.areas_id_area_seq OWNED BY identidad.areas.id_area;


--
-- TOC entry 267 (class 1259 OID 46453)
-- Name: auditoria_accesos; Type: TABLE; Schema: identidad; Owner: -
--

CREATE TABLE identidad.auditoria_accesos (
    id_auditoria bigint NOT NULL,
    id_usuario bigint NOT NULL,
    ip_origen character varying(50),
    accion character varying(50) NOT NULL,
    detalles text,
    fecha_evento timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- TOC entry 268 (class 1259 OID 46459)
-- Name: auditoria_accesos_id_auditoria_seq; Type: SEQUENCE; Schema: identidad; Owner: -
--

CREATE SEQUENCE identidad.auditoria_accesos_id_auditoria_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4621 (class 0 OID 0)
-- Dependencies: 268
-- Name: auditoria_accesos_id_auditoria_seq; Type: SEQUENCE OWNED BY; Schema: identidad; Owner: -
--

ALTER SEQUENCE identidad.auditoria_accesos_id_auditoria_seq OWNED BY identidad.auditoria_accesos.id_auditoria;


--
-- TOC entry 269 (class 1259 OID 46460)
-- Name: cargos; Type: TABLE; Schema: identidad; Owner: -
--

CREATE TABLE identidad.cargos (
    id_cargo bigint NOT NULL,
    nombre_cargo character varying(100) NOT NULL,
    id_area bigint,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion character varying(100)
);


--
-- TOC entry 270 (class 1259 OID 46466)
-- Name: cargos_id_cargo_seq; Type: SEQUENCE; Schema: identidad; Owner: -
--

CREATE SEQUENCE identidad.cargos_id_cargo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4622 (class 0 OID 0)
-- Dependencies: 270
-- Name: cargos_id_cargo_seq; Type: SEQUENCE OWNED BY; Schema: identidad; Owner: -
--

ALTER SEQUENCE identidad.cargos_id_cargo_seq OWNED BY identidad.cargos.id_cargo;


--
-- TOC entry 271 (class 1259 OID 46467)
-- Name: menus; Type: TABLE; Schema: identidad; Owner: -
--

CREATE TABLE identidad.menus (
    id_menu bigint NOT NULL,
    codigo character varying(50) NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion character varying(255),
    ruta character varying(255),
    icono character varying(50),
    orden integer DEFAULT 0 NOT NULL,
    id_menu_padre bigint,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT now() NOT NULL,
    usuario_creacion character varying(100) DEFAULT 'SYSTEM'::character varying NOT NULL,
    fecha_modificacion timestamp without time zone,
    usuario_modificacion character varying(100)
);


--
-- TOC entry 272 (class 1259 OID 46476)
-- Name: menus_id_menu_seq; Type: SEQUENCE; Schema: identidad; Owner: -
--

CREATE SEQUENCE identidad.menus_id_menu_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4623 (class 0 OID 0)
-- Dependencies: 272
-- Name: menus_id_menu_seq; Type: SEQUENCE OWNED BY; Schema: identidad; Owner: -
--

ALTER SEQUENCE identidad.menus_id_menu_seq OWNED BY identidad.menus.id_menu;


--
-- TOC entry 273 (class 1259 OID 46477)
-- Name: permisos; Type: TABLE; Schema: identidad; Owner: -
--

CREATE TABLE identidad.permisos (
    id_permiso bigint NOT NULL,
    codigo_permiso character varying(100) NOT NULL,
    descripcion character varying(255),
    modulo character varying(50),
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion character varying(100)
);


--
-- TOC entry 274 (class 1259 OID 46485)
-- Name: permisos_id_permiso_seq; Type: SEQUENCE; Schema: identidad; Owner: -
--

CREATE SEQUENCE identidad.permisos_id_permiso_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4624 (class 0 OID 0)
-- Dependencies: 274
-- Name: permisos_id_permiso_seq; Type: SEQUENCE OWNED BY; Schema: identidad; Owner: -
--

ALTER SEQUENCE identidad.permisos_id_permiso_seq OWNED BY identidad.permisos.id_permiso;


--
-- TOC entry 275 (class 1259 OID 46486)
-- Name: roles; Type: TABLE; Schema: identidad; Owner: -
--

CREATE TABLE identidad.roles (
    id_rol bigint NOT NULL,
    nombre_rol character varying(50) NOT NULL,
    descripcion character varying(255),
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion character varying(100)
);


--
-- TOC entry 4625 (class 0 OID 0)
-- Dependencies: 275
-- Name: TABLE roles; Type: COMMENT; Schema: identidad; Owner: -
--

COMMENT ON TABLE identidad.roles IS 'Roles de usuario (ej: Admin, Cajero)';


--
-- TOC entry 276 (class 1259 OID 46494)
-- Name: roles_id_rol_seq; Type: SEQUENCE; Schema: identidad; Owner: -
--

CREATE SEQUENCE identidad.roles_id_rol_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4626 (class 0 OID 0)
-- Dependencies: 276
-- Name: roles_id_rol_seq; Type: SEQUENCE OWNED BY; Schema: identidad; Owner: -
--

ALTER SEQUENCE identidad.roles_id_rol_seq OWNED BY identidad.roles.id_rol;


--
-- TOC entry 277 (class 1259 OID 46495)
-- Name: roles_menus; Type: TABLE; Schema: identidad; Owner: -
--

CREATE TABLE identidad.roles_menus (
    id_rol_menu bigint NOT NULL,
    id_rol bigint NOT NULL,
    id_menu bigint NOT NULL,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT now() NOT NULL,
    usuario_creacion character varying(100) DEFAULT 'SYSTEM'::character varying NOT NULL,
    fecha_modificacion timestamp without time zone,
    usuario_modificacion character varying(100)
);


--
-- TOC entry 278 (class 1259 OID 46501)
-- Name: roles_menus_id_rol_menu_seq; Type: SEQUENCE; Schema: identidad; Owner: -
--

CREATE SEQUENCE identidad.roles_menus_id_rol_menu_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4627 (class 0 OID 0)
-- Dependencies: 278
-- Name: roles_menus_id_rol_menu_seq; Type: SEQUENCE OWNED BY; Schema: identidad; Owner: -
--

ALTER SEQUENCE identidad.roles_menus_id_rol_menu_seq OWNED BY identidad.roles_menus.id_rol_menu;


--
-- TOC entry 279 (class 1259 OID 46502)
-- Name: roles_menus_permisos; Type: TABLE; Schema: identidad; Owner: -
--

CREATE TABLE identidad.roles_menus_permisos (
    id_rol_menu_permiso bigint NOT NULL,
    id_rol_menu bigint NOT NULL,
    id_tipo_permiso bigint NOT NULL,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT now() NOT NULL,
    usuario_creacion character varying(100) DEFAULT 'SYSTEM'::character varying NOT NULL,
    fecha_modificacion timestamp without time zone,
    usuario_modificacion character varying(100)
);


--
-- TOC entry 280 (class 1259 OID 46508)
-- Name: roles_menus_permisos_id_rol_menu_permiso_seq; Type: SEQUENCE; Schema: identidad; Owner: -
--

CREATE SEQUENCE identidad.roles_menus_permisos_id_rol_menu_permiso_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4628 (class 0 OID 0)
-- Dependencies: 280
-- Name: roles_menus_permisos_id_rol_menu_permiso_seq; Type: SEQUENCE OWNED BY; Schema: identidad; Owner: -
--

ALTER SEQUENCE identidad.roles_menus_permisos_id_rol_menu_permiso_seq OWNED BY identidad.roles_menus_permisos.id_rol_menu_permiso;


--
-- TOC entry 281 (class 1259 OID 46509)
-- Name: roles_permisos; Type: TABLE; Schema: identidad; Owner: -
--

CREATE TABLE identidad.roles_permisos (
    id_rol bigint NOT NULL,
    id_permiso bigint NOT NULL,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion character varying(100)
);


--
-- TOC entry 282 (class 1259 OID 46515)
-- Name: tipos_permiso; Type: TABLE; Schema: identidad; Owner: -
--

CREATE TABLE identidad.tipos_permiso (
    id_tipo_permiso bigint NOT NULL,
    codigo character varying(20) NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion character varying(255),
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT now() NOT NULL,
    usuario_creacion character varying(100) DEFAULT 'SYSTEM'::character varying NOT NULL,
    fecha_modificacion timestamp without time zone,
    usuario_modificacion character varying(100)
);


--
-- TOC entry 283 (class 1259 OID 46523)
-- Name: tipos_permiso_id_tipo_permiso_seq; Type: SEQUENCE; Schema: identidad; Owner: -
--

CREATE SEQUENCE identidad.tipos_permiso_id_tipo_permiso_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4629 (class 0 OID 0)
-- Dependencies: 283
-- Name: tipos_permiso_id_tipo_permiso_seq; Type: SEQUENCE OWNED BY; Schema: identidad; Owner: -
--

ALTER SEQUENCE identidad.tipos_permiso_id_tipo_permiso_seq OWNED BY identidad.tipos_permiso.id_tipo_permiso;


--
-- TOC entry 284 (class 1259 OID 46524)
-- Name: trabajadores; Type: TABLE; Schema: identidad; Owner: -
--

CREATE TABLE identidad.trabajadores (
    id_trabajador bigint NOT NULL,
    numero_documento character varying(20) NOT NULL,
    nombres character varying(100) NOT NULL,
    apellidos character varying(100) NOT NULL,
    fecha_nacimiento date,
    telefono character varying(20),
    email_corporativo character varying(100),
    id_cargo bigint,
    id_usuario bigint,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion character varying(100),
    id_tipo_documento bigint
);


--
-- TOC entry 285 (class 1259 OID 46532)
-- Name: trabajadores_id_trabajador_seq; Type: SEQUENCE; Schema: identidad; Owner: -
--

CREATE SEQUENCE identidad.trabajadores_id_trabajador_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4630 (class 0 OID 0)
-- Dependencies: 285
-- Name: trabajadores_id_trabajador_seq; Type: SEQUENCE OWNED BY; Schema: identidad; Owner: -
--

ALTER SEQUENCE identidad.trabajadores_id_trabajador_seq OWNED BY identidad.trabajadores.id_trabajador;


--
-- TOC entry 286 (class 1259 OID 46533)
-- Name: usuarios; Type: TABLE; Schema: identidad; Owner: -
--

CREATE TABLE identidad.usuarios (
    id_usuario bigint NOT NULL,
    username character varying(50) NOT NULL,
    password_hash character varying(255) NOT NULL,
    email character varying(100) NOT NULL,
    nombres character varying(100) NOT NULL,
    apellidos character varying(100) NOT NULL,
    id_rol bigint NOT NULL,
    ultimo_acceso timestamp without time zone,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion character varying(100)
);


--
-- TOC entry 4631 (class 0 OID 0)
-- Dependencies: 286
-- Name: TABLE usuarios; Type: COMMENT; Schema: identidad; Owner: -
--

COMMENT ON TABLE identidad.usuarios IS 'Usuarios del sistema con acceso al backend';


--
-- TOC entry 287 (class 1259 OID 46541)
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE; Schema: identidad; Owner: -
--

CREATE SEQUENCE identidad.usuarios_id_usuario_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4632 (class 0 OID 0)
-- Dependencies: 287
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE OWNED BY; Schema: identidad; Owner: -
--

ALTER SEQUENCE identidad.usuarios_id_usuario_seq OWNED BY identidad.usuarios.id_usuario;


--
-- TOC entry 288 (class 1259 OID 46542)
-- Name: usuarios_roles; Type: TABLE; Schema: identidad; Owner: -
--

CREATE TABLE identidad.usuarios_roles (
    id_usuario_rol bigint NOT NULL,
    id_usuario bigint NOT NULL,
    id_rol bigint NOT NULL,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT now() NOT NULL,
    usuario_creacion character varying(100) DEFAULT 'SYSTEM'::character varying NOT NULL,
    fecha_modificacion timestamp without time zone,
    usuario_modificacion character varying(100)
);


--
-- TOC entry 289 (class 1259 OID 46548)
-- Name: usuarios_roles_id_usuario_rol_seq; Type: SEQUENCE; Schema: identidad; Owner: -
--

CREATE SEQUENCE identidad.usuarios_roles_id_usuario_rol_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4633 (class 0 OID 0)
-- Dependencies: 289
-- Name: usuarios_roles_id_usuario_rol_seq; Type: SEQUENCE OWNED BY; Schema: identidad; Owner: -
--

ALTER SEQUENCE identidad.usuarios_roles_id_usuario_rol_seq OWNED BY identidad.usuarios_roles.id_usuario_rol;


--
-- TOC entry 290 (class 1259 OID 46549)
-- Name: almacenes; Type: TABLE; Schema: inventario; Owner: -
--

CREATE TABLE inventario.almacenes (
    id_almacen bigint NOT NULL,
    nombre_almacen character varying(100) NOT NULL,
    direccion character varying(255),
    es_principal boolean DEFAULT false NOT NULL,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion character varying(100),
    id_sucursal bigint DEFAULT 0 NOT NULL
);


--
-- TOC entry 4634 (class 0 OID 0)
-- Dependencies: 290
-- Name: COLUMN almacenes.id_sucursal; Type: COMMENT; Schema: inventario; Owner: -
--

COMMENT ON COLUMN inventario.almacenes.id_sucursal IS 'ID de la sucursal a la que pertenece el almacÃ©n';


--
-- TOC entry 291 (class 1259 OID 46558)
-- Name: almacenes_id_almacen_seq; Type: SEQUENCE; Schema: inventario; Owner: -
--

CREATE SEQUENCE inventario.almacenes_id_almacen_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4635 (class 0 OID 0)
-- Dependencies: 291
-- Name: almacenes_id_almacen_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: -
--

ALTER SEQUENCE inventario.almacenes_id_almacen_seq OWNED BY inventario.almacenes.id_almacen;


--
-- TOC entry 365 (class 1259 OID 66587)
-- Name: inv_kardex_lote; Type: TABLE; Schema: inventario; Owner: -
--

CREATE TABLE inventario.inv_kardex_lote (
    id bigint NOT NULL,
    producto_id bigint NOT NULL,
    almacen_id bigint NOT NULL,
    fecha_entrada date NOT NULL,
    hora_entrada time without time zone NOT NULL,
    movimiento_origen_id bigint NOT NULL,
    costo_unitario numeric(18,6) NOT NULL,
    cantidad_original numeric(18,6) NOT NULL,
    cantidad_disponible numeric(18,6) NOT NULL,
    estado character varying(1) DEFAULT 'A'::character varying NOT NULL,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT now() NOT NULL,
    usuario_creacion character varying(50) DEFAULT 'SYSTEM'::character varying NOT NULL,
    fecha_modificacion timestamp without time zone,
    usuario_modificacion character varying(50)
);


--
-- TOC entry 364 (class 1259 OID 66586)
-- Name: inv_kardex_lote_id_seq; Type: SEQUENCE; Schema: inventario; Owner: -
--

CREATE SEQUENCE inventario.inv_kardex_lote_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4636 (class 0 OID 0)
-- Dependencies: 364
-- Name: inv_kardex_lote_id_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: -
--

ALTER SEQUENCE inventario.inv_kardex_lote_id_seq OWNED BY inventario.inv_kardex_lote.id;


--
-- TOC entry 367 (class 1259 OID 66598)
-- Name: inv_kardex_movimiento; Type: TABLE; Schema: inventario; Owner: -
--

CREATE TABLE inventario.inv_kardex_movimiento (
    id bigint NOT NULL,
    uuid character varying(36) NOT NULL,
    periodo character varying(7) NOT NULL,
    correlativo_kardex bigint NOT NULL,
    fecha_movimiento date NOT NULL,
    hora_movimiento time without time zone NOT NULL,
    fecha_hora_compuesta timestamp without time zone NOT NULL,
    modulo_origen character varying(30) NOT NULL,
    tipo_documento character varying(2) NOT NULL,
    serie_documento character varying(10) NOT NULL,
    numero_documento character varying(20) NOT NULL,
    anulado boolean DEFAULT false NOT NULL,
    fecha_anulacion date,
    motivo_anulacion text,
    tipo_operacion character varying(1) NOT NULL,
    motivo_traslado_sunat character varying(4) NOT NULL,
    descripcion_movimiento character varying(255) NOT NULL,
    almacen_id bigint NOT NULL,
    almacen_origen_id bigint,
    almacen_destino_id bigint,
    producto_id bigint NOT NULL,
    unidad_medida_codigo character varying(10) NOT NULL,
    factor_conversion numeric(18,6) NOT NULL,
    entrada_cantidad numeric(18,6),
    entrada_costo_unitario numeric(18,6),
    entrada_costo_total numeric(18,6),
    salida_cantidad numeric(18,6),
    salida_costo_unitario numeric(18,6),
    salida_costo_total numeric(18,6),
    saldo_cantidad numeric(18,6) NOT NULL,
    saldo_costo_unitario numeric(18,6) NOT NULL,
    saldo_costo_total numeric(18,6) NOT NULL,
    referencia_id bigint,
    referencia_tipo character varying(50),
    lote_id bigint,
    proveedor_cliente_id bigint,
    observaciones text,
    usuario_registro_id bigint NOT NULL,
    usuario_anulacion_id bigint,
    recalculado_at timestamp without time zone,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT now() NOT NULL,
    usuario_creacion character varying(50) DEFAULT 'SYSTEM'::character varying NOT NULL,
    fecha_modificacion timestamp without time zone,
    usuario_modificacion character varying(50)
);


--
-- TOC entry 366 (class 1259 OID 66597)
-- Name: inv_kardex_movimiento_id_seq; Type: SEQUENCE; Schema: inventario; Owner: -
--

CREATE SEQUENCE inventario.inv_kardex_movimiento_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4637 (class 0 OID 0)
-- Dependencies: 366
-- Name: inv_kardex_movimiento_id_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: -
--

ALTER SEQUENCE inventario.inv_kardex_movimiento_id_seq OWNED BY inventario.inv_kardex_movimiento.id;


--
-- TOC entry 368 (class 1259 OID 66610)
-- Name: inv_kardex_periodo_control; Type: TABLE; Schema: inventario; Owner: -
--

CREATE TABLE inventario.inv_kardex_periodo_control (
    periodo character varying(7) NOT NULL,
    estado character varying(1) DEFAULT 'A'::character varying NOT NULL,
    fecha_cierre date,
    usuario_cierre_id bigint,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(50)
);


--
-- TOC entry 370 (class 1259 OID 66618)
-- Name: inv_kardex_recalculo_log; Type: TABLE; Schema: inventario; Owner: -
--

CREATE TABLE inventario.inv_kardex_recalculo_log (
    id bigint NOT NULL,
    almacen_id integer NOT NULL,
    producto_id integer NOT NULL,
    desde_fecha date NOT NULL,
    motivo character varying(30) NOT NULL,
    registros_afect integer NOT NULL,
    usuario_id integer NOT NULL,
    duracion_ms integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(50)
);


--
-- TOC entry 369 (class 1259 OID 66617)
-- Name: inv_kardex_recalculo_log_id_seq; Type: SEQUENCE; Schema: inventario; Owner: -
--

CREATE SEQUENCE inventario.inv_kardex_recalculo_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4638 (class 0 OID 0)
-- Dependencies: 369
-- Name: inv_kardex_recalculo_log_id_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: -
--

ALTER SEQUENCE inventario.inv_kardex_recalculo_log_id_seq OWNED BY inventario.inv_kardex_recalculo_log.id;


--
-- TOC entry 292 (class 1259 OID 46559)
-- Name: movimientos_inventario; Type: TABLE; Schema: inventario; Owner: -
--

CREATE TABLE inventario.movimientos_inventario (
    id_movimiento bigint NOT NULL,
    id_stock bigint NOT NULL,
    cantidad numeric(10,3) NOT NULL,
    cantidad_anterior numeric(10,3) NOT NULL,
    cantidad_nueva numeric(10,3) NOT NULL,
    costo_unitario_movimiento numeric(12,4),
    referencia_modulo character varying(50),
    id_referencia bigint,
    observaciones text,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    id_tipo_movimiento bigint,
    saldo_cantidad numeric(10,3) DEFAULT 0,
    saldo_valorizado numeric(12,2) DEFAULT 0,
    costo_promedio_actual numeric(12,4) DEFAULT 0,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(50)
);


--
-- TOC entry 4639 (class 0 OID 0)
-- Dependencies: 292
-- Name: COLUMN movimientos_inventario.saldo_cantidad; Type: COMMENT; Schema: inventario; Owner: -
--

COMMENT ON COLUMN inventario.movimientos_inventario.saldo_cantidad IS 'Cantidad acumulada en stock luego del movimiento';


--
-- TOC entry 4640 (class 0 OID 0)
-- Dependencies: 292
-- Name: COLUMN movimientos_inventario.saldo_valorizado; Type: COMMENT; Schema: inventario; Owner: -
--

COMMENT ON COLUMN inventario.movimientos_inventario.saldo_valorizado IS 'Valor monetario acumulado del stock luego del movimiento';


--
-- TOC entry 4641 (class 0 OID 0)
-- Dependencies: 292
-- Name: COLUMN movimientos_inventario.costo_promedio_actual; Type: COMMENT; Schema: inventario; Owner: -
--

COMMENT ON COLUMN inventario.movimientos_inventario.costo_promedio_actual IS 'Costo promedio ponderado calculado al momento del movimiento';


--
-- TOC entry 293 (class 1259 OID 46565)
-- Name: movimientos_inventario_id_movimiento_seq; Type: SEQUENCE; Schema: inventario; Owner: -
--

CREATE SEQUENCE inventario.movimientos_inventario_id_movimiento_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4642 (class 0 OID 0)
-- Dependencies: 293
-- Name: movimientos_inventario_id_movimiento_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: -
--

ALTER SEQUENCE inventario.movimientos_inventario_id_movimiento_seq OWNED BY inventario.movimientos_inventario.id_movimiento;


--
-- TOC entry 294 (class 1259 OID 46566)
-- Name: stock; Type: TABLE; Schema: inventario; Owner: -
--

CREATE TABLE inventario.stock (
    id_stock bigint NOT NULL,
    id_producto bigint NOT NULL,
    id_variante bigint,
    id_almacen bigint NOT NULL,
    cantidad_actual numeric(10,3) DEFAULT 0 NOT NULL,
    cantidad_reservada numeric(10,3) DEFAULT 0,
    ubicacion_fisica character varying(50),
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion character varying(100),
    costo_promedio numeric(12,4) DEFAULT 0,
    valor_total numeric(12,2) DEFAULT 0,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_creacion character varying(100) DEFAULT 'SYSTEM'::character varying
);


--
-- TOC entry 295 (class 1259 OID 46572)
-- Name: stock_id_stock_seq; Type: SEQUENCE; Schema: inventario; Owner: -
--

CREATE SEQUENCE inventario.stock_id_stock_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4643 (class 0 OID 0)
-- Dependencies: 295
-- Name: stock_id_stock_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: -
--

ALTER SEQUENCE inventario.stock_id_stock_seq OWNED BY inventario.stock.id_stock;


--
-- TOC entry 337 (class 1259 OID 47568)
-- Name: traslados; Type: TABLE; Schema: inventario; Owner: -
--

CREATE TABLE inventario.traslados (
    id_traslado integer NOT NULL,
    numero_traslado character varying(20) NOT NULL,
    almacen_origen_id bigint NOT NULL,
    almacen_destino_id bigint NOT NULL,
    fecha_pedido timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_despacho timestamp without time zone,
    fecha_recepcion timestamp without time zone,
    gr_serie character varying(10),
    gr_numero character varying(20),
    estado character varying(20) DEFAULT 'PENDIENTE'::character varying,
    id_usuario_despacho bigint,
    id_usuario_recepcion bigint,
    observaciones text,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(50)
);


--
-- TOC entry 339 (class 1259 OID 47581)
-- Name: traslados_detalle; Type: TABLE; Schema: inventario; Owner: -
--

CREATE TABLE inventario.traslados_detalle (
    id_detalle_traslado integer NOT NULL,
    id_traslado integer,
    id_producto bigint NOT NULL,
    cantidad_solicitada numeric(18,6) NOT NULL,
    cantidad_despachada numeric(18,6) DEFAULT 0,
    cantidad_recibida numeric(18,6) DEFAULT 0,
    costo_unitario_despacho numeric(18,6),
    observaciones text,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(50)
);


--
-- TOC entry 338 (class 1259 OID 47580)
-- Name: traslados_detalle_id_detalle_traslado_seq; Type: SEQUENCE; Schema: inventario; Owner: -
--

CREATE SEQUENCE inventario.traslados_detalle_id_detalle_traslado_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4644 (class 0 OID 0)
-- Dependencies: 338
-- Name: traslados_detalle_id_detalle_traslado_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: -
--

ALTER SEQUENCE inventario.traslados_detalle_id_detalle_traslado_seq OWNED BY inventario.traslados_detalle.id_detalle_traslado;


--
-- TOC entry 336 (class 1259 OID 47567)
-- Name: traslados_id_traslado_seq; Type: SEQUENCE; Schema: inventario; Owner: -
--

CREATE SEQUENCE inventario.traslados_id_traslado_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4645 (class 0 OID 0)
-- Dependencies: 336
-- Name: traslados_id_traslado_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: -
--

ALTER SEQUENCE inventario.traslados_id_traslado_seq OWNED BY inventario.traslados.id_traslado;


--
-- TOC entry 341 (class 1259 OID 47597)
-- Name: traslados_incidencias; Type: TABLE; Schema: inventario; Owner: -
--

CREATE TABLE inventario.traslados_incidencias (
    id_incidencia integer NOT NULL,
    id_detalle_traslado integer,
    tipo_incidencia character varying(20),
    cantidad numeric(18,6) NOT NULL,
    descripcion text,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(50)
);


--
-- TOC entry 340 (class 1259 OID 47596)
-- Name: traslados_incidencias_id_incidencia_seq; Type: SEQUENCE; Schema: inventario; Owner: -
--

CREATE SEQUENCE inventario.traslados_incidencias_id_incidencia_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4646 (class 0 OID 0)
-- Dependencies: 340
-- Name: traslados_incidencias_id_incidencia_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: -
--

ALTER SEQUENCE inventario.traslados_incidencias_id_incidencia_seq OWNED BY inventario.traslados_incidencias.id_incidencia;


--
-- TOC entry 218 (class 1259 OID 16755)
-- Name: __EFMigrationsHistory; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."__EFMigrationsHistory" (
    migration_id character varying(150) NOT NULL,
    product_version character varying(32) NOT NULL
);


--
-- TOC entry 357 (class 1259 OID 62619)
-- Name: categorias; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categorias (
    "Id" integer NOT NULL,
    "Nombre" character varying(100) NOT NULL,
    "Descripcion" text,
    "ImagenUrl" text,
    "IdCategoriaPadre" integer,
    "Activado" boolean NOT NULL,
    "FechaCreacion" timestamp with time zone NOT NULL,
    "UsuarioCreacion" text NOT NULL,
    "FechaActualizacion" timestamp with time zone,
    "UsuarioActualizacion" text,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(50)
);


--
-- TOC entry 356 (class 1259 OID 62618)
-- Name: categorias_Id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.categorias ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."categorias_Id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 359 (class 1259 OID 62632)
-- Name: marcas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.marcas (
    "Id" integer NOT NULL,
    "Nombre" character varying(100) NOT NULL,
    "PaisOrigen" text,
    "Activado" boolean NOT NULL,
    "FechaCreacion" timestamp with time zone NOT NULL,
    "UsuarioCreacion" text NOT NULL,
    "FechaActualizacion" timestamp with time zone,
    "UsuarioActualizacion" text,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(50)
);


--
-- TOC entry 358 (class 1259 OID 62631)
-- Name: marcas_Id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.marcas ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."marcas_Id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 363 (class 1259 OID 62648)
-- Name: productos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.productos (
    "Id" integer NOT NULL,
    "CodigoProducto" character varying(50) NOT NULL,
    "CodigoBarras" text,
    "Sku" character varying(100),
    "NombreProducto" character varying(255) NOT NULL,
    "Descripcion" text,
    "ImagenUrl" text,
    "IdCategoria" integer NOT NULL,
    "IdMarca" integer NOT NULL,
    "IdUnidadMedida" integer NOT NULL,
    "PrecioCompra" numeric(12,2) NOT NULL,
    "PrecioVentaPublico" numeric(12,2) NOT NULL,
    "PrecioVentaMayorista" numeric(12,2) NOT NULL,
    "PrecioVentaDistribuidor" numeric(12,2) NOT NULL,
    "TieneVariantes" boolean NOT NULL,
    "PermiteInventarioNegativo" boolean NOT NULL,
    "GravadoImpuesto" boolean NOT NULL,
    "PorcentajeImpuesto" numeric(5,2) NOT NULL,
    "TipoProducto" text NOT NULL,
    "StockMinimo" numeric(10,3) NOT NULL,
    "StockMaximo" numeric(10,3) NOT NULL,
    "Activado" boolean NOT NULL,
    "FechaCreacion" timestamp with time zone NOT NULL,
    "UsuarioCreacion" text NOT NULL,
    "FechaActualizacion" timestamp with time zone,
    "UsuarioActualizacion" text,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(50)
);


--
-- TOC entry 362 (class 1259 OID 62647)
-- Name: productos_Id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.productos ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."productos_Id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 361 (class 1259 OID 62640)
-- Name: unidades_medida; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.unidades_medida (
    "Id" integer NOT NULL,
    "CodigoSunat" text NOT NULL,
    "Nombre" character varying(50) NOT NULL,
    "Simbolo" character varying(10) NOT NULL,
    "Activado" boolean NOT NULL,
    "FechaCreacion" timestamp with time zone NOT NULL,
    "UsuarioCreacion" text NOT NULL,
    "FechaActualizacion" timestamp with time zone,
    "UsuarioActualizacion" text,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(50)
);


--
-- TOC entry 360 (class 1259 OID 62639)
-- Name: unidades_medida_Id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.unidades_medida ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."unidades_medida_Id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 296 (class 1259 OID 46573)
-- Name: cajas; Type: TABLE; Schema: ventas; Owner: -
--

CREATE TABLE ventas.cajas (
    id_caja bigint NOT NULL,
    nombre_caja character varying(50) NOT NULL,
    id_almacen bigint NOT NULL,
    monto_apertura numeric(12,2) DEFAULT 0,
    monto_actual numeric(12,2) DEFAULT 0,
    fecha_apertura timestamp without time zone,
    fecha_cierre timestamp without time zone,
    id_usuario_cajero bigint,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion character varying(100),
    id_estado bigint
);


--
-- TOC entry 297 (class 1259 OID 46581)
-- Name: cajas_id_caja_seq; Type: SEQUENCE; Schema: ventas; Owner: -
--

CREATE SEQUENCE ventas.cajas_id_caja_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4647 (class 0 OID 0)
-- Dependencies: 297
-- Name: cajas_id_caja_seq; Type: SEQUENCE OWNED BY; Schema: ventas; Owner: -
--

ALTER SEQUENCE ventas.cajas_id_caja_seq OWNED BY ventas.cajas.id_caja;


--
-- TOC entry 298 (class 1259 OID 46582)
-- Name: cotizaciones; Type: TABLE; Schema: ventas; Owner: -
--

CREATE TABLE ventas.cotizaciones (
    id_cotizacion bigint NOT NULL,
    serie character varying(4) NOT NULL,
    numero bigint NOT NULL,
    id_cliente bigint NOT NULL,
    id_usuario_vendedor bigint NOT NULL,
    fecha_emision date NOT NULL,
    fecha_vencimiento date NOT NULL,
    moneda character varying(3) DEFAULT 'PEN'::character varying,
    tipo_cambio numeric(10,4) DEFAULT 1,
    subtotal numeric(12,2) DEFAULT 0,
    impuesto numeric(12,2) DEFAULT 0,
    total numeric(12,2) DEFAULT 0,
    observaciones text,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion character varying(100),
    id_estado bigint
);


--
-- TOC entry 299 (class 1259 OID 46595)
-- Name: cotizaciones_id_cotizacion_seq; Type: SEQUENCE; Schema: ventas; Owner: -
--

CREATE SEQUENCE ventas.cotizaciones_id_cotizacion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4648 (class 0 OID 0)
-- Dependencies: 299
-- Name: cotizaciones_id_cotizacion_seq; Type: SEQUENCE OWNED BY; Schema: ventas; Owner: -
--

ALTER SEQUENCE ventas.cotizaciones_id_cotizacion_seq OWNED BY ventas.cotizaciones.id_cotizacion;


--
-- TOC entry 300 (class 1259 OID 46596)
-- Name: detalle_cotizacion; Type: TABLE; Schema: ventas; Owner: -
--

CREATE TABLE ventas.detalle_cotizacion (
    id_detalle_cot bigint NOT NULL,
    id_cotizacion bigint NOT NULL,
    id_producto bigint NOT NULL,
    id_variante bigint,
    cantidad numeric(10,3) NOT NULL,
    precio_unitario numeric(12,2) NOT NULL,
    porcentaje_descuento numeric(5,2) DEFAULT 0,
    monto_descuento numeric(12,2) DEFAULT 0,
    subtotal numeric(12,2) NOT NULL,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(50)
);


--
-- TOC entry 301 (class 1259 OID 46601)
-- Name: detalle_cotizacion_id_detalle_cot_seq; Type: SEQUENCE; Schema: ventas; Owner: -
--

CREATE SEQUENCE ventas.detalle_cotizacion_id_detalle_cot_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4649 (class 0 OID 0)
-- Dependencies: 301
-- Name: detalle_cotizacion_id_detalle_cot_seq; Type: SEQUENCE OWNED BY; Schema: ventas; Owner: -
--

ALTER SEQUENCE ventas.detalle_cotizacion_id_detalle_cot_seq OWNED BY ventas.detalle_cotizacion.id_detalle_cot;


--
-- TOC entry 333 (class 1259 OID 47543)
-- Name: detalle_notas; Type: TABLE; Schema: ventas; Owner: -
--

CREATE TABLE ventas.detalle_notas (
    id_detalle_nota bigint NOT NULL,
    id_nota bigint NOT NULL,
    id_producto bigint NOT NULL,
    id_variante bigint,
    cantidad numeric(10,3) NOT NULL,
    precio_unitario numeric(12,2) NOT NULL,
    impuesto_item numeric(12,2) NOT NULL,
    total_item numeric(12,2) NOT NULL,
    activado boolean DEFAULT true NOT NULL,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(50)
);


--
-- TOC entry 332 (class 1259 OID 47542)
-- Name: detalle_notas_id_detalle_nota_seq; Type: SEQUENCE; Schema: ventas; Owner: -
--

ALTER TABLE ventas.detalle_notas ALTER COLUMN id_detalle_nota ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME ventas.detalle_notas_id_detalle_nota_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 302 (class 1259 OID 46602)
-- Name: detalle_venta; Type: TABLE; Schema: ventas; Owner: -
--

CREATE TABLE ventas.detalle_venta (
    id_detalle_venta bigint NOT NULL,
    id_venta bigint NOT NULL,
    id_producto bigint NOT NULL,
    id_variante bigint,
    descripcion_producto character varying(255),
    cantidad numeric(10,3) NOT NULL,
    precio_unitario numeric(12,2) NOT NULL,
    precio_lista_original numeric(12,2),
    porcentaje_impuesto numeric(5,2) DEFAULT 18.0,
    impuesto_item numeric(12,2) DEFAULT 0,
    total_item numeric(12,2) NOT NULL,
    codigo_afectacion_igv character varying(2),
    codigo_tributo character varying(4),
    precio_unitario_base numeric(12,4),
    descuento_item numeric(12,4) DEFAULT 0,
    valor_item numeric(12,4),
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_creacion character varying(100) DEFAULT 'SYSTEM'::character varying,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion character varying(100),
    activado boolean DEFAULT true NOT NULL
);


--
-- TOC entry 4650 (class 0 OID 0)
-- Dependencies: 302
-- Name: COLUMN detalle_venta.codigo_afectacion_igv; Type: COMMENT; Schema: ventas; Owner: -
--

COMMENT ON COLUMN ventas.detalle_venta.codigo_afectacion_igv IS 'Código SUNAT de afectación (10, 20, 30, etc)';


--
-- TOC entry 4651 (class 0 OID 0)
-- Dependencies: 302
-- Name: COLUMN detalle_venta.codigo_tributo; Type: COMMENT; Schema: ventas; Owner: -
--

COMMENT ON COLUMN ventas.detalle_venta.codigo_tributo IS 'Código SUNAT del tributo (1000 IGV, 9997 EXONERADO, etc)';


--
-- TOC entry 303 (class 1259 OID 46607)
-- Name: detalle_venta_id_detalle_venta_seq; Type: SEQUENCE; Schema: ventas; Owner: -
--

CREATE SEQUENCE ventas.detalle_venta_id_detalle_venta_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4652 (class 0 OID 0)
-- Dependencies: 303
-- Name: detalle_venta_id_detalle_venta_seq; Type: SEQUENCE OWNED BY; Schema: ventas; Owner: -
--

ALTER SEQUENCE ventas.detalle_venta_id_detalle_venta_seq OWNED BY ventas.detalle_venta.id_detalle_venta;


--
-- TOC entry 304 (class 1259 OID 46608)
-- Name: metodos_pago; Type: TABLE; Schema: ventas; Owner: -
--

CREATE TABLE ventas.metodos_pago (
    id_metodo_pago bigint NOT NULL,
    codigo character varying(20) NOT NULL,
    nombre character varying(50) NOT NULL,
    requiere_referencia boolean DEFAULT false,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion character varying(100)
);


--
-- TOC entry 305 (class 1259 OID 46615)
-- Name: metodos_pago_id_metodo_pago_seq; Type: SEQUENCE; Schema: ventas; Owner: -
--

CREATE SEQUENCE ventas.metodos_pago_id_metodo_pago_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4653 (class 0 OID 0)
-- Dependencies: 305
-- Name: metodos_pago_id_metodo_pago_seq; Type: SEQUENCE OWNED BY; Schema: ventas; Owner: -
--

ALTER SEQUENCE ventas.metodos_pago_id_metodo_pago_seq OWNED BY ventas.metodos_pago.id_metodo_pago;


--
-- TOC entry 306 (class 1259 OID 46616)
-- Name: movimientos_caja; Type: TABLE; Schema: ventas; Owner: -
--

CREATE TABLE ventas.movimientos_caja (
    id_movimiento_caja bigint NOT NULL,
    id_caja bigint NOT NULL,
    monto numeric(12,2) NOT NULL,
    concepto character varying(255) NOT NULL,
    id_pago_relacionado bigint,
    fecha_movimiento timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_responsable character varying(100) NOT NULL,
    id_tipo_movimiento bigint,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(50)
);


--
-- TOC entry 307 (class 1259 OID 46620)
-- Name: movimientos_caja_id_movimiento_caja_seq; Type: SEQUENCE; Schema: ventas; Owner: -
--

CREATE SEQUENCE ventas.movimientos_caja_id_movimiento_caja_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4654 (class 0 OID 0)
-- Dependencies: 307
-- Name: movimientos_caja_id_movimiento_caja_seq; Type: SEQUENCE OWNED BY; Schema: ventas; Owner: -
--

ALTER SEQUENCE ventas.movimientos_caja_id_movimiento_caja_seq OWNED BY ventas.movimientos_caja.id_movimiento_caja;


--
-- TOC entry 323 (class 1259 OID 47262)
-- Name: notas; Type: TABLE; Schema: ventas; Owner: -
--

CREATE TABLE ventas.notas (
    id_nota bigint NOT NULL,
    id_venta_referencia bigint,
    id_tipo_nota bigint,
    id_tipo_comprobante bigint,
    serie character varying(4),
    numero bigint,
    fecha_emision timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    motivo_sustento text,
    total_nota numeric(12,2),
    activado boolean DEFAULT true,
    codigo_tipo_comprobante_ref character varying(10),
    serie_ref character varying(10),
    numero_ref character varying(20),
    codigo_motivo character varying(2),
    descripcion_motivo character varying(200),
    codigo_motivo_nc character varying(2),
    codigo_motivo_nd character varying(2),
    id_tipo_doc_ref character varying(4),
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(50)
);


--
-- TOC entry 322 (class 1259 OID 47261)
-- Name: notas_id_nota_seq; Type: SEQUENCE; Schema: ventas; Owner: -
--

ALTER TABLE ventas.notas ALTER COLUMN id_nota ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME ventas.notas_id_nota_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 308 (class 1259 OID 46621)
-- Name: pagos; Type: TABLE; Schema: ventas; Owner: -
--

CREATE TABLE ventas.pagos (
    id_pago bigint NOT NULL,
    id_venta bigint NOT NULL,
    id_metodo_pago bigint NOT NULL,
    monto_pago numeric(12,2) NOT NULL,
    referencia_pago character varying(100),
    fecha_pago timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(50)
);


--
-- TOC entry 309 (class 1259 OID 46627)
-- Name: pagos_id_pago_seq; Type: SEQUENCE; Schema: ventas; Owner: -
--

CREATE SEQUENCE ventas.pagos_id_pago_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4655 (class 0 OID 0)
-- Dependencies: 309
-- Name: pagos_id_pago_seq; Type: SEQUENCE OWNED BY; Schema: ventas; Owner: -
--

ALTER SEQUENCE ventas.pagos_id_pago_seq OWNED BY ventas.pagos.id_pago;


--
-- TOC entry 310 (class 1259 OID 46628)
-- Name: ventas; Type: TABLE; Schema: ventas; Owner: -
--

CREATE TABLE ventas.ventas (
    id_venta bigint NOT NULL,
    id_empresa bigint DEFAULT 1 NOT NULL,
    id_almacen bigint NOT NULL,
    id_caja bigint,
    id_cliente bigint NOT NULL,
    id_usuario_vendedor bigint NOT NULL,
    id_cotizacion_origen bigint,
    serie character varying(4) NOT NULL,
    numero bigint NOT NULL,
    fecha_emision timestamp without time zone NOT NULL,
    fecha_vencimiento_pago date,
    moneda character varying(3) DEFAULT 'PEN'::character varying,
    tipo_cambio numeric(10,4) DEFAULT 1.0,
    subtotal_gravado numeric(12,2) DEFAULT 0,
    subtotal_exonerado numeric(12,2) DEFAULT 0,
    subtotal_inafecto numeric(12,2) DEFAULT 0,
    total_impuesto numeric(12,2) DEFAULT 0,
    total_descuento_global numeric(12,2) DEFAULT 0,
    total_venta numeric(12,2) NOT NULL,
    saldo_pendiente numeric(12,2) DEFAULT 0,
    observaciones text,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion character varying(100),
    id_estado bigint,
    id_estado_pago bigint,
    id_tipo_comprobante bigint
);


--
-- TOC entry 311 (class 1259 OID 46645)
-- Name: ventas_id_venta_seq; Type: SEQUENCE; Schema: ventas; Owner: -
--

CREATE SEQUENCE ventas.ventas_id_venta_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4656 (class 0 OID 0)
-- Dependencies: 311
-- Name: ventas_id_venta_seq; Type: SEQUENCE OWNED BY; Schema: ventas; Owner: -
--

ALTER SEQUENCE ventas.ventas_id_venta_seq OWNED BY ventas.ventas.id_venta;


--
-- TOC entry 353 (class 1259 OID 47770)
-- Name: vw_caja_movimientos; Type: VIEW; Schema: vistas; Owner: -
--

CREATE VIEW vistas.vw_caja_movimientos AS
 SELECT m.id_movimiento_caja,
    m.fecha_movimiento,
    c.nombre_caja,
    tm.nombre AS tipo_movimiento,
    m.concepto,
    m.monto,
    'PEN'::text AS moneda,
    NULL::text AS referencia_comprobante,
    m.usuario_responsable AS nombre_usuario
   FROM ((ventas.movimientos_caja m
     JOIN ventas.cajas c ON ((m.id_caja = c.id_caja)))
     LEFT JOIN configuracion.tablas_generales_detalle tm ON ((m.id_tipo_movimiento = tm.id_detalle)));


--
-- TOC entry 349 (class 1259 OID 47750)
-- Name: vw_detalle_venta; Type: VIEW; Schema: vistas; Owner: -
--

CREATE VIEW vistas.vw_detalle_venta AS
 SELECT d.id_detalle_venta,
    d.id_venta,
    p.id_producto,
    p.codigo_producto,
    d.descripcion_producto,
    um.codigo_sunat AS codigo_unidad_medida,
    um.simbolo AS simbolo_unidad,
    d.cantidad,
    d.precio_unitario_base,
    d.precio_unitario AS precio_unitario_con_igv,
    d.descuento_item,
    d.valor_item,
    ta.codigo AS codigo_afectacion_igv,
    ta.nombre AS nombre_afectacion_igv,
    d.codigo_tributo,
    d.porcentaje_impuesto AS porcentaje_igv,
    d.impuesto_item,
    d.total_item
   FROM (((ventas.detalle_venta d
     JOIN catalogo.productos p ON ((d.id_producto = p.id_producto)))
     JOIN catalogo.unidades_medida um ON ((p.id_unidad = um.id_unidad)))
     LEFT JOIN configuracion.tipo_afectacion_igv ta ON (((d.codigo_afectacion_igv)::text = (ta.codigo)::text)));


--
-- TOC entry 351 (class 1259 OID 47760)
-- Name: vw_kardex_movimientos; Type: VIEW; Schema: vistas; Owner: -
--

CREATE VIEW vistas.vw_kardex_movimientos AS
 SELECT m.id_movimiento,
    m.fecha_creacion AS fecha_movimiento,
    p.codigo_producto,
    p.nombre_producto AS descripcion_producto,
    a.nombre_almacen,
    tm.nombre AS tipo_operacion,
    m.referencia_modulo AS tipo_documento_origen,
    (m.id_referencia)::text AS numero_documento,
    m.cantidad,
    m.costo_unitario_movimiento AS costo_unitario,
    (m.cantidad * m.costo_unitario_movimiento) AS costo_total,
    m.cantidad_nueva AS saldo_cantidad,
    m.observaciones
   FROM ((((inventario.movimientos_inventario m
     JOIN inventario.stock s ON ((m.id_stock = s.id_stock)))
     JOIN catalogo.productos p ON ((s.id_producto = p.id_producto)))
     JOIN inventario.almacenes a ON ((s.id_almacen = a.id_almacen)))
     LEFT JOIN configuracion.tablas_generales_detalle tm ON ((m.id_tipo_movimiento = tm.id_detalle)));


--
-- TOC entry 350 (class 1259 OID 47755)
-- Name: vw_lista_compras; Type: VIEW; Schema: vistas; Owner: -
--

CREATE VIEW vistas.vw_lista_compras AS
 SELECT c.id_compra,
    c.serie_comprobante,
    c.numero_comprobante,
    c.fecha_emision,
    tc.nombre AS nombre_tipo_comprobante,
    p.numero_documento AS numero_documento_proveedor,
    p.razon_social AS razon_social_proveedor,
    c.subtotal,
    c.impuesto AS igv,
    c.total,
    c.moneda,
    a.nombre_almacen AS nombre_almacen_destino,
    (c.id_orden_compra_ref IS NOT NULL) AS tiene_orden_compra_vinculada
   FROM (((compras.compras c
     JOIN compras.proveedores p ON ((c.id_proveedor = p.id_proveedor)))
     JOIN configuracion.tipo_comprobante tc ON ((c.id_tipo_comprobante = tc.id_tipo_comprobante)))
     JOIN inventario.almacenes a ON ((c.id_almacen = a.id_almacen)));


--
-- TOC entry 348 (class 1259 OID 47745)
-- Name: vw_lista_ventas; Type: VIEW; Schema: vistas; Owner: -
--

CREATE VIEW vistas.vw_lista_ventas AS
 SELECT v.id_venta,
    v.serie,
    v.numero,
    v.fecha_emision,
    tc.codigo AS codigo_tipo_comprobante,
    tc.nombre AS nombre_tipo_comprobante,
    c.numero_documento AS numero_documento_cliente,
    c.razon_social AS razon_social_cliente,
    ((v.subtotal_gravado + v.subtotal_exonerado) + v.subtotal_inafecto) AS subtotal,
    v.total_impuesto AS igv,
    v.total_venta AS total,
    v.moneda,
    eg.nombre AS estado_venta,
    v.usuario_creacion AS nombre_usuario_creacion,
    (EXISTS ( SELECT 1
           FROM (ventas.notas n
             JOIN configuracion.tipo_comprobante tcn ON ((n.id_tipo_comprobante = tcn.id_tipo_comprobante)))
          WHERE ((n.id_venta_referencia = v.id_venta) AND ((tcn.codigo)::text = '07'::text)))) AS tiene_nota_credito,
    (EXISTS ( SELECT 1
           FROM (ventas.notas n
             JOIN configuracion.tipo_comprobante tcn ON ((n.id_tipo_comprobante = tcn.id_tipo_comprobante)))
          WHERE ((n.id_venta_referencia = v.id_venta) AND ((tcn.codigo)::text = '08'::text)))) AS tiene_nota_debito
   FROM (((ventas.ventas v
     JOIN clientes.clientes c ON ((v.id_cliente = c.id_cliente)))
     JOIN configuracion.tipo_comprobante tc ON ((v.id_tipo_comprobante = tc.id_tipo_comprobante)))
     LEFT JOIN configuracion.tablas_generales_detalle eg ON ((v.id_estado = eg.id_detalle)));


--
-- TOC entry 354 (class 1259 OID 47775)
-- Name: vw_notas_credito_debito; Type: VIEW; Schema: vistas; Owner: -
--

CREATE VIEW vistas.vw_notas_credito_debito AS
 SELECT n.id_nota,
        CASE
            WHEN ((tc.codigo)::text = '07'::text) THEN 'CREDITO'::text
            ELSE 'DEBITO'::text
        END AS tipo_nota,
    'VENTA'::text AS origen,
    n.serie,
    n.numero,
    n.fecha_emision,
    tc.nombre AS nombre_tipo_comprobante,
    (((n.serie_ref)::text || '-'::text) || (n.numero_ref)::text) AS comprobante_referencia,
    c.razon_social AS razon_social_cliente_o_proveedor,
    COALESCE(mnc.codigo, mnd.codigo) AS codigo_motivo,
    COALESCE(mnc.nombre, mnd.nombre) AS descripcion_motivo,
    COALESCE(mnc.devuelve_stock, false) AS devuelve_stock,
    n.total_nota AS monto_total,
    'ACTIVO'::text AS estado
   FROM (((((ventas.notas n
     JOIN configuracion.tipo_comprobante tc ON ((n.id_tipo_comprobante = tc.id_tipo_comprobante)))
     JOIN ventas.ventas v ON ((n.id_venta_referencia = v.id_venta)))
     JOIN clientes.clientes c ON ((v.id_cliente = c.id_cliente)))
     LEFT JOIN configuracion.motivo_nota_credito mnc ON (((n.codigo_motivo_nc)::text = (mnc.codigo)::text)))
     LEFT JOIN configuracion.motivo_nota_debito mnd ON (((n.codigo_motivo_nd)::text = (mnd.codigo)::text)))
UNION ALL
 SELECT n.id_nota,
        CASE
            WHEN ((tc.codigo)::text = '07'::text) THEN 'CREDITO'::text
            ELSE 'DEBITO'::text
        END AS tipo_nota,
    'COMPRA'::text AS origen,
    n.serie_comprobante AS serie,
    (n.numero_comprobante)::bigint AS numero,
    n.fecha_emision,
    tc.nombre AS nombre_tipo_comprobante,
    (((n.serie_ref)::text || '-'::text) || (n.numero_ref)::text) AS comprobante_referencia,
    p.razon_social AS razon_social_cliente_o_proveedor,
    COALESCE(mnc.codigo, mnd.codigo) AS codigo_motivo,
    COALESCE(mnc.nombre, mnd.nombre) AS descripcion_motivo,
    COALESCE(mnc.devuelve_stock, false) AS devuelve_stock,
    n.total AS monto_total,
    'ACTIVO'::text AS estado
   FROM (((((compras.notas n
     JOIN configuracion.tipo_comprobante tc ON ((n.id_tipo_comprobante = tc.id_tipo_comprobante)))
     JOIN compras.compras c ON ((n.id_compra_referencia = c.id_compra)))
     JOIN compras.proveedores p ON ((c.id_proveedor = p.id_proveedor)))
     LEFT JOIN configuracion.motivo_nota_credito mnc ON (((n.codigo_motivo_nc)::text = (mnc.codigo)::text)))
     LEFT JOIN configuracion.motivo_nota_debito mnd ON (((n.codigo_motivo_nd)::text = (mnd.codigo)::text)));


--
-- TOC entry 352 (class 1259 OID 47765)
-- Name: vw_stock_actual; Type: VIEW; Schema: vistas; Owner: -
--

CREATE VIEW vistas.vw_stock_actual AS
 SELECT p.id_producto,
    p.codigo_producto,
    p.nombre_producto AS descripcion_producto,
    cat.nombre_categoria,
    mar.nombre_marca,
    um.codigo_sunat AS codigo_unidad_medida,
    um.simbolo AS simbolo_unidad,
    a.nombre_almacen,
    st.cantidad_actual AS stock_actual,
    st.ubicacion_fisica,
    (st.cantidad_actual < p.stock_minimo) AS alerta_stock_minimo
   FROM (((((inventario.stock st
     JOIN catalogo.productos p ON ((st.id_producto = p.id_producto)))
     JOIN catalogo.categorias cat ON ((p.id_categoria = cat.id_categoria)))
     JOIN catalogo.marcas mar ON ((p.id_marca = mar.id_marca)))
     JOIN catalogo.unidades_medida um ON ((p.id_unidad = um.id_unidad)))
     JOIN inventario.almacenes a ON ((st.id_almacen = a.id_almacen)));


--
-- TOC entry 3588 (class 2604 OID 62924)
-- Name: categorias id_categoria; Type: DEFAULT; Schema: catalogo; Owner: -
--

ALTER TABLE ONLY catalogo.categorias ALTER COLUMN id_categoria SET DEFAULT nextval('catalogo.categorias_id_categoria_seq'::regclass);


--
-- TOC entry 3597 (class 2604 OID 62925)
-- Name: imagenes_producto id_imagen; Type: DEFAULT; Schema: catalogo; Owner: -
--

ALTER TABLE ONLY catalogo.imagenes_producto ALTER COLUMN id_imagen SET DEFAULT nextval('catalogo.imagenes_producto_id_imagen_seq'::regclass);


--
-- TOC entry 3598 (class 2604 OID 62926)
-- Name: listas_precios id_lista_precio; Type: DEFAULT; Schema: catalogo; Owner: -
--

ALTER TABLE ONLY catalogo.listas_precios ALTER COLUMN id_lista_precio SET DEFAULT nextval('catalogo.listas_precios_id_lista_precio_seq'::regclass);


--
-- TOC entry 3603 (class 2604 OID 62927)
-- Name: marcas id_marca; Type: DEFAULT; Schema: catalogo; Owner: -
--

ALTER TABLE ONLY catalogo.marcas ALTER COLUMN id_marca SET DEFAULT nextval('catalogo.marcas_id_marca_seq'::regclass);


--
-- TOC entry 3620 (class 2604 OID 62928)
-- Name: productos id_producto; Type: DEFAULT; Schema: catalogo; Owner: -
--

ALTER TABLE ONLY catalogo.productos ALTER COLUMN id_producto SET DEFAULT nextval('catalogo.productos_id_producto_seq'::regclass);


--
-- TOC entry 3625 (class 2604 OID 62929)
-- Name: unidades_medida id_unidad; Type: DEFAULT; Schema: catalogo; Owner: -
--

ALTER TABLE ONLY catalogo.unidades_medida ALTER COLUMN id_unidad SET DEFAULT nextval('catalogo.unidades_medida_id_unidad_seq'::regclass);


--
-- TOC entry 3629 (class 2604 OID 62930)
-- Name: variantes_producto id_variante; Type: DEFAULT; Schema: catalogo; Owner: -
--

ALTER TABLE ONLY catalogo.variantes_producto ALTER COLUMN id_variante SET DEFAULT nextval('catalogo.variantes_producto_id_variante_seq'::regclass);


--
-- TOC entry 3639 (class 2604 OID 62931)
-- Name: clientes id_cliente; Type: DEFAULT; Schema: clientes; Owner: -
--

ALTER TABLE ONLY clientes.clientes ALTER COLUMN id_cliente SET DEFAULT nextval('clientes.clientes_id_cliente_seq'::regclass);


--
-- TOC entry 3643 (class 2604 OID 62932)
-- Name: contactos_cliente id_contacto; Type: DEFAULT; Schema: clientes; Owner: -
--

ALTER TABLE ONLY clientes.contactos_cliente ALTER COLUMN id_contacto SET DEFAULT nextval('clientes.contactos_cliente_id_contacto_seq'::regclass);


--
-- TOC entry 3659 (class 2604 OID 62933)
-- Name: compras id_compra; Type: DEFAULT; Schema: compras; Owner: -
--

ALTER TABLE ONLY compras.compras ALTER COLUMN id_compra SET DEFAULT nextval('compras.compras_id_compra_seq'::regclass);


--
-- TOC entry 3663 (class 2604 OID 62934)
-- Name: detalle_compra id_detalle_compra; Type: DEFAULT; Schema: compras; Owner: -
--

ALTER TABLE ONLY compras.detalle_compra ALTER COLUMN id_detalle_compra SET DEFAULT nextval('compras.detalle_compra_id_detalle_compra_seq'::regclass);


--
-- TOC entry 3666 (class 2604 OID 62935)
-- Name: detalle_orden_compra id_detalle_oc; Type: DEFAULT; Schema: compras; Owner: -
--

ALTER TABLE ONLY compras.detalle_orden_compra ALTER COLUMN id_detalle_oc SET DEFAULT nextval('compras.detalle_orden_compra_id_detalle_oc_seq'::regclass);


--
-- TOC entry 3671 (class 2604 OID 62936)
-- Name: ordenes_compra id_orden_compra; Type: DEFAULT; Schema: compras; Owner: -
--

ALTER TABLE ONLY compras.ordenes_compra ALTER COLUMN id_orden_compra SET DEFAULT nextval('compras.ordenes_compra_id_orden_compra_seq'::regclass);


--
-- TOC entry 3676 (class 2604 OID 62937)
-- Name: proveedores id_proveedor; Type: DEFAULT; Schema: compras; Owner: -
--

ALTER TABLE ONLY compras.proveedores ALTER COLUMN id_proveedor SET DEFAULT nextval('compras.proveedores_id_proveedor_seq'::regclass);


--
-- TOC entry 3683 (class 2604 OID 62938)
-- Name: configuraciones id_configuracion; Type: DEFAULT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.configuraciones ALTER COLUMN id_configuracion SET DEFAULT nextval('configuracion.configuraciones_id_configuracion_seq'::regclass);


--
-- TOC entry 3687 (class 2604 OID 62939)
-- Name: empresa id_empresa; Type: DEFAULT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.empresa ALTER COLUMN id_empresa SET DEFAULT nextval('configuracion.empresa_id_empresa_seq'::regclass);


--
-- TOC entry 3889 (class 2604 OID 47336)
-- Name: impuestos id_impuesto; Type: DEFAULT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.impuestos ALTER COLUMN id_impuesto SET DEFAULT nextval('configuracion.impuestos_id_impuesto_seq'::regclass);


--
-- TOC entry 3871 (class 2604 OID 47244)
-- Name: matriz_regla_sunat id_regla; Type: DEFAULT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.matriz_regla_sunat ALTER COLUMN id_regla SET DEFAULT nextval('configuracion.matriz_regla_sunat_id_regla_seq'::regclass);


--
-- TOC entry 3895 (class 2604 OID 47348)
-- Name: parametros_configuracion id_parametro; Type: DEFAULT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.parametros_configuracion ALTER COLUMN id_parametro SET DEFAULT nextval('configuracion.parametros_configuracion_id_parametro_seq'::regclass);


--
-- TOC entry 3692 (class 2604 OID 62940)
-- Name: series_comprobantes id_serie; Type: DEFAULT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.series_comprobantes ALTER COLUMN id_serie SET DEFAULT nextval('configuracion.series_comprobantes_id_serie_seq'::regclass);


--
-- TOC entry 3884 (class 2604 OID 47318)
-- Name: sucursales id_sucursal; Type: DEFAULT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.sucursales ALTER COLUMN id_sucursal SET DEFAULT nextval('configuracion.sucursales_id_sucursal_seq'::regclass);


--
-- TOC entry 3697 (class 2604 OID 62941)
-- Name: tablas_generales id_tabla; Type: DEFAULT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.tablas_generales ALTER COLUMN id_tabla SET DEFAULT nextval('configuracion.tablas_generales_id_tabla_seq'::regclass);


--
-- TOC entry 3701 (class 2604 OID 62942)
-- Name: tablas_generales_detalle id_detalle; Type: DEFAULT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.tablas_generales_detalle ALTER COLUMN id_detalle SET DEFAULT nextval('configuracion.tablas_generales_detalle_id_detalle_seq'::regclass);


--
-- TOC entry 3867 (class 2604 OID 47231)
-- Name: tipo_operacion_sunat id_tipo_operacion; Type: DEFAULT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.tipo_operacion_sunat ALTER COLUMN id_tipo_operacion SET DEFAULT nextval('configuracion.tipo_operacion_sunat_id_tipo_operacion_seq'::regclass);


--
-- TOC entry 3711 (class 2604 OID 62943)
-- Name: asientos_contables id_asiento; Type: DEFAULT; Schema: contabilidad; Owner: -
--

ALTER TABLE ONLY contabilidad.asientos_contables ALTER COLUMN id_asiento SET DEFAULT nextval('contabilidad.asientos_contables_id_asiento_seq'::regclass);


--
-- TOC entry 3712 (class 2604 OID 62944)
-- Name: centros_costo id_centro_costo; Type: DEFAULT; Schema: contabilidad; Owner: -
--

ALTER TABLE ONLY contabilidad.centros_costo ALTER COLUMN id_centro_costo SET DEFAULT nextval('contabilidad.centros_costo_id_centro_costo_seq'::regclass);


--
-- TOC entry 3716 (class 2604 OID 62945)
-- Name: detalle_asiento id_detalle_asiento; Type: DEFAULT; Schema: contabilidad; Owner: -
--

ALTER TABLE ONLY contabilidad.detalle_asiento ALTER COLUMN id_detalle_asiento SET DEFAULT nextval('contabilidad.detalle_asiento_id_detalle_asiento_seq'::regclass);


--
-- TOC entry 3724 (class 2604 OID 62946)
-- Name: plan_cuentas id_cuenta; Type: DEFAULT; Schema: contabilidad; Owner: -
--

ALTER TABLE ONLY contabilidad.plan_cuentas ALTER COLUMN id_cuenta SET DEFAULT nextval('contabilidad.plan_cuentas_id_cuenta_seq'::regclass);


--
-- TOC entry 3725 (class 2604 OID 62947)
-- Name: areas id_area; Type: DEFAULT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.areas ALTER COLUMN id_area SET DEFAULT nextval('identidad.areas_id_area_seq'::regclass);


--
-- TOC entry 3729 (class 2604 OID 62948)
-- Name: auditoria_accesos id_auditoria; Type: DEFAULT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.auditoria_accesos ALTER COLUMN id_auditoria SET DEFAULT nextval('identidad.auditoria_accesos_id_auditoria_seq'::regclass);


--
-- TOC entry 3731 (class 2604 OID 62949)
-- Name: cargos id_cargo; Type: DEFAULT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.cargos ALTER COLUMN id_cargo SET DEFAULT nextval('identidad.cargos_id_cargo_seq'::regclass);


--
-- TOC entry 3735 (class 2604 OID 62950)
-- Name: menus id_menu; Type: DEFAULT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.menus ALTER COLUMN id_menu SET DEFAULT nextval('identidad.menus_id_menu_seq'::regclass);


--
-- TOC entry 3740 (class 2604 OID 62951)
-- Name: permisos id_permiso; Type: DEFAULT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.permisos ALTER COLUMN id_permiso SET DEFAULT nextval('identidad.permisos_id_permiso_seq'::regclass);


--
-- TOC entry 3744 (class 2604 OID 62952)
-- Name: roles id_rol; Type: DEFAULT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.roles ALTER COLUMN id_rol SET DEFAULT nextval('identidad.roles_id_rol_seq'::regclass);


--
-- TOC entry 3748 (class 2604 OID 62953)
-- Name: roles_menus id_rol_menu; Type: DEFAULT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.roles_menus ALTER COLUMN id_rol_menu SET DEFAULT nextval('identidad.roles_menus_id_rol_menu_seq'::regclass);


--
-- TOC entry 3752 (class 2604 OID 62954)
-- Name: roles_menus_permisos id_rol_menu_permiso; Type: DEFAULT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.roles_menus_permisos ALTER COLUMN id_rol_menu_permiso SET DEFAULT nextval('identidad.roles_menus_permisos_id_rol_menu_permiso_seq'::regclass);


--
-- TOC entry 3759 (class 2604 OID 62955)
-- Name: tipos_permiso id_tipo_permiso; Type: DEFAULT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.tipos_permiso ALTER COLUMN id_tipo_permiso SET DEFAULT nextval('identidad.tipos_permiso_id_tipo_permiso_seq'::regclass);


--
-- TOC entry 3763 (class 2604 OID 62956)
-- Name: trabajadores id_trabajador; Type: DEFAULT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.trabajadores ALTER COLUMN id_trabajador SET DEFAULT nextval('identidad.trabajadores_id_trabajador_seq'::regclass);


--
-- TOC entry 3767 (class 2604 OID 62957)
-- Name: usuarios id_usuario; Type: DEFAULT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.usuarios ALTER COLUMN id_usuario SET DEFAULT nextval('identidad.usuarios_id_usuario_seq'::regclass);


--
-- TOC entry 3771 (class 2604 OID 62958)
-- Name: usuarios_roles id_usuario_rol; Type: DEFAULT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.usuarios_roles ALTER COLUMN id_usuario_rol SET DEFAULT nextval('identidad.usuarios_roles_id_usuario_rol_seq'::regclass);


--
-- TOC entry 3779 (class 2604 OID 62959)
-- Name: almacenes id_almacen; Type: DEFAULT; Schema: inventario; Owner: -
--

ALTER TABLE ONLY inventario.almacenes ALTER COLUMN id_almacen SET DEFAULT nextval('inventario.almacenes_id_almacen_seq'::regclass);


--
-- TOC entry 3924 (class 2604 OID 66590)
-- Name: inv_kardex_lote id; Type: DEFAULT; Schema: inventario; Owner: -
--

ALTER TABLE ONLY inventario.inv_kardex_lote ALTER COLUMN id SET DEFAULT nextval('inventario.inv_kardex_lote_id_seq'::regclass);


--
-- TOC entry 3929 (class 2604 OID 66601)
-- Name: inv_kardex_movimiento id; Type: DEFAULT; Schema: inventario; Owner: -
--

ALTER TABLE ONLY inventario.inv_kardex_movimiento ALTER COLUMN id SET DEFAULT nextval('inventario.inv_kardex_movimiento_id_seq'::regclass);


--
-- TOC entry 3936 (class 2604 OID 66621)
-- Name: inv_kardex_recalculo_log id; Type: DEFAULT; Schema: inventario; Owner: -
--

ALTER TABLE ONLY inventario.inv_kardex_recalculo_log ALTER COLUMN id SET DEFAULT nextval('inventario.inv_kardex_recalculo_log_id_seq'::regclass);


--
-- TOC entry 3781 (class 2604 OID 62960)
-- Name: movimientos_inventario id_movimiento; Type: DEFAULT; Schema: inventario; Owner: -
--

ALTER TABLE ONLY inventario.movimientos_inventario ALTER COLUMN id_movimiento SET DEFAULT nextval('inventario.movimientos_inventario_id_movimiento_seq'::regclass);


--
-- TOC entry 3789 (class 2604 OID 62961)
-- Name: stock id_stock; Type: DEFAULT; Schema: inventario; Owner: -
--

ALTER TABLE ONLY inventario.stock ALTER COLUMN id_stock SET DEFAULT nextval('inventario.stock_id_stock_seq'::regclass);


--
-- TOC entry 3903 (class 2604 OID 47571)
-- Name: traslados id_traslado; Type: DEFAULT; Schema: inventario; Owner: -
--

ALTER TABLE ONLY inventario.traslados ALTER COLUMN id_traslado SET DEFAULT nextval('inventario.traslados_id_traslado_seq'::regclass);


--
-- TOC entry 3906 (class 2604 OID 47584)
-- Name: traslados_detalle id_detalle_traslado; Type: DEFAULT; Schema: inventario; Owner: -
--

ALTER TABLE ONLY inventario.traslados_detalle ALTER COLUMN id_detalle_traslado SET DEFAULT nextval('inventario.traslados_detalle_id_detalle_traslado_seq'::regclass);


--
-- TOC entry 3909 (class 2604 OID 47600)
-- Name: traslados_incidencias id_incidencia; Type: DEFAULT; Schema: inventario; Owner: -
--

ALTER TABLE ONLY inventario.traslados_incidencias ALTER COLUMN id_incidencia SET DEFAULT nextval('inventario.traslados_incidencias_id_incidencia_seq'::regclass);


--
-- TOC entry 3799 (class 2604 OID 62962)
-- Name: cajas id_caja; Type: DEFAULT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.cajas ALTER COLUMN id_caja SET DEFAULT nextval('ventas.cajas_id_caja_seq'::regclass);


--
-- TOC entry 3808 (class 2604 OID 62963)
-- Name: cotizaciones id_cotizacion; Type: DEFAULT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.cotizaciones ALTER COLUMN id_cotizacion SET DEFAULT nextval('ventas.cotizaciones_id_cotizacion_seq'::regclass);


--
-- TOC entry 3809 (class 2604 OID 62964)
-- Name: detalle_cotizacion id_detalle_cot; Type: DEFAULT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.detalle_cotizacion ALTER COLUMN id_detalle_cot SET DEFAULT nextval('ventas.detalle_cotizacion_id_detalle_cot_seq'::regclass);


--
-- TOC entry 3815 (class 2604 OID 62965)
-- Name: detalle_venta id_detalle_venta; Type: DEFAULT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.detalle_venta ALTER COLUMN id_detalle_venta SET DEFAULT nextval('ventas.detalle_venta_id_detalle_venta_seq'::regclass);


--
-- TOC entry 3820 (class 2604 OID 62966)
-- Name: metodos_pago id_metodo_pago; Type: DEFAULT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.metodos_pago ALTER COLUMN id_metodo_pago SET DEFAULT nextval('ventas.metodos_pago_id_metodo_pago_seq'::regclass);


--
-- TOC entry 3825 (class 2604 OID 62967)
-- Name: movimientos_caja id_movimiento_caja; Type: DEFAULT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.movimientos_caja ALTER COLUMN id_movimiento_caja SET DEFAULT nextval('ventas.movimientos_caja_id_movimiento_caja_seq'::regclass);


--
-- TOC entry 3827 (class 2604 OID 62968)
-- Name: pagos id_pago; Type: DEFAULT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.pagos ALTER COLUMN id_pago SET DEFAULT nextval('ventas.pagos_id_pago_seq'::regclass);


--
-- TOC entry 3843 (class 2604 OID 62969)
-- Name: ventas id_venta; Type: DEFAULT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.ventas ALTER COLUMN id_venta SET DEFAULT nextval('ventas.ventas_id_venta_seq'::regclass);


--
-- TOC entry 4560 (class 0 OID 62613)
-- Dependencies: 355
-- Data for Name: __ef_migrations; Type: TABLE DATA; Schema: catalogo; Owner: -
--

COPY catalogo.__ef_migrations (migration_id, product_version) FROM stdin;
20260127221140_Inicial	8.0.8
20260127221706_AjusteEsquema	8.0.8
20260128013043_RefactorTipoProducto	8.0.8
20260222180939_AddMetodoValuacionToProducto	8.0.8
\.


--
-- TOC entry 4431 (class 0 OID 46222)
-- Dependencies: 219
-- Data for Name: categorias; Type: TABLE DATA; Schema: catalogo; Owner: -
--

COPY catalogo.categorias (id_categoria, nombre_categoria, descripcion, id_categoria_padre, imagen_url, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion) FROM stdin;
1	General	Categoria General	\N	\N	t	2026-01-27 17:36:29.051209	SYSTEM	2026-01-27 17:36:29.051209	\N
2	General 2	prueba	\N	\N	f	2026-01-28 23:41:36.75824	API_USER	2026-01-29 12:27:20.601968	API_USER
4	Electrónica	Dispositivos electrónicos, hogar y oficina	\N	\N	t	2026-03-21 11:26:08.334007	SEEDER	2026-03-21 11:26:08.334007	\N
5	Línea Blanca	Electrodomésticos grandes	\N	\N	t	2026-03-21 11:26:08.334007	SEEDER	2026-03-21 11:26:08.334007	\N
6	Ferretería	Herramientas y construcción	\N	\N	t	2026-03-21 11:26:08.334007	SEEDER	2026-03-21 11:26:08.334007	\N
7	Electrónica	Dispositivos electrónicos, hogar y oficina	\N	\N	t	2026-03-21 11:28:58.728614	SEEDER	2026-03-21 11:28:58.728614	\N
8	Línea Blanca	Electrodomésticos grandes	\N	\N	t	2026-03-21 11:28:58.728614	SEEDER	2026-03-21 11:28:58.728614	\N
9	Ferretería	Herramientas y construcción	\N	\N	t	2026-03-21 11:28:58.728614	SEEDER	2026-03-21 11:28:58.728614	\N
\.


--
-- TOC entry 4433 (class 0 OID 46231)
-- Dependencies: 221
-- Data for Name: imagenes_producto; Type: TABLE DATA; Schema: catalogo; Owner: -
--

COPY catalogo.imagenes_producto (id_imagen, id_producto, url_imagen, es_principal, orden, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion) FROM stdin;
\.


--
-- TOC entry 4435 (class 0 OID 46242)
-- Dependencies: 223
-- Data for Name: listas_precios; Type: TABLE DATA; Schema: catalogo; Owner: -
--

COPY catalogo.listas_precios (id_lista_precio, nombre_lista, es_base, porcentaje_ganancia_sugerido, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion) FROM stdin;
\.


--
-- TOC entry 4437 (class 0 OID 46250)
-- Dependencies: 225
-- Data for Name: marcas; Type: TABLE DATA; Schema: catalogo; Owner: -
--

COPY catalogo.marcas (id_marca, nombre_marca, pais_origen, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion) FROM stdin;
1	Generico	Peru	t	2026-01-27 17:36:29.051209	SYSTEM	2026-01-27 17:36:29.051209	\N
5	Samsung	Corea del Sur	t	2026-03-21 11:26:08.334007	SEEDER	2026-03-21 11:26:08.334007	\N
6	LG	Corea del Sur	t	2026-03-21 11:26:08.334007	SEEDER	2026-03-21 11:26:08.334007	\N
7	Bosch	Alemania	t	2026-03-21 11:26:08.334007	SEEDER	2026-03-21 11:26:08.334007	\N
8	Truper	México	t	2026-03-21 11:26:08.334007	SEEDER	2026-03-21 11:26:08.334007	\N
9	ASUS	Taiwán	t	2026-03-21 11:26:08.334007	SEEDER	2026-03-21 11:26:08.334007	\N
10	Xiaomi	China	t	2026-03-21 11:26:08.334007	SEEDER	2026-03-21 11:26:08.334007	\N
\.


--
-- TOC entry 4439 (class 0 OID 46257)
-- Dependencies: 227
-- Data for Name: productos; Type: TABLE DATA; Schema: catalogo; Owner: -
--

COPY catalogo.productos (id_producto, codigo_producto, codigo_barras, sku, nombre_producto, descripcion, id_categoria, id_marca, id_unidad, tiene_variantes, precio_compra, precio_venta_publico, precio_venta_mayorista, precio_venta_distribuidor, stock_minimo, stock_maximo, permite_inventario_negativo, gravado_impuesto, porcentaje_impuesto, imagen_principal_url, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion, id_tipo_producto, metodo_valuacion) FROM stdin;
7	TV-SAM-001	\N	\N	Smart TV 55" 4K UHD	Televisor inteligente Samsung con resolución 4K	4	5	1	f	0.00	1899.00	0.00	0.00	5.000	\N	f	t	18.00	\N	t	2026-03-21 11:26:08.334007	SEEDER	2026-03-21 11:26:08.334007	\N	\N	PE
8	LAP-ASU-001	\N	\N	Laptop ASUS ZenBook 14"	Laptop ultra delgada, procesador Intel i7, 16GB RAM	4	9	1	f	0.00	4299.00	0.00	0.00	3.000	\N	f	t	18.00	\N	t	2026-03-21 11:26:08.334007	SEEDER	2026-03-21 11:26:08.334007	\N	\N	PE
9	CEL-XIA-001	\N	\N	Smartphone Xiaomi Redmi Note 13	Teléfono móvil Xiaomi 256GB / 8GB RAM	4	10	1	f	0.00	1199.00	0.00	0.00	10.000	\N	f	t	18.00	\N	t	2026-03-21 11:26:08.334007	SEEDER	2026-03-21 11:26:08.334007	\N	\N	PE
10	REF-LG-001	\N	\N	Refrigeradora LG Inverter 600L	Refrigeradora de gran capacidad con tecnología Inverter LG	5	6	1	f	0.00	2899.00	0.00	0.00	2.000	\N	f	t	18.00	\N	t	2026-03-21 11:26:08.334007	SEEDER	2026-03-21 11:26:08.334007	\N	\N	PE
11	LAV-BOS-001	\N	\N	Lavadora Bosch Carga Frontal 9kg	Lavadora inteligente Bosch 9 kilogramos con secado	5	7	1	f	0.00	1850.50	0.00	0.00	4.000	\N	f	t	18.00	\N	t	2026-03-21 11:26:08.334007	SEEDER	2026-03-21 11:26:08.334007	\N	\N	PE
12	HER-TRU-001	\N	\N	Taladro Percutor 1/2" 700W	Taladro industrial percutor marca Truper, 700 watts de potencia	6	8	1	f	0.00	199.90	0.00	0.00	10.000	\N	f	t	18.00	\N	t	2026-03-21 11:26:08.334007	SEEDER	2026-03-21 11:26:08.334007	\N	\N	PE
13	HER-TRU-002	\N	\N	Set de Herramientas Mecánicas 50 Pzs	Maletín con llaves, dados y otras herramientas mecánicas Truper	6	8	1	f	0.00	299.90	0.00	0.00	8.000	\N	f	t	18.00	\N	t	2026-03-21 11:26:08.334007	SEEDER	2026-03-21 11:26:08.334007	\N	\N	PE
1	PROD_CLI_01	\N	\N	Producto Client	\N	1	1	1	f	0.00	0.00	0.00	0.00	0.000	0.000	f	t	18.00	\N	t	2026-01-27 22:55:17.057057		\N	\N	\N	
2	PROD001	\N	\N	Producto Prueba	\N	1	1	1	f	0.00	0.00	0.00	0.00	0.000	0.000	f	t	18.00	\N	t	2026-01-27 22:59:25.458681		\N	\N	\N	
3	PROD_WRAPPER_02	\N	\N	Producto Wrapper 2	\N	1	1	1	f	0.00	0.00	0.00	0.00	0.000	0.000	f	t	18.00	\N	t	2026-01-27 23:11:00.248331		\N	\N	\N	
4	PROD_AUDIT_03	\N	\N	Producto Auditado	\N	1	1	1	f	0.00	0.00	0.00	0.00	0.000	0.000	f	t	18.00	\N	t	2026-01-27 23:18:23.828687	API_USER	\N	\N	\N	
5	prueba	\N	\N	esta	\N	1	1	1	f	0.00	0.00	0.00	0.00	0.000	0.000	f	t	18.00	\N	t	2026-01-27 23:37:50.466669	API_USER	\N	\N	\N	
\.


--
-- TOC entry 4441 (class 0 OID 46279)
-- Dependencies: 229
-- Data for Name: unidades_medida; Type: TABLE DATA; Schema: catalogo; Owner: -
--

COPY catalogo.unidades_medida (id_unidad, codigo_sunat, nombre_unidad, simbolo, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion) FROM stdin;
1	NIU	Unidad	UND	t	2026-01-27 17:36:28.866902	SYSTEM	2026-01-27 17:36:28.866902	\N
2	KGM	Kilogramo	KG	t	2026-01-27 17:36:28.866902	SYSTEM	2026-01-27 17:36:28.866902	\N
3	LTR	Litro	LT	t	2026-01-27 17:36:28.866902	SYSTEM	2026-01-27 17:36:28.866902	\N
4	MTR	Metro	MT	t	2026-01-27 17:36:28.866902	SYSTEM	2026-01-27 17:36:28.866902	\N
5	BX	Caja	CJA	t	2026-01-27 17:36:28.866902	SYSTEM	2026-01-27 17:36:28.866902	\N
6	NIU	Unidad	UND	t	2026-01-27 17:36:29.051209	SYSTEM	2026-01-27 17:36:29.051209	\N
\.


--
-- TOC entry 4443 (class 0 OID 46286)
-- Dependencies: 231
-- Data for Name: variantes_producto; Type: TABLE DATA; Schema: catalogo; Owner: -
--

COPY catalogo.variantes_producto (id_variante, id_producto, sku_variante, codigo_barras_variante, nombre_completo_variante, atributos_json, precio_adicional, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion) FROM stdin;
\.


--
-- TOC entry 4576 (class 0 OID 66654)
-- Dependencies: 371
-- Data for Name: __EFMigrationsHistory; Type: TABLE DATA; Schema: clientes; Owner: -
--

COPY clientes."__EFMigrationsHistory" ("MigrationId", "ProductVersion") FROM stdin;
20260129225037_Initial	8.0.x
\.


--
-- TOC entry 4579 (class 0 OID 66796)
-- Dependencies: 374
-- Data for Name: __ef_migrations_history; Type: TABLE DATA; Schema: clientes; Owner: -
--

COPY clientes.__ef_migrations_history (migration_id, product_version) FROM stdin;
20260129225037_Inicial	8.0.8
20260327223412_AddSunatFieldsToCliente	8.0.8
\.


--
-- TOC entry 4445 (class 0 OID 46296)
-- Dependencies: 233
-- Data for Name: clientes; Type: TABLE DATA; Schema: clientes; Owner: -
--

COPY clientes.clientes (id_cliente, numero_documento, razon_social, nombre_comercial, direccion, telefono, email, limite_credito, dias_credito, id_lista_precio_asignada, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion, id_tipo_documento, id_tipo_cliente, condicion_sunat, es_agente_percepcion, es_agente_retencion, es_buen_contribuyente, estado_sunat, fecha_ultima_consulta_sunat, ubigeo) FROM stdin;
2	20556677881	Constructora Horizonte S.A.	Horizonte	Av. Javier Prado 1500, San Isidro	01-2223344	compras@horizonte.com.pe	0.00	0	\N	t	2026-03-21 18:44:11.223105	SYSTEM	2026-03-21 18:44:11.223105	\N	4	\N	\N	f	f	f	\N	\N	\N
3	45678901	María García López	María García	Urb. Los Pinos F-12, Arequipa	987654321	maria.garcia@outlook.com	0.00	0	\N	t	2026-03-21 18:44:11.223105	SYSTEM	2026-03-21 18:44:11.223105	\N	2	\N	\N	f	f	f	\N	\N	\N
5	44050058	Francisco Antonio Vilchez Quispe	\N	Sta Catalina 430	968737466	\N	\N	\N	\N	t	2026-03-28 00:27:49.647488	API_USER	\N	\N	2	9	HABIDO	t	t	t	ACTIVO	\N	130107
\.


--
-- TOC entry 4447 (class 0 OID 46307)
-- Dependencies: 235
-- Data for Name: contactos_cliente; Type: TABLE DATA; Schema: clientes; Owner: -
--

COPY clientes.contactos_cliente (id_contacto, id_cliente, nombres, cargo, telefono, email, es_principal, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion) FROM stdin;
\.


--
-- TOC entry 4578 (class 0 OID 66791)
-- Dependencies: 373
-- Data for Name: __ef_migrations_history; Type: TABLE DATA; Schema: compras; Owner: -
--

COPY compras.__ef_migrations_history (migration_id, product_version) FROM stdin;
20260129231053_Inicial	8.0.8
20260206190831_FixDetalleAudit	8.0.8
20260213160911_AddCompraIdToOrdenCompra	8.0.8
20260217183807_UpdateOrdenCompraSerieNumero	8.0.8
20260217203920_AddSerieNumeroCorrelativoToOrdenCompra	8.0.8
20260219175334_AddObservacionesToCompra	8.0.8
20260221132104_AddCamposSunatPle81	8.0.8
20260316050748_UpdateSunatFieldsCompras	8.0.8
20260322232250_FixTypoIdCompra	8.0.8
20260327220128_AddSunatFieldsAndResetSequence	8.0.8
\.


--
-- TOC entry 4449 (class 0 OID 46317)
-- Dependencies: 237
-- Data for Name: compras; Type: TABLE DATA; Schema: compras; Owner: -
--

COPY compras.compras (id_compra, id_proveedor, id_almacen, id_orden_compra_ref, serie_comprobante, numero_comprobante, fecha_emision, fecha_contable, moneda, tipo_cambio, subtotal, impuesto, total, saldo_pendiente, fecha_vencimiento, base_gravada, base_exonerada, base_inafecta, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion, id_tipo_comprobante, id_estado_pago, observaciones) FROM stdin;
12	2	1	\N	F001	00000012	2026-03-26	2026-03-26	PEN	1.0000	0.00	521.82	3420.82	3420.82	\N	2899.00	0.00	0.00	t	2026-03-26 14:24:47.10994	API_USER	\N	\N	1	1	Carga desde Orden OC01-00000001. 
13	2	1	\N	F001	00000013	2026-03-26	2026-03-26	PEN	1.0000	0.00	521.82	3420.82	3420.82	\N	2899.00	0.00	0.00	t	2026-03-26 14:39:46.166121	API_USER	\N	\N	1	1	Carga desde Orden OC01-00000001. 
14	2	1	\N	F001	00000014	2026-03-26	2026-03-26	PEN	1.0000	0.00	521.82	3420.82	3420.82	\N	2899.00	0.00	0.00	t	2026-03-26 14:42:36.440632	API_USER	\N	\N	1	1	Carga desde Orden OC01-00000001. 
15	2	1	\N	F001	00000015	2026-03-26	2026-03-26	PEN	1.0000	0.00	521.82	3420.82	3420.82	\N	2899.00	0.00	0.00	t	2026-03-26 14:49:17.386423	API_USER	\N	\N	1	1	Carga desde Orden OC01-00000001. 
16	2	1	\N	F001	00000016	2026-03-26	2026-03-26	PEN	1.0000	0.00	521.82	3420.82	3420.82	\N	2899.00	0.00	0.00	t	2026-03-26 14:59:42.657712	API_USER	\N	\N	1	1	Carga desde Orden OC01-00000001. 
17	2	1	\N	F001	00000017	2026-03-26	2026-03-26	PEN	1.0000	0.00	521.82	3420.82	3420.82	\N	2899.00	0.00	0.00	t	2026-03-26 15:49:12.215437	API_USER	\N	\N	1	1	Carga desde Orden OC01-00000001. 
18	2	1	\N	F001	00000018	2026-03-26	2026-03-26	PEN	1.0000	0.00	521.82	3420.82	3420.82	\N	2899.00	0.00	0.00	t	2026-03-26 15:53:39.052604	API_USER	\N	\N	1	1	Carga desde Orden OC01-00000001. 
19	2	1	\N	F001	00000019	2026-03-26	2026-03-26	PEN	1.0000	0.00	521.82	3420.82	3420.82	\N	2899.00	0.00	0.00	t	2026-03-26 15:58:00.507281	API_USER	\N	\N	1	1	Carga desde Orden OC01-00000001. 
20	2	1	\N	F001	00000020	2026-03-26	2026-03-26	PEN	1.0000	0.00	521.82	3420.82	3420.82	\N	2899.00	0.00	0.00	t	2026-03-26 16:18:20.992479	API_USER	\N	\N	1	1	Carga desde Orden OC01-00000001. 
21	2	1	\N	F001	00000020	2026-03-26	2026-03-26	PEN	1.0000	0.00	521.82	3420.82	3420.82	\N	2899.00	0.00	0.00	t	2026-03-26 22:25:02.487232	API_USER	\N	\N	1	1	Carga desde Orden OC01-00000001. 
22	2	1	\N	F001	00000021	2026-03-26	2026-03-26	PEN	1.0000	0.00	521.82	3420.82	3420.82	\N	2899.00	0.00	0.00	t	2026-03-26 22:29:22.21869	API_USER	\N	\N	1	1	Carga desde Orden OC01-00000001. 
23	2	1	\N	F001	00000022	2026-03-26	2026-03-26	PEN	1.0000	0.00	521.82	3420.82	3420.82	\N	2899.00	0.00	0.00	t	2026-03-26 22:58:38.347874	API_USER	\N	\N	1	1	Carga desde Orden OC01-00000001. 
24	2	1	\N	F001	00000024	2026-03-26	2026-03-26	PEN	1.0000	0.00	521.82	3420.82	3420.82	\N	2899.00	0.00	0.00	t	2026-03-26 23:11:58.863779	API_USER	\N	\N	1	1	Carga desde Orden OC01-00000001. 
25	2	1	1	F001	00000025	2026-03-26	2026-03-26	PEN	1.0000	0.00	521.82	3420.82	3420.82	\N	2899.00	0.00	0.00	t	2026-03-26 23:20:28.662472	API_USER	\N	\N	1	1	Carga desde Orden OC01-00000001. 
26	2	1	1	F001	00000026	2026-03-26	2026-03-26	PEN	1.0000	0.00	521.82	3420.82	3420.82	\N	2899.00	0.00	0.00	t	2026-03-26 23:20:39.967156	API_USER	\N	\N	1	1	Carga desde Orden OC01-00000001. 
27	2	1	1	F001	00000027	2026-03-26	2026-03-26	PEN	1.0000	0.00	521.82	3420.82	3420.82	\N	2899.00	0.00	0.00	t	2026-03-26 23:20:47.184753	API_USER	\N	\N	1	1	Carga desde Orden OC01-00000001. 
28	2	1	1	F001	00000028	2026-03-26	2026-03-26	PEN	1.0000	0.00	521.82	3420.82	3420.82	\N	2899.00	0.00	0.00	t	2026-03-26 23:23:39.398799	API_USER	\N	\N	1	1	Carga desde Orden OC01-00000001. 
29	2	1	1	F001	00000029	2026-03-27	2026-03-27	PEN	1.0000	0.00	521.82	3420.82	3420.82	\N	2899.00	0.00	0.00	t	2026-03-27 04:30:27.406438	API_USER	\N	\N	1	1	Carga desde Orden OC01-00000001. 
30	1	1	\N	F001	000000	2026-03-28	2026-03-28	PEN	1.0000	0.00	19346.40	126826.40	126826.40	\N	107480.00	0.00	0.00	t	2026-03-28 17:36:27.448886	API_USER	\N	\N	1	1	
\.


--
-- TOC entry 4451 (class 0 OID 46332)
-- Dependencies: 239
-- Data for Name: detalle_compra; Type: TABLE DATA; Schema: compras; Owner: -
--

COPY compras.detalle_compra (id_detalle_compra, id_compra, id_producto, id_variante, descripcion, cantidad, precio_unitario_compra, subtotal, afectacion_igv, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion, codigo_tributo, precio_unitario_base, descuento_item, valor_item) FROM stdin;
10	12	10	\N		1.000	2899.00	2899.00	10	t	2026-03-26 14:24:47.110069	API_USER	\N	\N	\N	\N	0.0000	\N
11	13	10	\N		1.000	2899.00	2899.00	10	t	2026-03-26 14:39:46.166237	API_USER	\N	\N	\N	\N	0.0000	\N
12	14	10	\N		1.000	2899.00	2899.00	10	t	2026-03-26 14:42:36.440766	API_USER	\N	\N	\N	\N	0.0000	\N
13	15	10	\N		1.000	2899.00	2899.00	10	t	2026-03-26 14:49:17.386533	API_USER	\N	\N	\N	\N	0.0000	\N
14	16	10	\N		1.000	2899.00	2899.00	10	t	2026-03-26 14:59:42.657842	API_USER	\N	\N	\N	\N	0.0000	\N
15	17	10	\N		1.000	2899.00	2899.00	10	t	2026-03-26 15:49:12.215573	API_USER	\N	\N	\N	\N	0.0000	\N
16	18	10	\N		1.000	2899.00	2899.00	10	t	2026-03-26 15:53:39.052721	API_USER	\N	\N	\N	\N	0.0000	\N
17	19	10	\N		1.000	2899.00	2899.00	10	t	2026-03-26 15:58:00.507454	API_USER	\N	\N	\N	\N	0.0000	\N
18	20	10	\N		1.000	2899.00	2899.00	10	t	2026-03-26 16:18:20.992595	API_USER	\N	\N	\N	\N	0.0000	\N
19	21	10	\N		1.000	2899.00	2899.00	10	t	2026-03-26 22:25:02.487361	API_USER	\N	\N	\N	\N	0.0000	\N
20	22	10	\N		1.000	2899.00	2899.00	10	t	2026-03-26 22:29:22.218827	API_USER	\N	\N	\N	\N	0.0000	\N
21	23	10	\N		1.000	2899.00	2899.00	10	t	2026-03-26 22:58:38.347989	API_USER	\N	\N	\N	\N	0.0000	\N
22	24	10	\N		1.000	2899.00	2899.00	10	t	2026-03-26 23:11:58.863902	API_USER	\N	\N	\N	\N	0.0000	\N
23	25	10	\N		1.000	2899.00	2899.00	10	t	2026-03-26 23:20:28.662686	API_USER	\N	\N	\N	\N	0.0000	\N
24	26	10	\N		1.000	2899.00	2899.00	10	t	2026-03-26 23:20:39.967157	API_USER	\N	\N	\N	\N	0.0000	\N
25	27	10	\N		1.000	2899.00	2899.00	10	t	2026-03-26 23:20:47.184755	API_USER	\N	\N	\N	\N	0.0000	\N
26	28	10	\N		1.000	2899.00	2899.00	10	t	2026-03-26 23:23:39.3988	API_USER	\N	\N	\N	\N	0.0000	\N
27	29	10	\N		1.000	2899.00	2899.00	10	t	2026-03-27 04:30:27.406569	API_USER	\N	\N	\N	\N	0.0000	\N
28	30	10	\N		10.000	2899.00	28990.00	10	t	2026-03-28 17:36:27.449029	API_USER	\N	\N	\N	\N	0.0000	\N
29	30	13	\N		30.000	299.90	8997.00	10	t	2026-03-28 17:36:27.44903	API_USER	\N	\N	\N	\N	0.0000	\N
30	30	7	\N		15.000	1899.00	28485.00	10	t	2026-03-28 17:36:27.449031	API_USER	\N	\N	\N	\N	0.0000	\N
31	30	11	\N		20.000	1850.50	37010.00	10	t	2026-03-28 17:36:27.449031	API_USER	\N	\N	\N	\N	0.0000	\N
32	30	12	\N		20.000	199.90	3998.00	10	t	2026-03-28 17:36:27.449032	API_USER	\N	\N	\N	\N	0.0000	\N
\.


--
-- TOC entry 4547 (class 0 OID 47555)
-- Dependencies: 335
-- Data for Name: detalle_notas; Type: TABLE DATA; Schema: compras; Owner: -
--

COPY compras.detalle_notas (id_detalle_nota, id_nota, id_producto, cantidad, precio_unitario, subtotal, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion) FROM stdin;
\.


--
-- TOC entry 4453 (class 0 OID 46340)
-- Dependencies: 241
-- Data for Name: detalle_orden_compra; Type: TABLE DATA; Schema: compras; Owner: -
--

COPY compras.detalle_orden_compra (id_detalle_oc, id_orden_compra, id_producto, id_variante, cantidad_solicitada, precio_unitario_pactado, subtotal, cantidad_recibida, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion) FROM stdin;
1	1	10	\N	1.000	2899.00	2899.00	0.000	t	2026-03-21 23:25:06.725475	API_USER	\N	\N
\.


--
-- TOC entry 4577 (class 0 OID 66762)
-- Dependencies: 372
-- Data for Name: ef_migrations_history; Type: TABLE DATA; Schema: compras; Owner: -
--

COPY compras.ef_migrations_history (migration_id, product_version) FROM stdin;
20260129231053_Inicial	8.0.8
20260206190831_FixDetalleAudit	8.0.8
20260213160911_AddCompraIdToOrdenCompra	8.0.8
20260217183807_UpdateOrdenCompraSerieNumero	8.0.8
20260217203920_AddSerieNumeroCorrelativoToOrdenCompra	8.0.8
20260219175334_AddObservacionesToCompra	8.0.8
20260221132104_AddCamposSunatPle81	8.0.8
20260316050748_UpdateSunatFieldsCompras	8.0.8
20260322232250_FixTypoIdCompra	8.0.8
\.


--
-- TOC entry 4537 (class 0 OID 47272)
-- Dependencies: 325
-- Data for Name: notas; Type: TABLE DATA; Schema: compras; Owner: -
--

COPY compras.notas (id_nota, id_compra_referencia, id_tipo_comprobante, serie_comprobante, numero_comprobante, fecha_emision, motivo_sustento, total, activado, codigo_tipo_comprobante_ref, serie_ref, numero_ref, descripcion_motivo, codigo_motivo_nc, codigo_motivo_nd, id_tipo_doc_ref, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion) FROM stdin;
\.


--
-- TOC entry 4455 (class 0 OID 46348)
-- Dependencies: 243
-- Data for Name: ordenes_compra; Type: TABLE DATA; Schema: compras; Owner: -
--

COPY compras.ordenes_compra (id_orden_compra, codigo_orden, id_proveedor, id_almacen_destino, fecha_emision, fecha_entrega_estimada, total_importe, observaciones, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion, id_estado, compra_id, id_tipo_comprobante, serie, numero) FROM stdin;
1	OC01-00000001	2	1	2026-03-21	\N	2899.00	\N	t	2026-03-21 23:25:06.7254	API_USER	2026-03-26 23:30:27.527329	API_USER	100	29	13	OC01	00000001
\.


--
-- TOC entry 4457 (class 0 OID 46358)
-- Dependencies: 245
-- Data for Name: proveedores; Type: TABLE DATA; Schema: compras; Owner: -
--

COPY compras.proveedores (id_proveedor, numero_documento, razon_social, nombre_comercial, direccion, telefono, email, pagina_web, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion, id_tipo_documento, condicion_sunat, es_agente_percepcion, es_agente_retencion, es_buen_contribuyente, estado_sunat, fecha_ultima_consulta_sunat, ubigeo) FROM stdin;
1	20601234567	Distribuidora Alimentos S.A.C.	Alisac	Av. Los Próceres 456, Lima	01-4445566	ventas@alisac.com.pe	\N	t	2026-03-21 18:44:11.223105	SYSTEM	2026-03-21 18:44:11.223105	\N	4	\N	f	f	f	\N	\N	\N
2	10445566779	Juan Pérez Suministros	JP Suministros	Calle Las Lilas 123, Surco	999888777	juan.perez@email.com	\N	t	2026-03-21 18:44:11.223105	SYSTEM	2026-03-21 18:44:11.223105	\N	4	\N	f	f	f	\N	\N	\N
\.


--
-- TOC entry 4459 (class 0 OID 46367)
-- Dependencies: 247
-- Data for Name: configuraciones; Type: TABLE DATA; Schema: configuracion; Owner: -
--

COPY configuracion.configuraciones (id_configuracion, clave, valor, descripcion, grupo, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion) FROM stdin;
1	IMPUESTO_PORCENTAJE	18	Porcentaje de IGV/IVA por defecto	VENTAS	t	2026-01-27 17:36:28.866902	SYSTEM	2026-01-27 17:36:28.866902	\N
2	MONEDA_PRINCIPAL	PEN	Moneda base del sistema	SISTEMA	t	2026-01-27 17:36:28.866902	SYSTEM	2026-01-27 17:36:28.866902	\N
\.


--
-- TOC entry 4461 (class 0 OID 46376)
-- Dependencies: 249
-- Data for Name: empresa; Type: TABLE DATA; Schema: configuracion; Owner: -
--

COPY configuracion.empresa (id_empresa, ruc, razon_social, nombre_comercial, direccion_fiscal, telefono, correo_contacto, sitio_web, logo_url, moneda_principal, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion) FROM stdin;
1	20123456789	EMPRESA DEMO S.A.C.	MI TIENDA	AV. PRINCIPAL 123, LIMA	\N	\N	\N	\N	PEN	t	2026-01-27 17:36:28.866902	SYSTEM	2026-01-27 17:36:28.866902	\N
\.


--
-- TOC entry 4541 (class 0 OID 47333)
-- Dependencies: 329
-- Data for Name: impuestos; Type: TABLE DATA; Schema: configuracion; Owner: -
--

COPY configuracion.impuestos (id_impuesto, codigo_sunat, nombre, porcentaje, es_porcentaje, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion) FROM stdin;
1	1000	IGV	18.00	t	t	2026-03-16 09:20:16.083475	SYSTEM	\N	\N
2	2000	ISC	0.00	t	t	2026-03-16 09:20:16.083475	SYSTEM	\N	\N
3	9997	EXONERADO	0.00	t	t	2026-03-16 09:20:16.083475	SYSTEM	\N	\N
4	9998	INAFECTO	0.00	t	t	2026-03-16 09:20:16.083475	SYSTEM	\N	\N
\.


--
-- TOC entry 4531 (class 0 OID 47241)
-- Dependencies: 319
-- Data for Name: matriz_regla_sunat; Type: TABLE DATA; Schema: configuracion; Owner: -
--

COPY configuracion.matriz_regla_sunat (id_regla, id_tipo_operacion, id_tipo_comprobante, nivel_obligatoriedad, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion) FROM stdin;
1	1	1	1	t	2026-03-16 09:20:16.522641	SYSTEM	\N	\N
2	1	2	1	t	2026-03-16 09:20:16.524028	SYSTEM	\N	\N
3	1	5	1	t	2026-03-16 09:20:16.524624	SYSTEM	\N	\N
4	1	6	1	t	2026-03-16 09:20:16.525225	SYSTEM	\N	\N
5	1	4	1	t	2026-03-16 09:20:16.525863	SYSTEM	\N	\N
6	7	4	1	t	2026-03-16 09:20:16.526494	SYSTEM	\N	\N
\.


--
-- TOC entry 4557 (class 0 OID 47710)
-- Dependencies: 345
-- Data for Name: motivo_nota_credito; Type: TABLE DATA; Schema: configuracion; Owner: -
--

COPY configuracion.motivo_nota_credito (id_motivo, codigo, nombre, devuelve_stock, activo, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion) FROM stdin;
1	01	ANULACION DE LA OPERACION	t	t	t	2026-03-16 09:20:16.555568-05	SYSTEM	\N	\N
2	02	ANULACION POR ERROR EN EL RUC	f	t	t	2026-03-16 09:20:16.555568-05	SYSTEM	\N	\N
3	03	CORRECCION POR ERROR EN LA DESCRIPCION	f	t	t	2026-03-16 09:20:16.555568-05	SYSTEM	\N	\N
4	04	DESCUENTO GLOBAL	f	t	t	2026-03-16 09:20:16.555568-05	SYSTEM	\N	\N
5	05	DESCUENTO POR ITEM	f	t	t	2026-03-16 09:20:16.555568-05	SYSTEM	\N	\N
6	06	DEVOLUCION TOTAL	t	t	t	2026-03-16 09:20:16.555568-05	SYSTEM	\N	\N
7	07	DEVOLUCION POR ITEM	t	t	t	2026-03-16 09:20:16.555568-05	SYSTEM	\N	\N
8	08	BONIFICACION	f	t	t	2026-03-16 09:20:16.555568-05	SYSTEM	\N	\N
9	09	DISMINUCION EN EL VALOR	f	t	t	2026-03-16 09:20:16.555568-05	SYSTEM	\N	\N
10	10	OTROS CONCEPTOS	f	t	t	2026-03-16 09:20:16.555568-05	SYSTEM	\N	\N
11	11	AJUSTES DE OPERACIONES DE EXPORTACION	f	t	t	2026-03-16 09:20:16.555568-05	SYSTEM	\N	\N
12	12	AJUSTE AFECTO AL IVAP	f	t	t	2026-03-16 09:20:16.555568-05	SYSTEM	\N	\N
13	13	CORRECCION DE LA DESCRIPCION	f	t	t	2026-03-16 09:20:16.555568-05	SYSTEM	\N	\N
\.


--
-- TOC entry 4559 (class 0 OID 47723)
-- Dependencies: 347
-- Data for Name: motivo_nota_debito; Type: TABLE DATA; Schema: configuracion; Owner: -
--

COPY configuracion.motivo_nota_debito (id_motivo, codigo, nombre, activo, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion) FROM stdin;
1	01	INTERES POR MORA	t	t	2026-03-16 09:20:16.556913-05	SYSTEM	\N	\N
2	02	AUMENTO EN EL VALOR	t	t	2026-03-16 09:20:16.556913-05	SYSTEM	\N	\N
3	03	PENALIDADES / OTROS CONCEPTOS	t	t	2026-03-16 09:20:16.556913-05	SYSTEM	\N	\N
4	10	OTROS CONCEPTOS	t	t	2026-03-16 09:20:16.556913-05	SYSTEM	\N	\N
5	11	AJUSTES DE OPERACIONES DE EXPORTACION	t	t	2026-03-16 09:20:16.556913-05	SYSTEM	\N	\N
6	12	AJUSTE AFECTO AL IVAP	t	t	2026-03-16 09:20:16.556913-05	SYSTEM	\N	\N
\.


--
-- TOC entry 4543 (class 0 OID 47345)
-- Dependencies: 331
-- Data for Name: parametros_configuracion; Type: TABLE DATA; Schema: configuracion; Owner: -
--

COPY configuracion.parametros_configuracion (id_parametro, codigo, valor, descripcion, grupo, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion) FROM stdin;
1	MONEDA_DEFECTO	PEN	Moneda por defecto del sistema	GENERAL	t	2026-03-16 09:20:16.084486	SYSTEM	\N	\N
2	IGV_DEFECTO	18.00	Porcentaje de IGV actual	FISCAL	t	2026-03-16 09:20:16.084486	SYSTEM	\N	\N
\.


--
-- TOC entry 4533 (class 0 OID 47253)
-- Dependencies: 321
-- Data for Name: regla_documento_comprobante; Type: TABLE DATA; Schema: configuracion; Owner: -
--

COPY configuracion.regla_documento_comprobante (id_relacion, codigo_documento, id_tipo_comprobante, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion) FROM stdin;
18	6	1	t	2026-03-21 18:47:09.990392-05	SYSTEM	\N	\N
19	6	2	t	2026-03-21 18:47:09.990392-05	SYSTEM	\N	\N
20	6	3	t	2026-03-21 18:47:09.990392-05	SYSTEM	\N	\N
21	6	4	t	2026-03-21 18:47:09.990392-05	SYSTEM	\N	\N
22	1	2	t	2026-03-21 18:47:09.990392-05	SYSTEM	\N	\N
23	1	3	t	2026-03-21 18:47:09.990392-05	SYSTEM	\N	\N
24	4	2	t	2026-03-21 18:47:09.990392-05	SYSTEM	\N	\N
25	7	2	t	2026-03-21 18:47:09.990392-05	SYSTEM	\N	\N
26	0	2	t	2026-03-21 18:47:09.990392-05	SYSTEM	\N	\N
\.


--
-- TOC entry 4463 (class 0 OID 46386)
-- Dependencies: 251
-- Data for Name: series_comprobantes; Type: TABLE DATA; Schema: configuracion; Owner: -
--

COPY configuracion.series_comprobantes (id_serie, serie, correlativo_actual, id_almacen, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion, id_tipo_comprobante) FROM stdin;
1	F001	0	1	t	2026-03-21 22:45:45.656309	SYSTEM	2026-03-21 22:45:45.656309	\N	1
3	FC01	0	1	t	2026-03-21 22:45:45.656309	SYSTEM	2026-03-21 22:45:45.656309	\N	5
4	FD01	0	1	t	2026-03-21 22:45:45.656309	SYSTEM	2026-03-21 22:45:45.656309	\N	6
5	OC01	1	1	t	2026-03-21 23:22:28.174026	SYSTEM	2026-03-21 23:22:28.174026	\N	13
2	B001	4	1	t	2026-03-21 07:45:45.656309	SYSTEM	2026-03-29 12:25:36.282256	SISTEMA	2
\.


--
-- TOC entry 4539 (class 0 OID 47315)
-- Dependencies: 327
-- Data for Name: sucursales; Type: TABLE DATA; Schema: configuracion; Owner: -
--

COPY configuracion.sucursales (id_sucursal, id_empresa, codigo, nombre, direccion, telefono, es_principal, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion) FROM stdin;
1	1	001	Sucursal Principal	Av. Principal 123	\N	t	t	2026-03-16 09:20:16.085556	SYSTEM	\N	\N
\.


--
-- TOC entry 4465 (class 0 OID 46394)
-- Dependencies: 253
-- Data for Name: tablas_generales; Type: TABLE DATA; Schema: configuracion; Owner: -
--

COPY configuracion.tablas_generales (id_tabla, codigo, nombre, descripcion, es_sistema, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion, activado) FROM stdin;
1	TIPO_DOCUMENTO	Tipos de Documento de Identidad	\N	t	2026-01-27 20:38:29.859421-05	SISTEMA	\N	\N	t
3	TIPO_CLIENTE	Tipos de Cliente	\N	t	2026-01-27 20:38:29.870662-05	SISTEMA	\N	\N	t
4	TIPO_MOVIMIENTO_CAJA	Tipos de Movimiento de Caja	\N	t	2026-01-27 20:38:29.871674-05	SISTEMA	\N	\N	t
5	TIPO_PRODUCTO	Tipos de Producto	\N	t	2026-01-27 20:38:29.872644-05	SISTEMA	\N	\N	t
6	TIPO_MOVIMIENTO_INVENTARIO	Tipos de Movimiento de Inventario	\N	t	2026-01-27 20:38:29.873586-05	SISTEMA	\N	\N	t
7	TIPO_CUENTA_CONTABLE	Tipos de Cuenta Contable	\N	t	2026-01-27 20:38:29.87462-05	SISTEMA	\N	\N	t
8	ESTADO_VENTA	Estados de Venta	\N	t	2026-01-27 20:38:29.875555-05	SISTEMA	\N	\N	t
9	ESTADO_COTIZACION	Estados de CotizaciÃƒÂ³n	\N	t	2026-01-27 20:38:29.876572-05	SISTEMA	\N	\N	t
10	ESTADO_CAJA	Estados de Caja	\N	t	2026-01-27 20:38:29.877676-05	SISTEMA	\N	\N	t
11	ESTADO_ORDEN_COMPRA	Estados de Orden de Compra	\N	t	2026-01-27 20:38:29.878602-05	SISTEMA	\N	\N	t
12	ESTADO_ASIENTO	Estados de Asiento Contable	\N	t	2026-01-27 20:38:29.879531-05	SISTEMA	\N	\N	t
13	ESTADO_PAGO	Estados de Pago	\N	t	2026-01-27 20:38:29.880536-05	SISTEMA	\N	\N	t
14	TIPO_MONEDA	Tipos de Moneda	\N	t	2026-02-12 20:00:00-05	SISTEMA	\N	\N	t
2	TIPO_COMPROBANTE	Tipos de Comprobante de Pago	\N	t	2026-01-27 20:38:29.869526-05	SISTEMA	\N	\N	t
\.


--
-- TOC entry 4466 (class 0 OID 46402)
-- Dependencies: 254
-- Data for Name: tablas_generales_detalle; Type: TABLE DATA; Schema: configuracion; Owner: -
--

COPY configuracion.tablas_generales_detalle (id_detalle, id_tabla, codigo, nombre, descripcion, orden, estado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion, activado) FROM stdin;
1	1	DNI	Documento Nacional de Identidad	\N	1	t	2026-01-27 20:38:29.865474-05	SISTEMA	\N	\N	t
2	1	RUC	Registro ÃƒÅ¡nico de Contribuyentes	\N	2	t	2026-01-27 20:38:29.865474-05	SISTEMA	\N	\N	t
3	1	CE	Carnet de ExtranjerÃƒÂ­a	\N	3	t	2026-01-27 20:38:29.865474-05	SISTEMA	\N	\N	t
4	1	PAS	Pasaporte	\N	4	t	2026-01-27 20:38:29.865474-05	SISTEMA	\N	\N	t
100	11	FAC	Facturada	Orden de Compra Facturada	5	t	2026-03-26 22:50:33.71874-05	SISTEMA	\N	\N	t
9	3	PUB	PÃƒÂºblico General	\N	1	t	2026-01-27 20:38:29.871144-05	SISTEMA	\N	\N	t
10	3	CORP	Corporativo	\N	2	t	2026-01-27 20:38:29.871144-05	SISTEMA	\N	\N	t
11	3	VIP	Cliente VIP	\N	3	t	2026-01-27 20:38:29.871144-05	SISTEMA	\N	\N	t
12	4	ING	Ingreso	\N	1	t	2026-01-27 20:38:29.87213-05	SISTEMA	\N	\N	t
13	4	EGR	Egreso	\N	2	t	2026-01-27 20:38:29.87213-05	SISTEMA	\N	\N	t
14	4	APE	Apertura	\N	3	t	2026-01-27 20:38:29.87213-05	SISTEMA	\N	\N	t
15	4	CIE	Cierre	\N	4	t	2026-01-27 20:38:29.87213-05	SISTEMA	\N	\N	t
16	5	PROD	Producto Terminado	\N	1	t	2026-01-27 20:38:29.873074-05	SISTEMA	\N	\N	t
17	5	SERV	Servicio	\N	2	t	2026-01-27 20:38:29.873074-05	SISTEMA	\N	\N	t
18	5	INS	Insumo	\N	3	t	2026-01-27 20:38:29.873074-05	SISTEMA	\N	\N	t
19	6	ING_COM	Ingreso por Compra	\N	1	t	2026-01-27 20:38:29.874075-05	SISTEMA	\N	\N	t
20	6	SAL_VEN	Salida por Venta	\N	2	t	2026-01-27 20:38:29.874075-05	SISTEMA	\N	\N	t
21	6	AJU_POS	Ajuste Positivo	\N	3	t	2026-01-27 20:38:29.874075-05	SISTEMA	\N	\N	t
22	6	AJU_NEG	Ajuste Negativo	\N	4	t	2026-01-27 20:38:29.874075-05	SISTEMA	\N	\N	t
23	6	TRA_ALM	Transferencia entre Almacenes	\N	5	t	2026-01-27 20:38:29.874075-05	SISTEMA	\N	\N	t
24	7	ACT	Activo	\N	1	t	2026-01-27 20:38:29.875044-05	SISTEMA	\N	\N	t
25	7	PAS	Pasivo	\N	2	t	2026-01-27 20:38:29.875044-05	SISTEMA	\N	\N	t
26	7	PAT	Patrimonio	\N	3	t	2026-01-27 20:38:29.875044-05	SISTEMA	\N	\N	t
27	7	ING	Ingresos	\N	4	t	2026-01-27 20:38:29.875044-05	SISTEMA	\N	\N	t
28	7	GAS	Gastos	\N	5	t	2026-01-27 20:38:29.875044-05	SISTEMA	\N	\N	t
29	8	COM	Completada	\N	1	t	2026-01-27 20:38:29.876001-05	SISTEMA	\N	\N	t
30	8	ANU	Anulada	\N	2	t	2026-01-27 20:38:29.876001-05	SISTEMA	\N	\N	t
31	8	PPG	Pendiente de Pago	\N	3	t	2026-01-27 20:38:29.876001-05	SISTEMA	\N	\N	t
32	9	PEN	Pendiente	\N	1	t	2026-01-27 20:38:29.87705-05	SISTEMA	\N	\N	t
33	9	APR	Aprobada	\N	2	t	2026-01-27 20:38:29.87705-05	SISTEMA	\N	\N	t
34	9	REC	Rechazada	\N	3	t	2026-01-27 20:38:29.87705-05	SISTEMA	\N	\N	t
35	9	VEN	Vencida	\N	4	t	2026-01-27 20:38:29.87705-05	SISTEMA	\N	\N	t
51	14	PEN	Sol	S/	1	t	2026-02-12 20:00:00-05	SISTEMA	\N	\N	t
52	14	USD	DÃ³lar Americano	$	2	t	2026-02-12 20:00:00-05	SISTEMA	\N	\N	t
37	10	ABI	Abierta	\N	1	t	2026-01-27 20:38:29.878144-05	SISTEMA	\N	\N	t
38	10	CIE	Cerrada	\N	2	t	2026-01-27 20:38:29.878144-05	SISTEMA	\N	\N	t
39	11	BOR	Borrador	\N	1	t	2026-01-27 20:38:29.879005-05	SISTEMA	\N	\N	t
40	11	PEN	Pendiente	\N	2	t	2026-01-27 20:38:29.879005-05	SISTEMA	\N	\N	t
41	11	APR	Aprobada	\N	3	t	2026-01-27 20:38:29.879005-05	SISTEMA	\N	\N	t
42	11	REC	Rechazada	\N	4	t	2026-01-27 20:38:29.879005-05	SISTEMA	\N	\N	t
44	12	PEN	Pendiente	\N	2	t	2026-01-27 20:38:29.880009-05	SISTEMA	\N	\N	t
45	12	ANU	Anulado	\N	3	t	2026-01-27 20:38:29.880009-05	SISTEMA	\N	\N	t
46	13	PAG	Pagado	\N	1	t	2026-01-27 20:38:29.881027-05	SISTEMA	\N	\N	t
47	13	PAR	Parcial	\N	2	t	2026-01-27 20:38:29.881027-05	SISTEMA	\N	\N	t
48	13	CRE	A CrÃƒÂ©dito	\N	3	t	2026-01-27 20:38:29.881027-05	SISTEMA	\N	\N	t
49	13	PEN	Pendiente	\N	4	t	2026-01-27 20:38:29.881027-05	SISTEMA	\N	\N	t
50	13	ANU	Anulado	\N	5	t	2026-01-27 20:38:29.881027-05	SISTEMA	\N	\N	t
5	2	BOL	Boleta de Venta	\N	1	t	2026-01-27 20:38:29.870018-05	SISTEMA	\N	\N	t
6	2	FAC	Factura	\N	2	t	2026-01-27 20:38:29.870018-05	SISTEMA	\N	\N	t
7	2	NVT	Nota de Venta	\N	3	t	2026-01-27 20:38:29.870018-05	SISTEMA	\N	\N	t
8	2	TK	Ticket	\N	4	t	2026-01-27 20:38:29.870018-05	SISTEMA	\N	\N	t
36	9	CVT	Convertida a Venta	\N	5	t	2026-01-27 20:38:29.87705-05	SISTEMA	\N	\N	t
\.


--
-- TOC entry 4555 (class 0 OID 47695)
-- Dependencies: 343
-- Data for Name: tipo_afectacion_igv; Type: TABLE DATA; Schema: configuracion; Owner: -
--

COPY configuracion.tipo_afectacion_igv (id_afectacion, codigo, nombre, afecta_igv, es_exportacion, activo, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion) FROM stdin;
1	10	GRAVADO - OPERACION ONEROSA	t	f	t	t	2026-03-16 09:20:16.533236-05	SYSTEM	\N	\N
2	11	GRAVADO - RETIRO POR PREMIO	t	f	t	t	2026-03-16 09:20:16.533236-05	SYSTEM	\N	\N
3	12	GRAVADO - RETIRO POR DONACION	t	f	t	t	2026-03-16 09:20:16.533236-05	SYSTEM	\N	\N
4	13	GRAVADO - RETIRO	t	f	t	t	2026-03-16 09:20:16.533236-05	SYSTEM	\N	\N
5	14	GRAVADO - RETIRO POR PUBLICIDAD	t	f	t	t	2026-03-16 09:20:16.533236-05	SYSTEM	\N	\N
6	15	GRAVADO - BONIFICACIONES	t	f	t	t	2026-03-16 09:20:16.533236-05	SYSTEM	\N	\N
7	16	GRAVADO - RETIRO POR ENTREGA A TRABAJADORES	t	f	t	t	2026-03-16 09:20:16.533236-05	SYSTEM	\N	\N
8	17	GRAVADO - IVAP	t	f	t	t	2026-03-16 09:20:16.533236-05	SYSTEM	\N	\N
9	20	EXONERADO - OPERACION ONEROSA	f	f	t	t	2026-03-16 09:20:16.533236-05	SYSTEM	\N	\N
10	21	EXONERADO - TRANSFERENCIA GRATUITA	f	f	t	t	2026-03-16 09:20:16.533236-05	SYSTEM	\N	\N
11	30	INAFECTO - OPERACION ONEROSA	f	f	t	t	2026-03-16 09:20:16.533236-05	SYSTEM	\N	\N
12	31	INAFECTO - RETIRO POR BONIFICACION	f	f	t	t	2026-03-16 09:20:16.533236-05	SYSTEM	\N	\N
13	32	INAFECTO - RETIRO	f	f	t	t	2026-03-16 09:20:16.533236-05	SYSTEM	\N	\N
14	33	INAFECTO - RETIRO POR MUESTRAS MEDICAS	f	f	t	t	2026-03-16 09:20:16.533236-05	SYSTEM	\N	\N
15	34	INAFECTO - TRANSFERENCIA GRATUITA	f	f	t	t	2026-03-16 09:20:16.533236-05	SYSTEM	\N	\N
16	35	INAFECTO - RETIRO POR PUBLICIDAD	f	f	t	t	2026-03-16 09:20:16.533236-05	SYSTEM	\N	\N
17	36	INAFECTO - BONIFICACIONES	f	f	t	t	2026-03-16 09:20:16.533236-05	SYSTEM	\N	\N
18	37	INAFECTO - RETIRO POR ENTREGA A TRABAJADORES	f	f	t	t	2026-03-16 09:20:16.533236-05	SYSTEM	\N	\N
19	40	EXPORTACION DE BIENES O SERVICIOS	f	t	t	t	2026-03-16 09:20:16.533236-05	SYSTEM	\N	\N
\.


--
-- TOC entry 4527 (class 0 OID 47212)
-- Dependencies: 315
-- Data for Name: tipo_comprobante; Type: TABLE DATA; Schema: configuracion; Owner: -
--

COPY configuracion.tipo_comprobante (id_tipo_comprobante, codigo, nombre, mueve_stock, tipo_movimiento_stock, es_venta, es_compra, es_orden_compra, activado, fecha_creacion, usuario_creacion, es_emitible, es_referenciable, movimiento_stock_venta, movimiento_stock_compra, fecha_modificacion, usuario_modificacion) FROM stdin;
1	01	FACTURA	t	SALIDA	t	f	f	t	2026-03-16 09:20:16.511112-05	SYSTEM	t	t	SALIDA	NEUTRO	\N	\N
2	03	BOLETA DE VENTA	t	SALIDA	t	f	f	t	2026-03-16 09:20:16.511112-05	SYSTEM	t	t	SALIDA	NEUTRO	\N	\N
3	02	RECIBO POR HONORARIOS	f	NEUTRO	t	f	f	t	2026-03-16 09:20:16.511112-05	SYSTEM	t	t	NEUTRO	NEUTRO	\N	\N
4	04	LIQUIDACION DE COMPRA	t	ENTRADA	f	t	f	t	2026-03-16 09:20:16.511112-05	SYSTEM	t	t	NEUTRO	ENTRADA	\N	\N
5	07	NOTA DE CREDITO	t	DEPENDIENTE	f	f	f	t	2026-03-16 09:20:16.511112-05	SYSTEM	t	t	ENTRADA	SALIDA	\N	\N
6	08	NOTA DE DEBITO	f	NEUTRO	f	f	f	t	2026-03-16 09:20:16.511112-05	SYSTEM	t	t	NEUTRO	NEUTRO	\N	\N
7	09	GUIA DE REMISION REMITENTE	f	NEUTRO	f	f	f	t	2026-03-16 09:20:16.511112-05	SYSTEM	f	t	NEUTRO	NEUTRO	\N	\N
8	31	GUIA DE REMISION TRANSPORTISTA	f	NEUTRO	f	f	f	t	2026-03-16 09:20:16.511112-05	SYSTEM	f	t	NEUTRO	NEUTRO	\N	\N
9	50	DUA	f	NEUTRO	f	f	f	t	2026-03-16 09:20:16.511112-05	SYSTEM	f	t	NEUTRO	NEUTRO	\N	\N
10	52	DESPACHO SIMPLIFICADO	f	NEUTRO	f	f	f	t	2026-03-16 09:20:16.511112-05	SYSTEM	f	t	NEUTRO	NEUTRO	\N	\N
11	87	NOTA DE CREDITO ESPECIAL	f	NEUTRO	f	f	f	t	2026-03-16 09:20:16.511112-05	SYSTEM	f	t	NEUTRO	NEUTRO	\N	\N
12	88	NOTA DE DEBITO ESPECIAL	f	NEUTRO	f	f	f	t	2026-03-16 09:20:16.511112-05	SYSTEM	f	t	NEUTRO	NEUTRO	\N	\N
13	99	ORDEN DE COMPRA	f	NEUTRO	f	f	t	t	2026-03-21 23:22:28.165364-05	SYSTEM	t	t	NEUTRO	NEUTRO	\N	\N
\.


--
-- TOC entry 4525 (class 0 OID 47198)
-- Dependencies: 313
-- Data for Name: tipo_documento; Type: TABLE DATA; Schema: configuracion; Owner: -
--

COPY configuracion.tipo_documento (id_regla, codigo, nombre, longitud, longitud_maxima, es_numerico, estado, activado, fecha_creacion, usuario_creacion, es_persona_natural, es_empresa, aplica_sin_ruc, es_documento_relacionado, es_documento_identidad, fecha_modificacion, usuario_modificacion) FROM stdin;
6	A	CEDULA DIPLOMATICA de IDENTIDAD	6	15	f	t	t	2026-03-16 09:20:16.504337-05	SYSTEM	t	f	f	f	t	\N	\N
7	B	DOC. IDENTIDAD PAIS DE RESIDENCIA	6	15	f	t	t	2026-03-16 09:20:16.504337-05	SYSTEM	t	f	f	f	t	\N	\N
1	0	SIN DOCUMENTO	1	1	f	t	t	2026-03-16 09:20:16.504337-05	SYSTEM	t	f	t	f	t	2026-03-21 21:01:41.451695-05	\N
2	1	DNI	8	8	t	t	t	2026-03-16 09:20:16.504337-05	SYSTEM	t	f	f	f	t	2026-03-21 21:01:41.451695-05	\N
3	4	CARNET DE EXTRANJERIA	9	12	f	t	t	2026-03-16 09:20:16.504337-05	SYSTEM	t	f	f	f	t	2026-03-21 21:01:41.451695-05	\N
4	6	RUC	11	11	t	t	t	2026-03-16 09:20:16.504337-05	SYSTEM	f	t	f	f	t	2026-03-21 21:01:41.451695-05	\N
5	7	PASAPORTE	6	17	f	t	t	2026-03-16 09:20:16.504337-05	SYSTEM	t	f	f	f	t	2026-03-21 21:01:41.451695-05	\N
\.


--
-- TOC entry 4529 (class 0 OID 47228)
-- Dependencies: 317
-- Data for Name: tipo_operacion_sunat; Type: TABLE DATA; Schema: configuracion; Owner: -
--

COPY configuracion.tipo_operacion_sunat (id_tipo_operacion, codigo, nombre, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion) FROM stdin;
1	0101	VENTA INTERNA	t	2026-03-16 09:20:16.512683	SYSTEM	\N	\N
2	0112	VENTA INTERNA - GASTOS DEDUCIBLES	t	2026-03-16 09:20:16.512683	SYSTEM	\N	\N
3	0113	VENTA INTERNA - NRUS	t	2026-03-16 09:20:16.512683	SYSTEM	\N	\N
4	0200	EXPORTACION DE BIENES	t	2026-03-16 09:20:16.512683	SYSTEM	\N	\N
5	0201	EXPORTACION DE SERVICIOS	t	2026-03-16 09:20:16.512683	SYSTEM	\N	\N
6	0202	EXPORTACION - HOSPEDAJE	t	2026-03-16 09:20:16.512683	SYSTEM	\N	\N
7	0300	NO ONEROSA - ADQUISICION DE BIENES	t	2026-03-16 09:20:16.512683	SYSTEM	\N	\N
8	0401	TRASLADO ENTRE ESTABLECIMIENTOS	t	2026-03-16 09:20:16.512683	SYSTEM	\N	\N
9	1001	OPERACION SUJETA A DETRACCION	t	2026-03-16 09:20:16.512683	SYSTEM	\N	\N
10	2001	OPERACION SUJETA A PERCEPCION	t	2026-03-16 09:20:16.512683	SYSTEM	\N	\N
\.


--
-- TOC entry 4580 (class 0 OID 66867)
-- Dependencies: 375
-- Data for Name: ubigeos; Type: TABLE DATA; Schema: configuracion; Owner: -
--

COPY configuracion.ubigeos (codigo, nombre, nivel, parent_id, id, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion) FROM stdin;
01	AMAZONAS	1	\N	1	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
02	ANCASH	1	\N	2	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
03	APURIMAC	1	\N	3	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
04	AREQUIPA	1	\N	4	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
05	AYACUCHO	1	\N	5	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
06	CAJAMARCA	1	\N	6	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
07	CALLAO	1	\N	7	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
08	CUSCO	1	\N	8	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
09	HUANCAVELICA	1	\N	9	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
10	HUANUCO	1	\N	10	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
11	ICA	1	\N	11	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
12	JUNIN	1	\N	12	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
13	LA LIBERTAD	1	\N	13	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
14	LAMBAYEQUE	1	\N	14	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
15	LIMA	1	\N	15	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
16	LORETO	1	\N	16	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
17	MADRE DE DIOS	1	\N	17	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
18	MOQUEGUA	1	\N	18	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
19	PASCO	1	\N	19	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
20	PIURA	1	\N	20	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
21	PUNO	1	\N	21	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
22	SAN MARTIN	1	\N	22	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
23	TACNA	1	\N	23	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
24	TUMBES	1	\N	24	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
25	UCAYALI	1	\N	25	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0101	CHACHAPOYAS	2	01	26	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0102	BAGUA	2	01	27	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0103	BONGARA	2	01	28	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0104	CONDORCANQUI	2	01	29	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0105	LUYA	2	01	30	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0106	RODRIGUEZ DE MENDOZA	2	01	31	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0107	UTCUBAMBA	2	01	32	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0201	HUARAZ	2	02	33	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0202	AIJA	2	02	34	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0203	ANTONIO RAYMONDI	2	02	35	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0204	ASUNCION	2	02	36	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0205	BOLOGNESI	2	02	37	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0206	CARHUAZ	2	02	38	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0207	CARLOS FERMIN FITZCARRALD	2	02	39	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0208	CASMA	2	02	40	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0209	CORONGO	2	02	41	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0210	HUARI	2	02	42	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0211	HUARMEY	2	02	43	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0212	HUAYLAS	2	02	44	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0213	MARISCAL LUZURIAGA	2	02	45	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0214	OCROS	2	02	46	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0215	PALLASCA	2	02	47	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0216	POMABAMBA	2	02	48	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0217	RECUAY	2	02	49	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0218	SANTA	2	02	50	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0219	SIHUAS	2	02	51	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0220	YUNGAY	2	02	52	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0301	ABANCAY	2	03	53	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0302	ANDAHUAYLAS	2	03	54	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0303	ANTABAMBA	2	03	55	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0304	AYMARAES	2	03	56	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0305	COTABAMBAS	2	03	57	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0306	CHINCHEROS	2	03	58	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0307	GRAU	2	03	59	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0401	AREQUIPA	2	04	60	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0402	CAMANA	2	04	61	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0403	CARAVELI	2	04	62	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0404	CASTILLA	2	04	63	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0405	CAYLLOMA	2	04	64	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0406	CONDESUYOS	2	04	65	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0407	ISLAY	2	04	66	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0408	LA UNION	2	04	67	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0501	HUAMANGA	2	05	68	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0502	CANGALLO	2	05	69	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0503	HUANCA SANCOS	2	05	70	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0504	HUANTA	2	05	71	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0505	LA MAR	2	05	72	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0506	LUCANAS	2	05	73	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0507	PARINACOCHAS	2	05	74	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0508	PAUCAR DEL SARA SARA	2	05	75	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0509	SUCRE	2	05	76	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0510	VICTOR FAJARDO	2	05	77	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0511	VILCAS HUAMAN	2	05	78	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0601	CAJAMARCA	2	06	79	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0602	CAJABAMBA	2	06	80	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0603	CELENDIN	2	06	81	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0604	CHOTA	2	06	82	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0605	CONTUMAZA	2	06	83	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0606	CUTERVO	2	06	84	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0607	HUALGAYOC	2	06	85	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0608	JAEN	2	06	86	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0609	SAN IGNACIO	2	06	87	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0610	SAN MARCOS	2	06	88	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0611	SAN MIGUEL	2	06	89	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0612	SAN PABLO	2	06	90	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0613	SANTA CRUZ	2	06	91	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0701	CALLAO	2	07	92	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0801	CUSCO	2	08	93	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0802	ACOMAYO	2	08	94	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0803	ANTA	2	08	95	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0804	CALCA	2	08	96	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0805	CANAS	2	08	97	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0806	CANCHIS	2	08	98	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0807	CHUMBIVILCAS	2	08	99	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0808	ESPINAR	2	08	100	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0809	LA CONVENCION	2	08	101	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0810	PARURO	2	08	102	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0811	PAUCARTAMBO	2	08	103	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0812	QUISPICANCHI	2	08	104	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0813	URUBAMBA	2	08	105	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0901	HUANCAVELICA	2	09	106	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0902	ACOBAMBA	2	09	107	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0903	ANGARAES	2	09	108	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0904	CASTROVIRREYNA	2	09	109	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0905	CHURCAMPA	2	09	110	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0906	HUAYTARA	2	09	111	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
0907	TAYACAJA	2	09	112	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1001	HUANUCO	2	10	113	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1002	AMBO	2	10	114	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1003	DOS DE MAYO	2	10	115	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1004	HUACAYBAMBA	2	10	116	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1005	HUAMALIES	2	10	117	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1006	LEONCIO PRADO	2	10	118	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1007	MARAÑON	2	10	119	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1008	PACHITEA	2	10	120	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1009	PUERTO INCA	2	10	121	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1010	LAURICOCHA	2	10	122	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1011	YAROWILCA	2	10	123	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1101	ICA	2	11	124	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1102	CHINCHA	2	11	125	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1103	NAZCA	2	11	126	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1104	PALPA	2	11	127	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1105	PISCO	2	11	128	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1201	HUANCAYO	2	12	129	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1202	CONCEPCION	2	12	130	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1203	CHANCHAMAYO	2	12	131	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1204	JAUJA	2	12	132	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1205	JUNIN	2	12	133	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1206	SATIPO	2	12	134	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1207	TARMA	2	12	135	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1208	YAULI	2	12	136	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1209	CHUPACA	2	12	137	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1301	TRUJILLO	2	13	138	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1302	ASCOPE	2	13	139	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1303	BOLIVAR	2	13	140	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1304	CHEPEN	2	13	141	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1305	JULCAN	2	13	142	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1306	OTUZCO	2	13	143	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1307	PACASMAYO	2	13	144	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1308	PATAZ	2	13	145	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1309	SANCHEZ CARRION	2	13	146	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1310	SANTIAGO DE CHUCO	2	13	147	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1311	GRAN CHIMU	2	13	148	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1312	VIRU	2	13	149	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1401	CHICLAYO	2	14	150	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1402	FERREÑAFE	2	14	151	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1403	LAMBAYEQUE	2	14	152	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1501	LIMA	2	15	153	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1502	BARRANCA	2	15	154	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1503	CAJATAMBO	2	15	155	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1504	CANTA	2	15	156	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1505	CAÑETE	2	15	157	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1506	HUARAL	2	15	158	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1507	HUAROCHIRI	2	15	159	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1508	HUAURA	2	15	160	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1509	OYON	2	15	161	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1510	YAUYOS	2	15	162	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1601	MAYNAS	2	16	163	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1602	ALTO AMAZONAS	2	16	164	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1603	LORETO	2	16	165	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1604	MARISCAL RAMON CASTILLA	2	16	166	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1605	REQUENA	2	16	167	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1606	UCAYALI	2	16	168	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1607	DATEM DEL MARAÑON	2	16	169	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1608	PUTUMAYO	2	16	170	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1701	TAMBOPATA	2	17	171	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1702	MANU	2	17	172	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1703	TAHUAMANU	2	17	173	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1801	MARISCAL NIETO	2	18	174	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1802	GENERAL SANCHEZ CERRO	2	18	175	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1803	ILO	2	18	176	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1901	PASCO	2	19	177	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1902	DANIEL ALCIDES CARRION	2	19	178	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
1903	OXAPAMPA	2	19	179	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2001	PIURA	2	20	180	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2002	AYABACA	2	20	181	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2003	HUANCABAMBA	2	20	182	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2004	MORROPON	2	20	183	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2005	PAITA	2	20	184	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2006	SULLANA	2	20	185	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2007	TALARA	2	20	186	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2008	SECHURA	2	20	187	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2101	PUNO	2	21	188	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2102	AZANGARO	2	21	189	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2103	CARABAYA	2	21	190	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2104	CHUCUITO	2	21	191	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2105	EL COLLAO	2	21	192	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2106	HUANCANE	2	21	193	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2107	LAMPA	2	21	194	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2108	MELGAR	2	21	195	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2109	MOHO	2	21	196	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2110	SAN ANTONIO DE PUTINA	2	21	197	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2111	SAN ROMAN	2	21	198	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2112	SANDIA	2	21	199	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2113	YUNGUYO	2	21	200	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2201	MOYOBAMBA	2	22	201	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2202	BELLAVISTA	2	22	202	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2203	EL DORADO	2	22	203	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2204	HUALLAGA	2	22	204	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2205	LAMAS	2	22	205	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2206	MARISCAL CACERES	2	22	206	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2207	PICOTA	2	22	207	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2208	RIOJA	2	22	208	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2209	SAN MARTIN	2	22	209	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2210	TOCACHE	2	22	210	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2301	TACNA	2	23	211	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2302	CANDARAVE	2	23	212	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2303	JORGE BASADRE	2	23	213	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2304	TARATA	2	23	214	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2401	TUMBES	2	24	215	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2402	CONTRALMIRANTE VILLAR	2	24	216	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2403	ZARUMILLA	2	24	217	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2501	CORONEL PORTILLO	2	25	218	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2502	ATALAYA	2	25	219	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2503	PADRE ABAD	2	25	220	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
2504	PURUS	2	25	221	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010101	CHACHAPOYAS	3	0101	222	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010102	ASUNCION	3	0101	223	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010103	BALSAS	3	0101	224	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010104	CHETO	3	0101	225	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010105	CHILIQUIN	3	0101	226	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010106	CHUQUIBAMBA	3	0101	227	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010107	GRANADA	3	0101	228	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010108	HUANCAS	3	0101	229	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010109	LA JALCA	3	0101	230	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010110	LEIMEBAMBA	3	0101	231	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010111	LEVANTO	3	0101	232	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010112	MAGDALENA	3	0101	233	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010113	MARISCAL CASTILLA	3	0101	234	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010114	MOLINOPAMPA	3	0101	235	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010115	MONTEVIDEO	3	0101	236	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010116	OLLEROS	3	0101	237	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010117	QUINJALCA	3	0101	238	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010118	SAN FRANCISCO DE DAGUAS	3	0101	239	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010119	SAN ISIDRO DE MAINO	3	0101	240	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010120	SOLOCO	3	0101	241	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010121	SONCHE	3	0101	242	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010201	BAGUA	3	0102	243	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010202	ARAMANGO	3	0102	244	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010203	COPALLIN	3	0102	245	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010204	EL PARCO	3	0102	246	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010205	IMAZA	3	0102	247	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010206	LA PECA	3	0102	248	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010301	JUMBILLA	3	0103	249	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010302	CHISQUILLA	3	0103	250	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010303	CHURUJA	3	0103	251	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010304	COROSHA	3	0103	252	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010305	CUISPES	3	0103	253	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010306	FLORIDA	3	0103	254	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010307	JAZAN	3	0103	255	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010308	RECTA	3	0103	256	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010309	SAN CARLOS	3	0103	257	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010310	SHIPASBAMBA	3	0103	258	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010311	VALERA	3	0103	259	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010312	YAMBRASBAMBA	3	0103	260	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010401	NIEVA	3	0104	261	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010402	EL CENEPA	3	0104	262	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010403	RIO SANTIAGO	3	0104	263	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010501	LAMUD	3	0105	264	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010502	CAMPORREDONDO	3	0105	265	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010503	COCABAMBA	3	0105	266	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010504	COLCAMAR	3	0105	267	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010505	CONILA	3	0105	268	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010506	INGUILPATA	3	0105	269	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010507	LONGUITA	3	0105	270	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010508	LONYA CHICO	3	0105	271	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010509	LUYA	3	0105	272	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010510	LUYA VIEJO	3	0105	273	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010511	MARIA	3	0105	274	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010512	OCALLI	3	0105	275	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010513	OCUMAL	3	0105	276	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010514	PISUQUIA	3	0105	277	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010515	PROVIDENCIA	3	0105	278	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010516	SAN CRISTOBAL	3	0105	279	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010517	SAN FRANCISCO DEL YESO	3	0105	280	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010518	SAN JERONIMO	3	0105	281	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010519	SAN JUAN DE LOPECANCHA	3	0105	282	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010520	SANTA CATALINA	3	0105	283	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010521	SANTO TOMAS	3	0105	284	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010522	TINGO	3	0105	285	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010523	TRITA	3	0105	286	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010601	SAN NICOLAS	3	0106	287	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010602	CHIRIMOTO	3	0106	288	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010603	COCHAMAL	3	0106	289	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010604	HUAMBO	3	0106	290	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010605	LIMABAMBA	3	0106	291	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010606	LONGAR	3	0106	292	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010607	MARISCAL BENAVIDES	3	0106	293	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010608	MILPUC	3	0106	294	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010609	OMIA	3	0106	295	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010610	SANTA ROSA	3	0106	296	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010611	TOTORA	3	0106	297	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010612	VISTA ALEGRE	3	0106	298	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010701	BAGUA GRANDE	3	0107	299	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010702	CAJARURO	3	0107	300	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010703	CUMBA	3	0107	301	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010704	EL MILAGRO	3	0107	302	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010705	JAMALCA	3	0107	303	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010706	LONYA GRANDE	3	0107	304	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
010707	YAMON	3	0107	305	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020101	HUARAZ	3	0201	306	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020102	COCHABAMBA	3	0201	307	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020103	COLCABAMBA	3	0201	308	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020104	HUANCHAY	3	0201	309	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020105	INDEPENDENCIA	3	0201	310	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020106	JANGAS	3	0201	311	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020107	LA LIBERTAD	3	0201	312	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020108	OLLEROS	3	0201	313	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020109	PAMPAS	3	0201	314	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020110	PARIACOTO	3	0201	315	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020111	PIRA	3	0201	316	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020112	TARICA	3	0201	317	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020201	AIJA	3	0202	318	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020202	CORIS	3	0202	319	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020203	HUACLLAN	3	0202	320	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020204	LA MERCED	3	0202	321	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020205	SUCCHA	3	0202	322	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020301	LLAMELLIN	3	0203	323	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020302	ACZO	3	0203	324	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020303	CHACCHO	3	0203	325	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020304	CHINGAS	3	0203	326	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020305	MIRGAS	3	0203	327	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020306	SAN JUAN DE RONTOY	3	0203	328	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020401	CHACAS	3	0204	329	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020402	ACOCHACA	3	0204	330	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020501	CHIQUIAN	3	0205	331	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020502	ABELARDO PARDO LEZAMETA	3	0205	332	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020503	ANTONIO RAYMONDI	3	0205	333	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020504	AQUIA	3	0205	334	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020505	CAJACAY	3	0205	335	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020506	CANIS	3	0205	336	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020507	COLQUIOC	3	0205	337	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020508	HUALLANCA	3	0205	338	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020509	HUASTA	3	0205	339	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020510	HUAYLLACAYAN	3	0205	340	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020511	LA PRIMAVERA	3	0205	341	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020512	MANGAS	3	0205	342	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020513	PACLLON	3	0205	343	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020514	SAN MIGUEL DE CORPANQUI	3	0205	344	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020515	TICLLOS	3	0205	345	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020601	CARHUAZ	3	0206	346	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020602	ACOPAMPA	3	0206	347	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020603	AMASHCA	3	0206	348	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020604	ANTA	3	0206	349	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020605	ATAQUERO	3	0206	350	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020606	MARCARA	3	0206	351	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020607	PARIAHUANCA	3	0206	352	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020608	SAN MIGUEL DE ACO	3	0206	353	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020609	SHILLA	3	0206	354	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020610	TINCO	3	0206	355	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020611	YUNGAR	3	0206	356	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020701	SAN LUIS	3	0207	357	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020702	SAN NICOLAS	3	0207	358	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020703	YAUYA	3	0207	359	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020801	CASMA	3	0208	360	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020802	BUENA VISTA ALTA	3	0208	361	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020803	COMANDANTE NOEL	3	0208	362	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020804	YAUTAN	3	0208	363	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020901	CORONGO	3	0209	364	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020902	ACO	3	0209	365	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020903	BAMBAS	3	0209	366	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020904	CUSCA	3	0209	367	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020905	LA PAMPA	3	0209	368	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020906	YANAC	3	0209	369	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
020907	YUPAN	3	0209	370	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021001	HUARI	3	0210	371	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021002	ANRA	3	0210	372	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021003	CAJAY	3	0210	373	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021004	CHAVIN DE HUANTAR	3	0210	374	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021005	HUACACHI	3	0210	375	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021006	HUACCHIS	3	0210	376	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021007	HUACHIS	3	0210	377	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021008	HUANTAR	3	0210	378	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021009	MASIN	3	0210	379	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021010	PAUCAS	3	0210	380	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021011	PONTO	3	0210	381	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021012	RAHUAPAMPA	3	0210	382	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021013	RAPAYAN	3	0210	383	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021014	SAN MARCOS	3	0210	384	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021015	SAN PEDRO DE CHANA	3	0210	385	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021016	UCO	3	0210	386	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021101	HUARMEY	3	0211	387	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021102	COCHAPETI	3	0211	388	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021103	CULEBRAS	3	0211	389	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021104	HUAYAN	3	0211	390	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021105	MALVAS	3	0211	391	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021201	CARAZ	3	0212	392	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021202	HUALLANCA	3	0212	393	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021203	HUATA	3	0212	394	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021204	HUAYLAS	3	0212	395	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021205	MATO	3	0212	396	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021206	PAMPAROMAS	3	0212	397	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021207	PUEBLO LIBRE	3	0212	398	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021208	SANTA CRUZ	3	0212	399	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021209	SANTO TORIBIO	3	0212	400	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021210	YURACMARCA	3	0212	401	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021301	PISCOBAMBA	3	0213	402	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021302	CASCA	3	0213	403	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021303	ELEAZAR GUZMAN BARRON	3	0213	404	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021304	FIDEL OLIVAS ESCUDERO	3	0213	405	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021305	LLAMA	3	0213	406	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021306	LLUMPA	3	0213	407	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021307	LUCMA	3	0213	408	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021308	MUSGA	3	0213	409	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021401	OCROS	3	0214	410	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021402	ACAS	3	0214	411	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021403	CAJAMARQUILLA	3	0214	412	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021404	CARHUAPAMPA	3	0214	413	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021405	COCHAS	3	0214	414	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021406	CONGAS	3	0214	415	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021407	LLIPA	3	0214	416	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021408	SAN CRISTOBAL DE RAJAN	3	0214	417	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021409	SAN PEDRO	3	0214	418	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021410	SANTIAGO DE CHILCAS	3	0214	419	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021501	CABANA	3	0215	420	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021502	BOLOGNESI	3	0215	421	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021503	CONCHUCOS	3	0215	422	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021504	HUACASCHUQUE	3	0215	423	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021505	HUANDOVAL	3	0215	424	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021506	LACABAMBA	3	0215	425	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021507	LLAPO	3	0215	426	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021508	PALLASCA	3	0215	427	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021509	PAMPAS	3	0215	428	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021510	SANTA ROSA	3	0215	429	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021511	TAUCA	3	0215	430	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021601	POMABAMBA	3	0216	431	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021602	HUAYLLAN	3	0216	432	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021603	PAROBAMBA	3	0216	433	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021604	QUINUABAMBA	3	0216	434	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021701	RECUAY	3	0217	435	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021702	CATAC	3	0217	436	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021703	COTAPARACO	3	0217	437	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021704	HUAYLLAPAMPA	3	0217	438	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021705	LLACLLIN	3	0217	439	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021706	MARCA	3	0217	440	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021707	PAMPAS CHICO	3	0217	441	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021708	PARARIN	3	0217	442	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021709	TAPACOCHA	3	0217	443	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021710	TICAPAMPA	3	0217	444	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021801	CHIMBOTE	3	0218	445	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021802	CACERES DEL PERU	3	0218	446	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021803	COISHCO	3	0218	447	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021804	MACATE	3	0218	448	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021805	MORO	3	0218	449	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021806	NEPEÑA	3	0218	450	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021807	SAMANCO	3	0218	451	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021808	SANTA	3	0218	452	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021809	NUEVO CHIMBOTE	3	0218	453	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021901	SIHUAS	3	0219	454	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021902	ACOBAMBA	3	0219	455	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021903	ALFONSO UGARTE	3	0219	456	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021904	CASHAPAMPA	3	0219	457	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021905	CHINGALPO	3	0219	458	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021906	HUAYLLABAMBA	3	0219	459	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021907	QUICHES	3	0219	460	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021908	RAGASH	3	0219	461	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021909	SAN JUAN	3	0219	462	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
021910	SICSIBAMBA	3	0219	463	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
022001	YUNGAY	3	0220	464	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
022002	CASCAPARA	3	0220	465	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
022003	MANCOS	3	0220	466	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
022004	MATACOTO	3	0220	467	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
022005	QUILLO	3	0220	468	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
022006	RANRAHIRCA	3	0220	469	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
022007	SHUPLUY	3	0220	470	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
022008	YANAMA	3	0220	471	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030101	ABANCAY	3	0301	472	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030102	CHACOCHE	3	0301	473	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030103	CIRCA	3	0301	474	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030104	CURAHUASI	3	0301	475	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030105	HUANIPACA	3	0301	476	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030106	LAMBRAMA	3	0301	477	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030107	PICHIRHUA	3	0301	478	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030108	SAN PEDRO DE CACHORA	3	0301	479	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030109	TAMBURCO	3	0301	480	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030201	ANDAHUAYLAS	3	0302	481	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030202	ANDARAPA	3	0302	482	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030203	CHIARA	3	0302	483	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030204	HUANCARAMA	3	0302	484	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030205	HUANCARAY	3	0302	485	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030206	HUAYANA	3	0302	486	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030207	KISHUARA	3	0302	487	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030208	PACOBAMBA	3	0302	488	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030209	PACUCHA	3	0302	489	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030210	PAMPACHIRI	3	0302	490	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030211	POMACOCHA	3	0302	491	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030212	SAN ANTONIO DE CACHI	3	0302	492	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030213	SAN JERONIMO	3	0302	493	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030214	SAN MIGUEL DE CHACCRAMPA	3	0302	494	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030215	SANTA MARIA DE CHICMO	3	0302	495	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030216	TALAVERA	3	0302	496	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030217	TUMAY HUARACA	3	0302	497	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030218	TURPO	3	0302	498	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030219	KAQUIABAMBA	3	0302	499	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030220	JOSE MARIA ARGUEDAS	3	0302	500	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030301	ANTABAMBA	3	0303	501	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030302	EL ORO	3	0303	502	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030303	HUAQUIRCA	3	0303	503	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030304	JUAN ESPINOZA MEDRANO	3	0303	504	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030305	OROPESA	3	0303	505	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030306	PACHACONAS	3	0303	506	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030307	SABAINO	3	0303	507	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030401	CHALHUANCA	3	0304	508	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030402	CAPAYA	3	0304	509	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030403	CARAYBAMBA	3	0304	510	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030404	CHAPIMARCA	3	0304	511	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030405	COLCABAMBA	3	0304	512	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030406	COTARUSE	3	0304	513	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030407	HUAYLLO	3	0304	514	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030408	JUSTO APU SAHUARAURA	3	0304	515	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030409	LUCRE	3	0304	516	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030410	POCOHUANCA	3	0304	517	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030411	SAN JUAN DE CHACÑA	3	0304	518	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030412	SAÑAYCA	3	0304	519	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030413	SORAYA	3	0304	520	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030414	TAPAIRIHUA	3	0304	521	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030415	TINTAY	3	0304	522	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030416	TORAYA	3	0304	523	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030417	YANACA	3	0304	524	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030501	TAMBOBAMBA	3	0305	525	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030502	COTABAMBAS	3	0305	526	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030503	COYLLURQUI	3	0305	527	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030504	HAQUIRA	3	0305	528	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030505	MARA	3	0305	529	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030506	CHALLHUAHUACHO	3	0305	530	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030601	CHINCHEROS	3	0306	531	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030602	ANCO-HUALLO	3	0306	532	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030603	COCHARCAS	3	0306	533	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030604	HUACCANA	3	0306	534	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030605	OCOBAMBA	3	0306	535	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030606	ONGOY	3	0306	536	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030607	URANMARCA	3	0306	537	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030608	RANRACANCHA	3	0306	538	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030609	ROCCHACC	3	0306	539	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030610	EL PORVENIR	3	0306	540	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030611	LOS CHANKAS	3	0306	541	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030612	AHUAYRO	3	0306	542	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030701	CHUQUIBAMBILLA	3	0307	543	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030702	CURPAHUASI	3	0307	544	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030703	GAMARRA	3	0307	545	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030704	HUAYLLATI	3	0307	546	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030705	MAMARA	3	0307	547	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030706	MICAELA BASTIDAS	3	0307	548	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030707	PATAYPAMPA	3	0307	549	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030708	PROGRESO	3	0307	550	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030709	SAN ANTONIO	3	0307	551	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030710	SANTA ROSA	3	0307	552	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030711	TURPAY	3	0307	553	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030712	VILCABAMBA	3	0307	554	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030713	VIRUNDO	3	0307	555	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
030714	CURASCO	3	0307	556	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040101	AREQUIPA	3	0401	557	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040102	ALTO SELVA ALEGRE	3	0401	558	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040103	CAYMA	3	0401	559	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040104	CERRO COLORADO	3	0401	560	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040105	CHARACATO	3	0401	561	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040106	CHIGUATA	3	0401	562	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040107	JACOBO HUNTER	3	0401	563	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040108	LA JOYA	3	0401	564	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040109	MARIANO MELGAR	3	0401	565	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040110	MIRAFLORES	3	0401	566	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040111	MOLLEBAYA	3	0401	567	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040112	PAUCARPATA	3	0401	568	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040113	POCSI	3	0401	569	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040114	POLOBAYA	3	0401	570	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040115	QUEQUEÑA	3	0401	571	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040116	SABANDIA	3	0401	572	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040117	SACHACA	3	0401	573	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040118	SAN JUAN DE SIGUAS	3	0401	574	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040119	SAN JUAN DE TARUCANI	3	0401	575	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040120	SANTA ISABEL DE SIGUAS	3	0401	576	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040121	SANTA RITA DE SIGUAS	3	0401	577	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040122	SOCABAYA	3	0401	578	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040123	TIABAYA	3	0401	579	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040124	UCHUMAYO	3	0401	580	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040125	VITOR	3	0401	581	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040126	YANAHUARA	3	0401	582	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040127	YARABAMBA	3	0401	583	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040128	YURA	3	0401	584	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040129	JOSE LUIS BUSTAMANTE Y RIVERO	3	0401	585	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040201	CAMANA	3	0402	586	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040202	JOSE MARIA QUIMPER	3	0402	587	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040203	MARIANO NICOLAS VALCARCEL	3	0402	588	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040204	MARISCAL CACERES	3	0402	589	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040205	NICOLAS DE PIEROLA	3	0402	590	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040206	OCOÑA	3	0402	591	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040207	QUILCA	3	0402	592	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040208	SAMUEL PASTOR	3	0402	593	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040301	CARAVELI	3	0403	594	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040302	ACARI	3	0403	595	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040303	ATICO	3	0403	596	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040304	ATIQUIPA	3	0403	597	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040305	BELLA UNION	3	0403	598	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040306	CAHUACHO	3	0403	599	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040307	CHALA	3	0403	600	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040308	CHAPARRA	3	0403	601	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040309	HUANUHUANU	3	0403	602	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040310	JAQUI	3	0403	603	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040311	LOMAS	3	0403	604	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040312	QUICACHA	3	0403	605	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040313	YAUCA	3	0403	606	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040401	APLAO	3	0404	607	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040402	ANDAGUA	3	0404	608	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040403	AYO	3	0404	609	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040404	CHACHAS	3	0404	610	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040405	CHILCAYMARCA	3	0404	611	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040406	CHOCO	3	0404	612	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040407	HUANCARQUI	3	0404	613	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040408	MACHAGUAY	3	0404	614	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040409	ORCOPAMPA	3	0404	615	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040410	PAMPACOLCA	3	0404	616	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040411	TIPAN	3	0404	617	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040412	UÑON	3	0404	618	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040413	URACA	3	0404	619	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040414	VIRACO	3	0404	620	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040501	CHIVAY	3	0405	621	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040502	ACHOMA	3	0405	622	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040503	CABANACONDE	3	0405	623	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040504	CALLALLI	3	0405	624	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040505	CAYLLOMA	3	0405	625	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040506	COPORAQUE	3	0405	626	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040507	HUAMBO	3	0405	627	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040508	HUANCA	3	0405	628	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040509	ICHUPAMPA	3	0405	629	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040510	LARI	3	0405	630	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040511	LLUTA	3	0405	631	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040512	MACA	3	0405	632	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040513	MADRIGAL	3	0405	633	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040514	SAN ANTONIO DE CHUCA	3	0405	634	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040515	SIBAYO	3	0405	635	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040516	TAPAY	3	0405	636	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040517	TISCO	3	0405	637	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040518	TUTI	3	0405	638	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040519	YANQUE	3	0405	639	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040520	MAJES	3	0405	640	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040601	CHUQUIBAMBA	3	0406	641	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040602	ANDARAY	3	0406	642	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040603	CAYARANI	3	0406	643	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040604	CHICHAS	3	0406	644	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040605	IRAY	3	0406	645	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040606	RIO GRANDE	3	0406	646	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040607	SALAMANCA	3	0406	647	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040608	YANAQUIHUA	3	0406	648	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040701	MOLLENDO	3	0407	649	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040702	COCACHACRA	3	0407	650	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040703	DEAN VALDIVIA	3	0407	651	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040704	ISLAY	3	0407	652	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040705	MEJIA	3	0407	653	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040706	PUNTA DE BOMBON	3	0407	654	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040801	COTAHUASI	3	0408	655	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040802	ALCA	3	0408	656	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040803	CHARCANA	3	0408	657	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040804	HUAYNACOTAS	3	0408	658	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040805	PAMPAMARCA	3	0408	659	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040806	PUYCA	3	0408	660	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040807	QUECHUALLA	3	0408	661	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040808	SAYLA	3	0408	662	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040809	TAURIA	3	0408	663	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040810	TOMEPAMPA	3	0408	664	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
040811	TORO	3	0408	665	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050101	AYACUCHO	3	0501	666	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050102	ACOCRO	3	0501	667	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050103	ACOS VINCHOS	3	0501	668	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050104	CARMEN ALTO	3	0501	669	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050105	CHIARA	3	0501	670	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050106	OCROS	3	0501	671	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050107	PACAYCASA	3	0501	672	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050108	QUINUA	3	0501	673	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050109	SAN JOSE DE TICLLAS	3	0501	674	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050110	SAN JUAN BAUTISTA	3	0501	675	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050111	SANTIAGO DE PISCHA	3	0501	676	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050112	SOCOS	3	0501	677	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050113	TAMBILLO	3	0501	678	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050114	VINCHOS	3	0501	679	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050115	JESUS NAZARENO	3	0501	680	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050116	ANDRES AVELINO CACERES DORREGARAY	3	0501	681	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050201	CANGALLO	3	0502	682	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050202	CHUSCHI	3	0502	683	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050203	LOS MOROCHUCOS	3	0502	684	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050204	MARIA PARADO DE BELLIDO	3	0502	685	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050205	PARAS	3	0502	686	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050206	TOTOS	3	0502	687	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050301	SANCOS	3	0503	688	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050302	CARAPO	3	0503	689	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050303	SACSAMARCA	3	0503	690	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050304	SANTIAGO DE LUCANAMARCA	3	0503	691	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050401	HUANTA	3	0504	692	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050402	AYAHUANCO	3	0504	693	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050403	HUAMANGUILLA	3	0504	694	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050404	IGUAIN	3	0504	695	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050405	LURICOCHA	3	0504	696	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050406	SANTILLANA	3	0504	697	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050407	SIVIA	3	0504	698	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050408	LLOCHEGUA	3	0504	699	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050409	CANAYRE	3	0504	700	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050410	UCHURACCAY	3	0504	701	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050411	PUCACOLPA	3	0504	702	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050412	CHACA	3	0504	703	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050413	PUTIS	3	0504	704	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050501	SAN MIGUEL	3	0505	705	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050502	ANCO	3	0505	706	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050503	AYNA	3	0505	707	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050504	CHILCAS	3	0505	708	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050505	CHUNGUI	3	0505	709	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050506	LUIS CARRANZA	3	0505	710	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050507	SANTA ROSA	3	0505	711	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050508	TAMBO	3	0505	712	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050509	SAMUGARI	3	0505	713	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050510	ANCHIHUAY	3	0505	714	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050511	ORONCCOY	3	0505	715	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050512	UNION PROGRESO	3	0505	716	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050513	RIO MAGDALENA	3	0505	717	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050514	NINABAMBA	3	0505	718	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050515	PATIBAMBA	3	0505	719	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050601	PUQUIO	3	0506	720	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050602	AUCARA	3	0506	721	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050603	CABANA	3	0506	722	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050604	CARMEN SALCEDO	3	0506	723	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050605	CHAVIÑA	3	0506	724	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050606	CHIPAO	3	0506	725	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050607	HUAC-HUAS	3	0506	726	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050608	LARAMATE	3	0506	727	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050609	LEONCIO PRADO	3	0506	728	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050610	LLAUTA	3	0506	729	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050611	LUCANAS	3	0506	730	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050612	OCAÑA	3	0506	731	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050613	OTOCA	3	0506	732	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050614	SAISA	3	0506	733	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050615	SAN CRISTOBAL	3	0506	734	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050616	SAN JUAN	3	0506	735	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050617	SAN PEDRO	3	0506	736	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050618	SAN PEDRO DE PALCO	3	0506	737	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050619	SANCOS	3	0506	738	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050620	SANTA ANA DE HUAYCAHUACHO	3	0506	739	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050621	SANTA LUCIA	3	0506	740	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050701	CORACORA	3	0507	741	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050702	CHUMPI	3	0507	742	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050703	CORONEL CASTAÑEDA	3	0507	743	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050704	PACAPAUSA	3	0507	744	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050705	PULLO	3	0507	745	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050706	PUYUSCA	3	0507	746	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050707	SAN FRANCISCO DE RAVACAYCO	3	0507	747	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050708	UPAHUACHO	3	0507	748	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050801	PAUSA	3	0508	749	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050802	COLTA	3	0508	750	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050803	CORCULLA	3	0508	751	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050804	LAMPA	3	0508	752	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050805	MARCABAMBA	3	0508	753	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050806	OYOLO	3	0508	754	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050807	PARARCA	3	0508	755	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050808	SAN JAVIER DE ALPABAMBA	3	0508	756	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050809	SAN JOSE DE USHUA	3	0508	757	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050810	SARA SARA	3	0508	758	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050901	QUEROBAMBA	3	0509	759	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050902	BELEN	3	0509	760	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050903	CHALCOS	3	0509	761	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050904	CHILCAYOC	3	0509	762	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050905	HUACAÑA	3	0509	763	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050906	MORCOLLA	3	0509	764	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050907	PAICO	3	0509	765	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050908	SAN PEDRO DE LARCAY	3	0509	766	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050909	SAN SALVADOR DE QUIJE	3	0509	767	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050910	SANTIAGO DE PAUCARAY	3	0509	768	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
050911	SORAS	3	0509	769	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
051001	HUANCAPI	3	0510	770	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
051002	ALCAMENCA	3	0510	771	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
051003	APONGO	3	0510	772	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
051004	ASQUIPATA	3	0510	773	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
051005	CANARIA	3	0510	774	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
051006	CAYARA	3	0510	775	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
051007	COLCA	3	0510	776	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
051008	HUAMANQUIQUIA	3	0510	777	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
051009	HUANCARAYLLA	3	0510	778	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
051010	HUAYA	3	0510	779	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
051011	SARHUA	3	0510	780	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
051012	VILCANCHOS	3	0510	781	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
051101	VILCAS HUAMAN	3	0511	782	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
051102	ACCOMARCA	3	0511	783	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
051103	CARHUANCA	3	0511	784	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
051104	CONCEPCION	3	0511	785	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
051105	HUAMBALPA	3	0511	786	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
051106	INDEPENDENCIA	3	0511	787	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
051107	SAURAMA	3	0511	788	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
051108	VISCHONGO	3	0511	789	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060101	CAJAMARCA	3	0601	790	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060102	ASUNCION	3	0601	791	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060103	CHETILLA	3	0601	792	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060104	COSPAN	3	0601	793	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060105	ENCAÑADA	3	0601	794	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060106	JESUS	3	0601	795	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060107	LLACANORA	3	0601	796	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060108	LOS BAÑOS DEL INCA	3	0601	797	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060109	MAGDALENA	3	0601	798	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060110	MATARA	3	0601	799	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060111	NAMORA	3	0601	800	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060112	SAN JUAN	3	0601	801	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060201	CAJABAMBA	3	0602	802	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060202	CACHACHI	3	0602	803	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060203	CONDEBAMBA	3	0602	804	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060204	SITACOCHA	3	0602	805	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060301	CELENDIN	3	0603	806	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060302	CHUMUCH	3	0603	807	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060303	CORTEGANA	3	0603	808	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060304	HUASMIN	3	0603	809	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060305	JORGE CHAVEZ	3	0603	810	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060306	JOSE GALVEZ	3	0603	811	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060307	MIGUEL IGLESIAS	3	0603	812	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060308	OXAMARCA	3	0603	813	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060309	SOROCHUCO	3	0603	814	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060310	SUCRE	3	0603	815	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060311	UTCO	3	0603	816	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060312	LA LIBERTAD DE PALLAN	3	0603	817	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060401	CHOTA	3	0604	818	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060402	ANGUIA	3	0604	819	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060403	CHADIN	3	0604	820	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060404	CHIGUIRIP	3	0604	821	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060405	CHIMBAN	3	0604	822	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060406	CHOROPAMPA	3	0604	823	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060407	COCHABAMBA	3	0604	824	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060408	CONCHAN	3	0604	825	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060409	HUAMBOS	3	0604	826	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060410	LAJAS	3	0604	827	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060411	LLAMA	3	0604	828	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060412	MIRACOSTA	3	0604	829	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060413	PACCHA	3	0604	830	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060414	PION	3	0604	831	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060415	QUEROCOTO	3	0604	832	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060416	SAN JUAN DE LICUPIS	3	0604	833	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060417	TACABAMBA	3	0604	834	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060418	TOCMOCHE	3	0604	835	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060419	CHALAMARCA	3	0604	836	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060501	CONTUMAZA	3	0605	837	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060502	CHILETE	3	0605	838	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060503	CUPISNIQUE	3	0605	839	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060504	GUZMANGO	3	0605	840	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060505	SAN BENITO	3	0605	841	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060506	SANTA CRUZ DE TOLEDO	3	0605	842	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060507	TANTARICA	3	0605	843	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060508	YONAN	3	0605	844	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060601	CUTERVO	3	0606	845	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060602	CALLAYUC	3	0606	846	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060603	CHOROS	3	0606	847	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060604	CUJILLO	3	0606	848	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060605	LA RAMADA	3	0606	849	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060606	PIMPINGOS	3	0606	850	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060607	QUEROCOTILLO	3	0606	851	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060608	SAN ANDRES DE CUTERVO	3	0606	852	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060609	SAN JUAN DE CUTERVO	3	0606	853	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060610	SAN LUIS DE LUCMA	3	0606	854	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060611	SANTA CRUZ	3	0606	855	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060612	SANTO DOMINGO DE LA CAPILLA	3	0606	856	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060613	SANTO TOMAS	3	0606	857	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060614	SOCOTA	3	0606	858	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060615	TORIBIO CASANOVA	3	0606	859	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060701	BAMBAMARCA	3	0607	860	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060702	CHUGUR	3	0607	861	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060703	HUALGAYOC	3	0607	862	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060801	JAEN	3	0608	863	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060802	BELLAVISTA	3	0608	864	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060803	CHONTALI	3	0608	865	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060804	COLASAY	3	0608	866	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060805	HUABAL	3	0608	867	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060806	LAS PIRIAS	3	0608	868	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060807	POMAHUACA	3	0608	869	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060808	PUCARA	3	0608	870	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060809	SALLIQUE	3	0608	871	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060810	SAN FELIPE	3	0608	872	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060811	SAN JOSE DEL ALTO	3	0608	873	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060812	SANTA ROSA	3	0608	874	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060901	SAN IGNACIO	3	0609	875	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060902	CHIRINOS	3	0609	876	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060903	HUARANGO	3	0609	877	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060904	LA COIPA	3	0609	878	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060905	NAMBALLE	3	0609	879	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060906	SAN JOSE DE LOURDES	3	0609	880	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
060907	TABACONAS	3	0609	881	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
061001	PEDRO GALVEZ	3	0610	882	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
061002	CHANCAY	3	0610	883	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
061003	EDUARDO VILLANUEVA	3	0610	884	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
061004	GREGORIO PITA	3	0610	885	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
061005	ICHOCAN	3	0610	886	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
061006	JOSE MANUEL QUIROZ	3	0610	887	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
061007	JOSE SABOGAL	3	0610	888	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
061101	SAN MIGUEL	3	0611	889	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
061102	BOLIVAR	3	0611	890	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
061103	CALQUIS	3	0611	891	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
061104	CATILLUC	3	0611	892	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
061105	EL PRADO	3	0611	893	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
061106	LA FLORIDA	3	0611	894	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
061107	LLAPA	3	0611	895	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
061108	NANCHOC	3	0611	896	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
061109	NIEPOS	3	0611	897	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
061110	SAN GREGORIO	3	0611	898	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
061111	SAN SILVESTRE DE COCHAN	3	0611	899	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
061112	TONGOD	3	0611	900	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
061113	UNION AGUA BLANCA	3	0611	901	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
061201	SAN PABLO	3	0612	902	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
061202	SAN BERNARDINO	3	0612	903	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
061203	SAN LUIS	3	0612	904	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
061204	TUMBADEN	3	0612	905	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
061301	SANTA CRUZ	3	0613	906	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
061302	ANDABAMBA	3	0613	907	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
061303	CATACHE	3	0613	908	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
061304	CHANCAYBAÑOS	3	0613	909	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
061305	LA ESPERANZA	3	0613	910	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
061306	NINABAMBA	3	0613	911	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
061307	PULAN	3	0613	912	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
061308	SAUCEPAMPA	3	0613	913	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
061309	SEXI	3	0613	914	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
061310	UTICYACU	3	0613	915	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
061311	YAUYUCAN	3	0613	916	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
070101	CALLAO	3	0701	917	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
070102	BELLAVISTA	3	0701	918	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
070103	CARMEN DE LA LEGUA REYNOSO	3	0701	919	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
070104	LA PERLA	3	0701	920	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
070105	LA PUNTA	3	0701	921	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
070106	VENTANILLA	3	0701	922	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
070107	MI PERU	3	0701	923	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080101	CUSCO	3	0801	924	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080102	CCORCA	3	0801	925	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080103	POROY	3	0801	926	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080104	SAN JERONIMO	3	0801	927	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080105	SAN SEBASTIAN	3	0801	928	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080106	SANTIAGO	3	0801	929	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080107	SAYLLA	3	0801	930	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080108	WANCHAQ	3	0801	931	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080201	ACOMAYO	3	0802	932	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080202	ACOPIA	3	0802	933	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080203	ACOS	3	0802	934	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080204	MOSOC LLACTA	3	0802	935	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080205	POMACANCHI	3	0802	936	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080206	RONDOCAN	3	0802	937	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080207	SANGARARA	3	0802	938	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080301	ANTA	3	0803	939	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080302	ANCAHUASI	3	0803	940	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080303	CACHIMAYO	3	0803	941	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080304	CHINCHAYPUJIO	3	0803	942	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080305	HUAROCONDO	3	0803	943	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080306	LIMATAMBO	3	0803	944	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080307	MOLLEPATA	3	0803	945	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080308	PUCYURA	3	0803	946	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080309	ZURITE	3	0803	947	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080401	CALCA	3	0804	948	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080402	COYA	3	0804	949	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080403	LAMAY	3	0804	950	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080404	LARES	3	0804	951	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080405	PISAC	3	0804	952	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080406	SAN SALVADOR	3	0804	953	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080407	TARAY	3	0804	954	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080408	YANATILE	3	0804	955	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080501	YANAOCA	3	0805	956	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080502	CHECCA	3	0805	957	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080503	KUNTURKANKI	3	0805	958	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080504	LANGUI	3	0805	959	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080505	LAYO	3	0805	960	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080506	PAMPAMARCA	3	0805	961	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080507	QUEHUE	3	0805	962	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080508	TUPAC AMARU	3	0805	963	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080601	SICUANI	3	0806	964	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080602	CHECACUPE	3	0806	965	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080603	COMBAPATA	3	0806	966	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080604	MARANGANI	3	0806	967	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080605	PITUMARCA	3	0806	968	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080606	SAN PABLO	3	0806	969	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080607	SAN PEDRO	3	0806	970	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080608	TINTA	3	0806	971	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080701	SANTO TOMAS	3	0807	972	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080702	CAPACMARCA	3	0807	973	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080703	CHAMACA	3	0807	974	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080704	COLQUEMARCA	3	0807	975	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080705	LIVITACA	3	0807	976	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080706	LLUSCO	3	0807	977	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080707	QUIÑOTA	3	0807	978	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080708	VELILLE	3	0807	979	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080801	ESPINAR	3	0808	980	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080802	CONDOROMA	3	0808	981	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080803	COPORAQUE	3	0808	982	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080804	OCORURO	3	0808	983	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080805	PALLPATA	3	0808	984	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080806	PICHIGUA	3	0808	985	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080807	SUYCKUTAMBO	3	0808	986	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080808	ALTO PICHIGUA	3	0808	987	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080901	SANTA ANA	3	0809	988	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080902	ECHARATE	3	0809	989	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080903	HUAYOPATA	3	0809	990	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080904	MARANURA	3	0809	991	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080905	OCOBAMBA	3	0809	992	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080906	QUELLOUNO	3	0809	993	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080907	QUIMBIRI	3	0809	994	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080908	SANTA TERESA	3	0809	995	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080909	VILCABAMBA	3	0809	996	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080910	PICHARI	3	0809	997	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080911	INKAWASI	3	0809	998	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080912	VILLA VIRGEN	3	0809	999	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080913	VILLA KINTIARINA	3	0809	1000	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080914	MEGANTONI	3	0809	1001	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080915	KUMPIRUSHIATO	3	0809	1002	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080916	CIELO PUNCO	3	0809	1003	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080917	MANITEA	3	0809	1004	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
080918	UNION ASHÁNINKA	3	0809	1005	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
081001	PARURO	3	0810	1006	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
081002	ACCHA	3	0810	1007	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
081003	CCAPI	3	0810	1008	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
081004	COLCHA	3	0810	1009	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
081005	HUANOQUITE	3	0810	1010	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
081006	OMACHA	3	0810	1011	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
081007	PACCARITAMBO	3	0810	1012	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
081008	PILLPINTO	3	0810	1013	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
081009	YAURISQUE	3	0810	1014	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
081101	PAUCARTAMBO	3	0811	1015	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
081102	CAICAY	3	0811	1016	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
081103	CHALLABAMBA	3	0811	1017	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
081104	COLQUEPATA	3	0811	1018	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
081105	HUANCARANI	3	0811	1019	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
081106	KOSÑIPATA	3	0811	1020	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
081201	URCOS	3	0812	1021	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
081202	ANDAHUAYLILLAS	3	0812	1022	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
081203	CAMANTI	3	0812	1023	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
081204	CCARHUAYO	3	0812	1024	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
081205	CCATCA	3	0812	1025	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
081206	CUSIPATA	3	0812	1026	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
081207	HUARO	3	0812	1027	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
081208	LUCRE	3	0812	1028	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
081209	MARCAPATA	3	0812	1029	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
081210	OCONGATE	3	0812	1030	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
081211	OROPESA	3	0812	1031	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
081212	QUIQUIJANA	3	0812	1032	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
081301	URUBAMBA	3	0813	1033	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
081302	CHINCHERO	3	0813	1034	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
081303	HUAYLLABAMBA	3	0813	1035	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
081304	MACHUPICCHU	3	0813	1036	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
081305	MARAS	3	0813	1037	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
081306	OLLANTAYTAMBO	3	0813	1038	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
081307	YUCAY	3	0813	1039	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090101	HUANCAVELICA	3	0901	1040	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090102	ACOBAMBILLA	3	0901	1041	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090103	ACORIA	3	0901	1042	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090104	CONAYCA	3	0901	1043	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090105	CUENCA	3	0901	1044	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090106	HUACHOCOLPA	3	0901	1045	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090107	HUAYLLAHUARA	3	0901	1046	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090108	IZCUCHACA	3	0901	1047	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090109	LARIA	3	0901	1048	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090110	MANTA	3	0901	1049	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090111	MARISCAL CACERES	3	0901	1050	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090112	MOYA	3	0901	1051	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090113	NUEVO OCCORO	3	0901	1052	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090114	PALCA	3	0901	1053	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090115	PILCHACA	3	0901	1054	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090116	VILCA	3	0901	1055	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090117	YAULI	3	0901	1056	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090118	ASCENSION	3	0901	1057	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090119	HUANDO	3	0901	1058	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090201	ACOBAMBA	3	0902	1059	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090202	ANDABAMBA	3	0902	1060	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090203	ANTA	3	0902	1061	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090204	CAJA	3	0902	1062	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090205	MARCAS	3	0902	1063	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090206	PAUCARA	3	0902	1064	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090207	POMACOCHA	3	0902	1065	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090208	ROSARIO	3	0902	1066	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090301	LIRCAY	3	0903	1067	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090302	ANCHONGA	3	0903	1068	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090303	CALLANMARCA	3	0903	1069	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090304	CCOCHACCASA	3	0903	1070	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090305	CHINCHO	3	0903	1071	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090306	CONGALLA	3	0903	1072	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090307	HUANCA-HUANCA	3	0903	1073	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090308	HUAYLLAY GRANDE	3	0903	1074	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090309	JULCAMARCA	3	0903	1075	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090310	SAN ANTONIO DE ANTAPARCO	3	0903	1076	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090311	SANTO TOMAS DE PATA	3	0903	1077	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090312	SECCLLA	3	0903	1078	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090401	CASTROVIRREYNA	3	0904	1079	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090402	ARMA	3	0904	1080	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090403	AURAHUA	3	0904	1081	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090404	CAPILLAS	3	0904	1082	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090405	CHUPAMARCA	3	0904	1083	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090406	COCAS	3	0904	1084	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090407	HUACHOS	3	0904	1085	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090408	HUAMATAMBO	3	0904	1086	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090409	MOLLEPAMPA	3	0904	1087	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090410	SAN JUAN	3	0904	1088	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090411	SANTA ANA	3	0904	1089	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090412	TANTARA	3	0904	1090	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090413	TICRAPO	3	0904	1091	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090501	CHURCAMPA	3	0905	1092	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090502	ANCO	3	0905	1093	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090503	CHINCHIHUASI	3	0905	1094	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090504	EL CARMEN	3	0905	1095	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090505	LA MERCED	3	0905	1096	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090506	LOCROJA	3	0905	1097	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090507	PAUCARBAMBA	3	0905	1098	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090508	SAN MIGUEL DE MAYOCC	3	0905	1099	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090509	SAN PEDRO DE CORIS	3	0905	1100	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090510	PACHAMARCA	3	0905	1101	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090511	COSME	3	0905	1102	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090601	HUAYTARA	3	0906	1103	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090602	AYAVI	3	0906	1104	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090603	CORDOVA	3	0906	1105	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090604	HUAYACUNDO ARMA	3	0906	1106	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090605	LARAMARCA	3	0906	1107	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090606	OCOYO	3	0906	1108	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090607	PILPICHACA	3	0906	1109	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090608	QUERCO	3	0906	1110	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090609	QUITO-ARMA	3	0906	1111	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090610	SAN ANTONIO DE CUSICANCHA	3	0906	1112	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090611	SAN FRANCISCO DE SANGAYAICO	3	0906	1113	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090612	SAN ISIDRO	3	0906	1114	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090613	SANTIAGO DE CHOCORVOS	3	0906	1115	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090614	SANTIAGO DE QUIRAHUARA	3	0906	1116	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090615	SANTO DOMINGO DE CAPILLAS	3	0906	1117	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090616	TAMBO	3	0906	1118	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090701	PAMPAS	3	0907	1119	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090702	ACOSTAMBO	3	0907	1120	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090703	ACRAQUIA	3	0907	1121	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090704	AHUAYCHA	3	0907	1122	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090705	COLCABAMBA	3	0907	1123	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090706	DANIEL HERNANDEZ	3	0907	1124	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090707	HUACHOCOLPA	3	0907	1125	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090709	HUARIBAMBA	3	0907	1126	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090710	ÑAHUIMPUQUIO	3	0907	1127	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090711	PAZOS	3	0907	1128	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090713	QUISHUAR	3	0907	1129	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090714	SALCABAMBA	3	0907	1130	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090715	SALCAHUASI	3	0907	1131	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090716	SAN MARCOS DE ROCCHAC	3	0907	1132	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090717	SURCUBAMBA	3	0907	1133	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090718	TINTAY PUNCU	3	0907	1134	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090719	QUICHUAS	3	0907	1135	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090720	ANDAYMARCA	3	0907	1136	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090721	ROBLE	3	0907	1137	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090722	PICHOS	3	0907	1138	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090723	SANTIAGO DE TUCUMA	3	0907	1139	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090724	LAMBRAS	3	0907	1140	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
090725	COCHABAMBA	3	0907	1141	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100101	HUANUCO	3	1001	1142	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100102	AMARILIS	3	1001	1143	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100103	CHINCHAO	3	1001	1144	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100104	CHURUBAMBA	3	1001	1145	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100105	MARGOS	3	1001	1146	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100106	QUISQUI	3	1001	1147	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100107	SAN FRANCISCO DE CAYRAN	3	1001	1148	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100108	SAN PEDRO DE CHAULAN	3	1001	1149	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100109	SANTA MARIA DEL VALLE	3	1001	1150	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100110	YARUMAYO	3	1001	1151	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100111	PILLCO MARCA	3	1001	1152	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100112	YACUS	3	1001	1153	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100113	SAN PABLO DE PILLAO	3	1001	1154	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100201	AMBO	3	1002	1155	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100202	CAYNA	3	1002	1156	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100203	COLPAS	3	1002	1157	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100204	CONCHAMARCA	3	1002	1158	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100205	HUACAR	3	1002	1159	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100206	SAN FRANCISCO	3	1002	1160	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100207	SAN RAFAEL	3	1002	1161	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100208	TOMAY KICHWA	3	1002	1162	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100301	LA UNION	3	1003	1163	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100307	CHUQUIS	3	1003	1164	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100311	MARIAS	3	1003	1165	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100313	PACHAS	3	1003	1166	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100316	QUIVILLA	3	1003	1167	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100317	RIPAN	3	1003	1168	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100321	SHUNQUI	3	1003	1169	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100322	SILLAPATA	3	1003	1170	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100323	YANAS	3	1003	1171	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100401	HUACAYBAMBA	3	1004	1172	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100402	CANCHABAMBA	3	1004	1173	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100403	COCHABAMBA	3	1004	1174	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100404	PINRA	3	1004	1175	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100501	LLATA	3	1005	1176	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100502	ARANCAY	3	1005	1177	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100503	CHAVIN DE PARIARCA	3	1005	1178	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100504	JACAS GRANDE	3	1005	1179	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100505	JIRCAN	3	1005	1180	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100506	MIRAFLORES	3	1005	1181	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100507	MONZON	3	1005	1182	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100508	PUNCHAO	3	1005	1183	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100509	PUÑOS	3	1005	1184	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100510	SINGA	3	1005	1185	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100511	TANTAMAYO	3	1005	1186	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100601	RUPA-RUPA	3	1006	1187	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100602	DANIEL ALOMIAS ROBLES	3	1006	1188	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100603	HERMILIO VALDIZAN	3	1006	1189	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100604	JOSE CRESPO Y CASTILLO	3	1006	1190	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100605	LUYANDO	3	1006	1191	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100606	MARIANO DAMASO BERAUN	3	1006	1192	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100607	PUCAYACU	3	1006	1193	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100608	CASTILLO GRANDE	3	1006	1194	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100609	PUEBLO NUEVO	3	1006	1195	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100610	SANTO DOMINGO DE ANDA	3	1006	1196	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100701	HUACRACHUCO	3	1007	1197	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100702	CHOLON	3	1007	1198	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100703	SAN BUENAVENTURA	3	1007	1199	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100704	LA MORADA	3	1007	1200	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100705	SANTA ROSA DE ALTO YANAJANCA	3	1007	1201	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100801	PANAO	3	1008	1202	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100802	CHAGLLA	3	1008	1203	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100803	MOLINO	3	1008	1204	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100804	UMARI	3	1008	1205	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100901	PUERTO INCA	3	1009	1206	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100902	CODO DEL POZUZO	3	1009	1207	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100903	HONORIA	3	1009	1208	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100904	TOURNAVISTA	3	1009	1209	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
100905	YUYAPICHIS	3	1009	1210	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
101001	JESUS	3	1010	1211	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
101002	BAÑOS	3	1010	1212	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
101003	JIVIA	3	1010	1213	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
101004	QUEROPALCA	3	1010	1214	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
101005	RONDOS	3	1010	1215	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
101006	SAN FRANCISCO DE ASIS	3	1010	1216	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
101007	SAN MIGUEL DE CAURI	3	1010	1217	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
101101	CHAVINILLO	3	1011	1218	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
101102	CAHUAC	3	1011	1219	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
101103	CHACABAMBA	3	1011	1220	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
101104	APARICIO POMARES	3	1011	1221	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
101105	JACAS CHICO	3	1011	1222	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
101106	OBAS	3	1011	1223	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
101107	PAMPAMARCA	3	1011	1224	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
101108	CHORAS	3	1011	1225	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110101	ICA	3	1101	1226	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110102	LA TINGUIÑA	3	1101	1227	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110103	LOS AQUIJES	3	1101	1228	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110104	OCUCAJE	3	1101	1229	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110105	PACHACUTEC	3	1101	1230	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110106	PARCONA	3	1101	1231	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110107	PUEBLO NUEVO	3	1101	1232	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110108	SALAS	3	1101	1233	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110109	SAN JOSE DE LOS MOLINOS	3	1101	1234	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110110	SAN JUAN BAUTISTA	3	1101	1235	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110111	SANTIAGO	3	1101	1236	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110112	SUBTANJALLA	3	1101	1237	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110113	TATE	3	1101	1238	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110114	YAUCA DEL ROSARIO	3	1101	1239	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110201	CHINCHA ALTA	3	1102	1240	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110202	ALTO LARAN	3	1102	1241	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110203	CHAVIN	3	1102	1242	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110204	CHINCHA BAJA	3	1102	1243	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110205	EL CARMEN	3	1102	1244	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110206	GROCIO PRADO	3	1102	1245	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110207	PUEBLO NUEVO	3	1102	1246	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110208	SAN JUAN DE YANAC	3	1102	1247	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110209	SAN PEDRO DE HUACARPANA	3	1102	1248	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110210	SUNAMPE	3	1102	1249	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110211	TAMBO DE MORA	3	1102	1250	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110301	NAZCA	3	1103	1251	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110302	CHANGUILLO	3	1103	1252	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110303	EL INGENIO	3	1103	1253	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110304	MARCONA	3	1103	1254	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110305	VISTA ALEGRE	3	1103	1255	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110401	PALPA	3	1104	1256	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110402	LLIPATA	3	1104	1257	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110403	RIO GRANDE	3	1104	1258	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110404	SANTA CRUZ	3	1104	1259	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110405	TIBILLO	3	1104	1260	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110501	PISCO	3	1105	1261	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110502	HUANCANO	3	1105	1262	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110503	HUMAY	3	1105	1263	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110504	INDEPENDENCIA	3	1105	1264	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110505	PARACAS	3	1105	1265	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110506	SAN ANDRES	3	1105	1266	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110507	SAN CLEMENTE	3	1105	1267	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
110508	TUPAC AMARU INCA	3	1105	1268	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120101	HUANCAYO	3	1201	1269	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120104	CARHUACALLANGA	3	1201	1270	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120105	CHACAPAMPA	3	1201	1271	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120106	CHICCHE	3	1201	1272	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120107	CHILCA	3	1201	1273	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120108	CHONGOS ALTO	3	1201	1274	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120111	CHUPURO	3	1201	1275	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120112	COLCA	3	1201	1276	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120113	CULLHUAS	3	1201	1277	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120114	EL TAMBO	3	1201	1278	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120116	HUACRAPUQUIO	3	1201	1279	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120117	HUALHUAS	3	1201	1280	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120119	HUANCAN	3	1201	1281	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120120	HUASICANCHA	3	1201	1282	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120121	HUAYUCACHI	3	1201	1283	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120122	INGENIO	3	1201	1284	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120124	PARIAHUANCA	3	1201	1285	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120125	PILCOMAYO	3	1201	1286	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120126	PUCARA	3	1201	1287	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120127	QUICHUAY	3	1201	1288	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120128	QUILCAS	3	1201	1289	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120129	SAN AGUSTIN	3	1201	1290	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120130	SAN JERONIMO DE TUNAN	3	1201	1291	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120132	SAÑO	3	1201	1292	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120133	SAPALLANGA	3	1201	1293	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120134	SICAYA	3	1201	1294	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120135	SANTO DOMINGO DE ACOBAMBA	3	1201	1295	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120136	VIQUES	3	1201	1296	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120201	CONCEPCION	3	1202	1297	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120202	ACO	3	1202	1298	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120203	ANDAMARCA	3	1202	1299	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120204	CHAMBARA	3	1202	1300	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120205	COCHAS	3	1202	1301	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120206	COMAS	3	1202	1302	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120207	HEROINAS TOLEDO	3	1202	1303	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120208	MANZANARES	3	1202	1304	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120209	MARISCAL CASTILLA	3	1202	1305	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120210	MATAHUASI	3	1202	1306	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120211	MITO	3	1202	1307	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120212	NUEVE DE JULIO	3	1202	1308	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120213	ORCOTUNA	3	1202	1309	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120214	SAN JOSE DE QUERO	3	1202	1310	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120215	SANTA ROSA DE OCOPA	3	1202	1311	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120301	CHANCHAMAYO	3	1203	1312	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120302	PERENE	3	1203	1313	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120303	PICHANAQUI	3	1203	1314	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120304	SAN LUIS DE SHUARO	3	1203	1315	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120305	SAN RAMON	3	1203	1316	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120306	VITOC	3	1203	1317	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120401	JAUJA	3	1204	1318	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120402	ACOLLA	3	1204	1319	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120403	APATA	3	1204	1320	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120404	ATAURA	3	1204	1321	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120405	CANCHAYLLO	3	1204	1322	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120406	CURICACA	3	1204	1323	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120407	EL MANTARO	3	1204	1324	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120408	HUAMALI	3	1204	1325	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120409	HUARIPAMPA	3	1204	1326	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120410	HUERTAS	3	1204	1327	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120411	JANJAILLO	3	1204	1328	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120412	JULCAN	3	1204	1329	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120413	LEONOR ORDOÑEZ	3	1204	1330	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120414	LLOCLLAPAMPA	3	1204	1331	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120415	MARCO	3	1204	1332	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120416	MASMA	3	1204	1333	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120417	MASMA CHICCHE	3	1204	1334	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120418	MOLINOS	3	1204	1335	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120419	MONOBAMBA	3	1204	1336	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120420	MUQUI	3	1204	1337	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120421	MUQUIYAUYO	3	1204	1338	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120422	PACA	3	1204	1339	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120423	PACCHA	3	1204	1340	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120424	PANCAN	3	1204	1341	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120425	PARCO	3	1204	1342	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120426	POMACANCHA	3	1204	1343	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120427	RICRAN	3	1204	1344	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120428	SAN LORENZO	3	1204	1345	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120429	SAN PEDRO DE CHUNAN	3	1204	1346	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120430	SAUSA	3	1204	1347	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120431	SINCOS	3	1204	1348	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120432	TUNAN MARCA	3	1204	1349	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120433	YAULI	3	1204	1350	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120434	YAUYOS	3	1204	1351	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120501	JUNIN	3	1205	1352	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120502	CARHUAMAYO	3	1205	1353	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120503	ONDORES	3	1205	1354	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120504	ULCUMAYO	3	1205	1355	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120601	SATIPO	3	1206	1356	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120602	COVIRIALI	3	1206	1357	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120603	LLAYLLA	3	1206	1358	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120604	MAZAMARI	3	1206	1359	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120605	PAMPA HERMOSA	3	1206	1360	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120606	PANGOA	3	1206	1361	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120607	RIO NEGRO	3	1206	1362	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120608	RIO TAMBO	3	1206	1363	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120609	VIZCATAN DEL ENE	3	1206	1364	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120701	TARMA	3	1207	1365	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120702	ACOBAMBA	3	1207	1366	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120703	HUARICOLCA	3	1207	1367	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120704	HUASAHUASI	3	1207	1368	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120705	LA UNION	3	1207	1369	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120706	PALCA	3	1207	1370	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120707	PALCAMAYO	3	1207	1371	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120708	SAN PEDRO DE CAJAS	3	1207	1372	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120709	TAPO	3	1207	1373	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120801	LA OROYA	3	1208	1374	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120802	CHACAPALPA	3	1208	1375	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120803	HUAY-HUAY	3	1208	1376	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120804	MARCAPOMACOCHA	3	1208	1377	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120805	MOROCOCHA	3	1208	1378	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120806	PACCHA	3	1208	1379	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120807	SANTA BARBARA DE CARHUACAYAN	3	1208	1380	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120808	SANTA ROSA DE SACCO	3	1208	1381	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120809	SUITUCANCHA	3	1208	1382	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120810	YAULI	3	1208	1383	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120901	CHUPACA	3	1209	1384	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120902	AHUAC	3	1209	1385	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120903	CHONGOS BAJO	3	1209	1386	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120904	HUACHAC	3	1209	1387	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120905	HUAMANCACA CHICO	3	1209	1388	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120906	SAN JUAN DE YSCOS	3	1209	1389	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120907	SAN JUAN DE JARPA	3	1209	1390	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120908	TRES DE DICIEMBRE	3	1209	1391	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
120909	YANACANCHA	3	1209	1392	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130101	TRUJILLO	3	1301	1393	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130102	EL PORVENIR	3	1301	1394	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130103	FLORENCIA DE MORA	3	1301	1395	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130104	HUANCHACO	3	1301	1396	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130105	LA ESPERANZA	3	1301	1397	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130106	LAREDO	3	1301	1398	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130107	MOCHE	3	1301	1399	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130108	POROTO	3	1301	1400	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130109	SALAVERRY	3	1301	1401	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130110	SIMBAL	3	1301	1402	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130111	VICTOR LARCO HERRERA	3	1301	1403	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130201	ASCOPE	3	1302	1404	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130202	CHICAMA	3	1302	1405	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130203	CHOCOPE	3	1302	1406	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130204	MAGDALENA DE CAO	3	1302	1407	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130205	PAIJAN	3	1302	1408	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130206	RAZURI	3	1302	1409	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130207	SANTIAGO DE CAO	3	1302	1410	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130208	CASA GRANDE	3	1302	1411	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130301	BOLIVAR	3	1303	1412	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130302	BAMBAMARCA	3	1303	1413	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130303	CONDORMARCA	3	1303	1414	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130304	LONGOTEA	3	1303	1415	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130305	UCHUMARCA	3	1303	1416	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130306	UCUNCHA	3	1303	1417	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130401	CHEPEN	3	1304	1418	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130402	PACANGA	3	1304	1419	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130403	PUEBLO NUEVO	3	1304	1420	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130501	JULCAN	3	1305	1421	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130502	CALAMARCA	3	1305	1422	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130503	CARABAMBA	3	1305	1423	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130504	HUASO	3	1305	1424	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130601	OTUZCO	3	1306	1425	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130602	AGALLPAMPA	3	1306	1426	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130604	CHARAT	3	1306	1427	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130605	HUARANCHAL	3	1306	1428	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130606	LA CUESTA	3	1306	1429	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130608	MACHE	3	1306	1430	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130610	PARANDAY	3	1306	1431	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130611	SALPO	3	1306	1432	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130613	SINSICAP	3	1306	1433	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130614	USQUIL	3	1306	1434	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130701	SAN PEDRO DE LLOC	3	1307	1435	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130702	GUADALUPE	3	1307	1436	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130703	JEQUETEPEQUE	3	1307	1437	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130704	PACASMAYO	3	1307	1438	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130705	SAN JOSE	3	1307	1439	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130801	TAYABAMBA	3	1308	1440	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130802	BULDIBUYO	3	1308	1441	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130803	CHILLIA	3	1308	1442	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130804	HUANCASPATA	3	1308	1443	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130805	HUAYLILLAS	3	1308	1444	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130806	HUAYO	3	1308	1445	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130807	ONGON	3	1308	1446	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130808	PARCOY	3	1308	1447	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130809	PATAZ	3	1308	1448	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130810	PIAS	3	1308	1449	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130811	SANTIAGO DE CHALLAS	3	1308	1450	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130812	TAURIJA	3	1308	1451	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130813	URPAY	3	1308	1452	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130901	HUAMACHUCO	3	1309	1453	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130902	CHUGAY	3	1309	1454	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130903	COCHORCO	3	1309	1455	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130904	CURGOS	3	1309	1456	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130905	MARCABAL	3	1309	1457	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130906	SANAGORAN	3	1309	1458	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130907	SARIN	3	1309	1459	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
130908	SARTIMBAMBA	3	1309	1460	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
131001	SANTIAGO DE CHUCO	3	1310	1461	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
131002	ANGASMARCA	3	1310	1462	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
131003	CACHICADAN	3	1310	1463	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
131004	MOLLEBAMBA	3	1310	1464	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
131005	MOLLEPATA	3	1310	1465	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
131006	QUIRUVILCA	3	1310	1466	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
131007	SANTA CRUZ DE CHUCA	3	1310	1467	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
131008	SITABAMBA	3	1310	1468	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
131101	CASCAS	3	1311	1469	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
131102	LUCMA	3	1311	1470	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
131103	MARMOT	3	1311	1471	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
131104	SAYAPULLO	3	1311	1472	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
131201	VIRU	3	1312	1473	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
131202	CHAO	3	1312	1474	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
131203	GUADALUPITO	3	1312	1475	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
140101	CHICLAYO	3	1401	1476	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
140102	CHONGOYAPE	3	1401	1477	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
140103	ETEN	3	1401	1478	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
140104	ETEN PUERTO	3	1401	1479	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
140105	JOSE LEONARDO ORTIZ	3	1401	1480	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
140106	LA VICTORIA	3	1401	1481	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
140107	LAGUNAS	3	1401	1482	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
140108	MONSEFU	3	1401	1483	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
140109	NUEVA ARICA	3	1401	1484	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
140110	OYOTUN	3	1401	1485	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
140111	PICSI	3	1401	1486	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
140112	PIMENTEL	3	1401	1487	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
140113	REQUE	3	1401	1488	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
140114	SANTA ROSA	3	1401	1489	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
140115	SAÑA	3	1401	1490	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
140116	CAYALTI	3	1401	1491	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
140117	PATAPO	3	1401	1492	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
140118	POMALCA	3	1401	1493	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
140119	PUCALA	3	1401	1494	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
140120	TUMAN	3	1401	1495	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
140201	FERREÑAFE	3	1402	1496	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
140202	CAÑARIS	3	1402	1497	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
140203	INCAHUASI	3	1402	1498	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
140204	MANUEL ANTONIO MESONES MURO	3	1402	1499	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
140205	PITIPO	3	1402	1500	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
140206	PUEBLO NUEVO	3	1402	1501	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
140301	LAMBAYEQUE	3	1403	1502	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
140302	CHOCHOPE	3	1403	1503	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
140303	ILLIMO	3	1403	1504	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
140304	JAYANCA	3	1403	1505	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
140305	MOCHUMI	3	1403	1506	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
140306	MORROPE	3	1403	1507	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
140307	MOTUPE	3	1403	1508	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
140308	OLMOS	3	1403	1509	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
140309	PACORA	3	1403	1510	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
140310	SALAS	3	1403	1511	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
140311	SAN JOSE	3	1403	1512	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
140312	TUCUME	3	1403	1513	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150101	LIMA	3	1501	1514	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150102	ANCON	3	1501	1515	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150103	ATE	3	1501	1516	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150104	BARRANCO	3	1501	1517	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150105	BREÑA	3	1501	1518	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150106	CARABAYLLO	3	1501	1519	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150107	CHACLACAYO	3	1501	1520	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150108	CHORRILLOS	3	1501	1521	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150109	CIENEGUILLA	3	1501	1522	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150110	COMAS	3	1501	1523	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150111	EL AGUSTINO	3	1501	1524	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150112	INDEPENDENCIA	3	1501	1525	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150113	JESUS MARIA	3	1501	1526	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150114	LA MOLINA	3	1501	1527	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150115	LA VICTORIA	3	1501	1528	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150116	LINCE	3	1501	1529	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150117	LOS OLIVOS	3	1501	1530	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150118	LURIGANCHO	3	1501	1531	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150119	LURIN	3	1501	1532	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150120	MAGDALENA DEL MAR	3	1501	1533	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150121	PUEBLO LIBRE	3	1501	1534	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150122	MIRAFLORES	3	1501	1535	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150123	PACHACAMAC	3	1501	1536	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150124	PUCUSANA	3	1501	1537	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150125	PUENTE PIEDRA	3	1501	1538	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150126	PUNTA HERMOSA	3	1501	1539	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150127	PUNTA NEGRA	3	1501	1540	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150128	RIMAC	3	1501	1541	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150129	SAN BARTOLO	3	1501	1542	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150130	SAN BORJA	3	1501	1543	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150131	SAN ISIDRO	3	1501	1544	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150132	SAN JUAN DE LURIGANCHO	3	1501	1545	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150133	SAN JUAN DE MIRAFLORES	3	1501	1546	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150134	SAN LUIS	3	1501	1547	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150135	SAN MARTIN DE PORRES	3	1501	1548	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150136	SAN MIGUEL	3	1501	1549	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150137	SANTA ANITA	3	1501	1550	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150138	SANTA MARIA DEL MAR	3	1501	1551	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150139	SANTA ROSA	3	1501	1552	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150140	SANTIAGO DE SURCO	3	1501	1553	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150141	SURQUILLO	3	1501	1554	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150142	VILLA EL SALVADOR	3	1501	1555	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150143	VILLA MARIA DEL TRIUNFO	3	1501	1556	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150144	SANTA MARIA DE HUACHIPA	3	1501	1557	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150201	BARRANCA	3	1502	1558	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150202	PARAMONGA	3	1502	1559	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150203	PATIVILCA	3	1502	1560	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150204	SUPE	3	1502	1561	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150205	SUPE PUERTO	3	1502	1562	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150301	CAJATAMBO	3	1503	1563	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150302	COPA	3	1503	1564	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150303	GORGOR	3	1503	1565	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150304	HUANCAPON	3	1503	1566	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150305	MANAS	3	1503	1567	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150401	CANTA	3	1504	1568	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150402	ARAHUAY	3	1504	1569	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150403	HUAMANTANGA	3	1504	1570	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150404	HUAROS	3	1504	1571	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150405	LACHAQUI	3	1504	1572	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150406	SAN BUENAVENTURA	3	1504	1573	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150407	SANTA ROSA DE QUIVES	3	1504	1574	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150501	SAN VICENTE DE CAÑETE	3	1505	1575	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150502	ASIA	3	1505	1576	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150503	CALANGO	3	1505	1577	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150504	CERRO AZUL	3	1505	1578	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150505	CHILCA	3	1505	1579	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150506	COAYLLO	3	1505	1580	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150507	IMPERIAL	3	1505	1581	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150508	LUNAHUANA	3	1505	1582	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150509	MALA	3	1505	1583	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150510	NUEVO IMPERIAL	3	1505	1584	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150511	PACARAN	3	1505	1585	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150512	QUILMANA	3	1505	1586	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150513	SAN ANTONIO	3	1505	1587	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150514	SAN LUIS	3	1505	1588	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150515	SANTA CRUZ DE FLORES	3	1505	1589	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150516	ZUÑIGA	3	1505	1590	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150601	HUARAL	3	1506	1591	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150602	ATAVILLOS ALTO	3	1506	1592	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150603	ATAVILLOS BAJO	3	1506	1593	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150604	AUCALLAMA	3	1506	1594	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150605	CHANCAY	3	1506	1595	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150606	IHUARI	3	1506	1596	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150607	LAMPIAN	3	1506	1597	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150608	PACARAOS	3	1506	1598	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150609	SAN MIGUEL DE ACOS	3	1506	1599	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150610	SANTA CRUZ DE ANDAMARCA	3	1506	1600	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150611	SUMBILCA	3	1506	1601	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150612	VEINTISIETE DE NOVIEMBRE	3	1506	1602	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150701	MATUCANA	3	1507	1603	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150702	ANTIOQUIA	3	1507	1604	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150703	CALLAHUANCA	3	1507	1605	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150704	CARAMPOMA	3	1507	1606	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150705	CHICLA	3	1507	1607	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150706	CUENCA	3	1507	1608	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150707	HUACHUPAMPA	3	1507	1609	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150708	HUANZA	3	1507	1610	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150709	HUAROCHIRI	3	1507	1611	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150710	LAHUAYTAMBO	3	1507	1612	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150711	LANGA	3	1507	1613	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150712	LARAOS	3	1507	1614	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150713	MARIATANA	3	1507	1615	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150714	RICARDO PALMA	3	1507	1616	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150715	SAN ANDRES DE TUPICOCHA	3	1507	1617	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150716	SAN ANTONIO	3	1507	1618	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150717	SAN BARTOLOME	3	1507	1619	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150718	SAN DAMIAN	3	1507	1620	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150719	SAN JUAN DE IRIS	3	1507	1621	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150720	SAN JUAN DE TANTARANCHE	3	1507	1622	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150721	SAN LORENZO DE QUINTI	3	1507	1623	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150722	SAN MATEO	3	1507	1624	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150723	SAN MATEO DE OTAO	3	1507	1625	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150724	SAN PEDRO DE CASTA	3	1507	1626	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150725	SAN PEDRO DE HUANCAYRE	3	1507	1627	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150726	SANGALLAYA	3	1507	1628	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150727	SANTA CRUZ DE COCACHACRA	3	1507	1629	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150728	SANTA EULALIA	3	1507	1630	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150729	SANTIAGO DE ANCHUCAYA	3	1507	1631	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150730	SANTIAGO DE TUNA	3	1507	1632	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150731	SANTO DOMINGO DE LOS OLLEROS	3	1507	1633	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150732	SURCO	3	1507	1634	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150801	HUACHO	3	1508	1635	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150802	AMBAR	3	1508	1636	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150803	CALETA DE CARQUIN	3	1508	1637	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150804	CHECRAS	3	1508	1638	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150805	HUALMAY	3	1508	1639	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150806	HUAURA	3	1508	1640	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150807	LEONCIO PRADO	3	1508	1641	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150808	PACCHO	3	1508	1642	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150809	SANTA LEONOR	3	1508	1643	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150810	SANTA MARIA	3	1508	1644	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150811	SAYAN	3	1508	1645	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150812	VEGUETA	3	1508	1646	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150901	OYON	3	1509	1647	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150902	ANDAJES	3	1509	1648	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150903	CAUJUL	3	1509	1649	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150904	COCHAMARCA	3	1509	1650	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150905	NAVAN	3	1509	1651	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
150906	PACHANGARA	3	1509	1652	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
151001	YAUYOS	3	1510	1653	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
151002	ALIS	3	1510	1654	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
151003	AYAUCA	3	1510	1655	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
151004	AYAVIRI	3	1510	1656	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
151005	AZANGARO	3	1510	1657	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
151006	CACRA	3	1510	1658	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
151007	CARANIA	3	1510	1659	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
151008	CATAHUASI	3	1510	1660	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
151009	CHOCOS	3	1510	1661	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
151010	COCHAS	3	1510	1662	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
151011	COLONIA	3	1510	1663	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
151012	HONGOS	3	1510	1664	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
151013	HUAMPARA	3	1510	1665	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
151014	HUANCAYA	3	1510	1666	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
151015	HUANGASCAR	3	1510	1667	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
151016	HUANTAN	3	1510	1668	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
151017	HUAÑEC	3	1510	1669	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
151018	LARAOS	3	1510	1670	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
151019	LINCHA	3	1510	1671	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
151020	MADEAN	3	1510	1672	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
151021	MIRAFLORES	3	1510	1673	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
151022	OMAS	3	1510	1674	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
151023	PUTINZA	3	1510	1675	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
151024	QUINCHES	3	1510	1676	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
151025	QUINOCAY	3	1510	1677	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
151026	SAN JOAQUIN	3	1510	1678	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
151027	SAN PEDRO DE PILAS	3	1510	1679	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
151028	TANTA	3	1510	1680	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
151029	TAURIPAMPA	3	1510	1681	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
151030	TOMAS	3	1510	1682	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
151031	TUPE	3	1510	1683	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
151032	VIÑAC	3	1510	1684	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
151033	VITIS	3	1510	1685	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160101	IQUITOS	3	1601	1686	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160102	ALTO NANAY	3	1601	1687	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160103	FERNANDO LORES	3	1601	1688	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160104	INDIANA	3	1601	1689	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160105	LAS AMAZONAS	3	1601	1690	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160106	MAZAN	3	1601	1691	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160107	NAPO	3	1601	1692	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160108	PUNCHANA	3	1601	1693	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160109	PUTUMAYO	3	1601	1694	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160110	TORRES CAUSANA	3	1601	1695	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160112	BELEN	3	1601	1696	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160113	SAN JUAN BAUTISTA	3	1601	1697	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160114	TENIENTE MANUEL CLAVERO	3	1601	1698	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160201	YURIMAGUAS	3	1602	1699	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160202	BALSAPUERTO	3	1602	1700	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160205	JEBEROS	3	1602	1701	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160206	LAGUNAS	3	1602	1702	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160210	SANTA CRUZ	3	1602	1703	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160211	TENIENTE CESAR LOPEZ ROJAS	3	1602	1704	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160301	NAUTA	3	1603	1705	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160302	PARINARI	3	1603	1706	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160303	TIGRE	3	1603	1707	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160304	TROMPETEROS	3	1603	1708	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160305	URARINAS	3	1603	1709	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160401	RAMON CASTILLA	3	1604	1710	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160402	PEBAS	3	1604	1711	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160403	YAVARI	3	1604	1712	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160404	SAN PABLO	3	1604	1713	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160501	REQUENA	3	1605	1714	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160502	ALTO TAPICHE	3	1605	1715	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160503	CAPELO	3	1605	1716	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160504	EMILIO SAN MARTIN	3	1605	1717	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160505	MAQUIA	3	1605	1718	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160506	PUINAHUA	3	1605	1719	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160507	SAQUENA	3	1605	1720	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160508	SOPLIN	3	1605	1721	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160509	TAPICHE	3	1605	1722	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160510	JENARO HERRERA	3	1605	1723	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160511	YAQUERANA	3	1605	1724	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160601	CONTAMANA	3	1606	1725	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160602	INAHUAYA	3	1606	1726	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160603	PADRE MARQUEZ	3	1606	1727	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160604	PAMPA HERMOSA	3	1606	1728	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160605	SARAYACU	3	1606	1729	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160606	VARGAS GUERRA	3	1606	1730	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160701	BARRANCA	3	1607	1731	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160702	CAHUAPANAS	3	1607	1732	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160703	MANSERICHE	3	1607	1733	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160704	MORONA	3	1607	1734	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160705	PASTAZA	3	1607	1735	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160706	ANDOAS	3	1607	1736	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160801	PUTUMAYO	3	1608	1737	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160802	ROSA PANDURO	3	1608	1738	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160803	TENIENTE MANUEL CLAVERO	3	1608	1739	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
160804	YAGUAS	3	1608	1740	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
170101	TAMBOPATA	3	1701	1741	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
170102	INAMBARI	3	1701	1742	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
170103	LAS PIEDRAS	3	1701	1743	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
170104	LABERINTO	3	1701	1744	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
170201	MANU	3	1702	1745	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
170202	FITZCARRALD	3	1702	1746	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
170203	MADRE DE DIOS	3	1702	1747	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
170204	HUEPETUHE	3	1702	1748	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
170301	IÑAPARI	3	1703	1749	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
170302	IBERIA	3	1703	1750	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
170303	TAHUAMANU	3	1703	1751	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
180101	MOQUEGUA	3	1801	1752	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
180102	CARUMAS	3	1801	1753	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
180103	CUCHUMBAYA	3	1801	1754	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
180104	SAMEGUA	3	1801	1755	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
180105	SAN CRISTOBAL	3	1801	1756	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
180106	TORATA	3	1801	1757	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
180201	OMATE	3	1802	1758	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
180202	CHOJATA	3	1802	1759	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
180203	COALAQUE	3	1802	1760	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
180204	ICHUÑA	3	1802	1761	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
180205	LA CAPILLA	3	1802	1762	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
180206	LLOQUE	3	1802	1763	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
180207	MATALAQUE	3	1802	1764	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
180208	PUQUINA	3	1802	1765	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
180209	QUINISTAQUILLAS	3	1802	1766	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
180210	UBINAS	3	1802	1767	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
180211	YUNGA	3	1802	1768	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
180301	ILO	3	1803	1769	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
180302	EL ALGARROBAL	3	1803	1770	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
180303	PACOCHA	3	1803	1771	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
190101	CHAUPIMARCA	3	1901	1772	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
190102	HUACHON	3	1901	1773	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
190103	HUARIACA	3	1901	1774	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
190104	HUAYLLAY	3	1901	1775	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
190105	NINACACA	3	1901	1776	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
190106	PALLANCHACRA	3	1901	1777	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
190107	PAUCARTAMBO	3	1901	1778	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
190108	SAN FRANCISCO DE ASIS DE YARUSYACAN	3	1901	1779	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
190109	SIMON BOLIVAR	3	1901	1780	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
190110	TICLACAYAN	3	1901	1781	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
190111	TINYAHUARCO	3	1901	1782	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
190112	VICCO	3	1901	1783	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
190113	YANACANCHA	3	1901	1784	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
190201	YANAHUANCA	3	1902	1785	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
190202	CHACAYAN	3	1902	1786	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
190203	GOYLLARISQUIZGA	3	1902	1787	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
190204	PAUCAR	3	1902	1788	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
190205	SAN PEDRO DE PILLAO	3	1902	1789	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
190206	SANTA ANA DE TUSI	3	1902	1790	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
190207	TAPUC	3	1902	1791	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
190208	VILCABAMBA	3	1902	1792	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
190301	OXAPAMPA	3	1903	1793	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
190302	CHONTABAMBA	3	1903	1794	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
190303	HUANCABAMBA	3	1903	1795	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
190304	PALCAZU	3	1903	1796	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
190305	POZUZO	3	1903	1797	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
190306	PUERTO BERMUDEZ	3	1903	1798	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
190307	VILLA RICA	3	1903	1799	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
190308	CONSTITUCION	3	1903	1800	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200101	PIURA	3	2001	1801	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200104	CASTILLA	3	2001	1802	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200105	CATACAOS	3	2001	1803	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200107	CURA MORI	3	2001	1804	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200108	EL TALLAN	3	2001	1805	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200109	LA ARENA	3	2001	1806	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200110	LA UNION	3	2001	1807	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200111	LAS LOMAS	3	2001	1808	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200114	TAMBO GRANDE	3	2001	1809	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200115	VEINTISEIS DE OCTUBRE	3	2001	1810	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200201	AYABACA	3	2002	1811	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200202	FRIAS	3	2002	1812	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200203	JILILI	3	2002	1813	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200204	LAGUNAS	3	2002	1814	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200205	MONTERO	3	2002	1815	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200206	PACAIPAMPA	3	2002	1816	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200207	PAIMAS	3	2002	1817	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200208	SAPILLICA	3	2002	1818	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200209	SICCHEZ	3	2002	1819	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200210	SUYO	3	2002	1820	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200301	HUANCABAMBA	3	2003	1821	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200302	CANCHAQUE	3	2003	1822	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200303	EL CARMEN DE LA FRONTERA	3	2003	1823	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200304	HUARMACA	3	2003	1824	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200305	LALAQUIZ	3	2003	1825	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200306	SAN MIGUEL DE EL FAIQUE	3	2003	1826	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200307	SONDOR	3	2003	1827	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200308	SONDORILLO	3	2003	1828	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200401	CHULUCANAS	3	2004	1829	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200402	BUENOS AIRES	3	2004	1830	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200403	CHALACO	3	2004	1831	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200404	LA MATANZA	3	2004	1832	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200405	MORROPON	3	2004	1833	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200406	SALITRAL	3	2004	1834	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200407	SAN JUAN DE BIGOTE	3	2004	1835	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200408	SANTA CATALINA DE MOSSA	3	2004	1836	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200409	SANTO DOMINGO	3	2004	1837	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200410	YAMANGO	3	2004	1838	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200501	PAITA	3	2005	1839	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200502	AMOTAPE	3	2005	1840	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200503	ARENAL	3	2005	1841	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200504	COLAN	3	2005	1842	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200505	LA HUACA	3	2005	1843	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200506	TAMARINDO	3	2005	1844	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200507	VICHAYAL	3	2005	1845	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200601	SULLANA	3	2006	1846	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200602	BELLAVISTA	3	2006	1847	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200603	IGNACIO ESCUDERO	3	2006	1848	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200604	LANCONES	3	2006	1849	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200605	MARCAVELICA	3	2006	1850	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200606	MIGUEL CHECA	3	2006	1851	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200607	QUERECOTILLO	3	2006	1852	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200608	SALITRAL	3	2006	1853	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200701	PARIÑAS	3	2007	1854	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200702	EL ALTO	3	2007	1855	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200703	LA BREA	3	2007	1856	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200704	LOBITOS	3	2007	1857	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200705	LOS ORGANOS	3	2007	1858	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200706	MANCORA	3	2007	1859	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200801	SECHURA	3	2008	1860	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200802	BELLAVISTA DE LA UNION	3	2008	1861	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200803	BERNAL	3	2008	1862	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200804	CRISTO NOS VALGA	3	2008	1863	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200805	VICE	3	2008	1864	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
200806	RINCONADA LLICUAR	3	2008	1865	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210101	PUNO	3	2101	1866	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210102	ACORA	3	2101	1867	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210103	AMANTANI	3	2101	1868	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210104	ATUNCOLLA	3	2101	1869	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210105	CAPACHICA	3	2101	1870	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210106	CHUCUITO	3	2101	1871	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210107	COATA	3	2101	1872	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210108	HUATA	3	2101	1873	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210109	MAÑAZO	3	2101	1874	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210110	PAUCARCOLLA	3	2101	1875	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210111	PICHACANI	3	2101	1876	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210112	PLATERIA	3	2101	1877	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210113	SAN ANTONIO	3	2101	1878	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210114	TIQUILLACA	3	2101	1879	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210115	VILQUE	3	2101	1880	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210201	AZANGARO	3	2102	1881	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210202	ACHAYA	3	2102	1882	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210203	ARAPA	3	2102	1883	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210204	ASILLO	3	2102	1884	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210205	CAMINACA	3	2102	1885	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210206	CHUPA	3	2102	1886	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210207	JOSE DOMINGO CHOQUEHUANCA	3	2102	1887	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210208	MUÑANI	3	2102	1888	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210209	POTONI	3	2102	1889	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210210	SAMAN	3	2102	1890	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210211	SAN ANTON	3	2102	1891	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210212	SAN JOSE	3	2102	1892	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210213	SAN JUAN DE SALINAS	3	2102	1893	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210214	SANTIAGO DE PUPUJA	3	2102	1894	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210215	TIRAPATA	3	2102	1895	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210301	MACUSANI	3	2103	1896	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210302	AJOYANI	3	2103	1897	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210303	AYAPATA	3	2103	1898	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210304	COASA	3	2103	1899	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210305	CORANI	3	2103	1900	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210306	CRUCERO	3	2103	1901	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210307	ITUATA	3	2103	1902	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210308	OLLACHEA	3	2103	1903	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210309	SAN GABAN	3	2103	1904	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210310	USICAYOS	3	2103	1905	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210401	JULI	3	2104	1906	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210402	DESAGUADERO	3	2104	1907	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210403	HUACULLANI	3	2104	1908	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210404	KELLUYO	3	2104	1909	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210405	PISACOMA	3	2104	1910	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210406	POMATA	3	2104	1911	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210407	ZEPITA	3	2104	1912	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210501	ILAVE	3	2105	1913	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210502	CAPAZO	3	2105	1914	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210503	PILCUYO	3	2105	1915	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210504	SANTA ROSA	3	2105	1916	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210505	CONDURIRI	3	2105	1917	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210601	HUANCANE	3	2106	1918	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210602	COJATA	3	2106	1919	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210603	HUATASANI	3	2106	1920	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210604	INCHUPALLA	3	2106	1921	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210605	PUSI	3	2106	1922	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210606	ROSASPATA	3	2106	1923	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210607	TARACO	3	2106	1924	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210608	VILQUE CHICO	3	2106	1925	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210701	LAMPA	3	2107	1926	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210702	CABANILLA	3	2107	1927	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210703	CALAPUJA	3	2107	1928	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210704	NICASIO	3	2107	1929	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210705	OCUVIRI	3	2107	1930	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210706	PALCA	3	2107	1931	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210707	PARATIA	3	2107	1932	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210708	PUCARA	3	2107	1933	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210709	SANTA LUCIA	3	2107	1934	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210710	VILAVILA	3	2107	1935	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210801	AYAVIRI	3	2108	1936	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210802	ANTAUTA	3	2108	1937	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210803	CUPI	3	2108	1938	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210804	LLALLI	3	2108	1939	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210805	MACARI	3	2108	1940	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210806	NUÑOA	3	2108	1941	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210807	ORURILLO	3	2108	1942	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210808	SANTA ROSA	3	2108	1943	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210809	UMACHIRI	3	2108	1944	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210901	MOHO	3	2109	1945	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210902	CONIMA	3	2109	1946	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210903	HUAYRAPATA	3	2109	1947	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
210904	TILALI	3	2109	1948	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
211001	PUTINA	3	2110	1949	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
211002	ANANEA	3	2110	1950	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
211003	PEDRO VILCA APAZA	3	2110	1951	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
211004	QUILCAPUNCU	3	2110	1952	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
211005	SINA	3	2110	1953	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
211101	JULIACA	3	2111	1954	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
211102	CABANA	3	2111	1955	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
211103	CABANILLAS	3	2111	1956	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
211104	CARACOTO	3	2111	1957	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
211105	SAN MIGUEL	3	2111	1958	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
211201	SANDIA	3	2112	1959	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
211202	CUYOCUYO	3	2112	1960	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
211203	LIMBANI	3	2112	1961	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
211204	PATAMBUCO	3	2112	1962	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
211205	PHARA	3	2112	1963	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
211206	QUIACA	3	2112	1964	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
211207	SAN JUAN DEL ORO	3	2112	1965	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
211208	YANAHUAYA	3	2112	1966	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
211209	ALTO INAMBARI	3	2112	1967	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
211210	SAN PEDRO DE PUTINA PUNCO	3	2112	1968	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
211301	YUNGUYO	3	2113	1969	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
211302	ANAPIA	3	2113	1970	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
211303	COPANI	3	2113	1971	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
211304	CUTURAPI	3	2113	1972	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
211305	OLLARAYA	3	2113	1973	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
211306	TINICACHI	3	2113	1974	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
211307	UNICACHI	3	2113	1975	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220101	MOYOBAMBA	3	2201	1976	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220102	CALZADA	3	2201	1977	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220103	HABANA	3	2201	1978	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220104	JEPELACIO	3	2201	1979	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220105	SORITOR	3	2201	1980	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220106	YANTALO	3	2201	1981	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220201	BELLAVISTA	3	2202	1982	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220202	ALTO BIAVO	3	2202	1983	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220203	BAJO BIAVO	3	2202	1984	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220204	HUALLAGA	3	2202	1985	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220205	SAN PABLO	3	2202	1986	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220206	SAN RAFAEL	3	2202	1987	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220301	SAN JOSE DE SISA	3	2203	1988	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220302	AGUA BLANCA	3	2203	1989	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220303	SAN MARTIN	3	2203	1990	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220304	SANTA ROSA	3	2203	1991	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220305	SHATOJA	3	2203	1992	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220401	SAPOSOA	3	2204	1993	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220402	ALTO SAPOSOA	3	2204	1994	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220403	EL ESLABON	3	2204	1995	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220404	PISCOYACU	3	2204	1996	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220405	SACANCHE	3	2204	1997	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220406	TINGO DE SAPOSOA	3	2204	1998	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220501	LAMAS	3	2205	1999	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220502	ALONSO DE ALVARADO	3	2205	2000	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220503	BARRANQUITA	3	2205	2001	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220504	CAYNARACHI	3	2205	2002	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220505	CUÑUMBUQUI	3	2205	2003	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220506	PINTO RECODO	3	2205	2004	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220507	RUMISAPA	3	2205	2005	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220508	SAN ROQUE DE CUMBAZA	3	2205	2006	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220509	SHANAO	3	2205	2007	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220510	TABALOSOS	3	2205	2008	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220511	ZAPATERO	3	2205	2009	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220601	JUANJUI	3	2206	2010	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220602	CAMPANILLA	3	2206	2011	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220603	HUICUNGO	3	2206	2012	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220604	PACHIZA	3	2206	2013	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220605	PAJARILLO	3	2206	2014	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220701	PICOTA	3	2207	2015	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220702	BUENOS AIRES	3	2207	2016	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220703	CASPISAPA	3	2207	2017	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220704	PILLUANA	3	2207	2018	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220705	PUCACACA	3	2207	2019	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220706	SAN CRISTOBAL	3	2207	2020	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220707	SAN HILARION	3	2207	2021	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220708	SHAMBOYACU	3	2207	2022	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220709	TINGO DE PONASA	3	2207	2023	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220710	TRES UNIDOS	3	2207	2024	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220801	RIOJA	3	2208	2025	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220802	AWAJUN	3	2208	2026	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220803	ELIAS SOPLIN VARGAS	3	2208	2027	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220804	NUEVA CAJAMARCA	3	2208	2028	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220805	PARDO MIGUEL	3	2208	2029	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220806	POSIC	3	2208	2030	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220807	SAN FERNANDO	3	2208	2031	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220808	YORONGOS	3	2208	2032	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220809	YURACYACU	3	2208	2033	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220901	TARAPOTO	3	2209	2034	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220902	ALBERTO LEVEAU	3	2209	2035	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220903	CACATACHI	3	2209	2036	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220904	CHAZUTA	3	2209	2037	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220905	CHIPURANA	3	2209	2038	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220906	EL PORVENIR	3	2209	2039	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220907	HUIMBAYOC	3	2209	2040	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220908	JUAN GUERRA	3	2209	2041	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220909	LA BANDA DE SHILCAYO	3	2209	2042	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220910	MORALES	3	2209	2043	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220911	PAPAPLAYA	3	2209	2044	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220912	SAN ANTONIO	3	2209	2045	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220913	SAUCE	3	2209	2046	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
220914	SHAPAJA	3	2209	2047	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
221001	TOCACHE	3	2210	2048	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
221002	NUEVO PROGRESO	3	2210	2049	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
221003	POLVORA	3	2210	2050	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
221004	SHUNTE	3	2210	2051	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
221005	UCHIZA	3	2210	2052	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
221006	SANTA LUCIA	3	2210	2053	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
230101	TACNA	3	2301	2054	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
230102	ALTO DE LA ALIANZA	3	2301	2055	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
230103	CALANA	3	2301	2056	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
230104	CIUDAD NUEVA	3	2301	2057	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
230105	INCLAN	3	2301	2058	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
230106	PACHIA	3	2301	2059	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
230107	PALCA	3	2301	2060	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
230108	POCOLLAY	3	2301	2061	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
230109	SAMA	3	2301	2062	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
230110	CORONEL GREGORIO ALBARRACIN LANCHIPA	3	2301	2063	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
230111	LA YARADA LOS PALOS	3	2301	2064	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
230201	CANDARAVE	3	2302	2065	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
230202	CAIRANI	3	2302	2066	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
230203	CAMILACA	3	2302	2067	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
230204	CURIBAYA	3	2302	2068	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
230205	HUANUARA	3	2302	2069	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
230206	QUILAHUANI	3	2302	2070	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
230301	LOCUMBA	3	2303	2071	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
230302	ILABAYA	3	2303	2072	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
230303	ITE	3	2303	2073	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
230401	TARATA	3	2304	2074	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
230402	HEROES ALBARRACIN CHUCATAMANI	3	2304	2075	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
230403	ESTIQUE	3	2304	2076	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
230404	ESTIQUE-PAMPA	3	2304	2077	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
230405	SITAJARA	3	2304	2078	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
230406	SUSAPAYA	3	2304	2079	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
230407	TARUCACHI	3	2304	2080	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
230408	TICACO	3	2304	2081	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
240101	TUMBES	3	2401	2082	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
240102	CORRALES	3	2401	2083	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
240103	LA CRUZ	3	2401	2084	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
240104	PAMPAS DE HOSPITAL	3	2401	2085	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
240105	SAN JACINTO	3	2401	2086	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
240106	SAN JUAN DE LA VIRGEN	3	2401	2087	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
240201	ZORRITOS	3	2402	2088	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
240202	CASITAS	3	2402	2089	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
240203	CANOAS DE PUNTA SAL	3	2402	2090	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
240301	ZARUMILLA	3	2403	2091	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
240302	AGUAS VERDES	3	2403	2092	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
240303	MATAPALO	3	2403	2093	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
240304	PAPAYAL	3	2403	2094	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
250101	CALLERIA	3	2501	2095	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
250102	CAMPOVERDE	3	2501	2096	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
250103	IPARIA	3	2501	2097	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
250104	MASISEA	3	2501	2098	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
250105	YARINACOCHA	3	2501	2099	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
250106	NUEVA REQUENA	3	2501	2100	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
250107	MANANTAY	3	2501	2101	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
250201	RAYMONDI	3	2502	2102	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
250202	SEPAHUA	3	2502	2103	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
250203	TAHUANIA	3	2502	2104	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
250204	YURUA	3	2502	2105	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
250301	PADRE ABAD	3	2503	2106	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
250302	IRAZOLA	3	2503	2107	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
250303	CURIMANA	3	2503	2108	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
250304	NESHUYA	3	2503	2109	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
250305	ALEXANDER VON HUMBOLDT	3	2503	2110	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
250306	HUIPOCA	3	2503	2111	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
250307	BOQUERON	3	2503	2112	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
250401	PURUS	3	2504	2113	t	2026-03-27 23:42:11.065804-05	SISTEMA	\N	\N
\.


--
-- TOC entry 4469 (class 0 OID 46413)
-- Dependencies: 257
-- Data for Name: asientos_contables; Type: TABLE DATA; Schema: contabilidad; Owner: -
--

COPY contabilidad.asientos_contables (id_asiento, fecha_contable, periodo, glosa, origen_modulo, id_origen_referencia, total_debe, total_haber, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion, id_estado) FROM stdin;
\.


--
-- TOC entry 4471 (class 0 OID 46424)
-- Dependencies: 259
-- Data for Name: centros_costo; Type: TABLE DATA; Schema: contabilidad; Owner: -
--

COPY contabilidad.centros_costo (id_centro_costo, codigo, nombre, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion) FROM stdin;
\.


--
-- TOC entry 4473 (class 0 OID 46431)
-- Dependencies: 261
-- Data for Name: detalle_asiento; Type: TABLE DATA; Schema: contabilidad; Owner: -
--

COPY contabilidad.detalle_asiento (id_detalle_asiento, id_asiento, id_cuenta, id_centro_costo, debe, haber, referencia_doc, fecha_modificacion, usuario_modificacion) FROM stdin;
\.


--
-- TOC entry 4475 (class 0 OID 46437)
-- Dependencies: 263
-- Data for Name: plan_cuentas; Type: TABLE DATA; Schema: contabilidad; Owner: -
--

COPY contabilidad.plan_cuentas (id_cuenta, codigo_cuenta, nombre_cuenta, nivel, id_cuenta_padre, permite_asientos, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion, id_tipo_cuenta) FROM stdin;
\.


--
-- TOC entry 4477 (class 0 OID 46446)
-- Dependencies: 265
-- Data for Name: areas; Type: TABLE DATA; Schema: identidad; Owner: -
--

COPY identidad.areas (id_area, nombre_area, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion) FROM stdin;
\.


--
-- TOC entry 4479 (class 0 OID 46453)
-- Dependencies: 267
-- Data for Name: auditoria_accesos; Type: TABLE DATA; Schema: identidad; Owner: -
--

COPY identidad.auditoria_accesos (id_auditoria, id_usuario, ip_origen, accion, detalles, fecha_evento) FROM stdin;
\.


--
-- TOC entry 4481 (class 0 OID 46460)
-- Dependencies: 269
-- Data for Name: cargos; Type: TABLE DATA; Schema: identidad; Owner: -
--

COPY identidad.cargos (id_cargo, nombre_cargo, id_area, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion) FROM stdin;
\.


--
-- TOC entry 4483 (class 0 OID 46467)
-- Dependencies: 271
-- Data for Name: menus; Type: TABLE DATA; Schema: identidad; Owner: -
--

COPY identidad.menus (id_menu, codigo, nombre, descripcion, ruta, icono, orden, id_menu_padre, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion) FROM stdin;
1	DASHBOARD	Dashboard	Panel principal del sistema	/dashboard	dashboard	1	\N	t	2026-01-28 10:38:51.065407	SYSTEM	\N	\N
2	VENTAS	Ventas	Módulo de gestión de ventas	/ventas	shopping-cart	2	\N	t	2026-01-28 10:38:51.065407	SYSTEM	\N	\N
3	COMPRAS	Compras	Módulo de gestión de compras	/compras	shopping-bag	3	\N	t	2026-01-28 10:38:51.065407	SYSTEM	\N	\N
4	INVENTARIO	Inventario	Módulo de gestión de inventario	/inventario	warehouse	4	\N	t	2026-01-28 10:38:51.065407	SYSTEM	\N	\N
5	CLIENTES	Clientes	Módulo de gestión de clientes	/clientes	users	5	\N	t	2026-01-28 10:38:51.065407	SYSTEM	\N	\N
6	CATALOGO	Catálogo	Módulo de gestión de productos	/catalogo	book	6	\N	t	2026-01-28 10:38:51.065407	SYSTEM	\N	\N
7	CONTABILIDAD	Contabilidad	Módulo de contabilidad	/contabilidad	calculator	7	\N	t	2026-01-28 10:38:51.065407	SYSTEM	\N	\N
8	CONFIGURACION	Configuración	Configuración del sistema	/configuracion	settings	8	\N	t	2026-01-28 10:38:51.065407	SYSTEM	\N	\N
9	IDENTIDAD	Identidad	Gestión de usuarios y permisos	/identidad	shield	9	\N	t	2026-01-28 10:38:51.065407	SYSTEM	\N	\N
10	VENTAS_LISTA	Lista de Ventas	Ver todas las ventas	/ventas/lista	list	1	2	t	2026-01-28 10:38:51.065407	SYSTEM	\N	\N
11	VENTAS_NUEVA	Nueva Venta	Registrar nueva venta	/ventas/nueva	plus	2	2	t	2026-01-28 10:38:51.065407	SYSTEM	\N	\N
12	VENTAS_COTIZACIONES	Cotizaciones	Gestionar cotizaciones	/ventas/cotizaciones	file-text	3	2	t	2026-01-28 10:38:51.065407	SYSTEM	\N	\N
13	VENTAS_CAJAS	Cajas	Gestión de cajas	/ventas/cajas	credit-card	4	2	t	2026-01-28 10:38:51.065407	SYSTEM	\N	\N
14	COMPRAS_LISTA	Lista de Compras	Ver todas las compras	/compras/lista	list	1	3	t	2026-01-28 10:38:51.065407	SYSTEM	\N	\N
15	COMPRAS_NUEVA	Nueva Compra	Registrar nueva compra	/compras/nueva	plus	2	3	t	2026-01-28 10:38:51.065407	SYSTEM	\N	\N
16	COMPRAS_ORDENES	Órdenes de Compra	Gestionar órdenes	/compras/ordenes	clipboard	3	3	t	2026-01-28 10:38:51.065407	SYSTEM	\N	\N
17	COMPRAS_PROVEEDORES	Proveedores	Gestión de proveedores	/compras/proveedores	truck	4	3	t	2026-01-28 10:38:51.065407	SYSTEM	\N	\N
18	INVENTARIO_STOCK	Stock	Consultar stock disponible	/inventario/stock	package	1	4	t	2026-01-28 10:38:51.065407	SYSTEM	\N	\N
19	INVENTARIO_MOVIMIENTOS	Movimientos	Movimientos de inventario	/inventario/movimientos	repeat	2	4	t	2026-01-28 10:38:51.065407	SYSTEM	\N	\N
20	INVENTARIO_ALMACENES	Almacenes	Gestión de almacenes	/inventario/almacenes	home	3	4	t	2026-01-28 10:38:51.065407	SYSTEM	\N	\N
21	CATALOGO_PRODUCTOS	Productos	Gestión de productos	/catalogo/productos	box	1	6	t	2026-01-28 10:38:51.065407	SYSTEM	\N	\N
22	CATALOGO_CATEGORIAS	Categorías	Gestión de categorías	/catalogo/categorias	folder	2	6	t	2026-01-28 10:38:51.065407	SYSTEM	\N	\N
23	CATALOGO_MARCAS	Marcas	Gestión de marcas	/catalogo/marcas	tag	3	6	t	2026-01-28 10:38:51.065407	SYSTEM	\N	\N
24	CATALOGO_PRECIOS	Listas de Precios	Gestión de precios	/catalogo/precios	dollar-sign	4	6	t	2026-01-28 10:38:51.065407	SYSTEM	\N	\N
25	IDENTIDAD_USUARIOS	Usuarios	Gestión de usuarios	/identidad/usuarios	user	1	9	t	2026-01-28 10:38:51.065407	SYSTEM	\N	\N
26	IDENTIDAD_ROLES	Roles	Gestión de roles	/identidad/roles	users	2	9	t	2026-01-28 10:38:51.065407	SYSTEM	\N	\N
27	IDENTIDAD_PERMISOS	Permisos	Asignación de permisos	/identidad/permisos	lock	3	9	t	2026-01-28 10:38:51.065407	SYSTEM	\N	\N
28	CAT_UNIDADES_MEDIDA	Unidades de Medida	GestiÃ³n de unidades de medida	/catalogo/unidades-medida	Ruler	30	6	t	2026-03-16 09:20:16.047069	SYSTEM	\N	\N
29	CAT_LISTAS_PRECIOS	Listas de Precios	GestiÃ³n de listas de precios	/catalogo/listas-precios	DollarSign	40	6	t	2026-03-16 09:20:16.048196	SYSTEM	\N	\N
\.


--
-- TOC entry 4485 (class 0 OID 46477)
-- Dependencies: 273
-- Data for Name: permisos; Type: TABLE DATA; Schema: identidad; Owner: -
--

COPY identidad.permisos (id_permiso, codigo_permiso, descripcion, modulo, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion) FROM stdin;
\.


--
-- TOC entry 4487 (class 0 OID 46486)
-- Dependencies: 275
-- Data for Name: roles; Type: TABLE DATA; Schema: identidad; Owner: -
--

COPY identidad.roles (id_rol, nombre_rol, descripcion, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion) FROM stdin;
1	ADMINISTRADOR	Acceso total al sistema	t	2026-01-27 17:36:28.866902	SYSTEM	2026-01-27 17:36:28.866902	\N
2	VENDEDOR	Acceso a módulo de ventas y clientes	t	2026-01-27 17:36:28.866902	SYSTEM	2026-01-27 17:36:28.866902	\N
3	CAJERO	Acceso a apertura/cierre de caja y cobros	t	2026-01-27 17:36:28.866902	SYSTEM	2026-01-27 17:36:28.866902	\N
4	ALMACENERO	Acceso a inventarios y kardex	t	2026-01-27 17:36:28.866902	SYSTEM	2026-01-27 17:36:28.866902	\N
\.


--
-- TOC entry 4489 (class 0 OID 46495)
-- Dependencies: 277
-- Data for Name: roles_menus; Type: TABLE DATA; Schema: identidad; Owner: -
--

COPY identidad.roles_menus (id_rol_menu, id_rol, id_menu, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion) FROM stdin;
1	1	28	t	2026-03-16 09:20:16.048781	SYSTEM	\N	\N
2	1	29	t	2026-03-16 09:20:16.050401	SYSTEM	\N	\N
\.


--
-- TOC entry 4491 (class 0 OID 46502)
-- Dependencies: 279
-- Data for Name: roles_menus_permisos; Type: TABLE DATA; Schema: identidad; Owner: -
--

COPY identidad.roles_menus_permisos (id_rol_menu_permiso, id_rol_menu, id_tipo_permiso, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion) FROM stdin;
\.


--
-- TOC entry 4493 (class 0 OID 46509)
-- Dependencies: 281
-- Data for Name: roles_permisos; Type: TABLE DATA; Schema: identidad; Owner: -
--

COPY identidad.roles_permisos (id_rol, id_permiso, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion) FROM stdin;
\.


--
-- TOC entry 4494 (class 0 OID 46515)
-- Dependencies: 282
-- Data for Name: tipos_permiso; Type: TABLE DATA; Schema: identidad; Owner: -
--

COPY identidad.tipos_permiso (id_tipo_permiso, codigo, nombre, descripcion, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion) FROM stdin;
1	CREATE	Crear	Permite crear nuevos registros	t	2026-01-28 10:38:51.065407	SYSTEM	\N	\N
2	READ	Leer	Permite ver y consultar registros	t	2026-01-28 10:38:51.065407	SYSTEM	\N	\N
3	UPDATE	Actualizar	Permite modificar registros existentes	t	2026-01-28 10:38:51.065407	SYSTEM	\N	\N
4	DELETE	Eliminar	Permite eliminar registros	t	2026-01-28 10:38:51.065407	SYSTEM	\N	\N
5	EXPORT	Exportar	Permite exportar datos a archivos	t	2026-01-28 10:38:51.065407	SYSTEM	\N	\N
6	IMPORT	Importar	Permite importar datos desde archivos	t	2026-01-28 10:38:51.065407	SYSTEM	\N	\N
7	APPROVE	Aprobar	Permite aprobar transacciones o documentos	t	2026-01-28 10:38:51.065407	SYSTEM	\N	\N
8	PRINT	Imprimir	Permite imprimir documentos	t	2026-01-28 10:38:51.065407	SYSTEM	\N	\N
9	CANCEL	Anular	Permite anular documentos o transacciones	t	2026-01-28 10:38:51.065407	SYSTEM	\N	\N
\.


--
-- TOC entry 4496 (class 0 OID 46524)
-- Dependencies: 284
-- Data for Name: trabajadores; Type: TABLE DATA; Schema: identidad; Owner: -
--

COPY identidad.trabajadores (id_trabajador, numero_documento, nombres, apellidos, fecha_nacimiento, telefono, email_corporativo, id_cargo, id_usuario, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion, id_tipo_documento) FROM stdin;
\.


--
-- TOC entry 4498 (class 0 OID 46533)
-- Dependencies: 286
-- Data for Name: usuarios; Type: TABLE DATA; Schema: identidad; Owner: -
--

COPY identidad.usuarios (id_usuario, username, password_hash, email, nombres, apellidos, id_rol, ultimo_acceso, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion) FROM stdin;
1	admin	$2a$12$R9h/cIPz0gi.URNNXRFXjOios9lnpSHkTE.oFw0kX8k.js9l0.y	admin@sistema.com	Administrador	Principal	1	\N	t	2026-01-27 17:36:28.866902	SYSTEM	2026-01-27 17:36:28.866902	\N
\.


--
-- TOC entry 4500 (class 0 OID 46542)
-- Dependencies: 288
-- Data for Name: usuarios_roles; Type: TABLE DATA; Schema: identidad; Owner: -
--

COPY identidad.usuarios_roles (id_usuario_rol, id_usuario, id_rol, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion) FROM stdin;
\.


--
-- TOC entry 4502 (class 0 OID 46549)
-- Dependencies: 290
-- Data for Name: almacenes; Type: TABLE DATA; Schema: inventario; Owner: -
--

COPY inventario.almacenes (id_almacen, nombre_almacen, direccion, es_principal, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion, id_sucursal) FROM stdin;
1	ALMACEN CENTRAL	SEDE PRINCIPAL	t	t	2026-01-27 17:36:28.866902	SYSTEM	2026-01-27 17:36:28.866902	\N	1
\.


--
-- TOC entry 4570 (class 0 OID 66587)
-- Dependencies: 365
-- Data for Name: inv_kardex_lote; Type: TABLE DATA; Schema: inventario; Owner: -
--

COPY inventario.inv_kardex_lote (id, producto_id, almacen_id, fecha_entrada, hora_entrada, movimiento_origen_id, costo_unitario, cantidad_original, cantidad_disponible, estado, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion) FROM stdin;
\.


--
-- TOC entry 4572 (class 0 OID 66598)
-- Dependencies: 367
-- Data for Name: inv_kardex_movimiento; Type: TABLE DATA; Schema: inventario; Owner: -
--

COPY inventario.inv_kardex_movimiento (id, uuid, periodo, correlativo_kardex, fecha_movimiento, hora_movimiento, fecha_hora_compuesta, modulo_origen, tipo_documento, serie_documento, numero_documento, anulado, fecha_anulacion, motivo_anulacion, tipo_operacion, motivo_traslado_sunat, descripcion_movimiento, almacen_id, almacen_origen_id, almacen_destino_id, producto_id, unidad_medida_codigo, factor_conversion, entrada_cantidad, entrada_costo_unitario, entrada_costo_total, salida_cantidad, salida_costo_unitario, salida_costo_total, saldo_cantidad, saldo_costo_unitario, saldo_costo_total, referencia_id, referencia_tipo, lote_id, proveedor_cliente_id, observaciones, usuario_registro_id, usuario_anulacion_id, recalculado_at, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion) FROM stdin;
1	24480006-0373-4d84-b214-0aa4293997b8	2026-03	0	2026-03-27	03:29:22.646789	2026-03-27 03:29:22.646789	COMPRAS	01	F001	00000021	f	\N	\N	E	0101	Ingreso automático por Compra #22	1	\N	\N	10	NIU	1.000000	1.000000	2899.000000	2899.000000	0.000000	0.000000	0.000000	1.000000	2899.000000	2899.000000	22	COMPRAS	\N	\N	\N	1	\N	\N	t	2026-03-27 03:29:22.712875		\N	\N
2	696312a0-47f3-4e47-b23b-00e94c708490	2026-03	0	2026-03-27	03:58:38.763956	2026-03-27 03:58:38.763956	COMPRAS	01	F001	00000022	f	\N	\N	E	0101	Ingreso automático por Compra #23	1	\N	\N	10	NIU	1.000000	1.000000	2899.000000	2899.000000	0.000000	0.000000	0.000000	2.000000	2899.000000	5798.000000	23	COMPRAS	\N	\N	\N	1	\N	\N	t	2026-03-27 03:58:38.870039		\N	\N
3	c7376ab0-2b4d-4696-a727-8a312584c549	2026-03	0	2026-03-27	04:11:59.270463	2026-03-27 04:11:59.270463	COMPRAS	01	F001	00000024	f	\N	\N	E	0101	Ingreso automático por Compra #24	1	\N	\N	10	NIU	1.000000	1.000000	2899.000000	2899.000000	0.000000	0.000000	0.000000	3.000000	2899.000000	8697.000000	24	COMPRAS	\N	\N	\N	1	\N	\N	t	2026-03-27 04:11:59.389503		\N	\N
4	fac94505-3978-48ed-990e-7e6f708574dd	2026-03	0	2026-03-27	04:30:28.280845	2026-03-27 04:30:28.280845	COMPRAS	01	F001	00000029	f	\N	\N	E	0101	Ingreso automático por Compra #29	1	\N	\N	10	NIU	1.000000	1.000000	2899.000000	2899.000000	0.000000	0.000000	0.000000	4.000000	2899.000000	11596.000000	29	COMPRAS	\N	\N	\N	1	\N	\N	t	2026-03-27 04:30:28.383527		\N	\N
5	542fcf62-e089-4b85-9f49-8174a5f8b50f	2026-03	0	2026-03-28	05:59:59.083002	2026-03-28 05:59:59.083002	VENTAS	03	B001	1	f	\N	\N	S	0101	Salida automática por Venta #4	1	\N	\N	10	NIU	1.000000	0.000000	0.000000	0.000000	1.000000	2899.000000	2899.000000	3.000000	2899.000000	8697.000000	4	VENTAS	\N	\N	\N	1	\N	\N	t	2026-03-28 05:59:59.240281		\N	\N
6	7ae733f7-7646-4b81-9088-84e9e16d54cd	2026-03	0	2026-03-28	17:08:07.579611	2026-03-28 17:08:07.579611	VENTAS	03	B001	2	f	\N	\N	S	0101	Salida automática por Venta #5	1	\N	\N	10	NIU	1.000000	0.000000	0.000000	0.000000	1.000000	2899.000000	2899.000000	2.000000	2899.000000	5798.000000	5	VENTAS	\N	\N	\N	1	\N	\N	t	2026-03-28 17:08:07.735752		\N	\N
7	ddc898c9-43a1-4808-8286-b0c5b17c7b91	2026-03	0	2026-03-28	17:36:27.806692	2026-03-28 17:36:27.806692	COMPRAS	01	F001	000000	f	\N	\N	E	0101	Ingreso automático por Compra #30	1	\N	\N	10	NIU	1.000000	10.000000	2899.000000	28990.000000	0.000000	0.000000	0.000000	12.000000	2899.000000	34788.000000	30	COMPRAS	\N	\N	\N	1	\N	\N	t	2026-03-28 17:36:27.934332		\N	\N
8	27380861-666f-41f3-ae23-220842344cea	2026-03	0	2026-03-28	17:36:28.157163	2026-03-28 17:36:28.157163	COMPRAS	01	F001	000000	f	\N	\N	E	0101	Ingreso automático por Compra #30	1	\N	\N	13	NIU	1.000000	30.000000	299.900000	8997.000000	0.000000	0.000000	0.000000	30.000000	299.900000	8997.000000	30	COMPRAS	\N	\N	\N	1	\N	\N	t	2026-03-28 17:36:28.16237		\N	\N
9	8e28387a-3588-4f75-8f43-130bbe7c2b49	2026-03	0	2026-03-28	17:36:28.205864	2026-03-28 17:36:28.205864	COMPRAS	01	F001	000000	f	\N	\N	E	0101	Ingreso automático por Compra #30	1	\N	\N	7	NIU	1.000000	15.000000	1899.000000	28485.000000	0.000000	0.000000	0.000000	15.000000	1899.000000	28485.000000	30	COMPRAS	\N	\N	\N	1	\N	\N	t	2026-03-28 17:36:28.215043		\N	\N
10	ce2c33aa-46d4-41a4-8179-217da46b6c1a	2026-03	0	2026-03-28	17:36:28.244105	2026-03-28 17:36:28.244105	COMPRAS	01	F001	000000	f	\N	\N	E	0101	Ingreso automático por Compra #30	1	\N	\N	11	NIU	1.000000	20.000000	1850.500000	37010.000000	0.000000	0.000000	0.000000	20.000000	1850.500000	37010.000000	30	COMPRAS	\N	\N	\N	1	\N	\N	t	2026-03-28 17:36:28.248267		\N	\N
11	b4f962f6-ef7a-414f-88b5-07326af63e65	2026-03	0	2026-03-28	17:36:28.277486	2026-03-28 17:36:28.277486	COMPRAS	01	F001	000000	f	\N	\N	E	0101	Ingreso automático por Compra #30	1	\N	\N	12	NIU	1.000000	20.000000	199.900000	3998.000000	0.000000	0.000000	0.000000	20.000000	199.900000	3998.000000	30	COMPRAS	\N	\N	\N	1	\N	\N	t	2026-03-28 17:36:28.281143		\N	\N
\.


--
-- TOC entry 4573 (class 0 OID 66610)
-- Dependencies: 368
-- Data for Name: inv_kardex_periodo_control; Type: TABLE DATA; Schema: inventario; Owner: -
--

COPY inventario.inv_kardex_periodo_control (periodo, estado, fecha_cierre, usuario_cierre_id, created_at, updated_at, fecha_modificacion, usuario_modificacion) FROM stdin;
2026-03	A	\N	\N	2026-03-26 22:20:12.554795	\N	\N	\N
\.


--
-- TOC entry 4575 (class 0 OID 66618)
-- Dependencies: 370
-- Data for Name: inv_kardex_recalculo_log; Type: TABLE DATA; Schema: inventario; Owner: -
--

COPY inventario.inv_kardex_recalculo_log (id, almacen_id, producto_id, desde_fecha, motivo, registros_afect, usuario_id, duracion_ms, created_at, fecha_modificacion, usuario_modificacion) FROM stdin;
\.


--
-- TOC entry 4504 (class 0 OID 46559)
-- Dependencies: 292
-- Data for Name: movimientos_inventario; Type: TABLE DATA; Schema: inventario; Owner: -
--

COPY inventario.movimientos_inventario (id_movimiento, id_stock, cantidad, cantidad_anterior, cantidad_nueva, costo_unitario_movimiento, referencia_modulo, id_referencia, observaciones, fecha_creacion, usuario_creacion, id_tipo_movimiento, saldo_cantidad, saldo_valorizado, costo_promedio_actual, fecha_modificacion, usuario_modificacion) FROM stdin;
1	1	1.000	0.000	1.000	2899.0000	COMPRAS	22	Ingreso automático por Compra #22	2026-03-27 03:29:22.59485	SISTEMA	19	1.000	2899.00	2899.0000	\N	\N
2	1	1.000	1.000	2.000	2899.0000	COMPRAS	23	Ingreso automático por Compra #23	2026-03-27 03:58:38.69524	SISTEMA	19	2.000	5798.00	2899.0000	\N	\N
3	1	1.000	2.000	3.000	2899.0000	COMPRAS	24	Ingreso automático por Compra #24	2026-03-27 04:11:59.19937	SISTEMA	19	3.000	8697.00	2899.0000	\N	\N
4	1	1.000	3.000	4.000	2899.0000	COMPRAS	29	Ingreso automático por Compra #29	2026-03-27 04:30:28.211253	SISTEMA	19	4.000	11596.00	2899.0000	\N	\N
5	1	1.000	4.000	3.000	2899.0000	VENTAS	4	Salida automática por Venta #4	2026-03-28 05:59:58.992884	SISTEMA	20	3.000	8697.00	2899.0000	\N	\N
6	1	1.000	3.000	2.000	2899.0000	VENTAS	5	Salida automática por Venta #5	2026-03-28 17:08:07.511301	SISTEMA	20	2.000	5798.00	2899.0000	\N	\N
7	1	10.000	2.000	12.000	2899.0000	COMPRAS	30	Ingreso automático por Compra #30	2026-03-28 17:36:27.742911	SISTEMA	19	12.000	34788.00	2899.0000	\N	\N
8	2	30.000	0.000	30.000	299.9000	COMPRAS	30	Ingreso automático por Compra #30	2026-03-28 17:36:28.152642	SISTEMA	19	30.000	8997.00	299.9000	\N	\N
9	3	15.000	0.000	15.000	1899.0000	COMPRAS	30	Ingreso automático por Compra #30	2026-03-28 17:36:28.201134	SISTEMA	19	15.000	28485.00	1899.0000	\N	\N
10	4	20.000	0.000	20.000	1850.5000	COMPRAS	30	Ingreso automático por Compra #30	2026-03-28 17:36:28.240013	SISTEMA	19	20.000	37010.00	1850.5000	\N	\N
11	5	20.000	0.000	20.000	199.9000	COMPRAS	30	Ingreso automático por Compra #30	2026-03-28 17:36:28.274197	SISTEMA	19	20.000	3998.00	199.9000	\N	\N
\.


--
-- TOC entry 4506 (class 0 OID 46566)
-- Dependencies: 294
-- Data for Name: stock; Type: TABLE DATA; Schema: inventario; Owner: -
--

COPY inventario.stock (id_stock, id_producto, id_variante, id_almacen, cantidad_actual, cantidad_reservada, ubicacion_fisica, fecha_modificacion, usuario_modificacion, costo_promedio, valor_total, fecha_creacion, usuario_creacion) FROM stdin;
1	10	\N	1	12.000	0.000	\N	2026-03-26 22:29:22.896374	\N	2899.0000	34788.00	2026-03-26 22:29:22.896374	SYSTEM
2	13	\N	1	30.000	0.000	\N	\N	\N	299.9000	8997.00	2026-03-28 12:36:28.168103	SYSTEM
3	7	\N	1	15.000	0.000	\N	\N	\N	1899.0000	28485.00	2026-03-28 12:36:28.216387	SYSTEM
4	11	\N	1	20.000	0.000	\N	\N	\N	1850.5000	37010.00	2026-03-28 12:36:28.249473	SYSTEM
5	12	\N	1	20.000	0.000	\N	\N	\N	199.9000	3998.00	2026-03-28 12:36:28.291932	SYSTEM
\.


--
-- TOC entry 4549 (class 0 OID 47568)
-- Dependencies: 337
-- Data for Name: traslados; Type: TABLE DATA; Schema: inventario; Owner: -
--

COPY inventario.traslados (id_traslado, numero_traslado, almacen_origen_id, almacen_destino_id, fecha_pedido, fecha_despacho, fecha_recepcion, gr_serie, gr_numero, estado, id_usuario_despacho, id_usuario_recepcion, observaciones, fecha_modificacion, usuario_modificacion) FROM stdin;
\.


--
-- TOC entry 4551 (class 0 OID 47581)
-- Dependencies: 339
-- Data for Name: traslados_detalle; Type: TABLE DATA; Schema: inventario; Owner: -
--

COPY inventario.traslados_detalle (id_detalle_traslado, id_traslado, id_producto, cantidad_solicitada, cantidad_despachada, cantidad_recibida, costo_unitario_despacho, observaciones, fecha_modificacion, usuario_modificacion) FROM stdin;
\.


--
-- TOC entry 4553 (class 0 OID 47597)
-- Dependencies: 341
-- Data for Name: traslados_incidencias; Type: TABLE DATA; Schema: inventario; Owner: -
--

COPY inventario.traslados_incidencias (id_incidencia, id_detalle_traslado, tipo_incidencia, cantidad, descripcion, fecha_modificacion, usuario_modificacion) FROM stdin;
\.


--
-- TOC entry 4430 (class 0 OID 16755)
-- Dependencies: 218
-- Data for Name: __EFMigrationsHistory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."__EFMigrationsHistory" (migration_id, product_version) FROM stdin;
20260127221140_Inicial	8.0.8
20260127221706_AjusteEsquema	8.0.8
20260129221256_AgregarTiposComprobante	8.0.0
20260316050725_UpdateSunatFields	8.0.0
20260316050735_UpdateSunatFieldsVentas	8.0.0
20260316050748_UpdateSunatFieldsCompras	8.0.0
20260316143604_FixRelationshipsAndSeedData	8.0.0
20260327191956_NormalizarSucursal	8.0.0
20260129231053_Inicial	8.0.8
20260206190831_FixDetalleAudit	8.0.8
20260213160911_AddCompraIdToOrdenCompra	8.0.8
20260217183807_UpdateOrdenCompraSerieNumero	8.0.8
20260217203920_AddSerieNumeroCorrelativoToOrdenCompra	8.0.8
20260219175334_AddObservacionesToCompra	8.0.8
20260221132104_AddCamposSunatPle81	8.0.8
20260322232250_FixTypoIdCompra	8.0.8
20260327231902_AddUbigeoRecursive	8.0.0
\.


--
-- TOC entry 4562 (class 0 OID 62619)
-- Dependencies: 357
-- Data for Name: categorias; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.categorias ("Id", "Nombre", "Descripcion", "ImagenUrl", "IdCategoriaPadre", "Activado", "FechaCreacion", "UsuarioCreacion", "FechaActualizacion", "UsuarioActualizacion", fecha_modificacion, usuario_modificacion) FROM stdin;
\.


--
-- TOC entry 4564 (class 0 OID 62632)
-- Dependencies: 359
-- Data for Name: marcas; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.marcas ("Id", "Nombre", "PaisOrigen", "Activado", "FechaCreacion", "UsuarioCreacion", "FechaActualizacion", "UsuarioActualizacion", fecha_modificacion, usuario_modificacion) FROM stdin;
\.


--
-- TOC entry 4568 (class 0 OID 62648)
-- Dependencies: 363
-- Data for Name: productos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.productos ("Id", "CodigoProducto", "CodigoBarras", "Sku", "NombreProducto", "Descripcion", "ImagenUrl", "IdCategoria", "IdMarca", "IdUnidadMedida", "PrecioCompra", "PrecioVentaPublico", "PrecioVentaMayorista", "PrecioVentaDistribuidor", "TieneVariantes", "PermiteInventarioNegativo", "GravadoImpuesto", "PorcentajeImpuesto", "TipoProducto", "StockMinimo", "StockMaximo", "Activado", "FechaCreacion", "UsuarioCreacion", "FechaActualizacion", "UsuarioActualizacion", fecha_modificacion, usuario_modificacion) FROM stdin;
\.


--
-- TOC entry 4566 (class 0 OID 62640)
-- Dependencies: 361
-- Data for Name: unidades_medida; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.unidades_medida ("Id", "CodigoSunat", "Nombre", "Simbolo", "Activado", "FechaCreacion", "UsuarioCreacion", "FechaActualizacion", "UsuarioActualizacion", fecha_modificacion, usuario_modificacion) FROM stdin;
\.


--
-- TOC entry 4508 (class 0 OID 46573)
-- Dependencies: 296
-- Data for Name: cajas; Type: TABLE DATA; Schema: ventas; Owner: -
--

COPY ventas.cajas (id_caja, nombre_caja, id_almacen, monto_apertura, monto_actual, fecha_apertura, fecha_cierre, id_usuario_cajero, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion, id_estado) FROM stdin;
\.


--
-- TOC entry 4510 (class 0 OID 46582)
-- Dependencies: 298
-- Data for Name: cotizaciones; Type: TABLE DATA; Schema: ventas; Owner: -
--

COPY ventas.cotizaciones (id_cotizacion, serie, numero, id_cliente, id_usuario_vendedor, fecha_emision, fecha_vencimiento, moneda, tipo_cambio, subtotal, impuesto, total, observaciones, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion, id_estado) FROM stdin;
\.


--
-- TOC entry 4512 (class 0 OID 46596)
-- Dependencies: 300
-- Data for Name: detalle_cotizacion; Type: TABLE DATA; Schema: ventas; Owner: -
--

COPY ventas.detalle_cotizacion (id_detalle_cot, id_cotizacion, id_producto, id_variante, cantidad, precio_unitario, porcentaje_descuento, monto_descuento, subtotal, fecha_modificacion, usuario_modificacion) FROM stdin;
\.


--
-- TOC entry 4545 (class 0 OID 47543)
-- Dependencies: 333
-- Data for Name: detalle_notas; Type: TABLE DATA; Schema: ventas; Owner: -
--

COPY ventas.detalle_notas (id_detalle_nota, id_nota, id_producto, id_variante, cantidad, precio_unitario, impuesto_item, total_item, activado, fecha_modificacion, usuario_modificacion) FROM stdin;
\.


--
-- TOC entry 4514 (class 0 OID 46602)
-- Dependencies: 302
-- Data for Name: detalle_venta; Type: TABLE DATA; Schema: ventas; Owner: -
--

COPY ventas.detalle_venta (id_detalle_venta, id_venta, id_producto, id_variante, descripcion_producto, cantidad, precio_unitario, precio_lista_original, porcentaje_impuesto, impuesto_item, total_item, codigo_afectacion_igv, codigo_tributo, precio_unitario_base, descuento_item, valor_item, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion, activado) FROM stdin;
1	4	10	\N	\N	1.000	2899.00	\N	0.00	0.00	0.00	\N	\N	\N	0.0000	\N	2026-03-28 00:59:58.585136	API_USER	\N	\N	t
2	5	10	\N	\N	1.000	2899.00	\N	0.00	0.00	0.00	\N	\N	\N	0.0000	\N	2026-03-28 12:08:07.28099	API_USER	\N	\N	t
\.


--
-- TOC entry 4516 (class 0 OID 46608)
-- Dependencies: 304
-- Data for Name: metodos_pago; Type: TABLE DATA; Schema: ventas; Owner: -
--

COPY ventas.metodos_pago (id_metodo_pago, codigo, nombre, requiere_referencia, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion) FROM stdin;
1	EFE	Efectivo	f	t	2026-01-27 17:36:28.866902	SYSTEM	2026-01-27 17:36:28.866902	\N
2	TAR	Tarjeta Crédito/Débito	t	t	2026-01-27 17:36:28.866902	SYSTEM	2026-01-27 17:36:28.866902	\N
3	TRA	Transferencia Bancaria	t	t	2026-01-27 17:36:28.866902	SYSTEM	2026-01-27 17:36:28.866902	\N
4	YAP	Yape/Plin	t	t	2026-01-27 17:36:28.866902	SYSTEM	2026-01-27 17:36:28.866902	\N
\.


--
-- TOC entry 4518 (class 0 OID 46616)
-- Dependencies: 306
-- Data for Name: movimientos_caja; Type: TABLE DATA; Schema: ventas; Owner: -
--

COPY ventas.movimientos_caja (id_movimiento_caja, id_caja, monto, concepto, id_pago_relacionado, fecha_movimiento, usuario_responsable, id_tipo_movimiento, fecha_modificacion, usuario_modificacion) FROM stdin;
\.


--
-- TOC entry 4535 (class 0 OID 47262)
-- Dependencies: 323
-- Data for Name: notas; Type: TABLE DATA; Schema: ventas; Owner: -
--

COPY ventas.notas (id_nota, id_venta_referencia, id_tipo_nota, id_tipo_comprobante, serie, numero, fecha_emision, motivo_sustento, total_nota, activado, codigo_tipo_comprobante_ref, serie_ref, numero_ref, codigo_motivo, descripcion_motivo, codigo_motivo_nc, codigo_motivo_nd, id_tipo_doc_ref, fecha_modificacion, usuario_modificacion) FROM stdin;
\.


--
-- TOC entry 4520 (class 0 OID 46621)
-- Dependencies: 308
-- Data for Name: pagos; Type: TABLE DATA; Schema: ventas; Owner: -
--

COPY ventas.pagos (id_pago, id_venta, id_metodo_pago, monto_pago, referencia_pago, fecha_pago, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion) FROM stdin;
\.


--
-- TOC entry 4522 (class 0 OID 46628)
-- Dependencies: 310
-- Data for Name: ventas; Type: TABLE DATA; Schema: ventas; Owner: -
--

COPY ventas.ventas (id_venta, id_empresa, id_almacen, id_caja, id_cliente, id_usuario_vendedor, id_cotizacion_origen, serie, numero, fecha_emision, fecha_vencimiento_pago, moneda, tipo_cambio, subtotal_gravado, subtotal_exonerado, subtotal_inafecto, total_impuesto, total_descuento_global, total_venta, saldo_pendiente, observaciones, activado, fecha_creacion, usuario_creacion, fecha_modificacion, usuario_modificacion, id_estado, id_estado_pago, id_tipo_comprobante) FROM stdin;
4	1	1	\N	5	1	\N	B001	1	2026-03-28 00:59:58.385604	\N	PEN	1.0000	2899.00	0.00	0.00	521.82	0.00	3420.82	3420.82	Método de pago: Efectivo	t	2026-03-28 00:59:58.584963	API_USER	\N	\N	1	1	2
5	1	1	\N	5	1	\N	B001	2	2026-03-28 12:08:07.147512	\N	PEN	1.0000	2899.00	0.00	0.00	521.82	0.00	3420.82	3420.82	Método de pago: Efectivo	t	2026-03-28 12:08:07.280884	API_USER	\N	\N	10	40	2
\.


--
-- TOC entry 4657 (class 0 OID 0)
-- Dependencies: 220
-- Name: categorias_id_categoria_seq; Type: SEQUENCE SET; Schema: catalogo; Owner: -
--

SELECT pg_catalog.setval('catalogo.categorias_id_categoria_seq', 2, true);


--
-- TOC entry 4658 (class 0 OID 0)
-- Dependencies: 222
-- Name: imagenes_producto_id_imagen_seq; Type: SEQUENCE SET; Schema: catalogo; Owner: -
--

SELECT pg_catalog.setval('catalogo.imagenes_producto_id_imagen_seq', 1, false);


--
-- TOC entry 4659 (class 0 OID 0)
-- Dependencies: 224
-- Name: listas_precios_id_lista_precio_seq; Type: SEQUENCE SET; Schema: catalogo; Owner: -
--

SELECT pg_catalog.setval('catalogo.listas_precios_id_lista_precio_seq', 1, false);


--
-- TOC entry 4660 (class 0 OID 0)
-- Dependencies: 226
-- Name: marcas_id_marca_seq; Type: SEQUENCE SET; Schema: catalogo; Owner: -
--

SELECT pg_catalog.setval('catalogo.marcas_id_marca_seq', 3, true);


--
-- TOC entry 4661 (class 0 OID 0)
-- Dependencies: 228
-- Name: productos_id_producto_seq; Type: SEQUENCE SET; Schema: catalogo; Owner: -
--

SELECT pg_catalog.setval('catalogo.productos_id_producto_seq', 5, true);


--
-- TOC entry 4662 (class 0 OID 0)
-- Dependencies: 230
-- Name: unidades_medida_id_unidad_seq; Type: SEQUENCE SET; Schema: catalogo; Owner: -
--

SELECT pg_catalog.setval('catalogo.unidades_medida_id_unidad_seq', 6, true);


--
-- TOC entry 4663 (class 0 OID 0)
-- Dependencies: 232
-- Name: variantes_producto_id_variante_seq; Type: SEQUENCE SET; Schema: catalogo; Owner: -
--

SELECT pg_catalog.setval('catalogo.variantes_producto_id_variante_seq', 1, false);


--
-- TOC entry 4664 (class 0 OID 0)
-- Dependencies: 234
-- Name: clientes_id_cliente_seq; Type: SEQUENCE SET; Schema: clientes; Owner: -
--

SELECT pg_catalog.setval('clientes.clientes_id_cliente_seq', 5, true);


--
-- TOC entry 4665 (class 0 OID 0)
-- Dependencies: 236
-- Name: contactos_cliente_id_contacto_seq; Type: SEQUENCE SET; Schema: clientes; Owner: -
--

SELECT pg_catalog.setval('clientes.contactos_cliente_id_contacto_seq', 1, false);


--
-- TOC entry 4666 (class 0 OID 0)
-- Dependencies: 238
-- Name: compras_id_compra_seq; Type: SEQUENCE SET; Schema: compras; Owner: -
--

SELECT pg_catalog.setval('compras.compras_id_compra_seq', 30, true);


--
-- TOC entry 4667 (class 0 OID 0)
-- Dependencies: 240
-- Name: detalle_compra_id_detalle_compra_seq; Type: SEQUENCE SET; Schema: compras; Owner: -
--

SELECT pg_catalog.setval('compras.detalle_compra_id_detalle_compra_seq', 32, true);


--
-- TOC entry 4668 (class 0 OID 0)
-- Dependencies: 334
-- Name: detalle_notas_id_detalle_nota_seq; Type: SEQUENCE SET; Schema: compras; Owner: -
--

SELECT pg_catalog.setval('compras.detalle_notas_id_detalle_nota_seq', 1, false);


--
-- TOC entry 4669 (class 0 OID 0)
-- Dependencies: 242
-- Name: detalle_orden_compra_id_detalle_oc_seq; Type: SEQUENCE SET; Schema: compras; Owner: -
--

SELECT pg_catalog.setval('compras.detalle_orden_compra_id_detalle_oc_seq', 1, true);


--
-- TOC entry 4670 (class 0 OID 0)
-- Dependencies: 324
-- Name: notas_id_nota_seq; Type: SEQUENCE SET; Schema: compras; Owner: -
--

SELECT pg_catalog.setval('compras.notas_id_nota_seq', 1, false);


--
-- TOC entry 4671 (class 0 OID 0)
-- Dependencies: 244
-- Name: ordenes_compra_id_orden_compra_seq; Type: SEQUENCE SET; Schema: compras; Owner: -
--

SELECT pg_catalog.setval('compras.ordenes_compra_id_orden_compra_seq', 1, true);


--
-- TOC entry 4672 (class 0 OID 0)
-- Dependencies: 246
-- Name: proveedores_id_proveedor_seq; Type: SEQUENCE SET; Schema: compras; Owner: -
--

SELECT pg_catalog.setval('compras.proveedores_id_proveedor_seq', 3, true);


--
-- TOC entry 4673 (class 0 OID 0)
-- Dependencies: 248
-- Name: configuraciones_id_configuracion_seq; Type: SEQUENCE SET; Schema: configuracion; Owner: -
--

SELECT pg_catalog.setval('configuracion.configuraciones_id_configuracion_seq', 2, true);


--
-- TOC entry 4674 (class 0 OID 0)
-- Dependencies: 250
-- Name: empresa_id_empresa_seq; Type: SEQUENCE SET; Schema: configuracion; Owner: -
--

SELECT pg_catalog.setval('configuracion.empresa_id_empresa_seq', 1, true);


--
-- TOC entry 4675 (class 0 OID 0)
-- Dependencies: 328
-- Name: impuestos_id_impuesto_seq; Type: SEQUENCE SET; Schema: configuracion; Owner: -
--

SELECT pg_catalog.setval('configuracion.impuestos_id_impuesto_seq', 4, true);


--
-- TOC entry 4676 (class 0 OID 0)
-- Dependencies: 318
-- Name: matriz_regla_sunat_id_regla_seq; Type: SEQUENCE SET; Schema: configuracion; Owner: -
--

SELECT pg_catalog.setval('configuracion.matriz_regla_sunat_id_regla_seq', 6, true);


--
-- TOC entry 4677 (class 0 OID 0)
-- Dependencies: 344
-- Name: motivo_nota_credito_id_motivo_seq; Type: SEQUENCE SET; Schema: configuracion; Owner: -
--

SELECT pg_catalog.setval('configuracion.motivo_nota_credito_id_motivo_seq', 13, true);


--
-- TOC entry 4678 (class 0 OID 0)
-- Dependencies: 346
-- Name: motivo_nota_debito_id_motivo_seq; Type: SEQUENCE SET; Schema: configuracion; Owner: -
--

SELECT pg_catalog.setval('configuracion.motivo_nota_debito_id_motivo_seq', 6, true);


--
-- TOC entry 4679 (class 0 OID 0)
-- Dependencies: 330
-- Name: parametros_configuracion_id_parametro_seq; Type: SEQUENCE SET; Schema: configuracion; Owner: -
--

SELECT pg_catalog.setval('configuracion.parametros_configuracion_id_parametro_seq', 2, true);


--
-- TOC entry 4680 (class 0 OID 0)
-- Dependencies: 320
-- Name: regla_documento_comprobante_id_relacion_seq; Type: SEQUENCE SET; Schema: configuracion; Owner: -
--

SELECT pg_catalog.setval('configuracion.regla_documento_comprobante_id_relacion_seq', 26, true);


--
-- TOC entry 4681 (class 0 OID 0)
-- Dependencies: 252
-- Name: series_comprobantes_id_serie_seq; Type: SEQUENCE SET; Schema: configuracion; Owner: -
--

SELECT pg_catalog.setval('configuracion.series_comprobantes_id_serie_seq', 5, true);


--
-- TOC entry 4682 (class 0 OID 0)
-- Dependencies: 326
-- Name: sucursales_id_sucursal_seq; Type: SEQUENCE SET; Schema: configuracion; Owner: -
--

SELECT pg_catalog.setval('configuracion.sucursales_id_sucursal_seq', 1, true);


--
-- TOC entry 4683 (class 0 OID 0)
-- Dependencies: 255
-- Name: tablas_generales_detalle_id_detalle_seq; Type: SEQUENCE SET; Schema: configuracion; Owner: -
--

SELECT pg_catalog.setval('configuracion.tablas_generales_detalle_id_detalle_seq', 50, true);


--
-- TOC entry 4684 (class 0 OID 0)
-- Dependencies: 256
-- Name: tablas_generales_id_tabla_seq; Type: SEQUENCE SET; Schema: configuracion; Owner: -
--

SELECT pg_catalog.setval('configuracion.tablas_generales_id_tabla_seq', 13, true);


--
-- TOC entry 4685 (class 0 OID 0)
-- Dependencies: 342
-- Name: tipo_afectacion_igv_id_afectacion_seq; Type: SEQUENCE SET; Schema: configuracion; Owner: -
--

SELECT pg_catalog.setval('configuracion.tipo_afectacion_igv_id_afectacion_seq', 19, true);


--
-- TOC entry 4686 (class 0 OID 0)
-- Dependencies: 314
-- Name: tipo_comprobante_id_tipo_comprobante_seq; Type: SEQUENCE SET; Schema: configuracion; Owner: -
--

SELECT pg_catalog.setval('configuracion.tipo_comprobante_id_tipo_comprobante_seq', 13, true);


--
-- TOC entry 4687 (class 0 OID 0)
-- Dependencies: 312
-- Name: tipo_documento_id_regla_seq; Type: SEQUENCE SET; Schema: configuracion; Owner: -
--

SELECT pg_catalog.setval('configuracion.tipo_documento_id_regla_seq', 18, true);


--
-- TOC entry 4688 (class 0 OID 0)
-- Dependencies: 316
-- Name: tipo_operacion_sunat_id_tipo_operacion_seq; Type: SEQUENCE SET; Schema: configuracion; Owner: -
--

SELECT pg_catalog.setval('configuracion.tipo_operacion_sunat_id_tipo_operacion_seq', 10, true);


--
-- TOC entry 4689 (class 0 OID 0)
-- Dependencies: 258
-- Name: asientos_contables_id_asiento_seq; Type: SEQUENCE SET; Schema: contabilidad; Owner: -
--

SELECT pg_catalog.setval('contabilidad.asientos_contables_id_asiento_seq', 1, false);


--
-- TOC entry 4690 (class 0 OID 0)
-- Dependencies: 260
-- Name: centros_costo_id_centro_costo_seq; Type: SEQUENCE SET; Schema: contabilidad; Owner: -
--

SELECT pg_catalog.setval('contabilidad.centros_costo_id_centro_costo_seq', 1, false);


--
-- TOC entry 4691 (class 0 OID 0)
-- Dependencies: 262
-- Name: detalle_asiento_id_detalle_asiento_seq; Type: SEQUENCE SET; Schema: contabilidad; Owner: -
--

SELECT pg_catalog.setval('contabilidad.detalle_asiento_id_detalle_asiento_seq', 1, false);


--
-- TOC entry 4692 (class 0 OID 0)
-- Dependencies: 264
-- Name: plan_cuentas_id_cuenta_seq; Type: SEQUENCE SET; Schema: contabilidad; Owner: -
--

SELECT pg_catalog.setval('contabilidad.plan_cuentas_id_cuenta_seq', 1, false);


--
-- TOC entry 4693 (class 0 OID 0)
-- Dependencies: 266
-- Name: areas_id_area_seq; Type: SEQUENCE SET; Schema: identidad; Owner: -
--

SELECT pg_catalog.setval('identidad.areas_id_area_seq', 1, false);


--
-- TOC entry 4694 (class 0 OID 0)
-- Dependencies: 268
-- Name: auditoria_accesos_id_auditoria_seq; Type: SEQUENCE SET; Schema: identidad; Owner: -
--

SELECT pg_catalog.setval('identidad.auditoria_accesos_id_auditoria_seq', 1, false);


--
-- TOC entry 4695 (class 0 OID 0)
-- Dependencies: 270
-- Name: cargos_id_cargo_seq; Type: SEQUENCE SET; Schema: identidad; Owner: -
--

SELECT pg_catalog.setval('identidad.cargos_id_cargo_seq', 1, false);


--
-- TOC entry 4696 (class 0 OID 0)
-- Dependencies: 272
-- Name: menus_id_menu_seq; Type: SEQUENCE SET; Schema: identidad; Owner: -
--

SELECT pg_catalog.setval('identidad.menus_id_menu_seq', 27, true);


--
-- TOC entry 4697 (class 0 OID 0)
-- Dependencies: 274
-- Name: permisos_id_permiso_seq; Type: SEQUENCE SET; Schema: identidad; Owner: -
--

SELECT pg_catalog.setval('identidad.permisos_id_permiso_seq', 1, false);


--
-- TOC entry 4698 (class 0 OID 0)
-- Dependencies: 276
-- Name: roles_id_rol_seq; Type: SEQUENCE SET; Schema: identidad; Owner: -
--

SELECT pg_catalog.setval('identidad.roles_id_rol_seq', 4, true);


--
-- TOC entry 4699 (class 0 OID 0)
-- Dependencies: 278
-- Name: roles_menus_id_rol_menu_seq; Type: SEQUENCE SET; Schema: identidad; Owner: -
--

SELECT pg_catalog.setval('identidad.roles_menus_id_rol_menu_seq', 1, false);


--
-- TOC entry 4700 (class 0 OID 0)
-- Dependencies: 280
-- Name: roles_menus_permisos_id_rol_menu_permiso_seq; Type: SEQUENCE SET; Schema: identidad; Owner: -
--

SELECT pg_catalog.setval('identidad.roles_menus_permisos_id_rol_menu_permiso_seq', 1, false);


--
-- TOC entry 4701 (class 0 OID 0)
-- Dependencies: 283
-- Name: tipos_permiso_id_tipo_permiso_seq; Type: SEQUENCE SET; Schema: identidad; Owner: -
--

SELECT pg_catalog.setval('identidad.tipos_permiso_id_tipo_permiso_seq', 9, true);


--
-- TOC entry 4702 (class 0 OID 0)
-- Dependencies: 285
-- Name: trabajadores_id_trabajador_seq; Type: SEQUENCE SET; Schema: identidad; Owner: -
--

SELECT pg_catalog.setval('identidad.trabajadores_id_trabajador_seq', 1, false);


--
-- TOC entry 4703 (class 0 OID 0)
-- Dependencies: 287
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE SET; Schema: identidad; Owner: -
--

SELECT pg_catalog.setval('identidad.usuarios_id_usuario_seq', 1, true);


--
-- TOC entry 4704 (class 0 OID 0)
-- Dependencies: 289
-- Name: usuarios_roles_id_usuario_rol_seq; Type: SEQUENCE SET; Schema: identidad; Owner: -
--

SELECT pg_catalog.setval('identidad.usuarios_roles_id_usuario_rol_seq', 1, false);


--
-- TOC entry 4705 (class 0 OID 0)
-- Dependencies: 291
-- Name: almacenes_id_almacen_seq; Type: SEQUENCE SET; Schema: inventario; Owner: -
--

SELECT pg_catalog.setval('inventario.almacenes_id_almacen_seq', 1, true);


--
-- TOC entry 4706 (class 0 OID 0)
-- Dependencies: 364
-- Name: inv_kardex_lote_id_seq; Type: SEQUENCE SET; Schema: inventario; Owner: -
--

SELECT pg_catalog.setval('inventario.inv_kardex_lote_id_seq', 1, false);


--
-- TOC entry 4707 (class 0 OID 0)
-- Dependencies: 366
-- Name: inv_kardex_movimiento_id_seq; Type: SEQUENCE SET; Schema: inventario; Owner: -
--

SELECT pg_catalog.setval('inventario.inv_kardex_movimiento_id_seq', 11, true);


--
-- TOC entry 4708 (class 0 OID 0)
-- Dependencies: 369
-- Name: inv_kardex_recalculo_log_id_seq; Type: SEQUENCE SET; Schema: inventario; Owner: -
--

SELECT pg_catalog.setval('inventario.inv_kardex_recalculo_log_id_seq', 1, false);


--
-- TOC entry 4709 (class 0 OID 0)
-- Dependencies: 293
-- Name: movimientos_inventario_id_movimiento_seq; Type: SEQUENCE SET; Schema: inventario; Owner: -
--

SELECT pg_catalog.setval('inventario.movimientos_inventario_id_movimiento_seq', 11, true);


--
-- TOC entry 4710 (class 0 OID 0)
-- Dependencies: 295
-- Name: stock_id_stock_seq; Type: SEQUENCE SET; Schema: inventario; Owner: -
--

SELECT pg_catalog.setval('inventario.stock_id_stock_seq', 5, true);


--
-- TOC entry 4711 (class 0 OID 0)
-- Dependencies: 338
-- Name: traslados_detalle_id_detalle_traslado_seq; Type: SEQUENCE SET; Schema: inventario; Owner: -
--

SELECT pg_catalog.setval('inventario.traslados_detalle_id_detalle_traslado_seq', 1, false);


--
-- TOC entry 4712 (class 0 OID 0)
-- Dependencies: 336
-- Name: traslados_id_traslado_seq; Type: SEQUENCE SET; Schema: inventario; Owner: -
--

SELECT pg_catalog.setval('inventario.traslados_id_traslado_seq', 1, false);


--
-- TOC entry 4713 (class 0 OID 0)
-- Dependencies: 340
-- Name: traslados_incidencias_id_incidencia_seq; Type: SEQUENCE SET; Schema: inventario; Owner: -
--

SELECT pg_catalog.setval('inventario.traslados_incidencias_id_incidencia_seq', 1, false);


--
-- TOC entry 4714 (class 0 OID 0)
-- Dependencies: 356
-- Name: categorias_Id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."categorias_Id_seq"', 1, false);


--
-- TOC entry 4715 (class 0 OID 0)
-- Dependencies: 358
-- Name: marcas_Id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."marcas_Id_seq"', 1, false);


--
-- TOC entry 4716 (class 0 OID 0)
-- Dependencies: 362
-- Name: productos_Id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."productos_Id_seq"', 1, false);


--
-- TOC entry 4717 (class 0 OID 0)
-- Dependencies: 360
-- Name: unidades_medida_Id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."unidades_medida_Id_seq"', 1, false);


--
-- TOC entry 4718 (class 0 OID 0)
-- Dependencies: 297
-- Name: cajas_id_caja_seq; Type: SEQUENCE SET; Schema: ventas; Owner: -
--

SELECT pg_catalog.setval('ventas.cajas_id_caja_seq', 1, false);


--
-- TOC entry 4719 (class 0 OID 0)
-- Dependencies: 299
-- Name: cotizaciones_id_cotizacion_seq; Type: SEQUENCE SET; Schema: ventas; Owner: -
--

SELECT pg_catalog.setval('ventas.cotizaciones_id_cotizacion_seq', 1, false);


--
-- TOC entry 4720 (class 0 OID 0)
-- Dependencies: 301
-- Name: detalle_cotizacion_id_detalle_cot_seq; Type: SEQUENCE SET; Schema: ventas; Owner: -
--

SELECT pg_catalog.setval('ventas.detalle_cotizacion_id_detalle_cot_seq', 1, false);


--
-- TOC entry 4721 (class 0 OID 0)
-- Dependencies: 332
-- Name: detalle_notas_id_detalle_nota_seq; Type: SEQUENCE SET; Schema: ventas; Owner: -
--

SELECT pg_catalog.setval('ventas.detalle_notas_id_detalle_nota_seq', 1, false);


--
-- TOC entry 4722 (class 0 OID 0)
-- Dependencies: 303
-- Name: detalle_venta_id_detalle_venta_seq; Type: SEQUENCE SET; Schema: ventas; Owner: -
--

SELECT pg_catalog.setval('ventas.detalle_venta_id_detalle_venta_seq', 6, true);


--
-- TOC entry 4723 (class 0 OID 0)
-- Dependencies: 305
-- Name: metodos_pago_id_metodo_pago_seq; Type: SEQUENCE SET; Schema: ventas; Owner: -
--

SELECT pg_catalog.setval('ventas.metodos_pago_id_metodo_pago_seq', 4, true);


--
-- TOC entry 4724 (class 0 OID 0)
-- Dependencies: 307
-- Name: movimientos_caja_id_movimiento_caja_seq; Type: SEQUENCE SET; Schema: ventas; Owner: -
--

SELECT pg_catalog.setval('ventas.movimientos_caja_id_movimiento_caja_seq', 1, false);


--
-- TOC entry 4725 (class 0 OID 0)
-- Dependencies: 322
-- Name: notas_id_nota_seq; Type: SEQUENCE SET; Schema: ventas; Owner: -
--

SELECT pg_catalog.setval('ventas.notas_id_nota_seq', 1, false);


--
-- TOC entry 4726 (class 0 OID 0)
-- Dependencies: 309
-- Name: pagos_id_pago_seq; Type: SEQUENCE SET; Schema: ventas; Owner: -
--

SELECT pg_catalog.setval('ventas.pagos_id_pago_seq', 1, false);


--
-- TOC entry 4727 (class 0 OID 0)
-- Dependencies: 311
-- Name: ventas_id_venta_seq; Type: SEQUENCE SET; Schema: ventas; Owner: -
--

SELECT pg_catalog.setval('ventas.ventas_id_venta_seq', 7, true);


--
-- TOC entry 3941 (class 2606 OID 46693)
-- Name: categorias categorias_pkey; Type: CONSTRAINT; Schema: catalogo; Owner: -
--

ALTER TABLE ONLY catalogo.categorias
    ADD CONSTRAINT categorias_pkey PRIMARY KEY (id_categoria);


--
-- TOC entry 3943 (class 2606 OID 46695)
-- Name: imagenes_producto imagenes_producto_pkey; Type: CONSTRAINT; Schema: catalogo; Owner: -
--

ALTER TABLE ONLY catalogo.imagenes_producto
    ADD CONSTRAINT imagenes_producto_pkey PRIMARY KEY (id_imagen);


--
-- TOC entry 3945 (class 2606 OID 46697)
-- Name: listas_precios listas_precios_pkey; Type: CONSTRAINT; Schema: catalogo; Owner: -
--

ALTER TABLE ONLY catalogo.listas_precios
    ADD CONSTRAINT listas_precios_pkey PRIMARY KEY (id_lista_precio);


--
-- TOC entry 3947 (class 2606 OID 46699)
-- Name: marcas marcas_pkey; Type: CONSTRAINT; Schema: catalogo; Owner: -
--

ALTER TABLE ONLY catalogo.marcas
    ADD CONSTRAINT marcas_pkey PRIMARY KEY (id_marca);


--
-- TOC entry 4151 (class 2606 OID 62617)
-- Name: __ef_migrations pk___ef_migrations; Type: CONSTRAINT; Schema: catalogo; Owner: -
--

ALTER TABLE ONLY catalogo.__ef_migrations
    ADD CONSTRAINT pk___ef_migrations PRIMARY KEY (migration_id);


--
-- TOC entry 3949 (class 2606 OID 46701)
-- Name: productos productos_codigo_producto_key; Type: CONSTRAINT; Schema: catalogo; Owner: -
--

ALTER TABLE ONLY catalogo.productos
    ADD CONSTRAINT productos_codigo_producto_key UNIQUE (codigo_producto);


--
-- TOC entry 3951 (class 2606 OID 46703)
-- Name: productos productos_pkey; Type: CONSTRAINT; Schema: catalogo; Owner: -
--

ALTER TABLE ONLY catalogo.productos
    ADD CONSTRAINT productos_pkey PRIMARY KEY (id_producto);


--
-- TOC entry 3953 (class 2606 OID 46705)
-- Name: productos productos_sku_key; Type: CONSTRAINT; Schema: catalogo; Owner: -
--

ALTER TABLE ONLY catalogo.productos
    ADD CONSTRAINT productos_sku_key UNIQUE (sku);


--
-- TOC entry 3955 (class 2606 OID 46707)
-- Name: unidades_medida unidades_medida_pkey; Type: CONSTRAINT; Schema: catalogo; Owner: -
--

ALTER TABLE ONLY catalogo.unidades_medida
    ADD CONSTRAINT unidades_medida_pkey PRIMARY KEY (id_unidad);


--
-- TOC entry 3957 (class 2606 OID 46709)
-- Name: variantes_producto variantes_producto_pkey; Type: CONSTRAINT; Schema: catalogo; Owner: -
--

ALTER TABLE ONLY catalogo.variantes_producto
    ADD CONSTRAINT variantes_producto_pkey PRIMARY KEY (id_variante);


--
-- TOC entry 3959 (class 2606 OID 46711)
-- Name: variantes_producto variantes_producto_sku_variante_key; Type: CONSTRAINT; Schema: catalogo; Owner: -
--

ALTER TABLE ONLY catalogo.variantes_producto
    ADD CONSTRAINT variantes_producto_sku_variante_key UNIQUE (sku_variante);


--
-- TOC entry 4178 (class 2606 OID 66658)
-- Name: __EFMigrationsHistory PK___EFMigrationsHistory; Type: CONSTRAINT; Schema: clientes; Owner: -
--

ALTER TABLE ONLY clientes."__EFMigrationsHistory"
    ADD CONSTRAINT "PK___EFMigrationsHistory" PRIMARY KEY ("MigrationId");


--
-- TOC entry 4184 (class 2606 OID 66800)
-- Name: __ef_migrations_history __ef_migrations_history_pkey; Type: CONSTRAINT; Schema: clientes; Owner: -
--

ALTER TABLE ONLY clientes.__ef_migrations_history
    ADD CONSTRAINT __ef_migrations_history_pkey PRIMARY KEY (migration_id);


--
-- TOC entry 3961 (class 2606 OID 46713)
-- Name: clientes clientes_numero_documento_key; Type: CONSTRAINT; Schema: clientes; Owner: -
--

ALTER TABLE ONLY clientes.clientes
    ADD CONSTRAINT clientes_numero_documento_key UNIQUE (numero_documento);


--
-- TOC entry 3963 (class 2606 OID 46715)
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: clientes; Owner: -
--

ALTER TABLE ONLY clientes.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (id_cliente);


--
-- TOC entry 3967 (class 2606 OID 46717)
-- Name: contactos_cliente contactos_cliente_pkey; Type: CONSTRAINT; Schema: clientes; Owner: -
--

ALTER TABLE ONLY clientes.contactos_cliente
    ADD CONSTRAINT contactos_cliente_pkey PRIMARY KEY (id_contacto);


--
-- TOC entry 4182 (class 2606 OID 66795)
-- Name: __ef_migrations_history __ef_migrations_history_pkey; Type: CONSTRAINT; Schema: compras; Owner: -
--

ALTER TABLE ONLY compras.__ef_migrations_history
    ADD CONSTRAINT __ef_migrations_history_pkey PRIMARY KEY (migration_id);


--
-- TOC entry 3969 (class 2606 OID 46719)
-- Name: compras compras_pkey; Type: CONSTRAINT; Schema: compras; Owner: -
--

ALTER TABLE ONLY compras.compras
    ADD CONSTRAINT compras_pkey PRIMARY KEY (id_compra);


--
-- TOC entry 3971 (class 2606 OID 46721)
-- Name: detalle_compra detalle_compra_pkey; Type: CONSTRAINT; Schema: compras; Owner: -
--

ALTER TABLE ONLY compras.detalle_compra
    ADD CONSTRAINT detalle_compra_pkey PRIMARY KEY (id_detalle_compra);


--
-- TOC entry 4129 (class 2606 OID 47560)
-- Name: detalle_notas detalle_notas_pkey; Type: CONSTRAINT; Schema: compras; Owner: -
--

ALTER TABLE ONLY compras.detalle_notas
    ADD CONSTRAINT detalle_notas_pkey PRIMARY KEY (id_detalle_nota);


--
-- TOC entry 3973 (class 2606 OID 46723)
-- Name: detalle_orden_compra detalle_orden_compra_pkey; Type: CONSTRAINT; Schema: compras; Owner: -
--

ALTER TABLE ONLY compras.detalle_orden_compra
    ADD CONSTRAINT detalle_orden_compra_pkey PRIMARY KEY (id_detalle_oc);


--
-- TOC entry 4117 (class 2606 OID 47279)
-- Name: notas notas_pkey; Type: CONSTRAINT; Schema: compras; Owner: -
--

ALTER TABLE ONLY compras.notas
    ADD CONSTRAINT notas_pkey PRIMARY KEY (id_nota);


--
-- TOC entry 3975 (class 2606 OID 46725)
-- Name: ordenes_compra ordenes_compra_codigo_orden_key; Type: CONSTRAINT; Schema: compras; Owner: -
--

ALTER TABLE ONLY compras.ordenes_compra
    ADD CONSTRAINT ordenes_compra_codigo_orden_key UNIQUE (codigo_orden);


--
-- TOC entry 3977 (class 2606 OID 46727)
-- Name: ordenes_compra ordenes_compra_pkey; Type: CONSTRAINT; Schema: compras; Owner: -
--

ALTER TABLE ONLY compras.ordenes_compra
    ADD CONSTRAINT ordenes_compra_pkey PRIMARY KEY (id_orden_compra);


--
-- TOC entry 4180 (class 2606 OID 66766)
-- Name: ef_migrations_history pk_ef_migrations_history; Type: CONSTRAINT; Schema: compras; Owner: -
--

ALTER TABLE ONLY compras.ef_migrations_history
    ADD CONSTRAINT pk_ef_migrations_history PRIMARY KEY (migration_id);


--
-- TOC entry 3980 (class 2606 OID 46729)
-- Name: proveedores proveedores_numero_documento_key; Type: CONSTRAINT; Schema: compras; Owner: -
--

ALTER TABLE ONLY compras.proveedores
    ADD CONSTRAINT proveedores_numero_documento_key UNIQUE (numero_documento);


--
-- TOC entry 3982 (class 2606 OID 46731)
-- Name: proveedores proveedores_pkey; Type: CONSTRAINT; Schema: compras; Owner: -
--

ALTER TABLE ONLY compras.proveedores
    ADD CONSTRAINT proveedores_pkey PRIMARY KEY (id_proveedor);


--
-- TOC entry 3985 (class 2606 OID 46733)
-- Name: configuraciones configuraciones_clave_key; Type: CONSTRAINT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.configuraciones
    ADD CONSTRAINT configuraciones_clave_key UNIQUE (clave);


--
-- TOC entry 3987 (class 2606 OID 46735)
-- Name: configuraciones configuraciones_pkey; Type: CONSTRAINT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.configuraciones
    ADD CONSTRAINT configuraciones_pkey PRIMARY KEY (id_configuracion);


--
-- TOC entry 3989 (class 2606 OID 46737)
-- Name: empresa empresa_pkey; Type: CONSTRAINT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.empresa
    ADD CONSTRAINT empresa_pkey PRIMARY KEY (id_empresa);


--
-- TOC entry 3991 (class 2606 OID 46739)
-- Name: empresa empresa_ruc_key; Type: CONSTRAINT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.empresa
    ADD CONSTRAINT empresa_ruc_key UNIQUE (ruc);


--
-- TOC entry 4111 (class 2606 OID 47251)
-- Name: matriz_regla_sunat matriz_regla_sunat_pkey; Type: CONSTRAINT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.matriz_regla_sunat
    ADD CONSTRAINT matriz_regla_sunat_pkey PRIMARY KEY (id_regla);


--
-- TOC entry 4143 (class 2606 OID 47721)
-- Name: motivo_nota_credito motivo_nota_credito_codigo_key; Type: CONSTRAINT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.motivo_nota_credito
    ADD CONSTRAINT motivo_nota_credito_codigo_key UNIQUE (codigo);


--
-- TOC entry 4145 (class 2606 OID 47719)
-- Name: motivo_nota_credito motivo_nota_credito_pkey; Type: CONSTRAINT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.motivo_nota_credito
    ADD CONSTRAINT motivo_nota_credito_pkey PRIMARY KEY (id_motivo);


--
-- TOC entry 4147 (class 2606 OID 47733)
-- Name: motivo_nota_debito motivo_nota_debito_codigo_key; Type: CONSTRAINT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.motivo_nota_debito
    ADD CONSTRAINT motivo_nota_debito_codigo_key UNIQUE (codigo);


--
-- TOC entry 4149 (class 2606 OID 47731)
-- Name: motivo_nota_debito motivo_nota_debito_pkey; Type: CONSTRAINT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.motivo_nota_debito
    ADD CONSTRAINT motivo_nota_debito_pkey PRIMARY KEY (id_motivo);


--
-- TOC entry 4123 (class 2606 OID 47357)
-- Name: parametros_configuracion parametros_configuracion_codigo_key; Type: CONSTRAINT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.parametros_configuracion
    ADD CONSTRAINT parametros_configuracion_codigo_key UNIQUE (codigo);


--
-- TOC entry 4125 (class 2606 OID 47355)
-- Name: parametros_configuracion parametros_configuracion_pkey; Type: CONSTRAINT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.parametros_configuracion
    ADD CONSTRAINT parametros_configuracion_pkey PRIMARY KEY (id_parametro);


--
-- TOC entry 4121 (class 2606 OID 66634)
-- Name: impuestos pk_impuestos; Type: CONSTRAINT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.impuestos
    ADD CONSTRAINT pk_impuestos PRIMARY KEY (id_impuesto);


--
-- TOC entry 4119 (class 2606 OID 66632)
-- Name: sucursales pk_sucursales; Type: CONSTRAINT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.sucursales
    ADD CONSTRAINT pk_sucursales PRIMARY KEY (id_sucursal);


--
-- TOC entry 4187 (class 2606 OID 66871)
-- Name: ubigeos pk_ubigeos; Type: CONSTRAINT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.ubigeos
    ADD CONSTRAINT pk_ubigeos PRIMARY KEY (codigo);


--
-- TOC entry 4113 (class 2606 OID 47260)
-- Name: regla_documento_comprobante regla_documento_comprobante_pkey; Type: CONSTRAINT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.regla_documento_comprobante
    ADD CONSTRAINT regla_documento_comprobante_pkey PRIMARY KEY (id_relacion);


--
-- TOC entry 3993 (class 2606 OID 46741)
-- Name: series_comprobantes series_comprobantes_pkey; Type: CONSTRAINT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.series_comprobantes
    ADD CONSTRAINT series_comprobantes_pkey PRIMARY KEY (id_serie);


--
-- TOC entry 3996 (class 2606 OID 46743)
-- Name: tablas_generales tablas_generales_codigo_key; Type: CONSTRAINT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.tablas_generales
    ADD CONSTRAINT tablas_generales_codigo_key UNIQUE (codigo);


--
-- TOC entry 4002 (class 2606 OID 46745)
-- Name: tablas_generales_detalle tablas_generales_detalle_pkey; Type: CONSTRAINT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.tablas_generales_detalle
    ADD CONSTRAINT tablas_generales_detalle_pkey PRIMARY KEY (id_detalle);


--
-- TOC entry 3998 (class 2606 OID 46747)
-- Name: tablas_generales tablas_generales_pkey; Type: CONSTRAINT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.tablas_generales
    ADD CONSTRAINT tablas_generales_pkey PRIMARY KEY (id_tabla);


--
-- TOC entry 4139 (class 2606 OID 47706)
-- Name: tipo_afectacion_igv tipo_afectacion_igv_codigo_key; Type: CONSTRAINT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.tipo_afectacion_igv
    ADD CONSTRAINT tipo_afectacion_igv_codigo_key UNIQUE (codigo);


--
-- TOC entry 4141 (class 2606 OID 47704)
-- Name: tipo_afectacion_igv tipo_afectacion_igv_pkey; Type: CONSTRAINT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.tipo_afectacion_igv
    ADD CONSTRAINT tipo_afectacion_igv_pkey PRIMARY KEY (id_afectacion);


--
-- TOC entry 4103 (class 2606 OID 47226)
-- Name: tipo_comprobante tipo_comprobante_codigo_key; Type: CONSTRAINT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.tipo_comprobante
    ADD CONSTRAINT tipo_comprobante_codigo_key UNIQUE (codigo);


--
-- TOC entry 4105 (class 2606 OID 47224)
-- Name: tipo_comprobante tipo_comprobante_pkey; Type: CONSTRAINT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.tipo_comprobante
    ADD CONSTRAINT tipo_comprobante_pkey PRIMARY KEY (id_tipo_comprobante);


--
-- TOC entry 4099 (class 2606 OID 47210)
-- Name: tipo_documento tipo_documento_codigo_key; Type: CONSTRAINT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.tipo_documento
    ADD CONSTRAINT tipo_documento_codigo_key UNIQUE (codigo);


--
-- TOC entry 4101 (class 2606 OID 47208)
-- Name: tipo_documento tipo_documento_pkey; Type: CONSTRAINT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.tipo_documento
    ADD CONSTRAINT tipo_documento_pkey PRIMARY KEY (id_regla);


--
-- TOC entry 4107 (class 2606 OID 47239)
-- Name: tipo_operacion_sunat tipo_operacion_sunat_codigo_key; Type: CONSTRAINT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.tipo_operacion_sunat
    ADD CONSTRAINT tipo_operacion_sunat_codigo_key UNIQUE (codigo);


--
-- TOC entry 4109 (class 2606 OID 47237)
-- Name: tipo_operacion_sunat tipo_operacion_sunat_pkey; Type: CONSTRAINT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.tipo_operacion_sunat
    ADD CONSTRAINT tipo_operacion_sunat_pkey PRIMARY KEY (id_tipo_operacion);


--
-- TOC entry 4004 (class 2606 OID 46749)
-- Name: tablas_generales_detalle uk_tabla_codigo; Type: CONSTRAINT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.tablas_generales_detalle
    ADD CONSTRAINT uk_tabla_codigo UNIQUE (id_tabla, codigo);


--
-- TOC entry 4006 (class 2606 OID 46751)
-- Name: asientos_contables asientos_contables_pkey; Type: CONSTRAINT; Schema: contabilidad; Owner: -
--

ALTER TABLE ONLY contabilidad.asientos_contables
    ADD CONSTRAINT asientos_contables_pkey PRIMARY KEY (id_asiento);


--
-- TOC entry 4008 (class 2606 OID 46753)
-- Name: centros_costo centros_costo_codigo_key; Type: CONSTRAINT; Schema: contabilidad; Owner: -
--

ALTER TABLE ONLY contabilidad.centros_costo
    ADD CONSTRAINT centros_costo_codigo_key UNIQUE (codigo);


--
-- TOC entry 4010 (class 2606 OID 46755)
-- Name: centros_costo centros_costo_pkey; Type: CONSTRAINT; Schema: contabilidad; Owner: -
--

ALTER TABLE ONLY contabilidad.centros_costo
    ADD CONSTRAINT centros_costo_pkey PRIMARY KEY (id_centro_costo);


--
-- TOC entry 4012 (class 2606 OID 46757)
-- Name: detalle_asiento detalle_asiento_pkey; Type: CONSTRAINT; Schema: contabilidad; Owner: -
--

ALTER TABLE ONLY contabilidad.detalle_asiento
    ADD CONSTRAINT detalle_asiento_pkey PRIMARY KEY (id_detalle_asiento);


--
-- TOC entry 4014 (class 2606 OID 46759)
-- Name: plan_cuentas plan_cuentas_codigo_cuenta_key; Type: CONSTRAINT; Schema: contabilidad; Owner: -
--

ALTER TABLE ONLY contabilidad.plan_cuentas
    ADD CONSTRAINT plan_cuentas_codigo_cuenta_key UNIQUE (codigo_cuenta);


--
-- TOC entry 4016 (class 2606 OID 46761)
-- Name: plan_cuentas plan_cuentas_pkey; Type: CONSTRAINT; Schema: contabilidad; Owner: -
--

ALTER TABLE ONLY contabilidad.plan_cuentas
    ADD CONSTRAINT plan_cuentas_pkey PRIMARY KEY (id_cuenta);


--
-- TOC entry 4018 (class 2606 OID 46763)
-- Name: areas areas_pkey; Type: CONSTRAINT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.areas
    ADD CONSTRAINT areas_pkey PRIMARY KEY (id_area);


--
-- TOC entry 4020 (class 2606 OID 46765)
-- Name: auditoria_accesos auditoria_accesos_pkey; Type: CONSTRAINT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.auditoria_accesos
    ADD CONSTRAINT auditoria_accesos_pkey PRIMARY KEY (id_auditoria);


--
-- TOC entry 4022 (class 2606 OID 46767)
-- Name: cargos cargos_pkey; Type: CONSTRAINT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.cargos
    ADD CONSTRAINT cargos_pkey PRIMARY KEY (id_cargo);


--
-- TOC entry 4026 (class 2606 OID 46769)
-- Name: menus menus_codigo_key; Type: CONSTRAINT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.menus
    ADD CONSTRAINT menus_codigo_key UNIQUE (codigo);


--
-- TOC entry 4028 (class 2606 OID 46771)
-- Name: menus menus_pkey; Type: CONSTRAINT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.menus
    ADD CONSTRAINT menus_pkey PRIMARY KEY (id_menu);


--
-- TOC entry 4030 (class 2606 OID 46773)
-- Name: permisos permisos_codigo_permiso_key; Type: CONSTRAINT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.permisos
    ADD CONSTRAINT permisos_codigo_permiso_key UNIQUE (codigo_permiso);


--
-- TOC entry 4032 (class 2606 OID 46775)
-- Name: permisos permisos_pkey; Type: CONSTRAINT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.permisos
    ADD CONSTRAINT permisos_pkey PRIMARY KEY (id_permiso);


--
-- TOC entry 4040 (class 2606 OID 46777)
-- Name: roles_menus roles_menus_id_rol_id_menu_key; Type: CONSTRAINT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.roles_menus
    ADD CONSTRAINT roles_menus_id_rol_id_menu_key UNIQUE (id_rol, id_menu);


--
-- TOC entry 4044 (class 2606 OID 46779)
-- Name: roles_menus_permisos roles_menus_permisos_id_rol_menu_id_tipo_permiso_key; Type: CONSTRAINT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.roles_menus_permisos
    ADD CONSTRAINT roles_menus_permisos_id_rol_menu_id_tipo_permiso_key UNIQUE (id_rol_menu, id_tipo_permiso);


--
-- TOC entry 4046 (class 2606 OID 46781)
-- Name: roles_menus_permisos roles_menus_permisos_pkey; Type: CONSTRAINT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.roles_menus_permisos
    ADD CONSTRAINT roles_menus_permisos_pkey PRIMARY KEY (id_rol_menu_permiso);


--
-- TOC entry 4042 (class 2606 OID 46783)
-- Name: roles_menus roles_menus_pkey; Type: CONSTRAINT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.roles_menus
    ADD CONSTRAINT roles_menus_pkey PRIMARY KEY (id_rol_menu);


--
-- TOC entry 4034 (class 2606 OID 46785)
-- Name: roles roles_nombre_rol_key; Type: CONSTRAINT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.roles
    ADD CONSTRAINT roles_nombre_rol_key UNIQUE (nombre_rol);


--
-- TOC entry 4048 (class 2606 OID 46787)
-- Name: roles_permisos roles_permisos_pkey; Type: CONSTRAINT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.roles_permisos
    ADD CONSTRAINT roles_permisos_pkey PRIMARY KEY (id_rol, id_permiso);


--
-- TOC entry 4036 (class 2606 OID 46789)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id_rol);


--
-- TOC entry 4051 (class 2606 OID 46791)
-- Name: tipos_permiso tipos_permiso_codigo_key; Type: CONSTRAINT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.tipos_permiso
    ADD CONSTRAINT tipos_permiso_codigo_key UNIQUE (codigo);


--
-- TOC entry 4053 (class 2606 OID 46793)
-- Name: tipos_permiso tipos_permiso_pkey; Type: CONSTRAINT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.tipos_permiso
    ADD CONSTRAINT tipos_permiso_pkey PRIMARY KEY (id_tipo_permiso);


--
-- TOC entry 4055 (class 2606 OID 46795)
-- Name: trabajadores trabajadores_id_usuario_key; Type: CONSTRAINT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.trabajadores
    ADD CONSTRAINT trabajadores_id_usuario_key UNIQUE (id_usuario);


--
-- TOC entry 4057 (class 2606 OID 46797)
-- Name: trabajadores trabajadores_numero_documento_key; Type: CONSTRAINT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.trabajadores
    ADD CONSTRAINT trabajadores_numero_documento_key UNIQUE (numero_documento);


--
-- TOC entry 4059 (class 2606 OID 46799)
-- Name: trabajadores trabajadores_pkey; Type: CONSTRAINT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.trabajadores
    ADD CONSTRAINT trabajadores_pkey PRIMARY KEY (id_trabajador);


--
-- TOC entry 4061 (class 2606 OID 46801)
-- Name: usuarios usuarios_email_key; Type: CONSTRAINT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.usuarios
    ADD CONSTRAINT usuarios_email_key UNIQUE (email);


--
-- TOC entry 4063 (class 2606 OID 46803)
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id_usuario);


--
-- TOC entry 4069 (class 2606 OID 46805)
-- Name: usuarios_roles usuarios_roles_id_usuario_id_rol_key; Type: CONSTRAINT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.usuarios_roles
    ADD CONSTRAINT usuarios_roles_id_usuario_id_rol_key UNIQUE (id_usuario, id_rol);


--
-- TOC entry 4071 (class 2606 OID 46807)
-- Name: usuarios_roles usuarios_roles_pkey; Type: CONSTRAINT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.usuarios_roles
    ADD CONSTRAINT usuarios_roles_pkey PRIMARY KEY (id_usuario_rol);


--
-- TOC entry 4065 (class 2606 OID 46809)
-- Name: usuarios usuarios_username_key; Type: CONSTRAINT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.usuarios
    ADD CONSTRAINT usuarios_username_key UNIQUE (username);


--
-- TOC entry 4073 (class 2606 OID 46811)
-- Name: almacenes almacenes_pkey; Type: CONSTRAINT; Schema: inventario; Owner: -
--

ALTER TABLE ONLY inventario.almacenes
    ADD CONSTRAINT almacenes_pkey PRIMARY KEY (id_almacen);


--
-- TOC entry 4166 (class 2606 OID 66596)
-- Name: inv_kardex_lote inv_kardex_lote_pkey; Type: CONSTRAINT; Schema: inventario; Owner: -
--

ALTER TABLE ONLY inventario.inv_kardex_lote
    ADD CONSTRAINT inv_kardex_lote_pkey PRIMARY KEY (id);


--
-- TOC entry 4168 (class 2606 OID 66609)
-- Name: inv_kardex_movimiento inv_kardex_movimiento_pkey; Type: CONSTRAINT; Schema: inventario; Owner: -
--

ALTER TABLE ONLY inventario.inv_kardex_movimiento
    ADD CONSTRAINT inv_kardex_movimiento_pkey PRIMARY KEY (id);


--
-- TOC entry 4174 (class 2606 OID 66616)
-- Name: inv_kardex_periodo_control inv_kardex_periodo_control_pkey; Type: CONSTRAINT; Schema: inventario; Owner: -
--

ALTER TABLE ONLY inventario.inv_kardex_periodo_control
    ADD CONSTRAINT inv_kardex_periodo_control_pkey PRIMARY KEY (periodo);


--
-- TOC entry 4176 (class 2606 OID 66624)
-- Name: inv_kardex_recalculo_log inv_kardex_recalculo_log_pkey; Type: CONSTRAINT; Schema: inventario; Owner: -
--

ALTER TABLE ONLY inventario.inv_kardex_recalculo_log
    ADD CONSTRAINT inv_kardex_recalculo_log_pkey PRIMARY KEY (id);


--
-- TOC entry 4075 (class 2606 OID 46813)
-- Name: movimientos_inventario movimientos_inventario_pkey; Type: CONSTRAINT; Schema: inventario; Owner: -
--

ALTER TABLE ONLY inventario.movimientos_inventario
    ADD CONSTRAINT movimientos_inventario_pkey PRIMARY KEY (id_movimiento);


--
-- TOC entry 4077 (class 2606 OID 46815)
-- Name: stock stock_pkey; Type: CONSTRAINT; Schema: inventario; Owner: -
--

ALTER TABLE ONLY inventario.stock
    ADD CONSTRAINT stock_pkey PRIMARY KEY (id_stock);


--
-- TOC entry 4135 (class 2606 OID 47590)
-- Name: traslados_detalle traslados_detalle_pkey; Type: CONSTRAINT; Schema: inventario; Owner: -
--

ALTER TABLE ONLY inventario.traslados_detalle
    ADD CONSTRAINT traslados_detalle_pkey PRIMARY KEY (id_detalle_traslado);


--
-- TOC entry 4137 (class 2606 OID 47604)
-- Name: traslados_incidencias traslados_incidencias_pkey; Type: CONSTRAINT; Schema: inventario; Owner: -
--

ALTER TABLE ONLY inventario.traslados_incidencias
    ADD CONSTRAINT traslados_incidencias_pkey PRIMARY KEY (id_incidencia);


--
-- TOC entry 4131 (class 2606 OID 47579)
-- Name: traslados traslados_numero_traslado_key; Type: CONSTRAINT; Schema: inventario; Owner: -
--

ALTER TABLE ONLY inventario.traslados
    ADD CONSTRAINT traslados_numero_traslado_key UNIQUE (numero_traslado);


--
-- TOC entry 4133 (class 2606 OID 47577)
-- Name: traslados traslados_pkey; Type: CONSTRAINT; Schema: inventario; Owner: -
--

ALTER TABLE ONLY inventario.traslados
    ADD CONSTRAINT traslados_pkey PRIMARY KEY (id_traslado);


--
-- TOC entry 4079 (class 2606 OID 46817)
-- Name: stock uq_stock_producto_almacen; Type: CONSTRAINT; Schema: inventario; Owner: -
--

ALTER TABLE ONLY inventario.stock
    ADD CONSTRAINT uq_stock_producto_almacen UNIQUE (id_producto, id_variante, id_almacen);


--
-- TOC entry 3939 (class 2606 OID 17004)
-- Name: __EFMigrationsHistory PK___EFMigrationsHistory; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."__EFMigrationsHistory"
    ADD CONSTRAINT "PK___EFMigrationsHistory" PRIMARY KEY (migration_id);


--
-- TOC entry 4154 (class 2606 OID 62625)
-- Name: categorias PK_categorias; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorias
    ADD CONSTRAINT "PK_categorias" PRIMARY KEY ("Id");


--
-- TOC entry 4156 (class 2606 OID 62638)
-- Name: marcas PK_marcas; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.marcas
    ADD CONSTRAINT "PK_marcas" PRIMARY KEY ("Id");


--
-- TOC entry 4164 (class 2606 OID 62654)
-- Name: productos PK_productos; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT "PK_productos" PRIMARY KEY ("Id");


--
-- TOC entry 4158 (class 2606 OID 62646)
-- Name: unidades_medida PK_unidades_medida; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unidades_medida
    ADD CONSTRAINT "PK_unidades_medida" PRIMARY KEY ("Id");


--
-- TOC entry 4081 (class 2606 OID 46819)
-- Name: cajas cajas_pkey; Type: CONSTRAINT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.cajas
    ADD CONSTRAINT cajas_pkey PRIMARY KEY (id_caja);


--
-- TOC entry 4083 (class 2606 OID 46821)
-- Name: cotizaciones cotizaciones_pkey; Type: CONSTRAINT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.cotizaciones
    ADD CONSTRAINT cotizaciones_pkey PRIMARY KEY (id_cotizacion);


--
-- TOC entry 4085 (class 2606 OID 46823)
-- Name: detalle_cotizacion detalle_cotizacion_pkey; Type: CONSTRAINT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.detalle_cotizacion
    ADD CONSTRAINT detalle_cotizacion_pkey PRIMARY KEY (id_detalle_cot);


--
-- TOC entry 4127 (class 2606 OID 47548)
-- Name: detalle_notas detalle_notas_pkey; Type: CONSTRAINT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.detalle_notas
    ADD CONSTRAINT detalle_notas_pkey PRIMARY KEY (id_detalle_nota);


--
-- TOC entry 4087 (class 2606 OID 46825)
-- Name: detalle_venta detalle_venta_pkey; Type: CONSTRAINT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.detalle_venta
    ADD CONSTRAINT detalle_venta_pkey PRIMARY KEY (id_detalle_venta);


--
-- TOC entry 4089 (class 2606 OID 46827)
-- Name: metodos_pago metodos_pago_codigo_key; Type: CONSTRAINT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.metodos_pago
    ADD CONSTRAINT metodos_pago_codigo_key UNIQUE (codigo);


--
-- TOC entry 4091 (class 2606 OID 46829)
-- Name: metodos_pago metodos_pago_pkey; Type: CONSTRAINT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.metodos_pago
    ADD CONSTRAINT metodos_pago_pkey PRIMARY KEY (id_metodo_pago);


--
-- TOC entry 4093 (class 2606 OID 46831)
-- Name: movimientos_caja movimientos_caja_pkey; Type: CONSTRAINT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.movimientos_caja
    ADD CONSTRAINT movimientos_caja_pkey PRIMARY KEY (id_movimiento_caja);


--
-- TOC entry 4115 (class 2606 OID 47270)
-- Name: notas notas_pkey; Type: CONSTRAINT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.notas
    ADD CONSTRAINT notas_pkey PRIMARY KEY (id_nota);


--
-- TOC entry 4095 (class 2606 OID 46833)
-- Name: pagos pagos_pkey; Type: CONSTRAINT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.pagos
    ADD CONSTRAINT pagos_pkey PRIMARY KEY (id_pago);


--
-- TOC entry 4097 (class 2606 OID 46835)
-- Name: ventas ventas_pkey; Type: CONSTRAINT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.ventas
    ADD CONSTRAINT ventas_pkey PRIMARY KEY (id_venta);


--
-- TOC entry 3964 (class 1259 OID 66826)
-- Name: idx_clientes_razon_social; Type: INDEX; Schema: clientes; Owner: -
--

CREATE INDEX idx_clientes_razon_social ON clientes.clientes USING gin (to_tsvector('spanish'::regconfig, (razon_social)::text));


--
-- TOC entry 3965 (class 1259 OID 66825)
-- Name: uq_clientes_numero_documento; Type: INDEX; Schema: clientes; Owner: -
--

CREATE UNIQUE INDEX uq_clientes_numero_documento ON clientes.clientes USING btree (numero_documento) WHERE (activado = true);


--
-- TOC entry 3978 (class 1259 OID 66866)
-- Name: idx_proveedores_razon_social; Type: INDEX; Schema: compras; Owner: -
--

CREATE INDEX idx_proveedores_razon_social ON compras.proveedores USING gin (to_tsvector('spanish'::regconfig, (razon_social)::text));


--
-- TOC entry 3983 (class 1259 OID 66865)
-- Name: uq_proveedores_numero_documento; Type: INDEX; Schema: compras; Owner: -
--

CREATE UNIQUE INDEX uq_proveedores_numero_documento ON compras.proveedores USING btree (numero_documento) WHERE (activado = true);


--
-- TOC entry 3994 (class 1259 OID 46836)
-- Name: idx_tablas_generales_codigo; Type: INDEX; Schema: configuracion; Owner: -
--

CREATE INDEX idx_tablas_generales_codigo ON configuracion.tablas_generales USING btree (codigo);


--
-- TOC entry 3999 (class 1259 OID 46837)
-- Name: idx_tablas_generales_detalle_codigo; Type: INDEX; Schema: configuracion; Owner: -
--

CREATE INDEX idx_tablas_generales_detalle_codigo ON configuracion.tablas_generales_detalle USING btree (codigo);


--
-- TOC entry 4000 (class 1259 OID 46838)
-- Name: idx_tablas_generales_detalle_tabla; Type: INDEX; Schema: configuracion; Owner: -
--

CREATE INDEX idx_tablas_generales_detalle_tabla ON configuracion.tablas_generales_detalle USING btree (id_tabla);


--
-- TOC entry 4185 (class 1259 OID 66877)
-- Name: ix_ubigeos_parent_id; Type: INDEX; Schema: configuracion; Owner: -
--

CREATE INDEX ix_ubigeos_parent_id ON configuracion.ubigeos USING btree (parent_id);


--
-- TOC entry 4023 (class 1259 OID 46839)
-- Name: idx_menus_codigo; Type: INDEX; Schema: identidad; Owner: -
--

CREATE INDEX idx_menus_codigo ON identidad.menus USING btree (codigo);


--
-- TOC entry 4024 (class 1259 OID 46840)
-- Name: idx_menus_menu_padre; Type: INDEX; Schema: identidad; Owner: -
--

CREATE INDEX idx_menus_menu_padre ON identidad.menus USING btree (id_menu_padre);


--
-- TOC entry 4037 (class 1259 OID 46841)
-- Name: idx_roles_menus_menu; Type: INDEX; Schema: identidad; Owner: -
--

CREATE INDEX idx_roles_menus_menu ON identidad.roles_menus USING btree (id_menu);


--
-- TOC entry 4038 (class 1259 OID 46842)
-- Name: idx_roles_menus_rol; Type: INDEX; Schema: identidad; Owner: -
--

CREATE INDEX idx_roles_menus_rol ON identidad.roles_menus USING btree (id_rol);


--
-- TOC entry 4049 (class 1259 OID 46843)
-- Name: idx_tipos_permiso_codigo; Type: INDEX; Schema: identidad; Owner: -
--

CREATE INDEX idx_tipos_permiso_codigo ON identidad.tipos_permiso USING btree (codigo);


--
-- TOC entry 4066 (class 1259 OID 46844)
-- Name: idx_usuarios_roles_rol; Type: INDEX; Schema: identidad; Owner: -
--

CREATE INDEX idx_usuarios_roles_rol ON identidad.usuarios_roles USING btree (id_rol);


--
-- TOC entry 4067 (class 1259 OID 46845)
-- Name: idx_usuarios_roles_usuario; Type: INDEX; Schema: identidad; Owner: -
--

CREATE INDEX idx_usuarios_roles_usuario ON identidad.usuarios_roles USING btree (id_usuario);


--
-- TOC entry 4169 (class 1259 OID 66628)
-- Name: ix_inv_kardex_movimiento_doc; Type: INDEX; Schema: inventario; Owner: -
--

CREATE INDEX ix_inv_kardex_movimiento_doc ON inventario.inv_kardex_movimiento USING btree (tipo_documento, serie_documento, numero_documento);


--
-- TOC entry 4170 (class 1259 OID 66625)
-- Name: ix_inv_kardex_movimiento_fecha_hora; Type: INDEX; Schema: inventario; Owner: -
--

CREATE INDEX ix_inv_kardex_movimiento_fecha_hora ON inventario.inv_kardex_movimiento USING btree (fecha_movimiento, hora_movimiento);


--
-- TOC entry 4171 (class 1259 OID 66626)
-- Name: ix_inv_kardex_movimiento_periodo_prod; Type: INDEX; Schema: inventario; Owner: -
--

CREATE INDEX ix_inv_kardex_movimiento_periodo_prod ON inventario.inv_kardex_movimiento USING btree (periodo, almacen_id, producto_id);


--
-- TOC entry 4172 (class 1259 OID 66627)
-- Name: ix_inv_kardex_movimiento_ref; Type: INDEX; Schema: inventario; Owner: -
--

CREATE INDEX ix_inv_kardex_movimiento_ref ON inventario.inv_kardex_movimiento USING btree (referencia_id, referencia_tipo);


--
-- TOC entry 4152 (class 1259 OID 62670)
-- Name: IX_categorias_IdCategoriaPadre; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IX_categorias_IdCategoriaPadre" ON public.categorias USING btree ("IdCategoriaPadre");


--
-- TOC entry 4159 (class 1259 OID 62671)
-- Name: IX_productos_CodigoProducto; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "IX_productos_CodigoProducto" ON public.productos USING btree ("CodigoProducto");


--
-- TOC entry 4160 (class 1259 OID 62672)
-- Name: IX_productos_IdCategoria; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IX_productos_IdCategoria" ON public.productos USING btree ("IdCategoria");


--
-- TOC entry 4161 (class 1259 OID 62673)
-- Name: IX_productos_IdMarca; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IX_productos_IdMarca" ON public.productos USING btree ("IdMarca");


--
-- TOC entry 4162 (class 1259 OID 62674)
-- Name: IX_productos_IdUnidadMedida; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IX_productos_IdUnidadMedida" ON public.productos USING btree ("IdUnidadMedida");


--
-- TOC entry 4275 (class 2620 OID 46846)
-- Name: productos tr_productos_update; Type: TRIGGER; Schema: catalogo; Owner: -
--

CREATE TRIGGER tr_productos_update BEFORE UPDATE ON catalogo.productos FOR EACH ROW EXECUTE FUNCTION public.update_fecha_modificacion_column();


--
-- TOC entry 4276 (class 2620 OID 46847)
-- Name: clientes tr_clientes_update; Type: TRIGGER; Schema: clientes; Owner: -
--

CREATE TRIGGER tr_clientes_update BEFORE UPDATE ON clientes.clientes FOR EACH ROW EXECUTE FUNCTION public.update_fecha_modificacion_column();


--
-- TOC entry 4277 (class 2620 OID 62709)
-- Name: compras tr_compras_update; Type: TRIGGER; Schema: compras; Owner: -
--

CREATE TRIGGER tr_compras_update BEFORE UPDATE ON compras.compras FOR EACH ROW EXECUTE FUNCTION public.update_fecha_modificacion_column();


--
-- TOC entry 4278 (class 2620 OID 62710)
-- Name: ordenes_compra tr_ordenes_compra_update; Type: TRIGGER; Schema: compras; Owner: -
--

CREATE TRIGGER tr_ordenes_compra_update BEFORE UPDATE ON compras.ordenes_compra FOR EACH ROW EXECUTE FUNCTION public.update_fecha_modificacion_column();


--
-- TOC entry 4279 (class 2620 OID 46848)
-- Name: configuraciones tr_config_update; Type: TRIGGER; Schema: configuracion; Owner: -
--

CREATE TRIGGER tr_config_update BEFORE UPDATE ON configuracion.configuraciones FOR EACH ROW EXECUTE FUNCTION public.update_fecha_modificacion_column();


--
-- TOC entry 4280 (class 2620 OID 46849)
-- Name: empresa tr_empresa_update; Type: TRIGGER; Schema: configuracion; Owner: -
--

CREATE TRIGGER tr_empresa_update BEFORE UPDATE ON configuracion.empresa FOR EACH ROW EXECUTE FUNCTION public.update_fecha_modificacion_column();


--
-- TOC entry 4283 (class 2620 OID 62711)
-- Name: tipo_documento tr_tipo_documento_update; Type: TRIGGER; Schema: configuracion; Owner: -
--

CREATE TRIGGER tr_tipo_documento_update BEFORE UPDATE ON configuracion.tipo_documento FOR EACH ROW EXECUTE FUNCTION public.update_fecha_modificacion_column();


--
-- TOC entry 4281 (class 2620 OID 46850)
-- Name: usuarios tr_usuarios_update; Type: TRIGGER; Schema: identidad; Owner: -
--

CREATE TRIGGER tr_usuarios_update BEFORE UPDATE ON identidad.usuarios FOR EACH ROW EXECUTE FUNCTION public.update_fecha_modificacion_column();


--
-- TOC entry 4282 (class 2620 OID 46851)
-- Name: ventas tr_ventas_update; Type: TRIGGER; Schema: ventas; Owner: -
--

CREATE TRIGGER tr_ventas_update BEFORE UPDATE ON ventas.ventas FOR EACH ROW EXECUTE FUNCTION public.update_fecha_modificacion_column();


--
-- TOC entry 4188 (class 2606 OID 46852)
-- Name: categorias fk_categoria_padre; Type: FK CONSTRAINT; Schema: catalogo; Owner: -
--

ALTER TABLE ONLY catalogo.categorias
    ADD CONSTRAINT fk_categoria_padre FOREIGN KEY (id_categoria_padre) REFERENCES catalogo.categorias(id_categoria);


--
-- TOC entry 4189 (class 2606 OID 46857)
-- Name: imagenes_producto fk_imagenes_producto; Type: FK CONSTRAINT; Schema: catalogo; Owner: -
--

ALTER TABLE ONLY catalogo.imagenes_producto
    ADD CONSTRAINT fk_imagenes_producto FOREIGN KEY (id_producto) REFERENCES catalogo.productos(id_producto) ON DELETE CASCADE;


--
-- TOC entry 4190 (class 2606 OID 46862)
-- Name: productos fk_producto_tipo; Type: FK CONSTRAINT; Schema: catalogo; Owner: -
--

ALTER TABLE ONLY catalogo.productos
    ADD CONSTRAINT fk_producto_tipo FOREIGN KEY (id_tipo_producto) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 4191 (class 2606 OID 46867)
-- Name: productos fk_productos_categoria; Type: FK CONSTRAINT; Schema: catalogo; Owner: -
--

ALTER TABLE ONLY catalogo.productos
    ADD CONSTRAINT fk_productos_categoria FOREIGN KEY (id_categoria) REFERENCES catalogo.categorias(id_categoria);


--
-- TOC entry 4192 (class 2606 OID 46872)
-- Name: productos fk_productos_marca; Type: FK CONSTRAINT; Schema: catalogo; Owner: -
--

ALTER TABLE ONLY catalogo.productos
    ADD CONSTRAINT fk_productos_marca FOREIGN KEY (id_marca) REFERENCES catalogo.marcas(id_marca);


--
-- TOC entry 4193 (class 2606 OID 46877)
-- Name: productos fk_productos_unidad; Type: FK CONSTRAINT; Schema: catalogo; Owner: -
--

ALTER TABLE ONLY catalogo.productos
    ADD CONSTRAINT fk_productos_unidad FOREIGN KEY (id_unidad) REFERENCES catalogo.unidades_medida(id_unidad);


--
-- TOC entry 4194 (class 2606 OID 46882)
-- Name: variantes_producto fk_variantes_producto; Type: FK CONSTRAINT; Schema: catalogo; Owner: -
--

ALTER TABLE ONLY catalogo.variantes_producto
    ADD CONSTRAINT fk_variantes_producto FOREIGN KEY (id_producto) REFERENCES catalogo.productos(id_producto) ON DELETE CASCADE;


--
-- TOC entry 4195 (class 2606 OID 46887)
-- Name: clientes fk_cliente_lista_precio; Type: FK CONSTRAINT; Schema: clientes; Owner: -
--

ALTER TABLE ONLY clientes.clientes
    ADD CONSTRAINT fk_cliente_lista_precio FOREIGN KEY (id_lista_precio_asignada) REFERENCES catalogo.listas_precios(id_lista_precio);


--
-- TOC entry 4196 (class 2606 OID 46892)
-- Name: clientes fk_cliente_tipo_cliente; Type: FK CONSTRAINT; Schema: clientes; Owner: -
--

ALTER TABLE ONLY clientes.clientes
    ADD CONSTRAINT fk_cliente_tipo_cliente FOREIGN KEY (id_tipo_cliente) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 4197 (class 2606 OID 46897)
-- Name: clientes fk_cliente_tipo_documento; Type: FK CONSTRAINT; Schema: clientes; Owner: -
--

ALTER TABLE ONLY clientes.clientes
    ADD CONSTRAINT fk_cliente_tipo_documento FOREIGN KEY (id_tipo_documento) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 4198 (class 2606 OID 46902)
-- Name: contactos_cliente fk_contacto_cliente; Type: FK CONSTRAINT; Schema: clientes; Owner: -
--

ALTER TABLE ONLY clientes.contactos_cliente
    ADD CONSTRAINT fk_contacto_cliente FOREIGN KEY (id_cliente) REFERENCES clientes.clientes(id_cliente) ON DELETE CASCADE;


--
-- TOC entry 4199 (class 2606 OID 46907)
-- Name: compras fk_compra_almacen; Type: FK CONSTRAINT; Schema: compras; Owner: -
--

ALTER TABLE ONLY compras.compras
    ADD CONSTRAINT fk_compra_almacen FOREIGN KEY (id_almacen) REFERENCES inventario.almacenes(id_almacen);


--
-- TOC entry 4200 (class 2606 OID 46912)
-- Name: compras fk_compra_estado_pago; Type: FK CONSTRAINT; Schema: compras; Owner: -
--

ALTER TABLE ONLY compras.compras
    ADD CONSTRAINT fk_compra_estado_pago FOREIGN KEY (id_estado_pago) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 4201 (class 2606 OID 46917)
-- Name: compras fk_compra_proveedor; Type: FK CONSTRAINT; Schema: compras; Owner: -
--

ALTER TABLE ONLY compras.compras
    ADD CONSTRAINT fk_compra_proveedor FOREIGN KEY (id_proveedor) REFERENCES compras.proveedores(id_proveedor);


--
-- TOC entry 4202 (class 2606 OID 46922)
-- Name: compras fk_compra_tipo_comprobante; Type: FK CONSTRAINT; Schema: compras; Owner: -
--

ALTER TABLE ONLY compras.compras
    ADD CONSTRAINT fk_compra_tipo_comprobante FOREIGN KEY (id_tipo_comprobante) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 4203 (class 2606 OID 46927)
-- Name: detalle_compra fk_dc_compra; Type: FK CONSTRAINT; Schema: compras; Owner: -
--

ALTER TABLE ONLY compras.detalle_compra
    ADD CONSTRAINT fk_dc_compra FOREIGN KEY (id_compra) REFERENCES compras.compras(id_compra) ON DELETE CASCADE;


--
-- TOC entry 4204 (class 2606 OID 46932)
-- Name: detalle_compra fk_dc_producto; Type: FK CONSTRAINT; Schema: compras; Owner: -
--

ALTER TABLE ONLY compras.detalle_compra
    ADD CONSTRAINT fk_dc_producto FOREIGN KEY (id_producto) REFERENCES catalogo.productos(id_producto);


--
-- TOC entry 4205 (class 2606 OID 62971)
-- Name: detalle_compra fk_detalle_compra_afectacion_igv; Type: FK CONSTRAINT; Schema: compras; Owner: -
--

ALTER TABLE ONLY compras.detalle_compra
    ADD CONSTRAINT fk_detalle_compra_afectacion_igv FOREIGN KEY (afectacion_igv) REFERENCES configuracion.tipo_afectacion_igv(codigo);


--
-- TOC entry 4267 (class 2606 OID 47561)
-- Name: detalle_notas fk_detalle_notas_compras_cabecera; Type: FK CONSTRAINT; Schema: compras; Owner: -
--

ALTER TABLE ONLY compras.detalle_notas
    ADD CONSTRAINT fk_detalle_notas_compras_cabecera FOREIGN KEY (id_nota) REFERENCES compras.notas(id_nota) ON DELETE CASCADE;


--
-- TOC entry 4206 (class 2606 OID 46937)
-- Name: detalle_orden_compra fk_doc_orden; Type: FK CONSTRAINT; Schema: compras; Owner: -
--

ALTER TABLE ONLY compras.detalle_orden_compra
    ADD CONSTRAINT fk_doc_orden FOREIGN KEY (id_orden_compra) REFERENCES compras.ordenes_compra(id_orden_compra) ON DELETE CASCADE;


--
-- TOC entry 4207 (class 2606 OID 46942)
-- Name: detalle_orden_compra fk_doc_producto; Type: FK CONSTRAINT; Schema: compras; Owner: -
--

ALTER TABLE ONLY compras.detalle_orden_compra
    ADD CONSTRAINT fk_doc_producto FOREIGN KEY (id_producto) REFERENCES catalogo.productos(id_producto);


--
-- TOC entry 4208 (class 2606 OID 46947)
-- Name: ordenes_compra fk_oc_almacen; Type: FK CONSTRAINT; Schema: compras; Owner: -
--

ALTER TABLE ONLY compras.ordenes_compra
    ADD CONSTRAINT fk_oc_almacen FOREIGN KEY (id_almacen_destino) REFERENCES inventario.almacenes(id_almacen);


--
-- TOC entry 4209 (class 2606 OID 46952)
-- Name: ordenes_compra fk_oc_proveedor; Type: FK CONSTRAINT; Schema: compras; Owner: -
--

ALTER TABLE ONLY compras.ordenes_compra
    ADD CONSTRAINT fk_oc_proveedor FOREIGN KEY (id_proveedor) REFERENCES compras.proveedores(id_proveedor);


--
-- TOC entry 4210 (class 2606 OID 46957)
-- Name: ordenes_compra fk_orden_compra_estado; Type: FK CONSTRAINT; Schema: compras; Owner: -
--

ALTER TABLE ONLY compras.ordenes_compra
    ADD CONSTRAINT fk_orden_compra_estado FOREIGN KEY (id_estado) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 4211 (class 2606 OID 62712)
-- Name: proveedores fk_proveedor_tipo_documento; Type: FK CONSTRAINT; Schema: compras; Owner: -
--

ALTER TABLE ONLY compras.proveedores
    ADD CONSTRAINT fk_proveedor_tipo_documento FOREIGN KEY (id_tipo_documento) REFERENCES configuracion.tipo_documento(id_regla);


--
-- TOC entry 4259 (class 2606 OID 47285)
-- Name: matriz_regla_sunat fk_matriz_tipo_comp; Type: FK CONSTRAINT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.matriz_regla_sunat
    ADD CONSTRAINT fk_matriz_tipo_comp FOREIGN KEY (id_tipo_comprobante) REFERENCES configuracion.tipo_comprobante(id_tipo_comprobante);


--
-- TOC entry 4260 (class 2606 OID 47290)
-- Name: matriz_regla_sunat fk_matriz_tipo_oper; Type: FK CONSTRAINT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.matriz_regla_sunat
    ADD CONSTRAINT fk_matriz_tipo_oper FOREIGN KEY (id_tipo_operacion) REFERENCES configuracion.tipo_operacion_sunat(id_tipo_operacion);


--
-- TOC entry 4262 (class 2606 OID 47295)
-- Name: regla_documento_comprobante fk_regla_doc_tipo_comp; Type: FK CONSTRAINT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.regla_documento_comprobante
    ADD CONSTRAINT fk_regla_doc_tipo_comp FOREIGN KEY (id_tipo_comprobante) REFERENCES configuracion.tipo_comprobante(id_tipo_comprobante);


--
-- TOC entry 4261 (class 2606 OID 47787)
-- Name: regla_documento_comprobante fk_regla_documento_comprobante_tipo_documento_codigo_documento; Type: FK CONSTRAINT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.regla_documento_comprobante
    ADD CONSTRAINT fk_regla_documento_comprobante_tipo_documento_codigo_documento FOREIGN KEY (codigo_documento) REFERENCES configuracion.tipo_documento(codigo) ON DELETE RESTRICT;


--
-- TOC entry 4212 (class 2606 OID 47280)
-- Name: series_comprobantes fk_series_tipo_comp; Type: FK CONSTRAINT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.series_comprobantes
    ADD CONSTRAINT fk_series_tipo_comp FOREIGN KEY (id_tipo_comprobante) REFERENCES configuracion.tipo_comprobante(id_tipo_comprobante);


--
-- TOC entry 4263 (class 2606 OID 47782)
-- Name: sucursales fk_sucursal_empresa_id_empresa; Type: FK CONSTRAINT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.sucursales
    ADD CONSTRAINT fk_sucursal_empresa_id_empresa FOREIGN KEY (id_empresa) REFERENCES configuracion.empresa(id_empresa) ON DELETE RESTRICT;


--
-- TOC entry 4264 (class 2606 OID 66635)
-- Name: sucursales fk_sucursales_empresa_id_empresa; Type: FK CONSTRAINT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.sucursales
    ADD CONSTRAINT fk_sucursales_empresa_id_empresa FOREIGN KEY (id_empresa) REFERENCES configuracion.empresa(id_empresa) ON DELETE RESTRICT;


--
-- TOC entry 4213 (class 2606 OID 46972)
-- Name: tablas_generales_detalle fk_tabla_general; Type: FK CONSTRAINT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.tablas_generales_detalle
    ADD CONSTRAINT fk_tabla_general FOREIGN KEY (id_tabla) REFERENCES configuracion.tablas_generales(id_tabla) ON DELETE CASCADE;


--
-- TOC entry 4274 (class 2606 OID 66872)
-- Name: ubigeos fk_ubigeos_ubigeos_parent_id; Type: FK CONSTRAINT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.ubigeos
    ADD CONSTRAINT fk_ubigeos_ubigeos_parent_id FOREIGN KEY (parent_id) REFERENCES configuracion.ubigeos(codigo) ON DELETE RESTRICT;


--
-- TOC entry 4265 (class 2606 OID 47327)
-- Name: sucursales sucursales_id_empresa_fkey; Type: FK CONSTRAINT; Schema: configuracion; Owner: -
--

ALTER TABLE ONLY configuracion.sucursales
    ADD CONSTRAINT sucursales_id_empresa_fkey FOREIGN KEY (id_empresa) REFERENCES configuracion.empresa(id_empresa);


--
-- TOC entry 4214 (class 2606 OID 46977)
-- Name: asientos_contables fk_asiento_estado; Type: FK CONSTRAINT; Schema: contabilidad; Owner: -
--

ALTER TABLE ONLY contabilidad.asientos_contables
    ADD CONSTRAINT fk_asiento_estado FOREIGN KEY (id_estado) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 4217 (class 2606 OID 46982)
-- Name: plan_cuentas fk_cuenta_padre; Type: FK CONSTRAINT; Schema: contabilidad; Owner: -
--

ALTER TABLE ONLY contabilidad.plan_cuentas
    ADD CONSTRAINT fk_cuenta_padre FOREIGN KEY (id_cuenta_padre) REFERENCES contabilidad.plan_cuentas(id_cuenta);


--
-- TOC entry 4215 (class 2606 OID 46987)
-- Name: detalle_asiento fk_da_asiento; Type: FK CONSTRAINT; Schema: contabilidad; Owner: -
--

ALTER TABLE ONLY contabilidad.detalle_asiento
    ADD CONSTRAINT fk_da_asiento FOREIGN KEY (id_asiento) REFERENCES contabilidad.asientos_contables(id_asiento) ON DELETE CASCADE;


--
-- TOC entry 4216 (class 2606 OID 46992)
-- Name: detalle_asiento fk_da_cuenta; Type: FK CONSTRAINT; Schema: contabilidad; Owner: -
--

ALTER TABLE ONLY contabilidad.detalle_asiento
    ADD CONSTRAINT fk_da_cuenta FOREIGN KEY (id_cuenta) REFERENCES contabilidad.plan_cuentas(id_cuenta);


--
-- TOC entry 4218 (class 2606 OID 46997)
-- Name: plan_cuentas fk_plan_cuenta_tipo; Type: FK CONSTRAINT; Schema: contabilidad; Owner: -
--

ALTER TABLE ONLY contabilidad.plan_cuentas
    ADD CONSTRAINT fk_plan_cuenta_tipo FOREIGN KEY (id_tipo_cuenta) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 4219 (class 2606 OID 47002)
-- Name: cargos fk_cargos_area; Type: FK CONSTRAINT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.cargos
    ADD CONSTRAINT fk_cargos_area FOREIGN KEY (id_area) REFERENCES identidad.areas(id_area);


--
-- TOC entry 4225 (class 2606 OID 47007)
-- Name: roles_permisos fk_rp_permiso; Type: FK CONSTRAINT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.roles_permisos
    ADD CONSTRAINT fk_rp_permiso FOREIGN KEY (id_permiso) REFERENCES identidad.permisos(id_permiso) ON DELETE CASCADE;


--
-- TOC entry 4226 (class 2606 OID 47012)
-- Name: roles_permisos fk_rp_rol; Type: FK CONSTRAINT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.roles_permisos
    ADD CONSTRAINT fk_rp_rol FOREIGN KEY (id_rol) REFERENCES identidad.roles(id_rol) ON DELETE CASCADE;


--
-- TOC entry 4227 (class 2606 OID 47017)
-- Name: trabajadores fk_trabajador_tipo_documento; Type: FK CONSTRAINT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.trabajadores
    ADD CONSTRAINT fk_trabajador_tipo_documento FOREIGN KEY (id_tipo_documento) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 4228 (class 2606 OID 47022)
-- Name: trabajadores fk_trabajadores_cargo; Type: FK CONSTRAINT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.trabajadores
    ADD CONSTRAINT fk_trabajadores_cargo FOREIGN KEY (id_cargo) REFERENCES identidad.cargos(id_cargo);


--
-- TOC entry 4229 (class 2606 OID 47027)
-- Name: trabajadores fk_trabajadores_usuario; Type: FK CONSTRAINT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.trabajadores
    ADD CONSTRAINT fk_trabajadores_usuario FOREIGN KEY (id_usuario) REFERENCES identidad.usuarios(id_usuario);


--
-- TOC entry 4230 (class 2606 OID 47032)
-- Name: usuarios fk_usuarios_rol; Type: FK CONSTRAINT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.usuarios
    ADD CONSTRAINT fk_usuarios_rol FOREIGN KEY (id_rol) REFERENCES identidad.roles(id_rol) ON DELETE RESTRICT;


--
-- TOC entry 4220 (class 2606 OID 47037)
-- Name: menus menus_id_menu_padre_fkey; Type: FK CONSTRAINT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.menus
    ADD CONSTRAINT menus_id_menu_padre_fkey FOREIGN KEY (id_menu_padre) REFERENCES identidad.menus(id_menu) ON DELETE CASCADE;


--
-- TOC entry 4221 (class 2606 OID 47042)
-- Name: roles_menus roles_menus_id_menu_fkey; Type: FK CONSTRAINT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.roles_menus
    ADD CONSTRAINT roles_menus_id_menu_fkey FOREIGN KEY (id_menu) REFERENCES identidad.menus(id_menu) ON DELETE CASCADE;


--
-- TOC entry 4222 (class 2606 OID 47047)
-- Name: roles_menus roles_menus_id_rol_fkey; Type: FK CONSTRAINT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.roles_menus
    ADD CONSTRAINT roles_menus_id_rol_fkey FOREIGN KEY (id_rol) REFERENCES identidad.roles(id_rol) ON DELETE CASCADE;


--
-- TOC entry 4223 (class 2606 OID 47052)
-- Name: roles_menus_permisos roles_menus_permisos_id_rol_menu_fkey; Type: FK CONSTRAINT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.roles_menus_permisos
    ADD CONSTRAINT roles_menus_permisos_id_rol_menu_fkey FOREIGN KEY (id_rol_menu) REFERENCES identidad.roles_menus(id_rol_menu) ON DELETE CASCADE;


--
-- TOC entry 4224 (class 2606 OID 47057)
-- Name: roles_menus_permisos roles_menus_permisos_id_tipo_permiso_fkey; Type: FK CONSTRAINT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.roles_menus_permisos
    ADD CONSTRAINT roles_menus_permisos_id_tipo_permiso_fkey FOREIGN KEY (id_tipo_permiso) REFERENCES identidad.tipos_permiso(id_tipo_permiso) ON DELETE CASCADE;


--
-- TOC entry 4231 (class 2606 OID 47062)
-- Name: usuarios_roles usuarios_roles_id_rol_fkey; Type: FK CONSTRAINT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.usuarios_roles
    ADD CONSTRAINT usuarios_roles_id_rol_fkey FOREIGN KEY (id_rol) REFERENCES identidad.roles(id_rol) ON DELETE CASCADE;


--
-- TOC entry 4232 (class 2606 OID 47067)
-- Name: usuarios_roles usuarios_roles_id_usuario_fkey; Type: FK CONSTRAINT; Schema: identidad; Owner: -
--

ALTER TABLE ONLY identidad.usuarios_roles
    ADD CONSTRAINT usuarios_roles_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES identidad.usuarios(id_usuario) ON DELETE CASCADE;


--
-- TOC entry 4233 (class 2606 OID 47072)
-- Name: movimientos_inventario fk_movimiento_inventario_tipo; Type: FK CONSTRAINT; Schema: inventario; Owner: -
--

ALTER TABLE ONLY inventario.movimientos_inventario
    ADD CONSTRAINT fk_movimiento_inventario_tipo FOREIGN KEY (id_tipo_movimiento) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 4234 (class 2606 OID 47077)
-- Name: movimientos_inventario fk_movimiento_stock; Type: FK CONSTRAINT; Schema: inventario; Owner: -
--

ALTER TABLE ONLY inventario.movimientos_inventario
    ADD CONSTRAINT fk_movimiento_stock FOREIGN KEY (id_stock) REFERENCES inventario.stock(id_stock);


--
-- TOC entry 4235 (class 2606 OID 47082)
-- Name: stock fk_stock_almacen; Type: FK CONSTRAINT; Schema: inventario; Owner: -
--

ALTER TABLE ONLY inventario.stock
    ADD CONSTRAINT fk_stock_almacen FOREIGN KEY (id_almacen) REFERENCES inventario.almacenes(id_almacen);


--
-- TOC entry 4236 (class 2606 OID 47087)
-- Name: stock fk_stock_producto; Type: FK CONSTRAINT; Schema: inventario; Owner: -
--

ALTER TABLE ONLY inventario.stock
    ADD CONSTRAINT fk_stock_producto FOREIGN KEY (id_producto) REFERENCES catalogo.productos(id_producto);


--
-- TOC entry 4237 (class 2606 OID 47092)
-- Name: stock fk_stock_variante; Type: FK CONSTRAINT; Schema: inventario; Owner: -
--

ALTER TABLE ONLY inventario.stock
    ADD CONSTRAINT fk_stock_variante FOREIGN KEY (id_variante) REFERENCES catalogo.variantes_producto(id_variante);


--
-- TOC entry 4268 (class 2606 OID 47591)
-- Name: traslados_detalle traslados_detalle_id_traslado_fkey; Type: FK CONSTRAINT; Schema: inventario; Owner: -
--

ALTER TABLE ONLY inventario.traslados_detalle
    ADD CONSTRAINT traslados_detalle_id_traslado_fkey FOREIGN KEY (id_traslado) REFERENCES inventario.traslados(id_traslado);


--
-- TOC entry 4269 (class 2606 OID 47605)
-- Name: traslados_incidencias traslados_incidencias_id_detalle_traslado_fkey; Type: FK CONSTRAINT; Schema: inventario; Owner: -
--

ALTER TABLE ONLY inventario.traslados_incidencias
    ADD CONSTRAINT traslados_incidencias_id_detalle_traslado_fkey FOREIGN KEY (id_detalle_traslado) REFERENCES inventario.traslados_detalle(id_detalle_traslado);


--
-- TOC entry 4270 (class 2606 OID 62626)
-- Name: categorias FK_categorias_categorias_IdCategoriaPadre; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorias
    ADD CONSTRAINT "FK_categorias_categorias_IdCategoriaPadre" FOREIGN KEY ("IdCategoriaPadre") REFERENCES public.categorias("Id");


--
-- TOC entry 4271 (class 2606 OID 62655)
-- Name: productos FK_productos_categorias_IdCategoria; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT "FK_productos_categorias_IdCategoria" FOREIGN KEY ("IdCategoria") REFERENCES public.categorias("Id") ON DELETE RESTRICT;


--
-- TOC entry 4272 (class 2606 OID 62660)
-- Name: productos FK_productos_marcas_IdMarca; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT "FK_productos_marcas_IdMarca" FOREIGN KEY ("IdMarca") REFERENCES public.marcas("Id") ON DELETE RESTRICT;


--
-- TOC entry 4273 (class 2606 OID 62665)
-- Name: productos FK_productos_unidades_medida_IdUnidadMedida; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT "FK_productos_unidades_medida_IdUnidadMedida" FOREIGN KEY ("IdUnidadMedida") REFERENCES public.unidades_medida("Id") ON DELETE RESTRICT;


--
-- TOC entry 4238 (class 2606 OID 47097)
-- Name: cajas fk_caja_almacen; Type: FK CONSTRAINT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.cajas
    ADD CONSTRAINT fk_caja_almacen FOREIGN KEY (id_almacen) REFERENCES inventario.almacenes(id_almacen);


--
-- TOC entry 4239 (class 2606 OID 47102)
-- Name: cajas fk_caja_estado; Type: FK CONSTRAINT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.cajas
    ADD CONSTRAINT fk_caja_estado FOREIGN KEY (id_estado) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 4240 (class 2606 OID 47107)
-- Name: cotizaciones fk_cot_cliente; Type: FK CONSTRAINT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.cotizaciones
    ADD CONSTRAINT fk_cot_cliente FOREIGN KEY (id_cliente) REFERENCES clientes.clientes(id_cliente);


--
-- TOC entry 4241 (class 2606 OID 47112)
-- Name: cotizaciones fk_cot_vendedor; Type: FK CONSTRAINT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.cotizaciones
    ADD CONSTRAINT fk_cot_vendedor FOREIGN KEY (id_usuario_vendedor) REFERENCES identidad.usuarios(id_usuario);


--
-- TOC entry 4242 (class 2606 OID 47117)
-- Name: cotizaciones fk_cotizacion_estado; Type: FK CONSTRAINT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.cotizaciones
    ADD CONSTRAINT fk_cotizacion_estado FOREIGN KEY (id_estado) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 4243 (class 2606 OID 47122)
-- Name: detalle_cotizacion fk_dcot_cotizacion; Type: FK CONSTRAINT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.detalle_cotizacion
    ADD CONSTRAINT fk_dcot_cotizacion FOREIGN KEY (id_cotizacion) REFERENCES ventas.cotizaciones(id_cotizacion) ON DELETE CASCADE;


--
-- TOC entry 4244 (class 2606 OID 47127)
-- Name: detalle_cotizacion fk_dcot_producto; Type: FK CONSTRAINT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.detalle_cotizacion
    ADD CONSTRAINT fk_dcot_producto FOREIGN KEY (id_producto) REFERENCES catalogo.productos(id_producto);


--
-- TOC entry 4266 (class 2606 OID 47549)
-- Name: detalle_notas fk_detalle_notas_cabecera; Type: FK CONSTRAINT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.detalle_notas
    ADD CONSTRAINT fk_detalle_notas_cabecera FOREIGN KEY (id_nota) REFERENCES ventas.notas(id_nota) ON DELETE CASCADE;


--
-- TOC entry 4247 (class 2606 OID 47734)
-- Name: detalle_venta fk_detalle_venta_afectacion_igv; Type: FK CONSTRAINT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.detalle_venta
    ADD CONSTRAINT fk_detalle_venta_afectacion_igv FOREIGN KEY (codigo_afectacion_igv) REFERENCES configuracion.tipo_afectacion_igv(codigo);


--
-- TOC entry 4245 (class 2606 OID 47132)
-- Name: detalle_venta fk_dv_producto; Type: FK CONSTRAINT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.detalle_venta
    ADD CONSTRAINT fk_dv_producto FOREIGN KEY (id_producto) REFERENCES catalogo.productos(id_producto);


--
-- TOC entry 4246 (class 2606 OID 47137)
-- Name: detalle_venta fk_dv_venta; Type: FK CONSTRAINT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.detalle_venta
    ADD CONSTRAINT fk_dv_venta FOREIGN KEY (id_venta) REFERENCES ventas.ventas(id_venta) ON DELETE CASCADE;


--
-- TOC entry 4248 (class 2606 OID 47142)
-- Name: movimientos_caja fk_mc_caja; Type: FK CONSTRAINT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.movimientos_caja
    ADD CONSTRAINT fk_mc_caja FOREIGN KEY (id_caja) REFERENCES ventas.cajas(id_caja);


--
-- TOC entry 4249 (class 2606 OID 47147)
-- Name: movimientos_caja fk_mc_pago; Type: FK CONSTRAINT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.movimientos_caja
    ADD CONSTRAINT fk_mc_pago FOREIGN KEY (id_pago_relacionado) REFERENCES ventas.pagos(id_pago);


--
-- TOC entry 4250 (class 2606 OID 47152)
-- Name: movimientos_caja fk_movimiento_caja_tipo; Type: FK CONSTRAINT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.movimientos_caja
    ADD CONSTRAINT fk_movimiento_caja_tipo FOREIGN KEY (id_tipo_movimiento) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 4251 (class 2606 OID 47157)
-- Name: pagos fk_pago_metodo; Type: FK CONSTRAINT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.pagos
    ADD CONSTRAINT fk_pago_metodo FOREIGN KEY (id_metodo_pago) REFERENCES ventas.metodos_pago(id_metodo_pago);


--
-- TOC entry 4252 (class 2606 OID 47162)
-- Name: pagos fk_pago_venta; Type: FK CONSTRAINT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.pagos
    ADD CONSTRAINT fk_pago_venta FOREIGN KEY (id_venta) REFERENCES ventas.ventas(id_venta);


--
-- TOC entry 4253 (class 2606 OID 47167)
-- Name: ventas fk_venta_almacen; Type: FK CONSTRAINT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.ventas
    ADD CONSTRAINT fk_venta_almacen FOREIGN KEY (id_almacen) REFERENCES inventario.almacenes(id_almacen);


--
-- TOC entry 4254 (class 2606 OID 47172)
-- Name: ventas fk_venta_caja; Type: FK CONSTRAINT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.ventas
    ADD CONSTRAINT fk_venta_caja FOREIGN KEY (id_caja) REFERENCES ventas.cajas(id_caja);


--
-- TOC entry 4255 (class 2606 OID 47177)
-- Name: ventas fk_venta_cliente; Type: FK CONSTRAINT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.ventas
    ADD CONSTRAINT fk_venta_cliente FOREIGN KEY (id_cliente) REFERENCES clientes.clientes(id_cliente);


--
-- TOC entry 4256 (class 2606 OID 47182)
-- Name: ventas fk_venta_estado; Type: FK CONSTRAINT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.ventas
    ADD CONSTRAINT fk_venta_estado FOREIGN KEY (id_estado) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 4257 (class 2606 OID 47187)
-- Name: ventas fk_venta_estado_pago; Type: FK CONSTRAINT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.ventas
    ADD CONSTRAINT fk_venta_estado_pago FOREIGN KEY (id_estado_pago) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 4258 (class 2606 OID 47192)
-- Name: ventas fk_venta_tipo_comprobante; Type: FK CONSTRAINT; Schema: ventas; Owner: -
--

ALTER TABLE ONLY ventas.ventas
    ADD CONSTRAINT fk_venta_tipo_comprobante FOREIGN KEY (id_tipo_comprobante) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


-- Completed on 2026-03-29 12:58:16

--
-- PostgreSQL database dump complete
--

\unrestrict VeLFI1idzRelRDyfy7FTXJwbCK6pfq5o3Yf9wAENjpVhFeFC3EzYOYieoQlDcF2

-- Completed on 2026-03-29 12:58:16

--
-- PostgreSQL database cluster dump complete
--

