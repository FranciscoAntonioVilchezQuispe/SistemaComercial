/**
 * Tipos para el módulo de Inventario
 */

import { Producto } from "@features/catalogo";

export interface StockProducto {
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

export interface MovimientoInventario {
  id: number;
  idProducto: number;
  producto?: Producto;
  idAlmacen: number;
  almacen?: string;
  idTipoMovimiento: number;
  tipoMovimiento?: string; // Entrada, Salida, Ajuste, Traslado
  cantidad: number;
  precioCosto?: number;
  fecha: string;
  idUsuario: number;
  usuario?: string;
  referencia?: string; // N° Factura, N° Venta, etc.
  observaciones?: string;
}

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
