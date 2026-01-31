// Exportar páginas
export { PaginaPOS } from "./paginas/PaginaPOS";
export { PaginaVentas } from "./paginas/PaginaVentas";
export { PaginaClientes } from "./paginas/PaginaClientes";

// Exportar componentes
export { CarritoCompras } from "./componentes/pos/CarritoCompras";
export { GridProductosPOS } from "./componentes/pos/GridProductosPOS";
export { TablaVentas } from "./componentes/ventas/TablaVentas";
export { DetalleVentaModal } from "./componentes/ventas/DetalleVentaModal";
export { TablaClientes } from "./componentes/clientes/TablaClientes";
export { FormularioCliente } from "./componentes/clientes/FormularioCliente";

// Exportar hooks
export {
  useVentas,
  useVenta,
  useVentasDelDia,
  useCrearVenta,
  useAnularVenta,
} from "./hooks/useVentas";
export {
  useClientes,
  useCliente,
  useBuscarClientePorDocumento,
  useCrearCliente,
  useActualizarCliente,
  useEliminarCliente,
} from "./hooks/useClientes";
export { useCarrito } from "./hooks/useCarrito";

// Exportar tipos
export type {
  Venta,
  VentaFormData,
  VentaFiltros,
  DetalleVenta,
} from "./tipos/ventas.types";
export type {
  Cliente,
  ClienteFormData,
  ClienteFiltros,
} from "./tipos/ventas.types";
export type { ItemCarrito, Carrito } from "./tipos/ventas.types";
