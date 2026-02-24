/**
 * Tipos para el módulo de Ventas
 */

import { Producto } from "@features/catalogo";
import {
  Cliente as ClienteGlobal,
  ClienteFormData as ClienteFormDataGlobal,
} from "@/features/clientes/types/cliente.types";

// ============================================
// VENTA
// ============================================

export interface Venta {
  id: number;
  numeroComprobante: string;
  idTipoComprobante: number;
  tipoComprobante?: string;
  idCliente: number;
  cliente?: ClienteGlobal;
  idUsuario: number;
  usuario?: string;
  fecha: string;
  subtotal: number;
  descuento: number;
  igv: number;
  total: number;
  idEstado: number;
  estado?: string;
  idEstadoPago: number;
  estadoPago?: string;
  observaciones?: string;
  detalles: DetalleVenta[];
  fechaCreacion: string;
}

export interface DetalleVenta {
  id: number;
  idVenta: number;
  idProducto: number;
  producto?: Producto;
  cantidad: number;
  precioUnitario: number;
  descuento: number;
  subtotal: number;
}

export interface VentaFormData {
  idCliente: number;
  idTipoComprobante: number;
  idAlmacen: number;
  idMoneda: number;
  serie: string;
  numero: number;
  tipoCambio: number;
  observaciones?: string;
  detalles: DetalleVentaFormData[];
}

export interface DetalleVentaFormData {
  idProducto: number;
  cantidad: number;
  precioUnitario: number;
  descuento: number;
}

export interface VentaFiltros {
  fechaInicio?: string;
  fechaFin?: string;
  idCliente?: number;
  idEstado?: number;
  idEstadoPago?: number;
  numeroComprobante?: string;
}

// ============================================
// CLIENTE
// ============================================

export type Cliente = ClienteGlobal;
export type ClienteFormData = ClienteFormDataGlobal;

export interface ClienteFiltros {
  busqueda?: string;
  idTipoDocumento?: number;
  idTipoCliente?: number;
  activo?: boolean;
}

// ============================================
// CARRITO
// ============================================

export interface ItemCarrito {
  producto: Producto;
  cantidad: number;
  precioUnitario: number;
  descuento: number;
  subtotal: number;
}

export interface Carrito {
  items: ItemCarrito[];
  subtotal: number;
  descuento: number;
  igv: number;
  total: number;
}

// ============================================
// CAJA
// ============================================

export interface Caja {
  id: number;
  nombre: string;
  idEstado: number;
  estado?: string;
  montoInicial: number;
  montoActual: number;
  idUsuarioApertura: number;
  usuarioApertura?: string;
  fechaApertura: string;
  idUsuarioCierre?: number;
  usuarioCierre?: string;
  fechaCierre?: string;
}

export interface MovimientoCaja {
  id: number;
  idCaja: number;
  idTipoMovimiento: number;
  tipoMovimiento?: string;
  monto: number;
  descripcion: string;
  fecha: string;
}

// ============================================
// RESPUESTAS API
// ============================================

export interface RespuestaVentas {
  datos: Venta[];
  total: number;
  pagina: number;
  elementosPorPagina: number;
}

export interface RespuestaClientes {
  datos: Cliente[];
  total: number;
  pagina: number;
  elementosPorPagina: number;
}
