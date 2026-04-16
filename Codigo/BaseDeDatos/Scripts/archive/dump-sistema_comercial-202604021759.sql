--
-- PostgreSQL database dump
--

\restrict rp5Q9G3ovxVQT81Uzawt5e9zogHCF6BfHrQE93Hff5kpNCgVPAaGQTaEpNLJKzC

-- Dumped from database version 14.22
-- Dumped by pg_dump version 14.22

-- Started on 2026-04-02 17:59:27

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

DROP DATABASE sistema_comercial;
--
-- TOC entry 4717 (class 1262 OID 16394)
-- Name: sistema_comercial; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE sistema_comercial WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Spanish_Peru.1252';


ALTER DATABASE sistema_comercial OWNER TO postgres;

\unrestrict rp5Q9G3ovxVQT81Uzawt5e9zogHCF6BfHrQE93Hff5kpNCgVPAaGQTaEpNLJKzC
\connect sistema_comercial
\restrict rp5Q9G3ovxVQT81Uzawt5e9zogHCF6BfHrQE93Hff5kpNCgVPAaGQTaEpNLJKzC

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
-- Name: catalogo; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA catalogo;


ALTER SCHEMA catalogo OWNER TO postgres;

--
-- TOC entry 7 (class 2615 OID 46214)
-- Name: clientes; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA clientes;


ALTER SCHEMA clientes OWNER TO postgres;

--
-- TOC entry 8 (class 2615 OID 46215)
-- Name: compras; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA compras;


ALTER SCHEMA compras OWNER TO postgres;

--
-- TOC entry 9 (class 2615 OID 46216)
-- Name: configuracion; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA configuracion;


ALTER SCHEMA configuracion OWNER TO postgres;

--
-- TOC entry 10 (class 2615 OID 46217)
-- Name: contabilidad; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA contabilidad;


ALTER SCHEMA contabilidad OWNER TO postgres;

--
-- TOC entry 11 (class 2615 OID 46218)
-- Name: identidad; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA identidad;


ALTER SCHEMA identidad OWNER TO postgres;

--
-- TOC entry 12 (class 2615 OID 46219)
-- Name: inventario; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA inventario;


ALTER SCHEMA inventario OWNER TO postgres;

--
-- TOC entry 14 (class 2615 OID 67288)
-- Name: sunat; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA sunat;


ALTER SCHEMA sunat OWNER TO postgres;

--
-- TOC entry 13 (class 2615 OID 46220)
-- Name: ventas; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA ventas;


ALTER SCHEMA ventas OWNER TO postgres;

--
-- TOC entry 15 (class 2615 OID 18605)
-- Name: vistas; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA vistas;


ALTER SCHEMA vistas OWNER TO postgres;

--
-- TOC entry 390 (class 1255 OID 46221)
-- Name: update_fecha_modificacion_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_fecha_modificacion_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.fecha_modificacion = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_fecha_modificacion_column() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 339 (class 1259 OID 62613)
-- Name: __ef_migrations; Type: TABLE; Schema: catalogo; Owner: postgres
--

CREATE TABLE catalogo.__ef_migrations (
    migration_id character varying(150) NOT NULL,
    product_version character varying(32) NOT NULL
);


ALTER TABLE catalogo.__ef_migrations OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 46222)
-- Name: categorias; Type: TABLE; Schema: catalogo; Owner: postgres
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


ALTER TABLE catalogo.categorias OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 46230)
-- Name: categorias_id_categoria_seq; Type: SEQUENCE; Schema: catalogo; Owner: postgres
--

CREATE SEQUENCE catalogo.categorias_id_categoria_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE catalogo.categorias_id_categoria_seq OWNER TO postgres;

--
-- TOC entry 4718 (class 0 OID 0)
-- Dependencies: 221
-- Name: categorias_id_categoria_seq; Type: SEQUENCE OWNED BY; Schema: catalogo; Owner: postgres
--

ALTER SEQUENCE catalogo.categorias_id_categoria_seq OWNED BY catalogo.categorias.id_categoria;


--
-- TOC entry 222 (class 1259 OID 46231)
-- Name: imagenes_producto; Type: TABLE; Schema: catalogo; Owner: postgres
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


ALTER TABLE catalogo.imagenes_producto OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 46241)
-- Name: imagenes_producto_id_imagen_seq; Type: SEQUENCE; Schema: catalogo; Owner: postgres
--

CREATE SEQUENCE catalogo.imagenes_producto_id_imagen_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE catalogo.imagenes_producto_id_imagen_seq OWNER TO postgres;

--
-- TOC entry 4719 (class 0 OID 0)
-- Dependencies: 223
-- Name: imagenes_producto_id_imagen_seq; Type: SEQUENCE OWNED BY; Schema: catalogo; Owner: postgres
--

ALTER SEQUENCE catalogo.imagenes_producto_id_imagen_seq OWNED BY catalogo.imagenes_producto.id_imagen;


--
-- TOC entry 224 (class 1259 OID 46242)
-- Name: listas_precios; Type: TABLE; Schema: catalogo; Owner: postgres
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


ALTER TABLE catalogo.listas_precios OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 46249)
-- Name: listas_precios_id_lista_precio_seq; Type: SEQUENCE; Schema: catalogo; Owner: postgres
--

CREATE SEQUENCE catalogo.listas_precios_id_lista_precio_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE catalogo.listas_precios_id_lista_precio_seq OWNER TO postgres;

--
-- TOC entry 4720 (class 0 OID 0)
-- Dependencies: 225
-- Name: listas_precios_id_lista_precio_seq; Type: SEQUENCE OWNED BY; Schema: catalogo; Owner: postgres
--

ALTER SEQUENCE catalogo.listas_precios_id_lista_precio_seq OWNED BY catalogo.listas_precios.id_lista_precio;


--
-- TOC entry 226 (class 1259 OID 46250)
-- Name: marcas; Type: TABLE; Schema: catalogo; Owner: postgres
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


ALTER TABLE catalogo.marcas OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 46256)
-- Name: marcas_id_marca_seq; Type: SEQUENCE; Schema: catalogo; Owner: postgres
--

CREATE SEQUENCE catalogo.marcas_id_marca_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE catalogo.marcas_id_marca_seq OWNER TO postgres;

--
-- TOC entry 4721 (class 0 OID 0)
-- Dependencies: 227
-- Name: marcas_id_marca_seq; Type: SEQUENCE OWNED BY; Schema: catalogo; Owner: postgres
--

ALTER SEQUENCE catalogo.marcas_id_marca_seq OWNED BY catalogo.marcas.id_marca;


--
-- TOC entry 228 (class 1259 OID 46257)
-- Name: productos; Type: TABLE; Schema: catalogo; Owner: postgres
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


ALTER TABLE catalogo.productos OWNER TO postgres;

--
-- TOC entry 4722 (class 0 OID 0)
-- Dependencies: 228
-- Name: TABLE productos; Type: COMMENT; Schema: catalogo; Owner: postgres
--

COMMENT ON TABLE catalogo.productos IS 'Catálogo maestro de productos';


--
-- TOC entry 229 (class 1259 OID 46278)
-- Name: productos_id_producto_seq; Type: SEQUENCE; Schema: catalogo; Owner: postgres
--

CREATE SEQUENCE catalogo.productos_id_producto_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE catalogo.productos_id_producto_seq OWNER TO postgres;

--
-- TOC entry 4723 (class 0 OID 0)
-- Dependencies: 229
-- Name: productos_id_producto_seq; Type: SEQUENCE OWNED BY; Schema: catalogo; Owner: postgres
--

ALTER SEQUENCE catalogo.productos_id_producto_seq OWNED BY catalogo.productos.id_producto;


--
-- TOC entry 230 (class 1259 OID 46279)
-- Name: unidades_medida; Type: TABLE; Schema: catalogo; Owner: postgres
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


ALTER TABLE catalogo.unidades_medida OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 46285)
-- Name: unidades_medida_id_unidad_seq; Type: SEQUENCE; Schema: catalogo; Owner: postgres
--

CREATE SEQUENCE catalogo.unidades_medida_id_unidad_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE catalogo.unidades_medida_id_unidad_seq OWNER TO postgres;

--
-- TOC entry 4724 (class 0 OID 0)
-- Dependencies: 231
-- Name: unidades_medida_id_unidad_seq; Type: SEQUENCE OWNED BY; Schema: catalogo; Owner: postgres
--

ALTER SEQUENCE catalogo.unidades_medida_id_unidad_seq OWNED BY catalogo.unidades_medida.id_unidad;


--
-- TOC entry 232 (class 1259 OID 46286)
-- Name: variantes_producto; Type: TABLE; Schema: catalogo; Owner: postgres
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


ALTER TABLE catalogo.variantes_producto OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 46295)
-- Name: variantes_producto_id_variante_seq; Type: SEQUENCE; Schema: catalogo; Owner: postgres
--

CREATE SEQUENCE catalogo.variantes_producto_id_variante_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE catalogo.variantes_producto_id_variante_seq OWNER TO postgres;

--
-- TOC entry 4725 (class 0 OID 0)
-- Dependencies: 233
-- Name: variantes_producto_id_variante_seq; Type: SEQUENCE OWNED BY; Schema: catalogo; Owner: postgres
--

ALTER SEQUENCE catalogo.variantes_producto_id_variante_seq OWNED BY catalogo.variantes_producto.id_variante;


--
-- TOC entry 355 (class 1259 OID 66654)
-- Name: __EFMigrationsHistory; Type: TABLE; Schema: clientes; Owner: postgres
--

CREATE TABLE clientes."__EFMigrationsHistory" (
    "MigrationId" character varying(150) NOT NULL,
    "ProductVersion" character varying(32) NOT NULL
);


ALTER TABLE clientes."__EFMigrationsHistory" OWNER TO postgres;

--
-- TOC entry 358 (class 1259 OID 66796)
-- Name: __ef_migrations_history; Type: TABLE; Schema: clientes; Owner: postgres
--

CREATE TABLE clientes.__ef_migrations_history (
    migration_id character varying(150) NOT NULL,
    product_version character varying(32) NOT NULL
);


ALTER TABLE clientes.__ef_migrations_history OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 46296)
-- Name: clientes; Type: TABLE; Schema: clientes; Owner: postgres
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


ALTER TABLE clientes.clientes OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 46306)
-- Name: clientes_id_cliente_seq; Type: SEQUENCE; Schema: clientes; Owner: postgres
--

CREATE SEQUENCE clientes.clientes_id_cliente_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clientes.clientes_id_cliente_seq OWNER TO postgres;

--
-- TOC entry 4726 (class 0 OID 0)
-- Dependencies: 235
-- Name: clientes_id_cliente_seq; Type: SEQUENCE OWNED BY; Schema: clientes; Owner: postgres
--

ALTER SEQUENCE clientes.clientes_id_cliente_seq OWNED BY clientes.clientes.id_cliente;


--
-- TOC entry 236 (class 1259 OID 46307)
-- Name: contactos_cliente; Type: TABLE; Schema: clientes; Owner: postgres
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


ALTER TABLE clientes.contactos_cliente OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 46316)
-- Name: contactos_cliente_id_contacto_seq; Type: SEQUENCE; Schema: clientes; Owner: postgres
--

CREATE SEQUENCE clientes.contactos_cliente_id_contacto_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clientes.contactos_cliente_id_contacto_seq OWNER TO postgres;

--
-- TOC entry 4727 (class 0 OID 0)
-- Dependencies: 237
-- Name: contactos_cliente_id_contacto_seq; Type: SEQUENCE OWNED BY; Schema: clientes; Owner: postgres
--

ALTER SEQUENCE clientes.contactos_cliente_id_contacto_seq OWNED BY clientes.contactos_cliente.id_contacto;


--
-- TOC entry 357 (class 1259 OID 66791)
-- Name: __ef_migrations_history; Type: TABLE; Schema: compras; Owner: postgres
--

CREATE TABLE compras.__ef_migrations_history (
    migration_id character varying(150) NOT NULL,
    product_version character varying(32) NOT NULL
);


ALTER TABLE compras.__ef_migrations_history OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 46317)
-- Name: compras; Type: TABLE; Schema: compras; Owner: postgres
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
    observaciones text,
    estado_sunat text DEFAULT ''::text NOT NULL,
    fecha_anulacion timestamp without time zone,
    motivo_anulacion text
);


ALTER TABLE compras.compras OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 46331)
-- Name: compras_id_compra_seq; Type: SEQUENCE; Schema: compras; Owner: postgres
--

CREATE SEQUENCE compras.compras_id_compra_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE compras.compras_id_compra_seq OWNER TO postgres;

--
-- TOC entry 4728 (class 0 OID 0)
-- Dependencies: 239
-- Name: compras_id_compra_seq; Type: SEQUENCE OWNED BY; Schema: compras; Owner: postgres
--

ALTER SEQUENCE compras.compras_id_compra_seq OWNED BY compras.compras.id_compra;


--
-- TOC entry 240 (class 1259 OID 46332)
-- Name: detalle_compra; Type: TABLE; Schema: compras; Owner: postgres
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


ALTER TABLE compras.detalle_compra OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 46339)
-- Name: detalle_compra_id_detalle_compra_seq; Type: SEQUENCE; Schema: compras; Owner: postgres
--

CREATE SEQUENCE compras.detalle_compra_id_detalle_compra_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE compras.detalle_compra_id_detalle_compra_seq OWNER TO postgres;

--
-- TOC entry 4729 (class 0 OID 0)
-- Dependencies: 241
-- Name: detalle_compra_id_detalle_compra_seq; Type: SEQUENCE OWNED BY; Schema: compras; Owner: postgres
--

ALTER SEQUENCE compras.detalle_compra_id_detalle_compra_seq OWNED BY compras.detalle_compra.id_detalle_compra;


--
-- TOC entry 242 (class 1259 OID 46340)
-- Name: detalle_orden_compra; Type: TABLE; Schema: compras; Owner: postgres
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


ALTER TABLE compras.detalle_orden_compra OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 46347)
-- Name: detalle_orden_compra_id_detalle_oc_seq; Type: SEQUENCE; Schema: compras; Owner: postgres
--

CREATE SEQUENCE compras.detalle_orden_compra_id_detalle_oc_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE compras.detalle_orden_compra_id_detalle_oc_seq OWNER TO postgres;

--
-- TOC entry 4730 (class 0 OID 0)
-- Dependencies: 243
-- Name: detalle_orden_compra_id_detalle_oc_seq; Type: SEQUENCE OWNED BY; Schema: compras; Owner: postgres
--

ALTER SEQUENCE compras.detalle_orden_compra_id_detalle_oc_seq OWNED BY compras.detalle_orden_compra.id_detalle_oc;


--
-- TOC entry 356 (class 1259 OID 66762)
-- Name: ef_migrations_history; Type: TABLE; Schema: compras; Owner: postgres
--

CREATE TABLE compras.ef_migrations_history (
    migration_id character varying(150) NOT NULL,
    product_version character varying(32) NOT NULL
);


ALTER TABLE compras.ef_migrations_history OWNER TO postgres;

--
-- TOC entry 361 (class 1259 OID 66884)
-- Name: nota_credito; Type: TABLE; Schema: compras; Owner: postgres
--

CREATE TABLE compras.nota_credito (
    id_nota bigint NOT NULL,
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
    usuario_modificacion character varying(100)
);


ALTER TABLE compras.nota_credito OWNER TO postgres;

--
-- TOC entry 365 (class 1259 OID 66920)
-- Name: nota_credito_detalle; Type: TABLE; Schema: compras; Owner: postgres
--

CREATE TABLE compras.nota_credito_detalle (
    id_detalle bigint NOT NULL,
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
    usuario_modificacion character varying(100)
);


ALTER TABLE compras.nota_credito_detalle OWNER TO postgres;

--
-- TOC entry 364 (class 1259 OID 66919)
-- Name: nota_credito_detalle_id_detalle_seq; Type: SEQUENCE; Schema: compras; Owner: postgres
--

ALTER TABLE compras.nota_credito_detalle ALTER COLUMN id_detalle ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME compras.nota_credito_detalle_id_detalle_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 360 (class 1259 OID 66883)
-- Name: nota_credito_id_nota_seq; Type: SEQUENCE; Schema: compras; Owner: postgres
--

ALTER TABLE compras.nota_credito ALTER COLUMN id_nota ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME compras.nota_credito_id_nota_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 363 (class 1259 OID 66902)
-- Name: nota_debito; Type: TABLE; Schema: compras; Owner: postgres
--

CREATE TABLE compras.nota_debito (
    id_nota bigint NOT NULL,
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
    usuario_modificacion character varying(100)
);


ALTER TABLE compras.nota_debito OWNER TO postgres;

--
-- TOC entry 367 (class 1259 OID 66938)
-- Name: nota_debito_detalle; Type: TABLE; Schema: compras; Owner: postgres
--

CREATE TABLE compras.nota_debito_detalle (
    id_detalle bigint NOT NULL,
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
    usuario_modificacion character varying(100)
);


ALTER TABLE compras.nota_debito_detalle OWNER TO postgres;

--
-- TOC entry 366 (class 1259 OID 66937)
-- Name: nota_debito_detalle_id_detalle_seq; Type: SEQUENCE; Schema: compras; Owner: postgres
--

ALTER TABLE compras.nota_debito_detalle ALTER COLUMN id_detalle ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME compras.nota_debito_detalle_id_detalle_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 362 (class 1259 OID 66901)
-- Name: nota_debito_id_nota_seq; Type: SEQUENCE; Schema: compras; Owner: postgres
--

ALTER TABLE compras.nota_debito ALTER COLUMN id_nota ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME compras.nota_debito_id_nota_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 244 (class 1259 OID 46348)
-- Name: ordenes_compra; Type: TABLE; Schema: compras; Owner: postgres
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


ALTER TABLE compras.ordenes_compra OWNER TO postgres;

--
-- TOC entry 4731 (class 0 OID 0)
-- Dependencies: 244
-- Name: COLUMN ordenes_compra.compra_id; Type: COMMENT; Schema: compras; Owner: postgres
--

COMMENT ON COLUMN compras.ordenes_compra.compra_id IS 'ID de la compra vinculada a esta orden';


--
-- TOC entry 245 (class 1259 OID 46357)
-- Name: ordenes_compra_id_orden_compra_seq; Type: SEQUENCE; Schema: compras; Owner: postgres
--

CREATE SEQUENCE compras.ordenes_compra_id_orden_compra_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE compras.ordenes_compra_id_orden_compra_seq OWNER TO postgres;

--
-- TOC entry 4732 (class 0 OID 0)
-- Dependencies: 245
-- Name: ordenes_compra_id_orden_compra_seq; Type: SEQUENCE OWNED BY; Schema: compras; Owner: postgres
--

ALTER SEQUENCE compras.ordenes_compra_id_orden_compra_seq OWNED BY compras.ordenes_compra.id_orden_compra;


--
-- TOC entry 246 (class 1259 OID 46358)
-- Name: proveedores; Type: TABLE; Schema: compras; Owner: postgres
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


ALTER TABLE compras.proveedores OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 46366)
-- Name: proveedores_id_proveedor_seq; Type: SEQUENCE; Schema: compras; Owner: postgres
--

CREATE SEQUENCE compras.proveedores_id_proveedor_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE compras.proveedores_id_proveedor_seq OWNER TO postgres;

--
-- TOC entry 4733 (class 0 OID 0)
-- Dependencies: 247
-- Name: proveedores_id_proveedor_seq; Type: SEQUENCE OWNED BY; Schema: compras; Owner: postgres
--

ALTER SEQUENCE compras.proveedores_id_proveedor_seq OWNED BY compras.proveedores.id_proveedor;


--
-- TOC entry 248 (class 1259 OID 46367)
-- Name: configuraciones; Type: TABLE; Schema: configuracion; Owner: postgres
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


ALTER TABLE configuracion.configuraciones OWNER TO postgres;

--
-- TOC entry 4734 (class 0 OID 0)
-- Dependencies: 248
-- Name: TABLE configuraciones; Type: COMMENT; Schema: configuracion; Owner: postgres
--

COMMENT ON TABLE configuracion.configuraciones IS 'Variables de configuración global del sistema';


--
-- TOC entry 249 (class 1259 OID 46375)
-- Name: configuraciones_id_configuracion_seq; Type: SEQUENCE; Schema: configuracion; Owner: postgres
--

CREATE SEQUENCE configuracion.configuraciones_id_configuracion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE configuracion.configuraciones_id_configuracion_seq OWNER TO postgres;

--
-- TOC entry 4735 (class 0 OID 0)
-- Dependencies: 249
-- Name: configuraciones_id_configuracion_seq; Type: SEQUENCE OWNED BY; Schema: configuracion; Owner: postgres
--

ALTER SEQUENCE configuracion.configuraciones_id_configuracion_seq OWNED BY configuracion.configuraciones.id_configuracion;


--
-- TOC entry 250 (class 1259 OID 46376)
-- Name: empresa; Type: TABLE; Schema: configuracion; Owner: postgres
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


ALTER TABLE configuracion.empresa OWNER TO postgres;

--
-- TOC entry 4736 (class 0 OID 0)
-- Dependencies: 250
-- Name: TABLE empresa; Type: COMMENT; Schema: configuracion; Owner: postgres
--

COMMENT ON TABLE configuracion.empresa IS 'Datos generales de la empresa emisora';


--
-- TOC entry 251 (class 1259 OID 46385)
-- Name: empresa_id_empresa_seq; Type: SEQUENCE; Schema: configuracion; Owner: postgres
--

CREATE SEQUENCE configuracion.empresa_id_empresa_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE configuracion.empresa_id_empresa_seq OWNER TO postgres;

--
-- TOC entry 4737 (class 0 OID 0)
-- Dependencies: 251
-- Name: empresa_id_empresa_seq; Type: SEQUENCE OWNED BY; Schema: configuracion; Owner: postgres
--

ALTER SEQUENCE configuracion.empresa_id_empresa_seq OWNED BY configuracion.empresa.id_empresa;


--
-- TOC entry 324 (class 1259 OID 47333)
-- Name: impuestos; Type: TABLE; Schema: configuracion; Owner: postgres
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


ALTER TABLE configuracion.impuestos OWNER TO postgres;

--
-- TOC entry 323 (class 1259 OID 47332)
-- Name: impuestos_id_impuesto_seq; Type: SEQUENCE; Schema: configuracion; Owner: postgres
--

CREATE SEQUENCE configuracion.impuestos_id_impuesto_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE configuracion.impuestos_id_impuesto_seq OWNER TO postgres;

--
-- TOC entry 4738 (class 0 OID 0)
-- Dependencies: 323
-- Name: impuestos_id_impuesto_seq; Type: SEQUENCE OWNED BY; Schema: configuracion; Owner: postgres
--

ALTER SEQUENCE configuracion.impuestos_id_impuesto_seq OWNED BY configuracion.impuestos.id_impuesto;


--
-- TOC entry 318 (class 1259 OID 47241)
-- Name: matriz_regla_sunat; Type: TABLE; Schema: configuracion; Owner: postgres
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
    usuario_modificacion character varying(100)
);


ALTER TABLE configuracion.matriz_regla_sunat OWNER TO postgres;

--
-- TOC entry 317 (class 1259 OID 47240)
-- Name: matriz_regla_sunat_id_regla_seq; Type: SEQUENCE; Schema: configuracion; Owner: postgres
--

CREATE SEQUENCE configuracion.matriz_regla_sunat_id_regla_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE configuracion.matriz_regla_sunat_id_regla_seq OWNER TO postgres;

--
-- TOC entry 4739 (class 0 OID 0)
-- Dependencies: 317
-- Name: matriz_regla_sunat_id_regla_seq; Type: SEQUENCE OWNED BY; Schema: configuracion; Owner: postgres
--

ALTER SEQUENCE configuracion.matriz_regla_sunat_id_regla_seq OWNED BY configuracion.matriz_regla_sunat.id_regla;


--
-- TOC entry 384 (class 1259 OID 67074)
-- Name: metodos_pago; Type: TABLE; Schema: configuracion; Owner: postgres
--

CREATE TABLE configuracion.metodos_pago (
    id_metodo_pago bigint NOT NULL,
    codigo character varying(20) NOT NULL,
    nombre character varying(100) NOT NULL,
    es_efectivo boolean NOT NULL,
    id_tipo_documento_pago bigint,
    activado boolean NOT NULL,
    fecha_creacion timestamp with time zone NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(100)
);


ALTER TABLE configuracion.metodos_pago OWNER TO postgres;

--
-- TOC entry 383 (class 1259 OID 67073)
-- Name: metodos_pago_id_metodo_pago_seq; Type: SEQUENCE; Schema: configuracion; Owner: postgres
--

ALTER TABLE configuracion.metodos_pago ALTER COLUMN id_metodo_pago ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME configuracion.metodos_pago_id_metodo_pago_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 336 (class 1259 OID 47710)
-- Name: motivo_nota_credito; Type: TABLE; Schema: configuracion; Owner: postgres
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


ALTER TABLE configuracion.motivo_nota_credito OWNER TO postgres;

--
-- TOC entry 335 (class 1259 OID 47709)
-- Name: motivo_nota_credito_id_motivo_seq; Type: SEQUENCE; Schema: configuracion; Owner: postgres
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
-- TOC entry 338 (class 1259 OID 47723)
-- Name: motivo_nota_debito; Type: TABLE; Schema: configuracion; Owner: postgres
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


ALTER TABLE configuracion.motivo_nota_debito OWNER TO postgres;

--
-- TOC entry 337 (class 1259 OID 47722)
-- Name: motivo_nota_debito_id_motivo_seq; Type: SEQUENCE; Schema: configuracion; Owner: postgres
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
-- TOC entry 326 (class 1259 OID 47345)
-- Name: parametros_configuracion; Type: TABLE; Schema: configuracion; Owner: postgres
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


ALTER TABLE configuracion.parametros_configuracion OWNER TO postgres;

--
-- TOC entry 325 (class 1259 OID 47344)
-- Name: parametros_configuracion_id_parametro_seq; Type: SEQUENCE; Schema: configuracion; Owner: postgres
--

CREATE SEQUENCE configuracion.parametros_configuracion_id_parametro_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE configuracion.parametros_configuracion_id_parametro_seq OWNER TO postgres;

--
-- TOC entry 4740 (class 0 OID 0)
-- Dependencies: 325
-- Name: parametros_configuracion_id_parametro_seq; Type: SEQUENCE OWNED BY; Schema: configuracion; Owner: postgres
--

ALTER SEQUENCE configuracion.parametros_configuracion_id_parametro_seq OWNED BY configuracion.parametros_configuracion.id_parametro;


--
-- TOC entry 320 (class 1259 OID 47253)
-- Name: regla_documento_comprobante; Type: TABLE; Schema: configuracion; Owner: postgres
--

CREATE TABLE configuracion.regla_documento_comprobante (
    id_relacion bigint NOT NULL,
    codigo_documento character varying(10) NOT NULL,
    id_tipo_comprobante bigint NOT NULL,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp with time zone DEFAULT now() NOT NULL,
    usuario_creacion character varying(100) DEFAULT 'SYSTEM'::character varying NOT NULL,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(100)
);


ALTER TABLE configuracion.regla_documento_comprobante OWNER TO postgres;

--
-- TOC entry 319 (class 1259 OID 47252)
-- Name: regla_documento_comprobante_id_relacion_seq; Type: SEQUENCE; Schema: configuracion; Owner: postgres
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
-- TOC entry 252 (class 1259 OID 46386)
-- Name: series_comprobantes; Type: TABLE; Schema: configuracion; Owner: postgres
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


ALTER TABLE configuracion.series_comprobantes OWNER TO postgres;

--
-- TOC entry 4741 (class 0 OID 0)
-- Dependencies: 252
-- Name: TABLE series_comprobantes; Type: COMMENT; Schema: configuracion; Owner: postgres
--

COMMENT ON TABLE configuracion.series_comprobantes IS 'Gestión de series y correlativos para facturación';


--
-- TOC entry 253 (class 1259 OID 46393)
-- Name: series_comprobantes_id_serie_seq; Type: SEQUENCE; Schema: configuracion; Owner: postgres
--

CREATE SEQUENCE configuracion.series_comprobantes_id_serie_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE configuracion.series_comprobantes_id_serie_seq OWNER TO postgres;

--
-- TOC entry 4742 (class 0 OID 0)
-- Dependencies: 253
-- Name: series_comprobantes_id_serie_seq; Type: SEQUENCE OWNED BY; Schema: configuracion; Owner: postgres
--

ALTER SEQUENCE configuracion.series_comprobantes_id_serie_seq OWNED BY configuracion.series_comprobantes.id_serie;


--
-- TOC entry 322 (class 1259 OID 47315)
-- Name: sucursales; Type: TABLE; Schema: configuracion; Owner: postgres
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


ALTER TABLE configuracion.sucursales OWNER TO postgres;

--
-- TOC entry 321 (class 1259 OID 47314)
-- Name: sucursales_id_sucursal_seq; Type: SEQUENCE; Schema: configuracion; Owner: postgres
--

CREATE SEQUENCE configuracion.sucursales_id_sucursal_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE configuracion.sucursales_id_sucursal_seq OWNER TO postgres;

--
-- TOC entry 4743 (class 0 OID 0)
-- Dependencies: 321
-- Name: sucursales_id_sucursal_seq; Type: SEQUENCE OWNED BY; Schema: configuracion; Owner: postgres
--

ALTER SEQUENCE configuracion.sucursales_id_sucursal_seq OWNED BY configuracion.sucursales.id_sucursal;


--
-- TOC entry 254 (class 1259 OID 46394)
-- Name: tablas_generales; Type: TABLE; Schema: configuracion; Owner: postgres
--

CREATE TABLE configuracion.tablas_generales (
    id_tabla bigint NOT NULL,
    codigo character varying(50) NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion text,
    es_sistema boolean DEFAULT false NOT NULL,
    fecha_creacion timestamp with time zone DEFAULT now() NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(100),
    activado boolean DEFAULT true NOT NULL
);


ALTER TABLE configuracion.tablas_generales OWNER TO postgres;

--
-- TOC entry 255 (class 1259 OID 46402)
-- Name: tablas_generales_detalle; Type: TABLE; Schema: configuracion; Owner: postgres
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
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(100),
    activado boolean DEFAULT true NOT NULL
);


ALTER TABLE configuracion.tablas_generales_detalle OWNER TO postgres;

--
-- TOC entry 256 (class 1259 OID 46411)
-- Name: tablas_generales_detalle_id_detalle_seq; Type: SEQUENCE; Schema: configuracion; Owner: postgres
--

CREATE SEQUENCE configuracion.tablas_generales_detalle_id_detalle_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE configuracion.tablas_generales_detalle_id_detalle_seq OWNER TO postgres;

--
-- TOC entry 4744 (class 0 OID 0)
-- Dependencies: 256
-- Name: tablas_generales_detalle_id_detalle_seq; Type: SEQUENCE OWNED BY; Schema: configuracion; Owner: postgres
--

ALTER SEQUENCE configuracion.tablas_generales_detalle_id_detalle_seq OWNED BY configuracion.tablas_generales_detalle.id_detalle;


--
-- TOC entry 257 (class 1259 OID 46412)
-- Name: tablas_generales_id_tabla_seq; Type: SEQUENCE; Schema: configuracion; Owner: postgres
--

CREATE SEQUENCE configuracion.tablas_generales_id_tabla_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE configuracion.tablas_generales_id_tabla_seq OWNER TO postgres;

--
-- TOC entry 4745 (class 0 OID 0)
-- Dependencies: 257
-- Name: tablas_generales_id_tabla_seq; Type: SEQUENCE OWNED BY; Schema: configuracion; Owner: postgres
--

ALTER SEQUENCE configuracion.tablas_generales_id_tabla_seq OWNED BY configuracion.tablas_generales.id_tabla;


--
-- TOC entry 334 (class 1259 OID 47695)
-- Name: tipo_afectacion_igv; Type: TABLE; Schema: configuracion; Owner: postgres
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
    usuario_modificacion character varying(50),
    id_impuesto bigint
);


ALTER TABLE configuracion.tipo_afectacion_igv OWNER TO postgres;

--
-- TOC entry 333 (class 1259 OID 47694)
-- Name: tipo_afectacion_igv_id_afectacion_seq; Type: SEQUENCE; Schema: configuracion; Owner: postgres
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
-- TOC entry 314 (class 1259 OID 47212)
-- Name: tipo_comprobante; Type: TABLE; Schema: configuracion; Owner: postgres
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
    usuario_creacion character varying(100) DEFAULT 'SYSTEM'::character varying,
    es_emitible boolean DEFAULT true NOT NULL,
    es_referenciable boolean DEFAULT false NOT NULL,
    movimiento_stock_venta character varying(10) DEFAULT 'NEUTRO'::character varying NOT NULL,
    movimiento_stock_compra character varying(10) DEFAULT 'NEUTRO'::character varying NOT NULL,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(100)
);


ALTER TABLE configuracion.tipo_comprobante OWNER TO postgres;

--
-- TOC entry 313 (class 1259 OID 47211)
-- Name: tipo_comprobante_id_tipo_comprobante_seq; Type: SEQUENCE; Schema: configuracion; Owner: postgres
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
-- TOC entry 312 (class 1259 OID 47198)
-- Name: tipo_documento; Type: TABLE; Schema: configuracion; Owner: postgres
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
    usuario_creacion character varying(100) DEFAULT 'SYSTEM'::character varying,
    es_persona_natural boolean DEFAULT false NOT NULL,
    es_empresa boolean DEFAULT false NOT NULL,
    aplica_sin_ruc boolean DEFAULT false NOT NULL,
    es_documento_relacionado boolean DEFAULT false NOT NULL,
    es_documento_identidad boolean DEFAULT true NOT NULL,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(100)
);


ALTER TABLE configuracion.tipo_documento OWNER TO postgres;

--
-- TOC entry 311 (class 1259 OID 47197)
-- Name: tipo_documento_id_regla_seq; Type: SEQUENCE; Schema: configuracion; Owner: postgres
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
-- TOC entry 316 (class 1259 OID 47228)
-- Name: tipo_operacion_sunat; Type: TABLE; Schema: configuracion; Owner: postgres
--

CREATE TABLE configuracion.tipo_operacion_sunat (
    id_tipo_operacion integer NOT NULL,
    codigo character varying(4) NOT NULL,
    nombre character varying(200) NOT NULL,
    activado boolean DEFAULT true,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_creacion character varying(100) DEFAULT 'SYSTEM'::character varying,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(100),
    aplica_factura boolean DEFAULT true,
    aplica_boleta boolean DEFAULT true,
    aplica_nota_credito boolean DEFAULT false,
    aplica_nota_debito boolean DEFAULT false
);


ALTER TABLE configuracion.tipo_operacion_sunat OWNER TO postgres;

--
-- TOC entry 315 (class 1259 OID 47227)
-- Name: tipo_operacion_sunat_id_tipo_operacion_seq; Type: SEQUENCE; Schema: configuracion; Owner: postgres
--

CREATE SEQUENCE configuracion.tipo_operacion_sunat_id_tipo_operacion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE configuracion.tipo_operacion_sunat_id_tipo_operacion_seq OWNER TO postgres;

--
-- TOC entry 4746 (class 0 OID 0)
-- Dependencies: 315
-- Name: tipo_operacion_sunat_id_tipo_operacion_seq; Type: SEQUENCE OWNED BY; Schema: configuracion; Owner: postgres
--

ALTER SEQUENCE configuracion.tipo_operacion_sunat_id_tipo_operacion_seq OWNED BY configuracion.tipo_operacion_sunat.id_tipo_operacion;


--
-- TOC entry 359 (class 1259 OID 66867)
-- Name: ubigeos; Type: TABLE; Schema: configuracion; Owner: postgres
--

CREATE TABLE configuracion.ubigeos (
    codigo character varying(6) NOT NULL,
    nombre character varying(100) NOT NULL,
    nivel smallint NOT NULL,
    parent_id character varying(6),
    id bigint NOT NULL,
    activado boolean NOT NULL,
    fecha_creacion timestamp with time zone NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(100)
);


ALTER TABLE configuracion.ubigeos OWNER TO postgres;

--
-- TOC entry 258 (class 1259 OID 46413)
-- Name: asientos_contables; Type: TABLE; Schema: contabilidad; Owner: postgres
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


ALTER TABLE contabilidad.asientos_contables OWNER TO postgres;

--
-- TOC entry 259 (class 1259 OID 46423)
-- Name: asientos_contables_id_asiento_seq; Type: SEQUENCE; Schema: contabilidad; Owner: postgres
--

CREATE SEQUENCE contabilidad.asientos_contables_id_asiento_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE contabilidad.asientos_contables_id_asiento_seq OWNER TO postgres;

--
-- TOC entry 4747 (class 0 OID 0)
-- Dependencies: 259
-- Name: asientos_contables_id_asiento_seq; Type: SEQUENCE OWNED BY; Schema: contabilidad; Owner: postgres
--

ALTER SEQUENCE contabilidad.asientos_contables_id_asiento_seq OWNED BY contabilidad.asientos_contables.id_asiento;


--
-- TOC entry 260 (class 1259 OID 46424)
-- Name: centros_costo; Type: TABLE; Schema: contabilidad; Owner: postgres
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


ALTER TABLE contabilidad.centros_costo OWNER TO postgres;

--
-- TOC entry 261 (class 1259 OID 46430)
-- Name: centros_costo_id_centro_costo_seq; Type: SEQUENCE; Schema: contabilidad; Owner: postgres
--

CREATE SEQUENCE contabilidad.centros_costo_id_centro_costo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE contabilidad.centros_costo_id_centro_costo_seq OWNER TO postgres;

--
-- TOC entry 4748 (class 0 OID 0)
-- Dependencies: 261
-- Name: centros_costo_id_centro_costo_seq; Type: SEQUENCE OWNED BY; Schema: contabilidad; Owner: postgres
--

ALTER SEQUENCE contabilidad.centros_costo_id_centro_costo_seq OWNED BY contabilidad.centros_costo.id_centro_costo;


--
-- TOC entry 262 (class 1259 OID 46431)
-- Name: detalle_asiento; Type: TABLE; Schema: contabilidad; Owner: postgres
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


ALTER TABLE contabilidad.detalle_asiento OWNER TO postgres;

--
-- TOC entry 263 (class 1259 OID 46436)
-- Name: detalle_asiento_id_detalle_asiento_seq; Type: SEQUENCE; Schema: contabilidad; Owner: postgres
--

CREATE SEQUENCE contabilidad.detalle_asiento_id_detalle_asiento_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE contabilidad.detalle_asiento_id_detalle_asiento_seq OWNER TO postgres;

--
-- TOC entry 4749 (class 0 OID 0)
-- Dependencies: 263
-- Name: detalle_asiento_id_detalle_asiento_seq; Type: SEQUENCE OWNED BY; Schema: contabilidad; Owner: postgres
--

ALTER SEQUENCE contabilidad.detalle_asiento_id_detalle_asiento_seq OWNED BY contabilidad.detalle_asiento.id_detalle_asiento;


--
-- TOC entry 264 (class 1259 OID 46437)
-- Name: plan_cuentas; Type: TABLE; Schema: contabilidad; Owner: postgres
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


ALTER TABLE contabilidad.plan_cuentas OWNER TO postgres;

--
-- TOC entry 265 (class 1259 OID 46445)
-- Name: plan_cuentas_id_cuenta_seq; Type: SEQUENCE; Schema: contabilidad; Owner: postgres
--

CREATE SEQUENCE contabilidad.plan_cuentas_id_cuenta_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE contabilidad.plan_cuentas_id_cuenta_seq OWNER TO postgres;

--
-- TOC entry 4750 (class 0 OID 0)
-- Dependencies: 265
-- Name: plan_cuentas_id_cuenta_seq; Type: SEQUENCE OWNED BY; Schema: contabilidad; Owner: postgres
--

ALTER SEQUENCE contabilidad.plan_cuentas_id_cuenta_seq OWNED BY contabilidad.plan_cuentas.id_cuenta;


--
-- TOC entry 266 (class 1259 OID 46446)
-- Name: areas; Type: TABLE; Schema: identidad; Owner: postgres
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


ALTER TABLE identidad.areas OWNER TO postgres;

--
-- TOC entry 267 (class 1259 OID 46452)
-- Name: areas_id_area_seq; Type: SEQUENCE; Schema: identidad; Owner: postgres
--

CREATE SEQUENCE identidad.areas_id_area_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE identidad.areas_id_area_seq OWNER TO postgres;

--
-- TOC entry 4751 (class 0 OID 0)
-- Dependencies: 267
-- Name: areas_id_area_seq; Type: SEQUENCE OWNED BY; Schema: identidad; Owner: postgres
--

ALTER SEQUENCE identidad.areas_id_area_seq OWNED BY identidad.areas.id_area;


--
-- TOC entry 268 (class 1259 OID 46453)
-- Name: auditoria_accesos; Type: TABLE; Schema: identidad; Owner: postgres
--

CREATE TABLE identidad.auditoria_accesos (
    id_auditoria bigint NOT NULL,
    id_usuario bigint NOT NULL,
    ip_origen character varying(50),
    accion character varying(50) NOT NULL,
    detalles text,
    fecha_evento timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE identidad.auditoria_accesos OWNER TO postgres;

--
-- TOC entry 269 (class 1259 OID 46459)
-- Name: auditoria_accesos_id_auditoria_seq; Type: SEQUENCE; Schema: identidad; Owner: postgres
--

CREATE SEQUENCE identidad.auditoria_accesos_id_auditoria_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE identidad.auditoria_accesos_id_auditoria_seq OWNER TO postgres;

--
-- TOC entry 4752 (class 0 OID 0)
-- Dependencies: 269
-- Name: auditoria_accesos_id_auditoria_seq; Type: SEQUENCE OWNED BY; Schema: identidad; Owner: postgres
--

ALTER SEQUENCE identidad.auditoria_accesos_id_auditoria_seq OWNED BY identidad.auditoria_accesos.id_auditoria;


--
-- TOC entry 270 (class 1259 OID 46460)
-- Name: cargos; Type: TABLE; Schema: identidad; Owner: postgres
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


ALTER TABLE identidad.cargos OWNER TO postgres;

--
-- TOC entry 271 (class 1259 OID 46466)
-- Name: cargos_id_cargo_seq; Type: SEQUENCE; Schema: identidad; Owner: postgres
--

CREATE SEQUENCE identidad.cargos_id_cargo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE identidad.cargos_id_cargo_seq OWNER TO postgres;

--
-- TOC entry 4753 (class 0 OID 0)
-- Dependencies: 271
-- Name: cargos_id_cargo_seq; Type: SEQUENCE OWNED BY; Schema: identidad; Owner: postgres
--

ALTER SEQUENCE identidad.cargos_id_cargo_seq OWNED BY identidad.cargos.id_cargo;


--
-- TOC entry 272 (class 1259 OID 46467)
-- Name: menus; Type: TABLE; Schema: identidad; Owner: postgres
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


ALTER TABLE identidad.menus OWNER TO postgres;

--
-- TOC entry 273 (class 1259 OID 46476)
-- Name: menus_id_menu_seq; Type: SEQUENCE; Schema: identidad; Owner: postgres
--

CREATE SEQUENCE identidad.menus_id_menu_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE identidad.menus_id_menu_seq OWNER TO postgres;

--
-- TOC entry 4754 (class 0 OID 0)
-- Dependencies: 273
-- Name: menus_id_menu_seq; Type: SEQUENCE OWNED BY; Schema: identidad; Owner: postgres
--

ALTER SEQUENCE identidad.menus_id_menu_seq OWNED BY identidad.menus.id_menu;


--
-- TOC entry 274 (class 1259 OID 46477)
-- Name: permisos; Type: TABLE; Schema: identidad; Owner: postgres
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


ALTER TABLE identidad.permisos OWNER TO postgres;

--
-- TOC entry 275 (class 1259 OID 46485)
-- Name: permisos_id_permiso_seq; Type: SEQUENCE; Schema: identidad; Owner: postgres
--

CREATE SEQUENCE identidad.permisos_id_permiso_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE identidad.permisos_id_permiso_seq OWNER TO postgres;

--
-- TOC entry 4755 (class 0 OID 0)
-- Dependencies: 275
-- Name: permisos_id_permiso_seq; Type: SEQUENCE OWNED BY; Schema: identidad; Owner: postgres
--

ALTER SEQUENCE identidad.permisos_id_permiso_seq OWNED BY identidad.permisos.id_permiso;


--
-- TOC entry 276 (class 1259 OID 46486)
-- Name: roles; Type: TABLE; Schema: identidad; Owner: postgres
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


ALTER TABLE identidad.roles OWNER TO postgres;

--
-- TOC entry 4756 (class 0 OID 0)
-- Dependencies: 276
-- Name: TABLE roles; Type: COMMENT; Schema: identidad; Owner: postgres
--

COMMENT ON TABLE identidad.roles IS 'Roles de usuario (ej: Admin, Cajero)';


--
-- TOC entry 277 (class 1259 OID 46494)
-- Name: roles_id_rol_seq; Type: SEQUENCE; Schema: identidad; Owner: postgres
--

CREATE SEQUENCE identidad.roles_id_rol_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE identidad.roles_id_rol_seq OWNER TO postgres;

--
-- TOC entry 4757 (class 0 OID 0)
-- Dependencies: 277
-- Name: roles_id_rol_seq; Type: SEQUENCE OWNED BY; Schema: identidad; Owner: postgres
--

ALTER SEQUENCE identidad.roles_id_rol_seq OWNED BY identidad.roles.id_rol;


--
-- TOC entry 278 (class 1259 OID 46495)
-- Name: roles_menus; Type: TABLE; Schema: identidad; Owner: postgres
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


ALTER TABLE identidad.roles_menus OWNER TO postgres;

--
-- TOC entry 279 (class 1259 OID 46501)
-- Name: roles_menus_id_rol_menu_seq; Type: SEQUENCE; Schema: identidad; Owner: postgres
--

CREATE SEQUENCE identidad.roles_menus_id_rol_menu_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE identidad.roles_menus_id_rol_menu_seq OWNER TO postgres;

--
-- TOC entry 4758 (class 0 OID 0)
-- Dependencies: 279
-- Name: roles_menus_id_rol_menu_seq; Type: SEQUENCE OWNED BY; Schema: identidad; Owner: postgres
--

ALTER SEQUENCE identidad.roles_menus_id_rol_menu_seq OWNED BY identidad.roles_menus.id_rol_menu;


--
-- TOC entry 280 (class 1259 OID 46502)
-- Name: roles_menus_permisos; Type: TABLE; Schema: identidad; Owner: postgres
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


ALTER TABLE identidad.roles_menus_permisos OWNER TO postgres;

--
-- TOC entry 281 (class 1259 OID 46508)
-- Name: roles_menus_permisos_id_rol_menu_permiso_seq; Type: SEQUENCE; Schema: identidad; Owner: postgres
--

CREATE SEQUENCE identidad.roles_menus_permisos_id_rol_menu_permiso_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE identidad.roles_menus_permisos_id_rol_menu_permiso_seq OWNER TO postgres;

--
-- TOC entry 4759 (class 0 OID 0)
-- Dependencies: 281
-- Name: roles_menus_permisos_id_rol_menu_permiso_seq; Type: SEQUENCE OWNED BY; Schema: identidad; Owner: postgres
--

ALTER SEQUENCE identidad.roles_menus_permisos_id_rol_menu_permiso_seq OWNED BY identidad.roles_menus_permisos.id_rol_menu_permiso;


--
-- TOC entry 282 (class 1259 OID 46509)
-- Name: roles_permisos; Type: TABLE; Schema: identidad; Owner: postgres
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


ALTER TABLE identidad.roles_permisos OWNER TO postgres;

--
-- TOC entry 283 (class 1259 OID 46515)
-- Name: tipos_permiso; Type: TABLE; Schema: identidad; Owner: postgres
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


ALTER TABLE identidad.tipos_permiso OWNER TO postgres;

--
-- TOC entry 284 (class 1259 OID 46523)
-- Name: tipos_permiso_id_tipo_permiso_seq; Type: SEQUENCE; Schema: identidad; Owner: postgres
--

CREATE SEQUENCE identidad.tipos_permiso_id_tipo_permiso_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE identidad.tipos_permiso_id_tipo_permiso_seq OWNER TO postgres;

--
-- TOC entry 4760 (class 0 OID 0)
-- Dependencies: 284
-- Name: tipos_permiso_id_tipo_permiso_seq; Type: SEQUENCE OWNED BY; Schema: identidad; Owner: postgres
--

ALTER SEQUENCE identidad.tipos_permiso_id_tipo_permiso_seq OWNED BY identidad.tipos_permiso.id_tipo_permiso;


--
-- TOC entry 285 (class 1259 OID 46524)
-- Name: trabajadores; Type: TABLE; Schema: identidad; Owner: postgres
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


ALTER TABLE identidad.trabajadores OWNER TO postgres;

--
-- TOC entry 286 (class 1259 OID 46532)
-- Name: trabajadores_id_trabajador_seq; Type: SEQUENCE; Schema: identidad; Owner: postgres
--

CREATE SEQUENCE identidad.trabajadores_id_trabajador_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE identidad.trabajadores_id_trabajador_seq OWNER TO postgres;

--
-- TOC entry 4761 (class 0 OID 0)
-- Dependencies: 286
-- Name: trabajadores_id_trabajador_seq; Type: SEQUENCE OWNED BY; Schema: identidad; Owner: postgres
--

ALTER SEQUENCE identidad.trabajadores_id_trabajador_seq OWNED BY identidad.trabajadores.id_trabajador;


--
-- TOC entry 287 (class 1259 OID 46533)
-- Name: usuarios; Type: TABLE; Schema: identidad; Owner: postgres
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


ALTER TABLE identidad.usuarios OWNER TO postgres;

--
-- TOC entry 4762 (class 0 OID 0)
-- Dependencies: 287
-- Name: TABLE usuarios; Type: COMMENT; Schema: identidad; Owner: postgres
--

COMMENT ON TABLE identidad.usuarios IS 'Usuarios del sistema con acceso al backend';


--
-- TOC entry 288 (class 1259 OID 46541)
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE; Schema: identidad; Owner: postgres
--

CREATE SEQUENCE identidad.usuarios_id_usuario_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE identidad.usuarios_id_usuario_seq OWNER TO postgres;

--
-- TOC entry 4763 (class 0 OID 0)
-- Dependencies: 288
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE OWNED BY; Schema: identidad; Owner: postgres
--

ALTER SEQUENCE identidad.usuarios_id_usuario_seq OWNED BY identidad.usuarios.id_usuario;


--
-- TOC entry 289 (class 1259 OID 46542)
-- Name: usuarios_roles; Type: TABLE; Schema: identidad; Owner: postgres
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


ALTER TABLE identidad.usuarios_roles OWNER TO postgres;

--
-- TOC entry 290 (class 1259 OID 46548)
-- Name: usuarios_roles_id_usuario_rol_seq; Type: SEQUENCE; Schema: identidad; Owner: postgres
--

CREATE SEQUENCE identidad.usuarios_roles_id_usuario_rol_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE identidad.usuarios_roles_id_usuario_rol_seq OWNER TO postgres;

--
-- TOC entry 4764 (class 0 OID 0)
-- Dependencies: 290
-- Name: usuarios_roles_id_usuario_rol_seq; Type: SEQUENCE OWNED BY; Schema: identidad; Owner: postgres
--

ALTER SEQUENCE identidad.usuarios_roles_id_usuario_rol_seq OWNED BY identidad.usuarios_roles.id_usuario_rol;


--
-- TOC entry 291 (class 1259 OID 46549)
-- Name: almacenes; Type: TABLE; Schema: inventario; Owner: postgres
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


ALTER TABLE inventario.almacenes OWNER TO postgres;

--
-- TOC entry 4765 (class 0 OID 0)
-- Dependencies: 291
-- Name: COLUMN almacenes.id_sucursal; Type: COMMENT; Schema: inventario; Owner: postgres
--

COMMENT ON COLUMN inventario.almacenes.id_sucursal IS 'ID de la sucursal a la que pertenece el almacÃ©n';


--
-- TOC entry 292 (class 1259 OID 46558)
-- Name: almacenes_id_almacen_seq; Type: SEQUENCE; Schema: inventario; Owner: postgres
--

CREATE SEQUENCE inventario.almacenes_id_almacen_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE inventario.almacenes_id_almacen_seq OWNER TO postgres;

--
-- TOC entry 4766 (class 0 OID 0)
-- Dependencies: 292
-- Name: almacenes_id_almacen_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: postgres
--

ALTER SEQUENCE inventario.almacenes_id_almacen_seq OWNED BY inventario.almacenes.id_almacen;


--
-- TOC entry 349 (class 1259 OID 66587)
-- Name: inv_kardex_lote; Type: TABLE; Schema: inventario; Owner: postgres
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


ALTER TABLE inventario.inv_kardex_lote OWNER TO postgres;

--
-- TOC entry 348 (class 1259 OID 66586)
-- Name: inv_kardex_lote_id_seq; Type: SEQUENCE; Schema: inventario; Owner: postgres
--

CREATE SEQUENCE inventario.inv_kardex_lote_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE inventario.inv_kardex_lote_id_seq OWNER TO postgres;

--
-- TOC entry 4767 (class 0 OID 0)
-- Dependencies: 348
-- Name: inv_kardex_lote_id_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: postgres
--

ALTER SEQUENCE inventario.inv_kardex_lote_id_seq OWNED BY inventario.inv_kardex_lote.id;


--
-- TOC entry 351 (class 1259 OID 66598)
-- Name: inv_kardex_movimiento; Type: TABLE; Schema: inventario; Owner: postgres
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


ALTER TABLE inventario.inv_kardex_movimiento OWNER TO postgres;

--
-- TOC entry 350 (class 1259 OID 66597)
-- Name: inv_kardex_movimiento_id_seq; Type: SEQUENCE; Schema: inventario; Owner: postgres
--

CREATE SEQUENCE inventario.inv_kardex_movimiento_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE inventario.inv_kardex_movimiento_id_seq OWNER TO postgres;

--
-- TOC entry 4768 (class 0 OID 0)
-- Dependencies: 350
-- Name: inv_kardex_movimiento_id_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: postgres
--

ALTER SEQUENCE inventario.inv_kardex_movimiento_id_seq OWNED BY inventario.inv_kardex_movimiento.id;


--
-- TOC entry 352 (class 1259 OID 66610)
-- Name: inv_kardex_periodo_control; Type: TABLE; Schema: inventario; Owner: postgres
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


ALTER TABLE inventario.inv_kardex_periodo_control OWNER TO postgres;

--
-- TOC entry 354 (class 1259 OID 66618)
-- Name: inv_kardex_recalculo_log; Type: TABLE; Schema: inventario; Owner: postgres
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


ALTER TABLE inventario.inv_kardex_recalculo_log OWNER TO postgres;

--
-- TOC entry 353 (class 1259 OID 66617)
-- Name: inv_kardex_recalculo_log_id_seq; Type: SEQUENCE; Schema: inventario; Owner: postgres
--

CREATE SEQUENCE inventario.inv_kardex_recalculo_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE inventario.inv_kardex_recalculo_log_id_seq OWNER TO postgres;

--
-- TOC entry 4769 (class 0 OID 0)
-- Dependencies: 353
-- Name: inv_kardex_recalculo_log_id_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: postgres
--

ALTER SEQUENCE inventario.inv_kardex_recalculo_log_id_seq OWNED BY inventario.inv_kardex_recalculo_log.id;


--
-- TOC entry 293 (class 1259 OID 46559)
-- Name: movimientos_inventario; Type: TABLE; Schema: inventario; Owner: postgres
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


ALTER TABLE inventario.movimientos_inventario OWNER TO postgres;

--
-- TOC entry 4770 (class 0 OID 0)
-- Dependencies: 293
-- Name: COLUMN movimientos_inventario.saldo_cantidad; Type: COMMENT; Schema: inventario; Owner: postgres
--

COMMENT ON COLUMN inventario.movimientos_inventario.saldo_cantidad IS 'Cantidad acumulada en stock luego del movimiento';


--
-- TOC entry 4771 (class 0 OID 0)
-- Dependencies: 293
-- Name: COLUMN movimientos_inventario.saldo_valorizado; Type: COMMENT; Schema: inventario; Owner: postgres
--

COMMENT ON COLUMN inventario.movimientos_inventario.saldo_valorizado IS 'Valor monetario acumulado del stock luego del movimiento';


--
-- TOC entry 4772 (class 0 OID 0)
-- Dependencies: 293
-- Name: COLUMN movimientos_inventario.costo_promedio_actual; Type: COMMENT; Schema: inventario; Owner: postgres
--

COMMENT ON COLUMN inventario.movimientos_inventario.costo_promedio_actual IS 'Costo promedio ponderado calculado al momento del movimiento';


--
-- TOC entry 294 (class 1259 OID 46565)
-- Name: movimientos_inventario_id_movimiento_seq; Type: SEQUENCE; Schema: inventario; Owner: postgres
--

CREATE SEQUENCE inventario.movimientos_inventario_id_movimiento_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE inventario.movimientos_inventario_id_movimiento_seq OWNER TO postgres;

--
-- TOC entry 4773 (class 0 OID 0)
-- Dependencies: 294
-- Name: movimientos_inventario_id_movimiento_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: postgres
--

ALTER SEQUENCE inventario.movimientos_inventario_id_movimiento_seq OWNED BY inventario.movimientos_inventario.id_movimiento;


--
-- TOC entry 295 (class 1259 OID 46566)
-- Name: stock; Type: TABLE; Schema: inventario; Owner: postgres
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


ALTER TABLE inventario.stock OWNER TO postgres;

--
-- TOC entry 296 (class 1259 OID 46572)
-- Name: stock_id_stock_seq; Type: SEQUENCE; Schema: inventario; Owner: postgres
--

CREATE SEQUENCE inventario.stock_id_stock_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE inventario.stock_id_stock_seq OWNER TO postgres;

--
-- TOC entry 4774 (class 0 OID 0)
-- Dependencies: 296
-- Name: stock_id_stock_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: postgres
--

ALTER SEQUENCE inventario.stock_id_stock_seq OWNED BY inventario.stock.id_stock;


--
-- TOC entry 328 (class 1259 OID 47568)
-- Name: traslados; Type: TABLE; Schema: inventario; Owner: postgres
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


ALTER TABLE inventario.traslados OWNER TO postgres;

--
-- TOC entry 330 (class 1259 OID 47581)
-- Name: traslados_detalle; Type: TABLE; Schema: inventario; Owner: postgres
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


ALTER TABLE inventario.traslados_detalle OWNER TO postgres;

--
-- TOC entry 329 (class 1259 OID 47580)
-- Name: traslados_detalle_id_detalle_traslado_seq; Type: SEQUENCE; Schema: inventario; Owner: postgres
--

CREATE SEQUENCE inventario.traslados_detalle_id_detalle_traslado_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE inventario.traslados_detalle_id_detalle_traslado_seq OWNER TO postgres;

--
-- TOC entry 4775 (class 0 OID 0)
-- Dependencies: 329
-- Name: traslados_detalle_id_detalle_traslado_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: postgres
--

ALTER SEQUENCE inventario.traslados_detalle_id_detalle_traslado_seq OWNED BY inventario.traslados_detalle.id_detalle_traslado;


--
-- TOC entry 327 (class 1259 OID 47567)
-- Name: traslados_id_traslado_seq; Type: SEQUENCE; Schema: inventario; Owner: postgres
--

CREATE SEQUENCE inventario.traslados_id_traslado_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE inventario.traslados_id_traslado_seq OWNER TO postgres;

--
-- TOC entry 4776 (class 0 OID 0)
-- Dependencies: 327
-- Name: traslados_id_traslado_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: postgres
--

ALTER SEQUENCE inventario.traslados_id_traslado_seq OWNED BY inventario.traslados.id_traslado;


--
-- TOC entry 332 (class 1259 OID 47597)
-- Name: traslados_incidencias; Type: TABLE; Schema: inventario; Owner: postgres
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


ALTER TABLE inventario.traslados_incidencias OWNER TO postgres;

--
-- TOC entry 331 (class 1259 OID 47596)
-- Name: traslados_incidencias_id_incidencia_seq; Type: SEQUENCE; Schema: inventario; Owner: postgres
--

CREATE SEQUENCE inventario.traslados_incidencias_id_incidencia_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE inventario.traslados_incidencias_id_incidencia_seq OWNER TO postgres;

--
-- TOC entry 4777 (class 0 OID 0)
-- Dependencies: 331
-- Name: traslados_incidencias_id_incidencia_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: postgres
--

ALTER SEQUENCE inventario.traslados_incidencias_id_incidencia_seq OWNED BY inventario.traslados_incidencias.id_incidencia;


--
-- TOC entry 219 (class 1259 OID 16755)
-- Name: __EFMigrationsHistory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."__EFMigrationsHistory" (
    migration_id character varying(150) NOT NULL,
    product_version character varying(32) NOT NULL
);


ALTER TABLE public."__EFMigrationsHistory" OWNER TO postgres;

--
-- TOC entry 341 (class 1259 OID 62619)
-- Name: categorias; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.categorias OWNER TO postgres;

--
-- TOC entry 340 (class 1259 OID 62618)
-- Name: categorias_Id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
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
-- TOC entry 343 (class 1259 OID 62632)
-- Name: marcas; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.marcas OWNER TO postgres;

--
-- TOC entry 342 (class 1259 OID 62631)
-- Name: marcas_Id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
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
-- TOC entry 347 (class 1259 OID 62648)
-- Name: productos; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.productos OWNER TO postgres;

--
-- TOC entry 346 (class 1259 OID 62647)
-- Name: productos_Id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
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
-- TOC entry 345 (class 1259 OID 62640)
-- Name: unidades_medida; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.unidades_medida OWNER TO postgres;

--
-- TOC entry 344 (class 1259 OID 62639)
-- Name: unidades_medida_Id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
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
-- TOC entry 385 (class 1259 OID 67289)
-- Name: cat_estado_cpe; Type: TABLE; Schema: sunat; Owner: postgres
--

CREATE TABLE sunat.cat_estado_cpe (
    id_estado character varying(20) NOT NULL,
    descripcion character varying(100) NOT NULL,
    es_final boolean DEFAULT false NOT NULL,
    permite_reenvio boolean DEFAULT false NOT NULL,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    usuario_creacion character varying(50) DEFAULT 'sistema'::character varying NOT NULL,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(50)
);


ALTER TABLE sunat.cat_estado_cpe OWNER TO postgres;

--
-- TOC entry 387 (class 1259 OID 67300)
-- Name: log_envio_cpe; Type: TABLE; Schema: sunat; Owner: postgres
--

CREATE TABLE sunat.log_envio_cpe (
    id_log bigint NOT NULL,
    id_venta bigint,
    id_nota_credito bigint,
    id_nota_debito bigint,
    tipo_documento character varying(10) NOT NULL,
    fecha_envio timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    xml_enviado text,
    xml_respuesta text,
    codigo_respuesta character varying(50),
    mensaje_respuesta text,
    ticket character varying(100),
    id_estado_cpe character varying(20),
    exito boolean DEFAULT false NOT NULL,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    usuario_creacion character varying(50) DEFAULT 'sistema'::character varying NOT NULL,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(50),
    CONSTRAINT chk_log_envio_unico_doc CHECK ((((id_venta IS NOT NULL) AND (id_nota_credito IS NULL) AND (id_nota_debito IS NULL)) OR ((id_venta IS NULL) AND (id_nota_credito IS NOT NULL) AND (id_nota_debito IS NULL)) OR ((id_venta IS NULL) AND (id_nota_credito IS NULL) AND (id_nota_debito IS NOT NULL)))),
    CONSTRAINT chk_tipo_doc_log CHECK (((tipo_documento)::text = ANY ((ARRAY['VENTA'::character varying, 'NC'::character varying, 'ND'::character varying])::text[])))
);


ALTER TABLE sunat.log_envio_cpe OWNER TO postgres;

--
-- TOC entry 386 (class 1259 OID 67299)
-- Name: log_envio_cpe_id_log_seq; Type: SEQUENCE; Schema: sunat; Owner: postgres
--

CREATE SEQUENCE sunat.log_envio_cpe_id_log_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sunat.log_envio_cpe_id_log_seq OWNER TO postgres;

--
-- TOC entry 4778 (class 0 OID 0)
-- Dependencies: 386
-- Name: log_envio_cpe_id_log_seq; Type: SEQUENCE OWNED BY; Schema: sunat; Owner: postgres
--

ALTER SEQUENCE sunat.log_envio_cpe_id_log_seq OWNED BY sunat.log_envio_cpe.id_log;


--
-- TOC entry 297 (class 1259 OID 46573)
-- Name: cajas; Type: TABLE; Schema: ventas; Owner: postgres
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


ALTER TABLE ventas.cajas OWNER TO postgres;

--
-- TOC entry 298 (class 1259 OID 46581)
-- Name: cajas_id_caja_seq; Type: SEQUENCE; Schema: ventas; Owner: postgres
--

CREATE SEQUENCE ventas.cajas_id_caja_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ventas.cajas_id_caja_seq OWNER TO postgres;

--
-- TOC entry 4779 (class 0 OID 0)
-- Dependencies: 298
-- Name: cajas_id_caja_seq; Type: SEQUENCE OWNED BY; Schema: ventas; Owner: postgres
--

ALTER SEQUENCE ventas.cajas_id_caja_seq OWNED BY ventas.cajas.id_caja;


--
-- TOC entry 299 (class 1259 OID 46582)
-- Name: cotizaciones; Type: TABLE; Schema: ventas; Owner: postgres
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


ALTER TABLE ventas.cotizaciones OWNER TO postgres;

--
-- TOC entry 300 (class 1259 OID 46595)
-- Name: cotizaciones_id_cotizacion_seq; Type: SEQUENCE; Schema: ventas; Owner: postgres
--

CREATE SEQUENCE ventas.cotizaciones_id_cotizacion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ventas.cotizaciones_id_cotizacion_seq OWNER TO postgres;

--
-- TOC entry 4780 (class 0 OID 0)
-- Dependencies: 300
-- Name: cotizaciones_id_cotizacion_seq; Type: SEQUENCE OWNED BY; Schema: ventas; Owner: postgres
--

ALTER SEQUENCE ventas.cotizaciones_id_cotizacion_seq OWNED BY ventas.cotizaciones.id_cotizacion;


--
-- TOC entry 301 (class 1259 OID 46596)
-- Name: detalle_cotizacion; Type: TABLE; Schema: ventas; Owner: postgres
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
    usuario_modificacion character varying(100)
);


ALTER TABLE ventas.detalle_cotizacion OWNER TO postgres;

--
-- TOC entry 302 (class 1259 OID 46601)
-- Name: detalle_cotizacion_id_detalle_cot_seq; Type: SEQUENCE; Schema: ventas; Owner: postgres
--

CREATE SEQUENCE ventas.detalle_cotizacion_id_detalle_cot_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ventas.detalle_cotizacion_id_detalle_cot_seq OWNER TO postgres;

--
-- TOC entry 4781 (class 0 OID 0)
-- Dependencies: 302
-- Name: detalle_cotizacion_id_detalle_cot_seq; Type: SEQUENCE OWNED BY; Schema: ventas; Owner: postgres
--

ALTER SEQUENCE ventas.detalle_cotizacion_id_detalle_cot_seq OWNED BY ventas.detalle_cotizacion.id_detalle_cot;


--
-- TOC entry 303 (class 1259 OID 46602)
-- Name: detalle_venta; Type: TABLE; Schema: ventas; Owner: postgres
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
    activado boolean DEFAULT true NOT NULL,
    id_unidad_medida bigint,
    numero_linea integer,
    codigo_producto_sunat character varying(20),
    codigo_producto_vendedor character varying(50),
    id_afectacion_igv bigint,
    id_tributo bigint
);


ALTER TABLE ventas.detalle_venta OWNER TO postgres;

--
-- TOC entry 4782 (class 0 OID 0)
-- Dependencies: 303
-- Name: COLUMN detalle_venta.codigo_afectacion_igv; Type: COMMENT; Schema: ventas; Owner: postgres
--

COMMENT ON COLUMN ventas.detalle_venta.codigo_afectacion_igv IS 'Código SUNAT de afectación (10, 20, 30, etc)';


--
-- TOC entry 4783 (class 0 OID 0)
-- Dependencies: 303
-- Name: COLUMN detalle_venta.codigo_tributo; Type: COMMENT; Schema: ventas; Owner: postgres
--

COMMENT ON COLUMN ventas.detalle_venta.codigo_tributo IS 'Código SUNAT del tributo (1000 IGV, 9997 EXONERADO, etc)';


--
-- TOC entry 304 (class 1259 OID 46607)
-- Name: detalle_venta_id_detalle_venta_seq; Type: SEQUENCE; Schema: ventas; Owner: postgres
--

CREATE SEQUENCE ventas.detalle_venta_id_detalle_venta_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ventas.detalle_venta_id_detalle_venta_seq OWNER TO postgres;

--
-- TOC entry 4784 (class 0 OID 0)
-- Dependencies: 304
-- Name: detalle_venta_id_detalle_venta_seq; Type: SEQUENCE OWNED BY; Schema: ventas; Owner: postgres
--

ALTER SEQUENCE ventas.detalle_venta_id_detalle_venta_seq OWNED BY ventas.detalle_venta.id_detalle_venta;


--
-- TOC entry 305 (class 1259 OID 46616)
-- Name: movimientos_caja; Type: TABLE; Schema: ventas; Owner: postgres
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
    usuario_modificacion character varying(100)
);


ALTER TABLE ventas.movimientos_caja OWNER TO postgres;

--
-- TOC entry 306 (class 1259 OID 46620)
-- Name: movimientos_caja_id_movimiento_caja_seq; Type: SEQUENCE; Schema: ventas; Owner: postgres
--

CREATE SEQUENCE ventas.movimientos_caja_id_movimiento_caja_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ventas.movimientos_caja_id_movimiento_caja_seq OWNER TO postgres;

--
-- TOC entry 4785 (class 0 OID 0)
-- Dependencies: 306
-- Name: movimientos_caja_id_movimiento_caja_seq; Type: SEQUENCE OWNED BY; Schema: ventas; Owner: postgres
--

ALTER SEQUENCE ventas.movimientos_caja_id_movimiento_caja_seq OWNED BY ventas.movimientos_caja.id_movimiento_caja;


--
-- TOC entry 369 (class 1259 OID 66969)
-- Name: nota_credito; Type: TABLE; Schema: ventas; Owner: postgres
--

CREATE TABLE ventas.nota_credito (
    id_nota bigint NOT NULL,
    serie character varying(4) NOT NULL,
    numero bigint NOT NULL,
    tipo_comprobante character varying(2) NOT NULL,
    id_venta_referencia bigint NOT NULL,
    serie_referencia character varying(4) NOT NULL,
    numero_referencia bigint NOT NULL,
    tipo_doc_referencia character varying(2) NOT NULL,
    id_tipo_nota bigint NOT NULL,
    motivo_sustento text NOT NULL,
    cliente_tipo_doc character varying(2) NOT NULL,
    cliente_nro_doc character varying(15) NOT NULL,
    cliente_razon_social character varying(250) NOT NULL,
    subtotal numeric(12,2) NOT NULL,
    igv numeric(12,2) NOT NULL,
    total numeric(12,2) NOT NULL,
    porcentaje_igv numeric(5,2) NOT NULL,
    moneda character varying(3) NOT NULL,
    tipo_cambio numeric(10,4),
    afecta_stock boolean NOT NULL,
    fecha_emision date NOT NULL,
    estado character varying(20) NOT NULL,
    fecha_envio_sunat timestamp with time zone,
    respuesta_sunat_codigo character varying(10),
    respuesta_sunat_desc text,
    hash_cdr text,
    xml_generado text,
    activado boolean NOT NULL,
    fecha_creacion timestamp with time zone NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(100),
    id_tipo_operacion bigint,
    hash_cpe text,
    subtotal_gravado numeric(18,2) DEFAULT 0,
    subtotal_exonerado numeric(18,2) DEFAULT 0,
    subtotal_inafecto numeric(18,2) DEFAULT 0,
    id_empresa bigint,
    numero_ticket_sunat character varying(100),
    id_estado_cpe character varying(20)
);


ALTER TABLE ventas.nota_credito OWNER TO postgres;

--
-- TOC entry 373 (class 1259 OID 66995)
-- Name: nota_credito_detalle; Type: TABLE; Schema: ventas; Owner: postgres
--

CREATE TABLE ventas.nota_credito_detalle (
    id_detalle bigint NOT NULL,
    id_nota_credito bigint NOT NULL,
    id_venta_detalle bigint,
    id_producto bigint NOT NULL,
    descripcion character varying(500) NOT NULL,
    unidad_medida character varying(10) NOT NULL,
    cantidad numeric(12,4) NOT NULL,
    precio_unitario numeric(12,4) NOT NULL,
    subtotal numeric(12,2) NOT NULL,
    igv numeric(12,2) NOT NULL,
    total numeric(12,2) NOT NULL,
    activado boolean NOT NULL,
    fecha_creacion timestamp with time zone NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(100),
    id_afectacion_igv bigint,
    id_tributo bigint,
    precio_unitario_base numeric(18,2) DEFAULT 0,
    valor_item numeric(18,2) DEFAULT 0,
    descuento_item numeric(18,2) DEFAULT 0,
    porcentaje_impuesto numeric(5,2) DEFAULT 18.00,
    numero_linea integer,
    id_unidad_medida bigint
);


ALTER TABLE ventas.nota_credito_detalle OWNER TO postgres;

--
-- TOC entry 372 (class 1259 OID 66994)
-- Name: nota_credito_detalle_id_detalle_seq; Type: SEQUENCE; Schema: ventas; Owner: postgres
--

ALTER TABLE ventas.nota_credito_detalle ALTER COLUMN id_detalle ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME ventas.nota_credito_detalle_id_detalle_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 368 (class 1259 OID 66968)
-- Name: nota_credito_id_nota_seq; Type: SEQUENCE; Schema: ventas; Owner: postgres
--

ALTER TABLE ventas.nota_credito ALTER COLUMN id_nota ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME ventas.nota_credito_id_nota_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 371 (class 1259 OID 66982)
-- Name: nota_debito; Type: TABLE; Schema: ventas; Owner: postgres
--

CREATE TABLE ventas.nota_debito (
    id_nota bigint NOT NULL,
    serie character varying(4) NOT NULL,
    numero bigint NOT NULL,
    tipo_comprobante character varying(2) NOT NULL,
    id_venta_referencia bigint NOT NULL,
    serie_referencia character varying(4) NOT NULL,
    numero_referencia bigint NOT NULL,
    tipo_doc_referencia character varying(2) NOT NULL,
    id_tipo_nota bigint NOT NULL,
    motivo_sustento text NOT NULL,
    cliente_tipo_doc character varying(2) NOT NULL,
    cliente_nro_doc character varying(15) NOT NULL,
    cliente_razon_social character varying(250) NOT NULL,
    subtotal numeric(12,2) NOT NULL,
    igv numeric(12,2) NOT NULL,
    total numeric(12,2) NOT NULL,
    porcentaje_igv numeric(5,2) NOT NULL,
    moneda character varying(3) NOT NULL,
    tipo_cambio numeric(10,4),
    afecta_stock boolean NOT NULL,
    fecha_emision date NOT NULL,
    estado character varying(20) NOT NULL,
    fecha_envio_sunat timestamp with time zone,
    respuesta_sunat_codigo character varying(10),
    respuesta_sunat_desc text,
    hash_cdr text,
    xml_generado text,
    activado boolean NOT NULL,
    fecha_creacion timestamp with time zone NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(100),
    id_tipo_operacion bigint,
    hash_cpe text,
    subtotal_gravado numeric(18,2) DEFAULT 0,
    subtotal_exonerado numeric(18,2) DEFAULT 0,
    subtotal_inafecto numeric(18,2) DEFAULT 0,
    id_empresa bigint,
    numero_ticket_sunat character varying(100),
    id_estado_cpe character varying(20)
);


ALTER TABLE ventas.nota_debito OWNER TO postgres;

--
-- TOC entry 375 (class 1259 OID 67013)
-- Name: nota_debito_detalle; Type: TABLE; Schema: ventas; Owner: postgres
--

CREATE TABLE ventas.nota_debito_detalle (
    id_detalle bigint NOT NULL,
    id_nota_debito bigint NOT NULL,
    id_venta_detalle bigint,
    id_producto bigint NOT NULL,
    descripcion character varying(500) NOT NULL,
    unidad_medida character varying(10) NOT NULL,
    cantidad numeric(12,4) NOT NULL,
    precio_unitario numeric(12,4) NOT NULL,
    subtotal numeric(12,2) NOT NULL,
    igv numeric(12,2) NOT NULL,
    total numeric(12,2) NOT NULL,
    activado boolean NOT NULL,
    fecha_creacion timestamp with time zone NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(100),
    id_afectacion_igv bigint,
    id_tributo bigint,
    precio_unitario_base numeric(18,2) DEFAULT 0,
    valor_item numeric(18,2) DEFAULT 0,
    descuento_item numeric(18,2) DEFAULT 0,
    porcentaje_impuesto numeric(5,2) DEFAULT 18.00,
    numero_linea integer,
    id_unidad_medida bigint
);


ALTER TABLE ventas.nota_debito_detalle OWNER TO postgres;

--
-- TOC entry 374 (class 1259 OID 67012)
-- Name: nota_debito_detalle_id_detalle_seq; Type: SEQUENCE; Schema: ventas; Owner: postgres
--

ALTER TABLE ventas.nota_debito_detalle ALTER COLUMN id_detalle ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME ventas.nota_debito_detalle_id_detalle_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 370 (class 1259 OID 66981)
-- Name: nota_debito_id_nota_seq; Type: SEQUENCE; Schema: ventas; Owner: postgres
--

ALTER TABLE ventas.nota_debito ALTER COLUMN id_nota ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME ventas.nota_debito_id_nota_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 307 (class 1259 OID 46621)
-- Name: pagos; Type: TABLE; Schema: ventas; Owner: postgres
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
    usuario_modificacion character varying(100)
);


ALTER TABLE ventas.pagos OWNER TO postgres;

--
-- TOC entry 308 (class 1259 OID 46627)
-- Name: pagos_id_pago_seq; Type: SEQUENCE; Schema: ventas; Owner: postgres
--

CREATE SEQUENCE ventas.pagos_id_pago_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ventas.pagos_id_pago_seq OWNER TO postgres;

--
-- TOC entry 4786 (class 0 OID 0)
-- Dependencies: 308
-- Name: pagos_id_pago_seq; Type: SEQUENCE OWNED BY; Schema: ventas; Owner: postgres
--

ALTER SEQUENCE ventas.pagos_id_pago_seq OWNED BY ventas.pagos.id_pago;


--
-- TOC entry 389 (class 1259 OID 67336)
-- Name: venta_cuota_pago; Type: TABLE; Schema: ventas; Owner: postgres
--

CREATE TABLE ventas.venta_cuota_pago (
    id_cuota bigint NOT NULL,
    id_venta bigint NOT NULL,
    numero_cuota integer NOT NULL,
    monto_cuota numeric(18,2) NOT NULL,
    fecha_vencimiento date NOT NULL,
    fecha_pago date,
    pagado boolean DEFAULT false NOT NULL,
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    usuario_creacion character varying(50) DEFAULT 'sistema'::character varying NOT NULL,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(50)
);


ALTER TABLE ventas.venta_cuota_pago OWNER TO postgres;

--
-- TOC entry 388 (class 1259 OID 67335)
-- Name: venta_cuota_pago_id_cuota_seq; Type: SEQUENCE; Schema: ventas; Owner: postgres
--

CREATE SEQUENCE ventas.venta_cuota_pago_id_cuota_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ventas.venta_cuota_pago_id_cuota_seq OWNER TO postgres;

--
-- TOC entry 4787 (class 0 OID 0)
-- Dependencies: 388
-- Name: venta_cuota_pago_id_cuota_seq; Type: SEQUENCE OWNED BY; Schema: ventas; Owner: postgres
--

ALTER SEQUENCE ventas.venta_cuota_pago_id_cuota_seq OWNED BY ventas.venta_cuota_pago.id_cuota;


--
-- TOC entry 309 (class 1259 OID 46628)
-- Name: ventas; Type: TABLE; Schema: ventas; Owner: postgres
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
    moneda character varying(255) DEFAULT 'PEN'::character varying,
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
    id_tipo_comprobante bigint,
    estado_sunat text DEFAULT ''::text NOT NULL,
    fecha_anulacion timestamp with time zone,
    motivo_anulacion text,
    numero_resumen_baja text,
    id_tipo_operacion bigint,
    forma_pago character varying(20) DEFAULT 'Contado'::character varying,
    total_descuento_item numeric(18,2) DEFAULT 0,
    total_gratuito numeric(18,2) DEFAULT 0,
    hash_cpe text,
    hash_cdr text,
    descripcion_cdr text,
    fecha_envio_sunat timestamp with time zone,
    numero_ticket_sunat character varying(100),
    orden_compra_referencia character varying(50),
    xml_generado text,
    id_estado_cpe character varying(20)
);


ALTER TABLE ventas.ventas OWNER TO postgres;

--
-- TOC entry 310 (class 1259 OID 46645)
-- Name: ventas_id_venta_seq; Type: SEQUENCE; Schema: ventas; Owner: postgres
--

CREATE SEQUENCE ventas.ventas_id_venta_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ventas.ventas_id_venta_seq OWNER TO postgres;

--
-- TOC entry 4788 (class 0 OID 0)
-- Dependencies: 310
-- Name: ventas_id_venta_seq; Type: SEQUENCE OWNED BY; Schema: ventas; Owner: postgres
--

ALTER SEQUENCE ventas.ventas_id_venta_seq OWNED BY ventas.ventas.id_venta;


--
-- TOC entry 381 (class 1259 OID 67061)
-- Name: vw_caja_movimientos; Type: VIEW; Schema: vistas; Owner: postgres
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


ALTER TABLE vistas.vw_caja_movimientos OWNER TO postgres;

--
-- TOC entry 377 (class 1259 OID 67041)
-- Name: vw_detalle_venta; Type: VIEW; Schema: vistas; Owner: postgres
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


ALTER TABLE vistas.vw_detalle_venta OWNER TO postgres;

--
-- TOC entry 379 (class 1259 OID 67051)
-- Name: vw_kardex_movimientos; Type: VIEW; Schema: vistas; Owner: postgres
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


ALTER TABLE vistas.vw_kardex_movimientos OWNER TO postgres;

--
-- TOC entry 378 (class 1259 OID 67046)
-- Name: vw_lista_compras; Type: VIEW; Schema: vistas; Owner: postgres
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


ALTER TABLE vistas.vw_lista_compras OWNER TO postgres;

--
-- TOC entry 376 (class 1259 OID 67036)
-- Name: vw_lista_ventas; Type: VIEW; Schema: vistas; Owner: postgres
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
           FROM (ventas.nota_credito n
             JOIN configuracion.tipo_comprobante tcn ON (((n.tipo_comprobante)::text = (tcn.codigo)::text)))
          WHERE ((n.id_venta_referencia = v.id_venta) AND ((tcn.codigo)::text = '07'::text)))) AS tiene_nota_credito,
    (EXISTS ( SELECT 1
           FROM (ventas.nota_debito n
             JOIN configuracion.tipo_comprobante tcn ON (((n.tipo_comprobante)::text = (tcn.codigo)::text)))
          WHERE ((n.id_venta_referencia = v.id_venta) AND ((tcn.codigo)::text = '08'::text)))) AS tiene_nota_debito
   FROM (((ventas.ventas v
     JOIN clientes.clientes c ON ((v.id_cliente = c.id_cliente)))
     JOIN configuracion.tipo_comprobante tc ON ((v.id_tipo_comprobante = tc.id_tipo_comprobante)))
     LEFT JOIN configuracion.tablas_generales_detalle eg ON ((v.id_estado = eg.id_detalle)));


ALTER TABLE vistas.vw_lista_ventas OWNER TO postgres;

--
-- TOC entry 382 (class 1259 OID 67066)
-- Name: vw_notas_credito_debito; Type: VIEW; Schema: vistas; Owner: postgres
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
    (((n.serie_referencia)::text || '-'::text) || n.numero_referencia) AS comprobante_referencia,
    n.cliente_razon_social AS razon_social_cliente_o_proveedor,
    (n.id_tipo_nota)::character varying AS codigo_motivo,
    n.motivo_sustento AS descripcion_motivo,
    n.afecta_stock AS devuelve_stock,
    n.total AS monto_total,
    n.estado
   FROM (ventas.nota_credito n
     JOIN configuracion.tipo_comprobante tc ON (((n.tipo_comprobante)::text = (tc.codigo)::text)))
UNION ALL
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
    (((n.serie_referencia)::text || '-'::text) || n.numero_referencia) AS comprobante_referencia,
    n.cliente_razon_social AS razon_social_cliente_o_proveedor,
    (n.id_tipo_nota)::character varying AS codigo_motivo,
    n.motivo_sustento AS descripcion_motivo,
    n.afecta_stock AS devuelve_stock,
    n.total AS monto_total,
    n.estado
   FROM (ventas.nota_debito n
     JOIN configuracion.tipo_comprobante tc ON (((n.tipo_comprobante)::text = (tc.codigo)::text)));


ALTER TABLE vistas.vw_notas_credito_debito OWNER TO postgres;

--
-- TOC entry 380 (class 1259 OID 67056)
-- Name: vw_stock_actual; Type: VIEW; Schema: vistas; Owner: postgres
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


ALTER TABLE vistas.vw_stock_actual OWNER TO postgres;

--
-- TOC entry 3626 (class 2604 OID 62924)
-- Name: categorias id_categoria; Type: DEFAULT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.categorias ALTER COLUMN id_categoria SET DEFAULT nextval('catalogo.categorias_id_categoria_seq'::regclass);


--
-- TOC entry 3632 (class 2604 OID 62925)
-- Name: imagenes_producto id_imagen; Type: DEFAULT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.imagenes_producto ALTER COLUMN id_imagen SET DEFAULT nextval('catalogo.imagenes_producto_id_imagen_seq'::regclass);


--
-- TOC entry 3637 (class 2604 OID 62926)
-- Name: listas_precios id_lista_precio; Type: DEFAULT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.listas_precios ALTER COLUMN id_lista_precio SET DEFAULT nextval('catalogo.listas_precios_id_lista_precio_seq'::regclass);


--
-- TOC entry 3641 (class 2604 OID 62927)
-- Name: marcas id_marca; Type: DEFAULT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.marcas ALTER COLUMN id_marca SET DEFAULT nextval('catalogo.marcas_id_marca_seq'::regclass);


--
-- TOC entry 3655 (class 2604 OID 62928)
-- Name: productos id_producto; Type: DEFAULT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.productos ALTER COLUMN id_producto SET DEFAULT nextval('catalogo.productos_id_producto_seq'::regclass);


--
-- TOC entry 3663 (class 2604 OID 62929)
-- Name: unidades_medida id_unidad; Type: DEFAULT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.unidades_medida ALTER COLUMN id_unidad SET DEFAULT nextval('catalogo.unidades_medida_id_unidad_seq'::regclass);


--
-- TOC entry 3668 (class 2604 OID 62930)
-- Name: variantes_producto id_variante; Type: DEFAULT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.variantes_producto ALTER COLUMN id_variante SET DEFAULT nextval('catalogo.variantes_producto_id_variante_seq'::regclass);


--
-- TOC entry 3674 (class 2604 OID 62931)
-- Name: clientes id_cliente; Type: DEFAULT; Schema: clientes; Owner: postgres
--

ALTER TABLE ONLY clientes.clientes ALTER COLUMN id_cliente SET DEFAULT nextval('clientes.clientes_id_cliente_seq'::regclass);


--
-- TOC entry 3682 (class 2604 OID 62932)
-- Name: contactos_cliente id_contacto; Type: DEFAULT; Schema: clientes; Owner: postgres
--

ALTER TABLE ONLY clientes.contactos_cliente ALTER COLUMN id_contacto SET DEFAULT nextval('clientes.contactos_cliente_id_contacto_seq'::regclass);


--
-- TOC entry 3694 (class 2604 OID 62933)
-- Name: compras id_compra; Type: DEFAULT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.compras ALTER COLUMN id_compra SET DEFAULT nextval('compras.compras_id_compra_seq'::regclass);


--
-- TOC entry 3699 (class 2604 OID 62934)
-- Name: detalle_compra id_detalle_compra; Type: DEFAULT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.detalle_compra ALTER COLUMN id_detalle_compra SET DEFAULT nextval('compras.detalle_compra_id_detalle_compra_seq'::regclass);


--
-- TOC entry 3706 (class 2604 OID 62935)
-- Name: detalle_orden_compra id_detalle_oc; Type: DEFAULT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.detalle_orden_compra ALTER COLUMN id_detalle_oc SET DEFAULT nextval('compras.detalle_orden_compra_id_detalle_oc_seq'::regclass);


--
-- TOC entry 3711 (class 2604 OID 62936)
-- Name: ordenes_compra id_orden_compra; Type: DEFAULT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.ordenes_compra ALTER COLUMN id_orden_compra SET DEFAULT nextval('compras.ordenes_compra_id_orden_compra_seq'::regclass);


--
-- TOC entry 3715 (class 2604 OID 62937)
-- Name: proveedores id_proveedor; Type: DEFAULT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.proveedores ALTER COLUMN id_proveedor SET DEFAULT nextval('compras.proveedores_id_proveedor_seq'::regclass);


--
-- TOC entry 3722 (class 2604 OID 62938)
-- Name: configuraciones id_configuracion; Type: DEFAULT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.configuraciones ALTER COLUMN id_configuracion SET DEFAULT nextval('configuracion.configuraciones_id_configuracion_seq'::regclass);


--
-- TOC entry 3727 (class 2604 OID 62939)
-- Name: empresa id_empresa; Type: DEFAULT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.empresa ALTER COLUMN id_empresa SET DEFAULT nextval('configuracion.empresa_id_empresa_seq'::regclass);


--
-- TOC entry 3924 (class 2604 OID 47336)
-- Name: impuestos id_impuesto; Type: DEFAULT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.impuestos ALTER COLUMN id_impuesto SET DEFAULT nextval('configuracion.impuestos_id_impuesto_seq'::regclass);


--
-- TOC entry 3910 (class 2604 OID 47244)
-- Name: matriz_regla_sunat id_regla; Type: DEFAULT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.matriz_regla_sunat ALTER COLUMN id_regla SET DEFAULT nextval('configuracion.matriz_regla_sunat_id_regla_seq'::regclass);


--
-- TOC entry 3929 (class 2604 OID 47348)
-- Name: parametros_configuracion id_parametro; Type: DEFAULT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.parametros_configuracion ALTER COLUMN id_parametro SET DEFAULT nextval('configuracion.parametros_configuracion_id_parametro_seq'::regclass);


--
-- TOC entry 3732 (class 2604 OID 62940)
-- Name: series_comprobantes id_serie; Type: DEFAULT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.series_comprobantes ALTER COLUMN id_serie SET DEFAULT nextval('configuracion.series_comprobantes_id_serie_seq'::regclass);


--
-- TOC entry 3918 (class 2604 OID 47318)
-- Name: sucursales id_sucursal; Type: DEFAULT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.sucursales ALTER COLUMN id_sucursal SET DEFAULT nextval('configuracion.sucursales_id_sucursal_seq'::regclass);


--
-- TOC entry 3736 (class 2604 OID 62941)
-- Name: tablas_generales id_tabla; Type: DEFAULT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.tablas_generales ALTER COLUMN id_tabla SET DEFAULT nextval('configuracion.tablas_generales_id_tabla_seq'::regclass);


--
-- TOC entry 3741 (class 2604 OID 62942)
-- Name: tablas_generales_detalle id_detalle; Type: DEFAULT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.tablas_generales_detalle ALTER COLUMN id_detalle SET DEFAULT nextval('configuracion.tablas_generales_detalle_id_detalle_seq'::regclass);


--
-- TOC entry 3906 (class 2604 OID 47231)
-- Name: tipo_operacion_sunat id_tipo_operacion; Type: DEFAULT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.tipo_operacion_sunat ALTER COLUMN id_tipo_operacion SET DEFAULT nextval('configuracion.tipo_operacion_sunat_id_tipo_operacion_seq'::regclass);


--
-- TOC entry 3747 (class 2604 OID 62943)
-- Name: asientos_contables id_asiento; Type: DEFAULT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.asientos_contables ALTER COLUMN id_asiento SET DEFAULT nextval('contabilidad.asientos_contables_id_asiento_seq'::regclass);


--
-- TOC entry 3751 (class 2604 OID 62944)
-- Name: centros_costo id_centro_costo; Type: DEFAULT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.centros_costo ALTER COLUMN id_centro_costo SET DEFAULT nextval('contabilidad.centros_costo_id_centro_costo_seq'::regclass);


--
-- TOC entry 3754 (class 2604 OID 62945)
-- Name: detalle_asiento id_detalle_asiento; Type: DEFAULT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.detalle_asiento ALTER COLUMN id_detalle_asiento SET DEFAULT nextval('contabilidad.detalle_asiento_id_detalle_asiento_seq'::regclass);


--
-- TOC entry 3760 (class 2604 OID 62946)
-- Name: plan_cuentas id_cuenta; Type: DEFAULT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.plan_cuentas ALTER COLUMN id_cuenta SET DEFAULT nextval('contabilidad.plan_cuentas_id_cuenta_seq'::regclass);


--
-- TOC entry 3764 (class 2604 OID 62947)
-- Name: areas id_area; Type: DEFAULT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.areas ALTER COLUMN id_area SET DEFAULT nextval('identidad.areas_id_area_seq'::regclass);


--
-- TOC entry 3766 (class 2604 OID 62948)
-- Name: auditoria_accesos id_auditoria; Type: DEFAULT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.auditoria_accesos ALTER COLUMN id_auditoria SET DEFAULT nextval('identidad.auditoria_accesos_id_auditoria_seq'::regclass);


--
-- TOC entry 3770 (class 2604 OID 62949)
-- Name: cargos id_cargo; Type: DEFAULT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.cargos ALTER COLUMN id_cargo SET DEFAULT nextval('identidad.cargos_id_cargo_seq'::regclass);


--
-- TOC entry 3775 (class 2604 OID 62950)
-- Name: menus id_menu; Type: DEFAULT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.menus ALTER COLUMN id_menu SET DEFAULT nextval('identidad.menus_id_menu_seq'::regclass);


--
-- TOC entry 3779 (class 2604 OID 62951)
-- Name: permisos id_permiso; Type: DEFAULT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.permisos ALTER COLUMN id_permiso SET DEFAULT nextval('identidad.permisos_id_permiso_seq'::regclass);


--
-- TOC entry 3783 (class 2604 OID 62952)
-- Name: roles id_rol; Type: DEFAULT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.roles ALTER COLUMN id_rol SET DEFAULT nextval('identidad.roles_id_rol_seq'::regclass);


--
-- TOC entry 3787 (class 2604 OID 62953)
-- Name: roles_menus id_rol_menu; Type: DEFAULT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.roles_menus ALTER COLUMN id_rol_menu SET DEFAULT nextval('identidad.roles_menus_id_rol_menu_seq'::regclass);


--
-- TOC entry 3791 (class 2604 OID 62954)
-- Name: roles_menus_permisos id_rol_menu_permiso; Type: DEFAULT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.roles_menus_permisos ALTER COLUMN id_rol_menu_permiso SET DEFAULT nextval('identidad.roles_menus_permisos_id_rol_menu_permiso_seq'::regclass);


--
-- TOC entry 3798 (class 2604 OID 62955)
-- Name: tipos_permiso id_tipo_permiso; Type: DEFAULT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.tipos_permiso ALTER COLUMN id_tipo_permiso SET DEFAULT nextval('identidad.tipos_permiso_id_tipo_permiso_seq'::regclass);


--
-- TOC entry 3802 (class 2604 OID 62956)
-- Name: trabajadores id_trabajador; Type: DEFAULT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.trabajadores ALTER COLUMN id_trabajador SET DEFAULT nextval('identidad.trabajadores_id_trabajador_seq'::regclass);


--
-- TOC entry 3806 (class 2604 OID 62957)
-- Name: usuarios id_usuario; Type: DEFAULT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.usuarios ALTER COLUMN id_usuario SET DEFAULT nextval('identidad.usuarios_id_usuario_seq'::regclass);


--
-- TOC entry 3810 (class 2604 OID 62958)
-- Name: usuarios_roles id_usuario_rol; Type: DEFAULT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.usuarios_roles ALTER COLUMN id_usuario_rol SET DEFAULT nextval('identidad.usuarios_roles_id_usuario_rol_seq'::regclass);


--
-- TOC entry 3815 (class 2604 OID 62959)
-- Name: almacenes id_almacen; Type: DEFAULT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.almacenes ALTER COLUMN id_almacen SET DEFAULT nextval('inventario.almacenes_id_almacen_seq'::regclass);


--
-- TOC entry 3954 (class 2604 OID 66590)
-- Name: inv_kardex_lote id; Type: DEFAULT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.inv_kardex_lote ALTER COLUMN id SET DEFAULT nextval('inventario.inv_kardex_lote_id_seq'::regclass);


--
-- TOC entry 3959 (class 2604 OID 66601)
-- Name: inv_kardex_movimiento id; Type: DEFAULT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.inv_kardex_movimiento ALTER COLUMN id SET DEFAULT nextval('inventario.inv_kardex_movimiento_id_seq'::regclass);


--
-- TOC entry 3966 (class 2604 OID 66621)
-- Name: inv_kardex_recalculo_log id; Type: DEFAULT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.inv_kardex_recalculo_log ALTER COLUMN id SET DEFAULT nextval('inventario.inv_kardex_recalculo_log_id_seq'::regclass);


--
-- TOC entry 3818 (class 2604 OID 62960)
-- Name: movimientos_inventario id_movimiento; Type: DEFAULT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.movimientos_inventario ALTER COLUMN id_movimiento SET DEFAULT nextval('inventario.movimientos_inventario_id_movimiento_seq'::regclass);


--
-- TOC entry 3825 (class 2604 OID 62961)
-- Name: stock id_stock; Type: DEFAULT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.stock ALTER COLUMN id_stock SET DEFAULT nextval('inventario.stock_id_stock_seq'::regclass);


--
-- TOC entry 3933 (class 2604 OID 47571)
-- Name: traslados id_traslado; Type: DEFAULT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.traslados ALTER COLUMN id_traslado SET DEFAULT nextval('inventario.traslados_id_traslado_seq'::regclass);


--
-- TOC entry 3936 (class 2604 OID 47584)
-- Name: traslados_detalle id_detalle_traslado; Type: DEFAULT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.traslados_detalle ALTER COLUMN id_detalle_traslado SET DEFAULT nextval('inventario.traslados_detalle_id_detalle_traslado_seq'::regclass);


--
-- TOC entry 3939 (class 2604 OID 47600)
-- Name: traslados_incidencias id_incidencia; Type: DEFAULT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.traslados_incidencias ALTER COLUMN id_incidencia SET DEFAULT nextval('inventario.traslados_incidencias_id_incidencia_seq'::regclass);


--
-- TOC entry 3987 (class 2604 OID 67303)
-- Name: log_envio_cpe id_log; Type: DEFAULT; Schema: sunat; Owner: postgres
--

ALTER TABLE ONLY sunat.log_envio_cpe ALTER COLUMN id_log SET DEFAULT nextval('sunat.log_envio_cpe_id_log_seq'::regclass);


--
-- TOC entry 3835 (class 2604 OID 62962)
-- Name: cajas id_caja; Type: DEFAULT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.cajas ALTER COLUMN id_caja SET DEFAULT nextval('ventas.cajas_id_caja_seq'::regclass);


--
-- TOC entry 3844 (class 2604 OID 62963)
-- Name: cotizaciones id_cotizacion; Type: DEFAULT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.cotizaciones ALTER COLUMN id_cotizacion SET DEFAULT nextval('ventas.cotizaciones_id_cotizacion_seq'::regclass);


--
-- TOC entry 3847 (class 2604 OID 62964)
-- Name: detalle_cotizacion id_detalle_cot; Type: DEFAULT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.detalle_cotizacion ALTER COLUMN id_detalle_cot SET DEFAULT nextval('ventas.detalle_cotizacion_id_detalle_cot_seq'::regclass);


--
-- TOC entry 3851 (class 2604 OID 62965)
-- Name: detalle_venta id_detalle_venta; Type: DEFAULT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.detalle_venta ALTER COLUMN id_detalle_venta SET DEFAULT nextval('ventas.detalle_venta_id_detalle_venta_seq'::regclass);


--
-- TOC entry 3857 (class 2604 OID 62967)
-- Name: movimientos_caja id_movimiento_caja; Type: DEFAULT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.movimientos_caja ALTER COLUMN id_movimiento_caja SET DEFAULT nextval('ventas.movimientos_caja_id_movimiento_caja_seq'::regclass);


--
-- TOC entry 3861 (class 2604 OID 62968)
-- Name: pagos id_pago; Type: DEFAULT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.pagos ALTER COLUMN id_pago SET DEFAULT nextval('ventas.pagos_id_pago_seq'::regclass);


--
-- TOC entry 3995 (class 2604 OID 67339)
-- Name: venta_cuota_pago id_cuota; Type: DEFAULT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.venta_cuota_pago ALTER COLUMN id_cuota SET DEFAULT nextval('ventas.venta_cuota_pago_id_cuota_seq'::regclass);


--
-- TOC entry 3873 (class 2604 OID 62969)
-- Name: ventas id_venta; Type: DEFAULT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.ventas ALTER COLUMN id_venta SET DEFAULT nextval('ventas.ventas_id_venta_seq'::regclass);


--
-- TOC entry 4668 (class 0 OID 62613)
-- Dependencies: 339
-- Data for Name: __ef_migrations; Type: TABLE DATA; Schema: catalogo; Owner: postgres
--

INSERT INTO catalogo.__ef_migrations VALUES ('20260127221140_Inicial', '8.0.8');
INSERT INTO catalogo.__ef_migrations VALUES ('20260127221706_AjusteEsquema', '8.0.8');
INSERT INTO catalogo.__ef_migrations VALUES ('20260128013043_RefactorTipoProducto', '8.0.8');
INSERT INTO catalogo.__ef_migrations VALUES ('20260222180939_AddMetodoValuacionToProducto', '8.0.8');


--
-- TOC entry 4549 (class 0 OID 46222)
-- Dependencies: 220
-- Data for Name: categorias; Type: TABLE DATA; Schema: catalogo; Owner: postgres
--

INSERT INTO catalogo.categorias VALUES (1, 'General', 'Categoria General', NULL, NULL, true, '2026-01-27 17:36:29.051209', 'SYSTEM', '2026-01-27 17:36:29.051209', NULL);
INSERT INTO catalogo.categorias VALUES (2, 'General 2', 'prueba', NULL, NULL, false, '2026-01-28 23:41:36.75824', 'API_USER', '2026-01-29 12:27:20.601968', 'API_USER');
INSERT INTO catalogo.categorias VALUES (4, 'Electrónica', 'Dispositivos electrónicos, hogar y oficina', NULL, NULL, true, '2026-03-21 11:26:08.334007', 'SEEDER', '2026-03-21 11:26:08.334007', NULL);
INSERT INTO catalogo.categorias VALUES (5, 'Línea Blanca', 'Electrodomésticos grandes', NULL, NULL, true, '2026-03-21 11:26:08.334007', 'SEEDER', '2026-03-21 11:26:08.334007', NULL);
INSERT INTO catalogo.categorias VALUES (6, 'Ferretería', 'Herramientas y construcción', NULL, NULL, true, '2026-03-21 11:26:08.334007', 'SEEDER', '2026-03-21 11:26:08.334007', NULL);
INSERT INTO catalogo.categorias VALUES (7, 'Electrónica', 'Dispositivos electrónicos, hogar y oficina', NULL, NULL, true, '2026-03-21 11:28:58.728614', 'SEEDER', '2026-03-21 11:28:58.728614', NULL);
INSERT INTO catalogo.categorias VALUES (8, 'Línea Blanca', 'Electrodomésticos grandes', NULL, NULL, true, '2026-03-21 11:28:58.728614', 'SEEDER', '2026-03-21 11:28:58.728614', NULL);
INSERT INTO catalogo.categorias VALUES (9, 'Ferretería', 'Herramientas y construcción', NULL, NULL, true, '2026-03-21 11:28:58.728614', 'SEEDER', '2026-03-21 11:28:58.728614', NULL);


--
-- TOC entry 4551 (class 0 OID 46231)
-- Dependencies: 222
-- Data for Name: imagenes_producto; Type: TABLE DATA; Schema: catalogo; Owner: postgres
--



--
-- TOC entry 4553 (class 0 OID 46242)
-- Dependencies: 224
-- Data for Name: listas_precios; Type: TABLE DATA; Schema: catalogo; Owner: postgres
--



--
-- TOC entry 4555 (class 0 OID 46250)
-- Dependencies: 226
-- Data for Name: marcas; Type: TABLE DATA; Schema: catalogo; Owner: postgres
--

INSERT INTO catalogo.marcas VALUES (1, 'Generico', 'Peru', true, '2026-01-27 17:36:29.051209', 'SYSTEM', '2026-01-27 17:36:29.051209', NULL);
INSERT INTO catalogo.marcas VALUES (5, 'Samsung', 'Corea del Sur', true, '2026-03-21 11:26:08.334007', 'SEEDER', '2026-03-21 11:26:08.334007', NULL);
INSERT INTO catalogo.marcas VALUES (6, 'LG', 'Corea del Sur', true, '2026-03-21 11:26:08.334007', 'SEEDER', '2026-03-21 11:26:08.334007', NULL);
INSERT INTO catalogo.marcas VALUES (7, 'Bosch', 'Alemania', true, '2026-03-21 11:26:08.334007', 'SEEDER', '2026-03-21 11:26:08.334007', NULL);
INSERT INTO catalogo.marcas VALUES (8, 'Truper', 'México', true, '2026-03-21 11:26:08.334007', 'SEEDER', '2026-03-21 11:26:08.334007', NULL);
INSERT INTO catalogo.marcas VALUES (9, 'ASUS', 'Taiwán', true, '2026-03-21 11:26:08.334007', 'SEEDER', '2026-03-21 11:26:08.334007', NULL);
INSERT INTO catalogo.marcas VALUES (10, 'Xiaomi', 'China', true, '2026-03-21 11:26:08.334007', 'SEEDER', '2026-03-21 11:26:08.334007', NULL);


--
-- TOC entry 4557 (class 0 OID 46257)
-- Dependencies: 228
-- Data for Name: productos; Type: TABLE DATA; Schema: catalogo; Owner: postgres
--

INSERT INTO catalogo.productos VALUES (7, 'TV-SAM-001', NULL, NULL, 'Smart TV 55" 4K UHD', 'Televisor inteligente Samsung con resolución 4K', 4, 5, 1, false, 0.00, 1899.00, 0.00, 0.00, 5.000, NULL, false, true, 18.00, NULL, true, '2026-03-21 11:26:08.334007', 'SEEDER', '2026-03-21 11:26:08.334007', NULL, NULL, 'PE');
INSERT INTO catalogo.productos VALUES (8, 'LAP-ASU-001', NULL, NULL, 'Laptop ASUS ZenBook 14"', 'Laptop ultra delgada, procesador Intel i7, 16GB RAM', 4, 9, 1, false, 0.00, 4299.00, 0.00, 0.00, 3.000, NULL, false, true, 18.00, NULL, true, '2026-03-21 11:26:08.334007', 'SEEDER', '2026-03-21 11:26:08.334007', NULL, NULL, 'PE');
INSERT INTO catalogo.productos VALUES (9, 'CEL-XIA-001', NULL, NULL, 'Smartphone Xiaomi Redmi Note 13', 'Teléfono móvil Xiaomi 256GB / 8GB RAM', 4, 10, 1, false, 0.00, 1199.00, 0.00, 0.00, 10.000, NULL, false, true, 18.00, NULL, true, '2026-03-21 11:26:08.334007', 'SEEDER', '2026-03-21 11:26:08.334007', NULL, NULL, 'PE');
INSERT INTO catalogo.productos VALUES (10, 'REF-LG-001', NULL, NULL, 'Refrigeradora LG Inverter 600L', 'Refrigeradora de gran capacidad con tecnología Inverter LG', 5, 6, 1, false, 0.00, 2899.00, 0.00, 0.00, 2.000, NULL, false, true, 18.00, NULL, true, '2026-03-21 11:26:08.334007', 'SEEDER', '2026-03-21 11:26:08.334007', NULL, NULL, 'PE');
INSERT INTO catalogo.productos VALUES (11, 'LAV-BOS-001', NULL, NULL, 'Lavadora Bosch Carga Frontal 9kg', 'Lavadora inteligente Bosch 9 kilogramos con secado', 5, 7, 1, false, 0.00, 1850.50, 0.00, 0.00, 4.000, NULL, false, true, 18.00, NULL, true, '2026-03-21 11:26:08.334007', 'SEEDER', '2026-03-21 11:26:08.334007', NULL, NULL, 'PE');
INSERT INTO catalogo.productos VALUES (12, 'HER-TRU-001', NULL, NULL, 'Taladro Percutor 1/2" 700W', 'Taladro industrial percutor marca Truper, 700 watts de potencia', 6, 8, 1, false, 0.00, 199.90, 0.00, 0.00, 10.000, NULL, false, true, 18.00, NULL, true, '2026-03-21 11:26:08.334007', 'SEEDER', '2026-03-21 11:26:08.334007', NULL, NULL, 'PE');
INSERT INTO catalogo.productos VALUES (13, 'HER-TRU-002', NULL, NULL, 'Set de Herramientas Mecánicas 50 Pzs', 'Maletín con llaves, dados y otras herramientas mecánicas Truper', 6, 8, 1, false, 0.00, 299.90, 0.00, 0.00, 8.000, NULL, false, true, 18.00, NULL, true, '2026-03-21 11:26:08.334007', 'SEEDER', '2026-03-21 11:26:08.334007', NULL, NULL, 'PE');
INSERT INTO catalogo.productos VALUES (1, 'PROD_CLI_01', NULL, NULL, 'Producto Client', NULL, 1, 1, 1, false, 0.00, 0.00, 0.00, 0.00, 0.000, 0.000, false, true, 18.00, NULL, true, '2026-01-27 22:55:17.057057', '', NULL, NULL, NULL, '');
INSERT INTO catalogo.productos VALUES (2, 'PROD001', NULL, NULL, 'Producto Prueba', NULL, 1, 1, 1, false, 0.00, 0.00, 0.00, 0.00, 0.000, 0.000, false, true, 18.00, NULL, true, '2026-01-27 22:59:25.458681', '', NULL, NULL, NULL, '');
INSERT INTO catalogo.productos VALUES (3, 'PROD_WRAPPER_02', NULL, NULL, 'Producto Wrapper 2', NULL, 1, 1, 1, false, 0.00, 0.00, 0.00, 0.00, 0.000, 0.000, false, true, 18.00, NULL, true, '2026-01-27 23:11:00.248331', '', NULL, NULL, NULL, '');
INSERT INTO catalogo.productos VALUES (4, 'PROD_AUDIT_03', NULL, NULL, 'Producto Auditado', NULL, 1, 1, 1, false, 0.00, 0.00, 0.00, 0.00, 0.000, 0.000, false, true, 18.00, NULL, true, '2026-01-27 23:18:23.828687', 'API_USER', NULL, NULL, NULL, '');
INSERT INTO catalogo.productos VALUES (5, 'prueba', NULL, NULL, 'esta', NULL, 1, 1, 1, false, 0.00, 0.00, 0.00, 0.00, 0.000, 0.000, false, true, 18.00, NULL, true, '2026-01-27 23:37:50.466669', 'API_USER', NULL, NULL, NULL, '');


--
-- TOC entry 4559 (class 0 OID 46279)
-- Dependencies: 230
-- Data for Name: unidades_medida; Type: TABLE DATA; Schema: catalogo; Owner: postgres
--

INSERT INTO catalogo.unidades_medida VALUES (1, 'NIU', 'Unidad', 'UND', true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);
INSERT INTO catalogo.unidades_medida VALUES (2, 'KGM', 'Kilogramo', 'KG', true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);
INSERT INTO catalogo.unidades_medida VALUES (3, 'LTR', 'Litro', 'LT', true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);
INSERT INTO catalogo.unidades_medida VALUES (4, 'MTR', 'Metro', 'MT', true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);
INSERT INTO catalogo.unidades_medida VALUES (5, 'BX', 'Caja', 'CJA', true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);
INSERT INTO catalogo.unidades_medida VALUES (6, 'NIU', 'Unidad', 'UND', true, '2026-01-27 17:36:29.051209', 'SYSTEM', '2026-01-27 17:36:29.051209', NULL);
INSERT INTO catalogo.unidades_medida VALUES (12, 'ZZ', 'Servicio', 'SRV', true, '2026-03-30 09:27:17.624767', 'sistema', '2026-03-30 09:27:17.624767', NULL);
INSERT INTO catalogo.unidades_medida VALUES (13, 'MTQ', 'Metro Cúbico', 'm3', true, '2026-03-30 09:27:17.624767', 'sistema', '2026-03-30 09:27:17.624767', NULL);
INSERT INTO catalogo.unidades_medida VALUES (14, 'DZN', 'Docena', 'DOC', true, '2026-03-30 09:27:17.624767', 'sistema', '2026-03-30 09:27:17.624767', NULL);
INSERT INTO catalogo.unidades_medida VALUES (15, 'SET', 'Juego', 'JGO', true, '2026-03-30 09:27:17.624767', 'sistema', '2026-03-30 09:27:17.624767', NULL);


--
-- TOC entry 4561 (class 0 OID 46286)
-- Dependencies: 232
-- Data for Name: variantes_producto; Type: TABLE DATA; Schema: catalogo; Owner: postgres
--



--
-- TOC entry 4684 (class 0 OID 66654)
-- Dependencies: 355
-- Data for Name: __EFMigrationsHistory; Type: TABLE DATA; Schema: clientes; Owner: postgres
--

INSERT INTO clientes."__EFMigrationsHistory" VALUES ('20260129225037_Initial', '8.0.x');


--
-- TOC entry 4687 (class 0 OID 66796)
-- Dependencies: 358
-- Data for Name: __ef_migrations_history; Type: TABLE DATA; Schema: clientes; Owner: postgres
--

INSERT INTO clientes.__ef_migrations_history VALUES ('20260129225037_Inicial', '8.0.8');
INSERT INTO clientes.__ef_migrations_history VALUES ('20260327223412_AddSunatFieldsToCliente', '8.0.8');


--
-- TOC entry 4563 (class 0 OID 46296)
-- Dependencies: 234
-- Data for Name: clientes; Type: TABLE DATA; Schema: clientes; Owner: postgres
--

INSERT INTO clientes.clientes VALUES (2, '20556677881', 'Constructora Horizonte S.A.', 'Horizonte', 'Av. Javier Prado 1500, San Isidro', '01-2223344', 'compras@horizonte.com.pe', 0.00, 0, NULL, true, '2026-03-21 18:44:11.223105', 'SYSTEM', '2026-03-21 18:44:11.223105', NULL, 4, NULL, NULL, false, false, false, NULL, NULL, NULL);
INSERT INTO clientes.clientes VALUES (3, '45678901', 'María García López', 'María García', 'Urb. Los Pinos F-12, Arequipa', '987654321', 'maria.garcia@outlook.com', 0.00, 0, NULL, true, '2026-03-21 18:44:11.223105', 'SYSTEM', '2026-03-21 18:44:11.223105', NULL, 2, NULL, NULL, false, false, false, NULL, NULL, NULL);
INSERT INTO clientes.clientes VALUES (5, '44050058', 'Francisco Antonio Vilchez Quispe', NULL, 'Sta Catalina 430', '968737466', NULL, NULL, NULL, NULL, true, '2026-03-28 00:27:49.647488', 'API_USER', NULL, NULL, 2, 9, 'HABIDO', true, true, true, 'ACTIVO', NULL, '130107');


--
-- TOC entry 4565 (class 0 OID 46307)
-- Dependencies: 236
-- Data for Name: contactos_cliente; Type: TABLE DATA; Schema: clientes; Owner: postgres
--



--
-- TOC entry 4686 (class 0 OID 66791)
-- Dependencies: 357
-- Data for Name: __ef_migrations_history; Type: TABLE DATA; Schema: compras; Owner: postgres
--

INSERT INTO compras.__ef_migrations_history VALUES ('20260129231053_Inicial', '8.0.8');
INSERT INTO compras.__ef_migrations_history VALUES ('20260206190831_FixDetalleAudit', '8.0.8');
INSERT INTO compras.__ef_migrations_history VALUES ('20260213160911_AddCompraIdToOrdenCompra', '8.0.8');
INSERT INTO compras.__ef_migrations_history VALUES ('20260217183807_UpdateOrdenCompraSerieNumero', '8.0.8');
INSERT INTO compras.__ef_migrations_history VALUES ('20260217203920_AddSerieNumeroCorrelativoToOrdenCompra', '8.0.8');
INSERT INTO compras.__ef_migrations_history VALUES ('20260219175334_AddObservacionesToCompra', '8.0.8');
INSERT INTO compras.__ef_migrations_history VALUES ('20260221132104_AddCamposSunatPle81', '8.0.8');
INSERT INTO compras.__ef_migrations_history VALUES ('20260316050748_UpdateSunatFieldsCompras', '8.0.8');
INSERT INTO compras.__ef_migrations_history VALUES ('20260322232250_FixTypoIdCompra', '8.0.8');
INSERT INTO compras.__ef_migrations_history VALUES ('20260327220128_AddSunatFieldsAndResetSequence', '8.0.8');
INSERT INTO compras.__ef_migrations_history VALUES ('20260329205312_AddSunatNotasCompras', '8.0.8');
INSERT INTO compras.__ef_migrations_history VALUES ('20260401144641_RemoveRedundantNotas', '8.0.8');


--
-- TOC entry 4567 (class 0 OID 46317)
-- Dependencies: 238
-- Data for Name: compras; Type: TABLE DATA; Schema: compras; Owner: postgres
--

INSERT INTO compras.compras VALUES (12, 2, 1, NULL, 'F001', '00000012', '2026-03-26', '2026-03-26', 'PEN', 1.0000, 0.00, 521.82, 3420.82, 3420.82, NULL, 2899.00, 0.00, 0.00, true, '2026-03-26 14:24:47.10994', 'API_USER', NULL, NULL, 1, 1, 'Carga desde Orden OC01-00000001. ', '', NULL, NULL);
INSERT INTO compras.compras VALUES (13, 2, 1, NULL, 'F001', '00000013', '2026-03-26', '2026-03-26', 'PEN', 1.0000, 0.00, 521.82, 3420.82, 3420.82, NULL, 2899.00, 0.00, 0.00, true, '2026-03-26 14:39:46.166121', 'API_USER', NULL, NULL, 1, 1, 'Carga desde Orden OC01-00000001. ', '', NULL, NULL);
INSERT INTO compras.compras VALUES (14, 2, 1, NULL, 'F001', '00000014', '2026-03-26', '2026-03-26', 'PEN', 1.0000, 0.00, 521.82, 3420.82, 3420.82, NULL, 2899.00, 0.00, 0.00, true, '2026-03-26 14:42:36.440632', 'API_USER', NULL, NULL, 1, 1, 'Carga desde Orden OC01-00000001. ', '', NULL, NULL);
INSERT INTO compras.compras VALUES (15, 2, 1, NULL, 'F001', '00000015', '2026-03-26', '2026-03-26', 'PEN', 1.0000, 0.00, 521.82, 3420.82, 3420.82, NULL, 2899.00, 0.00, 0.00, true, '2026-03-26 14:49:17.386423', 'API_USER', NULL, NULL, 1, 1, 'Carga desde Orden OC01-00000001. ', '', NULL, NULL);
INSERT INTO compras.compras VALUES (16, 2, 1, NULL, 'F001', '00000016', '2026-03-26', '2026-03-26', 'PEN', 1.0000, 0.00, 521.82, 3420.82, 3420.82, NULL, 2899.00, 0.00, 0.00, true, '2026-03-26 14:59:42.657712', 'API_USER', NULL, NULL, 1, 1, 'Carga desde Orden OC01-00000001. ', '', NULL, NULL);
INSERT INTO compras.compras VALUES (17, 2, 1, NULL, 'F001', '00000017', '2026-03-26', '2026-03-26', 'PEN', 1.0000, 0.00, 521.82, 3420.82, 3420.82, NULL, 2899.00, 0.00, 0.00, true, '2026-03-26 15:49:12.215437', 'API_USER', NULL, NULL, 1, 1, 'Carga desde Orden OC01-00000001. ', '', NULL, NULL);
INSERT INTO compras.compras VALUES (18, 2, 1, NULL, 'F001', '00000018', '2026-03-26', '2026-03-26', 'PEN', 1.0000, 0.00, 521.82, 3420.82, 3420.82, NULL, 2899.00, 0.00, 0.00, true, '2026-03-26 15:53:39.052604', 'API_USER', NULL, NULL, 1, 1, 'Carga desde Orden OC01-00000001. ', '', NULL, NULL);
INSERT INTO compras.compras VALUES (19, 2, 1, NULL, 'F001', '00000019', '2026-03-26', '2026-03-26', 'PEN', 1.0000, 0.00, 521.82, 3420.82, 3420.82, NULL, 2899.00, 0.00, 0.00, true, '2026-03-26 15:58:00.507281', 'API_USER', NULL, NULL, 1, 1, 'Carga desde Orden OC01-00000001. ', '', NULL, NULL);
INSERT INTO compras.compras VALUES (20, 2, 1, NULL, 'F001', '00000020', '2026-03-26', '2026-03-26', 'PEN', 1.0000, 0.00, 521.82, 3420.82, 3420.82, NULL, 2899.00, 0.00, 0.00, true, '2026-03-26 16:18:20.992479', 'API_USER', NULL, NULL, 1, 1, 'Carga desde Orden OC01-00000001. ', '', NULL, NULL);
INSERT INTO compras.compras VALUES (21, 2, 1, NULL, 'F001', '00000020', '2026-03-26', '2026-03-26', 'PEN', 1.0000, 0.00, 521.82, 3420.82, 3420.82, NULL, 2899.00, 0.00, 0.00, true, '2026-03-26 22:25:02.487232', 'API_USER', NULL, NULL, 1, 1, 'Carga desde Orden OC01-00000001. ', '', NULL, NULL);
INSERT INTO compras.compras VALUES (22, 2, 1, NULL, 'F001', '00000021', '2026-03-26', '2026-03-26', 'PEN', 1.0000, 0.00, 521.82, 3420.82, 3420.82, NULL, 2899.00, 0.00, 0.00, true, '2026-03-26 22:29:22.21869', 'API_USER', NULL, NULL, 1, 1, 'Carga desde Orden OC01-00000001. ', '', NULL, NULL);
INSERT INTO compras.compras VALUES (23, 2, 1, NULL, 'F001', '00000022', '2026-03-26', '2026-03-26', 'PEN', 1.0000, 0.00, 521.82, 3420.82, 3420.82, NULL, 2899.00, 0.00, 0.00, true, '2026-03-26 22:58:38.347874', 'API_USER', NULL, NULL, 1, 1, 'Carga desde Orden OC01-00000001. ', '', NULL, NULL);
INSERT INTO compras.compras VALUES (24, 2, 1, NULL, 'F001', '00000024', '2026-03-26', '2026-03-26', 'PEN', 1.0000, 0.00, 521.82, 3420.82, 3420.82, NULL, 2899.00, 0.00, 0.00, true, '2026-03-26 23:11:58.863779', 'API_USER', NULL, NULL, 1, 1, 'Carga desde Orden OC01-00000001. ', '', NULL, NULL);
INSERT INTO compras.compras VALUES (25, 2, 1, 1, 'F001', '00000025', '2026-03-26', '2026-03-26', 'PEN', 1.0000, 0.00, 521.82, 3420.82, 3420.82, NULL, 2899.00, 0.00, 0.00, true, '2026-03-26 23:20:28.662472', 'API_USER', NULL, NULL, 1, 1, 'Carga desde Orden OC01-00000001. ', '', NULL, NULL);
INSERT INTO compras.compras VALUES (26, 2, 1, 1, 'F001', '00000026', '2026-03-26', '2026-03-26', 'PEN', 1.0000, 0.00, 521.82, 3420.82, 3420.82, NULL, 2899.00, 0.00, 0.00, true, '2026-03-26 23:20:39.967156', 'API_USER', NULL, NULL, 1, 1, 'Carga desde Orden OC01-00000001. ', '', NULL, NULL);
INSERT INTO compras.compras VALUES (27, 2, 1, 1, 'F001', '00000027', '2026-03-26', '2026-03-26', 'PEN', 1.0000, 0.00, 521.82, 3420.82, 3420.82, NULL, 2899.00, 0.00, 0.00, true, '2026-03-26 23:20:47.184753', 'API_USER', NULL, NULL, 1, 1, 'Carga desde Orden OC01-00000001. ', '', NULL, NULL);
INSERT INTO compras.compras VALUES (28, 2, 1, 1, 'F001', '00000028', '2026-03-26', '2026-03-26', 'PEN', 1.0000, 0.00, 521.82, 3420.82, 3420.82, NULL, 2899.00, 0.00, 0.00, true, '2026-03-26 23:23:39.398799', 'API_USER', NULL, NULL, 1, 1, 'Carga desde Orden OC01-00000001. ', '', NULL, NULL);
INSERT INTO compras.compras VALUES (29, 2, 1, 1, 'F001', '00000029', '2026-03-27', '2026-03-27', 'PEN', 1.0000, 0.00, 521.82, 3420.82, 3420.82, NULL, 2899.00, 0.00, 0.00, true, '2026-03-27 04:30:27.406438', 'API_USER', NULL, NULL, 1, 1, 'Carga desde Orden OC01-00000001. ', '', NULL, NULL);
INSERT INTO compras.compras VALUES (30, 1, 1, NULL, 'F001', '000000', '2026-03-28', '2026-03-28', 'PEN', 1.0000, 0.00, 19346.40, 126826.40, 126826.40, NULL, 107480.00, 0.00, 0.00, true, '2026-03-28 17:36:27.448886', 'API_USER', NULL, NULL, 1, 1, '', '', NULL, NULL);


--
-- TOC entry 4569 (class 0 OID 46332)
-- Dependencies: 240
-- Data for Name: detalle_compra; Type: TABLE DATA; Schema: compras; Owner: postgres
--

INSERT INTO compras.detalle_compra VALUES (10, 12, 10, NULL, '', 1.000, 2899.00, 2899.00, '10', true, '2026-03-26 14:24:47.110069', 'API_USER', NULL, NULL, NULL, NULL, 0.0000, NULL);
INSERT INTO compras.detalle_compra VALUES (11, 13, 10, NULL, '', 1.000, 2899.00, 2899.00, '10', true, '2026-03-26 14:39:46.166237', 'API_USER', NULL, NULL, NULL, NULL, 0.0000, NULL);
INSERT INTO compras.detalle_compra VALUES (12, 14, 10, NULL, '', 1.000, 2899.00, 2899.00, '10', true, '2026-03-26 14:42:36.440766', 'API_USER', NULL, NULL, NULL, NULL, 0.0000, NULL);
INSERT INTO compras.detalle_compra VALUES (13, 15, 10, NULL, '', 1.000, 2899.00, 2899.00, '10', true, '2026-03-26 14:49:17.386533', 'API_USER', NULL, NULL, NULL, NULL, 0.0000, NULL);
INSERT INTO compras.detalle_compra VALUES (14, 16, 10, NULL, '', 1.000, 2899.00, 2899.00, '10', true, '2026-03-26 14:59:42.657842', 'API_USER', NULL, NULL, NULL, NULL, 0.0000, NULL);
INSERT INTO compras.detalle_compra VALUES (15, 17, 10, NULL, '', 1.000, 2899.00, 2899.00, '10', true, '2026-03-26 15:49:12.215573', 'API_USER', NULL, NULL, NULL, NULL, 0.0000, NULL);
INSERT INTO compras.detalle_compra VALUES (16, 18, 10, NULL, '', 1.000, 2899.00, 2899.00, '10', true, '2026-03-26 15:53:39.052721', 'API_USER', NULL, NULL, NULL, NULL, 0.0000, NULL);
INSERT INTO compras.detalle_compra VALUES (17, 19, 10, NULL, '', 1.000, 2899.00, 2899.00, '10', true, '2026-03-26 15:58:00.507454', 'API_USER', NULL, NULL, NULL, NULL, 0.0000, NULL);
INSERT INTO compras.detalle_compra VALUES (18, 20, 10, NULL, '', 1.000, 2899.00, 2899.00, '10', true, '2026-03-26 16:18:20.992595', 'API_USER', NULL, NULL, NULL, NULL, 0.0000, NULL);
INSERT INTO compras.detalle_compra VALUES (19, 21, 10, NULL, '', 1.000, 2899.00, 2899.00, '10', true, '2026-03-26 22:25:02.487361', 'API_USER', NULL, NULL, NULL, NULL, 0.0000, NULL);
INSERT INTO compras.detalle_compra VALUES (20, 22, 10, NULL, '', 1.000, 2899.00, 2899.00, '10', true, '2026-03-26 22:29:22.218827', 'API_USER', NULL, NULL, NULL, NULL, 0.0000, NULL);
INSERT INTO compras.detalle_compra VALUES (21, 23, 10, NULL, '', 1.000, 2899.00, 2899.00, '10', true, '2026-03-26 22:58:38.347989', 'API_USER', NULL, NULL, NULL, NULL, 0.0000, NULL);
INSERT INTO compras.detalle_compra VALUES (22, 24, 10, NULL, '', 1.000, 2899.00, 2899.00, '10', true, '2026-03-26 23:11:58.863902', 'API_USER', NULL, NULL, NULL, NULL, 0.0000, NULL);
INSERT INTO compras.detalle_compra VALUES (23, 25, 10, NULL, '', 1.000, 2899.00, 2899.00, '10', true, '2026-03-26 23:20:28.662686', 'API_USER', NULL, NULL, NULL, NULL, 0.0000, NULL);
INSERT INTO compras.detalle_compra VALUES (24, 26, 10, NULL, '', 1.000, 2899.00, 2899.00, '10', true, '2026-03-26 23:20:39.967157', 'API_USER', NULL, NULL, NULL, NULL, 0.0000, NULL);
INSERT INTO compras.detalle_compra VALUES (25, 27, 10, NULL, '', 1.000, 2899.00, 2899.00, '10', true, '2026-03-26 23:20:47.184755', 'API_USER', NULL, NULL, NULL, NULL, 0.0000, NULL);
INSERT INTO compras.detalle_compra VALUES (26, 28, 10, NULL, '', 1.000, 2899.00, 2899.00, '10', true, '2026-03-26 23:23:39.3988', 'API_USER', NULL, NULL, NULL, NULL, 0.0000, NULL);
INSERT INTO compras.detalle_compra VALUES (27, 29, 10, NULL, '', 1.000, 2899.00, 2899.00, '10', true, '2026-03-27 04:30:27.406569', 'API_USER', NULL, NULL, NULL, NULL, 0.0000, NULL);
INSERT INTO compras.detalle_compra VALUES (28, 30, 10, NULL, '', 10.000, 2899.00, 28990.00, '10', true, '2026-03-28 17:36:27.449029', 'API_USER', NULL, NULL, NULL, NULL, 0.0000, NULL);
INSERT INTO compras.detalle_compra VALUES (29, 30, 13, NULL, '', 30.000, 299.90, 8997.00, '10', true, '2026-03-28 17:36:27.44903', 'API_USER', NULL, NULL, NULL, NULL, 0.0000, NULL);
INSERT INTO compras.detalle_compra VALUES (30, 30, 7, NULL, '', 15.000, 1899.00, 28485.00, '10', true, '2026-03-28 17:36:27.449031', 'API_USER', NULL, NULL, NULL, NULL, 0.0000, NULL);
INSERT INTO compras.detalle_compra VALUES (31, 30, 11, NULL, '', 20.000, 1850.50, 37010.00, '10', true, '2026-03-28 17:36:27.449031', 'API_USER', NULL, NULL, NULL, NULL, 0.0000, NULL);
INSERT INTO compras.detalle_compra VALUES (32, 30, 12, NULL, '', 20.000, 199.90, 3998.00, '10', true, '2026-03-28 17:36:27.449032', 'API_USER', NULL, NULL, NULL, NULL, 0.0000, NULL);


--
-- TOC entry 4571 (class 0 OID 46340)
-- Dependencies: 242
-- Data for Name: detalle_orden_compra; Type: TABLE DATA; Schema: compras; Owner: postgres
--

INSERT INTO compras.detalle_orden_compra VALUES (1, 1, 10, NULL, 1.000, 2899.00, 2899.00, 0.000, true, '2026-03-21 23:25:06.725475', 'API_USER', NULL, NULL);


--
-- TOC entry 4685 (class 0 OID 66762)
-- Dependencies: 356
-- Data for Name: ef_migrations_history; Type: TABLE DATA; Schema: compras; Owner: postgres
--

INSERT INTO compras.ef_migrations_history VALUES ('20260129231053_Inicial', '8.0.8');
INSERT INTO compras.ef_migrations_history VALUES ('20260206190831_FixDetalleAudit', '8.0.8');
INSERT INTO compras.ef_migrations_history VALUES ('20260213160911_AddCompraIdToOrdenCompra', '8.0.8');
INSERT INTO compras.ef_migrations_history VALUES ('20260217183807_UpdateOrdenCompraSerieNumero', '8.0.8');
INSERT INTO compras.ef_migrations_history VALUES ('20260217203920_AddSerieNumeroCorrelativoToOrdenCompra', '8.0.8');
INSERT INTO compras.ef_migrations_history VALUES ('20260219175334_AddObservacionesToCompra', '8.0.8');
INSERT INTO compras.ef_migrations_history VALUES ('20260221132104_AddCamposSunatPle81', '8.0.8');
INSERT INTO compras.ef_migrations_history VALUES ('20260316050748_UpdateSunatFieldsCompras', '8.0.8');
INSERT INTO compras.ef_migrations_history VALUES ('20260322232250_FixTypoIdCompra', '8.0.8');


--
-- TOC entry 4690 (class 0 OID 66884)
-- Dependencies: 361
-- Data for Name: nota_credito; Type: TABLE DATA; Schema: compras; Owner: postgres
--



--
-- TOC entry 4694 (class 0 OID 66920)
-- Dependencies: 365
-- Data for Name: nota_credito_detalle; Type: TABLE DATA; Schema: compras; Owner: postgres
--



--
-- TOC entry 4692 (class 0 OID 66902)
-- Dependencies: 363
-- Data for Name: nota_debito; Type: TABLE DATA; Schema: compras; Owner: postgres
--



--
-- TOC entry 4696 (class 0 OID 66938)
-- Dependencies: 367
-- Data for Name: nota_debito_detalle; Type: TABLE DATA; Schema: compras; Owner: postgres
--



--
-- TOC entry 4573 (class 0 OID 46348)
-- Dependencies: 244
-- Data for Name: ordenes_compra; Type: TABLE DATA; Schema: compras; Owner: postgres
--

INSERT INTO compras.ordenes_compra VALUES (1, 'OC01-00000001', 2, 1, '2026-03-21', NULL, 2899.00, NULL, true, '2026-03-21 23:25:06.7254', 'API_USER', '2026-03-26 23:30:27.527329', 'API_USER', 100, 29, 13, 'OC01', '00000001');


--
-- TOC entry 4575 (class 0 OID 46358)
-- Dependencies: 246
-- Data for Name: proveedores; Type: TABLE DATA; Schema: compras; Owner: postgres
--

INSERT INTO compras.proveedores VALUES (2, '10445566779', 'Juan Pérez Suministros', 'JP Suministros', 'Calle Las Lilas 123, Surco', '999888777', 'juan.perez@email.com', NULL, true, '2026-03-21 18:44:11.223105', 'SYSTEM', '2026-03-21 18:44:11.223105', NULL, 4, NULL, false, false, false, NULL, NULL, NULL);
INSERT INTO compras.proveedores VALUES (1, '20601234567', 'Distribuidora Alimentos S.A.C.', 'Alisac', 'Av. Los Próceres 456, Lima', '014445566', 'ventas@alisac.com.pe', NULL, true, '2026-03-21 18:44:11.223105', 'SYSTEM', '2026-03-30 18:02:55.550293', 'API_USER', 4, 'HABIDO', true, true, true, 'ACTIVO', NULL, '150101');


--
-- TOC entry 4577 (class 0 OID 46367)
-- Dependencies: 248
-- Data for Name: configuraciones; Type: TABLE DATA; Schema: configuracion; Owner: postgres
--

INSERT INTO configuracion.configuraciones VALUES (1, 'IMPUESTO_PORCENTAJE', '18', 'Porcentaje de IGV/IVA por defecto', 'VENTAS', true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);
INSERT INTO configuracion.configuraciones VALUES (2, 'MONEDA_PRINCIPAL', 'PEN', 'Moneda base del sistema', 'SISTEMA', true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);


--
-- TOC entry 4579 (class 0 OID 46376)
-- Dependencies: 250
-- Data for Name: empresa; Type: TABLE DATA; Schema: configuracion; Owner: postgres
--

INSERT INTO configuracion.empresa VALUES (1, '20123456789', 'EMPRESA DEMO S.A.C.', 'MI TIENDA', 'AV. PRINCIPAL 123, LIMA', NULL, NULL, NULL, NULL, 'PEN', true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);


--
-- TOC entry 4653 (class 0 OID 47333)
-- Dependencies: 324
-- Data for Name: impuestos; Type: TABLE DATA; Schema: configuracion; Owner: postgres
--

INSERT INTO configuracion.impuestos VALUES (1, '1000', 'IGV', 18.00, true, true, '2026-03-16 09:20:16.083475', 'SYSTEM', NULL, NULL);
INSERT INTO configuracion.impuestos VALUES (2, '2000', 'ISC', 0.00, true, true, '2026-03-16 09:20:16.083475', 'SYSTEM', NULL, NULL);
INSERT INTO configuracion.impuestos VALUES (3, '9997', 'EXONERADO', 0.00, true, true, '2026-03-16 09:20:16.083475', 'SYSTEM', NULL, NULL);
INSERT INTO configuracion.impuestos VALUES (4, '9998', 'INAFECTO', 0.00, true, true, '2026-03-16 09:20:16.083475', 'SYSTEM', NULL, NULL);
INSERT INTO configuracion.impuestos VALUES (5, '9995', 'EXPORTACION', 0.00, true, true, '2026-03-30 09:27:17.624767', 'sistema', NULL, NULL);
INSERT INTO configuracion.impuestos VALUES (6, '9999', 'GRATUITA', 0.00, true, true, '2026-03-30 09:27:17.624767', 'sistema', NULL, NULL);


--
-- TOC entry 4647 (class 0 OID 47241)
-- Dependencies: 318
-- Data for Name: matriz_regla_sunat; Type: TABLE DATA; Schema: configuracion; Owner: postgres
--

INSERT INTO configuracion.matriz_regla_sunat VALUES (1, 1, 1, 1, true, '2026-03-16 09:20:16.522641', 'SYSTEM', NULL, NULL);
INSERT INTO configuracion.matriz_regla_sunat VALUES (2, 1, 2, 1, true, '2026-03-16 09:20:16.524028', 'SYSTEM', NULL, NULL);
INSERT INTO configuracion.matriz_regla_sunat VALUES (3, 1, 5, 1, true, '2026-03-16 09:20:16.524624', 'SYSTEM', NULL, NULL);
INSERT INTO configuracion.matriz_regla_sunat VALUES (4, 1, 6, 1, true, '2026-03-16 09:20:16.525225', 'SYSTEM', NULL, NULL);
INSERT INTO configuracion.matriz_regla_sunat VALUES (5, 1, 4, 1, true, '2026-03-16 09:20:16.525863', 'SYSTEM', NULL, NULL);
INSERT INTO configuracion.matriz_regla_sunat VALUES (6, 7, 4, 1, true, '2026-03-16 09:20:16.526494', 'SYSTEM', NULL, NULL);


--
-- TOC entry 4706 (class 0 OID 67074)
-- Dependencies: 384
-- Data for Name: metodos_pago; Type: TABLE DATA; Schema: configuracion; Owner: postgres
--

INSERT INTO configuracion.metodos_pago VALUES (1, 'EFECTIVO', 'Pago en Efectivo', true, NULL, true, '2026-03-29 23:57:09.579248-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.metodos_pago VALUES (2, 'TARJETA', 'Tarjeta de Débito/Crédito', false, NULL, true, '2026-03-29 23:57:09.579248-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.metodos_pago VALUES (3, 'TRANSFERENCIA', 'Transferencia Bancaria', false, NULL, true, '2026-03-29 23:57:09.579248-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.metodos_pago VALUES (4, 'YAPE_PLIN', 'Billetera Digital (Yape/Plin)', false, NULL, true, '2026-03-29 23:57:09.579248-05', 'SISTEMA', NULL, NULL);


--
-- TOC entry 4665 (class 0 OID 47710)
-- Dependencies: 336
-- Data for Name: motivo_nota_credito; Type: TABLE DATA; Schema: configuracion; Owner: postgres
--

INSERT INTO configuracion.motivo_nota_credito VALUES (1, '01', 'ANULACION DE LA OPERACION', true, true, true, '2026-03-16 09:20:16.555568-05', 'SYSTEM', NULL, NULL);
INSERT INTO configuracion.motivo_nota_credito VALUES (2, '02', 'ANULACION POR ERROR EN EL RUC', false, true, true, '2026-03-16 09:20:16.555568-05', 'SYSTEM', NULL, NULL);
INSERT INTO configuracion.motivo_nota_credito VALUES (3, '03', 'CORRECCION POR ERROR EN LA DESCRIPCION', false, true, true, '2026-03-16 09:20:16.555568-05', 'SYSTEM', NULL, NULL);
INSERT INTO configuracion.motivo_nota_credito VALUES (4, '04', 'DESCUENTO GLOBAL', false, true, true, '2026-03-16 09:20:16.555568-05', 'SYSTEM', NULL, NULL);
INSERT INTO configuracion.motivo_nota_credito VALUES (5, '05', 'DESCUENTO POR ITEM', false, true, true, '2026-03-16 09:20:16.555568-05', 'SYSTEM', NULL, NULL);
INSERT INTO configuracion.motivo_nota_credito VALUES (6, '06', 'DEVOLUCION TOTAL', true, true, true, '2026-03-16 09:20:16.555568-05', 'SYSTEM', NULL, NULL);
INSERT INTO configuracion.motivo_nota_credito VALUES (7, '07', 'DEVOLUCION POR ITEM', true, true, true, '2026-03-16 09:20:16.555568-05', 'SYSTEM', NULL, NULL);
INSERT INTO configuracion.motivo_nota_credito VALUES (8, '08', 'BONIFICACION', false, true, true, '2026-03-16 09:20:16.555568-05', 'SYSTEM', NULL, NULL);
INSERT INTO configuracion.motivo_nota_credito VALUES (9, '09', 'DISMINUCION EN EL VALOR', false, true, true, '2026-03-16 09:20:16.555568-05', 'SYSTEM', NULL, NULL);
INSERT INTO configuracion.motivo_nota_credito VALUES (10, '10', 'OTROS CONCEPTOS', false, true, true, '2026-03-16 09:20:16.555568-05', 'SYSTEM', NULL, NULL);
INSERT INTO configuracion.motivo_nota_credito VALUES (11, '11', 'AJUSTES DE OPERACIONES DE EXPORTACION', false, true, true, '2026-03-16 09:20:16.555568-05', 'SYSTEM', NULL, NULL);
INSERT INTO configuracion.motivo_nota_credito VALUES (12, '12', 'AJUSTE AFECTO AL IVAP', false, true, true, '2026-03-16 09:20:16.555568-05', 'SYSTEM', NULL, NULL);
INSERT INTO configuracion.motivo_nota_credito VALUES (13, '13', 'CORRECCION DE LA DESCRIPCION', false, true, true, '2026-03-16 09:20:16.555568-05', 'SYSTEM', NULL, NULL);


--
-- TOC entry 4667 (class 0 OID 47723)
-- Dependencies: 338
-- Data for Name: motivo_nota_debito; Type: TABLE DATA; Schema: configuracion; Owner: postgres
--

INSERT INTO configuracion.motivo_nota_debito VALUES (1, '01', 'INTERES POR MORA', true, true, '2026-03-16 09:20:16.556913-05', 'SYSTEM', NULL, NULL);
INSERT INTO configuracion.motivo_nota_debito VALUES (2, '02', 'AUMENTO EN EL VALOR', true, true, '2026-03-16 09:20:16.556913-05', 'SYSTEM', NULL, NULL);
INSERT INTO configuracion.motivo_nota_debito VALUES (3, '03', 'PENALIDADES / OTROS CONCEPTOS', true, true, '2026-03-16 09:20:16.556913-05', 'SYSTEM', NULL, NULL);
INSERT INTO configuracion.motivo_nota_debito VALUES (4, '10', 'OTROS CONCEPTOS', true, true, '2026-03-16 09:20:16.556913-05', 'SYSTEM', NULL, NULL);
INSERT INTO configuracion.motivo_nota_debito VALUES (5, '11', 'AJUSTES DE OPERACIONES DE EXPORTACION', true, true, '2026-03-16 09:20:16.556913-05', 'SYSTEM', NULL, NULL);
INSERT INTO configuracion.motivo_nota_debito VALUES (6, '12', 'AJUSTE AFECTO AL IVAP', true, true, '2026-03-16 09:20:16.556913-05', 'SYSTEM', NULL, NULL);


--
-- TOC entry 4655 (class 0 OID 47345)
-- Dependencies: 326
-- Data for Name: parametros_configuracion; Type: TABLE DATA; Schema: configuracion; Owner: postgres
--

INSERT INTO configuracion.parametros_configuracion VALUES (1, 'MONEDA_DEFECTO', 'PEN', 'Moneda por defecto del sistema', 'GENERAL', true, '2026-03-16 09:20:16.084486', 'SYSTEM', NULL, NULL);
INSERT INTO configuracion.parametros_configuracion VALUES (2, 'IGV_DEFECTO', '18.00', 'Porcentaje de IGV actual', 'FISCAL', true, '2026-03-16 09:20:16.084486', 'SYSTEM', NULL, NULL);


--
-- TOC entry 4649 (class 0 OID 47253)
-- Dependencies: 320
-- Data for Name: regla_documento_comprobante; Type: TABLE DATA; Schema: configuracion; Owner: postgres
--

INSERT INTO configuracion.regla_documento_comprobante VALUES (18, '6', 1, true, '2026-03-21 18:47:09.990392-05', 'SYSTEM', NULL, NULL);
INSERT INTO configuracion.regla_documento_comprobante VALUES (19, '6', 2, true, '2026-03-21 18:47:09.990392-05', 'SYSTEM', NULL, NULL);
INSERT INTO configuracion.regla_documento_comprobante VALUES (20, '6', 3, true, '2026-03-21 18:47:09.990392-05', 'SYSTEM', NULL, NULL);
INSERT INTO configuracion.regla_documento_comprobante VALUES (21, '6', 4, true, '2026-03-21 18:47:09.990392-05', 'SYSTEM', NULL, NULL);
INSERT INTO configuracion.regla_documento_comprobante VALUES (22, '1', 2, true, '2026-03-21 18:47:09.990392-05', 'SYSTEM', NULL, NULL);
INSERT INTO configuracion.regla_documento_comprobante VALUES (23, '1', 3, true, '2026-03-21 18:47:09.990392-05', 'SYSTEM', NULL, NULL);
INSERT INTO configuracion.regla_documento_comprobante VALUES (24, '4', 2, true, '2026-03-21 18:47:09.990392-05', 'SYSTEM', NULL, NULL);
INSERT INTO configuracion.regla_documento_comprobante VALUES (25, '7', 2, true, '2026-03-21 18:47:09.990392-05', 'SYSTEM', NULL, NULL);
INSERT INTO configuracion.regla_documento_comprobante VALUES (26, '0', 2, true, '2026-03-21 18:47:09.990392-05', 'SYSTEM', NULL, NULL);


--
-- TOC entry 4581 (class 0 OID 46386)
-- Dependencies: 252
-- Data for Name: series_comprobantes; Type: TABLE DATA; Schema: configuracion; Owner: postgres
--

INSERT INTO configuracion.series_comprobantes VALUES (1, 'F001', 0, 1, true, '2026-03-21 22:45:45.656309', 'SYSTEM', '2026-03-21 22:45:45.656309', NULL, 1);
INSERT INTO configuracion.series_comprobantes VALUES (3, 'FC01', 0, 1, true, '2026-03-21 22:45:45.656309', 'SYSTEM', '2026-03-21 22:45:45.656309', NULL, 5);
INSERT INTO configuracion.series_comprobantes VALUES (4, 'FD01', 0, 1, true, '2026-03-21 22:45:45.656309', 'SYSTEM', '2026-03-21 22:45:45.656309', NULL, 6);
INSERT INTO configuracion.series_comprobantes VALUES (5, 'OC01', 1, 1, true, '2026-03-21 23:22:28.174026', 'SYSTEM', '2026-03-21 23:22:28.174026', NULL, 13);
INSERT INTO configuracion.series_comprobantes VALUES (2, 'B001', 5, 1, true, '2026-03-21 02:45:45.656309', 'SYSTEM', '2026-03-29 13:18:01.554799', 'SISTEMA', 2);


--
-- TOC entry 4651 (class 0 OID 47315)
-- Dependencies: 322
-- Data for Name: sucursales; Type: TABLE DATA; Schema: configuracion; Owner: postgres
--

INSERT INTO configuracion.sucursales VALUES (1, 1, '001', 'Sucursal Principal', 'Av. Principal 123', NULL, true, true, '2026-03-16 09:20:16.085556', 'SYSTEM', NULL, NULL);


--
-- TOC entry 4583 (class 0 OID 46394)
-- Dependencies: 254
-- Data for Name: tablas_generales; Type: TABLE DATA; Schema: configuracion; Owner: postgres
--

INSERT INTO configuracion.tablas_generales VALUES (1, 'TIPO_DOCUMENTO', 'Tipos de Documento de Identidad', NULL, true, '2026-01-27 20:38:29.859421-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales VALUES (3, 'TIPO_CLIENTE', 'Tipos de Cliente', NULL, true, '2026-01-27 20:38:29.870662-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales VALUES (4, 'TIPO_MOVIMIENTO_CAJA', 'Tipos de Movimiento de Caja', NULL, true, '2026-01-27 20:38:29.871674-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales VALUES (5, 'TIPO_PRODUCTO', 'Tipos de Producto', NULL, true, '2026-01-27 20:38:29.872644-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales VALUES (6, 'TIPO_MOVIMIENTO_INVENTARIO', 'Tipos de Movimiento de Inventario', NULL, true, '2026-01-27 20:38:29.873586-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales VALUES (7, 'TIPO_CUENTA_CONTABLE', 'Tipos de Cuenta Contable', NULL, true, '2026-01-27 20:38:29.87462-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales VALUES (8, 'ESTADO_VENTA', 'Estados de Venta', NULL, true, '2026-01-27 20:38:29.875555-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales VALUES (9, 'ESTADO_COTIZACION', 'Estados de CotizaciÃƒÂ³n', NULL, true, '2026-01-27 20:38:29.876572-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales VALUES (10, 'ESTADO_CAJA', 'Estados de Caja', NULL, true, '2026-01-27 20:38:29.877676-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales VALUES (11, 'ESTADO_ORDEN_COMPRA', 'Estados de Orden de Compra', NULL, true, '2026-01-27 20:38:29.878602-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales VALUES (12, 'ESTADO_ASIENTO', 'Estados de Asiento Contable', NULL, true, '2026-01-27 20:38:29.879531-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales VALUES (13, 'ESTADO_PAGO', 'Estados de Pago', NULL, true, '2026-01-27 20:38:29.880536-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales VALUES (14, 'TIPO_MONEDA', 'Tipos de Moneda', NULL, true, '2026-02-12 20:00:00-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales VALUES (2, 'TIPO_COMPROBANTE', 'Tipos de Comprobante de Pago', NULL, true, '2026-01-27 20:38:29.869526-05', 'SISTEMA', NULL, NULL, true);


--
-- TOC entry 4584 (class 0 OID 46402)
-- Dependencies: 255
-- Data for Name: tablas_generales_detalle; Type: TABLE DATA; Schema: configuracion; Owner: postgres
--

INSERT INTO configuracion.tablas_generales_detalle VALUES (1, 1, 'DNI', 'Documento Nacional de Identidad', NULL, 1, true, '2026-01-27 20:38:29.865474-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (2, 1, 'RUC', 'Registro ÃƒÅ¡nico de Contribuyentes', NULL, 2, true, '2026-01-27 20:38:29.865474-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (3, 1, 'CE', 'Carnet de ExtranjerÃƒÂ­a', NULL, 3, true, '2026-01-27 20:38:29.865474-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (4, 1, 'PAS', 'Pasaporte', NULL, 4, true, '2026-01-27 20:38:29.865474-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (100, 11, 'FAC', 'Facturada', 'Orden de Compra Facturada', 5, true, '2026-03-26 22:50:33.71874-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (9, 3, 'PUB', 'PÃƒÂºblico General', NULL, 1, true, '2026-01-27 20:38:29.871144-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (10, 3, 'CORP', 'Corporativo', NULL, 2, true, '2026-01-27 20:38:29.871144-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (11, 3, 'VIP', 'Cliente VIP', NULL, 3, true, '2026-01-27 20:38:29.871144-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (12, 4, 'ING', 'Ingreso', NULL, 1, true, '2026-01-27 20:38:29.87213-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (13, 4, 'EGR', 'Egreso', NULL, 2, true, '2026-01-27 20:38:29.87213-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (14, 4, 'APE', 'Apertura', NULL, 3, true, '2026-01-27 20:38:29.87213-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (15, 4, 'CIE', 'Cierre', NULL, 4, true, '2026-01-27 20:38:29.87213-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (16, 5, 'PROD', 'Producto Terminado', NULL, 1, true, '2026-01-27 20:38:29.873074-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (17, 5, 'SERV', 'Servicio', NULL, 2, true, '2026-01-27 20:38:29.873074-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (18, 5, 'INS', 'Insumo', NULL, 3, true, '2026-01-27 20:38:29.873074-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (19, 6, 'ING_COM', 'Ingreso por Compra', NULL, 1, true, '2026-01-27 20:38:29.874075-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (20, 6, 'SAL_VEN', 'Salida por Venta', NULL, 2, true, '2026-01-27 20:38:29.874075-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (21, 6, 'AJU_POS', 'Ajuste Positivo', NULL, 3, true, '2026-01-27 20:38:29.874075-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (22, 6, 'AJU_NEG', 'Ajuste Negativo', NULL, 4, true, '2026-01-27 20:38:29.874075-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (23, 6, 'TRA_ALM', 'Transferencia entre Almacenes', NULL, 5, true, '2026-01-27 20:38:29.874075-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (24, 7, 'ACT', 'Activo', NULL, 1, true, '2026-01-27 20:38:29.875044-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (25, 7, 'PAS', 'Pasivo', NULL, 2, true, '2026-01-27 20:38:29.875044-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (26, 7, 'PAT', 'Patrimonio', NULL, 3, true, '2026-01-27 20:38:29.875044-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (27, 7, 'ING', 'Ingresos', NULL, 4, true, '2026-01-27 20:38:29.875044-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (28, 7, 'GAS', 'Gastos', NULL, 5, true, '2026-01-27 20:38:29.875044-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (29, 8, 'COM', 'Completada', NULL, 1, true, '2026-01-27 20:38:29.876001-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (30, 8, 'ANU', 'Anulada', NULL, 2, true, '2026-01-27 20:38:29.876001-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (31, 8, 'PPG', 'Pendiente de Pago', NULL, 3, true, '2026-01-27 20:38:29.876001-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (32, 9, 'PEN', 'Pendiente', NULL, 1, true, '2026-01-27 20:38:29.87705-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (33, 9, 'APR', 'Aprobada', NULL, 2, true, '2026-01-27 20:38:29.87705-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (34, 9, 'REC', 'Rechazada', NULL, 3, true, '2026-01-27 20:38:29.87705-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (35, 9, 'VEN', 'Vencida', NULL, 4, true, '2026-01-27 20:38:29.87705-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (51, 14, 'PEN', 'Sol', 'S/', 1, true, '2026-02-12 20:00:00-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (52, 14, 'USD', 'DÃ³lar Americano', '$', 2, true, '2026-02-12 20:00:00-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (37, 10, 'ABI', 'Abierta', NULL, 1, true, '2026-01-27 20:38:29.878144-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (38, 10, 'CIE', 'Cerrada', NULL, 2, true, '2026-01-27 20:38:29.878144-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (39, 11, 'BOR', 'Borrador', NULL, 1, true, '2026-01-27 20:38:29.879005-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (40, 11, 'PEN', 'Pendiente', NULL, 2, true, '2026-01-27 20:38:29.879005-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (41, 11, 'APR', 'Aprobada', NULL, 3, true, '2026-01-27 20:38:29.879005-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (42, 11, 'REC', 'Rechazada', NULL, 4, true, '2026-01-27 20:38:29.879005-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (44, 12, 'PEN', 'Pendiente', NULL, 2, true, '2026-01-27 20:38:29.880009-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (45, 12, 'ANU', 'Anulado', NULL, 3, true, '2026-01-27 20:38:29.880009-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (46, 13, 'PAG', 'Pagado', NULL, 1, true, '2026-01-27 20:38:29.881027-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (47, 13, 'PAR', 'Parcial', NULL, 2, true, '2026-01-27 20:38:29.881027-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (48, 13, 'CRE', 'A CrÃƒÂ©dito', NULL, 3, true, '2026-01-27 20:38:29.881027-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (49, 13, 'PEN', 'Pendiente', NULL, 4, true, '2026-01-27 20:38:29.881027-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (50, 13, 'ANU', 'Anulado', NULL, 5, true, '2026-01-27 20:38:29.881027-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (5, 2, 'BOL', 'Boleta de Venta', NULL, 1, true, '2026-01-27 20:38:29.870018-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (6, 2, 'FAC', 'Factura', NULL, 2, true, '2026-01-27 20:38:29.870018-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (7, 2, 'NVT', 'Nota de Venta', NULL, 3, true, '2026-01-27 20:38:29.870018-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (8, 2, 'TK', 'Ticket', NULL, 4, true, '2026-01-27 20:38:29.870018-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (36, 9, 'CVT', 'Convertida a Venta', NULL, 5, true, '2026-01-27 20:38:29.87705-05', 'SISTEMA', NULL, NULL, true);


--
-- TOC entry 4663 (class 0 OID 47695)
-- Dependencies: 334
-- Data for Name: tipo_afectacion_igv; Type: TABLE DATA; Schema: configuracion; Owner: postgres
--

INSERT INTO configuracion.tipo_afectacion_igv VALUES (1, '10', 'GRAVADO - OPERACION ONEROSA', true, false, true, true, '2026-03-16 09:20:16.533236-05', 'SYSTEM', NULL, NULL, NULL);
INSERT INTO configuracion.tipo_afectacion_igv VALUES (2, '11', 'GRAVADO - RETIRO POR PREMIO', true, false, true, true, '2026-03-16 09:20:16.533236-05', 'SYSTEM', NULL, NULL, NULL);
INSERT INTO configuracion.tipo_afectacion_igv VALUES (3, '12', 'GRAVADO - RETIRO POR DONACION', true, false, true, true, '2026-03-16 09:20:16.533236-05', 'SYSTEM', NULL, NULL, NULL);
INSERT INTO configuracion.tipo_afectacion_igv VALUES (4, '13', 'GRAVADO - RETIRO', true, false, true, true, '2026-03-16 09:20:16.533236-05', 'SYSTEM', NULL, NULL, NULL);
INSERT INTO configuracion.tipo_afectacion_igv VALUES (5, '14', 'GRAVADO - RETIRO POR PUBLICIDAD', true, false, true, true, '2026-03-16 09:20:16.533236-05', 'SYSTEM', NULL, NULL, NULL);
INSERT INTO configuracion.tipo_afectacion_igv VALUES (6, '15', 'GRAVADO - BONIFICACIONES', true, false, true, true, '2026-03-16 09:20:16.533236-05', 'SYSTEM', NULL, NULL, NULL);
INSERT INTO configuracion.tipo_afectacion_igv VALUES (7, '16', 'GRAVADO - RETIRO POR ENTREGA A TRABAJADORES', true, false, true, true, '2026-03-16 09:20:16.533236-05', 'SYSTEM', NULL, NULL, NULL);
INSERT INTO configuracion.tipo_afectacion_igv VALUES (8, '17', 'GRAVADO - IVAP', true, false, true, true, '2026-03-16 09:20:16.533236-05', 'SYSTEM', NULL, NULL, NULL);
INSERT INTO configuracion.tipo_afectacion_igv VALUES (9, '20', 'EXONERADO - OPERACION ONEROSA', false, false, true, true, '2026-03-16 09:20:16.533236-05', 'SYSTEM', NULL, NULL, NULL);
INSERT INTO configuracion.tipo_afectacion_igv VALUES (10, '21', 'EXONERADO - TRANSFERENCIA GRATUITA', false, false, true, true, '2026-03-16 09:20:16.533236-05', 'SYSTEM', NULL, NULL, NULL);
INSERT INTO configuracion.tipo_afectacion_igv VALUES (11, '30', 'INAFECTO - OPERACION ONEROSA', false, false, true, true, '2026-03-16 09:20:16.533236-05', 'SYSTEM', NULL, NULL, NULL);
INSERT INTO configuracion.tipo_afectacion_igv VALUES (12, '31', 'INAFECTO - RETIRO POR BONIFICACION', false, false, true, true, '2026-03-16 09:20:16.533236-05', 'SYSTEM', NULL, NULL, NULL);
INSERT INTO configuracion.tipo_afectacion_igv VALUES (13, '32', 'INAFECTO - RETIRO', false, false, true, true, '2026-03-16 09:20:16.533236-05', 'SYSTEM', NULL, NULL, NULL);
INSERT INTO configuracion.tipo_afectacion_igv VALUES (14, '33', 'INAFECTO - RETIRO POR MUESTRAS MEDICAS', false, false, true, true, '2026-03-16 09:20:16.533236-05', 'SYSTEM', NULL, NULL, NULL);
INSERT INTO configuracion.tipo_afectacion_igv VALUES (15, '34', 'INAFECTO - TRANSFERENCIA GRATUITA', false, false, true, true, '2026-03-16 09:20:16.533236-05', 'SYSTEM', NULL, NULL, NULL);
INSERT INTO configuracion.tipo_afectacion_igv VALUES (16, '35', 'INAFECTO - RETIRO POR PUBLICIDAD', false, false, true, true, '2026-03-16 09:20:16.533236-05', 'SYSTEM', NULL, NULL, NULL);
INSERT INTO configuracion.tipo_afectacion_igv VALUES (17, '36', 'INAFECTO - BONIFICACIONES', false, false, true, true, '2026-03-16 09:20:16.533236-05', 'SYSTEM', NULL, NULL, NULL);
INSERT INTO configuracion.tipo_afectacion_igv VALUES (18, '37', 'INAFECTO - RETIRO POR ENTREGA A TRABAJADORES', false, false, true, true, '2026-03-16 09:20:16.533236-05', 'SYSTEM', NULL, NULL, NULL);
INSERT INTO configuracion.tipo_afectacion_igv VALUES (19, '40', 'EXPORTACION DE BIENES O SERVICIOS', false, true, true, true, '2026-03-16 09:20:16.533236-05', 'SYSTEM', NULL, NULL, NULL);


--
-- TOC entry 4643 (class 0 OID 47212)
-- Dependencies: 314
-- Data for Name: tipo_comprobante; Type: TABLE DATA; Schema: configuracion; Owner: postgres
--

INSERT INTO configuracion.tipo_comprobante VALUES (1, '01', 'FACTURA', true, 'SALIDA', true, false, false, true, '2026-03-16 09:20:16.511112-05', 'SYSTEM', true, true, 'SALIDA', 'NEUTRO', NULL, NULL);
INSERT INTO configuracion.tipo_comprobante VALUES (2, '03', 'BOLETA DE VENTA', true, 'SALIDA', true, false, false, true, '2026-03-16 09:20:16.511112-05', 'SYSTEM', true, true, 'SALIDA', 'NEUTRO', NULL, NULL);
INSERT INTO configuracion.tipo_comprobante VALUES (3, '02', 'RECIBO POR HONORARIOS', false, 'NEUTRO', true, false, false, true, '2026-03-16 09:20:16.511112-05', 'SYSTEM', true, true, 'NEUTRO', 'NEUTRO', NULL, NULL);
INSERT INTO configuracion.tipo_comprobante VALUES (4, '04', 'LIQUIDACION DE COMPRA', true, 'ENTRADA', false, true, false, true, '2026-03-16 09:20:16.511112-05', 'SYSTEM', true, true, 'NEUTRO', 'ENTRADA', NULL, NULL);
INSERT INTO configuracion.tipo_comprobante VALUES (5, '07', 'NOTA DE CREDITO', true, 'DEPENDIENTE', false, false, false, true, '2026-03-16 09:20:16.511112-05', 'SYSTEM', true, true, 'ENTRADA', 'SALIDA', NULL, NULL);
INSERT INTO configuracion.tipo_comprobante VALUES (6, '08', 'NOTA DE DEBITO', false, 'NEUTRO', false, false, false, true, '2026-03-16 09:20:16.511112-05', 'SYSTEM', true, true, 'NEUTRO', 'NEUTRO', NULL, NULL);
INSERT INTO configuracion.tipo_comprobante VALUES (7, '09', 'GUIA DE REMISION REMITENTE', false, 'NEUTRO', false, false, false, true, '2026-03-16 09:20:16.511112-05', 'SYSTEM', false, true, 'NEUTRO', 'NEUTRO', NULL, NULL);
INSERT INTO configuracion.tipo_comprobante VALUES (8, '31', 'GUIA DE REMISION TRANSPORTISTA', false, 'NEUTRO', false, false, false, true, '2026-03-16 09:20:16.511112-05', 'SYSTEM', false, true, 'NEUTRO', 'NEUTRO', NULL, NULL);
INSERT INTO configuracion.tipo_comprobante VALUES (9, '50', 'DUA', false, 'NEUTRO', false, false, false, true, '2026-03-16 09:20:16.511112-05', 'SYSTEM', false, true, 'NEUTRO', 'NEUTRO', NULL, NULL);
INSERT INTO configuracion.tipo_comprobante VALUES (10, '52', 'DESPACHO SIMPLIFICADO', false, 'NEUTRO', false, false, false, true, '2026-03-16 09:20:16.511112-05', 'SYSTEM', false, true, 'NEUTRO', 'NEUTRO', NULL, NULL);
INSERT INTO configuracion.tipo_comprobante VALUES (11, '87', 'NOTA DE CREDITO ESPECIAL', false, 'NEUTRO', false, false, false, true, '2026-03-16 09:20:16.511112-05', 'SYSTEM', false, true, 'NEUTRO', 'NEUTRO', NULL, NULL);
INSERT INTO configuracion.tipo_comprobante VALUES (12, '88', 'NOTA DE DEBITO ESPECIAL', false, 'NEUTRO', false, false, false, true, '2026-03-16 09:20:16.511112-05', 'SYSTEM', false, true, 'NEUTRO', 'NEUTRO', NULL, NULL);
INSERT INTO configuracion.tipo_comprobante VALUES (13, '99', 'ORDEN DE COMPRA', false, 'NEUTRO', false, false, true, true, '2026-03-21 23:22:28.165364-05', 'SYSTEM', true, true, 'NEUTRO', 'NEUTRO', NULL, NULL);


--
-- TOC entry 4641 (class 0 OID 47198)
-- Dependencies: 312
-- Data for Name: tipo_documento; Type: TABLE DATA; Schema: configuracion; Owner: postgres
--

INSERT INTO configuracion.tipo_documento VALUES (6, 'A', 'CEDULA DIPLOMATICA de IDENTIDAD', 6, 15, false, true, true, '2026-03-16 09:20:16.504337-05', 'SYSTEM', true, false, false, false, true, NULL, NULL);
INSERT INTO configuracion.tipo_documento VALUES (7, 'B', 'DOC. IDENTIDAD PAIS DE RESIDENCIA', 6, 15, false, true, true, '2026-03-16 09:20:16.504337-05', 'SYSTEM', true, false, false, false, true, NULL, NULL);
INSERT INTO configuracion.tipo_documento VALUES (1, '0', 'SIN DOCUMENTO', 1, 1, false, true, true, '2026-03-16 09:20:16.504337-05', 'SYSTEM', true, false, true, false, true, '2026-03-21 21:01:41.451695-05', NULL);
INSERT INTO configuracion.tipo_documento VALUES (2, '1', 'DNI', 8, 8, true, true, true, '2026-03-16 09:20:16.504337-05', 'SYSTEM', true, false, false, false, true, '2026-03-21 21:01:41.451695-05', NULL);
INSERT INTO configuracion.tipo_documento VALUES (3, '4', 'CARNET DE EXTRANJERIA', 9, 12, false, true, true, '2026-03-16 09:20:16.504337-05', 'SYSTEM', true, false, false, false, true, '2026-03-21 21:01:41.451695-05', NULL);
INSERT INTO configuracion.tipo_documento VALUES (4, '6', 'RUC', 11, 11, true, true, true, '2026-03-16 09:20:16.504337-05', 'SYSTEM', false, true, false, false, true, '2026-03-21 21:01:41.451695-05', NULL);
INSERT INTO configuracion.tipo_documento VALUES (5, '7', 'PASAPORTE', 6, 17, false, true, true, '2026-03-16 09:20:16.504337-05', 'SYSTEM', true, false, false, false, true, '2026-03-21 21:01:41.451695-05', NULL);


--
-- TOC entry 4645 (class 0 OID 47228)
-- Dependencies: 316
-- Data for Name: tipo_operacion_sunat; Type: TABLE DATA; Schema: configuracion; Owner: postgres
--

INSERT INTO configuracion.tipo_operacion_sunat VALUES (1, '0101', 'VENTA INTERNA', true, '2026-03-16 09:20:16.512683', 'SYSTEM', NULL, NULL, true, true, false, false);
INSERT INTO configuracion.tipo_operacion_sunat VALUES (2, '0112', 'VENTA INTERNA - GASTOS DEDUCIBLES', true, '2026-03-16 09:20:16.512683', 'SYSTEM', NULL, NULL, true, true, false, false);
INSERT INTO configuracion.tipo_operacion_sunat VALUES (3, '0113', 'VENTA INTERNA - NRUS', true, '2026-03-16 09:20:16.512683', 'SYSTEM', NULL, NULL, true, true, false, false);
INSERT INTO configuracion.tipo_operacion_sunat VALUES (4, '0200', 'EXPORTACION DE BIENES', true, '2026-03-16 09:20:16.512683', 'SYSTEM', NULL, NULL, true, true, false, false);
INSERT INTO configuracion.tipo_operacion_sunat VALUES (5, '0201', 'EXPORTACION DE SERVICIOS', true, '2026-03-16 09:20:16.512683', 'SYSTEM', NULL, NULL, true, true, false, false);
INSERT INTO configuracion.tipo_operacion_sunat VALUES (6, '0202', 'EXPORTACION - HOSPEDAJE', true, '2026-03-16 09:20:16.512683', 'SYSTEM', NULL, NULL, true, true, false, false);
INSERT INTO configuracion.tipo_operacion_sunat VALUES (7, '0300', 'NO ONEROSA - ADQUISICION DE BIENES', true, '2026-03-16 09:20:16.512683', 'SYSTEM', NULL, NULL, true, true, false, false);
INSERT INTO configuracion.tipo_operacion_sunat VALUES (8, '0401', 'TRASLADO ENTRE ESTABLECIMIENTOS', true, '2026-03-16 09:20:16.512683', 'SYSTEM', NULL, NULL, true, true, false, false);
INSERT INTO configuracion.tipo_operacion_sunat VALUES (9, '1001', 'OPERACION SUJETA A DETRACCION', true, '2026-03-16 09:20:16.512683', 'SYSTEM', NULL, NULL, true, true, false, false);
INSERT INTO configuracion.tipo_operacion_sunat VALUES (10, '2001', 'OPERACION SUJETA A PERCEPCION', true, '2026-03-16 09:20:16.512683', 'SYSTEM', NULL, NULL, true, true, false, false);


--
-- TOC entry 4688 (class 0 OID 66867)
-- Dependencies: 359
-- Data for Name: ubigeos; Type: TABLE DATA; Schema: configuracion; Owner: postgres
--

INSERT INTO configuracion.ubigeos VALUES ('01', 'AMAZONAS', 1, NULL, 1, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('02', 'ANCASH', 1, NULL, 2, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('03', 'APURIMAC', 1, NULL, 3, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('04', 'AREQUIPA', 1, NULL, 4, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('05', 'AYACUCHO', 1, NULL, 5, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('06', 'CAJAMARCA', 1, NULL, 6, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('07', 'CALLAO', 1, NULL, 7, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('08', 'CUSCO', 1, NULL, 8, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('09', 'HUANCAVELICA', 1, NULL, 9, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('10', 'HUANUCO', 1, NULL, 10, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('11', 'ICA', 1, NULL, 11, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('12', 'JUNIN', 1, NULL, 12, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('13', 'LA LIBERTAD', 1, NULL, 13, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('14', 'LAMBAYEQUE', 1, NULL, 14, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('15', 'LIMA', 1, NULL, 15, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('16', 'LORETO', 1, NULL, 16, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('17', 'MADRE DE DIOS', 1, NULL, 17, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('18', 'MOQUEGUA', 1, NULL, 18, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('19', 'PASCO', 1, NULL, 19, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('20', 'PIURA', 1, NULL, 20, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('21', 'PUNO', 1, NULL, 21, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('22', 'SAN MARTIN', 1, NULL, 22, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('23', 'TACNA', 1, NULL, 23, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('24', 'TUMBES', 1, NULL, 24, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('25', 'UCAYALI', 1, NULL, 25, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0101', 'CHACHAPOYAS', 2, '01', 26, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0102', 'BAGUA', 2, '01', 27, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0103', 'BONGARA', 2, '01', 28, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0104', 'CONDORCANQUI', 2, '01', 29, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0105', 'LUYA', 2, '01', 30, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0106', 'RODRIGUEZ DE MENDOZA', 2, '01', 31, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0107', 'UTCUBAMBA', 2, '01', 32, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0201', 'HUARAZ', 2, '02', 33, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0202', 'AIJA', 2, '02', 34, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0203', 'ANTONIO RAYMONDI', 2, '02', 35, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0204', 'ASUNCION', 2, '02', 36, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0205', 'BOLOGNESI', 2, '02', 37, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0206', 'CARHUAZ', 2, '02', 38, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0207', 'CARLOS FERMIN FITZCARRALD', 2, '02', 39, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0208', 'CASMA', 2, '02', 40, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0209', 'CORONGO', 2, '02', 41, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0210', 'HUARI', 2, '02', 42, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0211', 'HUARMEY', 2, '02', 43, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0212', 'HUAYLAS', 2, '02', 44, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0213', 'MARISCAL LUZURIAGA', 2, '02', 45, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0214', 'OCROS', 2, '02', 46, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0215', 'PALLASCA', 2, '02', 47, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0216', 'POMABAMBA', 2, '02', 48, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0217', 'RECUAY', 2, '02', 49, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0218', 'SANTA', 2, '02', 50, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0219', 'SIHUAS', 2, '02', 51, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0220', 'YUNGAY', 2, '02', 52, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0301', 'ABANCAY', 2, '03', 53, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0302', 'ANDAHUAYLAS', 2, '03', 54, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0303', 'ANTABAMBA', 2, '03', 55, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0304', 'AYMARAES', 2, '03', 56, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0305', 'COTABAMBAS', 2, '03', 57, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0306', 'CHINCHEROS', 2, '03', 58, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0307', 'GRAU', 2, '03', 59, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0401', 'AREQUIPA', 2, '04', 60, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0402', 'CAMANA', 2, '04', 61, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0403', 'CARAVELI', 2, '04', 62, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0404', 'CASTILLA', 2, '04', 63, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0405', 'CAYLLOMA', 2, '04', 64, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0406', 'CONDESUYOS', 2, '04', 65, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0407', 'ISLAY', 2, '04', 66, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0408', 'LA UNION', 2, '04', 67, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0501', 'HUAMANGA', 2, '05', 68, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0502', 'CANGALLO', 2, '05', 69, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0503', 'HUANCA SANCOS', 2, '05', 70, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0504', 'HUANTA', 2, '05', 71, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0505', 'LA MAR', 2, '05', 72, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0506', 'LUCANAS', 2, '05', 73, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0507', 'PARINACOCHAS', 2, '05', 74, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0508', 'PAUCAR DEL SARA SARA', 2, '05', 75, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0509', 'SUCRE', 2, '05', 76, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0510', 'VICTOR FAJARDO', 2, '05', 77, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0511', 'VILCAS HUAMAN', 2, '05', 78, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0601', 'CAJAMARCA', 2, '06', 79, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0602', 'CAJABAMBA', 2, '06', 80, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0603', 'CELENDIN', 2, '06', 81, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0604', 'CHOTA', 2, '06', 82, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0605', 'CONTUMAZA', 2, '06', 83, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0606', 'CUTERVO', 2, '06', 84, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0607', 'HUALGAYOC', 2, '06', 85, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0608', 'JAEN', 2, '06', 86, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0609', 'SAN IGNACIO', 2, '06', 87, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0610', 'SAN MARCOS', 2, '06', 88, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0611', 'SAN MIGUEL', 2, '06', 89, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0612', 'SAN PABLO', 2, '06', 90, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0613', 'SANTA CRUZ', 2, '06', 91, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0701', 'CALLAO', 2, '07', 92, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0801', 'CUSCO', 2, '08', 93, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0802', 'ACOMAYO', 2, '08', 94, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0803', 'ANTA', 2, '08', 95, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0804', 'CALCA', 2, '08', 96, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0805', 'CANAS', 2, '08', 97, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0806', 'CANCHIS', 2, '08', 98, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0807', 'CHUMBIVILCAS', 2, '08', 99, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0808', 'ESPINAR', 2, '08', 100, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0809', 'LA CONVENCION', 2, '08', 101, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0810', 'PARURO', 2, '08', 102, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0811', 'PAUCARTAMBO', 2, '08', 103, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0812', 'QUISPICANCHI', 2, '08', 104, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0813', 'URUBAMBA', 2, '08', 105, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0901', 'HUANCAVELICA', 2, '09', 106, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0902', 'ACOBAMBA', 2, '09', 107, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0903', 'ANGARAES', 2, '09', 108, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0904', 'CASTROVIRREYNA', 2, '09', 109, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0905', 'CHURCAMPA', 2, '09', 110, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0906', 'HUAYTARA', 2, '09', 111, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('0907', 'TAYACAJA', 2, '09', 112, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1001', 'HUANUCO', 2, '10', 113, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1002', 'AMBO', 2, '10', 114, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1003', 'DOS DE MAYO', 2, '10', 115, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1004', 'HUACAYBAMBA', 2, '10', 116, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1005', 'HUAMALIES', 2, '10', 117, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1006', 'LEONCIO PRADO', 2, '10', 118, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1007', 'MARAÑON', 2, '10', 119, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1008', 'PACHITEA', 2, '10', 120, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1009', 'PUERTO INCA', 2, '10', 121, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1010', 'LAURICOCHA', 2, '10', 122, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1011', 'YAROWILCA', 2, '10', 123, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1101', 'ICA', 2, '11', 124, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1102', 'CHINCHA', 2, '11', 125, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1103', 'NAZCA', 2, '11', 126, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1104', 'PALPA', 2, '11', 127, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1105', 'PISCO', 2, '11', 128, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1201', 'HUANCAYO', 2, '12', 129, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1202', 'CONCEPCION', 2, '12', 130, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1203', 'CHANCHAMAYO', 2, '12', 131, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1204', 'JAUJA', 2, '12', 132, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1205', 'JUNIN', 2, '12', 133, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1206', 'SATIPO', 2, '12', 134, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1207', 'TARMA', 2, '12', 135, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1208', 'YAULI', 2, '12', 136, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1209', 'CHUPACA', 2, '12', 137, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1301', 'TRUJILLO', 2, '13', 138, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1302', 'ASCOPE', 2, '13', 139, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1303', 'BOLIVAR', 2, '13', 140, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1304', 'CHEPEN', 2, '13', 141, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1305', 'JULCAN', 2, '13', 142, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1306', 'OTUZCO', 2, '13', 143, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1307', 'PACASMAYO', 2, '13', 144, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1308', 'PATAZ', 2, '13', 145, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1309', 'SANCHEZ CARRION', 2, '13', 146, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1310', 'SANTIAGO DE CHUCO', 2, '13', 147, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1311', 'GRAN CHIMU', 2, '13', 148, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1312', 'VIRU', 2, '13', 149, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1401', 'CHICLAYO', 2, '14', 150, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1402', 'FERREÑAFE', 2, '14', 151, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1403', 'LAMBAYEQUE', 2, '14', 152, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1501', 'LIMA', 2, '15', 153, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1502', 'BARRANCA', 2, '15', 154, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1503', 'CAJATAMBO', 2, '15', 155, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1504', 'CANTA', 2, '15', 156, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1505', 'CAÑETE', 2, '15', 157, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1506', 'HUARAL', 2, '15', 158, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1507', 'HUAROCHIRI', 2, '15', 159, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1508', 'HUAURA', 2, '15', 160, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1509', 'OYON', 2, '15', 161, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1510', 'YAUYOS', 2, '15', 162, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1601', 'MAYNAS', 2, '16', 163, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1602', 'ALTO AMAZONAS', 2, '16', 164, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1603', 'LORETO', 2, '16', 165, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1604', 'MARISCAL RAMON CASTILLA', 2, '16', 166, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1605', 'REQUENA', 2, '16', 167, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1606', 'UCAYALI', 2, '16', 168, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1607', 'DATEM DEL MARAÑON', 2, '16', 169, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1608', 'PUTUMAYO', 2, '16', 170, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1701', 'TAMBOPATA', 2, '17', 171, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1702', 'MANU', 2, '17', 172, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1703', 'TAHUAMANU', 2, '17', 173, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1801', 'MARISCAL NIETO', 2, '18', 174, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1802', 'GENERAL SANCHEZ CERRO', 2, '18', 175, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1803', 'ILO', 2, '18', 176, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1901', 'PASCO', 2, '19', 177, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1902', 'DANIEL ALCIDES CARRION', 2, '19', 178, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('1903', 'OXAPAMPA', 2, '19', 179, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2001', 'PIURA', 2, '20', 180, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2002', 'AYABACA', 2, '20', 181, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2003', 'HUANCABAMBA', 2, '20', 182, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2004', 'MORROPON', 2, '20', 183, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2005', 'PAITA', 2, '20', 184, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2006', 'SULLANA', 2, '20', 185, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2007', 'TALARA', 2, '20', 186, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2008', 'SECHURA', 2, '20', 187, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2101', 'PUNO', 2, '21', 188, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2102', 'AZANGARO', 2, '21', 189, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2103', 'CARABAYA', 2, '21', 190, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2104', 'CHUCUITO', 2, '21', 191, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2105', 'EL COLLAO', 2, '21', 192, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2106', 'HUANCANE', 2, '21', 193, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2107', 'LAMPA', 2, '21', 194, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2108', 'MELGAR', 2, '21', 195, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2109', 'MOHO', 2, '21', 196, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2110', 'SAN ANTONIO DE PUTINA', 2, '21', 197, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2111', 'SAN ROMAN', 2, '21', 198, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2112', 'SANDIA', 2, '21', 199, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2113', 'YUNGUYO', 2, '21', 200, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2201', 'MOYOBAMBA', 2, '22', 201, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2202', 'BELLAVISTA', 2, '22', 202, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2203', 'EL DORADO', 2, '22', 203, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2204', 'HUALLAGA', 2, '22', 204, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2205', 'LAMAS', 2, '22', 205, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2206', 'MARISCAL CACERES', 2, '22', 206, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2207', 'PICOTA', 2, '22', 207, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2208', 'RIOJA', 2, '22', 208, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2209', 'SAN MARTIN', 2, '22', 209, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2210', 'TOCACHE', 2, '22', 210, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2301', 'TACNA', 2, '23', 211, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2302', 'CANDARAVE', 2, '23', 212, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2303', 'JORGE BASADRE', 2, '23', 213, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2304', 'TARATA', 2, '23', 214, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2401', 'TUMBES', 2, '24', 215, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2402', 'CONTRALMIRANTE VILLAR', 2, '24', 216, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2403', 'ZARUMILLA', 2, '24', 217, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2501', 'CORONEL PORTILLO', 2, '25', 218, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2502', 'ATALAYA', 2, '25', 219, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2503', 'PADRE ABAD', 2, '25', 220, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('2504', 'PURUS', 2, '25', 221, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010101', 'CHACHAPOYAS', 3, '0101', 222, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010102', 'ASUNCION', 3, '0101', 223, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010103', 'BALSAS', 3, '0101', 224, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010104', 'CHETO', 3, '0101', 225, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010105', 'CHILIQUIN', 3, '0101', 226, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010106', 'CHUQUIBAMBA', 3, '0101', 227, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010107', 'GRANADA', 3, '0101', 228, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010108', 'HUANCAS', 3, '0101', 229, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010109', 'LA JALCA', 3, '0101', 230, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010110', 'LEIMEBAMBA', 3, '0101', 231, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010111', 'LEVANTO', 3, '0101', 232, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010112', 'MAGDALENA', 3, '0101', 233, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010113', 'MARISCAL CASTILLA', 3, '0101', 234, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010114', 'MOLINOPAMPA', 3, '0101', 235, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010115', 'MONTEVIDEO', 3, '0101', 236, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010116', 'OLLEROS', 3, '0101', 237, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010117', 'QUINJALCA', 3, '0101', 238, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010118', 'SAN FRANCISCO DE DAGUAS', 3, '0101', 239, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010119', 'SAN ISIDRO DE MAINO', 3, '0101', 240, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010120', 'SOLOCO', 3, '0101', 241, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010121', 'SONCHE', 3, '0101', 242, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010201', 'BAGUA', 3, '0102', 243, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010202', 'ARAMANGO', 3, '0102', 244, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010203', 'COPALLIN', 3, '0102', 245, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010204', 'EL PARCO', 3, '0102', 246, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010205', 'IMAZA', 3, '0102', 247, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010206', 'LA PECA', 3, '0102', 248, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010301', 'JUMBILLA', 3, '0103', 249, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010302', 'CHISQUILLA', 3, '0103', 250, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010303', 'CHURUJA', 3, '0103', 251, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010304', 'COROSHA', 3, '0103', 252, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010305', 'CUISPES', 3, '0103', 253, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010306', 'FLORIDA', 3, '0103', 254, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010307', 'JAZAN', 3, '0103', 255, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010308', 'RECTA', 3, '0103', 256, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010309', 'SAN CARLOS', 3, '0103', 257, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010310', 'SHIPASBAMBA', 3, '0103', 258, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010311', 'VALERA', 3, '0103', 259, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010312', 'YAMBRASBAMBA', 3, '0103', 260, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010401', 'NIEVA', 3, '0104', 261, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010402', 'EL CENEPA', 3, '0104', 262, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010403', 'RIO SANTIAGO', 3, '0104', 263, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010501', 'LAMUD', 3, '0105', 264, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010502', 'CAMPORREDONDO', 3, '0105', 265, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010503', 'COCABAMBA', 3, '0105', 266, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010504', 'COLCAMAR', 3, '0105', 267, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010505', 'CONILA', 3, '0105', 268, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010506', 'INGUILPATA', 3, '0105', 269, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010507', 'LONGUITA', 3, '0105', 270, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010508', 'LONYA CHICO', 3, '0105', 271, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010509', 'LUYA', 3, '0105', 272, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010510', 'LUYA VIEJO', 3, '0105', 273, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010511', 'MARIA', 3, '0105', 274, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010512', 'OCALLI', 3, '0105', 275, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010513', 'OCUMAL', 3, '0105', 276, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010514', 'PISUQUIA', 3, '0105', 277, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010515', 'PROVIDENCIA', 3, '0105', 278, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010516', 'SAN CRISTOBAL', 3, '0105', 279, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010517', 'SAN FRANCISCO DEL YESO', 3, '0105', 280, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010518', 'SAN JERONIMO', 3, '0105', 281, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010519', 'SAN JUAN DE LOPECANCHA', 3, '0105', 282, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010520', 'SANTA CATALINA', 3, '0105', 283, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010521', 'SANTO TOMAS', 3, '0105', 284, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010522', 'TINGO', 3, '0105', 285, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010523', 'TRITA', 3, '0105', 286, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010601', 'SAN NICOLAS', 3, '0106', 287, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010602', 'CHIRIMOTO', 3, '0106', 288, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010603', 'COCHAMAL', 3, '0106', 289, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010604', 'HUAMBO', 3, '0106', 290, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010605', 'LIMABAMBA', 3, '0106', 291, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010606', 'LONGAR', 3, '0106', 292, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010607', 'MARISCAL BENAVIDES', 3, '0106', 293, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010608', 'MILPUC', 3, '0106', 294, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010609', 'OMIA', 3, '0106', 295, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010610', 'SANTA ROSA', 3, '0106', 296, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010611', 'TOTORA', 3, '0106', 297, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010612', 'VISTA ALEGRE', 3, '0106', 298, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010701', 'BAGUA GRANDE', 3, '0107', 299, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010702', 'CAJARURO', 3, '0107', 300, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010703', 'CUMBA', 3, '0107', 301, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010704', 'EL MILAGRO', 3, '0107', 302, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010705', 'JAMALCA', 3, '0107', 303, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010706', 'LONYA GRANDE', 3, '0107', 304, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('010707', 'YAMON', 3, '0107', 305, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020101', 'HUARAZ', 3, '0201', 306, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020102', 'COCHABAMBA', 3, '0201', 307, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020103', 'COLCABAMBA', 3, '0201', 308, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020104', 'HUANCHAY', 3, '0201', 309, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020105', 'INDEPENDENCIA', 3, '0201', 310, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020106', 'JANGAS', 3, '0201', 311, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020107', 'LA LIBERTAD', 3, '0201', 312, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020108', 'OLLEROS', 3, '0201', 313, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020109', 'PAMPAS', 3, '0201', 314, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020110', 'PARIACOTO', 3, '0201', 315, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020111', 'PIRA', 3, '0201', 316, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020112', 'TARICA', 3, '0201', 317, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020201', 'AIJA', 3, '0202', 318, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020202', 'CORIS', 3, '0202', 319, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020203', 'HUACLLAN', 3, '0202', 320, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020204', 'LA MERCED', 3, '0202', 321, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020205', 'SUCCHA', 3, '0202', 322, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020301', 'LLAMELLIN', 3, '0203', 323, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020302', 'ACZO', 3, '0203', 324, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020303', 'CHACCHO', 3, '0203', 325, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020304', 'CHINGAS', 3, '0203', 326, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020305', 'MIRGAS', 3, '0203', 327, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020306', 'SAN JUAN DE RONTOY', 3, '0203', 328, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020401', 'CHACAS', 3, '0204', 329, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020402', 'ACOCHACA', 3, '0204', 330, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020501', 'CHIQUIAN', 3, '0205', 331, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020502', 'ABELARDO PARDO LEZAMETA', 3, '0205', 332, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020503', 'ANTONIO RAYMONDI', 3, '0205', 333, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020504', 'AQUIA', 3, '0205', 334, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020505', 'CAJACAY', 3, '0205', 335, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020506', 'CANIS', 3, '0205', 336, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020507', 'COLQUIOC', 3, '0205', 337, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020508', 'HUALLANCA', 3, '0205', 338, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020509', 'HUASTA', 3, '0205', 339, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020510', 'HUAYLLACAYAN', 3, '0205', 340, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020511', 'LA PRIMAVERA', 3, '0205', 341, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020512', 'MANGAS', 3, '0205', 342, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020513', 'PACLLON', 3, '0205', 343, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020514', 'SAN MIGUEL DE CORPANQUI', 3, '0205', 344, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020515', 'TICLLOS', 3, '0205', 345, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020601', 'CARHUAZ', 3, '0206', 346, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020602', 'ACOPAMPA', 3, '0206', 347, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020603', 'AMASHCA', 3, '0206', 348, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020604', 'ANTA', 3, '0206', 349, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020605', 'ATAQUERO', 3, '0206', 350, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020606', 'MARCARA', 3, '0206', 351, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020607', 'PARIAHUANCA', 3, '0206', 352, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020608', 'SAN MIGUEL DE ACO', 3, '0206', 353, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020609', 'SHILLA', 3, '0206', 354, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020610', 'TINCO', 3, '0206', 355, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020611', 'YUNGAR', 3, '0206', 356, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020701', 'SAN LUIS', 3, '0207', 357, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020702', 'SAN NICOLAS', 3, '0207', 358, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020703', 'YAUYA', 3, '0207', 359, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020801', 'CASMA', 3, '0208', 360, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020802', 'BUENA VISTA ALTA', 3, '0208', 361, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020803', 'COMANDANTE NOEL', 3, '0208', 362, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020804', 'YAUTAN', 3, '0208', 363, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020901', 'CORONGO', 3, '0209', 364, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020902', 'ACO', 3, '0209', 365, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020903', 'BAMBAS', 3, '0209', 366, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020904', 'CUSCA', 3, '0209', 367, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020905', 'LA PAMPA', 3, '0209', 368, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020906', 'YANAC', 3, '0209', 369, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('020907', 'YUPAN', 3, '0209', 370, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021001', 'HUARI', 3, '0210', 371, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021002', 'ANRA', 3, '0210', 372, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021003', 'CAJAY', 3, '0210', 373, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021004', 'CHAVIN DE HUANTAR', 3, '0210', 374, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021005', 'HUACACHI', 3, '0210', 375, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021006', 'HUACCHIS', 3, '0210', 376, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021007', 'HUACHIS', 3, '0210', 377, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021008', 'HUANTAR', 3, '0210', 378, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021009', 'MASIN', 3, '0210', 379, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021010', 'PAUCAS', 3, '0210', 380, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021011', 'PONTO', 3, '0210', 381, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021012', 'RAHUAPAMPA', 3, '0210', 382, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021013', 'RAPAYAN', 3, '0210', 383, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021014', 'SAN MARCOS', 3, '0210', 384, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021015', 'SAN PEDRO DE CHANA', 3, '0210', 385, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021016', 'UCO', 3, '0210', 386, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021101', 'HUARMEY', 3, '0211', 387, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021102', 'COCHAPETI', 3, '0211', 388, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021103', 'CULEBRAS', 3, '0211', 389, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021104', 'HUAYAN', 3, '0211', 390, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021105', 'MALVAS', 3, '0211', 391, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021201', 'CARAZ', 3, '0212', 392, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021202', 'HUALLANCA', 3, '0212', 393, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021203', 'HUATA', 3, '0212', 394, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021204', 'HUAYLAS', 3, '0212', 395, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021205', 'MATO', 3, '0212', 396, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021206', 'PAMPAROMAS', 3, '0212', 397, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021207', 'PUEBLO LIBRE', 3, '0212', 398, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021208', 'SANTA CRUZ', 3, '0212', 399, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021209', 'SANTO TORIBIO', 3, '0212', 400, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021210', 'YURACMARCA', 3, '0212', 401, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021301', 'PISCOBAMBA', 3, '0213', 402, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021302', 'CASCA', 3, '0213', 403, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021303', 'ELEAZAR GUZMAN BARRON', 3, '0213', 404, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021304', 'FIDEL OLIVAS ESCUDERO', 3, '0213', 405, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021305', 'LLAMA', 3, '0213', 406, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021306', 'LLUMPA', 3, '0213', 407, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021307', 'LUCMA', 3, '0213', 408, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021308', 'MUSGA', 3, '0213', 409, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021401', 'OCROS', 3, '0214', 410, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021402', 'ACAS', 3, '0214', 411, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021403', 'CAJAMARQUILLA', 3, '0214', 412, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021404', 'CARHUAPAMPA', 3, '0214', 413, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021405', 'COCHAS', 3, '0214', 414, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021406', 'CONGAS', 3, '0214', 415, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021407', 'LLIPA', 3, '0214', 416, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021408', 'SAN CRISTOBAL DE RAJAN', 3, '0214', 417, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021409', 'SAN PEDRO', 3, '0214', 418, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021410', 'SANTIAGO DE CHILCAS', 3, '0214', 419, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021501', 'CABANA', 3, '0215', 420, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021502', 'BOLOGNESI', 3, '0215', 421, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021503', 'CONCHUCOS', 3, '0215', 422, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021504', 'HUACASCHUQUE', 3, '0215', 423, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021505', 'HUANDOVAL', 3, '0215', 424, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021506', 'LACABAMBA', 3, '0215', 425, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021507', 'LLAPO', 3, '0215', 426, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021508', 'PALLASCA', 3, '0215', 427, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021509', 'PAMPAS', 3, '0215', 428, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021510', 'SANTA ROSA', 3, '0215', 429, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021511', 'TAUCA', 3, '0215', 430, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021601', 'POMABAMBA', 3, '0216', 431, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021602', 'HUAYLLAN', 3, '0216', 432, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021603', 'PAROBAMBA', 3, '0216', 433, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021604', 'QUINUABAMBA', 3, '0216', 434, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021701', 'RECUAY', 3, '0217', 435, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021702', 'CATAC', 3, '0217', 436, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021703', 'COTAPARACO', 3, '0217', 437, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021704', 'HUAYLLAPAMPA', 3, '0217', 438, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021705', 'LLACLLIN', 3, '0217', 439, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021706', 'MARCA', 3, '0217', 440, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021707', 'PAMPAS CHICO', 3, '0217', 441, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021708', 'PARARIN', 3, '0217', 442, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021709', 'TAPACOCHA', 3, '0217', 443, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021710', 'TICAPAMPA', 3, '0217', 444, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021801', 'CHIMBOTE', 3, '0218', 445, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021802', 'CACERES DEL PERU', 3, '0218', 446, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021803', 'COISHCO', 3, '0218', 447, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021804', 'MACATE', 3, '0218', 448, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021805', 'MORO', 3, '0218', 449, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021806', 'NEPEÑA', 3, '0218', 450, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021807', 'SAMANCO', 3, '0218', 451, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021808', 'SANTA', 3, '0218', 452, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021809', 'NUEVO CHIMBOTE', 3, '0218', 453, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021901', 'SIHUAS', 3, '0219', 454, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021902', 'ACOBAMBA', 3, '0219', 455, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021903', 'ALFONSO UGARTE', 3, '0219', 456, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021904', 'CASHAPAMPA', 3, '0219', 457, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021905', 'CHINGALPO', 3, '0219', 458, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021906', 'HUAYLLABAMBA', 3, '0219', 459, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021907', 'QUICHES', 3, '0219', 460, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021908', 'RAGASH', 3, '0219', 461, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021909', 'SAN JUAN', 3, '0219', 462, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('021910', 'SICSIBAMBA', 3, '0219', 463, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('022001', 'YUNGAY', 3, '0220', 464, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('022002', 'CASCAPARA', 3, '0220', 465, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('022003', 'MANCOS', 3, '0220', 466, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('022004', 'MATACOTO', 3, '0220', 467, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('022005', 'QUILLO', 3, '0220', 468, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('022006', 'RANRAHIRCA', 3, '0220', 469, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('022007', 'SHUPLUY', 3, '0220', 470, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('022008', 'YANAMA', 3, '0220', 471, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030101', 'ABANCAY', 3, '0301', 472, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030102', 'CHACOCHE', 3, '0301', 473, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030103', 'CIRCA', 3, '0301', 474, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030104', 'CURAHUASI', 3, '0301', 475, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030105', 'HUANIPACA', 3, '0301', 476, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030106', 'LAMBRAMA', 3, '0301', 477, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030107', 'PICHIRHUA', 3, '0301', 478, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030108', 'SAN PEDRO DE CACHORA', 3, '0301', 479, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030109', 'TAMBURCO', 3, '0301', 480, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030201', 'ANDAHUAYLAS', 3, '0302', 481, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030202', 'ANDARAPA', 3, '0302', 482, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030203', 'CHIARA', 3, '0302', 483, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030204', 'HUANCARAMA', 3, '0302', 484, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030205', 'HUANCARAY', 3, '0302', 485, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030206', 'HUAYANA', 3, '0302', 486, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030207', 'KISHUARA', 3, '0302', 487, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030208', 'PACOBAMBA', 3, '0302', 488, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030209', 'PACUCHA', 3, '0302', 489, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030210', 'PAMPACHIRI', 3, '0302', 490, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030211', 'POMACOCHA', 3, '0302', 491, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030212', 'SAN ANTONIO DE CACHI', 3, '0302', 492, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030213', 'SAN JERONIMO', 3, '0302', 493, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030214', 'SAN MIGUEL DE CHACCRAMPA', 3, '0302', 494, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030215', 'SANTA MARIA DE CHICMO', 3, '0302', 495, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030216', 'TALAVERA', 3, '0302', 496, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030217', 'TUMAY HUARACA', 3, '0302', 497, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030218', 'TURPO', 3, '0302', 498, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030219', 'KAQUIABAMBA', 3, '0302', 499, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030220', 'JOSE MARIA ARGUEDAS', 3, '0302', 500, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030301', 'ANTABAMBA', 3, '0303', 501, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030302', 'EL ORO', 3, '0303', 502, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030303', 'HUAQUIRCA', 3, '0303', 503, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030304', 'JUAN ESPINOZA MEDRANO', 3, '0303', 504, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030305', 'OROPESA', 3, '0303', 505, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030306', 'PACHACONAS', 3, '0303', 506, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030307', 'SABAINO', 3, '0303', 507, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030401', 'CHALHUANCA', 3, '0304', 508, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030402', 'CAPAYA', 3, '0304', 509, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030403', 'CARAYBAMBA', 3, '0304', 510, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030404', 'CHAPIMARCA', 3, '0304', 511, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030405', 'COLCABAMBA', 3, '0304', 512, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030406', 'COTARUSE', 3, '0304', 513, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030407', 'HUAYLLO', 3, '0304', 514, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030408', 'JUSTO APU SAHUARAURA', 3, '0304', 515, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030409', 'LUCRE', 3, '0304', 516, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030410', 'POCOHUANCA', 3, '0304', 517, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030411', 'SAN JUAN DE CHACÑA', 3, '0304', 518, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030412', 'SAÑAYCA', 3, '0304', 519, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030413', 'SORAYA', 3, '0304', 520, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030414', 'TAPAIRIHUA', 3, '0304', 521, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030415', 'TINTAY', 3, '0304', 522, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030416', 'TORAYA', 3, '0304', 523, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030417', 'YANACA', 3, '0304', 524, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030501', 'TAMBOBAMBA', 3, '0305', 525, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030502', 'COTABAMBAS', 3, '0305', 526, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030503', 'COYLLURQUI', 3, '0305', 527, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030504', 'HAQUIRA', 3, '0305', 528, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030505', 'MARA', 3, '0305', 529, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030506', 'CHALLHUAHUACHO', 3, '0305', 530, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030601', 'CHINCHEROS', 3, '0306', 531, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030602', 'ANCO-HUALLO', 3, '0306', 532, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030603', 'COCHARCAS', 3, '0306', 533, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030604', 'HUACCANA', 3, '0306', 534, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030605', 'OCOBAMBA', 3, '0306', 535, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030606', 'ONGOY', 3, '0306', 536, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030607', 'URANMARCA', 3, '0306', 537, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030608', 'RANRACANCHA', 3, '0306', 538, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030609', 'ROCCHACC', 3, '0306', 539, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030610', 'EL PORVENIR', 3, '0306', 540, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030611', 'LOS CHANKAS', 3, '0306', 541, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030612', 'AHUAYRO', 3, '0306', 542, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030701', 'CHUQUIBAMBILLA', 3, '0307', 543, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030702', 'CURPAHUASI', 3, '0307', 544, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030703', 'GAMARRA', 3, '0307', 545, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030704', 'HUAYLLATI', 3, '0307', 546, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030705', 'MAMARA', 3, '0307', 547, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030706', 'MICAELA BASTIDAS', 3, '0307', 548, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030707', 'PATAYPAMPA', 3, '0307', 549, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030708', 'PROGRESO', 3, '0307', 550, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030709', 'SAN ANTONIO', 3, '0307', 551, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030710', 'SANTA ROSA', 3, '0307', 552, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030711', 'TURPAY', 3, '0307', 553, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030712', 'VILCABAMBA', 3, '0307', 554, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030713', 'VIRUNDO', 3, '0307', 555, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('030714', 'CURASCO', 3, '0307', 556, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040101', 'AREQUIPA', 3, '0401', 557, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040102', 'ALTO SELVA ALEGRE', 3, '0401', 558, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040103', 'CAYMA', 3, '0401', 559, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040104', 'CERRO COLORADO', 3, '0401', 560, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040105', 'CHARACATO', 3, '0401', 561, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040106', 'CHIGUATA', 3, '0401', 562, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040107', 'JACOBO HUNTER', 3, '0401', 563, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040108', 'LA JOYA', 3, '0401', 564, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040109', 'MARIANO MELGAR', 3, '0401', 565, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040110', 'MIRAFLORES', 3, '0401', 566, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040111', 'MOLLEBAYA', 3, '0401', 567, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040112', 'PAUCARPATA', 3, '0401', 568, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040113', 'POCSI', 3, '0401', 569, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040114', 'POLOBAYA', 3, '0401', 570, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040115', 'QUEQUEÑA', 3, '0401', 571, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040116', 'SABANDIA', 3, '0401', 572, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040117', 'SACHACA', 3, '0401', 573, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040118', 'SAN JUAN DE SIGUAS', 3, '0401', 574, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040119', 'SAN JUAN DE TARUCANI', 3, '0401', 575, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040120', 'SANTA ISABEL DE SIGUAS', 3, '0401', 576, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040121', 'SANTA RITA DE SIGUAS', 3, '0401', 577, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040122', 'SOCABAYA', 3, '0401', 578, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040123', 'TIABAYA', 3, '0401', 579, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040124', 'UCHUMAYO', 3, '0401', 580, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040125', 'VITOR', 3, '0401', 581, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040126', 'YANAHUARA', 3, '0401', 582, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040127', 'YARABAMBA', 3, '0401', 583, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040128', 'YURA', 3, '0401', 584, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040129', 'JOSE LUIS BUSTAMANTE Y RIVERO', 3, '0401', 585, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040201', 'CAMANA', 3, '0402', 586, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040202', 'JOSE MARIA QUIMPER', 3, '0402', 587, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040203', 'MARIANO NICOLAS VALCARCEL', 3, '0402', 588, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040204', 'MARISCAL CACERES', 3, '0402', 589, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040205', 'NICOLAS DE PIEROLA', 3, '0402', 590, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040206', 'OCOÑA', 3, '0402', 591, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040207', 'QUILCA', 3, '0402', 592, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040208', 'SAMUEL PASTOR', 3, '0402', 593, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040301', 'CARAVELI', 3, '0403', 594, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040302', 'ACARI', 3, '0403', 595, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040303', 'ATICO', 3, '0403', 596, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040304', 'ATIQUIPA', 3, '0403', 597, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040305', 'BELLA UNION', 3, '0403', 598, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040306', 'CAHUACHO', 3, '0403', 599, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040307', 'CHALA', 3, '0403', 600, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040308', 'CHAPARRA', 3, '0403', 601, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040309', 'HUANUHUANU', 3, '0403', 602, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040310', 'JAQUI', 3, '0403', 603, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040311', 'LOMAS', 3, '0403', 604, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040312', 'QUICACHA', 3, '0403', 605, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040313', 'YAUCA', 3, '0403', 606, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040401', 'APLAO', 3, '0404', 607, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040402', 'ANDAGUA', 3, '0404', 608, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040403', 'AYO', 3, '0404', 609, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040404', 'CHACHAS', 3, '0404', 610, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040405', 'CHILCAYMARCA', 3, '0404', 611, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040406', 'CHOCO', 3, '0404', 612, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040407', 'HUANCARQUI', 3, '0404', 613, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040408', 'MACHAGUAY', 3, '0404', 614, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040409', 'ORCOPAMPA', 3, '0404', 615, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040410', 'PAMPACOLCA', 3, '0404', 616, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040411', 'TIPAN', 3, '0404', 617, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040412', 'UÑON', 3, '0404', 618, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040413', 'URACA', 3, '0404', 619, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040414', 'VIRACO', 3, '0404', 620, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040501', 'CHIVAY', 3, '0405', 621, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040502', 'ACHOMA', 3, '0405', 622, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040503', 'CABANACONDE', 3, '0405', 623, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040504', 'CALLALLI', 3, '0405', 624, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040505', 'CAYLLOMA', 3, '0405', 625, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040506', 'COPORAQUE', 3, '0405', 626, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040507', 'HUAMBO', 3, '0405', 627, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040508', 'HUANCA', 3, '0405', 628, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040509', 'ICHUPAMPA', 3, '0405', 629, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040510', 'LARI', 3, '0405', 630, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040511', 'LLUTA', 3, '0405', 631, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040512', 'MACA', 3, '0405', 632, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040513', 'MADRIGAL', 3, '0405', 633, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040514', 'SAN ANTONIO DE CHUCA', 3, '0405', 634, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040515', 'SIBAYO', 3, '0405', 635, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040516', 'TAPAY', 3, '0405', 636, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040517', 'TISCO', 3, '0405', 637, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040518', 'TUTI', 3, '0405', 638, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040519', 'YANQUE', 3, '0405', 639, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040520', 'MAJES', 3, '0405', 640, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040601', 'CHUQUIBAMBA', 3, '0406', 641, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040602', 'ANDARAY', 3, '0406', 642, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040603', 'CAYARANI', 3, '0406', 643, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040604', 'CHICHAS', 3, '0406', 644, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040605', 'IRAY', 3, '0406', 645, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040606', 'RIO GRANDE', 3, '0406', 646, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040607', 'SALAMANCA', 3, '0406', 647, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040608', 'YANAQUIHUA', 3, '0406', 648, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040701', 'MOLLENDO', 3, '0407', 649, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040702', 'COCACHACRA', 3, '0407', 650, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040703', 'DEAN VALDIVIA', 3, '0407', 651, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040704', 'ISLAY', 3, '0407', 652, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040705', 'MEJIA', 3, '0407', 653, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040706', 'PUNTA DE BOMBON', 3, '0407', 654, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040801', 'COTAHUASI', 3, '0408', 655, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040802', 'ALCA', 3, '0408', 656, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040803', 'CHARCANA', 3, '0408', 657, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040804', 'HUAYNACOTAS', 3, '0408', 658, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040805', 'PAMPAMARCA', 3, '0408', 659, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040806', 'PUYCA', 3, '0408', 660, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040807', 'QUECHUALLA', 3, '0408', 661, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040808', 'SAYLA', 3, '0408', 662, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040809', 'TAURIA', 3, '0408', 663, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040810', 'TOMEPAMPA', 3, '0408', 664, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('040811', 'TORO', 3, '0408', 665, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050101', 'AYACUCHO', 3, '0501', 666, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050102', 'ACOCRO', 3, '0501', 667, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050103', 'ACOS VINCHOS', 3, '0501', 668, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050104', 'CARMEN ALTO', 3, '0501', 669, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050105', 'CHIARA', 3, '0501', 670, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050106', 'OCROS', 3, '0501', 671, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050107', 'PACAYCASA', 3, '0501', 672, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050108', 'QUINUA', 3, '0501', 673, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050109', 'SAN JOSE DE TICLLAS', 3, '0501', 674, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050110', 'SAN JUAN BAUTISTA', 3, '0501', 675, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050111', 'SANTIAGO DE PISCHA', 3, '0501', 676, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050112', 'SOCOS', 3, '0501', 677, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050113', 'TAMBILLO', 3, '0501', 678, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050114', 'VINCHOS', 3, '0501', 679, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050115', 'JESUS NAZARENO', 3, '0501', 680, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050116', 'ANDRES AVELINO CACERES DORREGARAY', 3, '0501', 681, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050201', 'CANGALLO', 3, '0502', 682, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050202', 'CHUSCHI', 3, '0502', 683, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050203', 'LOS MOROCHUCOS', 3, '0502', 684, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050204', 'MARIA PARADO DE BELLIDO', 3, '0502', 685, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050205', 'PARAS', 3, '0502', 686, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050206', 'TOTOS', 3, '0502', 687, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050301', 'SANCOS', 3, '0503', 688, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050302', 'CARAPO', 3, '0503', 689, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050303', 'SACSAMARCA', 3, '0503', 690, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050304', 'SANTIAGO DE LUCANAMARCA', 3, '0503', 691, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050401', 'HUANTA', 3, '0504', 692, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050402', 'AYAHUANCO', 3, '0504', 693, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050403', 'HUAMANGUILLA', 3, '0504', 694, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050404', 'IGUAIN', 3, '0504', 695, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050405', 'LURICOCHA', 3, '0504', 696, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050406', 'SANTILLANA', 3, '0504', 697, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050407', 'SIVIA', 3, '0504', 698, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050408', 'LLOCHEGUA', 3, '0504', 699, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050409', 'CANAYRE', 3, '0504', 700, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050410', 'UCHURACCAY', 3, '0504', 701, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050411', 'PUCACOLPA', 3, '0504', 702, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050412', 'CHACA', 3, '0504', 703, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050413', 'PUTIS', 3, '0504', 704, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050501', 'SAN MIGUEL', 3, '0505', 705, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050502', 'ANCO', 3, '0505', 706, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050503', 'AYNA', 3, '0505', 707, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050504', 'CHILCAS', 3, '0505', 708, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050505', 'CHUNGUI', 3, '0505', 709, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050506', 'LUIS CARRANZA', 3, '0505', 710, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050507', 'SANTA ROSA', 3, '0505', 711, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050508', 'TAMBO', 3, '0505', 712, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050509', 'SAMUGARI', 3, '0505', 713, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050510', 'ANCHIHUAY', 3, '0505', 714, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050511', 'ORONCCOY', 3, '0505', 715, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050512', 'UNION PROGRESO', 3, '0505', 716, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050513', 'RIO MAGDALENA', 3, '0505', 717, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050514', 'NINABAMBA', 3, '0505', 718, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050515', 'PATIBAMBA', 3, '0505', 719, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050601', 'PUQUIO', 3, '0506', 720, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050602', 'AUCARA', 3, '0506', 721, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050603', 'CABANA', 3, '0506', 722, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050604', 'CARMEN SALCEDO', 3, '0506', 723, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050605', 'CHAVIÑA', 3, '0506', 724, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050606', 'CHIPAO', 3, '0506', 725, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050607', 'HUAC-HUAS', 3, '0506', 726, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050608', 'LARAMATE', 3, '0506', 727, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050609', 'LEONCIO PRADO', 3, '0506', 728, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050610', 'LLAUTA', 3, '0506', 729, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050611', 'LUCANAS', 3, '0506', 730, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050612', 'OCAÑA', 3, '0506', 731, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050613', 'OTOCA', 3, '0506', 732, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050614', 'SAISA', 3, '0506', 733, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050615', 'SAN CRISTOBAL', 3, '0506', 734, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050616', 'SAN JUAN', 3, '0506', 735, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050617', 'SAN PEDRO', 3, '0506', 736, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050618', 'SAN PEDRO DE PALCO', 3, '0506', 737, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050619', 'SANCOS', 3, '0506', 738, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050620', 'SANTA ANA DE HUAYCAHUACHO', 3, '0506', 739, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050621', 'SANTA LUCIA', 3, '0506', 740, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050701', 'CORACORA', 3, '0507', 741, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050702', 'CHUMPI', 3, '0507', 742, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050703', 'CORONEL CASTAÑEDA', 3, '0507', 743, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050704', 'PACAPAUSA', 3, '0507', 744, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050705', 'PULLO', 3, '0507', 745, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050706', 'PUYUSCA', 3, '0507', 746, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050707', 'SAN FRANCISCO DE RAVACAYCO', 3, '0507', 747, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050708', 'UPAHUACHO', 3, '0507', 748, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050801', 'PAUSA', 3, '0508', 749, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050802', 'COLTA', 3, '0508', 750, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050803', 'CORCULLA', 3, '0508', 751, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050804', 'LAMPA', 3, '0508', 752, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050805', 'MARCABAMBA', 3, '0508', 753, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050806', 'OYOLO', 3, '0508', 754, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050807', 'PARARCA', 3, '0508', 755, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050808', 'SAN JAVIER DE ALPABAMBA', 3, '0508', 756, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050809', 'SAN JOSE DE USHUA', 3, '0508', 757, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050810', 'SARA SARA', 3, '0508', 758, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050901', 'QUEROBAMBA', 3, '0509', 759, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050902', 'BELEN', 3, '0509', 760, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050903', 'CHALCOS', 3, '0509', 761, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050904', 'CHILCAYOC', 3, '0509', 762, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050905', 'HUACAÑA', 3, '0509', 763, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050906', 'MORCOLLA', 3, '0509', 764, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050907', 'PAICO', 3, '0509', 765, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050908', 'SAN PEDRO DE LARCAY', 3, '0509', 766, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050909', 'SAN SALVADOR DE QUIJE', 3, '0509', 767, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050910', 'SANTIAGO DE PAUCARAY', 3, '0509', 768, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('050911', 'SORAS', 3, '0509', 769, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('051001', 'HUANCAPI', 3, '0510', 770, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('051002', 'ALCAMENCA', 3, '0510', 771, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('051003', 'APONGO', 3, '0510', 772, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('051004', 'ASQUIPATA', 3, '0510', 773, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('051005', 'CANARIA', 3, '0510', 774, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('051006', 'CAYARA', 3, '0510', 775, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('051007', 'COLCA', 3, '0510', 776, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('051008', 'HUAMANQUIQUIA', 3, '0510', 777, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('051009', 'HUANCARAYLLA', 3, '0510', 778, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('051010', 'HUAYA', 3, '0510', 779, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('051011', 'SARHUA', 3, '0510', 780, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('051012', 'VILCANCHOS', 3, '0510', 781, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('051101', 'VILCAS HUAMAN', 3, '0511', 782, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('051102', 'ACCOMARCA', 3, '0511', 783, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('051103', 'CARHUANCA', 3, '0511', 784, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('051104', 'CONCEPCION', 3, '0511', 785, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('051105', 'HUAMBALPA', 3, '0511', 786, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('051106', 'INDEPENDENCIA', 3, '0511', 787, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('051107', 'SAURAMA', 3, '0511', 788, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('051108', 'VISCHONGO', 3, '0511', 789, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060101', 'CAJAMARCA', 3, '0601', 790, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060102', 'ASUNCION', 3, '0601', 791, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060103', 'CHETILLA', 3, '0601', 792, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060104', 'COSPAN', 3, '0601', 793, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060105', 'ENCAÑADA', 3, '0601', 794, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060106', 'JESUS', 3, '0601', 795, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060107', 'LLACANORA', 3, '0601', 796, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060108', 'LOS BAÑOS DEL INCA', 3, '0601', 797, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060109', 'MAGDALENA', 3, '0601', 798, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060110', 'MATARA', 3, '0601', 799, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060111', 'NAMORA', 3, '0601', 800, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060112', 'SAN JUAN', 3, '0601', 801, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060201', 'CAJABAMBA', 3, '0602', 802, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060202', 'CACHACHI', 3, '0602', 803, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060203', 'CONDEBAMBA', 3, '0602', 804, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060204', 'SITACOCHA', 3, '0602', 805, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060301', 'CELENDIN', 3, '0603', 806, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060302', 'CHUMUCH', 3, '0603', 807, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060303', 'CORTEGANA', 3, '0603', 808, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060304', 'HUASMIN', 3, '0603', 809, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060305', 'JORGE CHAVEZ', 3, '0603', 810, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060306', 'JOSE GALVEZ', 3, '0603', 811, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060307', 'MIGUEL IGLESIAS', 3, '0603', 812, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060308', 'OXAMARCA', 3, '0603', 813, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060309', 'SOROCHUCO', 3, '0603', 814, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060310', 'SUCRE', 3, '0603', 815, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060311', 'UTCO', 3, '0603', 816, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060312', 'LA LIBERTAD DE PALLAN', 3, '0603', 817, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060401', 'CHOTA', 3, '0604', 818, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060402', 'ANGUIA', 3, '0604', 819, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060403', 'CHADIN', 3, '0604', 820, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060404', 'CHIGUIRIP', 3, '0604', 821, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060405', 'CHIMBAN', 3, '0604', 822, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060406', 'CHOROPAMPA', 3, '0604', 823, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060407', 'COCHABAMBA', 3, '0604', 824, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060408', 'CONCHAN', 3, '0604', 825, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060409', 'HUAMBOS', 3, '0604', 826, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060410', 'LAJAS', 3, '0604', 827, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060411', 'LLAMA', 3, '0604', 828, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060412', 'MIRACOSTA', 3, '0604', 829, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060413', 'PACCHA', 3, '0604', 830, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060414', 'PION', 3, '0604', 831, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060415', 'QUEROCOTO', 3, '0604', 832, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060416', 'SAN JUAN DE LICUPIS', 3, '0604', 833, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060417', 'TACABAMBA', 3, '0604', 834, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060418', 'TOCMOCHE', 3, '0604', 835, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060419', 'CHALAMARCA', 3, '0604', 836, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060501', 'CONTUMAZA', 3, '0605', 837, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060502', 'CHILETE', 3, '0605', 838, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060503', 'CUPISNIQUE', 3, '0605', 839, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060504', 'GUZMANGO', 3, '0605', 840, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060505', 'SAN BENITO', 3, '0605', 841, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060506', 'SANTA CRUZ DE TOLEDO', 3, '0605', 842, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060507', 'TANTARICA', 3, '0605', 843, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060508', 'YONAN', 3, '0605', 844, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060601', 'CUTERVO', 3, '0606', 845, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060602', 'CALLAYUC', 3, '0606', 846, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060603', 'CHOROS', 3, '0606', 847, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060604', 'CUJILLO', 3, '0606', 848, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060605', 'LA RAMADA', 3, '0606', 849, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060606', 'PIMPINGOS', 3, '0606', 850, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060607', 'QUEROCOTILLO', 3, '0606', 851, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060608', 'SAN ANDRES DE CUTERVO', 3, '0606', 852, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060609', 'SAN JUAN DE CUTERVO', 3, '0606', 853, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060610', 'SAN LUIS DE LUCMA', 3, '0606', 854, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060611', 'SANTA CRUZ', 3, '0606', 855, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060612', 'SANTO DOMINGO DE LA CAPILLA', 3, '0606', 856, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060613', 'SANTO TOMAS', 3, '0606', 857, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060614', 'SOCOTA', 3, '0606', 858, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060615', 'TORIBIO CASANOVA', 3, '0606', 859, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060701', 'BAMBAMARCA', 3, '0607', 860, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060702', 'CHUGUR', 3, '0607', 861, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060703', 'HUALGAYOC', 3, '0607', 862, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060801', 'JAEN', 3, '0608', 863, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060802', 'BELLAVISTA', 3, '0608', 864, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060803', 'CHONTALI', 3, '0608', 865, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060804', 'COLASAY', 3, '0608', 866, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060805', 'HUABAL', 3, '0608', 867, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060806', 'LAS PIRIAS', 3, '0608', 868, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060807', 'POMAHUACA', 3, '0608', 869, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060808', 'PUCARA', 3, '0608', 870, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060809', 'SALLIQUE', 3, '0608', 871, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060810', 'SAN FELIPE', 3, '0608', 872, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060811', 'SAN JOSE DEL ALTO', 3, '0608', 873, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060812', 'SANTA ROSA', 3, '0608', 874, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060901', 'SAN IGNACIO', 3, '0609', 875, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060902', 'CHIRINOS', 3, '0609', 876, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060903', 'HUARANGO', 3, '0609', 877, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060904', 'LA COIPA', 3, '0609', 878, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060905', 'NAMBALLE', 3, '0609', 879, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060906', 'SAN JOSE DE LOURDES', 3, '0609', 880, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('060907', 'TABACONAS', 3, '0609', 881, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('061001', 'PEDRO GALVEZ', 3, '0610', 882, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('061002', 'CHANCAY', 3, '0610', 883, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('061003', 'EDUARDO VILLANUEVA', 3, '0610', 884, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('061004', 'GREGORIO PITA', 3, '0610', 885, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('061005', 'ICHOCAN', 3, '0610', 886, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('061006', 'JOSE MANUEL QUIROZ', 3, '0610', 887, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('061007', 'JOSE SABOGAL', 3, '0610', 888, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('061101', 'SAN MIGUEL', 3, '0611', 889, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('061102', 'BOLIVAR', 3, '0611', 890, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('061103', 'CALQUIS', 3, '0611', 891, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('061104', 'CATILLUC', 3, '0611', 892, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('061105', 'EL PRADO', 3, '0611', 893, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('061106', 'LA FLORIDA', 3, '0611', 894, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('061107', 'LLAPA', 3, '0611', 895, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('061108', 'NANCHOC', 3, '0611', 896, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('061109', 'NIEPOS', 3, '0611', 897, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('061110', 'SAN GREGORIO', 3, '0611', 898, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('061111', 'SAN SILVESTRE DE COCHAN', 3, '0611', 899, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('061112', 'TONGOD', 3, '0611', 900, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('061113', 'UNION AGUA BLANCA', 3, '0611', 901, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('061201', 'SAN PABLO', 3, '0612', 902, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('061202', 'SAN BERNARDINO', 3, '0612', 903, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('061203', 'SAN LUIS', 3, '0612', 904, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('061204', 'TUMBADEN', 3, '0612', 905, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('061301', 'SANTA CRUZ', 3, '0613', 906, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('061302', 'ANDABAMBA', 3, '0613', 907, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('061303', 'CATACHE', 3, '0613', 908, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('061304', 'CHANCAYBAÑOS', 3, '0613', 909, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('061305', 'LA ESPERANZA', 3, '0613', 910, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('061306', 'NINABAMBA', 3, '0613', 911, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('061307', 'PULAN', 3, '0613', 912, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('061308', 'SAUCEPAMPA', 3, '0613', 913, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('061309', 'SEXI', 3, '0613', 914, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('061310', 'UTICYACU', 3, '0613', 915, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('061311', 'YAUYUCAN', 3, '0613', 916, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('070101', 'CALLAO', 3, '0701', 917, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('070102', 'BELLAVISTA', 3, '0701', 918, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('070103', 'CARMEN DE LA LEGUA REYNOSO', 3, '0701', 919, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('070104', 'LA PERLA', 3, '0701', 920, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('070105', 'LA PUNTA', 3, '0701', 921, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('070106', 'VENTANILLA', 3, '0701', 922, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('070107', 'MI PERU', 3, '0701', 923, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080101', 'CUSCO', 3, '0801', 924, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080102', 'CCORCA', 3, '0801', 925, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080103', 'POROY', 3, '0801', 926, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080104', 'SAN JERONIMO', 3, '0801', 927, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080105', 'SAN SEBASTIAN', 3, '0801', 928, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080106', 'SANTIAGO', 3, '0801', 929, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080107', 'SAYLLA', 3, '0801', 930, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080108', 'WANCHAQ', 3, '0801', 931, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080201', 'ACOMAYO', 3, '0802', 932, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080202', 'ACOPIA', 3, '0802', 933, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080203', 'ACOS', 3, '0802', 934, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080204', 'MOSOC LLACTA', 3, '0802', 935, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080205', 'POMACANCHI', 3, '0802', 936, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080206', 'RONDOCAN', 3, '0802', 937, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080207', 'SANGARARA', 3, '0802', 938, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080301', 'ANTA', 3, '0803', 939, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080302', 'ANCAHUASI', 3, '0803', 940, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080303', 'CACHIMAYO', 3, '0803', 941, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080304', 'CHINCHAYPUJIO', 3, '0803', 942, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080305', 'HUAROCONDO', 3, '0803', 943, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080306', 'LIMATAMBO', 3, '0803', 944, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080307', 'MOLLEPATA', 3, '0803', 945, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080308', 'PUCYURA', 3, '0803', 946, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080309', 'ZURITE', 3, '0803', 947, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080401', 'CALCA', 3, '0804', 948, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080402', 'COYA', 3, '0804', 949, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080403', 'LAMAY', 3, '0804', 950, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080404', 'LARES', 3, '0804', 951, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080405', 'PISAC', 3, '0804', 952, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080406', 'SAN SALVADOR', 3, '0804', 953, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080407', 'TARAY', 3, '0804', 954, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080408', 'YANATILE', 3, '0804', 955, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080501', 'YANAOCA', 3, '0805', 956, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080502', 'CHECCA', 3, '0805', 957, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080503', 'KUNTURKANKI', 3, '0805', 958, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080504', 'LANGUI', 3, '0805', 959, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080505', 'LAYO', 3, '0805', 960, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080506', 'PAMPAMARCA', 3, '0805', 961, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080507', 'QUEHUE', 3, '0805', 962, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080508', 'TUPAC AMARU', 3, '0805', 963, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080601', 'SICUANI', 3, '0806', 964, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080602', 'CHECACUPE', 3, '0806', 965, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080603', 'COMBAPATA', 3, '0806', 966, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080604', 'MARANGANI', 3, '0806', 967, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080605', 'PITUMARCA', 3, '0806', 968, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080606', 'SAN PABLO', 3, '0806', 969, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080607', 'SAN PEDRO', 3, '0806', 970, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080608', 'TINTA', 3, '0806', 971, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080701', 'SANTO TOMAS', 3, '0807', 972, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080702', 'CAPACMARCA', 3, '0807', 973, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080703', 'CHAMACA', 3, '0807', 974, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080704', 'COLQUEMARCA', 3, '0807', 975, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080705', 'LIVITACA', 3, '0807', 976, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080706', 'LLUSCO', 3, '0807', 977, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080707', 'QUIÑOTA', 3, '0807', 978, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080708', 'VELILLE', 3, '0807', 979, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080801', 'ESPINAR', 3, '0808', 980, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080802', 'CONDOROMA', 3, '0808', 981, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080803', 'COPORAQUE', 3, '0808', 982, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080804', 'OCORURO', 3, '0808', 983, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080805', 'PALLPATA', 3, '0808', 984, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080806', 'PICHIGUA', 3, '0808', 985, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080807', 'SUYCKUTAMBO', 3, '0808', 986, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080808', 'ALTO PICHIGUA', 3, '0808', 987, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080901', 'SANTA ANA', 3, '0809', 988, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080902', 'ECHARATE', 3, '0809', 989, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080903', 'HUAYOPATA', 3, '0809', 990, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080904', 'MARANURA', 3, '0809', 991, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080905', 'OCOBAMBA', 3, '0809', 992, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080906', 'QUELLOUNO', 3, '0809', 993, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080907', 'QUIMBIRI', 3, '0809', 994, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080908', 'SANTA TERESA', 3, '0809', 995, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080909', 'VILCABAMBA', 3, '0809', 996, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080910', 'PICHARI', 3, '0809', 997, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080911', 'INKAWASI', 3, '0809', 998, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080912', 'VILLA VIRGEN', 3, '0809', 999, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080913', 'VILLA KINTIARINA', 3, '0809', 1000, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080914', 'MEGANTONI', 3, '0809', 1001, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080915', 'KUMPIRUSHIATO', 3, '0809', 1002, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080916', 'CIELO PUNCO', 3, '0809', 1003, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080917', 'MANITEA', 3, '0809', 1004, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('080918', 'UNION ASHÁNINKA', 3, '0809', 1005, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('081001', 'PARURO', 3, '0810', 1006, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('081002', 'ACCHA', 3, '0810', 1007, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('081003', 'CCAPI', 3, '0810', 1008, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('081004', 'COLCHA', 3, '0810', 1009, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('081005', 'HUANOQUITE', 3, '0810', 1010, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('081006', 'OMACHA', 3, '0810', 1011, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('081007', 'PACCARITAMBO', 3, '0810', 1012, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('081008', 'PILLPINTO', 3, '0810', 1013, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('081009', 'YAURISQUE', 3, '0810', 1014, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('081101', 'PAUCARTAMBO', 3, '0811', 1015, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('081102', 'CAICAY', 3, '0811', 1016, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('081103', 'CHALLABAMBA', 3, '0811', 1017, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('081104', 'COLQUEPATA', 3, '0811', 1018, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('081105', 'HUANCARANI', 3, '0811', 1019, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('081106', 'KOSÑIPATA', 3, '0811', 1020, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('081201', 'URCOS', 3, '0812', 1021, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('081202', 'ANDAHUAYLILLAS', 3, '0812', 1022, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('081203', 'CAMANTI', 3, '0812', 1023, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('081204', 'CCARHUAYO', 3, '0812', 1024, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('081205', 'CCATCA', 3, '0812', 1025, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('081206', 'CUSIPATA', 3, '0812', 1026, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('081207', 'HUARO', 3, '0812', 1027, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('081208', 'LUCRE', 3, '0812', 1028, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('081209', 'MARCAPATA', 3, '0812', 1029, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('081210', 'OCONGATE', 3, '0812', 1030, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('081211', 'OROPESA', 3, '0812', 1031, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('081212', 'QUIQUIJANA', 3, '0812', 1032, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('081301', 'URUBAMBA', 3, '0813', 1033, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('081302', 'CHINCHERO', 3, '0813', 1034, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('081303', 'HUAYLLABAMBA', 3, '0813', 1035, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('081304', 'MACHUPICCHU', 3, '0813', 1036, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('081305', 'MARAS', 3, '0813', 1037, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('081306', 'OLLANTAYTAMBO', 3, '0813', 1038, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('081307', 'YUCAY', 3, '0813', 1039, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090101', 'HUANCAVELICA', 3, '0901', 1040, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090102', 'ACOBAMBILLA', 3, '0901', 1041, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090103', 'ACORIA', 3, '0901', 1042, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090104', 'CONAYCA', 3, '0901', 1043, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090105', 'CUENCA', 3, '0901', 1044, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090106', 'HUACHOCOLPA', 3, '0901', 1045, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090107', 'HUAYLLAHUARA', 3, '0901', 1046, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090108', 'IZCUCHACA', 3, '0901', 1047, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090109', 'LARIA', 3, '0901', 1048, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090110', 'MANTA', 3, '0901', 1049, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090111', 'MARISCAL CACERES', 3, '0901', 1050, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090112', 'MOYA', 3, '0901', 1051, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090113', 'NUEVO OCCORO', 3, '0901', 1052, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090114', 'PALCA', 3, '0901', 1053, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090115', 'PILCHACA', 3, '0901', 1054, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090116', 'VILCA', 3, '0901', 1055, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090117', 'YAULI', 3, '0901', 1056, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090118', 'ASCENSION', 3, '0901', 1057, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090119', 'HUANDO', 3, '0901', 1058, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090201', 'ACOBAMBA', 3, '0902', 1059, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090202', 'ANDABAMBA', 3, '0902', 1060, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090203', 'ANTA', 3, '0902', 1061, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090204', 'CAJA', 3, '0902', 1062, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090205', 'MARCAS', 3, '0902', 1063, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090206', 'PAUCARA', 3, '0902', 1064, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090207', 'POMACOCHA', 3, '0902', 1065, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090208', 'ROSARIO', 3, '0902', 1066, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090301', 'LIRCAY', 3, '0903', 1067, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090302', 'ANCHONGA', 3, '0903', 1068, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090303', 'CALLANMARCA', 3, '0903', 1069, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090304', 'CCOCHACCASA', 3, '0903', 1070, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090305', 'CHINCHO', 3, '0903', 1071, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090306', 'CONGALLA', 3, '0903', 1072, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090307', 'HUANCA-HUANCA', 3, '0903', 1073, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090308', 'HUAYLLAY GRANDE', 3, '0903', 1074, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090309', 'JULCAMARCA', 3, '0903', 1075, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090310', 'SAN ANTONIO DE ANTAPARCO', 3, '0903', 1076, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090311', 'SANTO TOMAS DE PATA', 3, '0903', 1077, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090312', 'SECCLLA', 3, '0903', 1078, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090401', 'CASTROVIRREYNA', 3, '0904', 1079, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090402', 'ARMA', 3, '0904', 1080, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090403', 'AURAHUA', 3, '0904', 1081, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090404', 'CAPILLAS', 3, '0904', 1082, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090405', 'CHUPAMARCA', 3, '0904', 1083, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090406', 'COCAS', 3, '0904', 1084, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090407', 'HUACHOS', 3, '0904', 1085, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090408', 'HUAMATAMBO', 3, '0904', 1086, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090409', 'MOLLEPAMPA', 3, '0904', 1087, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090410', 'SAN JUAN', 3, '0904', 1088, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090411', 'SANTA ANA', 3, '0904', 1089, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090412', 'TANTARA', 3, '0904', 1090, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090413', 'TICRAPO', 3, '0904', 1091, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090501', 'CHURCAMPA', 3, '0905', 1092, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090502', 'ANCO', 3, '0905', 1093, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090503', 'CHINCHIHUASI', 3, '0905', 1094, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090504', 'EL CARMEN', 3, '0905', 1095, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090505', 'LA MERCED', 3, '0905', 1096, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090506', 'LOCROJA', 3, '0905', 1097, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090507', 'PAUCARBAMBA', 3, '0905', 1098, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090508', 'SAN MIGUEL DE MAYOCC', 3, '0905', 1099, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090509', 'SAN PEDRO DE CORIS', 3, '0905', 1100, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090510', 'PACHAMARCA', 3, '0905', 1101, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090511', 'COSME', 3, '0905', 1102, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090601', 'HUAYTARA', 3, '0906', 1103, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090602', 'AYAVI', 3, '0906', 1104, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090603', 'CORDOVA', 3, '0906', 1105, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090604', 'HUAYACUNDO ARMA', 3, '0906', 1106, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090605', 'LARAMARCA', 3, '0906', 1107, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090606', 'OCOYO', 3, '0906', 1108, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090607', 'PILPICHACA', 3, '0906', 1109, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090608', 'QUERCO', 3, '0906', 1110, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090609', 'QUITO-ARMA', 3, '0906', 1111, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090610', 'SAN ANTONIO DE CUSICANCHA', 3, '0906', 1112, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090611', 'SAN FRANCISCO DE SANGAYAICO', 3, '0906', 1113, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090612', 'SAN ISIDRO', 3, '0906', 1114, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090613', 'SANTIAGO DE CHOCORVOS', 3, '0906', 1115, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090614', 'SANTIAGO DE QUIRAHUARA', 3, '0906', 1116, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090615', 'SANTO DOMINGO DE CAPILLAS', 3, '0906', 1117, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090616', 'TAMBO', 3, '0906', 1118, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090701', 'PAMPAS', 3, '0907', 1119, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090702', 'ACOSTAMBO', 3, '0907', 1120, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090703', 'ACRAQUIA', 3, '0907', 1121, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090704', 'AHUAYCHA', 3, '0907', 1122, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090705', 'COLCABAMBA', 3, '0907', 1123, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090706', 'DANIEL HERNANDEZ', 3, '0907', 1124, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090707', 'HUACHOCOLPA', 3, '0907', 1125, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090709', 'HUARIBAMBA', 3, '0907', 1126, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090710', 'ÑAHUIMPUQUIO', 3, '0907', 1127, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090711', 'PAZOS', 3, '0907', 1128, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090713', 'QUISHUAR', 3, '0907', 1129, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090714', 'SALCABAMBA', 3, '0907', 1130, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090715', 'SALCAHUASI', 3, '0907', 1131, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090716', 'SAN MARCOS DE ROCCHAC', 3, '0907', 1132, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090717', 'SURCUBAMBA', 3, '0907', 1133, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090718', 'TINTAY PUNCU', 3, '0907', 1134, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090719', 'QUICHUAS', 3, '0907', 1135, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090720', 'ANDAYMARCA', 3, '0907', 1136, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090721', 'ROBLE', 3, '0907', 1137, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090722', 'PICHOS', 3, '0907', 1138, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090723', 'SANTIAGO DE TUCUMA', 3, '0907', 1139, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090724', 'LAMBRAS', 3, '0907', 1140, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('090725', 'COCHABAMBA', 3, '0907', 1141, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100101', 'HUANUCO', 3, '1001', 1142, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100102', 'AMARILIS', 3, '1001', 1143, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100103', 'CHINCHAO', 3, '1001', 1144, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100104', 'CHURUBAMBA', 3, '1001', 1145, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100105', 'MARGOS', 3, '1001', 1146, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100106', 'QUISQUI', 3, '1001', 1147, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100107', 'SAN FRANCISCO DE CAYRAN', 3, '1001', 1148, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100108', 'SAN PEDRO DE CHAULAN', 3, '1001', 1149, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100109', 'SANTA MARIA DEL VALLE', 3, '1001', 1150, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100110', 'YARUMAYO', 3, '1001', 1151, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100111', 'PILLCO MARCA', 3, '1001', 1152, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100112', 'YACUS', 3, '1001', 1153, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100113', 'SAN PABLO DE PILLAO', 3, '1001', 1154, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100201', 'AMBO', 3, '1002', 1155, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100202', 'CAYNA', 3, '1002', 1156, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100203', 'COLPAS', 3, '1002', 1157, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100204', 'CONCHAMARCA', 3, '1002', 1158, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100205', 'HUACAR', 3, '1002', 1159, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100206', 'SAN FRANCISCO', 3, '1002', 1160, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100207', 'SAN RAFAEL', 3, '1002', 1161, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100208', 'TOMAY KICHWA', 3, '1002', 1162, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100301', 'LA UNION', 3, '1003', 1163, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100307', 'CHUQUIS', 3, '1003', 1164, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100311', 'MARIAS', 3, '1003', 1165, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100313', 'PACHAS', 3, '1003', 1166, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100316', 'QUIVILLA', 3, '1003', 1167, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100317', 'RIPAN', 3, '1003', 1168, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100321', 'SHUNQUI', 3, '1003', 1169, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100322', 'SILLAPATA', 3, '1003', 1170, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100323', 'YANAS', 3, '1003', 1171, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100401', 'HUACAYBAMBA', 3, '1004', 1172, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100402', 'CANCHABAMBA', 3, '1004', 1173, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100403', 'COCHABAMBA', 3, '1004', 1174, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100404', 'PINRA', 3, '1004', 1175, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100501', 'LLATA', 3, '1005', 1176, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100502', 'ARANCAY', 3, '1005', 1177, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100503', 'CHAVIN DE PARIARCA', 3, '1005', 1178, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100504', 'JACAS GRANDE', 3, '1005', 1179, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100505', 'JIRCAN', 3, '1005', 1180, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100506', 'MIRAFLORES', 3, '1005', 1181, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100507', 'MONZON', 3, '1005', 1182, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100508', 'PUNCHAO', 3, '1005', 1183, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100509', 'PUÑOS', 3, '1005', 1184, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100510', 'SINGA', 3, '1005', 1185, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100511', 'TANTAMAYO', 3, '1005', 1186, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100601', 'RUPA-RUPA', 3, '1006', 1187, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100602', 'DANIEL ALOMIAS ROBLES', 3, '1006', 1188, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100603', 'HERMILIO VALDIZAN', 3, '1006', 1189, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100604', 'JOSE CRESPO Y CASTILLO', 3, '1006', 1190, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100605', 'LUYANDO', 3, '1006', 1191, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100606', 'MARIANO DAMASO BERAUN', 3, '1006', 1192, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100607', 'PUCAYACU', 3, '1006', 1193, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100608', 'CASTILLO GRANDE', 3, '1006', 1194, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100609', 'PUEBLO NUEVO', 3, '1006', 1195, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100610', 'SANTO DOMINGO DE ANDA', 3, '1006', 1196, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100701', 'HUACRACHUCO', 3, '1007', 1197, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100702', 'CHOLON', 3, '1007', 1198, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100703', 'SAN BUENAVENTURA', 3, '1007', 1199, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100704', 'LA MORADA', 3, '1007', 1200, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100705', 'SANTA ROSA DE ALTO YANAJANCA', 3, '1007', 1201, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100801', 'PANAO', 3, '1008', 1202, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100802', 'CHAGLLA', 3, '1008', 1203, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100803', 'MOLINO', 3, '1008', 1204, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100804', 'UMARI', 3, '1008', 1205, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100901', 'PUERTO INCA', 3, '1009', 1206, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100902', 'CODO DEL POZUZO', 3, '1009', 1207, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100903', 'HONORIA', 3, '1009', 1208, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100904', 'TOURNAVISTA', 3, '1009', 1209, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('100905', 'YUYAPICHIS', 3, '1009', 1210, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('101001', 'JESUS', 3, '1010', 1211, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('101002', 'BAÑOS', 3, '1010', 1212, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('101003', 'JIVIA', 3, '1010', 1213, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('101004', 'QUEROPALCA', 3, '1010', 1214, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('101005', 'RONDOS', 3, '1010', 1215, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('101006', 'SAN FRANCISCO DE ASIS', 3, '1010', 1216, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('101007', 'SAN MIGUEL DE CAURI', 3, '1010', 1217, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('101101', 'CHAVINILLO', 3, '1011', 1218, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('101102', 'CAHUAC', 3, '1011', 1219, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('101103', 'CHACABAMBA', 3, '1011', 1220, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('101104', 'APARICIO POMARES', 3, '1011', 1221, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('101105', 'JACAS CHICO', 3, '1011', 1222, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('101106', 'OBAS', 3, '1011', 1223, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('101107', 'PAMPAMARCA', 3, '1011', 1224, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('101108', 'CHORAS', 3, '1011', 1225, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110101', 'ICA', 3, '1101', 1226, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110102', 'LA TINGUIÑA', 3, '1101', 1227, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110103', 'LOS AQUIJES', 3, '1101', 1228, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110104', 'OCUCAJE', 3, '1101', 1229, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110105', 'PACHACUTEC', 3, '1101', 1230, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110106', 'PARCONA', 3, '1101', 1231, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110107', 'PUEBLO NUEVO', 3, '1101', 1232, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110108', 'SALAS', 3, '1101', 1233, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110109', 'SAN JOSE DE LOS MOLINOS', 3, '1101', 1234, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110110', 'SAN JUAN BAUTISTA', 3, '1101', 1235, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110111', 'SANTIAGO', 3, '1101', 1236, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110112', 'SUBTANJALLA', 3, '1101', 1237, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110113', 'TATE', 3, '1101', 1238, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110114', 'YAUCA DEL ROSARIO', 3, '1101', 1239, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110201', 'CHINCHA ALTA', 3, '1102', 1240, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110202', 'ALTO LARAN', 3, '1102', 1241, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110203', 'CHAVIN', 3, '1102', 1242, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110204', 'CHINCHA BAJA', 3, '1102', 1243, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110205', 'EL CARMEN', 3, '1102', 1244, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110206', 'GROCIO PRADO', 3, '1102', 1245, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110207', 'PUEBLO NUEVO', 3, '1102', 1246, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110208', 'SAN JUAN DE YANAC', 3, '1102', 1247, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110209', 'SAN PEDRO DE HUACARPANA', 3, '1102', 1248, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110210', 'SUNAMPE', 3, '1102', 1249, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110211', 'TAMBO DE MORA', 3, '1102', 1250, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110301', 'NAZCA', 3, '1103', 1251, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110302', 'CHANGUILLO', 3, '1103', 1252, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110303', 'EL INGENIO', 3, '1103', 1253, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110304', 'MARCONA', 3, '1103', 1254, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110305', 'VISTA ALEGRE', 3, '1103', 1255, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110401', 'PALPA', 3, '1104', 1256, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110402', 'LLIPATA', 3, '1104', 1257, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110403', 'RIO GRANDE', 3, '1104', 1258, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110404', 'SANTA CRUZ', 3, '1104', 1259, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110405', 'TIBILLO', 3, '1104', 1260, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110501', 'PISCO', 3, '1105', 1261, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110502', 'HUANCANO', 3, '1105', 1262, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110503', 'HUMAY', 3, '1105', 1263, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110504', 'INDEPENDENCIA', 3, '1105', 1264, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110505', 'PARACAS', 3, '1105', 1265, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110506', 'SAN ANDRES', 3, '1105', 1266, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110507', 'SAN CLEMENTE', 3, '1105', 1267, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('110508', 'TUPAC AMARU INCA', 3, '1105', 1268, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120101', 'HUANCAYO', 3, '1201', 1269, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120104', 'CARHUACALLANGA', 3, '1201', 1270, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120105', 'CHACAPAMPA', 3, '1201', 1271, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120106', 'CHICCHE', 3, '1201', 1272, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120107', 'CHILCA', 3, '1201', 1273, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120108', 'CHONGOS ALTO', 3, '1201', 1274, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120111', 'CHUPURO', 3, '1201', 1275, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120112', 'COLCA', 3, '1201', 1276, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120113', 'CULLHUAS', 3, '1201', 1277, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120114', 'EL TAMBO', 3, '1201', 1278, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120116', 'HUACRAPUQUIO', 3, '1201', 1279, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120117', 'HUALHUAS', 3, '1201', 1280, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120119', 'HUANCAN', 3, '1201', 1281, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120120', 'HUASICANCHA', 3, '1201', 1282, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120121', 'HUAYUCACHI', 3, '1201', 1283, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120122', 'INGENIO', 3, '1201', 1284, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120124', 'PARIAHUANCA', 3, '1201', 1285, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120125', 'PILCOMAYO', 3, '1201', 1286, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120126', 'PUCARA', 3, '1201', 1287, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120127', 'QUICHUAY', 3, '1201', 1288, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120128', 'QUILCAS', 3, '1201', 1289, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120129', 'SAN AGUSTIN', 3, '1201', 1290, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120130', 'SAN JERONIMO DE TUNAN', 3, '1201', 1291, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120132', 'SAÑO', 3, '1201', 1292, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120133', 'SAPALLANGA', 3, '1201', 1293, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120134', 'SICAYA', 3, '1201', 1294, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120135', 'SANTO DOMINGO DE ACOBAMBA', 3, '1201', 1295, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120136', 'VIQUES', 3, '1201', 1296, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120201', 'CONCEPCION', 3, '1202', 1297, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120202', 'ACO', 3, '1202', 1298, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120203', 'ANDAMARCA', 3, '1202', 1299, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120204', 'CHAMBARA', 3, '1202', 1300, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120205', 'COCHAS', 3, '1202', 1301, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120206', 'COMAS', 3, '1202', 1302, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120207', 'HEROINAS TOLEDO', 3, '1202', 1303, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120208', 'MANZANARES', 3, '1202', 1304, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120209', 'MARISCAL CASTILLA', 3, '1202', 1305, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120210', 'MATAHUASI', 3, '1202', 1306, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120211', 'MITO', 3, '1202', 1307, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120212', 'NUEVE DE JULIO', 3, '1202', 1308, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120213', 'ORCOTUNA', 3, '1202', 1309, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120214', 'SAN JOSE DE QUERO', 3, '1202', 1310, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120215', 'SANTA ROSA DE OCOPA', 3, '1202', 1311, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120301', 'CHANCHAMAYO', 3, '1203', 1312, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120302', 'PERENE', 3, '1203', 1313, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120303', 'PICHANAQUI', 3, '1203', 1314, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120304', 'SAN LUIS DE SHUARO', 3, '1203', 1315, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120305', 'SAN RAMON', 3, '1203', 1316, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120306', 'VITOC', 3, '1203', 1317, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120401', 'JAUJA', 3, '1204', 1318, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120402', 'ACOLLA', 3, '1204', 1319, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120403', 'APATA', 3, '1204', 1320, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120404', 'ATAURA', 3, '1204', 1321, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120405', 'CANCHAYLLO', 3, '1204', 1322, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120406', 'CURICACA', 3, '1204', 1323, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120407', 'EL MANTARO', 3, '1204', 1324, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120408', 'HUAMALI', 3, '1204', 1325, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120409', 'HUARIPAMPA', 3, '1204', 1326, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120410', 'HUERTAS', 3, '1204', 1327, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120411', 'JANJAILLO', 3, '1204', 1328, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120412', 'JULCAN', 3, '1204', 1329, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120413', 'LEONOR ORDOÑEZ', 3, '1204', 1330, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120414', 'LLOCLLAPAMPA', 3, '1204', 1331, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120415', 'MARCO', 3, '1204', 1332, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120416', 'MASMA', 3, '1204', 1333, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120417', 'MASMA CHICCHE', 3, '1204', 1334, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120418', 'MOLINOS', 3, '1204', 1335, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120419', 'MONOBAMBA', 3, '1204', 1336, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120420', 'MUQUI', 3, '1204', 1337, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120421', 'MUQUIYAUYO', 3, '1204', 1338, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120422', 'PACA', 3, '1204', 1339, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120423', 'PACCHA', 3, '1204', 1340, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120424', 'PANCAN', 3, '1204', 1341, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120425', 'PARCO', 3, '1204', 1342, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120426', 'POMACANCHA', 3, '1204', 1343, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120427', 'RICRAN', 3, '1204', 1344, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120428', 'SAN LORENZO', 3, '1204', 1345, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120429', 'SAN PEDRO DE CHUNAN', 3, '1204', 1346, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120430', 'SAUSA', 3, '1204', 1347, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120431', 'SINCOS', 3, '1204', 1348, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120432', 'TUNAN MARCA', 3, '1204', 1349, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120433', 'YAULI', 3, '1204', 1350, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120434', 'YAUYOS', 3, '1204', 1351, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120501', 'JUNIN', 3, '1205', 1352, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120502', 'CARHUAMAYO', 3, '1205', 1353, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120503', 'ONDORES', 3, '1205', 1354, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120504', 'ULCUMAYO', 3, '1205', 1355, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120601', 'SATIPO', 3, '1206', 1356, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120602', 'COVIRIALI', 3, '1206', 1357, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120603', 'LLAYLLA', 3, '1206', 1358, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120604', 'MAZAMARI', 3, '1206', 1359, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120605', 'PAMPA HERMOSA', 3, '1206', 1360, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120606', 'PANGOA', 3, '1206', 1361, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120607', 'RIO NEGRO', 3, '1206', 1362, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120608', 'RIO TAMBO', 3, '1206', 1363, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120609', 'VIZCATAN DEL ENE', 3, '1206', 1364, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120701', 'TARMA', 3, '1207', 1365, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120702', 'ACOBAMBA', 3, '1207', 1366, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120703', 'HUARICOLCA', 3, '1207', 1367, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120704', 'HUASAHUASI', 3, '1207', 1368, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120705', 'LA UNION', 3, '1207', 1369, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120706', 'PALCA', 3, '1207', 1370, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120707', 'PALCAMAYO', 3, '1207', 1371, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120708', 'SAN PEDRO DE CAJAS', 3, '1207', 1372, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120709', 'TAPO', 3, '1207', 1373, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120801', 'LA OROYA', 3, '1208', 1374, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120802', 'CHACAPALPA', 3, '1208', 1375, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120803', 'HUAY-HUAY', 3, '1208', 1376, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120804', 'MARCAPOMACOCHA', 3, '1208', 1377, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120805', 'MOROCOCHA', 3, '1208', 1378, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120806', 'PACCHA', 3, '1208', 1379, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120807', 'SANTA BARBARA DE CARHUACAYAN', 3, '1208', 1380, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120808', 'SANTA ROSA DE SACCO', 3, '1208', 1381, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120809', 'SUITUCANCHA', 3, '1208', 1382, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120810', 'YAULI', 3, '1208', 1383, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120901', 'CHUPACA', 3, '1209', 1384, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120902', 'AHUAC', 3, '1209', 1385, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120903', 'CHONGOS BAJO', 3, '1209', 1386, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120904', 'HUACHAC', 3, '1209', 1387, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120905', 'HUAMANCACA CHICO', 3, '1209', 1388, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120906', 'SAN JUAN DE YSCOS', 3, '1209', 1389, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120907', 'SAN JUAN DE JARPA', 3, '1209', 1390, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120908', 'TRES DE DICIEMBRE', 3, '1209', 1391, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('120909', 'YANACANCHA', 3, '1209', 1392, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130101', 'TRUJILLO', 3, '1301', 1393, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130102', 'EL PORVENIR', 3, '1301', 1394, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130103', 'FLORENCIA DE MORA', 3, '1301', 1395, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130104', 'HUANCHACO', 3, '1301', 1396, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130105', 'LA ESPERANZA', 3, '1301', 1397, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130106', 'LAREDO', 3, '1301', 1398, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130107', 'MOCHE', 3, '1301', 1399, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130108', 'POROTO', 3, '1301', 1400, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130109', 'SALAVERRY', 3, '1301', 1401, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130110', 'SIMBAL', 3, '1301', 1402, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130111', 'VICTOR LARCO HERRERA', 3, '1301', 1403, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130201', 'ASCOPE', 3, '1302', 1404, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130202', 'CHICAMA', 3, '1302', 1405, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130203', 'CHOCOPE', 3, '1302', 1406, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130204', 'MAGDALENA DE CAO', 3, '1302', 1407, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130205', 'PAIJAN', 3, '1302', 1408, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130206', 'RAZURI', 3, '1302', 1409, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130207', 'SANTIAGO DE CAO', 3, '1302', 1410, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130208', 'CASA GRANDE', 3, '1302', 1411, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130301', 'BOLIVAR', 3, '1303', 1412, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130302', 'BAMBAMARCA', 3, '1303', 1413, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130303', 'CONDORMARCA', 3, '1303', 1414, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130304', 'LONGOTEA', 3, '1303', 1415, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130305', 'UCHUMARCA', 3, '1303', 1416, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130306', 'UCUNCHA', 3, '1303', 1417, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130401', 'CHEPEN', 3, '1304', 1418, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130402', 'PACANGA', 3, '1304', 1419, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130403', 'PUEBLO NUEVO', 3, '1304', 1420, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130501', 'JULCAN', 3, '1305', 1421, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130502', 'CALAMARCA', 3, '1305', 1422, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130503', 'CARABAMBA', 3, '1305', 1423, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130504', 'HUASO', 3, '1305', 1424, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130601', 'OTUZCO', 3, '1306', 1425, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130602', 'AGALLPAMPA', 3, '1306', 1426, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130604', 'CHARAT', 3, '1306', 1427, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130605', 'HUARANCHAL', 3, '1306', 1428, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130606', 'LA CUESTA', 3, '1306', 1429, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130608', 'MACHE', 3, '1306', 1430, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130610', 'PARANDAY', 3, '1306', 1431, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130611', 'SALPO', 3, '1306', 1432, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130613', 'SINSICAP', 3, '1306', 1433, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130614', 'USQUIL', 3, '1306', 1434, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130701', 'SAN PEDRO DE LLOC', 3, '1307', 1435, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130702', 'GUADALUPE', 3, '1307', 1436, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130703', 'JEQUETEPEQUE', 3, '1307', 1437, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130704', 'PACASMAYO', 3, '1307', 1438, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130705', 'SAN JOSE', 3, '1307', 1439, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130801', 'TAYABAMBA', 3, '1308', 1440, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130802', 'BULDIBUYO', 3, '1308', 1441, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130803', 'CHILLIA', 3, '1308', 1442, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130804', 'HUANCASPATA', 3, '1308', 1443, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130805', 'HUAYLILLAS', 3, '1308', 1444, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130806', 'HUAYO', 3, '1308', 1445, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130807', 'ONGON', 3, '1308', 1446, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130808', 'PARCOY', 3, '1308', 1447, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130809', 'PATAZ', 3, '1308', 1448, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130810', 'PIAS', 3, '1308', 1449, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130811', 'SANTIAGO DE CHALLAS', 3, '1308', 1450, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130812', 'TAURIJA', 3, '1308', 1451, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130813', 'URPAY', 3, '1308', 1452, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130901', 'HUAMACHUCO', 3, '1309', 1453, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130902', 'CHUGAY', 3, '1309', 1454, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130903', 'COCHORCO', 3, '1309', 1455, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130904', 'CURGOS', 3, '1309', 1456, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130905', 'MARCABAL', 3, '1309', 1457, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130906', 'SANAGORAN', 3, '1309', 1458, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130907', 'SARIN', 3, '1309', 1459, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('130908', 'SARTIMBAMBA', 3, '1309', 1460, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('131001', 'SANTIAGO DE CHUCO', 3, '1310', 1461, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('131002', 'ANGASMARCA', 3, '1310', 1462, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('131003', 'CACHICADAN', 3, '1310', 1463, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('131004', 'MOLLEBAMBA', 3, '1310', 1464, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('131005', 'MOLLEPATA', 3, '1310', 1465, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('131006', 'QUIRUVILCA', 3, '1310', 1466, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('131007', 'SANTA CRUZ DE CHUCA', 3, '1310', 1467, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('131008', 'SITABAMBA', 3, '1310', 1468, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('131101', 'CASCAS', 3, '1311', 1469, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('131102', 'LUCMA', 3, '1311', 1470, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('131103', 'MARMOT', 3, '1311', 1471, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('131104', 'SAYAPULLO', 3, '1311', 1472, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('131201', 'VIRU', 3, '1312', 1473, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('131202', 'CHAO', 3, '1312', 1474, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('131203', 'GUADALUPITO', 3, '1312', 1475, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('140101', 'CHICLAYO', 3, '1401', 1476, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('140102', 'CHONGOYAPE', 3, '1401', 1477, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('140103', 'ETEN', 3, '1401', 1478, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('140104', 'ETEN PUERTO', 3, '1401', 1479, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('140105', 'JOSE LEONARDO ORTIZ', 3, '1401', 1480, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('140106', 'LA VICTORIA', 3, '1401', 1481, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('140107', 'LAGUNAS', 3, '1401', 1482, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('140108', 'MONSEFU', 3, '1401', 1483, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('140109', 'NUEVA ARICA', 3, '1401', 1484, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('140110', 'OYOTUN', 3, '1401', 1485, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('140111', 'PICSI', 3, '1401', 1486, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('140112', 'PIMENTEL', 3, '1401', 1487, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('140113', 'REQUE', 3, '1401', 1488, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('140114', 'SANTA ROSA', 3, '1401', 1489, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('140115', 'SAÑA', 3, '1401', 1490, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('140116', 'CAYALTI', 3, '1401', 1491, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('140117', 'PATAPO', 3, '1401', 1492, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('140118', 'POMALCA', 3, '1401', 1493, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('140119', 'PUCALA', 3, '1401', 1494, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('140120', 'TUMAN', 3, '1401', 1495, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('140201', 'FERREÑAFE', 3, '1402', 1496, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('140202', 'CAÑARIS', 3, '1402', 1497, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('140203', 'INCAHUASI', 3, '1402', 1498, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('140204', 'MANUEL ANTONIO MESONES MURO', 3, '1402', 1499, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('140205', 'PITIPO', 3, '1402', 1500, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('140206', 'PUEBLO NUEVO', 3, '1402', 1501, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('140301', 'LAMBAYEQUE', 3, '1403', 1502, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('140302', 'CHOCHOPE', 3, '1403', 1503, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('140303', 'ILLIMO', 3, '1403', 1504, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('140304', 'JAYANCA', 3, '1403', 1505, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('140305', 'MOCHUMI', 3, '1403', 1506, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('140306', 'MORROPE', 3, '1403', 1507, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('140307', 'MOTUPE', 3, '1403', 1508, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('140308', 'OLMOS', 3, '1403', 1509, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('140309', 'PACORA', 3, '1403', 1510, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('140310', 'SALAS', 3, '1403', 1511, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('140311', 'SAN JOSE', 3, '1403', 1512, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('140312', 'TUCUME', 3, '1403', 1513, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150101', 'LIMA', 3, '1501', 1514, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150102', 'ANCON', 3, '1501', 1515, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150103', 'ATE', 3, '1501', 1516, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150104', 'BARRANCO', 3, '1501', 1517, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150105', 'BREÑA', 3, '1501', 1518, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150106', 'CARABAYLLO', 3, '1501', 1519, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150107', 'CHACLACAYO', 3, '1501', 1520, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150108', 'CHORRILLOS', 3, '1501', 1521, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150109', 'CIENEGUILLA', 3, '1501', 1522, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150110', 'COMAS', 3, '1501', 1523, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150111', 'EL AGUSTINO', 3, '1501', 1524, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150112', 'INDEPENDENCIA', 3, '1501', 1525, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150113', 'JESUS MARIA', 3, '1501', 1526, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150114', 'LA MOLINA', 3, '1501', 1527, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150115', 'LA VICTORIA', 3, '1501', 1528, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150116', 'LINCE', 3, '1501', 1529, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150117', 'LOS OLIVOS', 3, '1501', 1530, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150118', 'LURIGANCHO', 3, '1501', 1531, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150119', 'LURIN', 3, '1501', 1532, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150120', 'MAGDALENA DEL MAR', 3, '1501', 1533, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150121', 'PUEBLO LIBRE', 3, '1501', 1534, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150122', 'MIRAFLORES', 3, '1501', 1535, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150123', 'PACHACAMAC', 3, '1501', 1536, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150124', 'PUCUSANA', 3, '1501', 1537, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150125', 'PUENTE PIEDRA', 3, '1501', 1538, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150126', 'PUNTA HERMOSA', 3, '1501', 1539, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150127', 'PUNTA NEGRA', 3, '1501', 1540, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150128', 'RIMAC', 3, '1501', 1541, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150129', 'SAN BARTOLO', 3, '1501', 1542, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150130', 'SAN BORJA', 3, '1501', 1543, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150131', 'SAN ISIDRO', 3, '1501', 1544, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150132', 'SAN JUAN DE LURIGANCHO', 3, '1501', 1545, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150133', 'SAN JUAN DE MIRAFLORES', 3, '1501', 1546, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150134', 'SAN LUIS', 3, '1501', 1547, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150135', 'SAN MARTIN DE PORRES', 3, '1501', 1548, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150136', 'SAN MIGUEL', 3, '1501', 1549, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150137', 'SANTA ANITA', 3, '1501', 1550, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150138', 'SANTA MARIA DEL MAR', 3, '1501', 1551, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150139', 'SANTA ROSA', 3, '1501', 1552, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150140', 'SANTIAGO DE SURCO', 3, '1501', 1553, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150141', 'SURQUILLO', 3, '1501', 1554, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150142', 'VILLA EL SALVADOR', 3, '1501', 1555, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150143', 'VILLA MARIA DEL TRIUNFO', 3, '1501', 1556, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150144', 'SANTA MARIA DE HUACHIPA', 3, '1501', 1557, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150201', 'BARRANCA', 3, '1502', 1558, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150202', 'PARAMONGA', 3, '1502', 1559, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150203', 'PATIVILCA', 3, '1502', 1560, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150204', 'SUPE', 3, '1502', 1561, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150205', 'SUPE PUERTO', 3, '1502', 1562, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150301', 'CAJATAMBO', 3, '1503', 1563, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150302', 'COPA', 3, '1503', 1564, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150303', 'GORGOR', 3, '1503', 1565, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150304', 'HUANCAPON', 3, '1503', 1566, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150305', 'MANAS', 3, '1503', 1567, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150401', 'CANTA', 3, '1504', 1568, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150402', 'ARAHUAY', 3, '1504', 1569, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150403', 'HUAMANTANGA', 3, '1504', 1570, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150404', 'HUAROS', 3, '1504', 1571, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150405', 'LACHAQUI', 3, '1504', 1572, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150406', 'SAN BUENAVENTURA', 3, '1504', 1573, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150407', 'SANTA ROSA DE QUIVES', 3, '1504', 1574, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150501', 'SAN VICENTE DE CAÑETE', 3, '1505', 1575, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150502', 'ASIA', 3, '1505', 1576, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150503', 'CALANGO', 3, '1505', 1577, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150504', 'CERRO AZUL', 3, '1505', 1578, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150505', 'CHILCA', 3, '1505', 1579, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150506', 'COAYLLO', 3, '1505', 1580, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150507', 'IMPERIAL', 3, '1505', 1581, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150508', 'LUNAHUANA', 3, '1505', 1582, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150509', 'MALA', 3, '1505', 1583, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150510', 'NUEVO IMPERIAL', 3, '1505', 1584, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150511', 'PACARAN', 3, '1505', 1585, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150512', 'QUILMANA', 3, '1505', 1586, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150513', 'SAN ANTONIO', 3, '1505', 1587, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150514', 'SAN LUIS', 3, '1505', 1588, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150515', 'SANTA CRUZ DE FLORES', 3, '1505', 1589, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150516', 'ZUÑIGA', 3, '1505', 1590, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150601', 'HUARAL', 3, '1506', 1591, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150602', 'ATAVILLOS ALTO', 3, '1506', 1592, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150603', 'ATAVILLOS BAJO', 3, '1506', 1593, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150604', 'AUCALLAMA', 3, '1506', 1594, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150605', 'CHANCAY', 3, '1506', 1595, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150606', 'IHUARI', 3, '1506', 1596, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150607', 'LAMPIAN', 3, '1506', 1597, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150608', 'PACARAOS', 3, '1506', 1598, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150609', 'SAN MIGUEL DE ACOS', 3, '1506', 1599, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150610', 'SANTA CRUZ DE ANDAMARCA', 3, '1506', 1600, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150611', 'SUMBILCA', 3, '1506', 1601, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150612', 'VEINTISIETE DE NOVIEMBRE', 3, '1506', 1602, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150701', 'MATUCANA', 3, '1507', 1603, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150702', 'ANTIOQUIA', 3, '1507', 1604, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150703', 'CALLAHUANCA', 3, '1507', 1605, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150704', 'CARAMPOMA', 3, '1507', 1606, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150705', 'CHICLA', 3, '1507', 1607, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150706', 'CUENCA', 3, '1507', 1608, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150707', 'HUACHUPAMPA', 3, '1507', 1609, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150708', 'HUANZA', 3, '1507', 1610, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150709', 'HUAROCHIRI', 3, '1507', 1611, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150710', 'LAHUAYTAMBO', 3, '1507', 1612, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150711', 'LANGA', 3, '1507', 1613, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150712', 'LARAOS', 3, '1507', 1614, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150713', 'MARIATANA', 3, '1507', 1615, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150714', 'RICARDO PALMA', 3, '1507', 1616, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150715', 'SAN ANDRES DE TUPICOCHA', 3, '1507', 1617, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150716', 'SAN ANTONIO', 3, '1507', 1618, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150717', 'SAN BARTOLOME', 3, '1507', 1619, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150718', 'SAN DAMIAN', 3, '1507', 1620, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150719', 'SAN JUAN DE IRIS', 3, '1507', 1621, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150720', 'SAN JUAN DE TANTARANCHE', 3, '1507', 1622, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150721', 'SAN LORENZO DE QUINTI', 3, '1507', 1623, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150722', 'SAN MATEO', 3, '1507', 1624, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150723', 'SAN MATEO DE OTAO', 3, '1507', 1625, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150724', 'SAN PEDRO DE CASTA', 3, '1507', 1626, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150725', 'SAN PEDRO DE HUANCAYRE', 3, '1507', 1627, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150726', 'SANGALLAYA', 3, '1507', 1628, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150727', 'SANTA CRUZ DE COCACHACRA', 3, '1507', 1629, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150728', 'SANTA EULALIA', 3, '1507', 1630, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150729', 'SANTIAGO DE ANCHUCAYA', 3, '1507', 1631, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150730', 'SANTIAGO DE TUNA', 3, '1507', 1632, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150731', 'SANTO DOMINGO DE LOS OLLEROS', 3, '1507', 1633, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150732', 'SURCO', 3, '1507', 1634, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150801', 'HUACHO', 3, '1508', 1635, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150802', 'AMBAR', 3, '1508', 1636, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150803', 'CALETA DE CARQUIN', 3, '1508', 1637, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150804', 'CHECRAS', 3, '1508', 1638, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150805', 'HUALMAY', 3, '1508', 1639, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150806', 'HUAURA', 3, '1508', 1640, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150807', 'LEONCIO PRADO', 3, '1508', 1641, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150808', 'PACCHO', 3, '1508', 1642, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150809', 'SANTA LEONOR', 3, '1508', 1643, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150810', 'SANTA MARIA', 3, '1508', 1644, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150811', 'SAYAN', 3, '1508', 1645, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150812', 'VEGUETA', 3, '1508', 1646, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150901', 'OYON', 3, '1509', 1647, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150902', 'ANDAJES', 3, '1509', 1648, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150903', 'CAUJUL', 3, '1509', 1649, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150904', 'COCHAMARCA', 3, '1509', 1650, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150905', 'NAVAN', 3, '1509', 1651, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('150906', 'PACHANGARA', 3, '1509', 1652, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('151001', 'YAUYOS', 3, '1510', 1653, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('151002', 'ALIS', 3, '1510', 1654, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('151003', 'AYAUCA', 3, '1510', 1655, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('151004', 'AYAVIRI', 3, '1510', 1656, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('151005', 'AZANGARO', 3, '1510', 1657, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('151006', 'CACRA', 3, '1510', 1658, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('151007', 'CARANIA', 3, '1510', 1659, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('151008', 'CATAHUASI', 3, '1510', 1660, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('151009', 'CHOCOS', 3, '1510', 1661, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('151010', 'COCHAS', 3, '1510', 1662, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('151011', 'COLONIA', 3, '1510', 1663, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('151012', 'HONGOS', 3, '1510', 1664, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('151013', 'HUAMPARA', 3, '1510', 1665, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('151014', 'HUANCAYA', 3, '1510', 1666, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('151015', 'HUANGASCAR', 3, '1510', 1667, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('151016', 'HUANTAN', 3, '1510', 1668, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('151017', 'HUAÑEC', 3, '1510', 1669, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('151018', 'LARAOS', 3, '1510', 1670, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('151019', 'LINCHA', 3, '1510', 1671, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('151020', 'MADEAN', 3, '1510', 1672, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('151021', 'MIRAFLORES', 3, '1510', 1673, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('151022', 'OMAS', 3, '1510', 1674, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('151023', 'PUTINZA', 3, '1510', 1675, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('151024', 'QUINCHES', 3, '1510', 1676, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('151025', 'QUINOCAY', 3, '1510', 1677, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('151026', 'SAN JOAQUIN', 3, '1510', 1678, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('151027', 'SAN PEDRO DE PILAS', 3, '1510', 1679, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('151028', 'TANTA', 3, '1510', 1680, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('151029', 'TAURIPAMPA', 3, '1510', 1681, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('151030', 'TOMAS', 3, '1510', 1682, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('151031', 'TUPE', 3, '1510', 1683, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('151032', 'VIÑAC', 3, '1510', 1684, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('151033', 'VITIS', 3, '1510', 1685, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160101', 'IQUITOS', 3, '1601', 1686, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160102', 'ALTO NANAY', 3, '1601', 1687, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160103', 'FERNANDO LORES', 3, '1601', 1688, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160104', 'INDIANA', 3, '1601', 1689, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160105', 'LAS AMAZONAS', 3, '1601', 1690, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160106', 'MAZAN', 3, '1601', 1691, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160107', 'NAPO', 3, '1601', 1692, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160108', 'PUNCHANA', 3, '1601', 1693, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160109', 'PUTUMAYO', 3, '1601', 1694, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160110', 'TORRES CAUSANA', 3, '1601', 1695, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160112', 'BELEN', 3, '1601', 1696, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160113', 'SAN JUAN BAUTISTA', 3, '1601', 1697, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160114', 'TENIENTE MANUEL CLAVERO', 3, '1601', 1698, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160201', 'YURIMAGUAS', 3, '1602', 1699, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160202', 'BALSAPUERTO', 3, '1602', 1700, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160205', 'JEBEROS', 3, '1602', 1701, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160206', 'LAGUNAS', 3, '1602', 1702, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160210', 'SANTA CRUZ', 3, '1602', 1703, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160211', 'TENIENTE CESAR LOPEZ ROJAS', 3, '1602', 1704, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160301', 'NAUTA', 3, '1603', 1705, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160302', 'PARINARI', 3, '1603', 1706, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160303', 'TIGRE', 3, '1603', 1707, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160304', 'TROMPETEROS', 3, '1603', 1708, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160305', 'URARINAS', 3, '1603', 1709, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160401', 'RAMON CASTILLA', 3, '1604', 1710, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160402', 'PEBAS', 3, '1604', 1711, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160403', 'YAVARI', 3, '1604', 1712, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160404', 'SAN PABLO', 3, '1604', 1713, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160501', 'REQUENA', 3, '1605', 1714, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160502', 'ALTO TAPICHE', 3, '1605', 1715, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160503', 'CAPELO', 3, '1605', 1716, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160504', 'EMILIO SAN MARTIN', 3, '1605', 1717, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160505', 'MAQUIA', 3, '1605', 1718, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160506', 'PUINAHUA', 3, '1605', 1719, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160507', 'SAQUENA', 3, '1605', 1720, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160508', 'SOPLIN', 3, '1605', 1721, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160509', 'TAPICHE', 3, '1605', 1722, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160510', 'JENARO HERRERA', 3, '1605', 1723, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160511', 'YAQUERANA', 3, '1605', 1724, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160601', 'CONTAMANA', 3, '1606', 1725, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160602', 'INAHUAYA', 3, '1606', 1726, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160603', 'PADRE MARQUEZ', 3, '1606', 1727, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160604', 'PAMPA HERMOSA', 3, '1606', 1728, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160605', 'SARAYACU', 3, '1606', 1729, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160606', 'VARGAS GUERRA', 3, '1606', 1730, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160701', 'BARRANCA', 3, '1607', 1731, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160702', 'CAHUAPANAS', 3, '1607', 1732, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160703', 'MANSERICHE', 3, '1607', 1733, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160704', 'MORONA', 3, '1607', 1734, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160705', 'PASTAZA', 3, '1607', 1735, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160706', 'ANDOAS', 3, '1607', 1736, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160801', 'PUTUMAYO', 3, '1608', 1737, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160802', 'ROSA PANDURO', 3, '1608', 1738, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160803', 'TENIENTE MANUEL CLAVERO', 3, '1608', 1739, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('160804', 'YAGUAS', 3, '1608', 1740, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('170101', 'TAMBOPATA', 3, '1701', 1741, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('170102', 'INAMBARI', 3, '1701', 1742, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('170103', 'LAS PIEDRAS', 3, '1701', 1743, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('170104', 'LABERINTO', 3, '1701', 1744, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('170201', 'MANU', 3, '1702', 1745, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('170202', 'FITZCARRALD', 3, '1702', 1746, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('170203', 'MADRE DE DIOS', 3, '1702', 1747, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('170204', 'HUEPETUHE', 3, '1702', 1748, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('170301', 'IÑAPARI', 3, '1703', 1749, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('170302', 'IBERIA', 3, '1703', 1750, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('170303', 'TAHUAMANU', 3, '1703', 1751, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('180101', 'MOQUEGUA', 3, '1801', 1752, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('180102', 'CARUMAS', 3, '1801', 1753, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('180103', 'CUCHUMBAYA', 3, '1801', 1754, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('180104', 'SAMEGUA', 3, '1801', 1755, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('180105', 'SAN CRISTOBAL', 3, '1801', 1756, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('180106', 'TORATA', 3, '1801', 1757, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('180201', 'OMATE', 3, '1802', 1758, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('180202', 'CHOJATA', 3, '1802', 1759, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('180203', 'COALAQUE', 3, '1802', 1760, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('180204', 'ICHUÑA', 3, '1802', 1761, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('180205', 'LA CAPILLA', 3, '1802', 1762, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('180206', 'LLOQUE', 3, '1802', 1763, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('180207', 'MATALAQUE', 3, '1802', 1764, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('180208', 'PUQUINA', 3, '1802', 1765, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('180209', 'QUINISTAQUILLAS', 3, '1802', 1766, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('180210', 'UBINAS', 3, '1802', 1767, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('180211', 'YUNGA', 3, '1802', 1768, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('180301', 'ILO', 3, '1803', 1769, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('180302', 'EL ALGARROBAL', 3, '1803', 1770, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('180303', 'PACOCHA', 3, '1803', 1771, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('190101', 'CHAUPIMARCA', 3, '1901', 1772, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('190102', 'HUACHON', 3, '1901', 1773, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('190103', 'HUARIACA', 3, '1901', 1774, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('190104', 'HUAYLLAY', 3, '1901', 1775, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('190105', 'NINACACA', 3, '1901', 1776, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('190106', 'PALLANCHACRA', 3, '1901', 1777, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('190107', 'PAUCARTAMBO', 3, '1901', 1778, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('190108', 'SAN FRANCISCO DE ASIS DE YARUSYACAN', 3, '1901', 1779, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('190109', 'SIMON BOLIVAR', 3, '1901', 1780, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('190110', 'TICLACAYAN', 3, '1901', 1781, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('190111', 'TINYAHUARCO', 3, '1901', 1782, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('190112', 'VICCO', 3, '1901', 1783, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('190113', 'YANACANCHA', 3, '1901', 1784, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('190201', 'YANAHUANCA', 3, '1902', 1785, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('190202', 'CHACAYAN', 3, '1902', 1786, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('190203', 'GOYLLARISQUIZGA', 3, '1902', 1787, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('190204', 'PAUCAR', 3, '1902', 1788, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('190205', 'SAN PEDRO DE PILLAO', 3, '1902', 1789, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('190206', 'SANTA ANA DE TUSI', 3, '1902', 1790, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('190207', 'TAPUC', 3, '1902', 1791, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('190208', 'VILCABAMBA', 3, '1902', 1792, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('190301', 'OXAPAMPA', 3, '1903', 1793, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('190302', 'CHONTABAMBA', 3, '1903', 1794, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('190303', 'HUANCABAMBA', 3, '1903', 1795, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('190304', 'PALCAZU', 3, '1903', 1796, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('190305', 'POZUZO', 3, '1903', 1797, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('190306', 'PUERTO BERMUDEZ', 3, '1903', 1798, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('190307', 'VILLA RICA', 3, '1903', 1799, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('190308', 'CONSTITUCION', 3, '1903', 1800, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200101', 'PIURA', 3, '2001', 1801, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200104', 'CASTILLA', 3, '2001', 1802, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200105', 'CATACAOS', 3, '2001', 1803, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200107', 'CURA MORI', 3, '2001', 1804, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200108', 'EL TALLAN', 3, '2001', 1805, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200109', 'LA ARENA', 3, '2001', 1806, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200110', 'LA UNION', 3, '2001', 1807, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200111', 'LAS LOMAS', 3, '2001', 1808, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200114', 'TAMBO GRANDE', 3, '2001', 1809, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200115', 'VEINTISEIS DE OCTUBRE', 3, '2001', 1810, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200201', 'AYABACA', 3, '2002', 1811, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200202', 'FRIAS', 3, '2002', 1812, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200203', 'JILILI', 3, '2002', 1813, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200204', 'LAGUNAS', 3, '2002', 1814, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200205', 'MONTERO', 3, '2002', 1815, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200206', 'PACAIPAMPA', 3, '2002', 1816, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200207', 'PAIMAS', 3, '2002', 1817, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200208', 'SAPILLICA', 3, '2002', 1818, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200209', 'SICCHEZ', 3, '2002', 1819, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200210', 'SUYO', 3, '2002', 1820, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200301', 'HUANCABAMBA', 3, '2003', 1821, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200302', 'CANCHAQUE', 3, '2003', 1822, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200303', 'EL CARMEN DE LA FRONTERA', 3, '2003', 1823, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200304', 'HUARMACA', 3, '2003', 1824, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200305', 'LALAQUIZ', 3, '2003', 1825, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200306', 'SAN MIGUEL DE EL FAIQUE', 3, '2003', 1826, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200307', 'SONDOR', 3, '2003', 1827, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200308', 'SONDORILLO', 3, '2003', 1828, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200401', 'CHULUCANAS', 3, '2004', 1829, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200402', 'BUENOS AIRES', 3, '2004', 1830, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200403', 'CHALACO', 3, '2004', 1831, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200404', 'LA MATANZA', 3, '2004', 1832, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200405', 'MORROPON', 3, '2004', 1833, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200406', 'SALITRAL', 3, '2004', 1834, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200407', 'SAN JUAN DE BIGOTE', 3, '2004', 1835, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200408', 'SANTA CATALINA DE MOSSA', 3, '2004', 1836, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200409', 'SANTO DOMINGO', 3, '2004', 1837, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200410', 'YAMANGO', 3, '2004', 1838, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200501', 'PAITA', 3, '2005', 1839, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200502', 'AMOTAPE', 3, '2005', 1840, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200503', 'ARENAL', 3, '2005', 1841, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200504', 'COLAN', 3, '2005', 1842, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200505', 'LA HUACA', 3, '2005', 1843, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200506', 'TAMARINDO', 3, '2005', 1844, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200507', 'VICHAYAL', 3, '2005', 1845, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200601', 'SULLANA', 3, '2006', 1846, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200602', 'BELLAVISTA', 3, '2006', 1847, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200603', 'IGNACIO ESCUDERO', 3, '2006', 1848, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200604', 'LANCONES', 3, '2006', 1849, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200605', 'MARCAVELICA', 3, '2006', 1850, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200606', 'MIGUEL CHECA', 3, '2006', 1851, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200607', 'QUERECOTILLO', 3, '2006', 1852, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200608', 'SALITRAL', 3, '2006', 1853, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200701', 'PARIÑAS', 3, '2007', 1854, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200702', 'EL ALTO', 3, '2007', 1855, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200703', 'LA BREA', 3, '2007', 1856, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200704', 'LOBITOS', 3, '2007', 1857, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200705', 'LOS ORGANOS', 3, '2007', 1858, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200706', 'MANCORA', 3, '2007', 1859, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200801', 'SECHURA', 3, '2008', 1860, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200802', 'BELLAVISTA DE LA UNION', 3, '2008', 1861, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200803', 'BERNAL', 3, '2008', 1862, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200804', 'CRISTO NOS VALGA', 3, '2008', 1863, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200805', 'VICE', 3, '2008', 1864, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('200806', 'RINCONADA LLICUAR', 3, '2008', 1865, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210101', 'PUNO', 3, '2101', 1866, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210102', 'ACORA', 3, '2101', 1867, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210103', 'AMANTANI', 3, '2101', 1868, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210104', 'ATUNCOLLA', 3, '2101', 1869, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210105', 'CAPACHICA', 3, '2101', 1870, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210106', 'CHUCUITO', 3, '2101', 1871, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210107', 'COATA', 3, '2101', 1872, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210108', 'HUATA', 3, '2101', 1873, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210109', 'MAÑAZO', 3, '2101', 1874, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210110', 'PAUCARCOLLA', 3, '2101', 1875, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210111', 'PICHACANI', 3, '2101', 1876, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210112', 'PLATERIA', 3, '2101', 1877, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210113', 'SAN ANTONIO', 3, '2101', 1878, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210114', 'TIQUILLACA', 3, '2101', 1879, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210115', 'VILQUE', 3, '2101', 1880, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210201', 'AZANGARO', 3, '2102', 1881, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210202', 'ACHAYA', 3, '2102', 1882, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210203', 'ARAPA', 3, '2102', 1883, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210204', 'ASILLO', 3, '2102', 1884, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210205', 'CAMINACA', 3, '2102', 1885, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210206', 'CHUPA', 3, '2102', 1886, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210207', 'JOSE DOMINGO CHOQUEHUANCA', 3, '2102', 1887, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210208', 'MUÑANI', 3, '2102', 1888, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210209', 'POTONI', 3, '2102', 1889, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210210', 'SAMAN', 3, '2102', 1890, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210211', 'SAN ANTON', 3, '2102', 1891, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210212', 'SAN JOSE', 3, '2102', 1892, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210213', 'SAN JUAN DE SALINAS', 3, '2102', 1893, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210214', 'SANTIAGO DE PUPUJA', 3, '2102', 1894, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210215', 'TIRAPATA', 3, '2102', 1895, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210301', 'MACUSANI', 3, '2103', 1896, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210302', 'AJOYANI', 3, '2103', 1897, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210303', 'AYAPATA', 3, '2103', 1898, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210304', 'COASA', 3, '2103', 1899, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210305', 'CORANI', 3, '2103', 1900, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210306', 'CRUCERO', 3, '2103', 1901, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210307', 'ITUATA', 3, '2103', 1902, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210308', 'OLLACHEA', 3, '2103', 1903, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210309', 'SAN GABAN', 3, '2103', 1904, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210310', 'USICAYOS', 3, '2103', 1905, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210401', 'JULI', 3, '2104', 1906, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210402', 'DESAGUADERO', 3, '2104', 1907, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210403', 'HUACULLANI', 3, '2104', 1908, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210404', 'KELLUYO', 3, '2104', 1909, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210405', 'PISACOMA', 3, '2104', 1910, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210406', 'POMATA', 3, '2104', 1911, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210407', 'ZEPITA', 3, '2104', 1912, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210501', 'ILAVE', 3, '2105', 1913, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210502', 'CAPAZO', 3, '2105', 1914, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210503', 'PILCUYO', 3, '2105', 1915, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210504', 'SANTA ROSA', 3, '2105', 1916, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210505', 'CONDURIRI', 3, '2105', 1917, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210601', 'HUANCANE', 3, '2106', 1918, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210602', 'COJATA', 3, '2106', 1919, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210603', 'HUATASANI', 3, '2106', 1920, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210604', 'INCHUPALLA', 3, '2106', 1921, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210605', 'PUSI', 3, '2106', 1922, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210606', 'ROSASPATA', 3, '2106', 1923, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210607', 'TARACO', 3, '2106', 1924, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210608', 'VILQUE CHICO', 3, '2106', 1925, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210701', 'LAMPA', 3, '2107', 1926, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210702', 'CABANILLA', 3, '2107', 1927, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210703', 'CALAPUJA', 3, '2107', 1928, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210704', 'NICASIO', 3, '2107', 1929, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210705', 'OCUVIRI', 3, '2107', 1930, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210706', 'PALCA', 3, '2107', 1931, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210707', 'PARATIA', 3, '2107', 1932, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210708', 'PUCARA', 3, '2107', 1933, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210709', 'SANTA LUCIA', 3, '2107', 1934, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210710', 'VILAVILA', 3, '2107', 1935, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210801', 'AYAVIRI', 3, '2108', 1936, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210802', 'ANTAUTA', 3, '2108', 1937, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210803', 'CUPI', 3, '2108', 1938, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210804', 'LLALLI', 3, '2108', 1939, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210805', 'MACARI', 3, '2108', 1940, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210806', 'NUÑOA', 3, '2108', 1941, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210807', 'ORURILLO', 3, '2108', 1942, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210808', 'SANTA ROSA', 3, '2108', 1943, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210809', 'UMACHIRI', 3, '2108', 1944, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210901', 'MOHO', 3, '2109', 1945, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210902', 'CONIMA', 3, '2109', 1946, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210903', 'HUAYRAPATA', 3, '2109', 1947, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('210904', 'TILALI', 3, '2109', 1948, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('211001', 'PUTINA', 3, '2110', 1949, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('211002', 'ANANEA', 3, '2110', 1950, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('211003', 'PEDRO VILCA APAZA', 3, '2110', 1951, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('211004', 'QUILCAPUNCU', 3, '2110', 1952, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('211005', 'SINA', 3, '2110', 1953, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('211101', 'JULIACA', 3, '2111', 1954, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('211102', 'CABANA', 3, '2111', 1955, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('211103', 'CABANILLAS', 3, '2111', 1956, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('211104', 'CARACOTO', 3, '2111', 1957, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('211105', 'SAN MIGUEL', 3, '2111', 1958, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('211201', 'SANDIA', 3, '2112', 1959, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('211202', 'CUYOCUYO', 3, '2112', 1960, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('211203', 'LIMBANI', 3, '2112', 1961, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('211204', 'PATAMBUCO', 3, '2112', 1962, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('211205', 'PHARA', 3, '2112', 1963, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('211206', 'QUIACA', 3, '2112', 1964, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('211207', 'SAN JUAN DEL ORO', 3, '2112', 1965, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('211208', 'YANAHUAYA', 3, '2112', 1966, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('211209', 'ALTO INAMBARI', 3, '2112', 1967, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('211210', 'SAN PEDRO DE PUTINA PUNCO', 3, '2112', 1968, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('211301', 'YUNGUYO', 3, '2113', 1969, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('211302', 'ANAPIA', 3, '2113', 1970, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('211303', 'COPANI', 3, '2113', 1971, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('211304', 'CUTURAPI', 3, '2113', 1972, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('211305', 'OLLARAYA', 3, '2113', 1973, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('211306', 'TINICACHI', 3, '2113', 1974, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('211307', 'UNICACHI', 3, '2113', 1975, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220101', 'MOYOBAMBA', 3, '2201', 1976, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220102', 'CALZADA', 3, '2201', 1977, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220103', 'HABANA', 3, '2201', 1978, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220104', 'JEPELACIO', 3, '2201', 1979, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220105', 'SORITOR', 3, '2201', 1980, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220106', 'YANTALO', 3, '2201', 1981, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220201', 'BELLAVISTA', 3, '2202', 1982, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220202', 'ALTO BIAVO', 3, '2202', 1983, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220203', 'BAJO BIAVO', 3, '2202', 1984, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220204', 'HUALLAGA', 3, '2202', 1985, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220205', 'SAN PABLO', 3, '2202', 1986, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220206', 'SAN RAFAEL', 3, '2202', 1987, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220301', 'SAN JOSE DE SISA', 3, '2203', 1988, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220302', 'AGUA BLANCA', 3, '2203', 1989, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220303', 'SAN MARTIN', 3, '2203', 1990, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220304', 'SANTA ROSA', 3, '2203', 1991, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220305', 'SHATOJA', 3, '2203', 1992, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220401', 'SAPOSOA', 3, '2204', 1993, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220402', 'ALTO SAPOSOA', 3, '2204', 1994, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220403', 'EL ESLABON', 3, '2204', 1995, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220404', 'PISCOYACU', 3, '2204', 1996, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220405', 'SACANCHE', 3, '2204', 1997, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220406', 'TINGO DE SAPOSOA', 3, '2204', 1998, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220501', 'LAMAS', 3, '2205', 1999, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220502', 'ALONSO DE ALVARADO', 3, '2205', 2000, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220503', 'BARRANQUITA', 3, '2205', 2001, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220504', 'CAYNARACHI', 3, '2205', 2002, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220505', 'CUÑUMBUQUI', 3, '2205', 2003, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220506', 'PINTO RECODO', 3, '2205', 2004, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220507', 'RUMISAPA', 3, '2205', 2005, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220508', 'SAN ROQUE DE CUMBAZA', 3, '2205', 2006, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220509', 'SHANAO', 3, '2205', 2007, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220510', 'TABALOSOS', 3, '2205', 2008, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220511', 'ZAPATERO', 3, '2205', 2009, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220601', 'JUANJUI', 3, '2206', 2010, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220602', 'CAMPANILLA', 3, '2206', 2011, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220603', 'HUICUNGO', 3, '2206', 2012, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220604', 'PACHIZA', 3, '2206', 2013, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220605', 'PAJARILLO', 3, '2206', 2014, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220701', 'PICOTA', 3, '2207', 2015, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220702', 'BUENOS AIRES', 3, '2207', 2016, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220703', 'CASPISAPA', 3, '2207', 2017, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220704', 'PILLUANA', 3, '2207', 2018, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220705', 'PUCACACA', 3, '2207', 2019, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220706', 'SAN CRISTOBAL', 3, '2207', 2020, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220707', 'SAN HILARION', 3, '2207', 2021, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220708', 'SHAMBOYACU', 3, '2207', 2022, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220709', 'TINGO DE PONASA', 3, '2207', 2023, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220710', 'TRES UNIDOS', 3, '2207', 2024, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220801', 'RIOJA', 3, '2208', 2025, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220802', 'AWAJUN', 3, '2208', 2026, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220803', 'ELIAS SOPLIN VARGAS', 3, '2208', 2027, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220804', 'NUEVA CAJAMARCA', 3, '2208', 2028, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220805', 'PARDO MIGUEL', 3, '2208', 2029, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220806', 'POSIC', 3, '2208', 2030, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220807', 'SAN FERNANDO', 3, '2208', 2031, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220808', 'YORONGOS', 3, '2208', 2032, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220809', 'YURACYACU', 3, '2208', 2033, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220901', 'TARAPOTO', 3, '2209', 2034, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220902', 'ALBERTO LEVEAU', 3, '2209', 2035, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220903', 'CACATACHI', 3, '2209', 2036, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220904', 'CHAZUTA', 3, '2209', 2037, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220905', 'CHIPURANA', 3, '2209', 2038, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220906', 'EL PORVENIR', 3, '2209', 2039, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220907', 'HUIMBAYOC', 3, '2209', 2040, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220908', 'JUAN GUERRA', 3, '2209', 2041, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220909', 'LA BANDA DE SHILCAYO', 3, '2209', 2042, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220910', 'MORALES', 3, '2209', 2043, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220911', 'PAPAPLAYA', 3, '2209', 2044, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220912', 'SAN ANTONIO', 3, '2209', 2045, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220913', 'SAUCE', 3, '2209', 2046, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('220914', 'SHAPAJA', 3, '2209', 2047, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('221001', 'TOCACHE', 3, '2210', 2048, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('221002', 'NUEVO PROGRESO', 3, '2210', 2049, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('221003', 'POLVORA', 3, '2210', 2050, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('221004', 'SHUNTE', 3, '2210', 2051, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('221005', 'UCHIZA', 3, '2210', 2052, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('221006', 'SANTA LUCIA', 3, '2210', 2053, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('230101', 'TACNA', 3, '2301', 2054, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('230102', 'ALTO DE LA ALIANZA', 3, '2301', 2055, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('230103', 'CALANA', 3, '2301', 2056, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('230104', 'CIUDAD NUEVA', 3, '2301', 2057, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('230105', 'INCLAN', 3, '2301', 2058, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('230106', 'PACHIA', 3, '2301', 2059, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('230107', 'PALCA', 3, '2301', 2060, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('230108', 'POCOLLAY', 3, '2301', 2061, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('230109', 'SAMA', 3, '2301', 2062, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('230110', 'CORONEL GREGORIO ALBARRACIN LANCHIPA', 3, '2301', 2063, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('230111', 'LA YARADA LOS PALOS', 3, '2301', 2064, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('230201', 'CANDARAVE', 3, '2302', 2065, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('230202', 'CAIRANI', 3, '2302', 2066, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('230203', 'CAMILACA', 3, '2302', 2067, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('230204', 'CURIBAYA', 3, '2302', 2068, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('230205', 'HUANUARA', 3, '2302', 2069, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('230206', 'QUILAHUANI', 3, '2302', 2070, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('230301', 'LOCUMBA', 3, '2303', 2071, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('230302', 'ILABAYA', 3, '2303', 2072, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('230303', 'ITE', 3, '2303', 2073, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('230401', 'TARATA', 3, '2304', 2074, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('230402', 'HEROES ALBARRACIN CHUCATAMANI', 3, '2304', 2075, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('230403', 'ESTIQUE', 3, '2304', 2076, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('230404', 'ESTIQUE-PAMPA', 3, '2304', 2077, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('230405', 'SITAJARA', 3, '2304', 2078, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('230406', 'SUSAPAYA', 3, '2304', 2079, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('230407', 'TARUCACHI', 3, '2304', 2080, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('230408', 'TICACO', 3, '2304', 2081, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('240101', 'TUMBES', 3, '2401', 2082, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('240102', 'CORRALES', 3, '2401', 2083, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('240103', 'LA CRUZ', 3, '2401', 2084, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('240104', 'PAMPAS DE HOSPITAL', 3, '2401', 2085, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('240105', 'SAN JACINTO', 3, '2401', 2086, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('240106', 'SAN JUAN DE LA VIRGEN', 3, '2401', 2087, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('240201', 'ZORRITOS', 3, '2402', 2088, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('240202', 'CASITAS', 3, '2402', 2089, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('240203', 'CANOAS DE PUNTA SAL', 3, '2402', 2090, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('240301', 'ZARUMILLA', 3, '2403', 2091, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('240302', 'AGUAS VERDES', 3, '2403', 2092, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('240303', 'MATAPALO', 3, '2403', 2093, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('240304', 'PAPAYAL', 3, '2403', 2094, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('250101', 'CALLERIA', 3, '2501', 2095, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('250102', 'CAMPOVERDE', 3, '2501', 2096, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('250103', 'IPARIA', 3, '2501', 2097, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('250104', 'MASISEA', 3, '2501', 2098, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('250105', 'YARINACOCHA', 3, '2501', 2099, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('250106', 'NUEVA REQUENA', 3, '2501', 2100, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('250107', 'MANANTAY', 3, '2501', 2101, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('250201', 'RAYMONDI', 3, '2502', 2102, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('250202', 'SEPAHUA', 3, '2502', 2103, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('250203', 'TAHUANIA', 3, '2502', 2104, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('250204', 'YURUA', 3, '2502', 2105, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('250301', 'PADRE ABAD', 3, '2503', 2106, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('250302', 'IRAZOLA', 3, '2503', 2107, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('250303', 'CURIMANA', 3, '2503', 2108, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('250304', 'NESHUYA', 3, '2503', 2109, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('250305', 'ALEXANDER VON HUMBOLDT', 3, '2503', 2110, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('250306', 'HUIPOCA', 3, '2503', 2111, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('250307', 'BOQUERON', 3, '2503', 2112, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);
INSERT INTO configuracion.ubigeos VALUES ('250401', 'PURUS', 3, '2504', 2113, true, '2026-03-27 23:42:11.065804-05', 'SISTEMA', NULL, NULL);


--
-- TOC entry 4587 (class 0 OID 46413)
-- Dependencies: 258
-- Data for Name: asientos_contables; Type: TABLE DATA; Schema: contabilidad; Owner: postgres
--



--
-- TOC entry 4589 (class 0 OID 46424)
-- Dependencies: 260
-- Data for Name: centros_costo; Type: TABLE DATA; Schema: contabilidad; Owner: postgres
--



--
-- TOC entry 4591 (class 0 OID 46431)
-- Dependencies: 262
-- Data for Name: detalle_asiento; Type: TABLE DATA; Schema: contabilidad; Owner: postgres
--



--
-- TOC entry 4593 (class 0 OID 46437)
-- Dependencies: 264
-- Data for Name: plan_cuentas; Type: TABLE DATA; Schema: contabilidad; Owner: postgres
--



--
-- TOC entry 4595 (class 0 OID 46446)
-- Dependencies: 266
-- Data for Name: areas; Type: TABLE DATA; Schema: identidad; Owner: postgres
--



--
-- TOC entry 4597 (class 0 OID 46453)
-- Dependencies: 268
-- Data for Name: auditoria_accesos; Type: TABLE DATA; Schema: identidad; Owner: postgres
--



--
-- TOC entry 4599 (class 0 OID 46460)
-- Dependencies: 270
-- Data for Name: cargos; Type: TABLE DATA; Schema: identidad; Owner: postgres
--



--
-- TOC entry 4601 (class 0 OID 46467)
-- Dependencies: 272
-- Data for Name: menus; Type: TABLE DATA; Schema: identidad; Owner: postgres
--

INSERT INTO identidad.menus VALUES (1, 'DASHBOARD', 'Dashboard', 'Panel principal del sistema', '/dashboard', 'dashboard', 1, NULL, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (2, 'VENTAS', 'Ventas', 'Módulo de gestión de ventas', '/ventas', 'shopping-cart', 2, NULL, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (3, 'COMPRAS', 'Compras', 'Módulo de gestión de compras', '/compras', 'shopping-bag', 3, NULL, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (4, 'INVENTARIO', 'Inventario', 'Módulo de gestión de inventario', '/inventario', 'warehouse', 4, NULL, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (5, 'CLIENTES', 'Clientes', 'Módulo de gestión de clientes', '/clientes', 'users', 5, NULL, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (6, 'CATALOGO', 'Catálogo', 'Módulo de gestión de productos', '/catalogo', 'book', 6, NULL, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (7, 'CONTABILIDAD', 'Contabilidad', 'Módulo de contabilidad', '/contabilidad', 'calculator', 7, NULL, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (8, 'CONFIGURACION', 'Configuración', 'Configuración del sistema', '/configuracion', 'settings', 8, NULL, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (9, 'IDENTIDAD', 'Identidad', 'Gestión de usuarios y permisos', '/identidad', 'shield', 9, NULL, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (10, 'VENTAS_LISTA', 'Lista de Ventas', 'Ver todas las ventas', '/ventas/lista', 'list', 1, 2, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (11, 'VENTAS_NUEVA', 'Nueva Venta', 'Registrar nueva venta', '/ventas/nueva', 'plus', 2, 2, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (12, 'VENTAS_COTIZACIONES', 'Cotizaciones', 'Gestionar cotizaciones', '/ventas/cotizaciones', 'file-text', 3, 2, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (13, 'VENTAS_CAJAS', 'Cajas', 'Gestión de cajas', '/ventas/cajas', 'credit-card', 4, 2, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (14, 'COMPRAS_LISTA', 'Lista de Compras', 'Ver todas las compras', '/compras/lista', 'list', 1, 3, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (15, 'COMPRAS_NUEVA', 'Nueva Compra', 'Registrar nueva compra', '/compras/nueva', 'plus', 2, 3, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (16, 'COMPRAS_ORDENES', 'Órdenes de Compra', 'Gestionar órdenes', '/compras/ordenes', 'clipboard', 3, 3, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (17, 'COMPRAS_PROVEEDORES', 'Proveedores', 'Gestión de proveedores', '/compras/proveedores', 'truck', 4, 3, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (18, 'INVENTARIO_STOCK', 'Stock', 'Consultar stock disponible', '/inventario/stock', 'package', 1, 4, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (19, 'INVENTARIO_MOVIMIENTOS', 'Movimientos', 'Movimientos de inventario', '/inventario/movimientos', 'repeat', 2, 4, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (20, 'INVENTARIO_ALMACENES', 'Almacenes', 'Gestión de almacenes', '/inventario/almacenes', 'home', 3, 4, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (21, 'CATALOGO_PRODUCTOS', 'Productos', 'Gestión de productos', '/catalogo/productos', 'box', 1, 6, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (22, 'CATALOGO_CATEGORIAS', 'Categorías', 'Gestión de categorías', '/catalogo/categorias', 'folder', 2, 6, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (23, 'CATALOGO_MARCAS', 'Marcas', 'Gestión de marcas', '/catalogo/marcas', 'tag', 3, 6, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (24, 'CATALOGO_PRECIOS', 'Listas de Precios', 'Gestión de precios', '/catalogo/precios', 'dollar-sign', 4, 6, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (25, 'IDENTIDAD_USUARIOS', 'Usuarios', 'Gestión de usuarios', '/identidad/usuarios', 'user', 1, 9, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (26, 'IDENTIDAD_ROLES', 'Roles', 'Gestión de roles', '/identidad/roles', 'users', 2, 9, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (27, 'IDENTIDAD_PERMISOS', 'Permisos', 'Asignación de permisos', '/identidad/permisos', 'lock', 3, 9, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (28, 'CAT_UNIDADES_MEDIDA', 'Unidades de Medida', 'GestiÃ³n de unidades de medida', '/catalogo/unidades-medida', 'Ruler', 30, 6, true, '2026-03-16 09:20:16.047069', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (29, 'CAT_LISTAS_PRECIOS', 'Listas de Precios', 'GestiÃ³n de listas de precios', '/catalogo/listas-precios', 'DollarSign', 40, 6, true, '2026-03-16 09:20:16.048196', 'SYSTEM', NULL, NULL);


--
-- TOC entry 4603 (class 0 OID 46477)
-- Dependencies: 274
-- Data for Name: permisos; Type: TABLE DATA; Schema: identidad; Owner: postgres
--



--
-- TOC entry 4605 (class 0 OID 46486)
-- Dependencies: 276
-- Data for Name: roles; Type: TABLE DATA; Schema: identidad; Owner: postgres
--

INSERT INTO identidad.roles VALUES (1, 'ADMINISTRADOR', 'Acceso total al sistema', true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);
INSERT INTO identidad.roles VALUES (2, 'VENDEDOR', 'Acceso a módulo de ventas y clientes', true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);
INSERT INTO identidad.roles VALUES (3, 'CAJERO', 'Acceso a apertura/cierre de caja y cobros', true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);
INSERT INTO identidad.roles VALUES (4, 'ALMACENERO', 'Acceso a inventarios y kardex', true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);


--
-- TOC entry 4607 (class 0 OID 46495)
-- Dependencies: 278
-- Data for Name: roles_menus; Type: TABLE DATA; Schema: identidad; Owner: postgres
--

INSERT INTO identidad.roles_menus VALUES (1, 1, 28, true, '2026-03-16 09:20:16.048781', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.roles_menus VALUES (2, 1, 29, true, '2026-03-16 09:20:16.050401', 'SYSTEM', NULL, NULL);


--
-- TOC entry 4609 (class 0 OID 46502)
-- Dependencies: 280
-- Data for Name: roles_menus_permisos; Type: TABLE DATA; Schema: identidad; Owner: postgres
--



--
-- TOC entry 4611 (class 0 OID 46509)
-- Dependencies: 282
-- Data for Name: roles_permisos; Type: TABLE DATA; Schema: identidad; Owner: postgres
--



--
-- TOC entry 4612 (class 0 OID 46515)
-- Dependencies: 283
-- Data for Name: tipos_permiso; Type: TABLE DATA; Schema: identidad; Owner: postgres
--

INSERT INTO identidad.tipos_permiso VALUES (1, 'CREATE', 'Crear', 'Permite crear nuevos registros', true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.tipos_permiso VALUES (2, 'READ', 'Leer', 'Permite ver y consultar registros', true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.tipos_permiso VALUES (3, 'UPDATE', 'Actualizar', 'Permite modificar registros existentes', true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.tipos_permiso VALUES (4, 'DELETE', 'Eliminar', 'Permite eliminar registros', true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.tipos_permiso VALUES (5, 'EXPORT', 'Exportar', 'Permite exportar datos a archivos', true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.tipos_permiso VALUES (6, 'IMPORT', 'Importar', 'Permite importar datos desde archivos', true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.tipos_permiso VALUES (7, 'APPROVE', 'Aprobar', 'Permite aprobar transacciones o documentos', true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.tipos_permiso VALUES (8, 'PRINT', 'Imprimir', 'Permite imprimir documentos', true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.tipos_permiso VALUES (9, 'CANCEL', 'Anular', 'Permite anular documentos o transacciones', true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);


--
-- TOC entry 4614 (class 0 OID 46524)
-- Dependencies: 285
-- Data for Name: trabajadores; Type: TABLE DATA; Schema: identidad; Owner: postgres
--



--
-- TOC entry 4616 (class 0 OID 46533)
-- Dependencies: 287
-- Data for Name: usuarios; Type: TABLE DATA; Schema: identidad; Owner: postgres
--

INSERT INTO identidad.usuarios VALUES (1, 'admin', '$2a$12$R9h/cIPz0gi.URNNXRFXjOios9lnpSHkTE.oFw0kX8k.js9l0.y', 'admin@sistema.com', 'Administrador', 'Principal', 1, NULL, true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);


--
-- TOC entry 4618 (class 0 OID 46542)
-- Dependencies: 289
-- Data for Name: usuarios_roles; Type: TABLE DATA; Schema: identidad; Owner: postgres
--



--
-- TOC entry 4620 (class 0 OID 46549)
-- Dependencies: 291
-- Data for Name: almacenes; Type: TABLE DATA; Schema: inventario; Owner: postgres
--

INSERT INTO inventario.almacenes VALUES (1, 'ALMACEN CENTRAL', 'SEDE PRINCIPAL', true, true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL, 1);


--
-- TOC entry 4678 (class 0 OID 66587)
-- Dependencies: 349
-- Data for Name: inv_kardex_lote; Type: TABLE DATA; Schema: inventario; Owner: postgres
--



--
-- TOC entry 4680 (class 0 OID 66598)
-- Dependencies: 351
-- Data for Name: inv_kardex_movimiento; Type: TABLE DATA; Schema: inventario; Owner: postgres
--

INSERT INTO inventario.inv_kardex_movimiento VALUES (1, '24480006-0373-4d84-b214-0aa4293997b8', '2026-03', 0, '2026-03-27', '03:29:22.646789', '2026-03-27 03:29:22.646789', 'COMPRAS', '01', 'F001', '00000021', false, NULL, NULL, 'E', '0101', 'Ingreso automático por Compra #22', 1, NULL, NULL, 10, 'NIU', 1.000000, 1.000000, 2899.000000, 2899.000000, 0.000000, 0.000000, 0.000000, 1.000000, 2899.000000, 2899.000000, 22, 'COMPRAS', NULL, NULL, NULL, 1, NULL, NULL, true, '2026-03-27 03:29:22.712875', '', NULL, NULL);
INSERT INTO inventario.inv_kardex_movimiento VALUES (2, '696312a0-47f3-4e47-b23b-00e94c708490', '2026-03', 0, '2026-03-27', '03:58:38.763956', '2026-03-27 03:58:38.763956', 'COMPRAS', '01', 'F001', '00000022', false, NULL, NULL, 'E', '0101', 'Ingreso automático por Compra #23', 1, NULL, NULL, 10, 'NIU', 1.000000, 1.000000, 2899.000000, 2899.000000, 0.000000, 0.000000, 0.000000, 2.000000, 2899.000000, 5798.000000, 23, 'COMPRAS', NULL, NULL, NULL, 1, NULL, NULL, true, '2026-03-27 03:58:38.870039', '', NULL, NULL);
INSERT INTO inventario.inv_kardex_movimiento VALUES (3, 'c7376ab0-2b4d-4696-a727-8a312584c549', '2026-03', 0, '2026-03-27', '04:11:59.270463', '2026-03-27 04:11:59.270463', 'COMPRAS', '01', 'F001', '00000024', false, NULL, NULL, 'E', '0101', 'Ingreso automático por Compra #24', 1, NULL, NULL, 10, 'NIU', 1.000000, 1.000000, 2899.000000, 2899.000000, 0.000000, 0.000000, 0.000000, 3.000000, 2899.000000, 8697.000000, 24, 'COMPRAS', NULL, NULL, NULL, 1, NULL, NULL, true, '2026-03-27 04:11:59.389503', '', NULL, NULL);
INSERT INTO inventario.inv_kardex_movimiento VALUES (4, 'fac94505-3978-48ed-990e-7e6f708574dd', '2026-03', 0, '2026-03-27', '04:30:28.280845', '2026-03-27 04:30:28.280845', 'COMPRAS', '01', 'F001', '00000029', false, NULL, NULL, 'E', '0101', 'Ingreso automático por Compra #29', 1, NULL, NULL, 10, 'NIU', 1.000000, 1.000000, 2899.000000, 2899.000000, 0.000000, 0.000000, 0.000000, 4.000000, 2899.000000, 11596.000000, 29, 'COMPRAS', NULL, NULL, NULL, 1, NULL, NULL, true, '2026-03-27 04:30:28.383527', '', NULL, NULL);
INSERT INTO inventario.inv_kardex_movimiento VALUES (5, '542fcf62-e089-4b85-9f49-8174a5f8b50f', '2026-03', 0, '2026-03-28', '05:59:59.083002', '2026-03-28 05:59:59.083002', 'VENTAS', '03', 'B001', '1', false, NULL, NULL, 'S', '0101', 'Salida automática por Venta #4', 1, NULL, NULL, 10, 'NIU', 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 2899.000000, 2899.000000, 3.000000, 2899.000000, 8697.000000, 4, 'VENTAS', NULL, NULL, NULL, 1, NULL, NULL, true, '2026-03-28 05:59:59.240281', '', NULL, NULL);
INSERT INTO inventario.inv_kardex_movimiento VALUES (6, '7ae733f7-7646-4b81-9088-84e9e16d54cd', '2026-03', 0, '2026-03-28', '17:08:07.579611', '2026-03-28 17:08:07.579611', 'VENTAS', '03', 'B001', '2', false, NULL, NULL, 'S', '0101', 'Salida automática por Venta #5', 1, NULL, NULL, 10, 'NIU', 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 2899.000000, 2899.000000, 2.000000, 2899.000000, 5798.000000, 5, 'VENTAS', NULL, NULL, NULL, 1, NULL, NULL, true, '2026-03-28 17:08:07.735752', '', NULL, NULL);
INSERT INTO inventario.inv_kardex_movimiento VALUES (7, 'ddc898c9-43a1-4808-8286-b0c5b17c7b91', '2026-03', 0, '2026-03-28', '17:36:27.806692', '2026-03-28 17:36:27.806692', 'COMPRAS', '01', 'F001', '000000', false, NULL, NULL, 'E', '0101', 'Ingreso automático por Compra #30', 1, NULL, NULL, 10, 'NIU', 1.000000, 10.000000, 2899.000000, 28990.000000, 0.000000, 0.000000, 0.000000, 12.000000, 2899.000000, 34788.000000, 30, 'COMPRAS', NULL, NULL, NULL, 1, NULL, NULL, true, '2026-03-28 17:36:27.934332', '', NULL, NULL);
INSERT INTO inventario.inv_kardex_movimiento VALUES (8, '27380861-666f-41f3-ae23-220842344cea', '2026-03', 0, '2026-03-28', '17:36:28.157163', '2026-03-28 17:36:28.157163', 'COMPRAS', '01', 'F001', '000000', false, NULL, NULL, 'E', '0101', 'Ingreso automático por Compra #30', 1, NULL, NULL, 13, 'NIU', 1.000000, 30.000000, 299.900000, 8997.000000, 0.000000, 0.000000, 0.000000, 30.000000, 299.900000, 8997.000000, 30, 'COMPRAS', NULL, NULL, NULL, 1, NULL, NULL, true, '2026-03-28 17:36:28.16237', '', NULL, NULL);
INSERT INTO inventario.inv_kardex_movimiento VALUES (9, '8e28387a-3588-4f75-8f43-130bbe7c2b49', '2026-03', 0, '2026-03-28', '17:36:28.205864', '2026-03-28 17:36:28.205864', 'COMPRAS', '01', 'F001', '000000', false, NULL, NULL, 'E', '0101', 'Ingreso automático por Compra #30', 1, NULL, NULL, 7, 'NIU', 1.000000, 15.000000, 1899.000000, 28485.000000, 0.000000, 0.000000, 0.000000, 15.000000, 1899.000000, 28485.000000, 30, 'COMPRAS', NULL, NULL, NULL, 1, NULL, NULL, true, '2026-03-28 17:36:28.215043', '', NULL, NULL);
INSERT INTO inventario.inv_kardex_movimiento VALUES (10, 'ce2c33aa-46d4-41a4-8179-217da46b6c1a', '2026-03', 0, '2026-03-28', '17:36:28.244105', '2026-03-28 17:36:28.244105', 'COMPRAS', '01', 'F001', '000000', false, NULL, NULL, 'E', '0101', 'Ingreso automático por Compra #30', 1, NULL, NULL, 11, 'NIU', 1.000000, 20.000000, 1850.500000, 37010.000000, 0.000000, 0.000000, 0.000000, 20.000000, 1850.500000, 37010.000000, 30, 'COMPRAS', NULL, NULL, NULL, 1, NULL, NULL, true, '2026-03-28 17:36:28.248267', '', NULL, NULL);
INSERT INTO inventario.inv_kardex_movimiento VALUES (11, 'b4f962f6-ef7a-414f-88b5-07326af63e65', '2026-03', 0, '2026-03-28', '17:36:28.277486', '2026-03-28 17:36:28.277486', 'COMPRAS', '01', 'F001', '000000', false, NULL, NULL, 'E', '0101', 'Ingreso automático por Compra #30', 1, NULL, NULL, 12, 'NIU', 1.000000, 20.000000, 199.900000, 3998.000000, 0.000000, 0.000000, 0.000000, 20.000000, 199.900000, 3998.000000, 30, 'COMPRAS', NULL, NULL, NULL, 1, NULL, NULL, true, '2026-03-28 17:36:28.281143', '', NULL, NULL);
INSERT INTO inventario.inv_kardex_movimiento VALUES (12, 'f4e9ee75-f79c-461e-b015-1242a051d102', '2026-03', 0, '2026-03-29', '18:18:02.137533', '2026-03-29 18:18:02.137533', 'VENTAS', '03', 'B001', '5', false, NULL, NULL, 'S', '0101', 'Salida automática por Venta #8', 1, NULL, NULL, 13, 'NIU', 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 299.900000, 299.900000, 29.000000, 299.900000, 8697.100000, 8, 'VENTAS', NULL, NULL, NULL, 1, NULL, NULL, true, '2026-03-29 18:18:02.283675', '', NULL, NULL);
INSERT INTO inventario.inv_kardex_movimiento VALUES (13, '4a489eab-3e42-4b47-8f8e-ec8cbb6b866a', '2026-03', 0, '2026-03-29', '18:18:02.565938', '2026-03-29 18:18:02.565938', 'VENTAS', '03', 'B001', '5', false, NULL, NULL, 'S', '0101', 'Salida automática por Venta #8', 1, NULL, NULL, 12, 'NIU', 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 199.900000, 199.900000, 19.000000, 199.900000, 3798.100000, 8, 'VENTAS', NULL, NULL, NULL, 1, NULL, NULL, true, '2026-03-29 18:18:02.572257', '', NULL, NULL);
INSERT INTO inventario.inv_kardex_movimiento VALUES (14, 'e459b3f0-e8ec-4225-83ef-375b0c5ef5dc', '2026-03', 0, '2026-03-29', '18:18:02.608003', '2026-03-29 18:18:02.608003', 'VENTAS', '03', 'B001', '5', false, NULL, NULL, 'S', '0101', 'Salida automática por Venta #8', 1, NULL, NULL, 7, 'NIU', 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1899.000000, 1899.000000, 14.000000, 1899.000000, 26586.000000, 8, 'VENTAS', NULL, NULL, NULL, 1, NULL, NULL, true, '2026-03-29 18:18:02.617895', '', NULL, NULL);
INSERT INTO inventario.inv_kardex_movimiento VALUES (15, '266d1651-eb04-458e-80b8-8476c8c7ec14', '2026-03', 0, '2026-03-29', '18:18:02.648679', '2026-03-29 18:18:02.648679', 'VENTAS', '03', 'B001', '5', false, NULL, NULL, 'S', '0101', 'Salida automática por Venta #8', 1, NULL, NULL, 10, 'NIU', 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 2899.000000, 2899.000000, 11.000000, 2899.000000, 31889.000000, 8, 'VENTAS', NULL, NULL, NULL, 1, NULL, NULL, true, '2026-03-29 18:18:02.65308', '', NULL, NULL);
INSERT INTO inventario.inv_kardex_movimiento VALUES (16, 'a3826296-cbe3-43a8-b963-8f42e376ac70', '2026-03', 0, '2026-03-26', '00:00:00', '2026-03-26 00:00:00', 'COMPRAS', '01', 'F001', '00000012', false, NULL, NULL, 'E', '0101', 'Sincronización histórica Compra #12 de la fecha 26/03/2026', 1, NULL, NULL, 10, 'NIU', 1.000000, 1.000000, 2899.000000, 2899.000000, 0.000000, 0.000000, 0.000000, 1.000000, 2899.000000, 2899.000000, 12, 'COMPRAS', NULL, NULL, NULL, 1, NULL, NULL, true, '2026-03-29 18:18:31.170251', '', NULL, NULL);
INSERT INTO inventario.inv_kardex_movimiento VALUES (17, 'f5ac0413-2f37-45c3-97db-80a98e0f4ba2', '2026-03', 0, '2026-03-26', '00:00:00', '2026-03-26 00:00:00', 'COMPRAS', '01', 'F001', '00000013', false, NULL, NULL, 'E', '0101', 'Sincronización histórica Compra #13 de la fecha 26/03/2026', 1, NULL, NULL, 10, 'NIU', 1.000000, 1.000000, 2899.000000, 2899.000000, 0.000000, 0.000000, 0.000000, 1.000000, 2899.000000, 2899.000000, 13, 'COMPRAS', NULL, NULL, NULL, 1, NULL, NULL, true, '2026-03-29 18:18:31.194968', '', NULL, NULL);
INSERT INTO inventario.inv_kardex_movimiento VALUES (18, '705db5d6-e8cd-4725-bc35-7789147c7b0f', '2026-03', 0, '2026-03-26', '00:00:00', '2026-03-26 00:00:00', 'COMPRAS', '01', 'F001', '00000014', false, NULL, NULL, 'E', '0101', 'Sincronización histórica Compra #14 de la fecha 26/03/2026', 1, NULL, NULL, 10, 'NIU', 1.000000, 1.000000, 2899.000000, 2899.000000, 0.000000, 0.000000, 0.000000, 1.000000, 2899.000000, 2899.000000, 14, 'COMPRAS', NULL, NULL, NULL, 1, NULL, NULL, true, '2026-03-29 18:18:31.212462', '', NULL, NULL);
INSERT INTO inventario.inv_kardex_movimiento VALUES (19, '7e1d3566-8e20-4e03-9b5c-ca2dbbd81811', '2026-03', 0, '2026-03-26', '00:00:00', '2026-03-26 00:00:00', 'COMPRAS', '01', 'F001', '00000015', false, NULL, NULL, 'E', '0101', 'Sincronización histórica Compra #15 de la fecha 26/03/2026', 1, NULL, NULL, 10, 'NIU', 1.000000, 1.000000, 2899.000000, 2899.000000, 0.000000, 0.000000, 0.000000, 1.000000, 2899.000000, 2899.000000, 15, 'COMPRAS', NULL, NULL, NULL, 1, NULL, NULL, true, '2026-03-29 18:18:31.228902', '', NULL, NULL);
INSERT INTO inventario.inv_kardex_movimiento VALUES (20, 'f48e65f2-90f7-4dc8-8212-d8733b38f98c', '2026-03', 0, '2026-03-26', '00:00:00', '2026-03-26 00:00:00', 'COMPRAS', '01', 'F001', '00000016', false, NULL, NULL, 'E', '0101', 'Sincronización histórica Compra #16 de la fecha 26/03/2026', 1, NULL, NULL, 10, 'NIU', 1.000000, 1.000000, 2899.000000, 2899.000000, 0.000000, 0.000000, 0.000000, 1.000000, 2899.000000, 2899.000000, 16, 'COMPRAS', NULL, NULL, NULL, 1, NULL, NULL, true, '2026-03-29 18:18:31.24581', '', NULL, NULL);
INSERT INTO inventario.inv_kardex_movimiento VALUES (21, 'a112e9df-0e73-4344-9f42-d00dbaedb00e', '2026-03', 0, '2026-03-26', '00:00:00', '2026-03-26 00:00:00', 'COMPRAS', '01', 'F001', '00000017', false, NULL, NULL, 'E', '0101', 'Sincronización histórica Compra #17 de la fecha 26/03/2026', 1, NULL, NULL, 10, 'NIU', 1.000000, 1.000000, 2899.000000, 2899.000000, 0.000000, 0.000000, 0.000000, 1.000000, 2899.000000, 2899.000000, 17, 'COMPRAS', NULL, NULL, NULL, 1, NULL, NULL, true, '2026-03-29 18:18:31.270118', '', NULL, NULL);
INSERT INTO inventario.inv_kardex_movimiento VALUES (22, '438b5a09-00d2-44d2-90ea-e9a2a67bafc2', '2026-03', 0, '2026-03-26', '00:00:00', '2026-03-26 00:00:00', 'COMPRAS', '01', 'F001', '00000018', false, NULL, NULL, 'E', '0101', 'Sincronización histórica Compra #18 de la fecha 26/03/2026', 1, NULL, NULL, 10, 'NIU', 1.000000, 1.000000, 2899.000000, 2899.000000, 0.000000, 0.000000, 0.000000, 1.000000, 2899.000000, 2899.000000, 18, 'COMPRAS', NULL, NULL, NULL, 1, NULL, NULL, true, '2026-03-29 18:18:31.28661', '', NULL, NULL);
INSERT INTO inventario.inv_kardex_movimiento VALUES (23, '74940a7b-b93e-4d9a-93e3-bdfe62564674', '2026-03', 0, '2026-03-26', '00:00:00', '2026-03-26 00:00:00', 'COMPRAS', '01', 'F001', '00000019', false, NULL, NULL, 'E', '0101', 'Sincronización histórica Compra #19 de la fecha 26/03/2026', 1, NULL, NULL, 10, 'NIU', 1.000000, 1.000000, 2899.000000, 2899.000000, 0.000000, 0.000000, 0.000000, 1.000000, 2899.000000, 2899.000000, 19, 'COMPRAS', NULL, NULL, NULL, 1, NULL, NULL, true, '2026-03-29 18:18:31.304924', '', NULL, NULL);
INSERT INTO inventario.inv_kardex_movimiento VALUES (24, '8c15b8f2-9dd5-40b3-941d-b1f8aad3f0d7', '2026-03', 0, '2026-03-26', '00:00:00', '2026-03-26 00:00:00', 'COMPRAS', '01', 'F001', '00000020', false, NULL, NULL, 'E', '0101', 'Sincronización histórica Compra #20 de la fecha 26/03/2026', 1, NULL, NULL, 10, 'NIU', 1.000000, 1.000000, 2899.000000, 2899.000000, 0.000000, 0.000000, 0.000000, 1.000000, 2899.000000, 2899.000000, 20, 'COMPRAS', NULL, NULL, NULL, 1, NULL, NULL, true, '2026-03-29 18:18:31.322572', '', NULL, NULL);
INSERT INTO inventario.inv_kardex_movimiento VALUES (25, 'd91442e3-43ea-48af-9d47-d98bb687ab2d', '2026-03', 0, '2026-03-26', '00:00:00', '2026-03-26 00:00:00', 'COMPRAS', '01', 'F001', '00000020', false, NULL, NULL, 'E', '0101', 'Sincronización histórica Compra #21 de la fecha 26/03/2026', 1, NULL, NULL, 10, 'NIU', 1.000000, 1.000000, 2899.000000, 2899.000000, 0.000000, 0.000000, 0.000000, 1.000000, 2899.000000, 2899.000000, 21, 'COMPRAS', NULL, NULL, NULL, 1, NULL, NULL, true, '2026-03-29 18:18:31.339555', '', NULL, NULL);
INSERT INTO inventario.inv_kardex_movimiento VALUES (26, '87970713-afe1-4d12-b128-36cbb2da843f', '2026-03', 0, '2026-03-26', '00:00:00', '2026-03-26 00:00:00', 'COMPRAS', '01', 'F001', '00000025', false, NULL, NULL, 'E', '0101', 'Sincronización histórica Compra #25 de la fecha 26/03/2026', 1, NULL, NULL, 10, 'NIU', 1.000000, 1.000000, 2899.000000, 2899.000000, 0.000000, 0.000000, 0.000000, 1.000000, 2899.000000, 2899.000000, 25, 'COMPRAS', NULL, NULL, NULL, 1, NULL, NULL, true, '2026-03-29 18:18:31.362398', '', NULL, NULL);
INSERT INTO inventario.inv_kardex_movimiento VALUES (27, '8407c042-6874-4f27-883f-e0b991c6f115', '2026-03', 0, '2026-03-26', '00:00:00', '2026-03-26 00:00:00', 'COMPRAS', '01', 'F001', '00000026', false, NULL, NULL, 'E', '0101', 'Sincronización histórica Compra #26 de la fecha 26/03/2026', 1, NULL, NULL, 10, 'NIU', 1.000000, 1.000000, 2899.000000, 2899.000000, 0.000000, 0.000000, 0.000000, 1.000000, 2899.000000, 2899.000000, 26, 'COMPRAS', NULL, NULL, NULL, 1, NULL, NULL, true, '2026-03-29 18:18:31.380654', '', NULL, NULL);
INSERT INTO inventario.inv_kardex_movimiento VALUES (28, 'e370537d-81ae-45d1-ae7e-88c540f67355', '2026-03', 0, '2026-03-26', '00:00:00', '2026-03-26 00:00:00', 'COMPRAS', '01', 'F001', '00000027', false, NULL, NULL, 'E', '0101', 'Sincronización histórica Compra #27 de la fecha 26/03/2026', 1, NULL, NULL, 10, 'NIU', 1.000000, 1.000000, 2899.000000, 2899.000000, 0.000000, 0.000000, 0.000000, 1.000000, 2899.000000, 2899.000000, 27, 'COMPRAS', NULL, NULL, NULL, 1, NULL, NULL, true, '2026-03-29 18:18:31.39801', '', NULL, NULL);
INSERT INTO inventario.inv_kardex_movimiento VALUES (29, '6a25f5a7-e668-4b09-a2c1-28c125a37afd', '2026-03', 0, '2026-03-26', '00:00:00', '2026-03-26 00:00:00', 'COMPRAS', '01', 'F001', '00000028', false, NULL, NULL, 'E', '0101', 'Sincronización histórica Compra #28 de la fecha 26/03/2026', 1, NULL, NULL, 10, 'NIU', 1.000000, 1.000000, 2899.000000, 2899.000000, 0.000000, 0.000000, 0.000000, 1.000000, 2899.000000, 2899.000000, 28, 'COMPRAS', NULL, NULL, NULL, 1, NULL, NULL, true, '2026-03-29 18:18:31.416287', '', NULL, NULL);


--
-- TOC entry 4681 (class 0 OID 66610)
-- Dependencies: 352
-- Data for Name: inv_kardex_periodo_control; Type: TABLE DATA; Schema: inventario; Owner: postgres
--

INSERT INTO inventario.inv_kardex_periodo_control VALUES ('2026-03', 'A', NULL, NULL, '2026-03-26 22:20:12.554795', NULL, NULL, NULL);


--
-- TOC entry 4683 (class 0 OID 66618)
-- Dependencies: 354
-- Data for Name: inv_kardex_recalculo_log; Type: TABLE DATA; Schema: inventario; Owner: postgres
--



--
-- TOC entry 4622 (class 0 OID 46559)
-- Dependencies: 293
-- Data for Name: movimientos_inventario; Type: TABLE DATA; Schema: inventario; Owner: postgres
--

INSERT INTO inventario.movimientos_inventario VALUES (1, 1, 1.000, 0.000, 1.000, 2899.0000, 'COMPRAS', 22, 'Ingreso automático por Compra #22', '2026-03-27 03:29:22.59485', 'SISTEMA', 19, 1.000, 2899.00, 2899.0000, NULL, NULL);
INSERT INTO inventario.movimientos_inventario VALUES (2, 1, 1.000, 1.000, 2.000, 2899.0000, 'COMPRAS', 23, 'Ingreso automático por Compra #23', '2026-03-27 03:58:38.69524', 'SISTEMA', 19, 2.000, 5798.00, 2899.0000, NULL, NULL);
INSERT INTO inventario.movimientos_inventario VALUES (3, 1, 1.000, 2.000, 3.000, 2899.0000, 'COMPRAS', 24, 'Ingreso automático por Compra #24', '2026-03-27 04:11:59.19937', 'SISTEMA', 19, 3.000, 8697.00, 2899.0000, NULL, NULL);
INSERT INTO inventario.movimientos_inventario VALUES (4, 1, 1.000, 3.000, 4.000, 2899.0000, 'COMPRAS', 29, 'Ingreso automático por Compra #29', '2026-03-27 04:30:28.211253', 'SISTEMA', 19, 4.000, 11596.00, 2899.0000, NULL, NULL);
INSERT INTO inventario.movimientos_inventario VALUES (5, 1, 1.000, 4.000, 3.000, 2899.0000, 'VENTAS', 4, 'Salida automática por Venta #4', '2026-03-28 05:59:58.992884', 'SISTEMA', 20, 3.000, 8697.00, 2899.0000, NULL, NULL);
INSERT INTO inventario.movimientos_inventario VALUES (6, 1, 1.000, 3.000, 2.000, 2899.0000, 'VENTAS', 5, 'Salida automática por Venta #5', '2026-03-28 17:08:07.511301', 'SISTEMA', 20, 2.000, 5798.00, 2899.0000, NULL, NULL);
INSERT INTO inventario.movimientos_inventario VALUES (7, 1, 10.000, 2.000, 12.000, 2899.0000, 'COMPRAS', 30, 'Ingreso automático por Compra #30', '2026-03-28 17:36:27.742911', 'SISTEMA', 19, 12.000, 34788.00, 2899.0000, NULL, NULL);
INSERT INTO inventario.movimientos_inventario VALUES (8, 2, 30.000, 0.000, 30.000, 299.9000, 'COMPRAS', 30, 'Ingreso automático por Compra #30', '2026-03-28 17:36:28.152642', 'SISTEMA', 19, 30.000, 8997.00, 299.9000, NULL, NULL);
INSERT INTO inventario.movimientos_inventario VALUES (9, 3, 15.000, 0.000, 15.000, 1899.0000, 'COMPRAS', 30, 'Ingreso automático por Compra #30', '2026-03-28 17:36:28.201134', 'SISTEMA', 19, 15.000, 28485.00, 1899.0000, NULL, NULL);
INSERT INTO inventario.movimientos_inventario VALUES (10, 4, 20.000, 0.000, 20.000, 1850.5000, 'COMPRAS', 30, 'Ingreso automático por Compra #30', '2026-03-28 17:36:28.240013', 'SISTEMA', 19, 20.000, 37010.00, 1850.5000, NULL, NULL);
INSERT INTO inventario.movimientos_inventario VALUES (11, 5, 20.000, 0.000, 20.000, 199.9000, 'COMPRAS', 30, 'Ingreso automático por Compra #30', '2026-03-28 17:36:28.274197', 'SISTEMA', 19, 20.000, 3998.00, 199.9000, NULL, NULL);
INSERT INTO inventario.movimientos_inventario VALUES (12, 2, 1.000, 30.000, 29.000, 299.9000, 'VENTAS', 8, 'Salida automática por Venta #8', '2026-03-29 18:18:02.064925', 'SISTEMA', 20, 29.000, 8697.10, 299.9000, NULL, NULL);
INSERT INTO inventario.movimientos_inventario VALUES (13, 5, 1.000, 20.000, 19.000, 199.9000, 'VENTAS', 8, 'Salida automática por Venta #8', '2026-03-29 18:18:02.556048', 'SISTEMA', 20, 19.000, 3798.10, 199.9000, NULL, NULL);
INSERT INTO inventario.movimientos_inventario VALUES (14, 3, 1.000, 15.000, 14.000, 1899.0000, 'VENTAS', 8, 'Salida automática por Venta #8', '2026-03-29 18:18:02.603751', 'SISTEMA', 20, 14.000, 26586.00, 1899.0000, NULL, NULL);
INSERT INTO inventario.movimientos_inventario VALUES (15, 1, 1.000, 12.000, 11.000, 2899.0000, 'VENTAS', 8, 'Salida automática por Venta #8', '2026-03-29 18:18:02.644686', 'SISTEMA', 20, 11.000, 31889.00, 2899.0000, NULL, NULL);
INSERT INTO inventario.movimientos_inventario VALUES (16, 1, 1.000, 11.000, 12.000, 2899.0000, 'COMPRAS', 12, 'Sincronización histórica Compra #12 de la fecha 26/03/2026', '2026-03-26 00:00:00', 'SISTEMA', 19, 12.000, 34788.00, 2899.0000, NULL, NULL);
INSERT INTO inventario.movimientos_inventario VALUES (17, 1, 1.000, 12.000, 13.000, 2899.0000, 'COMPRAS', 13, 'Sincronización histórica Compra #13 de la fecha 26/03/2026', '2026-03-26 00:00:00', 'SISTEMA', 19, 13.000, 37687.00, 2899.0000, NULL, NULL);
INSERT INTO inventario.movimientos_inventario VALUES (18, 1, 1.000, 13.000, 14.000, 2899.0000, 'COMPRAS', 14, 'Sincronización histórica Compra #14 de la fecha 26/03/2026', '2026-03-26 00:00:00', 'SISTEMA', 19, 14.000, 40586.00, 2899.0000, NULL, NULL);
INSERT INTO inventario.movimientos_inventario VALUES (19, 1, 1.000, 14.000, 15.000, 2899.0000, 'COMPRAS', 15, 'Sincronización histórica Compra #15 de la fecha 26/03/2026', '2026-03-26 00:00:00', 'SISTEMA', 19, 15.000, 43485.00, 2899.0000, NULL, NULL);
INSERT INTO inventario.movimientos_inventario VALUES (20, 1, 1.000, 15.000, 16.000, 2899.0000, 'COMPRAS', 16, 'Sincronización histórica Compra #16 de la fecha 26/03/2026', '2026-03-26 00:00:00', 'SISTEMA', 19, 16.000, 46384.00, 2899.0000, NULL, NULL);
INSERT INTO inventario.movimientos_inventario VALUES (21, 1, 1.000, 16.000, 17.000, 2899.0000, 'COMPRAS', 17, 'Sincronización histórica Compra #17 de la fecha 26/03/2026', '2026-03-26 00:00:00', 'SISTEMA', 19, 17.000, 49283.00, 2899.0000, NULL, NULL);
INSERT INTO inventario.movimientos_inventario VALUES (22, 1, 1.000, 17.000, 18.000, 2899.0000, 'COMPRAS', 18, 'Sincronización histórica Compra #18 de la fecha 26/03/2026', '2026-03-26 00:00:00', 'SISTEMA', 19, 18.000, 52182.00, 2899.0000, NULL, NULL);
INSERT INTO inventario.movimientos_inventario VALUES (23, 1, 1.000, 18.000, 19.000, 2899.0000, 'COMPRAS', 19, 'Sincronización histórica Compra #19 de la fecha 26/03/2026', '2026-03-26 00:00:00', 'SISTEMA', 19, 19.000, 55081.00, 2899.0000, NULL, NULL);
INSERT INTO inventario.movimientos_inventario VALUES (24, 1, 1.000, 19.000, 20.000, 2899.0000, 'COMPRAS', 20, 'Sincronización histórica Compra #20 de la fecha 26/03/2026', '2026-03-26 00:00:00', 'SISTEMA', 19, 20.000, 57980.00, 2899.0000, NULL, NULL);
INSERT INTO inventario.movimientos_inventario VALUES (25, 1, 1.000, 20.000, 21.000, 2899.0000, 'COMPRAS', 21, 'Sincronización histórica Compra #21 de la fecha 26/03/2026', '2026-03-26 00:00:00', 'SISTEMA', 19, 21.000, 60879.00, 2899.0000, NULL, NULL);
INSERT INTO inventario.movimientos_inventario VALUES (26, 1, 1.000, 21.000, 22.000, 2899.0000, 'COMPRAS', 25, 'Sincronización histórica Compra #25 de la fecha 26/03/2026', '2026-03-26 00:00:00', 'SISTEMA', 19, 22.000, 63778.00, 2899.0000, NULL, NULL);
INSERT INTO inventario.movimientos_inventario VALUES (27, 1, 1.000, 22.000, 23.000, 2899.0000, 'COMPRAS', 26, 'Sincronización histórica Compra #26 de la fecha 26/03/2026', '2026-03-26 00:00:00', 'SISTEMA', 19, 23.000, 66677.00, 2899.0000, NULL, NULL);
INSERT INTO inventario.movimientos_inventario VALUES (28, 1, 1.000, 23.000, 24.000, 2899.0000, 'COMPRAS', 27, 'Sincronización histórica Compra #27 de la fecha 26/03/2026', '2026-03-26 00:00:00', 'SISTEMA', 19, 24.000, 69576.00, 2899.0000, NULL, NULL);
INSERT INTO inventario.movimientos_inventario VALUES (29, 1, 1.000, 24.000, 25.000, 2899.0000, 'COMPRAS', 28, 'Sincronización histórica Compra #28 de la fecha 26/03/2026', '2026-03-26 00:00:00', 'SISTEMA', 19, 25.000, 72475.00, 2899.0000, NULL, NULL);


--
-- TOC entry 4624 (class 0 OID 46566)
-- Dependencies: 295
-- Data for Name: stock; Type: TABLE DATA; Schema: inventario; Owner: postgres
--

INSERT INTO inventario.stock VALUES (4, 11, NULL, 1, 20.000, 0.000, NULL, NULL, NULL, 1850.5000, 37010.00, '2026-03-28 12:36:28.249473', 'SYSTEM');
INSERT INTO inventario.stock VALUES (2, 13, NULL, 1, 29.000, 0.000, NULL, NULL, NULL, 299.9000, 8697.10, '2026-03-28 12:36:28.168103', 'SYSTEM');
INSERT INTO inventario.stock VALUES (5, 12, NULL, 1, 19.000, 0.000, NULL, NULL, NULL, 199.9000, 3798.10, '2026-03-28 12:36:28.291932', 'SYSTEM');
INSERT INTO inventario.stock VALUES (3, 7, NULL, 1, 14.000, 0.000, NULL, NULL, NULL, 1899.0000, 26586.00, '2026-03-28 12:36:28.216387', 'SYSTEM');
INSERT INTO inventario.stock VALUES (1, 10, NULL, 1, 25.000, 0.000, NULL, '2026-03-26 22:29:22.896374', NULL, 2899.0000, 72475.00, '2026-03-26 22:29:22.896374', 'SYSTEM');


--
-- TOC entry 4657 (class 0 OID 47568)
-- Dependencies: 328
-- Data for Name: traslados; Type: TABLE DATA; Schema: inventario; Owner: postgres
--



--
-- TOC entry 4659 (class 0 OID 47581)
-- Dependencies: 330
-- Data for Name: traslados_detalle; Type: TABLE DATA; Schema: inventario; Owner: postgres
--



--
-- TOC entry 4661 (class 0 OID 47597)
-- Dependencies: 332
-- Data for Name: traslados_incidencias; Type: TABLE DATA; Schema: inventario; Owner: postgres
--



--
-- TOC entry 4548 (class 0 OID 16755)
-- Dependencies: 219
-- Data for Name: __EFMigrationsHistory; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."__EFMigrationsHistory" VALUES ('20260127221140_Inicial', '8.0.8');
INSERT INTO public."__EFMigrationsHistory" VALUES ('20260127221706_AjusteEsquema', '8.0.8');
INSERT INTO public."__EFMigrationsHistory" VALUES ('20260129221256_AgregarTiposComprobante', '8.0.0');
INSERT INTO public."__EFMigrationsHistory" VALUES ('20260316050725_UpdateSunatFields', '8.0.0');
INSERT INTO public."__EFMigrationsHistory" VALUES ('20260316050735_UpdateSunatFieldsVentas', '8.0.0');
INSERT INTO public."__EFMigrationsHistory" VALUES ('20260316050748_UpdateSunatFieldsCompras', '8.0.0');
INSERT INTO public."__EFMigrationsHistory" VALUES ('20260316143604_FixRelationshipsAndSeedData', '8.0.0');
INSERT INTO public."__EFMigrationsHistory" VALUES ('20260327191956_NormalizarSucursal', '8.0.0');
INSERT INTO public."__EFMigrationsHistory" VALUES ('20260129231053_Inicial', '8.0.8');
INSERT INTO public."__EFMigrationsHistory" VALUES ('20260206190831_FixDetalleAudit', '8.0.8');
INSERT INTO public."__EFMigrationsHistory" VALUES ('20260213160911_AddCompraIdToOrdenCompra', '8.0.8');
INSERT INTO public."__EFMigrationsHistory" VALUES ('20260217183807_UpdateOrdenCompraSerieNumero', '8.0.8');
INSERT INTO public."__EFMigrationsHistory" VALUES ('20260217203920_AddSerieNumeroCorrelativoToOrdenCompra', '8.0.8');
INSERT INTO public."__EFMigrationsHistory" VALUES ('20260219175334_AddObservacionesToCompra', '8.0.8');
INSERT INTO public."__EFMigrationsHistory" VALUES ('20260221132104_AddCamposSunatPle81', '8.0.8');
INSERT INTO public."__EFMigrationsHistory" VALUES ('20260322232250_FixTypoIdCompra', '8.0.8');
INSERT INTO public."__EFMigrationsHistory" VALUES ('20260327231902_AddUbigeoRecursive', '8.0.0');
INSERT INTO public."__EFMigrationsHistory" VALUES ('20260129230722_Inicial', '8.0.8');
INSERT INTO public."__EFMigrationsHistory" VALUES ('20260329205242_AddSunatNotasVentas', '8.0.8');
INSERT INTO public."__EFMigrationsHistory" VALUES ('20260330045214_PluralizarMetodosPago', '8.0.0');
INSERT INTO public."__EFMigrationsHistory" VALUES ('20260330045448_ExcluirMetodosPago', '8.0.8');
INSERT INTO public."__EFMigrationsHistory" VALUES ('20260330143835_SunatUbl', '8.0.8');
INSERT INTO public."__EFMigrationsHistory" VALUES ('20260401144512_RemoveRedundantNotas', '8.0.8');


--
-- TOC entry 4670 (class 0 OID 62619)
-- Dependencies: 341
-- Data for Name: categorias; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4672 (class 0 OID 62632)
-- Dependencies: 343
-- Data for Name: marcas; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4676 (class 0 OID 62648)
-- Dependencies: 347
-- Data for Name: productos; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4674 (class 0 OID 62640)
-- Dependencies: 345
-- Data for Name: unidades_medida; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4707 (class 0 OID 67289)
-- Dependencies: 385
-- Data for Name: cat_estado_cpe; Type: TABLE DATA; Schema: sunat; Owner: postgres
--

INSERT INTO sunat.cat_estado_cpe VALUES ('PENDIENTE', 'Pendiente de envío a SUNAT', false, true, true, '2026-03-30 14:27:17.624767-05', 'sistema', NULL, NULL);
INSERT INTO sunat.cat_estado_cpe VALUES ('ENVIADO', 'Enviado a SUNAT, esperando respuesta (Ticket)', false, false, true, '2026-03-30 14:27:17.624767-05', 'sistema', NULL, NULL);
INSERT INTO sunat.cat_estado_cpe VALUES ('ACEPTADO', 'Aceptado por SUNAT sin observaciones', true, false, true, '2026-03-30 14:27:17.624767-05', 'sistema', NULL, NULL);
INSERT INTO sunat.cat_estado_cpe VALUES ('ACEPTADO_OBS', 'Aceptado por SUNAT con observaciones', true, false, true, '2026-03-30 14:27:17.624767-05', 'sistema', NULL, NULL);
INSERT INTO sunat.cat_estado_cpe VALUES ('RECHAZADO', 'Rechazado por SUNAT (Error concurrente)', true, true, true, '2026-03-30 14:27:17.624767-05', 'sistema', NULL, NULL);
INSERT INTO sunat.cat_estado_cpe VALUES ('ANULADO', 'Comunicación de baja aceptada', true, false, true, '2026-03-30 14:27:17.624767-05', 'sistema', NULL, NULL);
INSERT INTO sunat.cat_estado_cpe VALUES ('ERROR', 'Error interno o de comunicación', false, true, true, '2026-03-30 14:27:17.624767-05', 'sistema', NULL, NULL);


--
-- TOC entry 4709 (class 0 OID 67300)
-- Dependencies: 387
-- Data for Name: log_envio_cpe; Type: TABLE DATA; Schema: sunat; Owner: postgres
--



--
-- TOC entry 4626 (class 0 OID 46573)
-- Dependencies: 297
-- Data for Name: cajas; Type: TABLE DATA; Schema: ventas; Owner: postgres
--



--
-- TOC entry 4628 (class 0 OID 46582)
-- Dependencies: 299
-- Data for Name: cotizaciones; Type: TABLE DATA; Schema: ventas; Owner: postgres
--



--
-- TOC entry 4630 (class 0 OID 46596)
-- Dependencies: 301
-- Data for Name: detalle_cotizacion; Type: TABLE DATA; Schema: ventas; Owner: postgres
--



--
-- TOC entry 4632 (class 0 OID 46602)
-- Dependencies: 303
-- Data for Name: detalle_venta; Type: TABLE DATA; Schema: ventas; Owner: postgres
--

INSERT INTO ventas.detalle_venta VALUES (1, 4, 10, NULL, NULL, 1.000, 2899.00, NULL, 0.00, 0.00, 0.00, NULL, NULL, NULL, 0.0000, NULL, '2026-03-28 00:59:58.585136', 'API_USER', NULL, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO ventas.detalle_venta VALUES (2, 5, 10, NULL, NULL, 1.000, 2899.00, NULL, 0.00, 0.00, 0.00, NULL, NULL, NULL, 0.0000, NULL, '2026-03-28 12:08:07.28099', 'API_USER', NULL, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO ventas.detalle_venta VALUES (7, 8, 13, NULL, NULL, 1.000, 299.90, NULL, 0.00, 0.00, 0.00, NULL, NULL, NULL, 0.0000, NULL, '2026-03-29 13:18:01.775724', 'SISTEMA', NULL, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO ventas.detalle_venta VALUES (8, 8, 12, NULL, NULL, 1.000, 199.90, NULL, 0.00, 0.00, 0.00, NULL, NULL, NULL, 0.0000, NULL, '2026-03-29 13:18:01.775725', 'SISTEMA', NULL, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO ventas.detalle_venta VALUES (9, 8, 7, NULL, NULL, 1.000, 1899.00, NULL, 0.00, 0.00, 0.00, NULL, NULL, NULL, 0.0000, NULL, '2026-03-29 13:18:01.775725', 'SISTEMA', NULL, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO ventas.detalle_venta VALUES (10, 8, 10, NULL, NULL, 1.000, 2899.00, NULL, 0.00, 0.00, 0.00, NULL, NULL, NULL, 0.0000, NULL, '2026-03-29 13:18:01.775726', 'SISTEMA', NULL, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL);


--
-- TOC entry 4634 (class 0 OID 46616)
-- Dependencies: 305
-- Data for Name: movimientos_caja; Type: TABLE DATA; Schema: ventas; Owner: postgres
--



--
-- TOC entry 4698 (class 0 OID 66969)
-- Dependencies: 369
-- Data for Name: nota_credito; Type: TABLE DATA; Schema: ventas; Owner: postgres
--



--
-- TOC entry 4702 (class 0 OID 66995)
-- Dependencies: 373
-- Data for Name: nota_credito_detalle; Type: TABLE DATA; Schema: ventas; Owner: postgres
--



--
-- TOC entry 4700 (class 0 OID 66982)
-- Dependencies: 371
-- Data for Name: nota_debito; Type: TABLE DATA; Schema: ventas; Owner: postgres
--



--
-- TOC entry 4704 (class 0 OID 67013)
-- Dependencies: 375
-- Data for Name: nota_debito_detalle; Type: TABLE DATA; Schema: ventas; Owner: postgres
--



--
-- TOC entry 4636 (class 0 OID 46621)
-- Dependencies: 307
-- Data for Name: pagos; Type: TABLE DATA; Schema: ventas; Owner: postgres
--

INSERT INTO ventas.pagos VALUES (1, 8, 1, 6251.40, NULL, '2026-03-29 13:18:01.411', true, '2026-03-29 13:18:01.775726', 'SISTEMA', NULL, NULL);


--
-- TOC entry 4711 (class 0 OID 67336)
-- Dependencies: 389
-- Data for Name: venta_cuota_pago; Type: TABLE DATA; Schema: ventas; Owner: postgres
--



--
-- TOC entry 4638 (class 0 OID 46628)
-- Dependencies: 309
-- Data for Name: ventas; Type: TABLE DATA; Schema: ventas; Owner: postgres
--

INSERT INTO ventas.ventas VALUES (4, 1, 1, NULL, 5, 1, NULL, 'B001', 1, '2026-03-28 00:59:58.385604', NULL, 'PEN', 1.0000, 2899.00, 0.00, 0.00, 521.82, 0.00, 3420.82, 3420.82, 'Método de pago: Efectivo', true, '2026-03-28 00:59:58.584963', 'API_USER', NULL, NULL, 1, 1, 2, '', NULL, NULL, NULL, NULL, 'Contado', 0.00, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO ventas.ventas VALUES (5, 1, 1, NULL, 5, 1, NULL, 'B001', 2, '2026-03-28 12:08:07.147512', NULL, 'PEN', 1.0000, 2899.00, 0.00, 0.00, 521.82, 0.00, 3420.82, 3420.82, 'Método de pago: Efectivo', true, '2026-03-28 12:08:07.280884', 'API_USER', NULL, NULL, 10, 40, 2, '', NULL, NULL, NULL, NULL, 'Contado', 0.00, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO ventas.ventas VALUES (8, 1, 1, NULL, 5, 1, NULL, 'B001', 5, '2026-03-29 13:18:01.629491', NULL, 'PEN', 1.0000, 5297.80, 0.00, 0.00, 953.60, 0.00, 6251.40, 0.00, 'Método de pago: Efectivo', true, '2026-03-29 13:18:01.775577', 'SISTEMA', NULL, NULL, 29, 47, 2, '', NULL, NULL, NULL, NULL, 'Contado', 0.00, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


--
-- TOC entry 4789 (class 0 OID 0)
-- Dependencies: 221
-- Name: categorias_id_categoria_seq; Type: SEQUENCE SET; Schema: catalogo; Owner: postgres
--

SELECT pg_catalog.setval('catalogo.categorias_id_categoria_seq', 2, true);


--
-- TOC entry 4790 (class 0 OID 0)
-- Dependencies: 223
-- Name: imagenes_producto_id_imagen_seq; Type: SEQUENCE SET; Schema: catalogo; Owner: postgres
--

SELECT pg_catalog.setval('catalogo.imagenes_producto_id_imagen_seq', 1, false);


--
-- TOC entry 4791 (class 0 OID 0)
-- Dependencies: 225
-- Name: listas_precios_id_lista_precio_seq; Type: SEQUENCE SET; Schema: catalogo; Owner: postgres
--

SELECT pg_catalog.setval('catalogo.listas_precios_id_lista_precio_seq', 1, false);


--
-- TOC entry 4792 (class 0 OID 0)
-- Dependencies: 227
-- Name: marcas_id_marca_seq; Type: SEQUENCE SET; Schema: catalogo; Owner: postgres
--

SELECT pg_catalog.setval('catalogo.marcas_id_marca_seq', 3, true);


--
-- TOC entry 4793 (class 0 OID 0)
-- Dependencies: 229
-- Name: productos_id_producto_seq; Type: SEQUENCE SET; Schema: catalogo; Owner: postgres
--

SELECT pg_catalog.setval('catalogo.productos_id_producto_seq', 5, true);


--
-- TOC entry 4794 (class 0 OID 0)
-- Dependencies: 231
-- Name: unidades_medida_id_unidad_seq; Type: SEQUENCE SET; Schema: catalogo; Owner: postgres
--

SELECT pg_catalog.setval('catalogo.unidades_medida_id_unidad_seq', 15, true);


--
-- TOC entry 4795 (class 0 OID 0)
-- Dependencies: 233
-- Name: variantes_producto_id_variante_seq; Type: SEQUENCE SET; Schema: catalogo; Owner: postgres
--

SELECT pg_catalog.setval('catalogo.variantes_producto_id_variante_seq', 1, false);


--
-- TOC entry 4796 (class 0 OID 0)
-- Dependencies: 235
-- Name: clientes_id_cliente_seq; Type: SEQUENCE SET; Schema: clientes; Owner: postgres
--

SELECT pg_catalog.setval('clientes.clientes_id_cliente_seq', 5, true);


--
-- TOC entry 4797 (class 0 OID 0)
-- Dependencies: 237
-- Name: contactos_cliente_id_contacto_seq; Type: SEQUENCE SET; Schema: clientes; Owner: postgres
--

SELECT pg_catalog.setval('clientes.contactos_cliente_id_contacto_seq', 1, false);


--
-- TOC entry 4798 (class 0 OID 0)
-- Dependencies: 239
-- Name: compras_id_compra_seq; Type: SEQUENCE SET; Schema: compras; Owner: postgres
--

SELECT pg_catalog.setval('compras.compras_id_compra_seq', 30, true);


--
-- TOC entry 4799 (class 0 OID 0)
-- Dependencies: 241
-- Name: detalle_compra_id_detalle_compra_seq; Type: SEQUENCE SET; Schema: compras; Owner: postgres
--

SELECT pg_catalog.setval('compras.detalle_compra_id_detalle_compra_seq', 32, true);


--
-- TOC entry 4800 (class 0 OID 0)
-- Dependencies: 243
-- Name: detalle_orden_compra_id_detalle_oc_seq; Type: SEQUENCE SET; Schema: compras; Owner: postgres
--

SELECT pg_catalog.setval('compras.detalle_orden_compra_id_detalle_oc_seq', 1, true);


--
-- TOC entry 4801 (class 0 OID 0)
-- Dependencies: 364
-- Name: nota_credito_detalle_id_detalle_seq; Type: SEQUENCE SET; Schema: compras; Owner: postgres
--

SELECT pg_catalog.setval('compras.nota_credito_detalle_id_detalle_seq', 1, false);


--
-- TOC entry 4802 (class 0 OID 0)
-- Dependencies: 360
-- Name: nota_credito_id_nota_seq; Type: SEQUENCE SET; Schema: compras; Owner: postgres
--

SELECT pg_catalog.setval('compras.nota_credito_id_nota_seq', 1, false);


--
-- TOC entry 4803 (class 0 OID 0)
-- Dependencies: 366
-- Name: nota_debito_detalle_id_detalle_seq; Type: SEQUENCE SET; Schema: compras; Owner: postgres
--

SELECT pg_catalog.setval('compras.nota_debito_detalle_id_detalle_seq', 1, false);


--
-- TOC entry 4804 (class 0 OID 0)
-- Dependencies: 362
-- Name: nota_debito_id_nota_seq; Type: SEQUENCE SET; Schema: compras; Owner: postgres
--

SELECT pg_catalog.setval('compras.nota_debito_id_nota_seq', 1, false);


--
-- TOC entry 4805 (class 0 OID 0)
-- Dependencies: 245
-- Name: ordenes_compra_id_orden_compra_seq; Type: SEQUENCE SET; Schema: compras; Owner: postgres
--

SELECT pg_catalog.setval('compras.ordenes_compra_id_orden_compra_seq', 1, true);


--
-- TOC entry 4806 (class 0 OID 0)
-- Dependencies: 247
-- Name: proveedores_id_proveedor_seq; Type: SEQUENCE SET; Schema: compras; Owner: postgres
--

SELECT pg_catalog.setval('compras.proveedores_id_proveedor_seq', 3, true);


--
-- TOC entry 4807 (class 0 OID 0)
-- Dependencies: 249
-- Name: configuraciones_id_configuracion_seq; Type: SEQUENCE SET; Schema: configuracion; Owner: postgres
--

SELECT pg_catalog.setval('configuracion.configuraciones_id_configuracion_seq', 2, true);


--
-- TOC entry 4808 (class 0 OID 0)
-- Dependencies: 251
-- Name: empresa_id_empresa_seq; Type: SEQUENCE SET; Schema: configuracion; Owner: postgres
--

SELECT pg_catalog.setval('configuracion.empresa_id_empresa_seq', 1, true);


--
-- TOC entry 4809 (class 0 OID 0)
-- Dependencies: 323
-- Name: impuestos_id_impuesto_seq; Type: SEQUENCE SET; Schema: configuracion; Owner: postgres
--

SELECT pg_catalog.setval('configuracion.impuestos_id_impuesto_seq', 4, true);


--
-- TOC entry 4810 (class 0 OID 0)
-- Dependencies: 317
-- Name: matriz_regla_sunat_id_regla_seq; Type: SEQUENCE SET; Schema: configuracion; Owner: postgres
--

SELECT pg_catalog.setval('configuracion.matriz_regla_sunat_id_regla_seq', 6, true);


--
-- TOC entry 4811 (class 0 OID 0)
-- Dependencies: 383
-- Name: metodos_pago_id_metodo_pago_seq; Type: SEQUENCE SET; Schema: configuracion; Owner: postgres
--

SELECT pg_catalog.setval('configuracion.metodos_pago_id_metodo_pago_seq', 4, true);


--
-- TOC entry 4812 (class 0 OID 0)
-- Dependencies: 335
-- Name: motivo_nota_credito_id_motivo_seq; Type: SEQUENCE SET; Schema: configuracion; Owner: postgres
--

SELECT pg_catalog.setval('configuracion.motivo_nota_credito_id_motivo_seq', 13, true);


--
-- TOC entry 4813 (class 0 OID 0)
-- Dependencies: 337
-- Name: motivo_nota_debito_id_motivo_seq; Type: SEQUENCE SET; Schema: configuracion; Owner: postgres
--

SELECT pg_catalog.setval('configuracion.motivo_nota_debito_id_motivo_seq', 6, true);


--
-- TOC entry 4814 (class 0 OID 0)
-- Dependencies: 325
-- Name: parametros_configuracion_id_parametro_seq; Type: SEQUENCE SET; Schema: configuracion; Owner: postgres
--

SELECT pg_catalog.setval('configuracion.parametros_configuracion_id_parametro_seq', 2, true);


--
-- TOC entry 4815 (class 0 OID 0)
-- Dependencies: 319
-- Name: regla_documento_comprobante_id_relacion_seq; Type: SEQUENCE SET; Schema: configuracion; Owner: postgres
--

SELECT pg_catalog.setval('configuracion.regla_documento_comprobante_id_relacion_seq', 26, true);


--
-- TOC entry 4816 (class 0 OID 0)
-- Dependencies: 253
-- Name: series_comprobantes_id_serie_seq; Type: SEQUENCE SET; Schema: configuracion; Owner: postgres
--

SELECT pg_catalog.setval('configuracion.series_comprobantes_id_serie_seq', 5, true);


--
-- TOC entry 4817 (class 0 OID 0)
-- Dependencies: 321
-- Name: sucursales_id_sucursal_seq; Type: SEQUENCE SET; Schema: configuracion; Owner: postgres
--

SELECT pg_catalog.setval('configuracion.sucursales_id_sucursal_seq', 1, true);


--
-- TOC entry 4818 (class 0 OID 0)
-- Dependencies: 256
-- Name: tablas_generales_detalle_id_detalle_seq; Type: SEQUENCE SET; Schema: configuracion; Owner: postgres
--

SELECT pg_catalog.setval('configuracion.tablas_generales_detalle_id_detalle_seq', 50, true);


--
-- TOC entry 4819 (class 0 OID 0)
-- Dependencies: 257
-- Name: tablas_generales_id_tabla_seq; Type: SEQUENCE SET; Schema: configuracion; Owner: postgres
--

SELECT pg_catalog.setval('configuracion.tablas_generales_id_tabla_seq', 13, true);


--
-- TOC entry 4820 (class 0 OID 0)
-- Dependencies: 333
-- Name: tipo_afectacion_igv_id_afectacion_seq; Type: SEQUENCE SET; Schema: configuracion; Owner: postgres
--

SELECT pg_catalog.setval('configuracion.tipo_afectacion_igv_id_afectacion_seq', 19, true);


--
-- TOC entry 4821 (class 0 OID 0)
-- Dependencies: 313
-- Name: tipo_comprobante_id_tipo_comprobante_seq; Type: SEQUENCE SET; Schema: configuracion; Owner: postgres
--

SELECT pg_catalog.setval('configuracion.tipo_comprobante_id_tipo_comprobante_seq', 13, true);


--
-- TOC entry 4822 (class 0 OID 0)
-- Dependencies: 311
-- Name: tipo_documento_id_regla_seq; Type: SEQUENCE SET; Schema: configuracion; Owner: postgres
--

SELECT pg_catalog.setval('configuracion.tipo_documento_id_regla_seq', 18, true);


--
-- TOC entry 4823 (class 0 OID 0)
-- Dependencies: 315
-- Name: tipo_operacion_sunat_id_tipo_operacion_seq; Type: SEQUENCE SET; Schema: configuracion; Owner: postgres
--

SELECT pg_catalog.setval('configuracion.tipo_operacion_sunat_id_tipo_operacion_seq', 10, true);


--
-- TOC entry 4824 (class 0 OID 0)
-- Dependencies: 259
-- Name: asientos_contables_id_asiento_seq; Type: SEQUENCE SET; Schema: contabilidad; Owner: postgres
--

SELECT pg_catalog.setval('contabilidad.asientos_contables_id_asiento_seq', 1, false);


--
-- TOC entry 4825 (class 0 OID 0)
-- Dependencies: 261
-- Name: centros_costo_id_centro_costo_seq; Type: SEQUENCE SET; Schema: contabilidad; Owner: postgres
--

SELECT pg_catalog.setval('contabilidad.centros_costo_id_centro_costo_seq', 1, false);


--
-- TOC entry 4826 (class 0 OID 0)
-- Dependencies: 263
-- Name: detalle_asiento_id_detalle_asiento_seq; Type: SEQUENCE SET; Schema: contabilidad; Owner: postgres
--

SELECT pg_catalog.setval('contabilidad.detalle_asiento_id_detalle_asiento_seq', 1, false);


--
-- TOC entry 4827 (class 0 OID 0)
-- Dependencies: 265
-- Name: plan_cuentas_id_cuenta_seq; Type: SEQUENCE SET; Schema: contabilidad; Owner: postgres
--

SELECT pg_catalog.setval('contabilidad.plan_cuentas_id_cuenta_seq', 1, false);


--
-- TOC entry 4828 (class 0 OID 0)
-- Dependencies: 267
-- Name: areas_id_area_seq; Type: SEQUENCE SET; Schema: identidad; Owner: postgres
--

SELECT pg_catalog.setval('identidad.areas_id_area_seq', 1, false);


--
-- TOC entry 4829 (class 0 OID 0)
-- Dependencies: 269
-- Name: auditoria_accesos_id_auditoria_seq; Type: SEQUENCE SET; Schema: identidad; Owner: postgres
--

SELECT pg_catalog.setval('identidad.auditoria_accesos_id_auditoria_seq', 1, false);


--
-- TOC entry 4830 (class 0 OID 0)
-- Dependencies: 271
-- Name: cargos_id_cargo_seq; Type: SEQUENCE SET; Schema: identidad; Owner: postgres
--

SELECT pg_catalog.setval('identidad.cargos_id_cargo_seq', 1, false);


--
-- TOC entry 4831 (class 0 OID 0)
-- Dependencies: 273
-- Name: menus_id_menu_seq; Type: SEQUENCE SET; Schema: identidad; Owner: postgres
--

SELECT pg_catalog.setval('identidad.menus_id_menu_seq', 27, true);


--
-- TOC entry 4832 (class 0 OID 0)
-- Dependencies: 275
-- Name: permisos_id_permiso_seq; Type: SEQUENCE SET; Schema: identidad; Owner: postgres
--

SELECT pg_catalog.setval('identidad.permisos_id_permiso_seq', 1, false);


--
-- TOC entry 4833 (class 0 OID 0)
-- Dependencies: 277
-- Name: roles_id_rol_seq; Type: SEQUENCE SET; Schema: identidad; Owner: postgres
--

SELECT pg_catalog.setval('identidad.roles_id_rol_seq', 4, true);


--
-- TOC entry 4834 (class 0 OID 0)
-- Dependencies: 279
-- Name: roles_menus_id_rol_menu_seq; Type: SEQUENCE SET; Schema: identidad; Owner: postgres
--

SELECT pg_catalog.setval('identidad.roles_menus_id_rol_menu_seq', 1, false);


--
-- TOC entry 4835 (class 0 OID 0)
-- Dependencies: 281
-- Name: roles_menus_permisos_id_rol_menu_permiso_seq; Type: SEQUENCE SET; Schema: identidad; Owner: postgres
--

SELECT pg_catalog.setval('identidad.roles_menus_permisos_id_rol_menu_permiso_seq', 1, false);


--
-- TOC entry 4836 (class 0 OID 0)
-- Dependencies: 284
-- Name: tipos_permiso_id_tipo_permiso_seq; Type: SEQUENCE SET; Schema: identidad; Owner: postgres
--

SELECT pg_catalog.setval('identidad.tipos_permiso_id_tipo_permiso_seq', 9, true);


--
-- TOC entry 4837 (class 0 OID 0)
-- Dependencies: 286
-- Name: trabajadores_id_trabajador_seq; Type: SEQUENCE SET; Schema: identidad; Owner: postgres
--

SELECT pg_catalog.setval('identidad.trabajadores_id_trabajador_seq', 1, false);


--
-- TOC entry 4838 (class 0 OID 0)
-- Dependencies: 288
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE SET; Schema: identidad; Owner: postgres
--

SELECT pg_catalog.setval('identidad.usuarios_id_usuario_seq', 1, true);


--
-- TOC entry 4839 (class 0 OID 0)
-- Dependencies: 290
-- Name: usuarios_roles_id_usuario_rol_seq; Type: SEQUENCE SET; Schema: identidad; Owner: postgres
--

SELECT pg_catalog.setval('identidad.usuarios_roles_id_usuario_rol_seq', 1, false);


--
-- TOC entry 4840 (class 0 OID 0)
-- Dependencies: 292
-- Name: almacenes_id_almacen_seq; Type: SEQUENCE SET; Schema: inventario; Owner: postgres
--

SELECT pg_catalog.setval('inventario.almacenes_id_almacen_seq', 1, true);


--
-- TOC entry 4841 (class 0 OID 0)
-- Dependencies: 348
-- Name: inv_kardex_lote_id_seq; Type: SEQUENCE SET; Schema: inventario; Owner: postgres
--

SELECT pg_catalog.setval('inventario.inv_kardex_lote_id_seq', 1, false);


--
-- TOC entry 4842 (class 0 OID 0)
-- Dependencies: 350
-- Name: inv_kardex_movimiento_id_seq; Type: SEQUENCE SET; Schema: inventario; Owner: postgres
--

SELECT pg_catalog.setval('inventario.inv_kardex_movimiento_id_seq', 29, true);


--
-- TOC entry 4843 (class 0 OID 0)
-- Dependencies: 353
-- Name: inv_kardex_recalculo_log_id_seq; Type: SEQUENCE SET; Schema: inventario; Owner: postgres
--

SELECT pg_catalog.setval('inventario.inv_kardex_recalculo_log_id_seq', 1, false);


--
-- TOC entry 4844 (class 0 OID 0)
-- Dependencies: 294
-- Name: movimientos_inventario_id_movimiento_seq; Type: SEQUENCE SET; Schema: inventario; Owner: postgres
--

SELECT pg_catalog.setval('inventario.movimientos_inventario_id_movimiento_seq', 29, true);


--
-- TOC entry 4845 (class 0 OID 0)
-- Dependencies: 296
-- Name: stock_id_stock_seq; Type: SEQUENCE SET; Schema: inventario; Owner: postgres
--

SELECT pg_catalog.setval('inventario.stock_id_stock_seq', 5, true);


--
-- TOC entry 4846 (class 0 OID 0)
-- Dependencies: 329
-- Name: traslados_detalle_id_detalle_traslado_seq; Type: SEQUENCE SET; Schema: inventario; Owner: postgres
--

SELECT pg_catalog.setval('inventario.traslados_detalle_id_detalle_traslado_seq', 1, false);


--
-- TOC entry 4847 (class 0 OID 0)
-- Dependencies: 327
-- Name: traslados_id_traslado_seq; Type: SEQUENCE SET; Schema: inventario; Owner: postgres
--

SELECT pg_catalog.setval('inventario.traslados_id_traslado_seq', 1, false);


--
-- TOC entry 4848 (class 0 OID 0)
-- Dependencies: 331
-- Name: traslados_incidencias_id_incidencia_seq; Type: SEQUENCE SET; Schema: inventario; Owner: postgres
--

SELECT pg_catalog.setval('inventario.traslados_incidencias_id_incidencia_seq', 1, false);


--
-- TOC entry 4849 (class 0 OID 0)
-- Dependencies: 340
-- Name: categorias_Id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."categorias_Id_seq"', 1, false);


--
-- TOC entry 4850 (class 0 OID 0)
-- Dependencies: 342
-- Name: marcas_Id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."marcas_Id_seq"', 1, false);


--
-- TOC entry 4851 (class 0 OID 0)
-- Dependencies: 346
-- Name: productos_Id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."productos_Id_seq"', 1, false);


--
-- TOC entry 4852 (class 0 OID 0)
-- Dependencies: 344
-- Name: unidades_medida_Id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."unidades_medida_Id_seq"', 1, false);


--
-- TOC entry 4853 (class 0 OID 0)
-- Dependencies: 386
-- Name: log_envio_cpe_id_log_seq; Type: SEQUENCE SET; Schema: sunat; Owner: postgres
--

SELECT pg_catalog.setval('sunat.log_envio_cpe_id_log_seq', 1, false);


--
-- TOC entry 4854 (class 0 OID 0)
-- Dependencies: 298
-- Name: cajas_id_caja_seq; Type: SEQUENCE SET; Schema: ventas; Owner: postgres
--

SELECT pg_catalog.setval('ventas.cajas_id_caja_seq', 1, false);


--
-- TOC entry 4855 (class 0 OID 0)
-- Dependencies: 300
-- Name: cotizaciones_id_cotizacion_seq; Type: SEQUENCE SET; Schema: ventas; Owner: postgres
--

SELECT pg_catalog.setval('ventas.cotizaciones_id_cotizacion_seq', 1, false);


--
-- TOC entry 4856 (class 0 OID 0)
-- Dependencies: 302
-- Name: detalle_cotizacion_id_detalle_cot_seq; Type: SEQUENCE SET; Schema: ventas; Owner: postgres
--

SELECT pg_catalog.setval('ventas.detalle_cotizacion_id_detalle_cot_seq', 1, false);


--
-- TOC entry 4857 (class 0 OID 0)
-- Dependencies: 304
-- Name: detalle_venta_id_detalle_venta_seq; Type: SEQUENCE SET; Schema: ventas; Owner: postgres
--

SELECT pg_catalog.setval('ventas.detalle_venta_id_detalle_venta_seq', 10, true);


--
-- TOC entry 4858 (class 0 OID 0)
-- Dependencies: 306
-- Name: movimientos_caja_id_movimiento_caja_seq; Type: SEQUENCE SET; Schema: ventas; Owner: postgres
--

SELECT pg_catalog.setval('ventas.movimientos_caja_id_movimiento_caja_seq', 1, false);


--
-- TOC entry 4859 (class 0 OID 0)
-- Dependencies: 372
-- Name: nota_credito_detalle_id_detalle_seq; Type: SEQUENCE SET; Schema: ventas; Owner: postgres
--

SELECT pg_catalog.setval('ventas.nota_credito_detalle_id_detalle_seq', 1, false);


--
-- TOC entry 4860 (class 0 OID 0)
-- Dependencies: 368
-- Name: nota_credito_id_nota_seq; Type: SEQUENCE SET; Schema: ventas; Owner: postgres
--

SELECT pg_catalog.setval('ventas.nota_credito_id_nota_seq', 1, false);


--
-- TOC entry 4861 (class 0 OID 0)
-- Dependencies: 374
-- Name: nota_debito_detalle_id_detalle_seq; Type: SEQUENCE SET; Schema: ventas; Owner: postgres
--

SELECT pg_catalog.setval('ventas.nota_debito_detalle_id_detalle_seq', 1, false);


--
-- TOC entry 4862 (class 0 OID 0)
-- Dependencies: 370
-- Name: nota_debito_id_nota_seq; Type: SEQUENCE SET; Schema: ventas; Owner: postgres
--

SELECT pg_catalog.setval('ventas.nota_debito_id_nota_seq', 1, false);


--
-- TOC entry 4863 (class 0 OID 0)
-- Dependencies: 308
-- Name: pagos_id_pago_seq; Type: SEQUENCE SET; Schema: ventas; Owner: postgres
--

SELECT pg_catalog.setval('ventas.pagos_id_pago_seq', 1, true);


--
-- TOC entry 4864 (class 0 OID 0)
-- Dependencies: 388
-- Name: venta_cuota_pago_id_cuota_seq; Type: SEQUENCE SET; Schema: ventas; Owner: postgres
--

SELECT pg_catalog.setval('ventas.venta_cuota_pago_id_cuota_seq', 1, false);


--
-- TOC entry 4865 (class 0 OID 0)
-- Dependencies: 310
-- Name: ventas_id_venta_seq; Type: SEQUENCE SET; Schema: ventas; Owner: postgres
--

SELECT pg_catalog.setval('ventas.ventas_id_venta_seq', 8, true);


--
-- TOC entry 4003 (class 2606 OID 46693)
-- Name: categorias categorias_pkey; Type: CONSTRAINT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.categorias
    ADD CONSTRAINT categorias_pkey PRIMARY KEY (id_categoria);


--
-- TOC entry 4005 (class 2606 OID 46695)
-- Name: imagenes_producto imagenes_producto_pkey; Type: CONSTRAINT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.imagenes_producto
    ADD CONSTRAINT imagenes_producto_pkey PRIMARY KEY (id_imagen);


--
-- TOC entry 4007 (class 2606 OID 46697)
-- Name: listas_precios listas_precios_pkey; Type: CONSTRAINT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.listas_precios
    ADD CONSTRAINT listas_precios_pkey PRIMARY KEY (id_lista_precio);


--
-- TOC entry 4009 (class 2606 OID 46699)
-- Name: marcas marcas_pkey; Type: CONSTRAINT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.marcas
    ADD CONSTRAINT marcas_pkey PRIMARY KEY (id_marca);


--
-- TOC entry 4201 (class 2606 OID 62617)
-- Name: __ef_migrations pk___ef_migrations; Type: CONSTRAINT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.__ef_migrations
    ADD CONSTRAINT pk___ef_migrations PRIMARY KEY (migration_id);


--
-- TOC entry 4011 (class 2606 OID 46701)
-- Name: productos productos_codigo_producto_key; Type: CONSTRAINT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.productos
    ADD CONSTRAINT productos_codigo_producto_key UNIQUE (codigo_producto);


--
-- TOC entry 4013 (class 2606 OID 46703)
-- Name: productos productos_pkey; Type: CONSTRAINT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.productos
    ADD CONSTRAINT productos_pkey PRIMARY KEY (id_producto);


--
-- TOC entry 4015 (class 2606 OID 46705)
-- Name: productos productos_sku_key; Type: CONSTRAINT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.productos
    ADD CONSTRAINT productos_sku_key UNIQUE (sku);


--
-- TOC entry 4017 (class 2606 OID 46707)
-- Name: unidades_medida unidades_medida_pkey; Type: CONSTRAINT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.unidades_medida
    ADD CONSTRAINT unidades_medida_pkey PRIMARY KEY (id_unidad);


--
-- TOC entry 4019 (class 2606 OID 46709)
-- Name: variantes_producto variantes_producto_pkey; Type: CONSTRAINT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.variantes_producto
    ADD CONSTRAINT variantes_producto_pkey PRIMARY KEY (id_variante);


--
-- TOC entry 4021 (class 2606 OID 46711)
-- Name: variantes_producto variantes_producto_sku_variante_key; Type: CONSTRAINT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.variantes_producto
    ADD CONSTRAINT variantes_producto_sku_variante_key UNIQUE (sku_variante);


--
-- TOC entry 4228 (class 2606 OID 66658)
-- Name: __EFMigrationsHistory PK___EFMigrationsHistory; Type: CONSTRAINT; Schema: clientes; Owner: postgres
--

ALTER TABLE ONLY clientes."__EFMigrationsHistory"
    ADD CONSTRAINT "PK___EFMigrationsHistory" PRIMARY KEY ("MigrationId");


--
-- TOC entry 4234 (class 2606 OID 66800)
-- Name: __ef_migrations_history __ef_migrations_history_pkey; Type: CONSTRAINT; Schema: clientes; Owner: postgres
--

ALTER TABLE ONLY clientes.__ef_migrations_history
    ADD CONSTRAINT __ef_migrations_history_pkey PRIMARY KEY (migration_id);


--
-- TOC entry 4023 (class 2606 OID 46713)
-- Name: clientes clientes_numero_documento_key; Type: CONSTRAINT; Schema: clientes; Owner: postgres
--

ALTER TABLE ONLY clientes.clientes
    ADD CONSTRAINT clientes_numero_documento_key UNIQUE (numero_documento);


--
-- TOC entry 4025 (class 2606 OID 46715)
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: clientes; Owner: postgres
--

ALTER TABLE ONLY clientes.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (id_cliente);


--
-- TOC entry 4029 (class 2606 OID 46717)
-- Name: contactos_cliente contactos_cliente_pkey; Type: CONSTRAINT; Schema: clientes; Owner: postgres
--

ALTER TABLE ONLY clientes.contactos_cliente
    ADD CONSTRAINT contactos_cliente_pkey PRIMARY KEY (id_contacto);


--
-- TOC entry 4232 (class 2606 OID 66795)
-- Name: __ef_migrations_history __ef_migrations_history_pkey; Type: CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.__ef_migrations_history
    ADD CONSTRAINT __ef_migrations_history_pkey PRIMARY KEY (migration_id);


--
-- TOC entry 4031 (class 2606 OID 46719)
-- Name: compras compras_pkey; Type: CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.compras
    ADD CONSTRAINT compras_pkey PRIMARY KEY (id_compra);


--
-- TOC entry 4033 (class 2606 OID 46721)
-- Name: detalle_compra detalle_compra_pkey; Type: CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.detalle_compra
    ADD CONSTRAINT detalle_compra_pkey PRIMARY KEY (id_detalle_compra);


--
-- TOC entry 4035 (class 2606 OID 46723)
-- Name: detalle_orden_compra detalle_orden_compra_pkey; Type: CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.detalle_orden_compra
    ADD CONSTRAINT detalle_orden_compra_pkey PRIMARY KEY (id_detalle_oc);


--
-- TOC entry 4037 (class 2606 OID 46725)
-- Name: ordenes_compra ordenes_compra_codigo_orden_key; Type: CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.ordenes_compra
    ADD CONSTRAINT ordenes_compra_codigo_orden_key UNIQUE (codigo_orden);


--
-- TOC entry 4039 (class 2606 OID 46727)
-- Name: ordenes_compra ordenes_compra_pkey; Type: CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.ordenes_compra
    ADD CONSTRAINT ordenes_compra_pkey PRIMARY KEY (id_orden_compra);


--
-- TOC entry 4230 (class 2606 OID 66766)
-- Name: ef_migrations_history pk_ef_migrations_history; Type: CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.ef_migrations_history
    ADD CONSTRAINT pk_ef_migrations_history PRIMARY KEY (migration_id);


--
-- TOC entry 4241 (class 2606 OID 66890)
-- Name: nota_credito pk_nota_credito; Type: CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.nota_credito
    ADD CONSTRAINT pk_nota_credito PRIMARY KEY (id_nota);


--
-- TOC entry 4249 (class 2606 OID 66926)
-- Name: nota_credito_detalle pk_nota_credito_detalle; Type: CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.nota_credito_detalle
    ADD CONSTRAINT pk_nota_credito_detalle PRIMARY KEY (id_detalle);


--
-- TOC entry 4245 (class 2606 OID 66908)
-- Name: nota_debito pk_nota_debito; Type: CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.nota_debito
    ADD CONSTRAINT pk_nota_debito PRIMARY KEY (id_nota);


--
-- TOC entry 4253 (class 2606 OID 66944)
-- Name: nota_debito_detalle pk_nota_debito_detalle; Type: CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.nota_debito_detalle
    ADD CONSTRAINT pk_nota_debito_detalle PRIMARY KEY (id_detalle);


--
-- TOC entry 4042 (class 2606 OID 46729)
-- Name: proveedores proveedores_numero_documento_key; Type: CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.proveedores
    ADD CONSTRAINT proveedores_numero_documento_key UNIQUE (numero_documento);


--
-- TOC entry 4044 (class 2606 OID 46731)
-- Name: proveedores proveedores_pkey; Type: CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.proveedores
    ADD CONSTRAINT proveedores_pkey PRIMARY KEY (id_proveedor);


--
-- TOC entry 4047 (class 2606 OID 46733)
-- Name: configuraciones configuraciones_clave_key; Type: CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.configuraciones
    ADD CONSTRAINT configuraciones_clave_key UNIQUE (clave);


--
-- TOC entry 4049 (class 2606 OID 46735)
-- Name: configuraciones configuraciones_pkey; Type: CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.configuraciones
    ADD CONSTRAINT configuraciones_pkey PRIMARY KEY (id_configuracion);


--
-- TOC entry 4051 (class 2606 OID 46737)
-- Name: empresa empresa_pkey; Type: CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.empresa
    ADD CONSTRAINT empresa_pkey PRIMARY KEY (id_empresa);


--
-- TOC entry 4053 (class 2606 OID 46739)
-- Name: empresa empresa_ruc_key; Type: CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.empresa
    ADD CONSTRAINT empresa_ruc_key UNIQUE (ruc);


--
-- TOC entry 4169 (class 2606 OID 47251)
-- Name: matriz_regla_sunat matriz_regla_sunat_pkey; Type: CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.matriz_regla_sunat
    ADD CONSTRAINT matriz_regla_sunat_pkey PRIMARY KEY (id_regla);


--
-- TOC entry 4193 (class 2606 OID 47721)
-- Name: motivo_nota_credito motivo_nota_credito_codigo_key; Type: CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.motivo_nota_credito
    ADD CONSTRAINT motivo_nota_credito_codigo_key UNIQUE (codigo);


--
-- TOC entry 4195 (class 2606 OID 47719)
-- Name: motivo_nota_credito motivo_nota_credito_pkey; Type: CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.motivo_nota_credito
    ADD CONSTRAINT motivo_nota_credito_pkey PRIMARY KEY (id_motivo);


--
-- TOC entry 4197 (class 2606 OID 47733)
-- Name: motivo_nota_debito motivo_nota_debito_codigo_key; Type: CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.motivo_nota_debito
    ADD CONSTRAINT motivo_nota_debito_codigo_key UNIQUE (codigo);


--
-- TOC entry 4199 (class 2606 OID 47731)
-- Name: motivo_nota_debito motivo_nota_debito_pkey; Type: CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.motivo_nota_debito
    ADD CONSTRAINT motivo_nota_debito_pkey PRIMARY KEY (id_motivo);


--
-- TOC entry 4177 (class 2606 OID 47357)
-- Name: parametros_configuracion parametros_configuracion_codigo_key; Type: CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.parametros_configuracion
    ADD CONSTRAINT parametros_configuracion_codigo_key UNIQUE (codigo);


--
-- TOC entry 4179 (class 2606 OID 47355)
-- Name: parametros_configuracion parametros_configuracion_pkey; Type: CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.parametros_configuracion
    ADD CONSTRAINT parametros_configuracion_pkey PRIMARY KEY (id_parametro);


--
-- TOC entry 4175 (class 2606 OID 66634)
-- Name: impuestos pk_impuestos; Type: CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.impuestos
    ADD CONSTRAINT pk_impuestos PRIMARY KEY (id_impuesto);


--
-- TOC entry 4269 (class 2606 OID 67078)
-- Name: metodos_pago pk_metodos_pago; Type: CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.metodos_pago
    ADD CONSTRAINT pk_metodos_pago PRIMARY KEY (id_metodo_pago);


--
-- TOC entry 4173 (class 2606 OID 66632)
-- Name: sucursales pk_sucursales; Type: CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.sucursales
    ADD CONSTRAINT pk_sucursales PRIMARY KEY (id_sucursal);


--
-- TOC entry 4237 (class 2606 OID 66871)
-- Name: ubigeos pk_ubigeos; Type: CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.ubigeos
    ADD CONSTRAINT pk_ubigeos PRIMARY KEY (codigo);


--
-- TOC entry 4171 (class 2606 OID 47260)
-- Name: regla_documento_comprobante regla_documento_comprobante_pkey; Type: CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.regla_documento_comprobante
    ADD CONSTRAINT regla_documento_comprobante_pkey PRIMARY KEY (id_relacion);


--
-- TOC entry 4055 (class 2606 OID 46741)
-- Name: series_comprobantes series_comprobantes_pkey; Type: CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.series_comprobantes
    ADD CONSTRAINT series_comprobantes_pkey PRIMARY KEY (id_serie);


--
-- TOC entry 4058 (class 2606 OID 46743)
-- Name: tablas_generales tablas_generales_codigo_key; Type: CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.tablas_generales
    ADD CONSTRAINT tablas_generales_codigo_key UNIQUE (codigo);


--
-- TOC entry 4064 (class 2606 OID 46745)
-- Name: tablas_generales_detalle tablas_generales_detalle_pkey; Type: CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.tablas_generales_detalle
    ADD CONSTRAINT tablas_generales_detalle_pkey PRIMARY KEY (id_detalle);


--
-- TOC entry 4060 (class 2606 OID 46747)
-- Name: tablas_generales tablas_generales_pkey; Type: CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.tablas_generales
    ADD CONSTRAINT tablas_generales_pkey PRIMARY KEY (id_tabla);


--
-- TOC entry 4189 (class 2606 OID 47706)
-- Name: tipo_afectacion_igv tipo_afectacion_igv_codigo_key; Type: CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.tipo_afectacion_igv
    ADD CONSTRAINT tipo_afectacion_igv_codigo_key UNIQUE (codigo);


--
-- TOC entry 4191 (class 2606 OID 47704)
-- Name: tipo_afectacion_igv tipo_afectacion_igv_pkey; Type: CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.tipo_afectacion_igv
    ADD CONSTRAINT tipo_afectacion_igv_pkey PRIMARY KEY (id_afectacion);


--
-- TOC entry 4161 (class 2606 OID 47226)
-- Name: tipo_comprobante tipo_comprobante_codigo_key; Type: CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.tipo_comprobante
    ADD CONSTRAINT tipo_comprobante_codigo_key UNIQUE (codigo);


--
-- TOC entry 4163 (class 2606 OID 47224)
-- Name: tipo_comprobante tipo_comprobante_pkey; Type: CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.tipo_comprobante
    ADD CONSTRAINT tipo_comprobante_pkey PRIMARY KEY (id_tipo_comprobante);


--
-- TOC entry 4157 (class 2606 OID 47210)
-- Name: tipo_documento tipo_documento_codigo_key; Type: CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.tipo_documento
    ADD CONSTRAINT tipo_documento_codigo_key UNIQUE (codigo);


--
-- TOC entry 4159 (class 2606 OID 47208)
-- Name: tipo_documento tipo_documento_pkey; Type: CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.tipo_documento
    ADD CONSTRAINT tipo_documento_pkey PRIMARY KEY (id_regla);


--
-- TOC entry 4165 (class 2606 OID 47239)
-- Name: tipo_operacion_sunat tipo_operacion_sunat_codigo_key; Type: CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.tipo_operacion_sunat
    ADD CONSTRAINT tipo_operacion_sunat_codigo_key UNIQUE (codigo);


--
-- TOC entry 4167 (class 2606 OID 47237)
-- Name: tipo_operacion_sunat tipo_operacion_sunat_pkey; Type: CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.tipo_operacion_sunat
    ADD CONSTRAINT tipo_operacion_sunat_pkey PRIMARY KEY (id_tipo_operacion);


--
-- TOC entry 4066 (class 2606 OID 46749)
-- Name: tablas_generales_detalle uk_tabla_codigo; Type: CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.tablas_generales_detalle
    ADD CONSTRAINT uk_tabla_codigo UNIQUE (id_tabla, codigo);


--
-- TOC entry 4068 (class 2606 OID 46751)
-- Name: asientos_contables asientos_contables_pkey; Type: CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.asientos_contables
    ADD CONSTRAINT asientos_contables_pkey PRIMARY KEY (id_asiento);


--
-- TOC entry 4070 (class 2606 OID 46753)
-- Name: centros_costo centros_costo_codigo_key; Type: CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.centros_costo
    ADD CONSTRAINT centros_costo_codigo_key UNIQUE (codigo);


--
-- TOC entry 4072 (class 2606 OID 46755)
-- Name: centros_costo centros_costo_pkey; Type: CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.centros_costo
    ADD CONSTRAINT centros_costo_pkey PRIMARY KEY (id_centro_costo);


--
-- TOC entry 4074 (class 2606 OID 46757)
-- Name: detalle_asiento detalle_asiento_pkey; Type: CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.detalle_asiento
    ADD CONSTRAINT detalle_asiento_pkey PRIMARY KEY (id_detalle_asiento);


--
-- TOC entry 4076 (class 2606 OID 46759)
-- Name: plan_cuentas plan_cuentas_codigo_cuenta_key; Type: CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.plan_cuentas
    ADD CONSTRAINT plan_cuentas_codigo_cuenta_key UNIQUE (codigo_cuenta);


--
-- TOC entry 4078 (class 2606 OID 46761)
-- Name: plan_cuentas plan_cuentas_pkey; Type: CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.plan_cuentas
    ADD CONSTRAINT plan_cuentas_pkey PRIMARY KEY (id_cuenta);


--
-- TOC entry 4080 (class 2606 OID 46763)
-- Name: areas areas_pkey; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.areas
    ADD CONSTRAINT areas_pkey PRIMARY KEY (id_area);


--
-- TOC entry 4082 (class 2606 OID 46765)
-- Name: auditoria_accesos auditoria_accesos_pkey; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.auditoria_accesos
    ADD CONSTRAINT auditoria_accesos_pkey PRIMARY KEY (id_auditoria);


--
-- TOC entry 4084 (class 2606 OID 46767)
-- Name: cargos cargos_pkey; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.cargos
    ADD CONSTRAINT cargos_pkey PRIMARY KEY (id_cargo);


--
-- TOC entry 4088 (class 2606 OID 46769)
-- Name: menus menus_codigo_key; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.menus
    ADD CONSTRAINT menus_codigo_key UNIQUE (codigo);


--
-- TOC entry 4090 (class 2606 OID 46771)
-- Name: menus menus_pkey; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.menus
    ADD CONSTRAINT menus_pkey PRIMARY KEY (id_menu);


--
-- TOC entry 4092 (class 2606 OID 46773)
-- Name: permisos permisos_codigo_permiso_key; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.permisos
    ADD CONSTRAINT permisos_codigo_permiso_key UNIQUE (codigo_permiso);


--
-- TOC entry 4094 (class 2606 OID 46775)
-- Name: permisos permisos_pkey; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.permisos
    ADD CONSTRAINT permisos_pkey PRIMARY KEY (id_permiso);


--
-- TOC entry 4102 (class 2606 OID 46777)
-- Name: roles_menus roles_menus_id_rol_id_menu_key; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.roles_menus
    ADD CONSTRAINT roles_menus_id_rol_id_menu_key UNIQUE (id_rol, id_menu);


--
-- TOC entry 4106 (class 2606 OID 46779)
-- Name: roles_menus_permisos roles_menus_permisos_id_rol_menu_id_tipo_permiso_key; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.roles_menus_permisos
    ADD CONSTRAINT roles_menus_permisos_id_rol_menu_id_tipo_permiso_key UNIQUE (id_rol_menu, id_tipo_permiso);


--
-- TOC entry 4108 (class 2606 OID 46781)
-- Name: roles_menus_permisos roles_menus_permisos_pkey; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.roles_menus_permisos
    ADD CONSTRAINT roles_menus_permisos_pkey PRIMARY KEY (id_rol_menu_permiso);


--
-- TOC entry 4104 (class 2606 OID 46783)
-- Name: roles_menus roles_menus_pkey; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.roles_menus
    ADD CONSTRAINT roles_menus_pkey PRIMARY KEY (id_rol_menu);


--
-- TOC entry 4096 (class 2606 OID 46785)
-- Name: roles roles_nombre_rol_key; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.roles
    ADD CONSTRAINT roles_nombre_rol_key UNIQUE (nombre_rol);


--
-- TOC entry 4110 (class 2606 OID 46787)
-- Name: roles_permisos roles_permisos_pkey; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.roles_permisos
    ADD CONSTRAINT roles_permisos_pkey PRIMARY KEY (id_rol, id_permiso);


--
-- TOC entry 4098 (class 2606 OID 46789)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id_rol);


--
-- TOC entry 4113 (class 2606 OID 46791)
-- Name: tipos_permiso tipos_permiso_codigo_key; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.tipos_permiso
    ADD CONSTRAINT tipos_permiso_codigo_key UNIQUE (codigo);


--
-- TOC entry 4115 (class 2606 OID 46793)
-- Name: tipos_permiso tipos_permiso_pkey; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.tipos_permiso
    ADD CONSTRAINT tipos_permiso_pkey PRIMARY KEY (id_tipo_permiso);


--
-- TOC entry 4117 (class 2606 OID 46795)
-- Name: trabajadores trabajadores_id_usuario_key; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.trabajadores
    ADD CONSTRAINT trabajadores_id_usuario_key UNIQUE (id_usuario);


--
-- TOC entry 4119 (class 2606 OID 46797)
-- Name: trabajadores trabajadores_numero_documento_key; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.trabajadores
    ADD CONSTRAINT trabajadores_numero_documento_key UNIQUE (numero_documento);


--
-- TOC entry 4121 (class 2606 OID 46799)
-- Name: trabajadores trabajadores_pkey; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.trabajadores
    ADD CONSTRAINT trabajadores_pkey PRIMARY KEY (id_trabajador);


--
-- TOC entry 4123 (class 2606 OID 46801)
-- Name: usuarios usuarios_email_key; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.usuarios
    ADD CONSTRAINT usuarios_email_key UNIQUE (email);


--
-- TOC entry 4125 (class 2606 OID 46803)
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id_usuario);


--
-- TOC entry 4131 (class 2606 OID 46805)
-- Name: usuarios_roles usuarios_roles_id_usuario_id_rol_key; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.usuarios_roles
    ADD CONSTRAINT usuarios_roles_id_usuario_id_rol_key UNIQUE (id_usuario, id_rol);


--
-- TOC entry 4133 (class 2606 OID 46807)
-- Name: usuarios_roles usuarios_roles_pkey; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.usuarios_roles
    ADD CONSTRAINT usuarios_roles_pkey PRIMARY KEY (id_usuario_rol);


--
-- TOC entry 4127 (class 2606 OID 46809)
-- Name: usuarios usuarios_username_key; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.usuarios
    ADD CONSTRAINT usuarios_username_key UNIQUE (username);


--
-- TOC entry 4135 (class 2606 OID 46811)
-- Name: almacenes almacenes_pkey; Type: CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.almacenes
    ADD CONSTRAINT almacenes_pkey PRIMARY KEY (id_almacen);


--
-- TOC entry 4216 (class 2606 OID 66596)
-- Name: inv_kardex_lote inv_kardex_lote_pkey; Type: CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.inv_kardex_lote
    ADD CONSTRAINT inv_kardex_lote_pkey PRIMARY KEY (id);


--
-- TOC entry 4218 (class 2606 OID 66609)
-- Name: inv_kardex_movimiento inv_kardex_movimiento_pkey; Type: CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.inv_kardex_movimiento
    ADD CONSTRAINT inv_kardex_movimiento_pkey PRIMARY KEY (id);


--
-- TOC entry 4224 (class 2606 OID 66616)
-- Name: inv_kardex_periodo_control inv_kardex_periodo_control_pkey; Type: CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.inv_kardex_periodo_control
    ADD CONSTRAINT inv_kardex_periodo_control_pkey PRIMARY KEY (periodo);


--
-- TOC entry 4226 (class 2606 OID 66624)
-- Name: inv_kardex_recalculo_log inv_kardex_recalculo_log_pkey; Type: CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.inv_kardex_recalculo_log
    ADD CONSTRAINT inv_kardex_recalculo_log_pkey PRIMARY KEY (id);


--
-- TOC entry 4137 (class 2606 OID 46813)
-- Name: movimientos_inventario movimientos_inventario_pkey; Type: CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.movimientos_inventario
    ADD CONSTRAINT movimientos_inventario_pkey PRIMARY KEY (id_movimiento);


--
-- TOC entry 4139 (class 2606 OID 46815)
-- Name: stock stock_pkey; Type: CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.stock
    ADD CONSTRAINT stock_pkey PRIMARY KEY (id_stock);


--
-- TOC entry 4185 (class 2606 OID 47590)
-- Name: traslados_detalle traslados_detalle_pkey; Type: CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.traslados_detalle
    ADD CONSTRAINT traslados_detalle_pkey PRIMARY KEY (id_detalle_traslado);


--
-- TOC entry 4187 (class 2606 OID 47604)
-- Name: traslados_incidencias traslados_incidencias_pkey; Type: CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.traslados_incidencias
    ADD CONSTRAINT traslados_incidencias_pkey PRIMARY KEY (id_incidencia);


--
-- TOC entry 4181 (class 2606 OID 47579)
-- Name: traslados traslados_numero_traslado_key; Type: CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.traslados
    ADD CONSTRAINT traslados_numero_traslado_key UNIQUE (numero_traslado);


--
-- TOC entry 4183 (class 2606 OID 47577)
-- Name: traslados traslados_pkey; Type: CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.traslados
    ADD CONSTRAINT traslados_pkey PRIMARY KEY (id_traslado);


--
-- TOC entry 4141 (class 2606 OID 46817)
-- Name: stock uq_stock_producto_almacen; Type: CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.stock
    ADD CONSTRAINT uq_stock_producto_almacen UNIQUE (id_producto, id_variante, id_almacen);


--
-- TOC entry 4001 (class 2606 OID 17004)
-- Name: __EFMigrationsHistory PK___EFMigrationsHistory; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."__EFMigrationsHistory"
    ADD CONSTRAINT "PK___EFMigrationsHistory" PRIMARY KEY (migration_id);


--
-- TOC entry 4204 (class 2606 OID 62625)
-- Name: categorias PK_categorias; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categorias
    ADD CONSTRAINT "PK_categorias" PRIMARY KEY ("Id");


--
-- TOC entry 4206 (class 2606 OID 62638)
-- Name: marcas PK_marcas; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marcas
    ADD CONSTRAINT "PK_marcas" PRIMARY KEY ("Id");


--
-- TOC entry 4214 (class 2606 OID 62654)
-- Name: productos PK_productos; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT "PK_productos" PRIMARY KEY ("Id");


--
-- TOC entry 4208 (class 2606 OID 62646)
-- Name: unidades_medida PK_unidades_medida; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidades_medida
    ADD CONSTRAINT "PK_unidades_medida" PRIMARY KEY ("Id");


--
-- TOC entry 4271 (class 2606 OID 67298)
-- Name: cat_estado_cpe cat_estado_cpe_pkey; Type: CONSTRAINT; Schema: sunat; Owner: postgres
--

ALTER TABLE ONLY sunat.cat_estado_cpe
    ADD CONSTRAINT cat_estado_cpe_pkey PRIMARY KEY (id_estado);


--
-- TOC entry 4273 (class 2606 OID 67314)
-- Name: log_envio_cpe log_envio_cpe_pkey; Type: CONSTRAINT; Schema: sunat; Owner: postgres
--

ALTER TABLE ONLY sunat.log_envio_cpe
    ADD CONSTRAINT log_envio_cpe_pkey PRIMARY KEY (id_log);


--
-- TOC entry 4143 (class 2606 OID 46819)
-- Name: cajas cajas_pkey; Type: CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.cajas
    ADD CONSTRAINT cajas_pkey PRIMARY KEY (id_caja);


--
-- TOC entry 4145 (class 2606 OID 46821)
-- Name: cotizaciones cotizaciones_pkey; Type: CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.cotizaciones
    ADD CONSTRAINT cotizaciones_pkey PRIMARY KEY (id_cotizacion);


--
-- TOC entry 4147 (class 2606 OID 46823)
-- Name: detalle_cotizacion detalle_cotizacion_pkey; Type: CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.detalle_cotizacion
    ADD CONSTRAINT detalle_cotizacion_pkey PRIMARY KEY (id_detalle_cot);


--
-- TOC entry 4149 (class 2606 OID 46825)
-- Name: detalle_venta detalle_venta_pkey; Type: CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.detalle_venta
    ADD CONSTRAINT detalle_venta_pkey PRIMARY KEY (id_detalle_venta);


--
-- TOC entry 4151 (class 2606 OID 46831)
-- Name: movimientos_caja movimientos_caja_pkey; Type: CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.movimientos_caja
    ADD CONSTRAINT movimientos_caja_pkey PRIMARY KEY (id_movimiento_caja);


--
-- TOC entry 4153 (class 2606 OID 46833)
-- Name: pagos pagos_pkey; Type: CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.pagos
    ADD CONSTRAINT pagos_pkey PRIMARY KEY (id_pago);


--
-- TOC entry 4256 (class 2606 OID 66975)
-- Name: nota_credito pk_nota_credito; Type: CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.nota_credito
    ADD CONSTRAINT pk_nota_credito PRIMARY KEY (id_nota);


--
-- TOC entry 4263 (class 2606 OID 67001)
-- Name: nota_credito_detalle pk_nota_credito_detalle; Type: CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.nota_credito_detalle
    ADD CONSTRAINT pk_nota_credito_detalle PRIMARY KEY (id_detalle);


--
-- TOC entry 4259 (class 2606 OID 66988)
-- Name: nota_debito pk_nota_debito; Type: CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.nota_debito
    ADD CONSTRAINT pk_nota_debito PRIMARY KEY (id_nota);


--
-- TOC entry 4267 (class 2606 OID 67019)
-- Name: nota_debito_detalle pk_nota_debito_detalle; Type: CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.nota_debito_detalle
    ADD CONSTRAINT pk_nota_debito_detalle PRIMARY KEY (id_detalle);


--
-- TOC entry 4275 (class 2606 OID 67345)
-- Name: venta_cuota_pago venta_cuota_pago_pkey; Type: CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.venta_cuota_pago
    ADD CONSTRAINT venta_cuota_pago_pkey PRIMARY KEY (id_cuota);


--
-- TOC entry 4155 (class 2606 OID 46835)
-- Name: ventas ventas_pkey; Type: CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.ventas
    ADD CONSTRAINT ventas_pkey PRIMARY KEY (id_venta);


--
-- TOC entry 4026 (class 1259 OID 66826)
-- Name: idx_clientes_razon_social; Type: INDEX; Schema: clientes; Owner: postgres
--

CREATE INDEX idx_clientes_razon_social ON clientes.clientes USING gin (to_tsvector('spanish'::regconfig, (razon_social)::text));


--
-- TOC entry 4027 (class 1259 OID 66825)
-- Name: uq_clientes_numero_documento; Type: INDEX; Schema: clientes; Owner: postgres
--

CREATE UNIQUE INDEX uq_clientes_numero_documento ON clientes.clientes USING btree (numero_documento) WHERE (activado = true);


--
-- TOC entry 4040 (class 1259 OID 66866)
-- Name: idx_proveedores_razon_social; Type: INDEX; Schema: compras; Owner: postgres
--

CREATE INDEX idx_proveedores_razon_social ON compras.proveedores USING gin (to_tsvector('spanish'::regconfig, (razon_social)::text));


--
-- TOC entry 4246 (class 1259 OID 66957)
-- Name: ix_nota_credito_detalle_id_compra_detalle; Type: INDEX; Schema: compras; Owner: postgres
--

CREATE INDEX ix_nota_credito_detalle_id_compra_detalle ON compras.nota_credito_detalle USING btree (id_compra_detalle);


--
-- TOC entry 4247 (class 1259 OID 66958)
-- Name: ix_nota_credito_detalle_id_nota_credito; Type: INDEX; Schema: compras; Owner: postgres
--

CREATE INDEX ix_nota_credito_detalle_id_nota_credito ON compras.nota_credito_detalle USING btree (id_nota_credito);


--
-- TOC entry 4238 (class 1259 OID 66955)
-- Name: ix_nota_credito_id_compra_referencia; Type: INDEX; Schema: compras; Owner: postgres
--

CREATE INDEX ix_nota_credito_id_compra_referencia ON compras.nota_credito USING btree (id_compra_referencia);


--
-- TOC entry 4239 (class 1259 OID 66956)
-- Name: ix_nota_credito_id_proveedor; Type: INDEX; Schema: compras; Owner: postgres
--

CREATE INDEX ix_nota_credito_id_proveedor ON compras.nota_credito USING btree (id_proveedor);


--
-- TOC entry 4250 (class 1259 OID 66961)
-- Name: ix_nota_debito_detalle_id_compra_detalle; Type: INDEX; Schema: compras; Owner: postgres
--

CREATE INDEX ix_nota_debito_detalle_id_compra_detalle ON compras.nota_debito_detalle USING btree (id_compra_detalle);


--
-- TOC entry 4251 (class 1259 OID 66962)
-- Name: ix_nota_debito_detalle_id_nota_debito; Type: INDEX; Schema: compras; Owner: postgres
--

CREATE INDEX ix_nota_debito_detalle_id_nota_debito ON compras.nota_debito_detalle USING btree (id_nota_debito);


--
-- TOC entry 4242 (class 1259 OID 66959)
-- Name: ix_nota_debito_id_compra_referencia; Type: INDEX; Schema: compras; Owner: postgres
--

CREATE INDEX ix_nota_debito_id_compra_referencia ON compras.nota_debito USING btree (id_compra_referencia);


--
-- TOC entry 4243 (class 1259 OID 66960)
-- Name: ix_nota_debito_id_proveedor; Type: INDEX; Schema: compras; Owner: postgres
--

CREATE INDEX ix_nota_debito_id_proveedor ON compras.nota_debito USING btree (id_proveedor);


--
-- TOC entry 4045 (class 1259 OID 66865)
-- Name: uq_proveedores_numero_documento; Type: INDEX; Schema: compras; Owner: postgres
--

CREATE UNIQUE INDEX uq_proveedores_numero_documento ON compras.proveedores USING btree (numero_documento) WHERE (activado = true);


--
-- TOC entry 4056 (class 1259 OID 46836)
-- Name: idx_tablas_generales_codigo; Type: INDEX; Schema: configuracion; Owner: postgres
--

CREATE INDEX idx_tablas_generales_codigo ON configuracion.tablas_generales USING btree (codigo);


--
-- TOC entry 4061 (class 1259 OID 46837)
-- Name: idx_tablas_generales_detalle_codigo; Type: INDEX; Schema: configuracion; Owner: postgres
--

CREATE INDEX idx_tablas_generales_detalle_codigo ON configuracion.tablas_generales_detalle USING btree (codigo);


--
-- TOC entry 4062 (class 1259 OID 46838)
-- Name: idx_tablas_generales_detalle_tabla; Type: INDEX; Schema: configuracion; Owner: postgres
--

CREATE INDEX idx_tablas_generales_detalle_tabla ON configuracion.tablas_generales_detalle USING btree (id_tabla);


--
-- TOC entry 4235 (class 1259 OID 66877)
-- Name: ix_ubigeos_parent_id; Type: INDEX; Schema: configuracion; Owner: postgres
--

CREATE INDEX ix_ubigeos_parent_id ON configuracion.ubigeos USING btree (parent_id);


--
-- TOC entry 4085 (class 1259 OID 46839)
-- Name: idx_menus_codigo; Type: INDEX; Schema: identidad; Owner: postgres
--

CREATE INDEX idx_menus_codigo ON identidad.menus USING btree (codigo);


--
-- TOC entry 4086 (class 1259 OID 46840)
-- Name: idx_menus_menu_padre; Type: INDEX; Schema: identidad; Owner: postgres
--

CREATE INDEX idx_menus_menu_padre ON identidad.menus USING btree (id_menu_padre);


--
-- TOC entry 4099 (class 1259 OID 46841)
-- Name: idx_roles_menus_menu; Type: INDEX; Schema: identidad; Owner: postgres
--

CREATE INDEX idx_roles_menus_menu ON identidad.roles_menus USING btree (id_menu);


--
-- TOC entry 4100 (class 1259 OID 46842)
-- Name: idx_roles_menus_rol; Type: INDEX; Schema: identidad; Owner: postgres
--

CREATE INDEX idx_roles_menus_rol ON identidad.roles_menus USING btree (id_rol);


--
-- TOC entry 4111 (class 1259 OID 46843)
-- Name: idx_tipos_permiso_codigo; Type: INDEX; Schema: identidad; Owner: postgres
--

CREATE INDEX idx_tipos_permiso_codigo ON identidad.tipos_permiso USING btree (codigo);


--
-- TOC entry 4128 (class 1259 OID 46844)
-- Name: idx_usuarios_roles_rol; Type: INDEX; Schema: identidad; Owner: postgres
--

CREATE INDEX idx_usuarios_roles_rol ON identidad.usuarios_roles USING btree (id_rol);


--
-- TOC entry 4129 (class 1259 OID 46845)
-- Name: idx_usuarios_roles_usuario; Type: INDEX; Schema: identidad; Owner: postgres
--

CREATE INDEX idx_usuarios_roles_usuario ON identidad.usuarios_roles USING btree (id_usuario);


--
-- TOC entry 4219 (class 1259 OID 66628)
-- Name: ix_inv_kardex_movimiento_doc; Type: INDEX; Schema: inventario; Owner: postgres
--

CREATE INDEX ix_inv_kardex_movimiento_doc ON inventario.inv_kardex_movimiento USING btree (tipo_documento, serie_documento, numero_documento);


--
-- TOC entry 4220 (class 1259 OID 66625)
-- Name: ix_inv_kardex_movimiento_fecha_hora; Type: INDEX; Schema: inventario; Owner: postgres
--

CREATE INDEX ix_inv_kardex_movimiento_fecha_hora ON inventario.inv_kardex_movimiento USING btree (fecha_movimiento, hora_movimiento);


--
-- TOC entry 4221 (class 1259 OID 66626)
-- Name: ix_inv_kardex_movimiento_periodo_prod; Type: INDEX; Schema: inventario; Owner: postgres
--

CREATE INDEX ix_inv_kardex_movimiento_periodo_prod ON inventario.inv_kardex_movimiento USING btree (periodo, almacen_id, producto_id);


--
-- TOC entry 4222 (class 1259 OID 66627)
-- Name: ix_inv_kardex_movimiento_ref; Type: INDEX; Schema: inventario; Owner: postgres
--

CREATE INDEX ix_inv_kardex_movimiento_ref ON inventario.inv_kardex_movimiento USING btree (referencia_id, referencia_tipo);


--
-- TOC entry 4202 (class 1259 OID 62670)
-- Name: IX_categorias_IdCategoriaPadre; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_categorias_IdCategoriaPadre" ON public.categorias USING btree ("IdCategoriaPadre");


--
-- TOC entry 4209 (class 1259 OID 62671)
-- Name: IX_productos_CodigoProducto; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IX_productos_CodigoProducto" ON public.productos USING btree ("CodigoProducto");


--
-- TOC entry 4210 (class 1259 OID 62672)
-- Name: IX_productos_IdCategoria; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_productos_IdCategoria" ON public.productos USING btree ("IdCategoria");


--
-- TOC entry 4211 (class 1259 OID 62673)
-- Name: IX_productos_IdMarca; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_productos_IdMarca" ON public.productos USING btree ("IdMarca");


--
-- TOC entry 4212 (class 1259 OID 62674)
-- Name: IX_productos_IdUnidadMedida; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_productos_IdUnidadMedida" ON public.productos USING btree ("IdUnidadMedida");


--
-- TOC entry 4260 (class 1259 OID 67031)
-- Name: ix_nota_credito_detalle_id_nota_credito; Type: INDEX; Schema: ventas; Owner: postgres
--

CREATE INDEX ix_nota_credito_detalle_id_nota_credito ON ventas.nota_credito_detalle USING btree (id_nota_credito);


--
-- TOC entry 4261 (class 1259 OID 67032)
-- Name: ix_nota_credito_detalle_id_venta_detalle; Type: INDEX; Schema: ventas; Owner: postgres
--

CREATE INDEX ix_nota_credito_detalle_id_venta_detalle ON ventas.nota_credito_detalle USING btree (id_venta_detalle);


--
-- TOC entry 4254 (class 1259 OID 67030)
-- Name: ix_nota_credito_id_venta_referencia; Type: INDEX; Schema: ventas; Owner: postgres
--

CREATE INDEX ix_nota_credito_id_venta_referencia ON ventas.nota_credito USING btree (id_venta_referencia);


--
-- TOC entry 4264 (class 1259 OID 67034)
-- Name: ix_nota_debito_detalle_id_nota_debito; Type: INDEX; Schema: ventas; Owner: postgres
--

CREATE INDEX ix_nota_debito_detalle_id_nota_debito ON ventas.nota_debito_detalle USING btree (id_nota_debito);


--
-- TOC entry 4265 (class 1259 OID 67035)
-- Name: ix_nota_debito_detalle_id_venta_detalle; Type: INDEX; Schema: ventas; Owner: postgres
--

CREATE INDEX ix_nota_debito_detalle_id_venta_detalle ON ventas.nota_debito_detalle USING btree (id_venta_detalle);


--
-- TOC entry 4257 (class 1259 OID 67033)
-- Name: ix_nota_debito_id_venta_referencia; Type: INDEX; Schema: ventas; Owner: postgres
--

CREATE INDEX ix_nota_debito_id_venta_referencia ON ventas.nota_debito USING btree (id_venta_referencia);


--
-- TOC entry 4393 (class 2620 OID 46846)
-- Name: productos tr_productos_update; Type: TRIGGER; Schema: catalogo; Owner: postgres
--

CREATE TRIGGER tr_productos_update BEFORE UPDATE ON catalogo.productos FOR EACH ROW EXECUTE FUNCTION public.update_fecha_modificacion_column();


--
-- TOC entry 4394 (class 2620 OID 46847)
-- Name: clientes tr_clientes_update; Type: TRIGGER; Schema: clientes; Owner: postgres
--

CREATE TRIGGER tr_clientes_update BEFORE UPDATE ON clientes.clientes FOR EACH ROW EXECUTE FUNCTION public.update_fecha_modificacion_column();


--
-- TOC entry 4395 (class 2620 OID 62709)
-- Name: compras tr_compras_update; Type: TRIGGER; Schema: compras; Owner: postgres
--

CREATE TRIGGER tr_compras_update BEFORE UPDATE ON compras.compras FOR EACH ROW EXECUTE FUNCTION public.update_fecha_modificacion_column();


--
-- TOC entry 4396 (class 2620 OID 62710)
-- Name: ordenes_compra tr_ordenes_compra_update; Type: TRIGGER; Schema: compras; Owner: postgres
--

CREATE TRIGGER tr_ordenes_compra_update BEFORE UPDATE ON compras.ordenes_compra FOR EACH ROW EXECUTE FUNCTION public.update_fecha_modificacion_column();


--
-- TOC entry 4397 (class 2620 OID 46848)
-- Name: configuraciones tr_config_update; Type: TRIGGER; Schema: configuracion; Owner: postgres
--

CREATE TRIGGER tr_config_update BEFORE UPDATE ON configuracion.configuraciones FOR EACH ROW EXECUTE FUNCTION public.update_fecha_modificacion_column();


--
-- TOC entry 4398 (class 2620 OID 46849)
-- Name: empresa tr_empresa_update; Type: TRIGGER; Schema: configuracion; Owner: postgres
--

CREATE TRIGGER tr_empresa_update BEFORE UPDATE ON configuracion.empresa FOR EACH ROW EXECUTE FUNCTION public.update_fecha_modificacion_column();


--
-- TOC entry 4401 (class 2620 OID 62711)
-- Name: tipo_documento tr_tipo_documento_update; Type: TRIGGER; Schema: configuracion; Owner: postgres
--

CREATE TRIGGER tr_tipo_documento_update BEFORE UPDATE ON configuracion.tipo_documento FOR EACH ROW EXECUTE FUNCTION public.update_fecha_modificacion_column();


--
-- TOC entry 4399 (class 2620 OID 46850)
-- Name: usuarios tr_usuarios_update; Type: TRIGGER; Schema: identidad; Owner: postgres
--

CREATE TRIGGER tr_usuarios_update BEFORE UPDATE ON identidad.usuarios FOR EACH ROW EXECUTE FUNCTION public.update_fecha_modificacion_column();


--
-- TOC entry 4400 (class 2620 OID 46851)
-- Name: ventas tr_ventas_update; Type: TRIGGER; Schema: ventas; Owner: postgres
--

CREATE TRIGGER tr_ventas_update BEFORE UPDATE ON ventas.ventas FOR EACH ROW EXECUTE FUNCTION public.update_fecha_modificacion_column();


--
-- TOC entry 4276 (class 2606 OID 46852)
-- Name: categorias fk_categoria_padre; Type: FK CONSTRAINT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.categorias
    ADD CONSTRAINT fk_categoria_padre FOREIGN KEY (id_categoria_padre) REFERENCES catalogo.categorias(id_categoria);


--
-- TOC entry 4277 (class 2606 OID 46857)
-- Name: imagenes_producto fk_imagenes_producto; Type: FK CONSTRAINT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.imagenes_producto
    ADD CONSTRAINT fk_imagenes_producto FOREIGN KEY (id_producto) REFERENCES catalogo.productos(id_producto) ON DELETE CASCADE;


--
-- TOC entry 4278 (class 2606 OID 46862)
-- Name: productos fk_producto_tipo; Type: FK CONSTRAINT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.productos
    ADD CONSTRAINT fk_producto_tipo FOREIGN KEY (id_tipo_producto) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 4279 (class 2606 OID 46867)
-- Name: productos fk_productos_categoria; Type: FK CONSTRAINT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.productos
    ADD CONSTRAINT fk_productos_categoria FOREIGN KEY (id_categoria) REFERENCES catalogo.categorias(id_categoria);


--
-- TOC entry 4280 (class 2606 OID 46872)
-- Name: productos fk_productos_marca; Type: FK CONSTRAINT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.productos
    ADD CONSTRAINT fk_productos_marca FOREIGN KEY (id_marca) REFERENCES catalogo.marcas(id_marca);


--
-- TOC entry 4281 (class 2606 OID 46877)
-- Name: productos fk_productos_unidad; Type: FK CONSTRAINT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.productos
    ADD CONSTRAINT fk_productos_unidad FOREIGN KEY (id_unidad) REFERENCES catalogo.unidades_medida(id_unidad);


--
-- TOC entry 4282 (class 2606 OID 46882)
-- Name: variantes_producto fk_variantes_producto; Type: FK CONSTRAINT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.variantes_producto
    ADD CONSTRAINT fk_variantes_producto FOREIGN KEY (id_producto) REFERENCES catalogo.productos(id_producto) ON DELETE CASCADE;


--
-- TOC entry 4283 (class 2606 OID 46887)
-- Name: clientes fk_cliente_lista_precio; Type: FK CONSTRAINT; Schema: clientes; Owner: postgres
--

ALTER TABLE ONLY clientes.clientes
    ADD CONSTRAINT fk_cliente_lista_precio FOREIGN KEY (id_lista_precio_asignada) REFERENCES catalogo.listas_precios(id_lista_precio);


--
-- TOC entry 4284 (class 2606 OID 46892)
-- Name: clientes fk_cliente_tipo_cliente; Type: FK CONSTRAINT; Schema: clientes; Owner: postgres
--

ALTER TABLE ONLY clientes.clientes
    ADD CONSTRAINT fk_cliente_tipo_cliente FOREIGN KEY (id_tipo_cliente) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 4285 (class 2606 OID 46897)
-- Name: clientes fk_cliente_tipo_documento; Type: FK CONSTRAINT; Schema: clientes; Owner: postgres
--

ALTER TABLE ONLY clientes.clientes
    ADD CONSTRAINT fk_cliente_tipo_documento FOREIGN KEY (id_tipo_documento) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 4286 (class 2606 OID 46902)
-- Name: contactos_cliente fk_contacto_cliente; Type: FK CONSTRAINT; Schema: clientes; Owner: postgres
--

ALTER TABLE ONLY clientes.contactos_cliente
    ADD CONSTRAINT fk_contacto_cliente FOREIGN KEY (id_cliente) REFERENCES clientes.clientes(id_cliente) ON DELETE CASCADE;


--
-- TOC entry 4287 (class 2606 OID 46907)
-- Name: compras fk_compra_almacen; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.compras
    ADD CONSTRAINT fk_compra_almacen FOREIGN KEY (id_almacen) REFERENCES inventario.almacenes(id_almacen);


--
-- TOC entry 4288 (class 2606 OID 46912)
-- Name: compras fk_compra_estado_pago; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.compras
    ADD CONSTRAINT fk_compra_estado_pago FOREIGN KEY (id_estado_pago) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 4289 (class 2606 OID 46917)
-- Name: compras fk_compra_proveedor; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.compras
    ADD CONSTRAINT fk_compra_proveedor FOREIGN KEY (id_proveedor) REFERENCES compras.proveedores(id_proveedor);


--
-- TOC entry 4290 (class 2606 OID 46922)
-- Name: compras fk_compra_tipo_comprobante; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.compras
    ADD CONSTRAINT fk_compra_tipo_comprobante FOREIGN KEY (id_tipo_comprobante) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 4291 (class 2606 OID 46927)
-- Name: detalle_compra fk_dc_compra; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.detalle_compra
    ADD CONSTRAINT fk_dc_compra FOREIGN KEY (id_compra) REFERENCES compras.compras(id_compra) ON DELETE CASCADE;


--
-- TOC entry 4292 (class 2606 OID 46932)
-- Name: detalle_compra fk_dc_producto; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.detalle_compra
    ADD CONSTRAINT fk_dc_producto FOREIGN KEY (id_producto) REFERENCES catalogo.productos(id_producto);


--
-- TOC entry 4293 (class 2606 OID 62971)
-- Name: detalle_compra fk_detalle_compra_afectacion_igv; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.detalle_compra
    ADD CONSTRAINT fk_detalle_compra_afectacion_igv FOREIGN KEY (afectacion_igv) REFERENCES configuracion.tipo_afectacion_igv(codigo);


--
-- TOC entry 4294 (class 2606 OID 46937)
-- Name: detalle_orden_compra fk_doc_orden; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.detalle_orden_compra
    ADD CONSTRAINT fk_doc_orden FOREIGN KEY (id_orden_compra) REFERENCES compras.ordenes_compra(id_orden_compra) ON DELETE CASCADE;


--
-- TOC entry 4295 (class 2606 OID 46942)
-- Name: detalle_orden_compra fk_doc_producto; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.detalle_orden_compra
    ADD CONSTRAINT fk_doc_producto FOREIGN KEY (id_producto) REFERENCES catalogo.productos(id_producto);


--
-- TOC entry 4366 (class 2606 OID 66891)
-- Name: nota_credito fk_nota_credito_compras_id_compra_referencia; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.nota_credito
    ADD CONSTRAINT fk_nota_credito_compras_id_compra_referencia FOREIGN KEY (id_compra_referencia) REFERENCES compras.compras(id_compra) ON DELETE CASCADE;


--
-- TOC entry 4370 (class 2606 OID 66927)
-- Name: nota_credito_detalle fk_nota_credito_detalle_detalle_compra_id_compra_detalle; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.nota_credito_detalle
    ADD CONSTRAINT fk_nota_credito_detalle_detalle_compra_id_compra_detalle FOREIGN KEY (id_compra_detalle) REFERENCES compras.detalle_compra(id_detalle_compra);


--
-- TOC entry 4371 (class 2606 OID 66932)
-- Name: nota_credito_detalle fk_nota_credito_detalle_nota_credito_id_nota_credito; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.nota_credito_detalle
    ADD CONSTRAINT fk_nota_credito_detalle_nota_credito_id_nota_credito FOREIGN KEY (id_nota_credito) REFERENCES compras.nota_credito(id_nota) ON DELETE CASCADE;


--
-- TOC entry 4367 (class 2606 OID 66896)
-- Name: nota_credito fk_nota_credito_proveedores_id_proveedor; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.nota_credito
    ADD CONSTRAINT fk_nota_credito_proveedores_id_proveedor FOREIGN KEY (id_proveedor) REFERENCES compras.proveedores(id_proveedor) ON DELETE CASCADE;


--
-- TOC entry 4368 (class 2606 OID 66909)
-- Name: nota_debito fk_nota_debito_compras_id_compra_referencia; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.nota_debito
    ADD CONSTRAINT fk_nota_debito_compras_id_compra_referencia FOREIGN KEY (id_compra_referencia) REFERENCES compras.compras(id_compra) ON DELETE CASCADE;


--
-- TOC entry 4372 (class 2606 OID 66945)
-- Name: nota_debito_detalle fk_nota_debito_detalle_detalle_compra_id_compra_detalle; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.nota_debito_detalle
    ADD CONSTRAINT fk_nota_debito_detalle_detalle_compra_id_compra_detalle FOREIGN KEY (id_compra_detalle) REFERENCES compras.detalle_compra(id_detalle_compra);


--
-- TOC entry 4373 (class 2606 OID 66950)
-- Name: nota_debito_detalle fk_nota_debito_detalle_nota_debito_id_nota_debito; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.nota_debito_detalle
    ADD CONSTRAINT fk_nota_debito_detalle_nota_debito_id_nota_debito FOREIGN KEY (id_nota_debito) REFERENCES compras.nota_debito(id_nota) ON DELETE CASCADE;


--
-- TOC entry 4369 (class 2606 OID 66914)
-- Name: nota_debito fk_nota_debito_proveedores_id_proveedor; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.nota_debito
    ADD CONSTRAINT fk_nota_debito_proveedores_id_proveedor FOREIGN KEY (id_proveedor) REFERENCES compras.proveedores(id_proveedor) ON DELETE CASCADE;


--
-- TOC entry 4296 (class 2606 OID 46947)
-- Name: ordenes_compra fk_oc_almacen; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.ordenes_compra
    ADD CONSTRAINT fk_oc_almacen FOREIGN KEY (id_almacen_destino) REFERENCES inventario.almacenes(id_almacen);


--
-- TOC entry 4297 (class 2606 OID 46952)
-- Name: ordenes_compra fk_oc_proveedor; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.ordenes_compra
    ADD CONSTRAINT fk_oc_proveedor FOREIGN KEY (id_proveedor) REFERENCES compras.proveedores(id_proveedor);


--
-- TOC entry 4298 (class 2606 OID 46957)
-- Name: ordenes_compra fk_orden_compra_estado; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.ordenes_compra
    ADD CONSTRAINT fk_orden_compra_estado FOREIGN KEY (id_estado) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 4299 (class 2606 OID 62712)
-- Name: proveedores fk_proveedor_tipo_documento; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.proveedores
    ADD CONSTRAINT fk_proveedor_tipo_documento FOREIGN KEY (id_tipo_documento) REFERENCES configuracion.tipo_documento(id_regla);


--
-- TOC entry 4360 (class 2606 OID 67374)
-- Name: tipo_afectacion_igv fk_afectacion_igv_impuesto; Type: FK CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.tipo_afectacion_igv
    ADD CONSTRAINT fk_afectacion_igv_impuesto FOREIGN KEY (id_impuesto) REFERENCES configuracion.impuestos(id_impuesto);


--
-- TOC entry 4351 (class 2606 OID 47285)
-- Name: matriz_regla_sunat fk_matriz_tipo_comp; Type: FK CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.matriz_regla_sunat
    ADD CONSTRAINT fk_matriz_tipo_comp FOREIGN KEY (id_tipo_comprobante) REFERENCES configuracion.tipo_comprobante(id_tipo_comprobante);


--
-- TOC entry 4352 (class 2606 OID 47290)
-- Name: matriz_regla_sunat fk_matriz_tipo_oper; Type: FK CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.matriz_regla_sunat
    ADD CONSTRAINT fk_matriz_tipo_oper FOREIGN KEY (id_tipo_operacion) REFERENCES configuracion.tipo_operacion_sunat(id_tipo_operacion);


--
-- TOC entry 4354 (class 2606 OID 47295)
-- Name: regla_documento_comprobante fk_regla_doc_tipo_comp; Type: FK CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.regla_documento_comprobante
    ADD CONSTRAINT fk_regla_doc_tipo_comp FOREIGN KEY (id_tipo_comprobante) REFERENCES configuracion.tipo_comprobante(id_tipo_comprobante);


--
-- TOC entry 4353 (class 2606 OID 47787)
-- Name: regla_documento_comprobante fk_regla_documento_comprobante_tipo_documento_codigo_documento; Type: FK CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.regla_documento_comprobante
    ADD CONSTRAINT fk_regla_documento_comprobante_tipo_documento_codigo_documento FOREIGN KEY (codigo_documento) REFERENCES configuracion.tipo_documento(codigo) ON DELETE RESTRICT;


--
-- TOC entry 4300 (class 2606 OID 47280)
-- Name: series_comprobantes fk_series_tipo_comp; Type: FK CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.series_comprobantes
    ADD CONSTRAINT fk_series_tipo_comp FOREIGN KEY (id_tipo_comprobante) REFERENCES configuracion.tipo_comprobante(id_tipo_comprobante);


--
-- TOC entry 4355 (class 2606 OID 47782)
-- Name: sucursales fk_sucursal_empresa_id_empresa; Type: FK CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.sucursales
    ADD CONSTRAINT fk_sucursal_empresa_id_empresa FOREIGN KEY (id_empresa) REFERENCES configuracion.empresa(id_empresa) ON DELETE RESTRICT;


--
-- TOC entry 4356 (class 2606 OID 66635)
-- Name: sucursales fk_sucursales_empresa_id_empresa; Type: FK CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.sucursales
    ADD CONSTRAINT fk_sucursales_empresa_id_empresa FOREIGN KEY (id_empresa) REFERENCES configuracion.empresa(id_empresa) ON DELETE RESTRICT;


--
-- TOC entry 4301 (class 2606 OID 46972)
-- Name: tablas_generales_detalle fk_tabla_general; Type: FK CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.tablas_generales_detalle
    ADD CONSTRAINT fk_tabla_general FOREIGN KEY (id_tabla) REFERENCES configuracion.tablas_generales(id_tabla) ON DELETE CASCADE;


--
-- TOC entry 4365 (class 2606 OID 66872)
-- Name: ubigeos fk_ubigeos_ubigeos_parent_id; Type: FK CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.ubigeos
    ADD CONSTRAINT fk_ubigeos_ubigeos_parent_id FOREIGN KEY (parent_id) REFERENCES configuracion.ubigeos(codigo) ON DELETE RESTRICT;


--
-- TOC entry 4357 (class 2606 OID 47327)
-- Name: sucursales sucursales_id_empresa_fkey; Type: FK CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.sucursales
    ADD CONSTRAINT sucursales_id_empresa_fkey FOREIGN KEY (id_empresa) REFERENCES configuracion.empresa(id_empresa);


--
-- TOC entry 4302 (class 2606 OID 46977)
-- Name: asientos_contables fk_asiento_estado; Type: FK CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.asientos_contables
    ADD CONSTRAINT fk_asiento_estado FOREIGN KEY (id_estado) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 4305 (class 2606 OID 46982)
-- Name: plan_cuentas fk_cuenta_padre; Type: FK CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.plan_cuentas
    ADD CONSTRAINT fk_cuenta_padre FOREIGN KEY (id_cuenta_padre) REFERENCES contabilidad.plan_cuentas(id_cuenta);


--
-- TOC entry 4303 (class 2606 OID 46987)
-- Name: detalle_asiento fk_da_asiento; Type: FK CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.detalle_asiento
    ADD CONSTRAINT fk_da_asiento FOREIGN KEY (id_asiento) REFERENCES contabilidad.asientos_contables(id_asiento) ON DELETE CASCADE;


--
-- TOC entry 4304 (class 2606 OID 46992)
-- Name: detalle_asiento fk_da_cuenta; Type: FK CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.detalle_asiento
    ADD CONSTRAINT fk_da_cuenta FOREIGN KEY (id_cuenta) REFERENCES contabilidad.plan_cuentas(id_cuenta);


--
-- TOC entry 4306 (class 2606 OID 46997)
-- Name: plan_cuentas fk_plan_cuenta_tipo; Type: FK CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.plan_cuentas
    ADD CONSTRAINT fk_plan_cuenta_tipo FOREIGN KEY (id_tipo_cuenta) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 4307 (class 2606 OID 47002)
-- Name: cargos fk_cargos_area; Type: FK CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.cargos
    ADD CONSTRAINT fk_cargos_area FOREIGN KEY (id_area) REFERENCES identidad.areas(id_area);


--
-- TOC entry 4313 (class 2606 OID 47007)
-- Name: roles_permisos fk_rp_permiso; Type: FK CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.roles_permisos
    ADD CONSTRAINT fk_rp_permiso FOREIGN KEY (id_permiso) REFERENCES identidad.permisos(id_permiso) ON DELETE CASCADE;


--
-- TOC entry 4314 (class 2606 OID 47012)
-- Name: roles_permisos fk_rp_rol; Type: FK CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.roles_permisos
    ADD CONSTRAINT fk_rp_rol FOREIGN KEY (id_rol) REFERENCES identidad.roles(id_rol) ON DELETE CASCADE;


--
-- TOC entry 4315 (class 2606 OID 47017)
-- Name: trabajadores fk_trabajador_tipo_documento; Type: FK CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.trabajadores
    ADD CONSTRAINT fk_trabajador_tipo_documento FOREIGN KEY (id_tipo_documento) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 4316 (class 2606 OID 47022)
-- Name: trabajadores fk_trabajadores_cargo; Type: FK CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.trabajadores
    ADD CONSTRAINT fk_trabajadores_cargo FOREIGN KEY (id_cargo) REFERENCES identidad.cargos(id_cargo);


--
-- TOC entry 4317 (class 2606 OID 47027)
-- Name: trabajadores fk_trabajadores_usuario; Type: FK CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.trabajadores
    ADD CONSTRAINT fk_trabajadores_usuario FOREIGN KEY (id_usuario) REFERENCES identidad.usuarios(id_usuario);


--
-- TOC entry 4318 (class 2606 OID 47032)
-- Name: usuarios fk_usuarios_rol; Type: FK CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.usuarios
    ADD CONSTRAINT fk_usuarios_rol FOREIGN KEY (id_rol) REFERENCES identidad.roles(id_rol) ON DELETE RESTRICT;


--
-- TOC entry 4308 (class 2606 OID 47037)
-- Name: menus menus_id_menu_padre_fkey; Type: FK CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.menus
    ADD CONSTRAINT menus_id_menu_padre_fkey FOREIGN KEY (id_menu_padre) REFERENCES identidad.menus(id_menu) ON DELETE CASCADE;


--
-- TOC entry 4309 (class 2606 OID 47042)
-- Name: roles_menus roles_menus_id_menu_fkey; Type: FK CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.roles_menus
    ADD CONSTRAINT roles_menus_id_menu_fkey FOREIGN KEY (id_menu) REFERENCES identidad.menus(id_menu) ON DELETE CASCADE;


--
-- TOC entry 4310 (class 2606 OID 47047)
-- Name: roles_menus roles_menus_id_rol_fkey; Type: FK CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.roles_menus
    ADD CONSTRAINT roles_menus_id_rol_fkey FOREIGN KEY (id_rol) REFERENCES identidad.roles(id_rol) ON DELETE CASCADE;


--
-- TOC entry 4311 (class 2606 OID 47052)
-- Name: roles_menus_permisos roles_menus_permisos_id_rol_menu_fkey; Type: FK CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.roles_menus_permisos
    ADD CONSTRAINT roles_menus_permisos_id_rol_menu_fkey FOREIGN KEY (id_rol_menu) REFERENCES identidad.roles_menus(id_rol_menu) ON DELETE CASCADE;


--
-- TOC entry 4312 (class 2606 OID 47057)
-- Name: roles_menus_permisos roles_menus_permisos_id_tipo_permiso_fkey; Type: FK CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.roles_menus_permisos
    ADD CONSTRAINT roles_menus_permisos_id_tipo_permiso_fkey FOREIGN KEY (id_tipo_permiso) REFERENCES identidad.tipos_permiso(id_tipo_permiso) ON DELETE CASCADE;


--
-- TOC entry 4319 (class 2606 OID 47062)
-- Name: usuarios_roles usuarios_roles_id_rol_fkey; Type: FK CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.usuarios_roles
    ADD CONSTRAINT usuarios_roles_id_rol_fkey FOREIGN KEY (id_rol) REFERENCES identidad.roles(id_rol) ON DELETE CASCADE;


--
-- TOC entry 4320 (class 2606 OID 47067)
-- Name: usuarios_roles usuarios_roles_id_usuario_fkey; Type: FK CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.usuarios_roles
    ADD CONSTRAINT usuarios_roles_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES identidad.usuarios(id_usuario) ON DELETE CASCADE;


--
-- TOC entry 4321 (class 2606 OID 47072)
-- Name: movimientos_inventario fk_movimiento_inventario_tipo; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.movimientos_inventario
    ADD CONSTRAINT fk_movimiento_inventario_tipo FOREIGN KEY (id_tipo_movimiento) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 4322 (class 2606 OID 47077)
-- Name: movimientos_inventario fk_movimiento_stock; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.movimientos_inventario
    ADD CONSTRAINT fk_movimiento_stock FOREIGN KEY (id_stock) REFERENCES inventario.stock(id_stock);


--
-- TOC entry 4323 (class 2606 OID 47082)
-- Name: stock fk_stock_almacen; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.stock
    ADD CONSTRAINT fk_stock_almacen FOREIGN KEY (id_almacen) REFERENCES inventario.almacenes(id_almacen);


--
-- TOC entry 4324 (class 2606 OID 47087)
-- Name: stock fk_stock_producto; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.stock
    ADD CONSTRAINT fk_stock_producto FOREIGN KEY (id_producto) REFERENCES catalogo.productos(id_producto);


--
-- TOC entry 4325 (class 2606 OID 47092)
-- Name: stock fk_stock_variante; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.stock
    ADD CONSTRAINT fk_stock_variante FOREIGN KEY (id_variante) REFERENCES catalogo.variantes_producto(id_variante);


--
-- TOC entry 4358 (class 2606 OID 47591)
-- Name: traslados_detalle traslados_detalle_id_traslado_fkey; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.traslados_detalle
    ADD CONSTRAINT traslados_detalle_id_traslado_fkey FOREIGN KEY (id_traslado) REFERENCES inventario.traslados(id_traslado);


--
-- TOC entry 4359 (class 2606 OID 47605)
-- Name: traslados_incidencias traslados_incidencias_id_detalle_traslado_fkey; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.traslados_incidencias
    ADD CONSTRAINT traslados_incidencias_id_detalle_traslado_fkey FOREIGN KEY (id_detalle_traslado) REFERENCES inventario.traslados_detalle(id_detalle_traslado);


--
-- TOC entry 4361 (class 2606 OID 62626)
-- Name: categorias FK_categorias_categorias_IdCategoriaPadre; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categorias
    ADD CONSTRAINT "FK_categorias_categorias_IdCategoriaPadre" FOREIGN KEY ("IdCategoriaPadre") REFERENCES public.categorias("Id");


--
-- TOC entry 4362 (class 2606 OID 62655)
-- Name: productos FK_productos_categorias_IdCategoria; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT "FK_productos_categorias_IdCategoria" FOREIGN KEY ("IdCategoria") REFERENCES public.categorias("Id") ON DELETE RESTRICT;


--
-- TOC entry 4363 (class 2606 OID 62660)
-- Name: productos FK_productos_marcas_IdMarca; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT "FK_productos_marcas_IdMarca" FOREIGN KEY ("IdMarca") REFERENCES public.marcas("Id") ON DELETE RESTRICT;


--
-- TOC entry 4364 (class 2606 OID 62665)
-- Name: productos FK_productos_unidades_medida_IdUnidadMedida; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT "FK_productos_unidades_medida_IdUnidadMedida" FOREIGN KEY ("IdUnidadMedida") REFERENCES public.unidades_medida("Id") ON DELETE RESTRICT;


--
-- TOC entry 4391 (class 2606 OID 67330)
-- Name: log_envio_cpe log_envio_cpe_id_estado_cpe_fkey; Type: FK CONSTRAINT; Schema: sunat; Owner: postgres
--

ALTER TABLE ONLY sunat.log_envio_cpe
    ADD CONSTRAINT log_envio_cpe_id_estado_cpe_fkey FOREIGN KEY (id_estado_cpe) REFERENCES sunat.cat_estado_cpe(id_estado);


--
-- TOC entry 4389 (class 2606 OID 67320)
-- Name: log_envio_cpe log_envio_cpe_id_nota_credito_fkey; Type: FK CONSTRAINT; Schema: sunat; Owner: postgres
--

ALTER TABLE ONLY sunat.log_envio_cpe
    ADD CONSTRAINT log_envio_cpe_id_nota_credito_fkey FOREIGN KEY (id_nota_credito) REFERENCES ventas.nota_credito(id_nota);


--
-- TOC entry 4390 (class 2606 OID 67325)
-- Name: log_envio_cpe log_envio_cpe_id_nota_debito_fkey; Type: FK CONSTRAINT; Schema: sunat; Owner: postgres
--

ALTER TABLE ONLY sunat.log_envio_cpe
    ADD CONSTRAINT log_envio_cpe_id_nota_debito_fkey FOREIGN KEY (id_nota_debito) REFERENCES ventas.nota_debito(id_nota);


--
-- TOC entry 4388 (class 2606 OID 67315)
-- Name: log_envio_cpe log_envio_cpe_id_venta_fkey; Type: FK CONSTRAINT; Schema: sunat; Owner: postgres
--

ALTER TABLE ONLY sunat.log_envio_cpe
    ADD CONSTRAINT log_envio_cpe_id_venta_fkey FOREIGN KEY (id_venta) REFERENCES ventas.ventas(id_venta);


--
-- TOC entry 4326 (class 2606 OID 47097)
-- Name: cajas fk_caja_almacen; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.cajas
    ADD CONSTRAINT fk_caja_almacen FOREIGN KEY (id_almacen) REFERENCES inventario.almacenes(id_almacen);


--
-- TOC entry 4327 (class 2606 OID 47102)
-- Name: cajas fk_caja_estado; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.cajas
    ADD CONSTRAINT fk_caja_estado FOREIGN KEY (id_estado) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 4328 (class 2606 OID 47107)
-- Name: cotizaciones fk_cot_cliente; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.cotizaciones
    ADD CONSTRAINT fk_cot_cliente FOREIGN KEY (id_cliente) REFERENCES clientes.clientes(id_cliente);


--
-- TOC entry 4329 (class 2606 OID 47112)
-- Name: cotizaciones fk_cot_vendedor; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.cotizaciones
    ADD CONSTRAINT fk_cot_vendedor FOREIGN KEY (id_usuario_vendedor) REFERENCES identidad.usuarios(id_usuario);


--
-- TOC entry 4330 (class 2606 OID 47117)
-- Name: cotizaciones fk_cotizacion_estado; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.cotizaciones
    ADD CONSTRAINT fk_cotizacion_estado FOREIGN KEY (id_estado) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 4331 (class 2606 OID 47122)
-- Name: detalle_cotizacion fk_dcot_cotizacion; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.detalle_cotizacion
    ADD CONSTRAINT fk_dcot_cotizacion FOREIGN KEY (id_cotizacion) REFERENCES ventas.cotizaciones(id_cotizacion) ON DELETE CASCADE;


--
-- TOC entry 4332 (class 2606 OID 47127)
-- Name: detalle_cotizacion fk_dcot_producto; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.detalle_cotizacion
    ADD CONSTRAINT fk_dcot_producto FOREIGN KEY (id_producto) REFERENCES catalogo.productos(id_producto);


--
-- TOC entry 4337 (class 2606 OID 47734)
-- Name: detalle_venta fk_detalle_venta_afectacion_igv; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.detalle_venta
    ADD CONSTRAINT fk_detalle_venta_afectacion_igv FOREIGN KEY (codigo_afectacion_igv) REFERENCES configuracion.tipo_afectacion_igv(codigo);


--
-- TOC entry 4334 (class 2606 OID 67369)
-- Name: detalle_venta fk_detalle_venta_tributo; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.detalle_venta
    ADD CONSTRAINT fk_detalle_venta_tributo FOREIGN KEY (id_tributo) REFERENCES configuracion.impuestos(id_impuesto);


--
-- TOC entry 4333 (class 2606 OID 67364)
-- Name: detalle_venta fk_detalle_venta_unidad_medida; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.detalle_venta
    ADD CONSTRAINT fk_detalle_venta_unidad_medida FOREIGN KEY (id_unidad_medida) REFERENCES catalogo.unidades_medida(id_unidad);


--
-- TOC entry 4335 (class 2606 OID 47132)
-- Name: detalle_venta fk_dv_producto; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.detalle_venta
    ADD CONSTRAINT fk_dv_producto FOREIGN KEY (id_producto) REFERENCES catalogo.productos(id_producto);


--
-- TOC entry 4336 (class 2606 OID 47137)
-- Name: detalle_venta fk_dv_venta; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.detalle_venta
    ADD CONSTRAINT fk_dv_venta FOREIGN KEY (id_venta) REFERENCES ventas.ventas(id_venta) ON DELETE CASCADE;


--
-- TOC entry 4338 (class 2606 OID 47142)
-- Name: movimientos_caja fk_mc_caja; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.movimientos_caja
    ADD CONSTRAINT fk_mc_caja FOREIGN KEY (id_caja) REFERENCES ventas.cajas(id_caja);


--
-- TOC entry 4339 (class 2606 OID 47147)
-- Name: movimientos_caja fk_mc_pago; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.movimientos_caja
    ADD CONSTRAINT fk_mc_pago FOREIGN KEY (id_pago_relacionado) REFERENCES ventas.pagos(id_pago);


--
-- TOC entry 4340 (class 2606 OID 47152)
-- Name: movimientos_caja fk_movimiento_caja_tipo; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.movimientos_caja
    ADD CONSTRAINT fk_movimiento_caja_tipo FOREIGN KEY (id_tipo_movimiento) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 4384 (class 2606 OID 67405)
-- Name: nota_credito_detalle fk_nc_detalle_unidad_medida; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.nota_credito_detalle
    ADD CONSTRAINT fk_nc_detalle_unidad_medida FOREIGN KEY (id_unidad_medida) REFERENCES catalogo.unidades_medida(id_unidad);


--
-- TOC entry 4377 (class 2606 OID 67396)
-- Name: nota_credito fk_nc_tipo_nota; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.nota_credito
    ADD CONSTRAINT fk_nc_tipo_nota FOREIGN KEY (id_tipo_nota) REFERENCES configuracion.motivo_nota_credito(id_motivo);


--
-- TOC entry 4376 (class 2606 OID 67391)
-- Name: nota_credito fk_nc_tipo_operacion; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.nota_credito
    ADD CONSTRAINT fk_nc_tipo_operacion FOREIGN KEY (id_tipo_operacion) REFERENCES configuracion.tipo_operacion_sunat(id_tipo_operacion);


--
-- TOC entry 4387 (class 2606 OID 67432)
-- Name: nota_debito_detalle fk_nd_detalle_unidad_medida; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.nota_debito_detalle
    ADD CONSTRAINT fk_nd_detalle_unidad_medida FOREIGN KEY (id_unidad_medida) REFERENCES catalogo.unidades_medida(id_unidad);


--
-- TOC entry 4381 (class 2606 OID 67423)
-- Name: nota_debito fk_nd_tipo_nota; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.nota_debito
    ADD CONSTRAINT fk_nd_tipo_nota FOREIGN KEY (id_tipo_nota) REFERENCES configuracion.motivo_nota_debito(id_motivo);


--
-- TOC entry 4380 (class 2606 OID 67418)
-- Name: nota_debito fk_nd_tipo_operacion; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.nota_debito
    ADD CONSTRAINT fk_nd_tipo_operacion FOREIGN KEY (id_tipo_operacion) REFERENCES configuracion.tipo_operacion_sunat(id_tipo_operacion);


--
-- TOC entry 4382 (class 2606 OID 67002)
-- Name: nota_credito_detalle fk_nota_credito_detalle_detalle_venta_id_venta_detalle; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.nota_credito_detalle
    ADD CONSTRAINT fk_nota_credito_detalle_detalle_venta_id_venta_detalle FOREIGN KEY (id_venta_detalle) REFERENCES ventas.detalle_venta(id_detalle_venta);


--
-- TOC entry 4383 (class 2606 OID 67007)
-- Name: nota_credito_detalle fk_nota_credito_detalle_nota_credito_id_nota_credito; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.nota_credito_detalle
    ADD CONSTRAINT fk_nota_credito_detalle_nota_credito_id_nota_credito FOREIGN KEY (id_nota_credito) REFERENCES ventas.nota_credito(id_nota) ON DELETE CASCADE;


--
-- TOC entry 4374 (class 2606 OID 66976)
-- Name: nota_credito fk_nota_credito_ventas_id_venta_referencia; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.nota_credito
    ADD CONSTRAINT fk_nota_credito_ventas_id_venta_referencia FOREIGN KEY (id_venta_referencia) REFERENCES ventas.ventas(id_venta) ON DELETE CASCADE;


--
-- TOC entry 4385 (class 2606 OID 67020)
-- Name: nota_debito_detalle fk_nota_debito_detalle_detalle_venta_id_venta_detalle; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.nota_debito_detalle
    ADD CONSTRAINT fk_nota_debito_detalle_detalle_venta_id_venta_detalle FOREIGN KEY (id_venta_detalle) REFERENCES ventas.detalle_venta(id_detalle_venta);


--
-- TOC entry 4386 (class 2606 OID 67025)
-- Name: nota_debito_detalle fk_nota_debito_detalle_nota_debito_id_nota_debito; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.nota_debito_detalle
    ADD CONSTRAINT fk_nota_debito_detalle_nota_debito_id_nota_debito FOREIGN KEY (id_nota_debito) REFERENCES ventas.nota_debito(id_nota) ON DELETE CASCADE;


--
-- TOC entry 4378 (class 2606 OID 66989)
-- Name: nota_debito fk_nota_debito_ventas_id_venta_referencia; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.nota_debito
    ADD CONSTRAINT fk_nota_debito_ventas_id_venta_referencia FOREIGN KEY (id_venta_referencia) REFERENCES ventas.ventas(id_venta) ON DELETE CASCADE;


--
-- TOC entry 4341 (class 2606 OID 47162)
-- Name: pagos fk_pago_venta; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.pagos
    ADD CONSTRAINT fk_pago_venta FOREIGN KEY (id_venta) REFERENCES ventas.ventas(id_venta);


--
-- TOC entry 4345 (class 2606 OID 47167)
-- Name: ventas fk_venta_almacen; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.ventas
    ADD CONSTRAINT fk_venta_almacen FOREIGN KEY (id_almacen) REFERENCES inventario.almacenes(id_almacen);


--
-- TOC entry 4346 (class 2606 OID 47172)
-- Name: ventas fk_venta_caja; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.ventas
    ADD CONSTRAINT fk_venta_caja FOREIGN KEY (id_caja) REFERENCES ventas.cajas(id_caja);


--
-- TOC entry 4347 (class 2606 OID 47177)
-- Name: ventas fk_venta_cliente; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.ventas
    ADD CONSTRAINT fk_venta_cliente FOREIGN KEY (id_cliente) REFERENCES clientes.clientes(id_cliente);


--
-- TOC entry 4348 (class 2606 OID 47182)
-- Name: ventas fk_venta_estado; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.ventas
    ADD CONSTRAINT fk_venta_estado FOREIGN KEY (id_estado) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 4349 (class 2606 OID 47187)
-- Name: ventas fk_venta_estado_pago; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.ventas
    ADD CONSTRAINT fk_venta_estado_pago FOREIGN KEY (id_estado_pago) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 4350 (class 2606 OID 47192)
-- Name: ventas fk_venta_tipo_comprobante; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.ventas
    ADD CONSTRAINT fk_venta_tipo_comprobante FOREIGN KEY (id_tipo_comprobante) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 4342 (class 2606 OID 67086)
-- Name: pagos fk_ventas_pagos_metodo_config; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.pagos
    ADD CONSTRAINT fk_ventas_pagos_metodo_config FOREIGN KEY (id_metodo_pago) REFERENCES configuracion.metodos_pago(id_metodo_pago);


--
-- TOC entry 4344 (class 2606 OID 67359)
-- Name: ventas fk_ventas_tipo_operacion; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.ventas
    ADD CONSTRAINT fk_ventas_tipo_operacion FOREIGN KEY (id_tipo_operacion) REFERENCES configuracion.tipo_operacion_sunat(id_tipo_operacion);


--
-- TOC entry 4375 (class 2606 OID 67386)
-- Name: nota_credito nota_credito_id_estado_cpe_fkey; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.nota_credito
    ADD CONSTRAINT nota_credito_id_estado_cpe_fkey FOREIGN KEY (id_estado_cpe) REFERENCES sunat.cat_estado_cpe(id_estado);


--
-- TOC entry 4379 (class 2606 OID 67413)
-- Name: nota_debito nota_debito_id_estado_cpe_fkey; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.nota_debito
    ADD CONSTRAINT nota_debito_id_estado_cpe_fkey FOREIGN KEY (id_estado_cpe) REFERENCES sunat.cat_estado_cpe(id_estado);


--
-- TOC entry 4392 (class 2606 OID 67346)
-- Name: venta_cuota_pago venta_cuota_pago_id_venta_fkey; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.venta_cuota_pago
    ADD CONSTRAINT venta_cuota_pago_id_venta_fkey FOREIGN KEY (id_venta) REFERENCES ventas.ventas(id_venta);


--
-- TOC entry 4343 (class 2606 OID 67354)
-- Name: ventas ventas_id_estado_cpe_fkey; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.ventas
    ADD CONSTRAINT ventas_id_estado_cpe_fkey FOREIGN KEY (id_estado_cpe) REFERENCES sunat.cat_estado_cpe(id_estado);


-- Completed on 2026-04-02 17:59:28

--
-- PostgreSQL database dump complete
--

\unrestrict rp5Q9G3ovxVQT81Uzawt5e9zogHCF6BfHrQE93Hff5kpNCgVPAaGQTaEpNLJKzC

