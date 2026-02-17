import { Suspense, lazy } from "react";
import { createBrowserRouter, Navigate } from "react-router-dom";
import { LayoutPrincipal } from "@/layouts/LayoutPrincipal/LayoutPrincipal";

// Carga perezosa de páginas para optimizar el rendimiento
const PaginaDashboard = lazy(
  () => import("@/features/dashboard/paginas/PaginaDashboard"),
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
const PaginaEmpresa = lazy(() =>
  import("@/features/configuracion/paginas/PaginaEmpresa").then((m) => ({
    default: m.PaginaEmpresa,
  })),
);
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
  import("@/features/configuracion/paginas/ReglasDocumentoPage").then((m) => ({
    default: m.ReglasDocumentoPage,
  })),
);

const PaginaPOS = lazy(() => import("@/features/ventas/paginas/PaginaPOS"));
const PaginaClientes = lazy(() =>
  import("@/features/clientes/paginas/PaginaClientes").then((m) => ({
    default: m.PaginaClientes,
  })),
);
const PaginaProveedores = lazy(() =>
  import("@/features/compras/proveedores/paginas/PaginaProveedores").then(
    (m) => ({
      default: m.default,
    }),
  ),
);
const PaginaCompras = lazy(() =>
  import("@/features/compras/compras/paginas/PaginaCompras").then((m) => ({
    default: m.default,
  })),
);
const PaginaOrdenesCompra = lazy(() =>
  import("@/features/compras/ordenes-compra/paginas/OrdenCompraPage").then(
    (m) => ({
      default: m.default,
    }),
  ),
);
const PaginaVentas = lazy(() =>
  import("@/features/ventas/paginas/PaginaVentas").then((m) => ({
    default: m.PaginaVentas,
  })),
);
const PaginaUnidadesMedida = lazy(() =>
  import("@/features/catalogo/paginas/PaginaUnidadesMedida").then((m) => ({
    default: m.default,
  })),
);
const PaginaListasPrecios = lazy(() =>
  import("@/features/catalogo/paginas/PaginaListasPrecios").then((m) => ({
    default: m.default,
  })),
);
const PaginaAlmacenes = lazy(() =>
  import("@/features/inventario/almacenes/paginas/PaginaAlmacenes").then(
    (m) => ({
      default: m.default,
    }),
  ),
);

// Estado de carga base
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

export const ruteador = createBrowserRouter(
  [
    {
      path: "/",
      element: <LayoutPrincipal />,
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
          path: "compras/ordenes-compra",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaOrdenesCompra />
            </Suspense>
          ),
        },
        {
          path: "compras/proveedores",
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
          path: "ventas/lista",
          element: (
            <Suspense fallback={<CargandoPagina />}>
              <PaginaVentas />
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
