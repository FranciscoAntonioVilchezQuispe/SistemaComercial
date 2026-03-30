/**
 * Tipos para el módulo de Inventario
 */

import { Producto } from "@features/catalogo";

export interface StockProducto {
  id: number;
  idProducto: number;
  producto?: Producto;
  idAlmacen: number;
  almacen?: string;
  cantidadActual: number;
  cantidadMinima: number;
  cantidadMaxima: number;
  ubicacion?: string;
  ultimaActualizacion: string;
}

/** Interface ligera para el listado de movimientos (Grids) */
export interface MovimientoResumen {
  id: number;
  tipoMovimientoNombre: string;
  productoNombre: string;
  almacenNombre: string;
  cantidad: number;
  costoUnitarioMovimiento: number;
  referenciaModulo?: string;
  idReferencia?: number;
  fechaCreacion: string;
}

/** Interface completa para el detalle de un movimiento */
export interface MovimientoDetalle {
  id: number;
  idTipoMovimiento: number;
  tipoMovimientoNombre: string;
  idProducto: number;
  productoNombre: string;
  almacenNombre: string;
  cantidad: number;
  cantidadAnterior: number;
  cantidadNueva: number;
  costoUnitarioMovimiento: number;
  saldoCantidad: number;
  saldoValorizado: number;
  costoPromedioActual: number;
  referenciaModulo?: string;
  idReferencia?: number;
  observaciones?: string;
  fechaCreacion: string;
  usuarioCreacion?: string;
}

/** @deprecated Usar MovimientoResumen o MovimientoDetalle */
export type MovimientoInventario = MovimientoResumen | MovimientoDetalle;

export interface DetalleKardex {
  fecha: string;
  tipoMovimiento: string;
  referencia: string;
  entrada: number;
  salida: number;
  saldo: number;
  costoUnitario: number;
  costoTotal: number;
}

export interface KardexProducto {
  producto: Producto;
  almacen: string;
  fechaInicio: string;
  fechaFin: string;
  movimientos: DetalleKardex[];
  resumen: {
    stockInicial: number;
    totalEntradas: number;
    totalSalidas: number;
    stockFinal: number;
  };
}

export interface RegistroMovimientoDTO {
  idProducto: number;
  idAlmacen: number;
  idTipoMovimiento: number;
  cantidad: number;
  precioCosto?: number;
  referencia?: string;
  observaciones?: string;
}

export interface AjusteStockDTO {
  idProducto: number;
  idAlmacen: number;
  nuevaCantidad: number;
  motivo: string;
}

export interface InventarioFiltros {
  idAlmacen?: number;
  idCategoria?: number;
  busqueda?: string;
  bajoStock?: boolean;
}

export interface MovimientoFiltros {
  idProducto?: number;
  idAlmacen?: number;
  idTipoMovimiento?: number;
  fechaInicio?: string;
  fechaFin?: string;
}

export interface Traslado {
  id: number;
  numeroTraslado: string;
  almacenOrigenId: number;
  almacenOrigenNombre: string;
  almacenDestinoId: number;
  almacenDestinoNombre: string;
  fechaDespacho?: string;
  fechaRecepcion?: string;
  estado: string;
  observaciones?: string;
  detalles: TrasladoDetalle[];
}

export interface TrasladoDetalle {
  productoId: number;
  productoNombre: string;
  cantidadSolicitada: number;
  cantidadDespachada: number;
  cantidadRecibida: number;
}
