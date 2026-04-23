import { Suspense, lazy, ReactNode } from "react";
import { createBrowserRouter, Navigate } from "react-router-dom";
import { LayoutPrincipal } from "@/layouts/LayoutPrincipal/LayoutPrincipal";
import { RutaProtegida } from "@/compartido/componentes/seguridad/RutaProtegida";

// Carga perezosa de páginas para optimizar el rendimiento
const PaginaDashboard = lazy(() =>
  import("@/features/dashboard/paginas/PaginaDashboard").then((m) => ({
    default: m.PaginaDashboard,
  })),
);
const PaginaProductos = lazy(() =>
  import("@/features/catalogo/paginas/PaginaProductos").then((m) => ({
    default: m.PaginaProductos,
  })),
);
const PaginaCategorias = lazy(() =>
  import("@/features/catalogo/paginas/PaginaCategorias").then((m) => ({
    default: m.PaginaCategorias,
  })),
);
const PaginaMarcas = lazy(() =>
  import("@/features/catalogo/paginas/PaginaMarcas").then((m) => ({
    default: m.PaginaMarcas,
  })),
);
const PaginaTablasGenerales = lazy(() =>
  import("@/features/configuracion/paginas/PaginaTablasGenerales").then(
    (m) => ({
      default: m.PaginaTablasGenerales,
    }),
  ),
);
const PaginaEmpresa = lazy(() => import("@/features/configuracion/paginas/PaginaEmpresa"));
const PaginaSucursales = lazy(() =>
  import("@/features/configuracion/paginas/PaginaSucursales").then((m) => ({
    default: m.PaginaSucursales,
  })),
);
const PaginaImpuestos = lazy(() =>
  import("@/features/configuracion/paginas/PaginaImpuestos").then((m) => ({
    default: m.PaginaImpuestos,
  })),
);
const PaginaMetodosPago = lazy(() =>
  import("@/features/configuracion/paginas/PaginaMetodosPago").then((m) => ({
    default: m.PaginaMetodosPago,
  })),
);
const PaginaComprobantes = lazy(() =>
  import("@/features/configuracion/paginas/PaginaComprobantes").then((m) => ({
    default: m.PaginaComprobantes,
  })),
);
const PaginaReglasDocumento = lazy(() =>
  import("@/features/configuracion/paginas/PaginaReglasDocumento").then(
    (m) => ({
      default: m.PaginaReglasDocumento,
    }),
  ),
);
const PaginaOperacionesSunat = lazy(() =>
  import("@/features/configuracion/paginas/PaginaOperacionesSunat").then(
    (m) => ({
      default: m.PaginaOperacionesSunat,
    }),
  ),
);
const PaginaMatrizReglas = lazy(() => import("@/features/configuracion/paginas/PaginaMatrizReglas").then((m) => ({ default: m.PaginaMatrizReglas })));
const PaginaAfectacionIgv = lazy(() => import("@/features/configuracion/paginas/PaginaAfectacionIgv").then((m) => ({ default: m.PaginaAfectacionIgv })));
const PaginaTiposTributo = lazy(() => import("@/features/configuracion/paginas/PaginaTiposTributo").then((m) => ({ default: m.PaginaTiposTributo })));
const PaginaUbigeos = lazy(() => import("@/features/configuracion/paginas/PaginaUbigeos").then((m) => ({ default: m.PaginaUbigeos })));

const PaginaPOS = lazy(() =>
  import("@/features/ventas/paginas/PaginaPOS").then((m) => ({
    default: m.PaginaPOS,
  })),
);
const PaginaClientes = lazy(() =>
  import("@/features/clientes/paginas/PaginaClientes").then((m) => ({
    default: m.PaginaClientes,
  })),
);
const PaginaProveedores = lazy(() =>
  import("@/features/compras/proveedores/paginas/PaginaProveedores").then(
    (m) => ({
      default: m.PaginaProveedores,
    }),
  ),
);
const PaginaCompras = lazy(() =>
  import("@/features/compras/compras/paginas/PaginaCompras").then((m) => ({
    default: m.PaginaCompras,
  })),
);
const PaginaOrdenesCompra = lazy(() => import("@/features/compras/ordenes-compra/paginas/PaginaOrdenCompra"));
const PaginaNotasCompra = lazy(() =>
  import("@/features/compras/compras/paginas/PaginaNotasCompra").then((m) => ({
    default: m.PaginaNotasCompra,
  })),
);
const PaginaVentas = lazy(() =>
  import("@/features/ventas/paginas/PaginaVentas").then((m) => ({
    default: m.PaginaVentas,
  })),
);
const PaginaNotas = lazy(() =>
  import("@/features/ventas/paginas/PaginaNotas").then((m) => ({
    default: m.PaginaNotas,
  })),
);
const PaginaCatalogosSunat = lazy(() =>
  import("@/features/configuracion/paginas/PaginaCatalogosSunat").then((m) => ({
    default: m.PaginaCatalogosSunat,
  })),
);
const PaginaCotizaciones = lazy(() =>
  import("@/features/ventas/paginas/PaginaCotizaciones").then((m) => ({
    default: m.PaginaCotizaciones,
  })),
);
const PaginaHistorialTurnos = lazy(() =>
  import("@/features/ventas/paginas/PaginaHistorialTurnos").then((m) => ({
    default: m.PaginaHistorialTurnos,
  })),
);
const PaginaCajas = lazy(() =>
  import("@/features/ventas/paginas/PaginaCajas").then((m) => ({
    default: m.PaginaCajas,
  })),
);
const PaginaUnidadesMedida = lazy(() =>
  import("@/features/catalogo/paginas/PaginaUnidadesMedida").then((m) => ({
    default: m.PaginaUnidadesMedida,
  })),
);
const PaginaListasPrecios = lazy(() =>
  import("@/features/catalogo/paginas/PaginaListasPrecios").then((m) => ({
    default: m.PaginaListasPrecios,
  })),
);
const PaginaStock = lazy(() =>
  import("@/features/inventario/paginas/PaginaStock").then((m) => ({
    default: m.PaginaStock,
  })),
);
const PaginaMovimientos = lazy(() =>
  import("@/features/inventario/paginas/PaginaMovimientos").then((m) => ({
    default: m.PaginaMovimientos,
  })),
);
const PaginaAlmacenes = lazy(() =>
  import("@/features/inventario/almacenes/paginas/PaginaAlmacenes").then(
    (m) => ({
      default: m.PaginaAlmacenes,
    }),
  ),
);
const PaginaKardexPeriodos = lazy(() =>
  import("@/features/inventario/paginas/PaginaKardexPeriodos").then((m) => ({
    default: m.PaginaKardexPeriodos,
  })),
);
const PaginaKardexReporte = lazy(() =>
  import("@/features/inventario/paginas/PaginaKardexReporte").then((m) => ({
    default: m.PaginaKardexReporte,
  })),
);
const PaginaTraslados = lazy(() =>
  import("@/features/inventario/paginas/PaginaTraslados").then((m) => ({
    default: m.PaginaTraslados,
  })),
);
const PaginaReportesHub = lazy(() =>
  import("@/features/reportes/paginas/PaginaReportesHub").then((m) => ({
    default: m.PaginaReportesHub,
  })),
);
const PaginaReporteStockCritico = lazy(() => import("@/features/reportes/paginas/PaginaReporteStockCritico").then((m) => ({ default: m.PaginaReporteStockCritico })));
const PaginaReporteRankingProductos = lazy(() => import("@/features/reportes/paginas/PaginaReporteRankingProductos"));
const PaginaReporteTopClientes = lazy(() => import("@/features/reportes/paginas/PaginaReporteTopClientes"));
const PaginaReporteComprasProveedor = lazy(() => import("@/features/reportes/paginas/PaginaReporteComprasProveedor"));

// Identidad / Seguridad
const PaginaUsuarios = lazy(() => import("@/features/identidad/pages/PaginaUsuarios").then((m) => ({ default: m.PaginaUsuarios })));
const PaginaRoles = lazy(() => import("@/features/identidad/pages/PaginaRoles").then((m) => ({ default: m.PaginaRoles })));
const PaginaTrabajadores = lazy(() => import("@/features/identidad/pages/PaginaTrabajadores").then((m) => ({ default: m.PaginaTrabajadores })));
const PaginaPerfil = lazy(() => import("@/features/identidad/pages/PaginaPerfil").then((m) => ({ default: m.PaginaPerfil })));
const PaginaConfiguracionUsuario = lazy(() => import("@/features/identidad/pages/PaginaConfiguracionUsuario").then((m) => ({ default: m.PaginaConfiguracionUsuario })));

const CargandoPagina = () => (
  <div className="flex h-[calc(100vh-80px)] w-full items-center justify-center">
    <div className="flex flex-col items-center gap-4">
      <div className="h-12 w-12 animate-spin rounded-full border-4 border-primary border-t-transparent shadow-lg" />
      <p className="text-sm font-medium text-muted-foreground animate-pulse">
        Cargando módulo...
      </p>
    </div>
  </div>
);

const PaginaLogin = lazy(() => import("@/features/identidad/pages/PaginaLogin").then((m) => ({ default: m.PaginaLogin })));

const RutaConPermiso = ({ children, codigoPermiso }: { children: ReactNode; codigoPermiso: string }) => (
  <RutaProtegida codigoPermiso={codigoPermiso}>{children}</RutaProtegida>
);

export const ruteador = createBrowserRouter(
  [
    {
      path: "/login",
      element: (
        <Suspense fallback={<CargandoPagina />}>
          <PaginaLogin />
        </Suspense>
      ),
    },
    {
      path: "/",
      element: (
        <RutaProtegida>
          <LayoutPrincipal />
        </RutaProtegida>
      ),
      children: [
        {
          index: true,
          element: <Navigate to="/dashboard" replace />,
        },
        {
          path: "dashboard",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaDashboard />
            </Suspense>
          ),
        },
        {
          path: "catalogo/productos",
          element: (
            <RutaConPermiso codigoPermiso="CAT_PRODUCTOS">
              <Suspense fallback={<CargandoPagina />}>
                <PaginaProductos />
              </Suspense>
            </RutaConPermiso>
          ),
        },
        {
          path: "catalogo/categorias",
          element: (
            <RutaConPermiso codigoPermiso="CAT_CATEGORIAS">
              <Suspense fallback={<CargandoPagina />}>
                <PaginaCategorias />
              </Suspense>
            </RutaConPermiso>
          ),
        },
        {
          path: "catalogo/marcas",
          element: (
            <RutaConPermiso codigoPermiso="CAT_MARCAS">
              <Suspense fallback={<CargandoPagina />}>
                <PaginaMarcas />
              </Suspense>
            </RutaConPermiso>
          ),
        },
        {
          path: "catalogo/unidades-medida",
          element: (
            <RutaConPermiso codigoPermiso="CAT_UNIDADES">
              <Suspense fallback={<CargandoPagina />}>
                <PaginaUnidadesMedida />
              </Suspense>
            </RutaConPermiso>
          ),
        },
        {
          path: "catalogo/listas-precios",
          element: (
            <RutaConPermiso codigoPermiso="CAT_PRECIOS">
              <Suspense fallback={<CargandoPagina />}>
                <PaginaListasPrecios />
              </Suspense>
            </RutaConPermiso>
          ),
        },
        {
          path: "configuracion/tablas-generales",
          element: (
            <RutaConPermiso codigoPermiso="CONF_GENERAL">
              <Suspense fallback={<CargandoPagina />}>
                <PaginaTablasGenerales />
              </Suspense>
            </RutaConPermiso>
          ),
        },
        {
          path: "configuracion/empresa",
          element: (
            <RutaConPermiso codigoPermiso="CONFIGURACION">
              <Suspense fallback={<CargandoPagina />}>
                <PaginaEmpresa />
              </Suspense>
            </RutaConPermiso>
          ),
        },
        {
          path: "configuracion/sucursales",
          element: (
            <RutaConPermiso codigoPermiso="CONF_GENERAL">
              <Suspense fallback={<CargandoPagina />}>
                <PaginaSucursales />
              </Suspense>
            </RutaConPermiso>
          ),
        },
        {
          path: "configuracion/impuestos",
          element: (
            <RutaConPermiso codigoPermiso="CONF_FISCAL">
              <Suspense fallback={<CargandoPagina />}>
                <PaginaImpuestos />
              </Suspense>
            </RutaConPermiso>
          ),
        },
        {
          path: "configuracion/afectacion-igv",
          element: (
            <RutaConPermiso codigoPermiso="CONF_FISCAL">
              <Suspense fallback={<CargandoPagina />}>
                <PaginaAfectacionIgv />
              </Suspense>
            </RutaConPermiso>
          ),
        },
        {
          path: "configuracion/tipos-tributo",
          element: (
            <RutaConPermiso codigoPermiso="CONF_FISCAL">
              <Suspense fallback={<CargandoPagina />}>
                <PaginaTiposTributo />
              </Suspense>
            </RutaConPermiso>
          ),
        },
        {
          path: "configuracion/metodos-pago",
          element: (
            <RutaConPermiso codigoPermiso="CONFIGURACION">
              <Suspense fallback={<CargandoPagina />}>
                <PaginaMetodosPago />
              </Suspense>
            </RutaConPermiso>
          ),
        },
        {
          path: "configuracion/comprobantes",
          element: (
            <RutaConPermiso codigoPermiso="CONFIGURACION">
              <Suspense fallback={<CargandoPagina />}>
                <PaginaComprobantes />
              </Suspense>
            </RutaConPermiso>
          ),
        },
        {
          path: "configuracion/reglas-sunat",
          element: (
            <RutaConPermiso codigoPermiso="CONFIGURACION">
              <Suspense fallback={<CargandoPagina />}>
                <PaginaReglasDocumento />
              </Suspense>
            </RutaConPermiso>
          ),
        },
        {
          path: "configuracion/operaciones-sunat",
          element: (
            <RutaConPermiso codigoPermiso="CONFIGURACION">
              <Suspense fallback={<CargandoPagina />}>
                <PaginaOperacionesSunat />
              </Suspense>
            </RutaConPermiso>
          ),
        },
        {
          path: "configuracion/matriz-sunat",
          element: (
            <RutaConPermiso codigoPermiso="CONFIGURACION">
              <Suspense fallback={<CargandoPagina />}>
                <PaginaMatrizReglas />
              </Suspense>
            </RutaConPermiso>
          ),
        },
        {
          path: "configuracion/ubigeos",
          element: (
            <RutaConPermiso codigoPermiso="CONFIGURACION">
              <Suspense fallback={<CargandoPagina />}>
                <PaginaUbigeos />
              </Suspense>
            </RutaConPermiso>
          ),
        },
        {
          path: "configuracion/sunat",
          element: (
            <RutaConPermiso codigoPermiso="CONFIGURACION">
              <Suspense fallback={<CargandoPagina />}>
                <PaginaCatalogosSunat />
              </Suspense>
            </RutaConPermiso>
          ),
        },

        {
          path: "clientes",
          element: (
            <RutaConPermiso codigoPermiso="VEN_CLIENTES">
              <Suspense fallback={<CargandoPagina />}>
                <PaginaClientes />
              </Suspense>
            </RutaConPermiso>
          ),
        },
        {
          path: "compras/lista",
          element: (
            <RutaConPermiso codigoPermiso="COM_LISTA">
              <Suspense fallback={<CargandoPagina />}>
                <PaginaCompras />
              </Suspense>
            </RutaConPermiso>
          ),
        },
        {
          path: "compras/notas",
          element: (
            <RutaConPermiso codigoPermiso="COM_NOTAS">
              <Suspense fallback={<CargandoPagina />}>
                <PaginaNotasCompra />
              </Suspense>
            </RutaConPermiso>
          ),
        },
        {
          path: "proveedores/ordenes",
          element: (
            <RutaConPermiso codigoPermiso="COM_ORDENES">
              <Suspense fallback={<CargandoPagina />}>
                <PaginaOrdenesCompra />
              </Suspense>
            </RutaConPermiso>
          ),
        },
        {
          path: "proveedores",
          element: (
            <RutaConPermiso codigoPermiso="COM_PROVEEDORES">
              <Suspense fallback={<CargandoPagina />}>
                <PaginaProveedores />
              </Suspense>
            </RutaConPermiso>
          ),
        },
        {
          path: "inventario/almacenes",
          element: (
            <RutaConPermiso codigoPermiso="INV_ALMACENES">
              <Suspense fallback={<CargandoPagina />}>
                <PaginaAlmacenes />
              </Suspense>
            </RutaConPermiso>
          ),
        },
        {
          path: "inventario/kardex/periodos",
          element: (
            <RutaConPermiso codigoPermiso="INV_KARDEX_PER">
              <Suspense fallback={<CargandoPagina />}>
                <PaginaKardexPeriodos />
              </Suspense>
            </RutaConPermiso>
          ),
        },
        {
          path: "inventario/kardex/reporte",
          element: (
            <RutaConPermiso codigoPermiso="INV_KARDEX_REP">
              <Suspense fallback={<CargandoPagina />}>
                <PaginaKardexReporte />
              </Suspense>
            </RutaConPermiso>
          ),
        },
        {
          path: "inventario/traslados",
          element: (
            <RutaConPermiso codigoPermiso="INV_TRASLADOS">
              <Suspense fallback={<CargandoPagina />}>
                <PaginaTraslados />
              </Suspense>
            </RutaConPermiso>
          ),
        },
        {
          path: "inventario/stock",
          element: (
            <RutaConPermiso codigoPermiso="INV_STOCK">
              <Suspense fallback={<CargandoPagina />}>
                <PaginaStock />
              </Suspense>
            </RutaConPermiso>
          ),
        },
        {
          path: "inventario/movimientos",
          element: (
            <RutaConPermiso codigoPermiso="INV_MOVIMIENTOS">
              <Suspense fallback={<CargandoPagina />}>
                <PaginaMovimientos />
              </Suspense>
            </RutaConPermiso>
          ),
        },
        {
          path: "ventas/lista",
          element: (
            <RutaConPermiso codigoPermiso="VEN_LISTA">
              <Suspense fallback={<CargandoPagina />}>
                <PaginaVentas />
              </Suspense>
            </RutaConPermiso>
          ),
        },
        {
          path: "ventas/cotizaciones",
          element: (
            <RutaConPermiso codigoPermiso="VEN_COTIZACIONES">
              <Suspense fallback={<CargandoPagina />}>
                <PaginaCotizaciones />
              </Suspense>
            </RutaConPermiso>
          ),
        },
        {
          path: "ventas/notas",
          element: (
            <RutaConPermiso codigoPermiso="VEN_NOTAS">
              <Suspense fallback={<CargandoPagina />}>
                <PaginaNotas />
              </Suspense>
            </RutaConPermiso>
          ),
        },
        {
          path: "ventas/pos",
          element: (
            <RutaConPermiso codigoPermiso="VEN_POS">
              <Suspense fallback={<CargandoPagina />}>
                <PaginaPOS />
              </Suspense>
            </RutaConPermiso>
          ),
        },
        {
          path: "ventas/turnos",
          element: (
            <RutaConPermiso codigoPermiso="VEN_TURNOS">
              <Suspense fallback={<CargandoPagina />}>
                <PaginaHistorialTurnos />
              </Suspense>
            </RutaConPermiso>
          ),
        },
        {
          path: "ventas/cajas",
          element: (
            <RutaConPermiso codigoPermiso="VEN_CAJAS">
              <Suspense fallback={<CargandoPagina />}>
                <PaginaCajas />
              </Suspense>
            </RutaConPermiso>
          ),
        },
        {
          path: "reportes",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaReportesHub />
            </Suspense>
          ),
        },
        {
          path: "reportes/stock-critico",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaReporteStockCritico />
            </Suspense>
          ),
        },
        {
          path: "reportes/ranking-productos",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaReporteRankingProductos />
            </Suspense>
          ),
        },
        {
          path: "reportes/top-clientes",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaReporteTopClientes />
            </Suspense>
          ),
        },
        {
          path: "reportes/compras-proveedor",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaReporteComprasProveedor />
            </Suspense>
          ),
        },
        // Módulo de Seguridad e Identidad
        {
          path: "seguridad/usuarios",
          element: (
            <RutaConPermiso codigoPermiso="SEG_USUARIOS">
              <Suspense fallback={<CargandoPagina />}>
                <PaginaUsuarios />
              </Suspense>
            </RutaConPermiso>
          ),
        },
        {
          path: "seguridad/roles",
          element: (
            <RutaConPermiso codigoPermiso="SEG_ROLES">
              <Suspense fallback={<CargandoPagina />}>
                <PaginaRoles />
              </Suspense>
            </RutaConPermiso>
          ),
        },
        {
          path: "seguridad/trabajadores",
          element: (
            <RutaConPermiso codigoPermiso="SEG_TRABAJADORES">
              <Suspense fallback={<CargandoPagina />}>
                <PaginaTrabajadores />
              </Suspense>
            </RutaConPermiso>
          ),
        },
        {
          path: "perfil",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaPerfil />
            </Suspense>
          ),
        },
        {
          path: "configuracion-usuario",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaConfiguracionUsuario />
            </Suspense>
          ),
        },
        {
          path: "*",
          element: (
            <div className="flex flex-col items-center justify-center h-screen gap-4">
              <h1 className="text-4xl font-bold">404</h1>
              <p className="text-muted-foreground">Página no encontrada</p>
              <Navigate to="/dashboard" />
            </div>
          ),
        },
      ],
    },
  ],
  {
    future: {
      v7_startTransition: true,
      v7_relativeSplatPath: true,
      v7_fetcherPersist: true,
      v7_normalizeFormMethod: true,
      v7_partialHydration: true,
      v7_skipActionErrorRevalidation: true,
    },
  },
);
