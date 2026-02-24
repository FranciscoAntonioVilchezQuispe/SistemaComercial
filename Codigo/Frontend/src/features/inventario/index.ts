// Exportar páginas
export { PaginaStock } from "./paginas/PaginaStock";
export { PaginaMovimientos } from "./paginas/PaginaMovimientos";
export { PaginaTraslados } from "./paginas/PaginaTraslados";

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
export {
  useTraslados,
  useCrearTraslado,
  useRecibirTraslado,
} from "./hooks/useTraslados";

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
