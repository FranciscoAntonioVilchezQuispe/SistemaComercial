import React from "react";
import {
  LayoutDashboard,
  Package,
  ShoppingCart,
  Warehouse,
  ShoppingBag,
  FileText,
  Settings,
  List,
  FolderTree,
  Tags,
  Ruler,
  DollarSign,
  Calculator,
  UserPlus,
  Users,
  BarChart3,
  Box,
  Truck,
  ClipboardList,
  ArrowLeftRight,
  History,
  Home,
  UserCheck,
  Building2,
  Percent,
  CreditCard,
  FileJson,
  ShieldCheck,
  Table,
} from "lucide-react";
import { RUTAS_TITULOS } from "@/config/rutasTitulos";

export interface ItemMenu {
  titulo: string;
  icono: React.ReactNode;
  ruta?: string;
  subItems?: ItemMenu[];
}

export const menuItems: ItemMenu[] = [
  {
    titulo: RUTAS_TITULOS["/dashboard"] || "Dashboard",
    icono: <LayoutDashboard className="h-5 w-5" />,
    ruta: "/dashboard",
  },
  {
    titulo: "Catálogo",
    icono: <Package className="h-5 w-5" />,
    subItems: [
      { titulo: RUTAS_TITULOS["/catalogo/productos"] || "Productos", icono: <Box className="h-6 w-6" />, ruta: "/catalogo/productos" },
      { titulo: RUTAS_TITULOS["/catalogo/categorias"] || "Categorías", icono: <FolderTree className="h-6 w-6" />, ruta: "/catalogo/categorias" },
      { titulo: RUTAS_TITULOS["/catalogo/marcas"] || "Marcas", icono: <Tags className="h-6 w-6" />, ruta: "/catalogo/marcas" },
      { titulo: RUTAS_TITULOS["/catalogo/unidades-medida"] || "Unidades de Medida", icono: <Ruler className="h-6 w-6" />, ruta: "/catalogo/unidades-medida" },
      { titulo: RUTAS_TITULOS["/catalogo/listas-precios"] || "Listas de Precios", icono: <DollarSign className="h-6 w-6" />, ruta: "/catalogo/listas-precios" },
    ],
  },
  {
    titulo: "Ventas",
    icono: <ShoppingCart className="h-5 w-5" />,
    subItems: [
      { titulo: RUTAS_TITULOS["/ventas/pos"] || "Punto de Venta", icono: <Calculator className="h-6 w-6" />, ruta: "/ventas/pos" },
      { titulo: RUTAS_TITULOS["/ventas/lista"] || "Ventas", icono: <List className="h-6 w-6" />, ruta: "/ventas/lista" },
      { titulo: RUTAS_TITULOS["/ventas/cotizaciones"] || "Cotizaciones", icono: <FileText className="h-6 w-6" />, ruta: "/ventas/cotizaciones" },
      { titulo: RUTAS_TITULOS["/clientes"] || "Clientes", icono: <Users className="h-6 w-6" />, ruta: "/clientes" },
    ],
  },
  {
    titulo: "Inventario",
    icono: <Warehouse className="h-5 w-5" />,
    subItems: [
      { titulo: RUTAS_TITULOS["/inventario/stock"] || "Stock", icono: <Box className="h-6 w-6" />, ruta: "/inventario/stock" },
      { titulo: RUTAS_TITULOS["/inventario/movimientos"] || "Operaciones", icono: <ArrowLeftRight className="h-6 w-6" />, ruta: "/inventario/movimientos" },
      { titulo: RUTAS_TITULOS["/inventario/traslados"] || "Traslados", icono: <Truck className="h-6 w-6" />, ruta: "/inventario/traslados" },
      { titulo: RUTAS_TITULOS["/inventario/kardex/reporte"] || "Reporte Kardex", icono: <BarChart3 className="h-6 w-6" />, ruta: "/inventario/kardex/reporte" },
      { titulo: RUTAS_TITULOS["/inventario/kardex/periodos"] || "Periodos Kardex", icono: <History className="h-6 w-6" />, ruta: "/inventario/kardex/periodos" },
      { titulo: RUTAS_TITULOS["/inventario/almacenes"] || "Almacenes", icono: <Home className="h-6 w-6" />, ruta: "/inventario/almacenes" },
    ],
  },
  {
    titulo: "Compras",
    icono: <ShoppingBag className="h-5 w-5" />,
    subItems: [
      { titulo: RUTAS_TITULOS["/proveedores/ordenes"] || "Órdenes de Compra", icono: <ClipboardList className="h-6 w-6" />, ruta: "/proveedores/ordenes" },
      { titulo: "Compras", icono: <ShoppingBag className="h-6 w-6" />, ruta: "/compras/lista" },
      { titulo: RUTAS_TITULOS["/proveedores"] || "Proveedores", icono: <Truck className="h-6 w-6" />, ruta: "/proveedores" },
    ],
  },
  {
    titulo: RUTAS_TITULOS["/reportes"] || "Reportes",
    icono: <FileText className="h-5 w-5" />,
    ruta: "/reportes",
  },
  {
    titulo: "Configuración",
    icono: <Settings className="h-5 w-5" />,
    subItems: [
      { titulo: RUTAS_TITULOS["/configuracion/usuarios"] || "Usuarios", icono: <UserPlus className="h-6 w-6" />, ruta: "/configuracion/usuarios" },
      { titulo: RUTAS_TITULOS["/configuracion/roles"] || "Roles", icono: <UserCheck className="h-6 w-6" />, ruta: "/configuracion/roles" },
      { titulo: RUTAS_TITULOS["/configuracion/empresa"] || "Empresa", icono: <Building2 className="h-6 w-6" />, ruta: "/configuracion/empresa" },
      { titulo: RUTAS_TITULOS["/configuracion/sucursales"] || "Sucursales", icono: <Home className="h-6 w-6" />, ruta: "/configuracion/sucursales" },
      { titulo: RUTAS_TITULOS["/configuracion/impuestos"] || "Impuestos", icono: <Percent className="h-6 w-6" />, ruta: "/configuracion/impuestos" },
      { titulo: RUTAS_TITULOS["/configuracion/metodos-pago"] || "Métodos de Pago", icono: <CreditCard className="h-6 w-6" />, ruta: "/configuracion/metodos-pago" },
      { titulo: RUTAS_TITULOS["/configuracion/comprobantes"] || "Comprobantes", icono: <FileJson className="h-6 w-6" />, ruta: "/configuracion/comprobantes" },
      { titulo: RUTAS_TITULOS["/configuracion/reglas-sunat"] || "Reglas SUNAT", icono: <ShieldCheck className="h-6 w-6" />, ruta: "/configuracion/reglas-sunat" },
      { titulo: RUTAS_TITULOS["/configuracion/operaciones-sunat"] || "Op. SUNAT", icono: <FileText className="h-6 w-6" />, ruta: "/configuracion/operaciones-sunat" },
      { titulo: RUTAS_TITULOS["/configuracion/matriz-sunat"] || "Matriz SUNAT", icono: <Table className="h-6 w-6" />, ruta: "/configuracion/matriz-sunat" },
      { titulo: RUTAS_TITULOS["/configuracion/tablas-generales"] || "Tablas Generales", icono: <List className="h-6 w-6" />, ruta: "/configuracion/tablas-generales" },
    ],
  },
];
