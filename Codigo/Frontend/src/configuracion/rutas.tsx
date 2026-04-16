import { Suspense, lazy } from "react";
import { createBrowserRouter, Navigate } from "react-router-dom";
import { LayoutPrincipal } from "@/layouts/LayoutPrincipal/LayoutPrincipal";

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
import { RutaProtegida } from "@/compartido/componentes/seguridad/RutaProtegida";

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
            <Suspense fallback={<CargandoPagina />}>
              <PaginaProductos />
            </Suspense>
          ),
        },
        {
          path: "catalogo/categorias",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaCategorias />
            </Suspense>
          ),
        },
        {
          path: "catalogo/marcas",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaMarcas />
            </Suspense>
          ),
        },
        {
          path: "catalogo/unidades-medida",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaUnidadesMedida />
            </Suspense>
          ),
        },
        {
          path: "catalogo/listas-precios",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaListasPrecios />
            </Suspense>
          ),
        },
        {
          path: "configuracion/tablas-generales",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaTablasGenerales />
            </Suspense>
          ),
        },
        {
          path: "configuracion/empresa",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaEmpresa />
            </Suspense>
          ),
        },
        {
          path: "configuracion/sucursales",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaSucursales />
            </Suspense>
          ),
        },
        {
          path: "configuracion/impuestos",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaImpuestos />
            </Suspense>
          ),
        },
        {
          path: "configuracion/afectacion-igv",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaAfectacionIgv />
            </Suspense>
          ),
        },
        {
          path: "configuracion/tipos-tributo",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaTiposTributo />
            </Suspense>
          ),
        },
        {
          path: "configuracion/metodos-pago",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaMetodosPago />
            </Suspense>
          ),
        },
        {
          path: "configuracion/comprobantes",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaComprobantes />
            </Suspense>
          ),
        },
        {
          path: "configuracion/reglas-sunat",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaReglasDocumento />
            </Suspense>
          ),
        },
        {
          path: "configuracion/operaciones-sunat",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaOperacionesSunat />
            </Suspense>
          ),
        },
        {
          path: "configuracion/matriz-sunat",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaMatrizReglas />
            </Suspense>
          ),
        },
        {
          path: "configuracion/ubigeos",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaUbigeos />
            </Suspense>
          ),
        },
        {
          path: "configuracion/sunat",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaCatalogosSunat />
            </Suspense>
          ),
        },

        {
          path: "clientes",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaClientes />
            </Suspense>
          ),
        },
        {
          path: "compras/lista",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaCompras />
            </Suspense>
          ),
        },
        {
          path: "compras/notas",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaNotasCompra />
            </Suspense>
          ),
        },
        {
          path: "proveedores/ordenes",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaOrdenesCompra />
            </Suspense>
          ),
        },
        {
          path: "proveedores",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaProveedores />
            </Suspense>
          ),
        },
        {
          path: "inventario/almacenes",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaAlmacenes />
            </Suspense>
          ),
        },
        {
          path: "inventario/kardex/periodos",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaKardexPeriodos />
            </Suspense>
          ),
        },
        {
          path: "inventario/kardex/reporte",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaKardexReporte />
            </Suspense>
          ),
        },
        {
          path: "inventario/traslados",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaTraslados />
            </Suspense>
          ),
        },
        {
          path: "inventario/stock",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaStock />
            </Suspense>
          ),
        },
        {
          path: "inventario/movimientos",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaMovimientos />
            </Suspense>
          ),
        },
        {
          path: "ventas/lista",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaVentas />
            </Suspense>
          ),
        },
        {
          path: "ventas/cotizaciones",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaCotizaciones />
            </Suspense>
          ),
        },
        {
          path: "ventas/notas",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaNotas />
            </Suspense>
          ),
        },
        {
          path: "ventas/pos",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaPOS />
            </Suspense>
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
            <Suspense fallback={<CargandoPagina />}>
              <PaginaUsuarios />
            </Suspense>
          ),
        },
        {
          path: "seguridad/roles",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaRoles />
            </Suspense>
          ),
        },
        {
          path: "seguridad/trabajadores",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaTrabajadores />
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
    },
  },
);
