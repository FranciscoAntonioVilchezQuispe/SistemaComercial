// Exportar páginas
export { PaginaPOS } from "./paginas/PaginaPOS";
export { PaginaVentas } from "./paginas/PaginaVentas";
export { PaginaCotizaciones } from "./paginas/PaginaCotizaciones";

// Exportar componentes
export { CarritoCompras } from "./componentes/pos/CarritoCompras";
export { GridProductosPOS } from "./componentes/pos/GridProductosPOS";
export { TablaVentas } from "./componentes/ventas/TablaVentas";
export { DetalleVentaModal } from "./componentes/ventas/DetalleVentaModal";

// Exportar hooks
export {
  useVentas,
  useVenta,
  useVentasDelDia,
  useCrearVenta,
  useAnularVenta,
} from "./hooks/useVentas";

export { useCarrito } from "./hooks/useCarrito";

// Exportar tipos
export type {
  Venta,
  VentaFormData,
  VentaFiltros,
  DetalleVenta,
} from "./tipos/ventas.types";

export type { ItemCarrito, Carrito } from "./tipos/ventas.types";
