// Exportar páginas
export { PaginaStock } from "./paginas/PaginaStock";
export { PaginaMovimientos } from "./paginas/PaginaMovimientos";

// Exportar componentes
export { TablaStock } from "./componentes/stock/TablaStock";
export { TablaMovimientos } from "./componentes/movimientos/TablaMovimientos";

// Exportar hooks
export {
  useStock,
  useStockProducto,
  useMovimientos,
  useRegistrarMovimiento,
  useAjustarStock,
  useKardex,
  useTiposMovimiento,
  useAlmacenes,
} from "./hooks/useInventario";

// Exportar tipos
export type {
  StockProducto,
  MovimientoInventario,
  KardexProducto,
  DetalleKardex,
  RegistroMovimientoDTO,
  AjusteStockDTO,
  InventarioFiltros,
  MovimientoFiltros,
} from "./tipos/inventario.types";
