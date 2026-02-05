--
--


-- Dumped by pg_dump version 18.1

-- Started on 2026-01-29 17:44:15

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5800 (class 1262 OID 16788)
--





SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 8 (class 2615 OID 19636)
-- Name: catalogo; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA catalogo;


ALTER SCHEMA catalogo OWNER TO postgres;

--
-- TOC entry 10 (class 2615 OID 19638)
-- Name: clientes; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA clientes;


ALTER SCHEMA clientes OWNER TO postgres;

--
-- TOC entry 11 (class 2615 OID 19639)
-- Name: compras; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA compras;


ALTER SCHEMA compras OWNER TO postgres;

--
-- TOC entry 6 (class 2615 OID 19634)
-- Name: configuracion; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA configuracion;


ALTER SCHEMA configuracion OWNER TO postgres;

--
-- TOC entry 13 (class 2615 OID 19641)
-- Name: contabilidad; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA contabilidad;


ALTER SCHEMA contabilidad OWNER TO postgres;

--
-- TOC entry 7 (class 2615 OID 19635)
-- Name: identidad; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA identidad;


ALTER SCHEMA identidad OWNER TO postgres;

--
-- TOC entry 9 (class 2615 OID 19637)
-- Name: inventario; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA inventario;


ALTER SCHEMA inventario OWNER TO postgres;

--
-- TOC entry 12 (class 2615 OID 19640)
-- Name: ventas; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA ventas;


ALTER SCHEMA ventas OWNER TO postgres;

--
-- TOC entry 321 (class 1255 OID 18604)
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
-- TOC entry 250 (class 1259 OID 19882)
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
-- TOC entry 249 (class 1259 OID 19881)
-- Name: categorias_id_categoria_seq; Type: SEQUENCE; Schema: catalogo; Owner: postgres
--

CREATE SEQUENCE catalogo.categorias_id_categoria_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE catalogo.categorias_id_categoria_seq OWNER TO postgres;

--
-- TOC entry 5801 (class 0 OID 0)
-- Dependencies: 249
-- Name: categorias_id_categoria_seq; Type: SEQUENCE OWNED BY; Schema: catalogo; Owner: postgres
--

ALTER SEQUENCE catalogo.categorias_id_categoria_seq OWNED BY catalogo.categorias.id_categoria;


--
-- TOC entry 264 (class 1259 OID 20056)
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
-- TOC entry 263 (class 1259 OID 20055)
-- Name: imagenes_producto_id_imagen_seq; Type: SEQUENCE; Schema: catalogo; Owner: postgres
--

CREATE SEQUENCE catalogo.imagenes_producto_id_imagen_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE catalogo.imagenes_producto_id_imagen_seq OWNER TO postgres;

--
-- TOC entry 5802 (class 0 OID 0)
-- Dependencies: 263
-- Name: imagenes_producto_id_imagen_seq; Type: SEQUENCE OWNED BY; Schema: catalogo; Owner: postgres
--

ALTER SEQUENCE catalogo.imagenes_producto_id_imagen_seq OWNED BY catalogo.imagenes_producto.id_imagen;


--
-- TOC entry 258 (class 1259 OID 19954)
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
-- TOC entry 257 (class 1259 OID 19953)
-- Name: listas_precios_id_lista_precio_seq; Type: SEQUENCE; Schema: catalogo; Owner: postgres
--

CREATE SEQUENCE catalogo.listas_precios_id_lista_precio_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE catalogo.listas_precios_id_lista_precio_seq OWNER TO postgres;

--
-- TOC entry 5803 (class 0 OID 0)
-- Dependencies: 257
-- Name: listas_precios_id_lista_precio_seq; Type: SEQUENCE OWNED BY; Schema: catalogo; Owner: postgres
--

ALTER SEQUENCE catalogo.listas_precios_id_lista_precio_seq OWNED BY catalogo.listas_precios.id_lista_precio;


--
-- TOC entry 252 (class 1259 OID 19904)
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
-- TOC entry 251 (class 1259 OID 19903)
-- Name: marcas_id_marca_seq; Type: SEQUENCE; Schema: catalogo; Owner: postgres
--

CREATE SEQUENCE catalogo.marcas_id_marca_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE catalogo.marcas_id_marca_seq OWNER TO postgres;

--
-- TOC entry 5804 (class 0 OID 0)
-- Dependencies: 251
-- Name: marcas_id_marca_seq; Type: SEQUENCE OWNED BY; Schema: catalogo; Owner: postgres
--

ALTER SEQUENCE catalogo.marcas_id_marca_seq OWNED BY catalogo.marcas.id_marca;


--
-- TOC entry 260 (class 1259 OID 19970)
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
    CONSTRAINT productos_precio_compra_check CHECK ((precio_compra >= (0)::numeric)),
    CONSTRAINT productos_precio_venta_distribuidor_check CHECK ((precio_venta_distribuidor >= (0)::numeric)),
    CONSTRAINT productos_precio_venta_mayorista_check CHECK ((precio_venta_mayorista >= (0)::numeric)),
    CONSTRAINT productos_precio_venta_publico_check CHECK ((precio_venta_publico >= (0)::numeric))
);


ALTER TABLE catalogo.productos OWNER TO postgres;

--
-- TOC entry 5805 (class 0 OID 0)
-- Dependencies: 260
-- Name: TABLE productos; Type: COMMENT; Schema: catalogo; Owner: postgres
--

COMMENT ON TABLE catalogo.productos IS 'Catálogo maestro de productos';


--
-- TOC entry 259 (class 1259 OID 19969)
-- Name: productos_id_producto_seq; Type: SEQUENCE; Schema: catalogo; Owner: postgres
--

CREATE SEQUENCE catalogo.productos_id_producto_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE catalogo.productos_id_producto_seq OWNER TO postgres;

--
-- TOC entry 5806 (class 0 OID 0)
-- Dependencies: 259
-- Name: productos_id_producto_seq; Type: SEQUENCE OWNED BY; Schema: catalogo; Owner: postgres
--

ALTER SEQUENCE catalogo.productos_id_producto_seq OWNED BY catalogo.productos.id_producto;


--
-- TOC entry 254 (class 1259 OID 19919)
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
-- TOC entry 253 (class 1259 OID 19918)
-- Name: unidades_medida_id_unidad_seq; Type: SEQUENCE; Schema: catalogo; Owner: postgres
--

CREATE SEQUENCE catalogo.unidades_medida_id_unidad_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE catalogo.unidades_medida_id_unidad_seq OWNER TO postgres;

--
-- TOC entry 5807 (class 0 OID 0)
-- Dependencies: 253
-- Name: unidades_medida_id_unidad_seq; Type: SEQUENCE OWNED BY; Schema: catalogo; Owner: postgres
--

ALTER SEQUENCE catalogo.unidades_medida_id_unidad_seq OWNED BY catalogo.unidades_medida.id_unidad;


--
-- TOC entry 262 (class 1259 OID 20029)
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
-- TOC entry 261 (class 1259 OID 20028)
-- Name: variantes_producto_id_variante_seq; Type: SEQUENCE; Schema: catalogo; Owner: postgres
--

CREATE SEQUENCE catalogo.variantes_producto_id_variante_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE catalogo.variantes_producto_id_variante_seq OWNER TO postgres;

--
-- TOC entry 5808 (class 0 OID 0)
-- Dependencies: 261
-- Name: variantes_producto_id_variante_seq; Type: SEQUENCE OWNED BY; Schema: catalogo; Owner: postgres
--

ALTER SEQUENCE catalogo.variantes_producto_id_variante_seq OWNED BY catalogo.variantes_producto.id_variante;


--
-- TOC entry 270 (class 1259 OID 20136)
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
    id_tipo_cliente bigint
);


ALTER TABLE clientes.clientes OWNER TO postgres;

--
-- TOC entry 269 (class 1259 OID 20135)
-- Name: clientes_id_cliente_seq; Type: SEQUENCE; Schema: clientes; Owner: postgres
--

CREATE SEQUENCE clientes.clientes_id_cliente_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE clientes.clientes_id_cliente_seq OWNER TO postgres;

--
-- TOC entry 5809 (class 0 OID 0)
-- Dependencies: 269
-- Name: clientes_id_cliente_seq; Type: SEQUENCE OWNED BY; Schema: clientes; Owner: postgres
--

ALTER SEQUENCE clientes.clientes_id_cliente_seq OWNED BY clientes.clientes.id_cliente;


--
-- TOC entry 272 (class 1259 OID 20166)
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
-- TOC entry 271 (class 1259 OID 20165)
-- Name: contactos_cliente_id_contacto_seq; Type: SEQUENCE; Schema: clientes; Owner: postgres
--

CREATE SEQUENCE clientes.contactos_cliente_id_contacto_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE clientes.contactos_cliente_id_contacto_seq OWNER TO postgres;

--
-- TOC entry 5810 (class 0 OID 0)
-- Dependencies: 271
-- Name: contactos_cliente_id_contacto_seq; Type: SEQUENCE OWNED BY; Schema: clientes; Owner: postgres
--

ALTER SEQUENCE clientes.contactos_cliente_id_contacto_seq OWNED BY clientes.contactos_cliente.id_contacto;


--
-- TOC entry 280 (class 1259 OID 20271)
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
    activado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_creacion character varying(100) NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion character varying(100),
    id_tipo_comprobante bigint,
    id_estado_pago bigint
);


ALTER TABLE compras.compras OWNER TO postgres;

--
-- TOC entry 279 (class 1259 OID 20270)
-- Name: compras_id_compra_seq; Type: SEQUENCE; Schema: compras; Owner: postgres
--

CREATE SEQUENCE compras.compras_id_compra_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE compras.compras_id_compra_seq OWNER TO postgres;

--
-- TOC entry 5811 (class 0 OID 0)
-- Dependencies: 279
-- Name: compras_id_compra_seq; Type: SEQUENCE OWNED BY; Schema: compras; Owner: postgres
--

ALTER SEQUENCE compras.compras_id_compra_seq OWNED BY compras.compras.id_compra;


--
-- TOC entry 282 (class 1259 OID 20308)
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
    subtotal numeric(12,2) NOT NULL
);


ALTER TABLE compras.detalle_compra OWNER TO postgres;

--
-- TOC entry 281 (class 1259 OID 20307)
-- Name: detalle_compra_id_detalle_compra_seq; Type: SEQUENCE; Schema: compras; Owner: postgres
--

CREATE SEQUENCE compras.detalle_compra_id_detalle_compra_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE compras.detalle_compra_id_detalle_compra_seq OWNER TO postgres;

--
-- TOC entry 5812 (class 0 OID 0)
-- Dependencies: 281
-- Name: detalle_compra_id_detalle_compra_seq; Type: SEQUENCE OWNED BY; Schema: compras; Owner: postgres
--

ALTER SEQUENCE compras.detalle_compra_id_detalle_compra_seq OWNED BY compras.detalle_compra.id_detalle_compra;


--
-- TOC entry 278 (class 1259 OID 20247)
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
    cantidad_recibida numeric(10,3) DEFAULT 0
);


ALTER TABLE compras.detalle_orden_compra OWNER TO postgres;

--
-- TOC entry 277 (class 1259 OID 20246)
-- Name: detalle_orden_compra_id_detalle_oc_seq; Type: SEQUENCE; Schema: compras; Owner: postgres
--

CREATE SEQUENCE compras.detalle_orden_compra_id_detalle_oc_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE compras.detalle_orden_compra_id_detalle_oc_seq OWNER TO postgres;

--
-- TOC entry 5813 (class 0 OID 0)
-- Dependencies: 277
-- Name: detalle_orden_compra_id_detalle_oc_seq; Type: SEQUENCE OWNED BY; Schema: compras; Owner: postgres
--

ALTER SEQUENCE compras.detalle_orden_compra_id_detalle_oc_seq OWNED BY compras.detalle_orden_compra.id_detalle_oc;


--
-- TOC entry 276 (class 1259 OID 20212)
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
    id_estado bigint
);


ALTER TABLE compras.ordenes_compra OWNER TO postgres;

--
-- TOC entry 275 (class 1259 OID 20211)
-- Name: ordenes_compra_id_orden_compra_seq; Type: SEQUENCE; Schema: compras; Owner: postgres
--

CREATE SEQUENCE compras.ordenes_compra_id_orden_compra_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE compras.ordenes_compra_id_orden_compra_seq OWNER TO postgres;

--
-- TOC entry 5814 (class 0 OID 0)
-- Dependencies: 275
-- Name: ordenes_compra_id_orden_compra_seq; Type: SEQUENCE OWNED BY; Schema: compras; Owner: postgres
--

ALTER SEQUENCE compras.ordenes_compra_id_orden_compra_seq OWNED BY compras.ordenes_compra.id_orden_compra;


--
-- TOC entry 274 (class 1259 OID 20190)
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
    id_tipo_documento bigint
);


ALTER TABLE compras.proveedores OWNER TO postgres;

--
-- TOC entry 273 (class 1259 OID 20189)
-- Name: proveedores_id_proveedor_seq; Type: SEQUENCE; Schema: compras; Owner: postgres
--

CREATE SEQUENCE compras.proveedores_id_proveedor_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE compras.proveedores_id_proveedor_seq OWNER TO postgres;

--
-- TOC entry 5815 (class 0 OID 0)
-- Dependencies: 273
-- Name: proveedores_id_proveedor_seq; Type: SEQUENCE OWNED BY; Schema: compras; Owner: postgres
--

ALTER SEQUENCE compras.proveedores_id_proveedor_seq OWNED BY compras.proveedores.id_proveedor;


--
-- TOC entry 231 (class 1259 OID 19666)
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
-- TOC entry 5816 (class 0 OID 0)
-- Dependencies: 231
-- Name: TABLE configuraciones; Type: COMMENT; Schema: configuracion; Owner: postgres
--

COMMENT ON TABLE configuracion.configuraciones IS 'Variables de configuración global del sistema';


--
-- TOC entry 230 (class 1259 OID 19665)
-- Name: configuraciones_id_configuracion_seq; Type: SEQUENCE; Schema: configuracion; Owner: postgres
--

CREATE SEQUENCE configuracion.configuraciones_id_configuracion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE configuracion.configuraciones_id_configuracion_seq OWNER TO postgres;

--
-- TOC entry 5817 (class 0 OID 0)
-- Dependencies: 230
-- Name: configuraciones_id_configuracion_seq; Type: SEQUENCE OWNED BY; Schema: configuracion; Owner: postgres
--

ALTER SEQUENCE configuracion.configuraciones_id_configuracion_seq OWNED BY configuracion.configuraciones.id_configuracion;


--
-- TOC entry 229 (class 1259 OID 19643)
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
-- TOC entry 5818 (class 0 OID 0)
-- Dependencies: 229
-- Name: TABLE empresa; Type: COMMENT; Schema: configuracion; Owner: postgres
--

COMMENT ON TABLE configuracion.empresa IS 'Datos generales de la empresa emisora';


--
-- TOC entry 228 (class 1259 OID 19642)
-- Name: empresa_id_empresa_seq; Type: SEQUENCE; Schema: configuracion; Owner: postgres
--

CREATE SEQUENCE configuracion.empresa_id_empresa_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE configuracion.empresa_id_empresa_seq OWNER TO postgres;

--
-- TOC entry 5819 (class 0 OID 0)
-- Dependencies: 228
-- Name: empresa_id_empresa_seq; Type: SEQUENCE OWNED BY; Schema: configuracion; Owner: postgres
--

ALTER SEQUENCE configuracion.empresa_id_empresa_seq OWNED BY configuracion.empresa.id_empresa;


--
-- TOC entry 233 (class 1259 OID 19686)
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
-- TOC entry 5820 (class 0 OID 0)
-- Dependencies: 233
-- Name: TABLE series_comprobantes; Type: COMMENT; Schema: configuracion; Owner: postgres
--

COMMENT ON TABLE configuracion.series_comprobantes IS 'Gestión de series y correlativos para facturación';


--
-- TOC entry 232 (class 1259 OID 19685)
-- Name: series_comprobantes_id_serie_seq; Type: SEQUENCE; Schema: configuracion; Owner: postgres
--

CREATE SEQUENCE configuracion.series_comprobantes_id_serie_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE configuracion.series_comprobantes_id_serie_seq OWNER TO postgres;

--
-- TOC entry 5821 (class 0 OID 0)
-- Dependencies: 232
-- Name: series_comprobantes_id_serie_seq; Type: SEQUENCE OWNED BY; Schema: configuracion; Owner: postgres
--

ALTER SEQUENCE configuracion.series_comprobantes_id_serie_seq OWNED BY configuracion.series_comprobantes.id_serie;


--
-- TOC entry 308 (class 1259 OID 20673)
-- Name: tablas_generales; Type: TABLE; Schema: configuracion; Owner: postgres
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


ALTER TABLE configuracion.tablas_generales OWNER TO postgres;

--
-- TOC entry 310 (class 1259 OID 20694)
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
    usuario_creacion character varying(50) NOT NULL,
    fecha_modificacion timestamp with time zone,
    usuario_modificacion character varying(50),
    activado boolean DEFAULT true NOT NULL
);


ALTER TABLE configuracion.tablas_generales_detalle OWNER TO postgres;

--
-- TOC entry 309 (class 1259 OID 20693)
-- Name: tablas_generales_detalle_id_detalle_seq; Type: SEQUENCE; Schema: configuracion; Owner: postgres
--

CREATE SEQUENCE configuracion.tablas_generales_detalle_id_detalle_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE configuracion.tablas_generales_detalle_id_detalle_seq OWNER TO postgres;

--
-- TOC entry 5822 (class 0 OID 0)
-- Dependencies: 309
-- Name: tablas_generales_detalle_id_detalle_seq; Type: SEQUENCE OWNED BY; Schema: configuracion; Owner: postgres
--

ALTER SEQUENCE configuracion.tablas_generales_detalle_id_detalle_seq OWNED BY configuracion.tablas_generales_detalle.id_detalle;


--
-- TOC entry 307 (class 1259 OID 20672)
-- Name: tablas_generales_id_tabla_seq; Type: SEQUENCE; Schema: configuracion; Owner: postgres
--

CREATE SEQUENCE configuracion.tablas_generales_id_tabla_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE configuracion.tablas_generales_id_tabla_seq OWNER TO postgres;

--
-- TOC entry 5823 (class 0 OID 0)
-- Dependencies: 307
-- Name: tablas_generales_id_tabla_seq; Type: SEQUENCE OWNED BY; Schema: configuracion; Owner: postgres
--

ALTER SEQUENCE configuracion.tablas_generales_id_tabla_seq OWNED BY configuracion.tablas_generales.id_tabla;


--
-- TOC entry 304 (class 1259 OID 20619)
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
-- TOC entry 303 (class 1259 OID 20618)
-- Name: asientos_contables_id_asiento_seq; Type: SEQUENCE; Schema: contabilidad; Owner: postgres
--

CREATE SEQUENCE contabilidad.asientos_contables_id_asiento_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE contabilidad.asientos_contables_id_asiento_seq OWNER TO postgres;

--
-- TOC entry 5824 (class 0 OID 0)
-- Dependencies: 303
-- Name: asientos_contables_id_asiento_seq; Type: SEQUENCE OWNED BY; Schema: contabilidad; Owner: postgres
--

ALTER SEQUENCE contabilidad.asientos_contables_id_asiento_seq OWNED BY contabilidad.asientos_contables.id_asiento;


--
-- TOC entry 302 (class 1259 OID 20601)
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
-- TOC entry 301 (class 1259 OID 20600)
-- Name: centros_costo_id_centro_costo_seq; Type: SEQUENCE; Schema: contabilidad; Owner: postgres
--

CREATE SEQUENCE contabilidad.centros_costo_id_centro_costo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE contabilidad.centros_costo_id_centro_costo_seq OWNER TO postgres;

--
-- TOC entry 5825 (class 0 OID 0)
-- Dependencies: 301
-- Name: centros_costo_id_centro_costo_seq; Type: SEQUENCE OWNED BY; Schema: contabilidad; Owner: postgres
--

ALTER SEQUENCE contabilidad.centros_costo_id_centro_costo_seq OWNED BY contabilidad.centros_costo.id_centro_costo;


--
-- TOC entry 306 (class 1259 OID 20643)
-- Name: detalle_asiento; Type: TABLE; Schema: contabilidad; Owner: postgres
--

CREATE TABLE contabilidad.detalle_asiento (
    id_detalle_asiento bigint NOT NULL,
    id_asiento bigint NOT NULL,
    id_cuenta bigint NOT NULL,
    id_centro_costo bigint,
    debe numeric(12,2) DEFAULT 0,
    haber numeric(12,2) DEFAULT 0,
    referencia_doc character varying(50)
);


ALTER TABLE contabilidad.detalle_asiento OWNER TO postgres;

--
-- TOC entry 305 (class 1259 OID 20642)
-- Name: detalle_asiento_id_detalle_asiento_seq; Type: SEQUENCE; Schema: contabilidad; Owner: postgres
--

CREATE SEQUENCE contabilidad.detalle_asiento_id_detalle_asiento_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE contabilidad.detalle_asiento_id_detalle_asiento_seq OWNER TO postgres;

--
-- TOC entry 5826 (class 0 OID 0)
-- Dependencies: 305
-- Name: detalle_asiento_id_detalle_asiento_seq; Type: SEQUENCE OWNED BY; Schema: contabilidad; Owner: postgres
--

ALTER SEQUENCE contabilidad.detalle_asiento_id_detalle_asiento_seq OWNED BY contabilidad.detalle_asiento.id_detalle_asiento;


--
-- TOC entry 300 (class 1259 OID 20571)
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
-- TOC entry 299 (class 1259 OID 20570)
-- Name: plan_cuentas_id_cuenta_seq; Type: SEQUENCE; Schema: contabilidad; Owner: postgres
--

CREATE SEQUENCE contabilidad.plan_cuentas_id_cuenta_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE contabilidad.plan_cuentas_id_cuenta_seq OWNER TO postgres;

--
-- TOC entry 5827 (class 0 OID 0)
-- Dependencies: 299
-- Name: plan_cuentas_id_cuenta_seq; Type: SEQUENCE OWNED BY; Schema: contabilidad; Owner: postgres
--

ALTER SEQUENCE contabilidad.plan_cuentas_id_cuenta_seq OWNED BY contabilidad.plan_cuentas.id_cuenta;


--
-- TOC entry 244 (class 1259 OID 19813)
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
-- TOC entry 243 (class 1259 OID 19812)
-- Name: areas_id_area_seq; Type: SEQUENCE; Schema: identidad; Owner: postgres
--

CREATE SEQUENCE identidad.areas_id_area_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE identidad.areas_id_area_seq OWNER TO postgres;

--
-- TOC entry 5828 (class 0 OID 0)
-- Dependencies: 243
-- Name: areas_id_area_seq; Type: SEQUENCE OWNED BY; Schema: identidad; Owner: postgres
--

ALTER SEQUENCE identidad.areas_id_area_seq OWNED BY identidad.areas.id_area;


--
-- TOC entry 242 (class 1259 OID 19799)
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
-- TOC entry 241 (class 1259 OID 19798)
-- Name: auditoria_accesos_id_auditoria_seq; Type: SEQUENCE; Schema: identidad; Owner: postgres
--

CREATE SEQUENCE identidad.auditoria_accesos_id_auditoria_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE identidad.auditoria_accesos_id_auditoria_seq OWNER TO postgres;

--
-- TOC entry 5829 (class 0 OID 0)
-- Dependencies: 241
-- Name: auditoria_accesos_id_auditoria_seq; Type: SEQUENCE OWNED BY; Schema: identidad; Owner: postgres
--

ALTER SEQUENCE identidad.auditoria_accesos_id_auditoria_seq OWNED BY identidad.auditoria_accesos.id_auditoria;


--
-- TOC entry 246 (class 1259 OID 19828)
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
-- TOC entry 245 (class 1259 OID 19827)
-- Name: cargos_id_cargo_seq; Type: SEQUENCE; Schema: identidad; Owner: postgres
--

CREATE SEQUENCE identidad.cargos_id_cargo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE identidad.cargos_id_cargo_seq OWNER TO postgres;

--
-- TOC entry 5830 (class 0 OID 0)
-- Dependencies: 245
-- Name: cargos_id_cargo_seq; Type: SEQUENCE OWNED BY; Schema: identidad; Owner: postgres
--

ALTER SEQUENCE identidad.cargos_id_cargo_seq OWNED BY identidad.cargos.id_cargo;


--
-- TOC entry 312 (class 1259 OID 21093)
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
-- TOC entry 311 (class 1259 OID 21092)
-- Name: menus_id_menu_seq; Type: SEQUENCE; Schema: identidad; Owner: postgres
--

CREATE SEQUENCE identidad.menus_id_menu_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE identidad.menus_id_menu_seq OWNER TO postgres;

--
-- TOC entry 5831 (class 0 OID 0)
-- Dependencies: 311
-- Name: menus_id_menu_seq; Type: SEQUENCE OWNED BY; Schema: identidad; Owner: postgres
--

ALTER SEQUENCE identidad.menus_id_menu_seq OWNED BY identidad.menus.id_menu;


--
-- TOC entry 239 (class 1259 OID 19757)
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
-- TOC entry 238 (class 1259 OID 19756)
-- Name: permisos_id_permiso_seq; Type: SEQUENCE; Schema: identidad; Owner: postgres
--

CREATE SEQUENCE identidad.permisos_id_permiso_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE identidad.permisos_id_permiso_seq OWNER TO postgres;

--
-- TOC entry 5832 (class 0 OID 0)
-- Dependencies: 238
-- Name: permisos_id_permiso_seq; Type: SEQUENCE OWNED BY; Schema: identidad; Owner: postgres
--

ALTER SEQUENCE identidad.permisos_id_permiso_seq OWNED BY identidad.permisos.id_permiso;


--
-- TOC entry 235 (class 1259 OID 19707)
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
-- TOC entry 5833 (class 0 OID 0)
-- Dependencies: 235
-- Name: TABLE roles; Type: COMMENT; Schema: identidad; Owner: postgres
--

COMMENT ON TABLE identidad.roles IS 'Roles de usuario (ej: Admin, Cajero)';


--
-- TOC entry 234 (class 1259 OID 19706)
-- Name: roles_id_rol_seq; Type: SEQUENCE; Schema: identidad; Owner: postgres
--

CREATE SEQUENCE identidad.roles_id_rol_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE identidad.roles_id_rol_seq OWNER TO postgres;

--
-- TOC entry 5834 (class 0 OID 0)
-- Dependencies: 234
-- Name: roles_id_rol_seq; Type: SEQUENCE OWNED BY; Schema: identidad; Owner: postgres
--

ALTER SEQUENCE identidad.roles_id_rol_seq OWNED BY identidad.roles.id_rol;


--
-- TOC entry 316 (class 1259 OID 21140)
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
-- TOC entry 315 (class 1259 OID 21139)
-- Name: roles_menus_id_rol_menu_seq; Type: SEQUENCE; Schema: identidad; Owner: postgres
--

CREATE SEQUENCE identidad.roles_menus_id_rol_menu_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE identidad.roles_menus_id_rol_menu_seq OWNER TO postgres;

--
-- TOC entry 5835 (class 0 OID 0)
-- Dependencies: 315
-- Name: roles_menus_id_rol_menu_seq; Type: SEQUENCE OWNED BY; Schema: identidad; Owner: postgres
--

ALTER SEQUENCE identidad.roles_menus_id_rol_menu_seq OWNED BY identidad.roles_menus.id_rol_menu;


--
-- TOC entry 318 (class 1259 OID 21168)
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
-- TOC entry 317 (class 1259 OID 21167)
-- Name: roles_menus_permisos_id_rol_menu_permiso_seq; Type: SEQUENCE; Schema: identidad; Owner: postgres
--

CREATE SEQUENCE identidad.roles_menus_permisos_id_rol_menu_permiso_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE identidad.roles_menus_permisos_id_rol_menu_permiso_seq OWNER TO postgres;

--
-- TOC entry 5836 (class 0 OID 0)
-- Dependencies: 317
-- Name: roles_menus_permisos_id_rol_menu_permiso_seq; Type: SEQUENCE OWNED BY; Schema: identidad; Owner: postgres
--

ALTER SEQUENCE identidad.roles_menus_permisos_id_rol_menu_permiso_seq OWNED BY identidad.roles_menus_permisos.id_rol_menu_permiso;


--
-- TOC entry 240 (class 1259 OID 19775)
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
-- TOC entry 314 (class 1259 OID 21120)
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
-- TOC entry 313 (class 1259 OID 21119)
-- Name: tipos_permiso_id_tipo_permiso_seq; Type: SEQUENCE; Schema: identidad; Owner: postgres
--

CREATE SEQUENCE identidad.tipos_permiso_id_tipo_permiso_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE identidad.tipos_permiso_id_tipo_permiso_seq OWNER TO postgres;

--
-- TOC entry 5837 (class 0 OID 0)
-- Dependencies: 313
-- Name: tipos_permiso_id_tipo_permiso_seq; Type: SEQUENCE OWNED BY; Schema: identidad; Owner: postgres
--

ALTER SEQUENCE identidad.tipos_permiso_id_tipo_permiso_seq OWNED BY identidad.tipos_permiso.id_tipo_permiso;


--
-- TOC entry 248 (class 1259 OID 19848)
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
-- TOC entry 247 (class 1259 OID 19847)
-- Name: trabajadores_id_trabajador_seq; Type: SEQUENCE; Schema: identidad; Owner: postgres
--

CREATE SEQUENCE identidad.trabajadores_id_trabajador_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE identidad.trabajadores_id_trabajador_seq OWNER TO postgres;

--
-- TOC entry 5838 (class 0 OID 0)
-- Dependencies: 247
-- Name: trabajadores_id_trabajador_seq; Type: SEQUENCE OWNED BY; Schema: identidad; Owner: postgres
--

ALTER SEQUENCE identidad.trabajadores_id_trabajador_seq OWNED BY identidad.trabajadores.id_trabajador;


--
-- TOC entry 237 (class 1259 OID 19726)
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
-- TOC entry 5839 (class 0 OID 0)
-- Dependencies: 237
-- Name: TABLE usuarios; Type: COMMENT; Schema: identidad; Owner: postgres
--

COMMENT ON TABLE identidad.usuarios IS 'Usuarios del sistema con acceso al backend';


--
-- TOC entry 236 (class 1259 OID 19725)
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE; Schema: identidad; Owner: postgres
--

CREATE SEQUENCE identidad.usuarios_id_usuario_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE identidad.usuarios_id_usuario_seq OWNER TO postgres;

--
-- TOC entry 5840 (class 0 OID 0)
-- Dependencies: 236
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE OWNED BY; Schema: identidad; Owner: postgres
--

ALTER SEQUENCE identidad.usuarios_id_usuario_seq OWNED BY identidad.usuarios.id_usuario;


--
-- TOC entry 320 (class 1259 OID 21196)
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
-- TOC entry 319 (class 1259 OID 21195)
-- Name: usuarios_roles_id_usuario_rol_seq; Type: SEQUENCE; Schema: identidad; Owner: postgres
--

CREATE SEQUENCE identidad.usuarios_roles_id_usuario_rol_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE identidad.usuarios_roles_id_usuario_rol_seq OWNER TO postgres;

--
-- TOC entry 5841 (class 0 OID 0)
-- Dependencies: 319
-- Name: usuarios_roles_id_usuario_rol_seq; Type: SEQUENCE OWNED BY; Schema: identidad; Owner: postgres
--

ALTER SEQUENCE identidad.usuarios_roles_id_usuario_rol_seq OWNED BY identidad.usuarios_roles.id_usuario_rol;


--
-- TOC entry 256 (class 1259 OID 19935)
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
    usuario_modificacion character varying(100)
);


ALTER TABLE inventario.almacenes OWNER TO postgres;

--
-- TOC entry 255 (class 1259 OID 19934)
-- Name: almacenes_id_almacen_seq; Type: SEQUENCE; Schema: inventario; Owner: postgres
--

CREATE SEQUENCE inventario.almacenes_id_almacen_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE inventario.almacenes_id_almacen_seq OWNER TO postgres;

--
-- TOC entry 5842 (class 0 OID 0)
-- Dependencies: 255
-- Name: almacenes_id_almacen_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: postgres
--

ALTER SEQUENCE inventario.almacenes_id_almacen_seq OWNED BY inventario.almacenes.id_almacen;


--
-- TOC entry 268 (class 1259 OID 20112)
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
    id_tipo_movimiento bigint
);


ALTER TABLE inventario.movimientos_inventario OWNER TO postgres;

--
-- TOC entry 267 (class 1259 OID 20111)
-- Name: movimientos_inventario_id_movimiento_seq; Type: SEQUENCE; Schema: inventario; Owner: postgres
--

CREATE SEQUENCE inventario.movimientos_inventario_id_movimiento_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE inventario.movimientos_inventario_id_movimiento_seq OWNER TO postgres;

--
-- TOC entry 5843 (class 0 OID 0)
-- Dependencies: 267
-- Name: movimientos_inventario_id_movimiento_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: postgres
--

ALTER SEQUENCE inventario.movimientos_inventario_id_movimiento_seq OWNED BY inventario.movimientos_inventario.id_movimiento;


--
-- TOC entry 266 (class 1259 OID 20081)
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
    usuario_modificacion character varying(100)
);


ALTER TABLE inventario.stock OWNER TO postgres;

--
-- TOC entry 265 (class 1259 OID 20080)
-- Name: stock_id_stock_seq; Type: SEQUENCE; Schema: inventario; Owner: postgres
--

CREATE SEQUENCE inventario.stock_id_stock_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE inventario.stock_id_stock_seq OWNER TO postgres;

--
-- TOC entry 5844 (class 0 OID 0)
-- Dependencies: 265
-- Name: stock_id_stock_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: postgres
--

ALTER SEQUENCE inventario.stock_id_stock_seq OWNED BY inventario.stock.id_stock;


--
-- TOC entry 227 (class 1259 OID 16789)
-- Name: __EFMigrationsHistory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."__EFMigrationsHistory" (
    migration_id character varying(150) CONSTRAINT "__EFMigrationsHistory_MigrationId_not_null" NOT NULL,
    product_version character varying(32) CONSTRAINT "__EFMigrationsHistory_ProductVersion_not_null" NOT NULL
);


ALTER TABLE public."__EFMigrationsHistory" OWNER TO postgres;

--
-- TOC entry 284 (class 1259 OID 20331)
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
-- TOC entry 283 (class 1259 OID 20330)
-- Name: cajas_id_caja_seq; Type: SEQUENCE; Schema: ventas; Owner: postgres
--

CREATE SEQUENCE ventas.cajas_id_caja_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ventas.cajas_id_caja_seq OWNER TO postgres;

--
-- TOC entry 5845 (class 0 OID 0)
-- Dependencies: 283
-- Name: cajas_id_caja_seq; Type: SEQUENCE OWNED BY; Schema: ventas; Owner: postgres
--

ALTER SEQUENCE ventas.cajas_id_caja_seq OWNED BY ventas.cajas.id_caja;


--
-- TOC entry 286 (class 1259 OID 20356)
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
-- TOC entry 285 (class 1259 OID 20355)
-- Name: cotizaciones_id_cotizacion_seq; Type: SEQUENCE; Schema: ventas; Owner: postgres
--

CREATE SEQUENCE ventas.cotizaciones_id_cotizacion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ventas.cotizaciones_id_cotizacion_seq OWNER TO postgres;

--
-- TOC entry 5846 (class 0 OID 0)
-- Dependencies: 285
-- Name: cotizaciones_id_cotizacion_seq; Type: SEQUENCE OWNED BY; Schema: ventas; Owner: postgres
--

ALTER SEQUENCE ventas.cotizaciones_id_cotizacion_seq OWNED BY ventas.cotizaciones.id_cotizacion;


--
-- TOC entry 288 (class 1259 OID 20395)
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
    subtotal numeric(12,2) NOT NULL
);


ALTER TABLE ventas.detalle_cotizacion OWNER TO postgres;

--
-- TOC entry 287 (class 1259 OID 20394)
-- Name: detalle_cotizacion_id_detalle_cot_seq; Type: SEQUENCE; Schema: ventas; Owner: postgres
--

CREATE SEQUENCE ventas.detalle_cotizacion_id_detalle_cot_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ventas.detalle_cotizacion_id_detalle_cot_seq OWNER TO postgres;

--
-- TOC entry 5847 (class 0 OID 0)
-- Dependencies: 287
-- Name: detalle_cotizacion_id_detalle_cot_seq; Type: SEQUENCE OWNED BY; Schema: ventas; Owner: postgres
--

ALTER SEQUENCE ventas.detalle_cotizacion_id_detalle_cot_seq OWNED BY ventas.detalle_cotizacion.id_detalle_cot;


--
-- TOC entry 292 (class 1259 OID 20475)
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
    total_item numeric(12,2) NOT NULL
);


ALTER TABLE ventas.detalle_venta OWNER TO postgres;

--
-- TOC entry 291 (class 1259 OID 20474)
-- Name: detalle_venta_id_detalle_venta_seq; Type: SEQUENCE; Schema: ventas; Owner: postgres
--

CREATE SEQUENCE ventas.detalle_venta_id_detalle_venta_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ventas.detalle_venta_id_detalle_venta_seq OWNER TO postgres;

--
-- TOC entry 5848 (class 0 OID 0)
-- Dependencies: 291
-- Name: detalle_venta_id_detalle_venta_seq; Type: SEQUENCE OWNED BY; Schema: ventas; Owner: postgres
--

ALTER SEQUENCE ventas.detalle_venta_id_detalle_venta_seq OWNED BY ventas.detalle_venta.id_detalle_venta;


--
-- TOC entry 294 (class 1259 OID 20500)
-- Name: metodos_pago; Type: TABLE; Schema: ventas; Owner: postgres
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


ALTER TABLE ventas.metodos_pago OWNER TO postgres;

--
-- TOC entry 293 (class 1259 OID 20499)
-- Name: metodos_pago_id_metodo_pago_seq; Type: SEQUENCE; Schema: ventas; Owner: postgres
--

CREATE SEQUENCE ventas.metodos_pago_id_metodo_pago_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ventas.metodos_pago_id_metodo_pago_seq OWNER TO postgres;

--
-- TOC entry 5849 (class 0 OID 0)
-- Dependencies: 293
-- Name: metodos_pago_id_metodo_pago_seq; Type: SEQUENCE OWNED BY; Schema: ventas; Owner: postgres
--

ALTER SEQUENCE ventas.metodos_pago_id_metodo_pago_seq OWNED BY ventas.metodos_pago.id_metodo_pago;


--
-- TOC entry 298 (class 1259 OID 20546)
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
    id_tipo_movimiento bigint
);


ALTER TABLE ventas.movimientos_caja OWNER TO postgres;

--
-- TOC entry 297 (class 1259 OID 20545)
-- Name: movimientos_caja_id_movimiento_caja_seq; Type: SEQUENCE; Schema: ventas; Owner: postgres
--

CREATE SEQUENCE ventas.movimientos_caja_id_movimiento_caja_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ventas.movimientos_caja_id_movimiento_caja_seq OWNER TO postgres;

--
-- TOC entry 5850 (class 0 OID 0)
-- Dependencies: 297
-- Name: movimientos_caja_id_movimiento_caja_seq; Type: SEQUENCE OWNED BY; Schema: ventas; Owner: postgres
--

ALTER SEQUENCE ventas.movimientos_caja_id_movimiento_caja_seq OWNED BY ventas.movimientos_caja.id_movimiento_caja;


--
-- TOC entry 296 (class 1259 OID 20519)
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
    usuario_creacion character varying(100) NOT NULL
);


ALTER TABLE ventas.pagos OWNER TO postgres;

--
-- TOC entry 295 (class 1259 OID 20518)
-- Name: pagos_id_pago_seq; Type: SEQUENCE; Schema: ventas; Owner: postgres
--

CREATE SEQUENCE ventas.pagos_id_pago_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ventas.pagos_id_pago_seq OWNER TO postgres;

--
-- TOC entry 5851 (class 0 OID 0)
-- Dependencies: 295
-- Name: pagos_id_pago_seq; Type: SEQUENCE OWNED BY; Schema: ventas; Owner: postgres
--

ALTER SEQUENCE ventas.pagos_id_pago_seq OWNED BY ventas.pagos.id_pago;


--
-- TOC entry 290 (class 1259 OID 20420)
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


ALTER TABLE ventas.ventas OWNER TO postgres;

--
-- TOC entry 289 (class 1259 OID 20419)
-- Name: ventas_id_venta_seq; Type: SEQUENCE; Schema: ventas; Owner: postgres
--

CREATE SEQUENCE ventas.ventas_id_venta_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ventas.ventas_id_venta_seq OWNER TO postgres;

--
-- TOC entry 5852 (class 0 OID 0)
-- Dependencies: 289
-- Name: ventas_id_venta_seq; Type: SEQUENCE OWNED BY; Schema: ventas; Owner: postgres
--

ALTER SEQUENCE ventas.ventas_id_venta_seq OWNED BY ventas.ventas.id_venta;


--
-- TOC entry 5141 (class 2604 OID 19885)
-- Name: categorias id_categoria; Type: DEFAULT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.categorias ALTER COLUMN id_categoria SET DEFAULT nextval('catalogo.categorias_id_categoria_seq'::regclass);


--
-- TOC entry 5181 (class 2604 OID 20059)
-- Name: imagenes_producto id_imagen; Type: DEFAULT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.imagenes_producto ALTER COLUMN id_imagen SET DEFAULT nextval('catalogo.imagenes_producto_id_imagen_seq'::regclass);


--
-- TOC entry 5158 (class 2604 OID 19957)
-- Name: listas_precios id_lista_precio; Type: DEFAULT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.listas_precios ALTER COLUMN id_lista_precio SET DEFAULT nextval('catalogo.listas_precios_id_lista_precio_seq'::regclass);


--
-- TOC entry 5145 (class 2604 OID 19907)
-- Name: marcas id_marca; Type: DEFAULT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.marcas ALTER COLUMN id_marca SET DEFAULT nextval('catalogo.marcas_id_marca_seq'::regclass);


--
-- TOC entry 5163 (class 2604 OID 19973)
-- Name: productos id_producto; Type: DEFAULT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.productos ALTER COLUMN id_producto SET DEFAULT nextval('catalogo.productos_id_producto_seq'::regclass);


--
-- TOC entry 5149 (class 2604 OID 19922)
-- Name: unidades_medida id_unidad; Type: DEFAULT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.unidades_medida ALTER COLUMN id_unidad SET DEFAULT nextval('catalogo.unidades_medida_id_unidad_seq'::regclass);


--
-- TOC entry 5176 (class 2604 OID 20032)
-- Name: variantes_producto id_variante; Type: DEFAULT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.variantes_producto ALTER COLUMN id_variante SET DEFAULT nextval('catalogo.variantes_producto_id_variante_seq'::regclass);


--
-- TOC entry 5193 (class 2604 OID 20139)
-- Name: clientes id_cliente; Type: DEFAULT; Schema: clientes; Owner: postgres
--

ALTER TABLE ONLY clientes.clientes ALTER COLUMN id_cliente SET DEFAULT nextval('clientes.clientes_id_cliente_seq'::regclass);


--
-- TOC entry 5199 (class 2604 OID 20169)
-- Name: contactos_cliente id_contacto; Type: DEFAULT; Schema: clientes; Owner: postgres
--

ALTER TABLE ONLY clientes.contactos_cliente ALTER COLUMN id_contacto SET DEFAULT nextval('clientes.contactos_cliente_id_contacto_seq'::regclass);


--
-- TOC entry 5215 (class 2604 OID 20274)
-- Name: compras id_compra; Type: DEFAULT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.compras ALTER COLUMN id_compra SET DEFAULT nextval('compras.compras_id_compra_seq'::regclass);


--
-- TOC entry 5224 (class 2604 OID 20311)
-- Name: detalle_compra id_detalle_compra; Type: DEFAULT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.detalle_compra ALTER COLUMN id_detalle_compra SET DEFAULT nextval('compras.detalle_compra_id_detalle_compra_seq'::regclass);


--
-- TOC entry 5213 (class 2604 OID 20250)
-- Name: detalle_orden_compra id_detalle_oc; Type: DEFAULT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.detalle_orden_compra ALTER COLUMN id_detalle_oc SET DEFAULT nextval('compras.detalle_orden_compra_id_detalle_oc_seq'::regclass);


--
-- TOC entry 5208 (class 2604 OID 20215)
-- Name: ordenes_compra id_orden_compra; Type: DEFAULT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.ordenes_compra ALTER COLUMN id_orden_compra SET DEFAULT nextval('compras.ordenes_compra_id_orden_compra_seq'::regclass);


--
-- TOC entry 5204 (class 2604 OID 20193)
-- Name: proveedores id_proveedor; Type: DEFAULT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.proveedores ALTER COLUMN id_proveedor SET DEFAULT nextval('compras.proveedores_id_proveedor_seq'::regclass);


--
-- TOC entry 5103 (class 2604 OID 19669)
-- Name: configuraciones id_configuracion; Type: DEFAULT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.configuraciones ALTER COLUMN id_configuracion SET DEFAULT nextval('configuracion.configuraciones_id_configuracion_seq'::regclass);


--
-- TOC entry 5098 (class 2604 OID 19646)
-- Name: empresa id_empresa; Type: DEFAULT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.empresa ALTER COLUMN id_empresa SET DEFAULT nextval('configuracion.empresa_id_empresa_seq'::regclass);


--
-- TOC entry 5107 (class 2604 OID 19689)
-- Name: series_comprobantes id_serie; Type: DEFAULT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.series_comprobantes ALTER COLUMN id_serie SET DEFAULT nextval('configuracion.series_comprobantes_id_serie_seq'::regclass);


--
-- TOC entry 5289 (class 2604 OID 20676)
-- Name: tablas_generales id_tabla; Type: DEFAULT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.tablas_generales ALTER COLUMN id_tabla SET DEFAULT nextval('configuracion.tablas_generales_id_tabla_seq'::regclass);


--
-- TOC entry 5293 (class 2604 OID 20697)
-- Name: tablas_generales_detalle id_detalle; Type: DEFAULT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.tablas_generales_detalle ALTER COLUMN id_detalle SET DEFAULT nextval('configuracion.tablas_generales_detalle_id_detalle_seq'::regclass);


--
-- TOC entry 5280 (class 2604 OID 20622)
-- Name: asientos_contables id_asiento; Type: DEFAULT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.asientos_contables ALTER COLUMN id_asiento SET DEFAULT nextval('contabilidad.asientos_contables_id_asiento_seq'::regclass);


--
-- TOC entry 5276 (class 2604 OID 20604)
-- Name: centros_costo id_centro_costo; Type: DEFAULT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.centros_costo ALTER COLUMN id_centro_costo SET DEFAULT nextval('contabilidad.centros_costo_id_centro_costo_seq'::regclass);


--
-- TOC entry 5286 (class 2604 OID 20646)
-- Name: detalle_asiento id_detalle_asiento; Type: DEFAULT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.detalle_asiento ALTER COLUMN id_detalle_asiento SET DEFAULT nextval('contabilidad.detalle_asiento_id_detalle_asiento_seq'::regclass);


--
-- TOC entry 5270 (class 2604 OID 20574)
-- Name: plan_cuentas id_cuenta; Type: DEFAULT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.plan_cuentas ALTER COLUMN id_cuenta SET DEFAULT nextval('contabilidad.plan_cuentas_id_cuenta_seq'::regclass);


--
-- TOC entry 5129 (class 2604 OID 19816)
-- Name: areas id_area; Type: DEFAULT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.areas ALTER COLUMN id_area SET DEFAULT nextval('identidad.areas_id_area_seq'::regclass);


--
-- TOC entry 5127 (class 2604 OID 19802)
-- Name: auditoria_accesos id_auditoria; Type: DEFAULT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.auditoria_accesos ALTER COLUMN id_auditoria SET DEFAULT nextval('identidad.auditoria_accesos_id_auditoria_seq'::regclass);


--
-- TOC entry 5133 (class 2604 OID 19831)
-- Name: cargos id_cargo; Type: DEFAULT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.cargos ALTER COLUMN id_cargo SET DEFAULT nextval('identidad.cargos_id_cargo_seq'::regclass);


--
-- TOC entry 5298 (class 2604 OID 21096)
-- Name: menus id_menu; Type: DEFAULT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.menus ALTER COLUMN id_menu SET DEFAULT nextval('identidad.menus_id_menu_seq'::regclass);


--
-- TOC entry 5120 (class 2604 OID 19760)
-- Name: permisos id_permiso; Type: DEFAULT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.permisos ALTER COLUMN id_permiso SET DEFAULT nextval('identidad.permisos_id_permiso_seq'::regclass);


--
-- TOC entry 5112 (class 2604 OID 19710)
-- Name: roles id_rol; Type: DEFAULT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.roles ALTER COLUMN id_rol SET DEFAULT nextval('identidad.roles_id_rol_seq'::regclass);


--
-- TOC entry 5307 (class 2604 OID 21143)
-- Name: roles_menus id_rol_menu; Type: DEFAULT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.roles_menus ALTER COLUMN id_rol_menu SET DEFAULT nextval('identidad.roles_menus_id_rol_menu_seq'::regclass);


--
-- TOC entry 5311 (class 2604 OID 21171)
-- Name: roles_menus_permisos id_rol_menu_permiso; Type: DEFAULT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.roles_menus_permisos ALTER COLUMN id_rol_menu_permiso SET DEFAULT nextval('identidad.roles_menus_permisos_id_rol_menu_permiso_seq'::regclass);


--
-- TOC entry 5303 (class 2604 OID 21123)
-- Name: tipos_permiso id_tipo_permiso; Type: DEFAULT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.tipos_permiso ALTER COLUMN id_tipo_permiso SET DEFAULT nextval('identidad.tipos_permiso_id_tipo_permiso_seq'::regclass);


--
-- TOC entry 5137 (class 2604 OID 19851)
-- Name: trabajadores id_trabajador; Type: DEFAULT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.trabajadores ALTER COLUMN id_trabajador SET DEFAULT nextval('identidad.trabajadores_id_trabajador_seq'::regclass);


--
-- TOC entry 5116 (class 2604 OID 19729)
-- Name: usuarios id_usuario; Type: DEFAULT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.usuarios ALTER COLUMN id_usuario SET DEFAULT nextval('identidad.usuarios_id_usuario_seq'::regclass);


--
-- TOC entry 5315 (class 2604 OID 21199)
-- Name: usuarios_roles id_usuario_rol; Type: DEFAULT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.usuarios_roles ALTER COLUMN id_usuario_rol SET DEFAULT nextval('identidad.usuarios_roles_id_usuario_rol_seq'::regclass);


--
-- TOC entry 5153 (class 2604 OID 19938)
-- Name: almacenes id_almacen; Type: DEFAULT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.almacenes ALTER COLUMN id_almacen SET DEFAULT nextval('inventario.almacenes_id_almacen_seq'::regclass);


--
-- TOC entry 5191 (class 2604 OID 20115)
-- Name: movimientos_inventario id_movimiento; Type: DEFAULT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.movimientos_inventario ALTER COLUMN id_movimiento SET DEFAULT nextval('inventario.movimientos_inventario_id_movimiento_seq'::regclass);


--
-- TOC entry 5187 (class 2604 OID 20084)
-- Name: stock id_stock; Type: DEFAULT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.stock ALTER COLUMN id_stock SET DEFAULT nextval('inventario.stock_id_stock_seq'::regclass);


--
-- TOC entry 5225 (class 2604 OID 20334)
-- Name: cajas id_caja; Type: DEFAULT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.cajas ALTER COLUMN id_caja SET DEFAULT nextval('ventas.cajas_id_caja_seq'::regclass);


--
-- TOC entry 5231 (class 2604 OID 20359)
-- Name: cotizaciones id_cotizacion; Type: DEFAULT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.cotizaciones ALTER COLUMN id_cotizacion SET DEFAULT nextval('ventas.cotizaciones_id_cotizacion_seq'::regclass);


--
-- TOC entry 5240 (class 2604 OID 20398)
-- Name: detalle_cotizacion id_detalle_cot; Type: DEFAULT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.detalle_cotizacion ALTER COLUMN id_detalle_cot SET DEFAULT nextval('ventas.detalle_cotizacion_id_detalle_cot_seq'::regclass);


--
-- TOC entry 5256 (class 2604 OID 20478)
-- Name: detalle_venta id_detalle_venta; Type: DEFAULT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.detalle_venta ALTER COLUMN id_detalle_venta SET DEFAULT nextval('ventas.detalle_venta_id_detalle_venta_seq'::regclass);


--
-- TOC entry 5259 (class 2604 OID 20503)
-- Name: metodos_pago id_metodo_pago; Type: DEFAULT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.metodos_pago ALTER COLUMN id_metodo_pago SET DEFAULT nextval('ventas.metodos_pago_id_metodo_pago_seq'::regclass);


--
-- TOC entry 5268 (class 2604 OID 20549)
-- Name: movimientos_caja id_movimiento_caja; Type: DEFAULT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.movimientos_caja ALTER COLUMN id_movimiento_caja SET DEFAULT nextval('ventas.movimientos_caja_id_movimiento_caja_seq'::regclass);


--
-- TOC entry 5264 (class 2604 OID 20522)
-- Name: pagos id_pago; Type: DEFAULT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.pagos ALTER COLUMN id_pago SET DEFAULT nextval('ventas.pagos_id_pago_seq'::regclass);


--
-- TOC entry 5243 (class 2604 OID 20423)
-- Name: ventas id_venta; Type: DEFAULT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.ventas ALTER COLUMN id_venta SET DEFAULT nextval('ventas.ventas_id_venta_seq'::regclass);


--
-- TOC entry 5724 (class 0 OID 19882)
-- Dependencies: 250
-- Data for Name: categorias; Type: TABLE DATA; Schema: catalogo; Owner: postgres
--

INSERT INTO catalogo.categorias VALUES (1, 'General', 'Categoria General', NULL, NULL, true, '2026-01-27 17:36:29.051209', 'SYSTEM', '2026-01-27 17:36:29.051209', NULL);
INSERT INTO catalogo.categorias VALUES (2, 'General 2', 'prueba', NULL, NULL, false, '2026-01-28 23:41:36.75824', 'API_USER', '2026-01-29 12:27:20.601968', 'API_USER');


--
-- TOC entry 5738 (class 0 OID 20056)
-- Dependencies: 264
-- Data for Name: imagenes_producto; Type: TABLE DATA; Schema: catalogo; Owner: postgres
--



--
-- TOC entry 5732 (class 0 OID 19954)
-- Dependencies: 258
-- Data for Name: listas_precios; Type: TABLE DATA; Schema: catalogo; Owner: postgres
--



--
-- TOC entry 5726 (class 0 OID 19904)
-- Dependencies: 252
-- Data for Name: marcas; Type: TABLE DATA; Schema: catalogo; Owner: postgres
--

INSERT INTO catalogo.marcas VALUES (1, 'Generico', 'Peru', true, '2026-01-27 17:36:29.051209', 'SYSTEM', '2026-01-27 17:36:29.051209', NULL);


--
-- TOC entry 5734 (class 0 OID 19970)
-- Dependencies: 260
-- Data for Name: productos; Type: TABLE DATA; Schema: catalogo; Owner: postgres
--

INSERT INTO catalogo.productos VALUES (1, 'PROD_CLI_01', NULL, NULL, 'Producto Client', NULL, 1, 1, 1, false, 0.00, 0.00, 0.00, 0.00, 0.000, 0.000, false, true, 18.00, NULL, true, '2026-01-27 22:55:17.057057', '', NULL, NULL, NULL);
INSERT INTO catalogo.productos VALUES (2, 'PROD001', NULL, NULL, 'Producto Prueba', NULL, 1, 1, 1, false, 0.00, 0.00, 0.00, 0.00, 0.000, 0.000, false, true, 18.00, NULL, true, '2026-01-27 22:59:25.458681', '', NULL, NULL, NULL);
INSERT INTO catalogo.productos VALUES (3, 'PROD_WRAPPER_02', NULL, NULL, 'Producto Wrapper 2', NULL, 1, 1, 1, false, 0.00, 0.00, 0.00, 0.00, 0.000, 0.000, false, true, 18.00, NULL, true, '2026-01-27 23:11:00.248331', '', NULL, NULL, NULL);
INSERT INTO catalogo.productos VALUES (4, 'PROD_AUDIT_03', NULL, NULL, 'Producto Auditado', NULL, 1, 1, 1, false, 0.00, 0.00, 0.00, 0.00, 0.000, 0.000, false, true, 18.00, NULL, true, '2026-01-27 23:18:23.828687', 'API_USER', NULL, NULL, NULL);
INSERT INTO catalogo.productos VALUES (5, 'prueba', NULL, NULL, 'esta', NULL, 1, 1, 1, false, 0.00, 0.00, 0.00, 0.00, 0.000, 0.000, false, true, 18.00, NULL, true, '2026-01-27 23:37:50.466669', 'API_USER', NULL, NULL, NULL);


--
-- TOC entry 5728 (class 0 OID 19919)
-- Dependencies: 254
-- Data for Name: unidades_medida; Type: TABLE DATA; Schema: catalogo; Owner: postgres
--

INSERT INTO catalogo.unidades_medida VALUES (1, 'NIU', 'Unidad', 'UND', true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);
INSERT INTO catalogo.unidades_medida VALUES (2, 'KGM', 'Kilogramo', 'KG', true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);
INSERT INTO catalogo.unidades_medida VALUES (3, 'LTR', 'Litro', 'LT', true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);
INSERT INTO catalogo.unidades_medida VALUES (4, 'MTR', 'Metro', 'MT', true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);
INSERT INTO catalogo.unidades_medida VALUES (5, 'BX', 'Caja', 'CJA', true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);
INSERT INTO catalogo.unidades_medida VALUES (6, 'NIU', 'Unidad', 'UND', true, '2026-01-27 17:36:29.051209', 'SYSTEM', '2026-01-27 17:36:29.051209', NULL);


--
-- TOC entry 5736 (class 0 OID 20029)
-- Dependencies: 262
-- Data for Name: variantes_producto; Type: TABLE DATA; Schema: catalogo; Owner: postgres
--



--
-- TOC entry 5744 (class 0 OID 20136)
-- Dependencies: 270
-- Data for Name: clientes; Type: TABLE DATA; Schema: clientes; Owner: postgres
--



--
-- TOC entry 5746 (class 0 OID 20166)
-- Dependencies: 272
-- Data for Name: contactos_cliente; Type: TABLE DATA; Schema: clientes; Owner: postgres
--



--
-- TOC entry 5754 (class 0 OID 20271)
-- Dependencies: 280
-- Data for Name: compras; Type: TABLE DATA; Schema: compras; Owner: postgres
--



--
-- TOC entry 5756 (class 0 OID 20308)
-- Dependencies: 282
-- Data for Name: detalle_compra; Type: TABLE DATA; Schema: compras; Owner: postgres
--



--
-- TOC entry 5752 (class 0 OID 20247)
-- Dependencies: 278
-- Data for Name: detalle_orden_compra; Type: TABLE DATA; Schema: compras; Owner: postgres
--



--
-- TOC entry 5750 (class 0 OID 20212)
-- Dependencies: 276
-- Data for Name: ordenes_compra; Type: TABLE DATA; Schema: compras; Owner: postgres
--



--
-- TOC entry 5748 (class 0 OID 20190)
-- Dependencies: 274
-- Data for Name: proveedores; Type: TABLE DATA; Schema: compras; Owner: postgres
--



--
-- TOC entry 5705 (class 0 OID 19666)
-- Dependencies: 231
-- Data for Name: configuraciones; Type: TABLE DATA; Schema: configuracion; Owner: postgres
--

INSERT INTO configuracion.configuraciones VALUES (1, 'IMPUESTO_PORCENTAJE', '18', 'Porcentaje de IGV/IVA por defecto', 'VENTAS', true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);
INSERT INTO configuracion.configuraciones VALUES (2, 'MONEDA_PRINCIPAL', 'PEN', 'Moneda base del sistema', 'SISTEMA', true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);


--
-- TOC entry 5703 (class 0 OID 19643)
-- Dependencies: 229
-- Data for Name: empresa; Type: TABLE DATA; Schema: configuracion; Owner: postgres
--

INSERT INTO configuracion.empresa VALUES (1, '20123456789', 'EMPRESA DEMO S.A.C.', 'MI TIENDA', 'AV. PRINCIPAL 123, LIMA', NULL, NULL, NULL, NULL, 'PEN', true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);


--
-- TOC entry 5707 (class 0 OID 19686)
-- Dependencies: 233
-- Data for Name: series_comprobantes; Type: TABLE DATA; Schema: configuracion; Owner: postgres
--



--
-- TOC entry 5782 (class 0 OID 20673)
-- Dependencies: 308
-- Data for Name: tablas_generales; Type: TABLE DATA; Schema: configuracion; Owner: postgres
--

INSERT INTO configuracion.tablas_generales VALUES (1, 'TIPO_DOCUMENTO', 'Tipos de Documento de Identidad', NULL, true, '2026-01-27 20:38:29.859421-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales VALUES (2, 'TIPO_COMPROBANTE', 'Tipos de Comprobante de Pago', NULL, true, '2026-01-27 20:38:29.869526-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales VALUES (3, 'TIPO_CLIENTE', 'Tipos de Cliente', NULL, true, '2026-01-27 20:38:29.870662-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales VALUES (4, 'TIPO_MOVIMIENTO_CAJA', 'Tipos de Movimiento de Caja', NULL, true, '2026-01-27 20:38:29.871674-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales VALUES (5, 'TIPO_PRODUCTO', 'Tipos de Producto', NULL, true, '2026-01-27 20:38:29.872644-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales VALUES (6, 'TIPO_MOVIMIENTO_INVENTARIO', 'Tipos de Movimiento de Inventario', NULL, true, '2026-01-27 20:38:29.873586-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales VALUES (7, 'TIPO_CUENTA_CONTABLE', 'Tipos de Cuenta Contable', NULL, true, '2026-01-27 20:38:29.87462-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales VALUES (8, 'ESTADO_VENTA', 'Estados de Venta', NULL, true, '2026-01-27 20:38:29.875555-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales VALUES (9, 'ESTADO_COTIZACION', 'Estados de CotizaciÃ³n', NULL, true, '2026-01-27 20:38:29.876572-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales VALUES (10, 'ESTADO_CAJA', 'Estados de Caja', NULL, true, '2026-01-27 20:38:29.877676-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales VALUES (11, 'ESTADO_ORDEN_COMPRA', 'Estados de Orden de Compra', NULL, true, '2026-01-27 20:38:29.878602-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales VALUES (12, 'ESTADO_ASIENTO', 'Estados de Asiento Contable', NULL, true, '2026-01-27 20:38:29.879531-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales VALUES (13, 'ESTADO_PAGO', 'Estados de Pago', NULL, true, '2026-01-27 20:38:29.880536-05', 'SISTEMA', NULL, NULL, true);


--
-- TOC entry 5784 (class 0 OID 20694)
-- Dependencies: 310
-- Data for Name: tablas_generales_detalle; Type: TABLE DATA; Schema: configuracion; Owner: postgres
--

INSERT INTO configuracion.tablas_generales_detalle VALUES (1, 1, 'DNI', 'Documento Nacional de Identidad', NULL, 1, true, '2026-01-27 20:38:29.865474-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (2, 1, 'RUC', 'Registro Ãšnico de Contribuyentes', NULL, 2, true, '2026-01-27 20:38:29.865474-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (3, 1, 'CE', 'Carnet de ExtranjerÃ­a', NULL, 3, true, '2026-01-27 20:38:29.865474-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (4, 1, 'PAS', 'Pasaporte', NULL, 4, true, '2026-01-27 20:38:29.865474-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (5, 2, 'BOL', 'Boleta de Venta', NULL, 1, true, '2026-01-27 20:38:29.870018-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (6, 2, 'FAC', 'Factura', NULL, 2, true, '2026-01-27 20:38:29.870018-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (7, 2, 'NVT', 'Nota de Venta', NULL, 3, true, '2026-01-27 20:38:29.870018-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (8, 2, 'TK', 'Ticket', NULL, 4, true, '2026-01-27 20:38:29.870018-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (9, 3, 'PUB', 'PÃºblico General', NULL, 1, true, '2026-01-27 20:38:29.871144-05', 'SISTEMA', NULL, NULL, true);
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
INSERT INTO configuracion.tablas_generales_detalle VALUES (36, 9, 'CVT', 'Convertida a Venta', NULL, 5, true, '2026-01-27 20:38:29.87705-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (37, 10, 'ABI', 'Abierta', NULL, 1, true, '2026-01-27 20:38:29.878144-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (38, 10, 'CIE', 'Cerrada', NULL, 2, true, '2026-01-27 20:38:29.878144-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (39, 11, 'BOR', 'Borrador', NULL, 1, true, '2026-01-27 20:38:29.879005-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (40, 11, 'PEN', 'Pendiente', NULL, 2, true, '2026-01-27 20:38:29.879005-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (41, 11, 'APR', 'Aprobada', NULL, 3, true, '2026-01-27 20:38:29.879005-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (42, 11, 'REC', 'Rechazada', NULL, 4, true, '2026-01-27 20:38:29.879005-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (43, 12, 'MAY', 'Mayorizado', NULL, 1, true, '2026-01-27 20:38:29.880009-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (44, 12, 'PEN', 'Pendiente', NULL, 2, true, '2026-01-27 20:38:29.880009-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (45, 12, 'ANU', 'Anulado', NULL, 3, true, '2026-01-27 20:38:29.880009-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (46, 13, 'PAG', 'Pagado', NULL, 1, true, '2026-01-27 20:38:29.881027-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (47, 13, 'PAR', 'Parcial', NULL, 2, true, '2026-01-27 20:38:29.881027-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (48, 13, 'CRE', 'A CrÃ©dito', NULL, 3, true, '2026-01-27 20:38:29.881027-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (49, 13, 'PEN', 'Pendiente', NULL, 4, true, '2026-01-27 20:38:29.881027-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (50, 13, 'ANU', 'Anulado', NULL, 5, true, '2026-01-27 20:38:29.881027-05', 'SISTEMA', NULL, NULL, true);


--
-- TOC entry 5778 (class 0 OID 20619)
-- Dependencies: 304
-- Data for Name: asientos_contables; Type: TABLE DATA; Schema: contabilidad; Owner: postgres
--



--
-- TOC entry 5776 (class 0 OID 20601)
-- Dependencies: 302
-- Data for Name: centros_costo; Type: TABLE DATA; Schema: contabilidad; Owner: postgres
--



--
-- TOC entry 5780 (class 0 OID 20643)
-- Dependencies: 306
-- Data for Name: detalle_asiento; Type: TABLE DATA; Schema: contabilidad; Owner: postgres
--



--
-- TOC entry 5774 (class 0 OID 20571)
-- Dependencies: 300
-- Data for Name: plan_cuentas; Type: TABLE DATA; Schema: contabilidad; Owner: postgres
--



--
-- TOC entry 5718 (class 0 OID 19813)
-- Dependencies: 244
-- Data for Name: areas; Type: TABLE DATA; Schema: identidad; Owner: postgres
--



--
-- TOC entry 5716 (class 0 OID 19799)
-- Dependencies: 242
-- Data for Name: auditoria_accesos; Type: TABLE DATA; Schema: identidad; Owner: postgres
--



--
-- TOC entry 5720 (class 0 OID 19828)
-- Dependencies: 246
-- Data for Name: cargos; Type: TABLE DATA; Schema: identidad; Owner: postgres
--



--
-- TOC entry 5786 (class 0 OID 21093)
-- Dependencies: 312
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


--
-- TOC entry 5713 (class 0 OID 19757)
-- Dependencies: 239
-- Data for Name: permisos; Type: TABLE DATA; Schema: identidad; Owner: postgres
--



--
-- TOC entry 5709 (class 0 OID 19707)
-- Dependencies: 235
-- Data for Name: roles; Type: TABLE DATA; Schema: identidad; Owner: postgres
--

INSERT INTO identidad.roles VALUES (1, 'ADMINISTRADOR', 'Acceso total al sistema', true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);
INSERT INTO identidad.roles VALUES (2, 'VENDEDOR', 'Acceso a módulo de ventas y clientes', true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);
INSERT INTO identidad.roles VALUES (3, 'CAJERO', 'Acceso a apertura/cierre de caja y cobros', true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);
INSERT INTO identidad.roles VALUES (4, 'ALMACENERO', 'Acceso a inventarios y kardex', true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);


--
-- TOC entry 5790 (class 0 OID 21140)
-- Dependencies: 316
-- Data for Name: roles_menus; Type: TABLE DATA; Schema: identidad; Owner: postgres
--



--
-- TOC entry 5792 (class 0 OID 21168)
-- Dependencies: 318
-- Data for Name: roles_menus_permisos; Type: TABLE DATA; Schema: identidad; Owner: postgres
--



--
-- TOC entry 5714 (class 0 OID 19775)
-- Dependencies: 240
-- Data for Name: roles_permisos; Type: TABLE DATA; Schema: identidad; Owner: postgres
--



--
-- TOC entry 5788 (class 0 OID 21120)
-- Dependencies: 314
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
-- TOC entry 5722 (class 0 OID 19848)
-- Dependencies: 248
-- Data for Name: trabajadores; Type: TABLE DATA; Schema: identidad; Owner: postgres
--



--
-- TOC entry 5711 (class 0 OID 19726)
-- Dependencies: 237
-- Data for Name: usuarios; Type: TABLE DATA; Schema: identidad; Owner: postgres
--

INSERT INTO identidad.usuarios VALUES (1, 'admin', '$2a$12$R9h/cIPz0gi.URNNXRFXjOios9lnpSHkTE.oFw0kX8k.js9l0.y', 'admin@sistema.com', 'Administrador', 'Principal', 1, NULL, true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);


--
-- TOC entry 5794 (class 0 OID 21196)
-- Dependencies: 320
-- Data for Name: usuarios_roles; Type: TABLE DATA; Schema: identidad; Owner: postgres
--



--
-- TOC entry 5730 (class 0 OID 19935)
-- Dependencies: 256
-- Data for Name: almacenes; Type: TABLE DATA; Schema: inventario; Owner: postgres
--

INSERT INTO inventario.almacenes VALUES (1, 'ALMACEN CENTRAL', 'SEDE PRINCIPAL', true, true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);


--
-- TOC entry 5742 (class 0 OID 20112)
-- Dependencies: 268
-- Data for Name: movimientos_inventario; Type: TABLE DATA; Schema: inventario; Owner: postgres
--



--
-- TOC entry 5740 (class 0 OID 20081)
-- Dependencies: 266
-- Data for Name: stock; Type: TABLE DATA; Schema: inventario; Owner: postgres
--



--
-- TOC entry 5701 (class 0 OID 16789)
-- Dependencies: 227
-- Data for Name: __EFMigrationsHistory; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."__EFMigrationsHistory" VALUES ('20260127221140_Inicial', '8.0.8');
INSERT INTO public."__EFMigrationsHistory" VALUES ('20260127221706_AjusteEsquema', '8.0.8');
INSERT INTO public."__EFMigrationsHistory" VALUES ('20260129221256_AgregarTiposComprobante', '8.0.0');


--
-- TOC entry 5758 (class 0 OID 20331)
-- Dependencies: 284
-- Data for Name: cajas; Type: TABLE DATA; Schema: ventas; Owner: postgres
--



--
-- TOC entry 5760 (class 0 OID 20356)
-- Dependencies: 286
-- Data for Name: cotizaciones; Type: TABLE DATA; Schema: ventas; Owner: postgres
--



--
-- TOC entry 5762 (class 0 OID 20395)
-- Dependencies: 288
-- Data for Name: detalle_cotizacion; Type: TABLE DATA; Schema: ventas; Owner: postgres
--



--
-- TOC entry 5766 (class 0 OID 20475)
-- Dependencies: 292
-- Data for Name: detalle_venta; Type: TABLE DATA; Schema: ventas; Owner: postgres
--



--
-- TOC entry 5768 (class 0 OID 20500)
-- Dependencies: 294
-- Data for Name: metodos_pago; Type: TABLE DATA; Schema: ventas; Owner: postgres
--

INSERT INTO ventas.metodos_pago VALUES (1, 'EFE', 'Efectivo', false, true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);
INSERT INTO ventas.metodos_pago VALUES (2, 'TAR', 'Tarjeta Crédito/Débito', true, true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);
INSERT INTO ventas.metodos_pago VALUES (3, 'TRA', 'Transferencia Bancaria', true, true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);
INSERT INTO ventas.metodos_pago VALUES (4, 'YAP', 'Yape/Plin', true, true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);


--
-- TOC entry 5772 (class 0 OID 20546)
-- Dependencies: 298
-- Data for Name: movimientos_caja; Type: TABLE DATA; Schema: ventas; Owner: postgres
--



--
-- TOC entry 5770 (class 0 OID 20519)
-- Dependencies: 296
-- Data for Name: pagos; Type: TABLE DATA; Schema: ventas; Owner: postgres
--



--
-- TOC entry 5764 (class 0 OID 20420)
-- Dependencies: 290
-- Data for Name: ventas; Type: TABLE DATA; Schema: ventas; Owner: postgres
--



--
-- TOC entry 5853 (class 0 OID 0)
-- Dependencies: 249
-- Name: categorias_id_categoria_seq; Type: SEQUENCE SET; Schema: catalogo; Owner: postgres
--

SELECT pg_catalog.setval('catalogo.categorias_id_categoria_seq', 2, true);


--
-- TOC entry 5854 (class 0 OID 0)
-- Dependencies: 263
-- Name: imagenes_producto_id_imagen_seq; Type: SEQUENCE SET; Schema: catalogo; Owner: postgres
--

SELECT pg_catalog.setval('catalogo.imagenes_producto_id_imagen_seq', 1, false);


--
-- TOC entry 5855 (class 0 OID 0)
-- Dependencies: 257
-- Name: listas_precios_id_lista_precio_seq; Type: SEQUENCE SET; Schema: catalogo; Owner: postgres
--

SELECT pg_catalog.setval('catalogo.listas_precios_id_lista_precio_seq', 1, false);


--
-- TOC entry 5856 (class 0 OID 0)
-- Dependencies: 251
-- Name: marcas_id_marca_seq; Type: SEQUENCE SET; Schema: catalogo; Owner: postgres
--

SELECT pg_catalog.setval('catalogo.marcas_id_marca_seq', 3, true);


--
-- TOC entry 5857 (class 0 OID 0)
-- Dependencies: 259
-- Name: productos_id_producto_seq; Type: SEQUENCE SET; Schema: catalogo; Owner: postgres
--

SELECT pg_catalog.setval('catalogo.productos_id_producto_seq', 5, true);


--
-- TOC entry 5858 (class 0 OID 0)
-- Dependencies: 253
-- Name: unidades_medida_id_unidad_seq; Type: SEQUENCE SET; Schema: catalogo; Owner: postgres
--

SELECT pg_catalog.setval('catalogo.unidades_medida_id_unidad_seq', 6, true);


--
-- TOC entry 5859 (class 0 OID 0)
-- Dependencies: 261
-- Name: variantes_producto_id_variante_seq; Type: SEQUENCE SET; Schema: catalogo; Owner: postgres
--

SELECT pg_catalog.setval('catalogo.variantes_producto_id_variante_seq', 1, false);


--
-- TOC entry 5860 (class 0 OID 0)
-- Dependencies: 269
-- Name: clientes_id_cliente_seq; Type: SEQUENCE SET; Schema: clientes; Owner: postgres
--

SELECT pg_catalog.setval('clientes.clientes_id_cliente_seq', 1, false);


--
-- TOC entry 5861 (class 0 OID 0)
-- Dependencies: 271
-- Name: contactos_cliente_id_contacto_seq; Type: SEQUENCE SET; Schema: clientes; Owner: postgres
--

SELECT pg_catalog.setval('clientes.contactos_cliente_id_contacto_seq', 1, false);


--
-- TOC entry 5862 (class 0 OID 0)
-- Dependencies: 279
-- Name: compras_id_compra_seq; Type: SEQUENCE SET; Schema: compras; Owner: postgres
--

SELECT pg_catalog.setval('compras.compras_id_compra_seq', 1, false);


--
-- TOC entry 5863 (class 0 OID 0)
-- Dependencies: 281
-- Name: detalle_compra_id_detalle_compra_seq; Type: SEQUENCE SET; Schema: compras; Owner: postgres
--

SELECT pg_catalog.setval('compras.detalle_compra_id_detalle_compra_seq', 1, false);


--
-- TOC entry 5864 (class 0 OID 0)
-- Dependencies: 277
-- Name: detalle_orden_compra_id_detalle_oc_seq; Type: SEQUENCE SET; Schema: compras; Owner: postgres
--

SELECT pg_catalog.setval('compras.detalle_orden_compra_id_detalle_oc_seq', 1, false);


--
-- TOC entry 5865 (class 0 OID 0)
-- Dependencies: 275
-- Name: ordenes_compra_id_orden_compra_seq; Type: SEQUENCE SET; Schema: compras; Owner: postgres
--

SELECT pg_catalog.setval('compras.ordenes_compra_id_orden_compra_seq', 1, false);


--
-- TOC entry 5866 (class 0 OID 0)
-- Dependencies: 273
-- Name: proveedores_id_proveedor_seq; Type: SEQUENCE SET; Schema: compras; Owner: postgres
--

SELECT pg_catalog.setval('compras.proveedores_id_proveedor_seq', 1, false);


--
-- TOC entry 5867 (class 0 OID 0)
-- Dependencies: 230
-- Name: configuraciones_id_configuracion_seq; Type: SEQUENCE SET; Schema: configuracion; Owner: postgres
--

SELECT pg_catalog.setval('configuracion.configuraciones_id_configuracion_seq', 2, true);


--
-- TOC entry 5868 (class 0 OID 0)
-- Dependencies: 228
-- Name: empresa_id_empresa_seq; Type: SEQUENCE SET; Schema: configuracion; Owner: postgres
--

SELECT pg_catalog.setval('configuracion.empresa_id_empresa_seq', 1, true);


--
-- TOC entry 5869 (class 0 OID 0)
-- Dependencies: 232
-- Name: series_comprobantes_id_serie_seq; Type: SEQUENCE SET; Schema: configuracion; Owner: postgres
--

SELECT pg_catalog.setval('configuracion.series_comprobantes_id_serie_seq', 1, false);


--
-- TOC entry 5870 (class 0 OID 0)
-- Dependencies: 309
-- Name: tablas_generales_detalle_id_detalle_seq; Type: SEQUENCE SET; Schema: configuracion; Owner: postgres
--

SELECT pg_catalog.setval('configuracion.tablas_generales_detalle_id_detalle_seq', 50, true);


--
-- TOC entry 5871 (class 0 OID 0)
-- Dependencies: 307
-- Name: tablas_generales_id_tabla_seq; Type: SEQUENCE SET; Schema: configuracion; Owner: postgres
--

SELECT pg_catalog.setval('configuracion.tablas_generales_id_tabla_seq', 13, true);


--
-- TOC entry 5872 (class 0 OID 0)
-- Dependencies: 303
-- Name: asientos_contables_id_asiento_seq; Type: SEQUENCE SET; Schema: contabilidad; Owner: postgres
--

SELECT pg_catalog.setval('contabilidad.asientos_contables_id_asiento_seq', 1, false);


--
-- TOC entry 5873 (class 0 OID 0)
-- Dependencies: 301
-- Name: centros_costo_id_centro_costo_seq; Type: SEQUENCE SET; Schema: contabilidad; Owner: postgres
--

SELECT pg_catalog.setval('contabilidad.centros_costo_id_centro_costo_seq', 1, false);


--
-- TOC entry 5874 (class 0 OID 0)
-- Dependencies: 305
-- Name: detalle_asiento_id_detalle_asiento_seq; Type: SEQUENCE SET; Schema: contabilidad; Owner: postgres
--

SELECT pg_catalog.setval('contabilidad.detalle_asiento_id_detalle_asiento_seq', 1, false);


--
-- TOC entry 5875 (class 0 OID 0)
-- Dependencies: 299
-- Name: plan_cuentas_id_cuenta_seq; Type: SEQUENCE SET; Schema: contabilidad; Owner: postgres
--

SELECT pg_catalog.setval('contabilidad.plan_cuentas_id_cuenta_seq', 1, false);


--
-- TOC entry 5876 (class 0 OID 0)
-- Dependencies: 243
-- Name: areas_id_area_seq; Type: SEQUENCE SET; Schema: identidad; Owner: postgres
--

SELECT pg_catalog.setval('identidad.areas_id_area_seq', 1, false);


--
-- TOC entry 5877 (class 0 OID 0)
-- Dependencies: 241
-- Name: auditoria_accesos_id_auditoria_seq; Type: SEQUENCE SET; Schema: identidad; Owner: postgres
--

SELECT pg_catalog.setval('identidad.auditoria_accesos_id_auditoria_seq', 1, false);


--
-- TOC entry 5878 (class 0 OID 0)
-- Dependencies: 245
-- Name: cargos_id_cargo_seq; Type: SEQUENCE SET; Schema: identidad; Owner: postgres
--

SELECT pg_catalog.setval('identidad.cargos_id_cargo_seq', 1, false);


--
-- TOC entry 5879 (class 0 OID 0)
-- Dependencies: 311
-- Name: menus_id_menu_seq; Type: SEQUENCE SET; Schema: identidad; Owner: postgres
--

SELECT pg_catalog.setval('identidad.menus_id_menu_seq', 27, true);


--
-- TOC entry 5880 (class 0 OID 0)
-- Dependencies: 238
-- Name: permisos_id_permiso_seq; Type: SEQUENCE SET; Schema: identidad; Owner: postgres
--

SELECT pg_catalog.setval('identidad.permisos_id_permiso_seq', 1, false);


--
-- TOC entry 5881 (class 0 OID 0)
-- Dependencies: 234
-- Name: roles_id_rol_seq; Type: SEQUENCE SET; Schema: identidad; Owner: postgres
--

SELECT pg_catalog.setval('identidad.roles_id_rol_seq', 4, true);


--
-- TOC entry 5882 (class 0 OID 0)
-- Dependencies: 315
-- Name: roles_menus_id_rol_menu_seq; Type: SEQUENCE SET; Schema: identidad; Owner: postgres
--

SELECT pg_catalog.setval('identidad.roles_menus_id_rol_menu_seq', 1, false);


--
-- TOC entry 5883 (class 0 OID 0)
-- Dependencies: 317
-- Name: roles_menus_permisos_id_rol_menu_permiso_seq; Type: SEQUENCE SET; Schema: identidad; Owner: postgres
--

SELECT pg_catalog.setval('identidad.roles_menus_permisos_id_rol_menu_permiso_seq', 1, false);


--
-- TOC entry 5884 (class 0 OID 0)
-- Dependencies: 313
-- Name: tipos_permiso_id_tipo_permiso_seq; Type: SEQUENCE SET; Schema: identidad; Owner: postgres
--

SELECT pg_catalog.setval('identidad.tipos_permiso_id_tipo_permiso_seq', 9, true);


--
-- TOC entry 5885 (class 0 OID 0)
-- Dependencies: 247
-- Name: trabajadores_id_trabajador_seq; Type: SEQUENCE SET; Schema: identidad; Owner: postgres
--

SELECT pg_catalog.setval('identidad.trabajadores_id_trabajador_seq', 1, false);


--
-- TOC entry 5886 (class 0 OID 0)
-- Dependencies: 236
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE SET; Schema: identidad; Owner: postgres
--

SELECT pg_catalog.setval('identidad.usuarios_id_usuario_seq', 1, true);


--
-- TOC entry 5887 (class 0 OID 0)
-- Dependencies: 319
-- Name: usuarios_roles_id_usuario_rol_seq; Type: SEQUENCE SET; Schema: identidad; Owner: postgres
--

SELECT pg_catalog.setval('identidad.usuarios_roles_id_usuario_rol_seq', 1, false);


--
-- TOC entry 5888 (class 0 OID 0)
-- Dependencies: 255
-- Name: almacenes_id_almacen_seq; Type: SEQUENCE SET; Schema: inventario; Owner: postgres
--

SELECT pg_catalog.setval('inventario.almacenes_id_almacen_seq', 1, true);


--
-- TOC entry 5889 (class 0 OID 0)
-- Dependencies: 267
-- Name: movimientos_inventario_id_movimiento_seq; Type: SEQUENCE SET; Schema: inventario; Owner: postgres
--

SELECT pg_catalog.setval('inventario.movimientos_inventario_id_movimiento_seq', 1, false);


--
-- TOC entry 5890 (class 0 OID 0)
-- Dependencies: 265
-- Name: stock_id_stock_seq; Type: SEQUENCE SET; Schema: inventario; Owner: postgres
--

SELECT pg_catalog.setval('inventario.stock_id_stock_seq', 1, false);


--
-- TOC entry 5891 (class 0 OID 0)
-- Dependencies: 283
-- Name: cajas_id_caja_seq; Type: SEQUENCE SET; Schema: ventas; Owner: postgres
--

SELECT pg_catalog.setval('ventas.cajas_id_caja_seq', 1, false);


--
-- TOC entry 5892 (class 0 OID 0)
-- Dependencies: 285
-- Name: cotizaciones_id_cotizacion_seq; Type: SEQUENCE SET; Schema: ventas; Owner: postgres
--

SELECT pg_catalog.setval('ventas.cotizaciones_id_cotizacion_seq', 1, false);


--
-- TOC entry 5893 (class 0 OID 0)
-- Dependencies: 287
-- Name: detalle_cotizacion_id_detalle_cot_seq; Type: SEQUENCE SET; Schema: ventas; Owner: postgres
--

SELECT pg_catalog.setval('ventas.detalle_cotizacion_id_detalle_cot_seq', 1, false);


--
-- TOC entry 5894 (class 0 OID 0)
-- Dependencies: 291
-- Name: detalle_venta_id_detalle_venta_seq; Type: SEQUENCE SET; Schema: ventas; Owner: postgres
--

SELECT pg_catalog.setval('ventas.detalle_venta_id_detalle_venta_seq', 1, false);


--
-- TOC entry 5895 (class 0 OID 0)
-- Dependencies: 293
-- Name: metodos_pago_id_metodo_pago_seq; Type: SEQUENCE SET; Schema: ventas; Owner: postgres
--

SELECT pg_catalog.setval('ventas.metodos_pago_id_metodo_pago_seq', 4, true);


--
-- TOC entry 5896 (class 0 OID 0)
-- Dependencies: 297
-- Name: movimientos_caja_id_movimiento_caja_seq; Type: SEQUENCE SET; Schema: ventas; Owner: postgres
--

SELECT pg_catalog.setval('ventas.movimientos_caja_id_movimiento_caja_seq', 1, false);


--
-- TOC entry 5897 (class 0 OID 0)
-- Dependencies: 295
-- Name: pagos_id_pago_seq; Type: SEQUENCE SET; Schema: ventas; Owner: postgres
--

SELECT pg_catalog.setval('ventas.pagos_id_pago_seq', 1, false);


--
-- TOC entry 5898 (class 0 OID 0)
-- Dependencies: 289
-- Name: ventas_id_venta_seq; Type: SEQUENCE SET; Schema: ventas; Owner: postgres
--

SELECT pg_catalog.setval('ventas.ventas_id_venta_seq', 1, false);


--
-- TOC entry 5364 (class 2606 OID 19897)
-- Name: categorias categorias_pkey; Type: CONSTRAINT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.categorias
    ADD CONSTRAINT categorias_pkey PRIMARY KEY (id_categoria);


--
-- TOC entry 5384 (class 2606 OID 20074)
-- Name: imagenes_producto imagenes_producto_pkey; Type: CONSTRAINT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.imagenes_producto
    ADD CONSTRAINT imagenes_producto_pkey PRIMARY KEY (id_imagen);


--
-- TOC entry 5372 (class 2606 OID 19968)
-- Name: listas_precios listas_precios_pkey; Type: CONSTRAINT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.listas_precios
    ADD CONSTRAINT listas_precios_pkey PRIMARY KEY (id_lista_precio);


--
-- TOC entry 5366 (class 2606 OID 19917)
-- Name: marcas marcas_pkey; Type: CONSTRAINT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.marcas
    ADD CONSTRAINT marcas_pkey PRIMARY KEY (id_marca);


--
-- TOC entry 5374 (class 2606 OID 20010)
-- Name: productos productos_codigo_producto_key; Type: CONSTRAINT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.productos
    ADD CONSTRAINT productos_codigo_producto_key UNIQUE (codigo_producto);


--
-- TOC entry 5376 (class 2606 OID 20008)
-- Name: productos productos_pkey; Type: CONSTRAINT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.productos
    ADD CONSTRAINT productos_pkey PRIMARY KEY (id_producto);


--
-- TOC entry 5378 (class 2606 OID 20012)
-- Name: productos productos_sku_key; Type: CONSTRAINT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.productos
    ADD CONSTRAINT productos_sku_key UNIQUE (sku);


--
-- TOC entry 5368 (class 2606 OID 19933)
-- Name: unidades_medida unidades_medida_pkey; Type: CONSTRAINT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.unidades_medida
    ADD CONSTRAINT unidades_medida_pkey PRIMARY KEY (id_unidad);


--
-- TOC entry 5380 (class 2606 OID 20047)
-- Name: variantes_producto variantes_producto_pkey; Type: CONSTRAINT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.variantes_producto
    ADD CONSTRAINT variantes_producto_pkey PRIMARY KEY (id_variante);


--
-- TOC entry 5382 (class 2606 OID 20049)
-- Name: variantes_producto variantes_producto_sku_variante_key; Type: CONSTRAINT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.variantes_producto
    ADD CONSTRAINT variantes_producto_sku_variante_key UNIQUE (sku_variante);


--
-- TOC entry 5392 (class 2606 OID 20159)
-- Name: clientes clientes_numero_documento_key; Type: CONSTRAINT; Schema: clientes; Owner: postgres
--

ALTER TABLE ONLY clientes.clientes
    ADD CONSTRAINT clientes_numero_documento_key UNIQUE (numero_documento);


--
-- TOC entry 5394 (class 2606 OID 20157)
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: clientes; Owner: postgres
--

ALTER TABLE ONLY clientes.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (id_cliente);


--
-- TOC entry 5396 (class 2606 OID 20183)
-- Name: contactos_cliente contactos_cliente_pkey; Type: CONSTRAINT; Schema: clientes; Owner: postgres
--

ALTER TABLE ONLY clientes.contactos_cliente
    ADD CONSTRAINT contactos_cliente_pkey PRIMARY KEY (id_contacto);


--
-- TOC entry 5408 (class 2606 OID 20296)
-- Name: compras compras_pkey; Type: CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.compras
    ADD CONSTRAINT compras_pkey PRIMARY KEY (id_compra);


--
-- TOC entry 5410 (class 2606 OID 20319)
-- Name: detalle_compra detalle_compra_pkey; Type: CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.detalle_compra
    ADD CONSTRAINT detalle_compra_pkey PRIMARY KEY (id_detalle_compra);


--
-- TOC entry 5406 (class 2606 OID 20259)
-- Name: detalle_orden_compra detalle_orden_compra_pkey; Type: CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.detalle_orden_compra
    ADD CONSTRAINT detalle_orden_compra_pkey PRIMARY KEY (id_detalle_oc);


--
-- TOC entry 5402 (class 2606 OID 20235)
-- Name: ordenes_compra ordenes_compra_codigo_orden_key; Type: CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.ordenes_compra
    ADD CONSTRAINT ordenes_compra_codigo_orden_key UNIQUE (codigo_orden);


--
-- TOC entry 5404 (class 2606 OID 20233)
-- Name: ordenes_compra ordenes_compra_pkey; Type: CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.ordenes_compra
    ADD CONSTRAINT ordenes_compra_pkey PRIMARY KEY (id_orden_compra);


--
-- TOC entry 5398 (class 2606 OID 20210)
-- Name: proveedores proveedores_numero_documento_key; Type: CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.proveedores
    ADD CONSTRAINT proveedores_numero_documento_key UNIQUE (numero_documento);


--
-- TOC entry 5400 (class 2606 OID 20208)
-- Name: proveedores proveedores_pkey; Type: CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.proveedores
    ADD CONSTRAINT proveedores_pkey PRIMARY KEY (id_proveedor);


--
-- TOC entry 5330 (class 2606 OID 19684)
-- Name: configuraciones configuraciones_clave_key; Type: CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.configuraciones
    ADD CONSTRAINT configuraciones_clave_key UNIQUE (clave);


--
-- TOC entry 5332 (class 2606 OID 19682)
-- Name: configuraciones configuraciones_pkey; Type: CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.configuraciones
    ADD CONSTRAINT configuraciones_pkey PRIMARY KEY (id_configuracion);


--
-- TOC entry 5326 (class 2606 OID 19662)
-- Name: empresa empresa_pkey; Type: CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.empresa
    ADD CONSTRAINT empresa_pkey PRIMARY KEY (id_empresa);


--
-- TOC entry 5328 (class 2606 OID 19664)
-- Name: empresa empresa_ruc_key; Type: CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.empresa
    ADD CONSTRAINT empresa_ruc_key UNIQUE (ruc);


--
-- TOC entry 5334 (class 2606 OID 19703)
-- Name: series_comprobantes series_comprobantes_pkey; Type: CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.series_comprobantes
    ADD CONSTRAINT series_comprobantes_pkey PRIMARY KEY (id_serie);


--
-- TOC entry 5443 (class 2606 OID 20692)
-- Name: tablas_generales tablas_generales_codigo_key; Type: CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.tablas_generales
    ADD CONSTRAINT tablas_generales_codigo_key UNIQUE (codigo);


--
-- TOC entry 5449 (class 2606 OID 20714)
-- Name: tablas_generales_detalle tablas_generales_detalle_pkey; Type: CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.tablas_generales_detalle
    ADD CONSTRAINT tablas_generales_detalle_pkey PRIMARY KEY (id_detalle);


--
-- TOC entry 5445 (class 2606 OID 20690)
-- Name: tablas_generales tablas_generales_pkey; Type: CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.tablas_generales
    ADD CONSTRAINT tablas_generales_pkey PRIMARY KEY (id_tabla);


--
-- TOC entry 5451 (class 2606 OID 20716)
-- Name: tablas_generales_detalle uk_tabla_codigo; Type: CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.tablas_generales_detalle
    ADD CONSTRAINT uk_tabla_codigo UNIQUE (id_tabla, codigo);


--
-- TOC entry 5438 (class 2606 OID 20641)
-- Name: asientos_contables asientos_contables_pkey; Type: CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.asientos_contables
    ADD CONSTRAINT asientos_contables_pkey PRIMARY KEY (id_asiento);


--
-- TOC entry 5434 (class 2606 OID 20617)
-- Name: centros_costo centros_costo_codigo_key; Type: CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.centros_costo
    ADD CONSTRAINT centros_costo_codigo_key UNIQUE (codigo);


--
-- TOC entry 5436 (class 2606 OID 20615)
-- Name: centros_costo centros_costo_pkey; Type: CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.centros_costo
    ADD CONSTRAINT centros_costo_pkey PRIMARY KEY (id_centro_costo);


--
-- TOC entry 5440 (class 2606 OID 20653)
-- Name: detalle_asiento detalle_asiento_pkey; Type: CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.detalle_asiento
    ADD CONSTRAINT detalle_asiento_pkey PRIMARY KEY (id_detalle_asiento);


--
-- TOC entry 5430 (class 2606 OID 20594)
-- Name: plan_cuentas plan_cuentas_codigo_cuenta_key; Type: CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.plan_cuentas
    ADD CONSTRAINT plan_cuentas_codigo_cuenta_key UNIQUE (codigo_cuenta);


--
-- TOC entry 5432 (class 2606 OID 20592)
-- Name: plan_cuentas plan_cuentas_pkey; Type: CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.plan_cuentas
    ADD CONSTRAINT plan_cuentas_pkey PRIMARY KEY (id_cuenta);


--
-- TOC entry 5354 (class 2606 OID 19826)
-- Name: areas areas_pkey; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.areas
    ADD CONSTRAINT areas_pkey PRIMARY KEY (id_area);


--
-- TOC entry 5352 (class 2606 OID 19811)
-- Name: auditoria_accesos auditoria_accesos_pkey; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.auditoria_accesos
    ADD CONSTRAINT auditoria_accesos_pkey PRIMARY KEY (id_auditoria);


--
-- TOC entry 5356 (class 2606 OID 19841)
-- Name: cargos cargos_pkey; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.cargos
    ADD CONSTRAINT cargos_pkey PRIMARY KEY (id_cargo);


--
-- TOC entry 5455 (class 2606 OID 21113)
-- Name: menus menus_codigo_key; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.menus
    ADD CONSTRAINT menus_codigo_key UNIQUE (codigo);


--
-- TOC entry 5457 (class 2606 OID 21111)
-- Name: menus menus_pkey; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.menus
    ADD CONSTRAINT menus_pkey PRIMARY KEY (id_menu);


--
-- TOC entry 5346 (class 2606 OID 19774)
-- Name: permisos permisos_codigo_permiso_key; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.permisos
    ADD CONSTRAINT permisos_codigo_permiso_key UNIQUE (codigo_permiso);


--
-- TOC entry 5348 (class 2606 OID 19772)
-- Name: permisos permisos_pkey; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.permisos
    ADD CONSTRAINT permisos_pkey PRIMARY KEY (id_permiso);


--
-- TOC entry 5466 (class 2606 OID 21156)
-- Name: roles_menus roles_menus_id_rol_id_menu_key; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.roles_menus
    ADD CONSTRAINT roles_menus_id_rol_id_menu_key UNIQUE (id_rol, id_menu);


--
-- TOC entry 5470 (class 2606 OID 21184)
-- Name: roles_menus_permisos roles_menus_permisos_id_rol_menu_id_tipo_permiso_key; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.roles_menus_permisos
    ADD CONSTRAINT roles_menus_permisos_id_rol_menu_id_tipo_permiso_key UNIQUE (id_rol_menu, id_tipo_permiso);


--
-- TOC entry 5472 (class 2606 OID 21182)
-- Name: roles_menus_permisos roles_menus_permisos_pkey; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.roles_menus_permisos
    ADD CONSTRAINT roles_menus_permisos_pkey PRIMARY KEY (id_rol_menu_permiso);


--
-- TOC entry 5468 (class 2606 OID 21154)
-- Name: roles_menus roles_menus_pkey; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.roles_menus
    ADD CONSTRAINT roles_menus_pkey PRIMARY KEY (id_rol_menu);


--
-- TOC entry 5336 (class 2606 OID 19724)
-- Name: roles roles_nombre_rol_key; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.roles
    ADD CONSTRAINT roles_nombre_rol_key UNIQUE (nombre_rol);


--
-- TOC entry 5350 (class 2606 OID 19787)
-- Name: roles_permisos roles_permisos_pkey; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.roles_permisos
    ADD CONSTRAINT roles_permisos_pkey PRIMARY KEY (id_rol, id_permiso);


--
-- TOC entry 5338 (class 2606 OID 19722)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id_rol);


--
-- TOC entry 5460 (class 2606 OID 21138)
-- Name: tipos_permiso tipos_permiso_codigo_key; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.tipos_permiso
    ADD CONSTRAINT tipos_permiso_codigo_key UNIQUE (codigo);


--
-- TOC entry 5462 (class 2606 OID 21136)
-- Name: tipos_permiso tipos_permiso_pkey; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.tipos_permiso
    ADD CONSTRAINT tipos_permiso_pkey PRIMARY KEY (id_tipo_permiso);


--
-- TOC entry 5358 (class 2606 OID 19870)
-- Name: trabajadores trabajadores_id_usuario_key; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.trabajadores
    ADD CONSTRAINT trabajadores_id_usuario_key UNIQUE (id_usuario);


--
-- TOC entry 5360 (class 2606 OID 19868)
-- Name: trabajadores trabajadores_numero_documento_key; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.trabajadores
    ADD CONSTRAINT trabajadores_numero_documento_key UNIQUE (numero_documento);


--
-- TOC entry 5362 (class 2606 OID 19866)
-- Name: trabajadores trabajadores_pkey; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.trabajadores
    ADD CONSTRAINT trabajadores_pkey PRIMARY KEY (id_trabajador);


--
-- TOC entry 5340 (class 2606 OID 19750)
-- Name: usuarios usuarios_email_key; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.usuarios
    ADD CONSTRAINT usuarios_email_key UNIQUE (email);


--
-- TOC entry 5342 (class 2606 OID 19746)
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id_usuario);


--
-- TOC entry 5476 (class 2606 OID 21212)
-- Name: usuarios_roles usuarios_roles_id_usuario_id_rol_key; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.usuarios_roles
    ADD CONSTRAINT usuarios_roles_id_usuario_id_rol_key UNIQUE (id_usuario, id_rol);


--
-- TOC entry 5478 (class 2606 OID 21210)
-- Name: usuarios_roles usuarios_roles_pkey; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.usuarios_roles
    ADD CONSTRAINT usuarios_roles_pkey PRIMARY KEY (id_usuario_rol);


--
-- TOC entry 5344 (class 2606 OID 19748)
-- Name: usuarios usuarios_username_key; Type: CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.usuarios
    ADD CONSTRAINT usuarios_username_key UNIQUE (username);


--
-- TOC entry 5370 (class 2606 OID 19952)
-- Name: almacenes almacenes_pkey; Type: CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.almacenes
    ADD CONSTRAINT almacenes_pkey PRIMARY KEY (id_almacen);


--
-- TOC entry 5390 (class 2606 OID 20129)
-- Name: movimientos_inventario movimientos_inventario_pkey; Type: CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.movimientos_inventario
    ADD CONSTRAINT movimientos_inventario_pkey PRIMARY KEY (id_movimiento);


--
-- TOC entry 5386 (class 2606 OID 20093)
-- Name: stock stock_pkey; Type: CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.stock
    ADD CONSTRAINT stock_pkey PRIMARY KEY (id_stock);


--
-- TOC entry 5388 (class 2606 OID 20095)
-- Name: stock uq_stock_producto_almacen; Type: CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.stock
    ADD CONSTRAINT uq_stock_producto_almacen UNIQUE (id_producto, id_variante, id_almacen);


--
-- TOC entry 5324 (class 2606 OID 16795)
-- Name: __EFMigrationsHistory PK___EFMigrationsHistory; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."__EFMigrationsHistory"
    ADD CONSTRAINT "PK___EFMigrationsHistory" PRIMARY KEY (migration_id);


--
-- TOC entry 5412 (class 2606 OID 20349)
-- Name: cajas cajas_pkey; Type: CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.cajas
    ADD CONSTRAINT cajas_pkey PRIMARY KEY (id_caja);


--
-- TOC entry 5414 (class 2606 OID 20383)
-- Name: cotizaciones cotizaciones_pkey; Type: CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.cotizaciones
    ADD CONSTRAINT cotizaciones_pkey PRIMARY KEY (id_cotizacion);


--
-- TOC entry 5416 (class 2606 OID 20408)
-- Name: detalle_cotizacion detalle_cotizacion_pkey; Type: CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.detalle_cotizacion
    ADD CONSTRAINT detalle_cotizacion_pkey PRIMARY KEY (id_detalle_cot);


--
-- TOC entry 5420 (class 2606 OID 20488)
-- Name: detalle_venta detalle_venta_pkey; Type: CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.detalle_venta
    ADD CONSTRAINT detalle_venta_pkey PRIMARY KEY (id_detalle_venta);


--
-- TOC entry 5422 (class 2606 OID 20517)
-- Name: metodos_pago metodos_pago_codigo_key; Type: CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.metodos_pago
    ADD CONSTRAINT metodos_pago_codigo_key UNIQUE (codigo);


--
-- TOC entry 5424 (class 2606 OID 20515)
-- Name: metodos_pago metodos_pago_pkey; Type: CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.metodos_pago
    ADD CONSTRAINT metodos_pago_pkey PRIMARY KEY (id_metodo_pago);


--
-- TOC entry 5428 (class 2606 OID 20559)
-- Name: movimientos_caja movimientos_caja_pkey; Type: CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.movimientos_caja
    ADD CONSTRAINT movimientos_caja_pkey PRIMARY KEY (id_movimiento_caja);


--
-- TOC entry 5426 (class 2606 OID 20534)
-- Name: pagos pagos_pkey; Type: CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.pagos
    ADD CONSTRAINT pagos_pkey PRIMARY KEY (id_pago);


--
-- TOC entry 5418 (class 2606 OID 20456)
-- Name: ventas ventas_pkey; Type: CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.ventas
    ADD CONSTRAINT ventas_pkey PRIMARY KEY (id_venta);


--
-- TOC entry 5441 (class 1259 OID 20722)
-- Name: idx_tablas_generales_codigo; Type: INDEX; Schema: configuracion; Owner: postgres
--

CREATE INDEX idx_tablas_generales_codigo ON configuracion.tablas_generales USING btree (codigo);


--
-- TOC entry 5446 (class 1259 OID 20724)
-- Name: idx_tablas_generales_detalle_codigo; Type: INDEX; Schema: configuracion; Owner: postgres
--

CREATE INDEX idx_tablas_generales_detalle_codigo ON configuracion.tablas_generales_detalle USING btree (codigo);


--
-- TOC entry 5447 (class 1259 OID 20723)
-- Name: idx_tablas_generales_detalle_tabla; Type: INDEX; Schema: configuracion; Owner: postgres
--

CREATE INDEX idx_tablas_generales_detalle_tabla ON configuracion.tablas_generales_detalle USING btree (id_tabla);


--
-- TOC entry 5452 (class 1259 OID 21223)
-- Name: idx_menus_codigo; Type: INDEX; Schema: identidad; Owner: postgres
--

CREATE INDEX idx_menus_codigo ON identidad.menus USING btree (codigo);


--
-- TOC entry 5453 (class 1259 OID 21224)
-- Name: idx_menus_menu_padre; Type: INDEX; Schema: identidad; Owner: postgres
--

CREATE INDEX idx_menus_menu_padre ON identidad.menus USING btree (id_menu_padre);


--
-- TOC entry 5463 (class 1259 OID 21227)
-- Name: idx_roles_menus_menu; Type: INDEX; Schema: identidad; Owner: postgres
--

CREATE INDEX idx_roles_menus_menu ON identidad.roles_menus USING btree (id_menu);


--
-- TOC entry 5464 (class 1259 OID 21226)
-- Name: idx_roles_menus_rol; Type: INDEX; Schema: identidad; Owner: postgres
--

CREATE INDEX idx_roles_menus_rol ON identidad.roles_menus USING btree (id_rol);


--
-- TOC entry 5458 (class 1259 OID 21225)
-- Name: idx_tipos_permiso_codigo; Type: INDEX; Schema: identidad; Owner: postgres
--

CREATE INDEX idx_tipos_permiso_codigo ON identidad.tipos_permiso USING btree (codigo);


--
-- TOC entry 5473 (class 1259 OID 21229)
-- Name: idx_usuarios_roles_rol; Type: INDEX; Schema: identidad; Owner: postgres
--

CREATE INDEX idx_usuarios_roles_rol ON identidad.usuarios_roles USING btree (id_rol);


--
-- TOC entry 5474 (class 1259 OID 21228)
-- Name: idx_usuarios_roles_usuario; Type: INDEX; Schema: identidad; Owner: postgres
--

CREATE INDEX idx_usuarios_roles_usuario ON identidad.usuarios_roles USING btree (id_usuario);


--
-- TOC entry 5551 (class 2620 OID 20667)
-- Name: productos tr_productos_update; Type: TRIGGER; Schema: catalogo; Owner: postgres
--

CREATE TRIGGER tr_productos_update BEFORE UPDATE ON catalogo.productos FOR EACH ROW EXECUTE FUNCTION public.update_fecha_modificacion_column();


--
-- TOC entry 5552 (class 2620 OID 20668)
-- Name: clientes tr_clientes_update; Type: TRIGGER; Schema: clientes; Owner: postgres
--

CREATE TRIGGER tr_clientes_update BEFORE UPDATE ON clientes.clientes FOR EACH ROW EXECUTE FUNCTION public.update_fecha_modificacion_column();


--
-- TOC entry 5549 (class 2620 OID 20665)
-- Name: configuraciones tr_config_update; Type: TRIGGER; Schema: configuracion; Owner: postgres
--

CREATE TRIGGER tr_config_update BEFORE UPDATE ON configuracion.configuraciones FOR EACH ROW EXECUTE FUNCTION public.update_fecha_modificacion_column();


--
-- TOC entry 5548 (class 2620 OID 20664)
-- Name: empresa tr_empresa_update; Type: TRIGGER; Schema: configuracion; Owner: postgres
--

CREATE TRIGGER tr_empresa_update BEFORE UPDATE ON configuracion.empresa FOR EACH ROW EXECUTE FUNCTION public.update_fecha_modificacion_column();


--
-- TOC entry 5550 (class 2620 OID 20666)
-- Name: usuarios tr_usuarios_update; Type: TRIGGER; Schema: identidad; Owner: postgres
--

CREATE TRIGGER tr_usuarios_update BEFORE UPDATE ON identidad.usuarios FOR EACH ROW EXECUTE FUNCTION public.update_fecha_modificacion_column();


--
-- TOC entry 5553 (class 2620 OID 20669)
-- Name: ventas tr_ventas_update; Type: TRIGGER; Schema: ventas; Owner: postgres
--

CREATE TRIGGER tr_ventas_update BEFORE UPDATE ON ventas.ventas FOR EACH ROW EXECUTE FUNCTION public.update_fecha_modificacion_column();


--
-- TOC entry 5487 (class 2606 OID 19898)
-- Name: categorias fk_categoria_padre; Type: FK CONSTRAINT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.categorias
    ADD CONSTRAINT fk_categoria_padre FOREIGN KEY (id_categoria_padre) REFERENCES catalogo.categorias(id_categoria);


--
-- TOC entry 5493 (class 2606 OID 20075)
-- Name: imagenes_producto fk_imagenes_producto; Type: FK CONSTRAINT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.imagenes_producto
    ADD CONSTRAINT fk_imagenes_producto FOREIGN KEY (id_producto) REFERENCES catalogo.productos(id_producto) ON DELETE CASCADE;


--
-- TOC entry 5488 (class 2606 OID 20725)
-- Name: productos fk_producto_tipo; Type: FK CONSTRAINT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.productos
    ADD CONSTRAINT fk_producto_tipo FOREIGN KEY (id_tipo_producto) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 5489 (class 2606 OID 20013)
-- Name: productos fk_productos_categoria; Type: FK CONSTRAINT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.productos
    ADD CONSTRAINT fk_productos_categoria FOREIGN KEY (id_categoria) REFERENCES catalogo.categorias(id_categoria);


--
-- TOC entry 5490 (class 2606 OID 20018)
-- Name: productos fk_productos_marca; Type: FK CONSTRAINT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.productos
    ADD CONSTRAINT fk_productos_marca FOREIGN KEY (id_marca) REFERENCES catalogo.marcas(id_marca);


--
-- TOC entry 5491 (class 2606 OID 20023)
-- Name: productos fk_productos_unidad; Type: FK CONSTRAINT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.productos
    ADD CONSTRAINT fk_productos_unidad FOREIGN KEY (id_unidad) REFERENCES catalogo.unidades_medida(id_unidad);


--
-- TOC entry 5492 (class 2606 OID 20050)
-- Name: variantes_producto fk_variantes_producto; Type: FK CONSTRAINT; Schema: catalogo; Owner: postgres
--

ALTER TABLE ONLY catalogo.variantes_producto
    ADD CONSTRAINT fk_variantes_producto FOREIGN KEY (id_producto) REFERENCES catalogo.productos(id_producto) ON DELETE CASCADE;


--
-- TOC entry 5499 (class 2606 OID 20160)
-- Name: clientes fk_cliente_lista_precio; Type: FK CONSTRAINT; Schema: clientes; Owner: postgres
--

ALTER TABLE ONLY clientes.clientes
    ADD CONSTRAINT fk_cliente_lista_precio FOREIGN KEY (id_lista_precio_asignada) REFERENCES catalogo.listas_precios(id_lista_precio);


--
-- TOC entry 5500 (class 2606 OID 20805)
-- Name: clientes fk_cliente_tipo_cliente; Type: FK CONSTRAINT; Schema: clientes; Owner: postgres
--

ALTER TABLE ONLY clientes.clientes
    ADD CONSTRAINT fk_cliente_tipo_cliente FOREIGN KEY (id_tipo_cliente) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 5501 (class 2606 OID 20800)
-- Name: clientes fk_cliente_tipo_documento; Type: FK CONSTRAINT; Schema: clientes; Owner: postgres
--

ALTER TABLE ONLY clientes.clientes
    ADD CONSTRAINT fk_cliente_tipo_documento FOREIGN KEY (id_tipo_documento) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 5502 (class 2606 OID 20184)
-- Name: contactos_cliente fk_contacto_cliente; Type: FK CONSTRAINT; Schema: clientes; Owner: postgres
--

ALTER TABLE ONLY clientes.contactos_cliente
    ADD CONSTRAINT fk_contacto_cliente FOREIGN KEY (id_cliente) REFERENCES clientes.clientes(id_cliente) ON DELETE CASCADE;


--
-- TOC entry 5509 (class 2606 OID 20302)
-- Name: compras fk_compra_almacen; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.compras
    ADD CONSTRAINT fk_compra_almacen FOREIGN KEY (id_almacen) REFERENCES inventario.almacenes(id_almacen);


--
-- TOC entry 5510 (class 2606 OID 20765)
-- Name: compras fk_compra_estado_pago; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.compras
    ADD CONSTRAINT fk_compra_estado_pago FOREIGN KEY (id_estado_pago) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 5511 (class 2606 OID 20297)
-- Name: compras fk_compra_proveedor; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.compras
    ADD CONSTRAINT fk_compra_proveedor FOREIGN KEY (id_proveedor) REFERENCES compras.proveedores(id_proveedor);


--
-- TOC entry 5512 (class 2606 OID 20760)
-- Name: compras fk_compra_tipo_comprobante; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.compras
    ADD CONSTRAINT fk_compra_tipo_comprobante FOREIGN KEY (id_tipo_comprobante) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 5513 (class 2606 OID 20320)
-- Name: detalle_compra fk_dc_compra; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.detalle_compra
    ADD CONSTRAINT fk_dc_compra FOREIGN KEY (id_compra) REFERENCES compras.compras(id_compra) ON DELETE CASCADE;


--
-- TOC entry 5514 (class 2606 OID 20325)
-- Name: detalle_compra fk_dc_producto; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.detalle_compra
    ADD CONSTRAINT fk_dc_producto FOREIGN KEY (id_producto) REFERENCES catalogo.productos(id_producto);


--
-- TOC entry 5507 (class 2606 OID 20260)
-- Name: detalle_orden_compra fk_doc_orden; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.detalle_orden_compra
    ADD CONSTRAINT fk_doc_orden FOREIGN KEY (id_orden_compra) REFERENCES compras.ordenes_compra(id_orden_compra) ON DELETE CASCADE;


--
-- TOC entry 5508 (class 2606 OID 20265)
-- Name: detalle_orden_compra fk_doc_producto; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.detalle_orden_compra
    ADD CONSTRAINT fk_doc_producto FOREIGN KEY (id_producto) REFERENCES catalogo.productos(id_producto);


--
-- TOC entry 5504 (class 2606 OID 20241)
-- Name: ordenes_compra fk_oc_almacen; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.ordenes_compra
    ADD CONSTRAINT fk_oc_almacen FOREIGN KEY (id_almacen_destino) REFERENCES inventario.almacenes(id_almacen);


--
-- TOC entry 5505 (class 2606 OID 20236)
-- Name: ordenes_compra fk_oc_proveedor; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.ordenes_compra
    ADD CONSTRAINT fk_oc_proveedor FOREIGN KEY (id_proveedor) REFERENCES compras.proveedores(id_proveedor);


--
-- TOC entry 5506 (class 2606 OID 20770)
-- Name: ordenes_compra fk_orden_compra_estado; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.ordenes_compra
    ADD CONSTRAINT fk_orden_compra_estado FOREIGN KEY (id_estado) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 5503 (class 2606 OID 20755)
-- Name: proveedores fk_proveedor_tipo_documento; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.proveedores
    ADD CONSTRAINT fk_proveedor_tipo_documento FOREIGN KEY (id_tipo_documento) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 5479 (class 2606 OID 20795)
-- Name: series_comprobantes fk_serie_comprobante_tipo; Type: FK CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.series_comprobantes
    ADD CONSTRAINT fk_serie_comprobante_tipo FOREIGN KEY (id_tipo_comprobante) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 5540 (class 2606 OID 20717)
-- Name: tablas_generales_detalle fk_tabla_general; Type: FK CONSTRAINT; Schema: configuracion; Owner: postgres
--

ALTER TABLE ONLY configuracion.tablas_generales_detalle
    ADD CONSTRAINT fk_tabla_general FOREIGN KEY (id_tabla) REFERENCES configuracion.tablas_generales(id_tabla) ON DELETE CASCADE;


--
-- TOC entry 5537 (class 2606 OID 20785)
-- Name: asientos_contables fk_asiento_estado; Type: FK CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.asientos_contables
    ADD CONSTRAINT fk_asiento_estado FOREIGN KEY (id_estado) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 5535 (class 2606 OID 20595)
-- Name: plan_cuentas fk_cuenta_padre; Type: FK CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.plan_cuentas
    ADD CONSTRAINT fk_cuenta_padre FOREIGN KEY (id_cuenta_padre) REFERENCES contabilidad.plan_cuentas(id_cuenta);


--
-- TOC entry 5538 (class 2606 OID 20654)
-- Name: detalle_asiento fk_da_asiento; Type: FK CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.detalle_asiento
    ADD CONSTRAINT fk_da_asiento FOREIGN KEY (id_asiento) REFERENCES contabilidad.asientos_contables(id_asiento) ON DELETE CASCADE;


--
-- TOC entry 5539 (class 2606 OID 20659)
-- Name: detalle_asiento fk_da_cuenta; Type: FK CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.detalle_asiento
    ADD CONSTRAINT fk_da_cuenta FOREIGN KEY (id_cuenta) REFERENCES contabilidad.plan_cuentas(id_cuenta);


--
-- TOC entry 5536 (class 2606 OID 20780)
-- Name: plan_cuentas fk_plan_cuenta_tipo; Type: FK CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.plan_cuentas
    ADD CONSTRAINT fk_plan_cuenta_tipo FOREIGN KEY (id_tipo_cuenta) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 5483 (class 2606 OID 19842)
-- Name: cargos fk_cargos_area; Type: FK CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.cargos
    ADD CONSTRAINT fk_cargos_area FOREIGN KEY (id_area) REFERENCES identidad.areas(id_area);


--
-- TOC entry 5481 (class 2606 OID 19793)
-- Name: roles_permisos fk_rp_permiso; Type: FK CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.roles_permisos
    ADD CONSTRAINT fk_rp_permiso FOREIGN KEY (id_permiso) REFERENCES identidad.permisos(id_permiso) ON DELETE CASCADE;


--
-- TOC entry 5482 (class 2606 OID 19788)
-- Name: roles_permisos fk_rp_rol; Type: FK CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.roles_permisos
    ADD CONSTRAINT fk_rp_rol FOREIGN KEY (id_rol) REFERENCES identidad.roles(id_rol) ON DELETE CASCADE;


--
-- TOC entry 5484 (class 2606 OID 20790)
-- Name: trabajadores fk_trabajador_tipo_documento; Type: FK CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.trabajadores
    ADD CONSTRAINT fk_trabajador_tipo_documento FOREIGN KEY (id_tipo_documento) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 5485 (class 2606 OID 19871)
-- Name: trabajadores fk_trabajadores_cargo; Type: FK CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.trabajadores
    ADD CONSTRAINT fk_trabajadores_cargo FOREIGN KEY (id_cargo) REFERENCES identidad.cargos(id_cargo);


--
-- TOC entry 5486 (class 2606 OID 19876)
-- Name: trabajadores fk_trabajadores_usuario; Type: FK CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.trabajadores
    ADD CONSTRAINT fk_trabajadores_usuario FOREIGN KEY (id_usuario) REFERENCES identidad.usuarios(id_usuario);


--
-- TOC entry 5480 (class 2606 OID 19751)
-- Name: usuarios fk_usuarios_rol; Type: FK CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.usuarios
    ADD CONSTRAINT fk_usuarios_rol FOREIGN KEY (id_rol) REFERENCES identidad.roles(id_rol) ON DELETE RESTRICT;


--
-- TOC entry 5541 (class 2606 OID 21114)
-- Name: menus menus_id_menu_padre_fkey; Type: FK CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.menus
    ADD CONSTRAINT menus_id_menu_padre_fkey FOREIGN KEY (id_menu_padre) REFERENCES identidad.menus(id_menu) ON DELETE CASCADE;


--
-- TOC entry 5542 (class 2606 OID 21162)
-- Name: roles_menus roles_menus_id_menu_fkey; Type: FK CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.roles_menus
    ADD CONSTRAINT roles_menus_id_menu_fkey FOREIGN KEY (id_menu) REFERENCES identidad.menus(id_menu) ON DELETE CASCADE;


--
-- TOC entry 5543 (class 2606 OID 21157)
-- Name: roles_menus roles_menus_id_rol_fkey; Type: FK CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.roles_menus
    ADD CONSTRAINT roles_menus_id_rol_fkey FOREIGN KEY (id_rol) REFERENCES identidad.roles(id_rol) ON DELETE CASCADE;


--
-- TOC entry 5544 (class 2606 OID 21185)
-- Name: roles_menus_permisos roles_menus_permisos_id_rol_menu_fkey; Type: FK CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.roles_menus_permisos
    ADD CONSTRAINT roles_menus_permisos_id_rol_menu_fkey FOREIGN KEY (id_rol_menu) REFERENCES identidad.roles_menus(id_rol_menu) ON DELETE CASCADE;


--
-- TOC entry 5545 (class 2606 OID 21190)
-- Name: roles_menus_permisos roles_menus_permisos_id_tipo_permiso_fkey; Type: FK CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.roles_menus_permisos
    ADD CONSTRAINT roles_menus_permisos_id_tipo_permiso_fkey FOREIGN KEY (id_tipo_permiso) REFERENCES identidad.tipos_permiso(id_tipo_permiso) ON DELETE CASCADE;


--
-- TOC entry 5546 (class 2606 OID 21218)
-- Name: usuarios_roles usuarios_roles_id_rol_fkey; Type: FK CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.usuarios_roles
    ADD CONSTRAINT usuarios_roles_id_rol_fkey FOREIGN KEY (id_rol) REFERENCES identidad.roles(id_rol) ON DELETE CASCADE;


--
-- TOC entry 5547 (class 2606 OID 21213)
-- Name: usuarios_roles usuarios_roles_id_usuario_fkey; Type: FK CONSTRAINT; Schema: identidad; Owner: postgres
--

ALTER TABLE ONLY identidad.usuarios_roles
    ADD CONSTRAINT usuarios_roles_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES identidad.usuarios(id_usuario) ON DELETE CASCADE;


--
-- TOC entry 5497 (class 2606 OID 20775)
-- Name: movimientos_inventario fk_movimiento_inventario_tipo; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.movimientos_inventario
    ADD CONSTRAINT fk_movimiento_inventario_tipo FOREIGN KEY (id_tipo_movimiento) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 5498 (class 2606 OID 20130)
-- Name: movimientos_inventario fk_movimiento_stock; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.movimientos_inventario
    ADD CONSTRAINT fk_movimiento_stock FOREIGN KEY (id_stock) REFERENCES inventario.stock(id_stock);


--
-- TOC entry 5494 (class 2606 OID 20106)
-- Name: stock fk_stock_almacen; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.stock
    ADD CONSTRAINT fk_stock_almacen FOREIGN KEY (id_almacen) REFERENCES inventario.almacenes(id_almacen);


--
-- TOC entry 5495 (class 2606 OID 20096)
-- Name: stock fk_stock_producto; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.stock
    ADD CONSTRAINT fk_stock_producto FOREIGN KEY (id_producto) REFERENCES catalogo.productos(id_producto);


--
-- TOC entry 5496 (class 2606 OID 20101)
-- Name: stock fk_stock_variante; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.stock
    ADD CONSTRAINT fk_stock_variante FOREIGN KEY (id_variante) REFERENCES catalogo.variantes_producto(id_variante);


--
-- TOC entry 5515 (class 2606 OID 20350)
-- Name: cajas fk_caja_almacen; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.cajas
    ADD CONSTRAINT fk_caja_almacen FOREIGN KEY (id_almacen) REFERENCES inventario.almacenes(id_almacen);


--
-- TOC entry 5516 (class 2606 OID 20745)
-- Name: cajas fk_caja_estado; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.cajas
    ADD CONSTRAINT fk_caja_estado FOREIGN KEY (id_estado) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 5517 (class 2606 OID 20384)
-- Name: cotizaciones fk_cot_cliente; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.cotizaciones
    ADD CONSTRAINT fk_cot_cliente FOREIGN KEY (id_cliente) REFERENCES clientes.clientes(id_cliente);


--
-- TOC entry 5518 (class 2606 OID 20389)
-- Name: cotizaciones fk_cot_vendedor; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.cotizaciones
    ADD CONSTRAINT fk_cot_vendedor FOREIGN KEY (id_usuario_vendedor) REFERENCES identidad.usuarios(id_usuario);


--
-- TOC entry 5519 (class 2606 OID 20740)
-- Name: cotizaciones fk_cotizacion_estado; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.cotizaciones
    ADD CONSTRAINT fk_cotizacion_estado FOREIGN KEY (id_estado) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 5520 (class 2606 OID 20409)
-- Name: detalle_cotizacion fk_dcot_cotizacion; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.detalle_cotizacion
    ADD CONSTRAINT fk_dcot_cotizacion FOREIGN KEY (id_cotizacion) REFERENCES ventas.cotizaciones(id_cotizacion) ON DELETE CASCADE;


--
-- TOC entry 5521 (class 2606 OID 20414)
-- Name: detalle_cotizacion fk_dcot_producto; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.detalle_cotizacion
    ADD CONSTRAINT fk_dcot_producto FOREIGN KEY (id_producto) REFERENCES catalogo.productos(id_producto);


--
-- TOC entry 5528 (class 2606 OID 20494)
-- Name: detalle_venta fk_dv_producto; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.detalle_venta
    ADD CONSTRAINT fk_dv_producto FOREIGN KEY (id_producto) REFERENCES catalogo.productos(id_producto);


--
-- TOC entry 5529 (class 2606 OID 20489)
-- Name: detalle_venta fk_dv_venta; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.detalle_venta
    ADD CONSTRAINT fk_dv_venta FOREIGN KEY (id_venta) REFERENCES ventas.ventas(id_venta) ON DELETE CASCADE;


--
-- TOC entry 5532 (class 2606 OID 20560)
-- Name: movimientos_caja fk_mc_caja; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.movimientos_caja
    ADD CONSTRAINT fk_mc_caja FOREIGN KEY (id_caja) REFERENCES ventas.cajas(id_caja);


--
-- TOC entry 5533 (class 2606 OID 20565)
-- Name: movimientos_caja fk_mc_pago; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.movimientos_caja
    ADD CONSTRAINT fk_mc_pago FOREIGN KEY (id_pago_relacionado) REFERENCES ventas.pagos(id_pago);


--
-- TOC entry 5534 (class 2606 OID 20750)
-- Name: movimientos_caja fk_movimiento_caja_tipo; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.movimientos_caja
    ADD CONSTRAINT fk_movimiento_caja_tipo FOREIGN KEY (id_tipo_movimiento) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 5530 (class 2606 OID 20540)
-- Name: pagos fk_pago_metodo; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.pagos
    ADD CONSTRAINT fk_pago_metodo FOREIGN KEY (id_metodo_pago) REFERENCES ventas.metodos_pago(id_metodo_pago);


--
-- TOC entry 5531 (class 2606 OID 20535)
-- Name: pagos fk_pago_venta; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.pagos
    ADD CONSTRAINT fk_pago_venta FOREIGN KEY (id_venta) REFERENCES ventas.ventas(id_venta);


--
-- TOC entry 5522 (class 2606 OID 20464)
-- Name: ventas fk_venta_almacen; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.ventas
    ADD CONSTRAINT fk_venta_almacen FOREIGN KEY (id_almacen) REFERENCES inventario.almacenes(id_almacen);


--
-- TOC entry 5523 (class 2606 OID 20469)
-- Name: ventas fk_venta_caja; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.ventas
    ADD CONSTRAINT fk_venta_caja FOREIGN KEY (id_caja) REFERENCES ventas.cajas(id_caja);


--
-- TOC entry 5524 (class 2606 OID 20459)
-- Name: ventas fk_venta_cliente; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.ventas
    ADD CONSTRAINT fk_venta_cliente FOREIGN KEY (id_cliente) REFERENCES clientes.clientes(id_cliente);


--
-- TOC entry 5525 (class 2606 OID 20730)
-- Name: ventas fk_venta_estado; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.ventas
    ADD CONSTRAINT fk_venta_estado FOREIGN KEY (id_estado) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 5526 (class 2606 OID 20735)
-- Name: ventas fk_venta_estado_pago; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.ventas
    ADD CONSTRAINT fk_venta_estado_pago FOREIGN KEY (id_estado_pago) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


--
-- TOC entry 5527 (class 2606 OID 20810)
-- Name: ventas fk_venta_tipo_comprobante; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.ventas
    ADD CONSTRAINT fk_venta_tipo_comprobante FOREIGN KEY (id_tipo_comprobante) REFERENCES configuracion.tablas_generales_detalle(id_detalle);


-- Completed on 2026-01-29 17:44:15

--
--


