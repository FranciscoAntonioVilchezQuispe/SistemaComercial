export interface DetalleCompra {
  id: number;
  idProducto: number;
  nombreProducto?: string;
  idVariante?: number | null;
  descripcion?: string;
  cantidad: number;
  precioUnitarioCompra: number;
  subtotal: number;
}

/** Interface ligera para el listado de compras (Grids) */
export interface CompraResumen {
  id: number;
  tipoComprobanteNombre: string;
  serieComprobante: string;
  numeroComprobante: string;
  fechaEmision: string;
  razonSocialProveedor: string;
  numeroDocumentoProveedor: string;
  moneda: string;
  total: number;
  estadoNombre: string;
  estadoPagoNombre: string;
}

/** Interface completa para el detalle de la compra */
export interface CompraDetalle {
  id: number;
  idProveedor: number;
  razonSocialProveedor?: string;
  numeroDocumentoProveedor?: string;
  idAlmacen: number;
  nombreAlmacen?: string;
  idMoneda: number;
  moneda: string;
  idTipoComprobante: number;
  tipoComprobanteNombre: string;
  serieComprobante: string;
  numeroComprobante: string;
  fechaEmision: string;
  fechaContable: string;
  tipoCambio: number;
  estado: string;
  estadoNombre: string;
  tipoOperacion?: string;
  observaciones?: string;

  // Totales
  subtotal: number;
  impuesto: number;
  total: number;
  saldoPendiente?: number;
  idEstadoPago: number;
  estadoPagoNombre?: string;

  detalles: DetalleCompra[];
}

/** @deprecated Usar CompraResumen o CompraDetalle */
export type Compra = CompraResumen | CompraDetalle;

export interface CompraFormData {
  idProveedor: number;
  idAlmacen: number;
  idMoneda: number;
  tipoComprobante: string;
  serieComprobante: string;
  numeroComprobante: string;
  fechaEmision: Date;
  tipoCambio: number;
  tipoOperacion: string;
  observaciones?: string;

  detalles: {
    idProducto: number;
    cantidad: number;
    precioUnitario: number;
    afectacionIgv: string;
  }[];
  idOrdenCompraRef?: number | null;
}

export interface DetalleCompraPayload {
  idProducto: number;
  idVariante?: number | null;
  descripcion?: string;
  cantidad: number;
  precioUnitarioCompra: number;
  afectacionIgv: string; // "10", "20", "30" (Catálogo SUNAT 07)
  subtotal: number;
}

export interface CrearCompraPayload {
  idProveedor: number;
  idAlmacen: number;
  idOrdenCompraRef?: number | null;
  idTipoComprobante: number;
  serieComprobante: string;
  numeroComprobante: string;
  fechaEmision: Date;
  fechaContable: Date;
  fechaVencimiento?: Date | null;
  moneda: string;
  tipoCambio: number;
  baseGravada: number;
  baseExonerada: number;
  baseInafecta: number;
  impuesto: number;
  total: number;
  saldoPendiente: number;
  idEstadoPago: number;
  tipoOperacion: string;
  observaciones?: string;
  detalles: DetalleCompraPayload[];
}
