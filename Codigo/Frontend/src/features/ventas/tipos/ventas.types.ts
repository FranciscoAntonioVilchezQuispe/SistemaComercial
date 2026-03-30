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

/** Interface ligera para el listado de ventas (Grids) */
export interface VentaResumen {
  id: number;
  serie: string;
  numero: number;
  fechaEmision: string;
  clienteRazonSocial: string;
  clienteNumeroDocumento: string;
  tipoComprobanteNombre: string;
  estadoNombre: string;
  estadoPagoNombre: string;
  totalVenta: number;
  // IDs para lógica visual (colores en el grid)
  idEstado: number;
  idEstadoPago: number;
}

/** Interface completa para el detalle de una venta (Vista Previa / Edición) */
export interface VentaDetalle {
  id: number;
  idEmpresa: number;
  idAlmacen: number;
  idCaja?: number;
  idCliente: number;
  nombreCliente: string;
  numeroDocumentoCliente: string;
  idUsuarioVendedor: number;
  idCotizacionOrigen?: number;
  idTipoComprobante: number;
  tipoComprobante: string;
  serie: string;
  numero: number;
  numeroFormateado: string;
  fechaEmision: string;
  fechaVencimientoPago?: string;
  idEstado: number;
  estado: string;
  moneda: string;
  tipoCambio: number;
  subtotalGravado: number;
  subtotalExonerado: number;
  subtotalInafecto: number;
  totalImpuesto: number;
  totalDescuentoGlobal: number;
  totalVenta: number;
  saldoPendiente: number;
  idEstadoPago: number;
  estadoPago: string;
  observaciones?: string;
  detalles: DetalleVenta[];
  pagos?: PagoDetalle[];
}

/** Tipo legado para compatibilidad durante la transición */
export type Venta = VentaResumen | VentaDetalle;

export interface PagoDetalle {
  id: number;
  fechaPago: string;
  montoPago: number;
  idMetodoPago: number;
  metodoPagoNombre: string;
}

export interface DetalleVenta {
  id: number;
  idProducto: number;
  idVariante?: number;
  descripcionProducto: string;
  cantidad: number;
  precioUnitario: number;
  precioListaOriginal?: number;
  porcentajeImpuesto: number;
  impuestoItem: number;
  totalItem: number;
}

export interface VentaFormData {
  idCliente: number;
  idTipoComprobante: number;
  idAlmacen: number;
  serie: string;
  numero: number;
  tipoCambio: number;
  moneda: string;
  subtotalGravado: number;
  totalImpuesto: number;
  totalVenta: number;
  observaciones?: string;
  detalles: DetalleVentaFormData[];
  pagos?: PagoFormData[];
}

export interface PagoFormData {
  idMetodoPago: number;
  montoPago: number;
  referenciaPago?: string;
  fechaPago?: string;
}

export interface DetalleVentaFormData {
  idProducto: number;
  idVariante?: number;
  descripcionProducto?: string;
  cantidad: number;
  precioUnitario: number;
  descuento: number;
  codigoAfectacionIgv: string;
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
// COTIZACION
// ============================================

/** Interface ligera para el listado de cotizaciones (Grids) */
export interface CotizacionResumen {
  id: number;
  serie: string;
  numero: number;
  numeroFormateado: string;
  fechaEmision: string;
  fechaVencimiento: string;
  clienteNombre: string;
  moneda: string;
  totalCotizacion: number;
  estadoNombre: string;
  idEstado: number;
}

/** Interface completa para el detalle de una cotización */
export interface CotizacionDetalle {
  id: number;
  idEmpresa: number;
  idAlmacen: number;
  idCliente: number;
  clienteNombre?: string;
  idUsuarioVendedor: number;
  serie: string;
  numero: number;
  fechaEmision: string;
  fechaVencimiento: string;
  idEstado: number;
  estadoNombre: string;
  moneda: string;
  tipoCambio: number;
  subtotalGravado: number;
  subtotalExonerado: number;
  subtotalInafecto: number;
  totalImpuesto: number;
  totalDescuento: number;
  totalCotizacion: number;
  observaciones?: string;
  detalles: DetalleCotizacion[];
}

export interface DetalleCotizacion {
  id: number;
  idProducto: number;
  idVariante?: number;
  descripcionProducto: string;
  cantidad: number;
  precioUnitario: number;
  precioListaOriginal?: number;
  porcentajeImpuesto: number;
  impuestoItem: number;
  totalItem: number;
}

// ============================================
// RESPUESTAS API
// ============================================

export interface RespuestaVentas {
  datos: VentaResumen[];
  total: number;
  pagina: number;
  elementosPorPagina: number;
}

export interface RespuestaCotizaciones {
  datos: CotizacionResumen[];
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
