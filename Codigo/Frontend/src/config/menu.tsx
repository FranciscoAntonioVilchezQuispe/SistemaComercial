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
  MapPin,
} from "lucide-react";
import { RUTAS_TITULOS } from "@/config/rutasTitulos";

export interface ItemMenu {
  titulo: string;
  icono: React.ReactNode;
  ruta?: string;
  subItems?: ItemMenu[];
  codigoPermiso?: string;
  soloAdmin?: boolean;
}

export const menuItems: ItemMenu[] = [
  {
    titulo: RUTAS_TITULOS["/dashboard"] || "Dashboard",
    icono: <LayoutDashboard className="h-5 w-5" />,
    ruta: "/dashboard",
    // Sin codigoPermiso: dashboard es visible para todos los autenticados
  },
  {
    titulo: "Catálogo",
    icono: <Package className="h-5 w-5" />,
    codigoPermiso: "CATALOGO",
    subItems: [
      { titulo: RUTAS_TITULOS["/catalogo/productos"] || "Productos", icono: <Box className="h-6 w-6" />, ruta: "/catalogo/productos", codigoPermiso: "CAT_PRODUCTOS" },
      { titulo: RUTAS_TITULOS["/catalogo/categorias"] || "Categorías", icono: <FolderTree className="h-6 w-6" />, ruta: "/catalogo/categorias", codigoPermiso: "CAT_CATEGORIAS" },
      { titulo: RUTAS_TITULOS["/catalogo/marcas"] || "Marcas", icono: <Tags className="h-6 w-6" />, ruta: "/catalogo/marcas", codigoPermiso: "CAT_MARCAS" },
      { titulo: RUTAS_TITULOS["/catalogo/unidades-medida"] || "Unidades de Medida", icono: <Ruler className="h-6 w-6" />, ruta: "/catalogo/unidades-medida", codigoPermiso: "CAT_UNIDADES" },
      { titulo: RUTAS_TITULOS["/catalogo/listas-precios"] || "Listas de Precios", icono: <DollarSign className="h-6 w-6" />, ruta: "/catalogo/listas-precios", codigoPermiso: "CAT_PRECIOS" },
    ],
  },
  {
    titulo: "Ventas",
    icono: <ShoppingCart className="h-5 w-5" />,
    codigoPermiso: "VENTAS",
    subItems: [
      { titulo: RUTAS_TITULOS["/ventas/pos"] || "Punto de Venta", icono: <Calculator className="h-6 w-6" />, ruta: "/ventas/pos", codigoPermiso: "VEN_POS" },
      { titulo: RUTAS_TITULOS["/ventas/lista"] || "Ventas", icono: <List className="h-6 w-6" />, ruta: "/ventas/lista", codigoPermiso: "VEN_LISTA" },
      { titulo: RUTAS_TITULOS["/ventas/notas"] || "Notas SUNAT", icono: <FileText className="h-6 w-6" />, ruta: "/ventas/notas", codigoPermiso: "VEN_NOTAS" },
      { titulo: RUTAS_TITULOS["/ventas/cotizaciones"] || "Cotizaciones", icono: <FileText className="h-6 w-6" />, ruta: "/ventas/cotizaciones", codigoPermiso: "VEN_COTIZACIONES" },
      { 
        titulo: RUTAS_TITULOS['/ventas/turnos'] || 'Historial de Turnos',
        icono: <History className="h-6 w-6" />,
        ruta: '/ventas/turnos',
        codigoPermiso: 'VEN_TURNOS'
      },
      { 
        titulo: RUTAS_TITULOS['/ventas/cajas'] || 'Gestión de Cajas',
        icono: <Building2 className="h-6 w-6" />,
        ruta: '/ventas/cajas',
        codigoPermiso: 'VEN_CAJAS'
      },
      { titulo: RUTAS_TITULOS["/clientes"] || "Clientes", icono: <Users className="h-6 w-6" />, ruta: "/clientes", codigoPermiso: "VEN_CLIENTES" },
    ],
  },
  {
    titulo: "Inventario",
    icono: <Warehouse className="h-5 w-5" />,
    codigoPermiso: "INVENTARIO",
    subItems: [
      { titulo: RUTAS_TITULOS["/inventario/stock"] || "Stock", icono: <Box className="h-6 w-6" />, ruta: "/inventario/stock", codigoPermiso: "INV_STOCK" },
      { titulo: RUTAS_TITULOS["/inventario/movimientos"] || "Operaciones", icono: <ArrowLeftRight className="h-6 w-6" />, ruta: "/inventario/movimientos", codigoPermiso: "INV_MOVIMIENTOS" },
      { titulo: RUTAS_TITULOS["/inventario/traslados"] || "Traslados", icono: <Truck className="h-6 w-6" />, ruta: "/inventario/traslados", codigoPermiso: "INV_TRASLADOS" },
      { titulo: RUTAS_TITULOS["/inventario/kardex/reporte"] || "Reporte Kardex", icono: <BarChart3 className="h-6 w-6" />, ruta: "/inventario/kardex/reporte", codigoPermiso: "INV_KARDEX_REP" },
      { titulo: RUTAS_TITULOS["/inventario/kardex/periodos"] || "Periodos Kardex", icono: <History className="h-6 w-6" />, ruta: "/inventario/kardex/periodos", codigoPermiso: "INV_KARDEX_PER" },
      { titulo: RUTAS_TITULOS["/inventario/almacenes"] || "Almacenes", icono: <Home className="h-6 w-6" />, ruta: "/inventario/almacenes", codigoPermiso: "INV_ALMACENES" },
    ],
  },
  {
    titulo: "Compras",
    icono: <ShoppingBag className="h-5 w-5" />,
    codigoPermiso: "COMPRAS",
    subItems: [
      { titulo: RUTAS_TITULOS["/proveedores/ordenes"] || "Órdenes de Compra", icono: <ClipboardList className="h-6 w-6" />, ruta: "/proveedores/ordenes", codigoPermiso: "COM_ORDENES" },
      { titulo: "Compras", icono: <ShoppingBag className="h-6 w-6" />, ruta: "/compras/lista", codigoPermiso: "COM_LISTA" },
      { titulo: RUTAS_TITULOS["/compras/notas"] || "Notas de Compra", icono: <FileText className="h-6 w-6" />, ruta: "/compras/notas", codigoPermiso: "COM_NOTAS" },
      { titulo: RUTAS_TITULOS["/proveedores"] || "Proveedores", icono: <Truck className="h-6 w-6" />, ruta: "/proveedores", codigoPermiso: "COM_PROVEEDORES" },
    ],
  },
  {
    titulo: RUTAS_TITULOS["/reportes"] || "Reportes",
    icono: <FileText className="h-5 w-5" />,
    ruta: "/reportes",
    // Sin codigoPermiso: reportes visibles para todos los autenticados
  },
  {
    titulo: "Seguridad",
    icono: <ShieldCheck className="h-5 w-5 text-emerald-600" />,
    soloAdmin: true,
    subItems: [
      { titulo: "Usuarios", icono: <Users className="h-6 w-6" />, ruta: "/seguridad/usuarios", codigoPermiso: "SEG_USUARIOS" },
      { titulo: "Roles y Permisos", icono: <UserCheck className="h-6 w-6" />, ruta: "/seguridad/roles", codigoPermiso: "SEG_ROLES" },
      { titulo: "Personal", icono: <UserPlus className="h-6 w-6" />, ruta: "/seguridad/trabajadores", codigoPermiso: "SEG_TRABAJADORES" },
    ],
  },
  {
    titulo: "Configuración",
    icono: <Settings className="h-5 w-5" />,
    codigoPermiso: "CONFIGURACION",
    subItems: [
      { titulo: RUTAS_TITULOS["/configuracion/empresa"] || "Empresa", icono: <Building2 className="h-6 w-6" />, ruta: "/configuracion/empresa", codigoPermiso: "CONF_FISCAL" },
      { titulo: RUTAS_TITULOS["/configuracion/sucursales"] || "Sucursales", icono: <Home className="h-6 w-6" />, ruta: "/configuracion/sucursales", codigoPermiso: "CONF_GENERAL" },
      { titulo: RUTAS_TITULOS["/configuracion/impuestos"] || "Impuestos", icono: <Percent className="h-6 w-6" />, ruta: "/configuracion/impuestos", codigoPermiso: "CONF_FISCAL" },
      { titulo: "Afectación IGV", icono: <ShieldCheck className="h-6 w-6" />, ruta: "/configuracion/afectacion-igv", codigoPermiso: "CONF_FISCAL" },
      { titulo: "Tipos de Tributo", icono: <Calculator className="h-6 w-6" />, ruta: "/configuracion/tipos-tributo", codigoPermiso: "CONF_FISCAL" },
      { titulo: RUTAS_TITULOS["/configuracion/metodos-pago"] || "Métodos de Pago", icono: <CreditCard className="h-6 w-6" />, ruta: "/configuracion/metodos-pago", codigoPermiso: "CONF_GENERAL" },
      { titulo: RUTAS_TITULOS["/configuracion/comprobantes"] || "Comprobantes", icono: <FileJson className="h-6 w-6" />, ruta: "/configuracion/comprobantes", codigoPermiso: "CONF_COMPROBANTES" },
      { titulo: RUTAS_TITULOS["/configuracion/reglas-sunat"] || "Reglas SUNAT", icono: <ShieldCheck className="h-6 w-6" />, ruta: "/configuracion/reglas-sunat", codigoPermiso: "CONF_FISCAL" },
      { titulo: RUTAS_TITULOS["/configuracion/operaciones-sunat"] || "Op. SUNAT", icono: <FileText className="h-6 w-6" />, ruta: "/configuracion/operaciones-sunat", codigoPermiso: "CONF_FISCAL" },
      { titulo: RUTAS_TITULOS["/configuracion/matriz-sunat"] || "Matriz SUNAT", icono: <Table className="h-6 w-6" />, ruta: "/configuracion/matriz-sunat", codigoPermiso: "CONF_FISCAL" },
      { titulo: RUTAS_TITULOS["/configuracion/tablas-generales"] || "Tablas Generales", icono: <List className="h-6 w-6" />, ruta: "/configuracion/tablas-generales", codigoPermiso: "CONF_GENERAL" },
      { titulo: RUTAS_TITULOS["/configuracion/ubigeos"] || "Ubigeos", icono: <MapPin className="h-6 w-6" />, ruta: "/configuracion/ubigeos", codigoPermiso: "CONF_GENERAL" },
    ],
  },
];
