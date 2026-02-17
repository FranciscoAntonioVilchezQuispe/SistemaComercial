export interface DetalleCompra {
  idProducto: number;
  nombreProducto: string; // Para visualización
  cantidad: number;
  precioUnitario: number;
  subtotal: number;
}

export interface Compra {
  id: number;
  idProveedor: number;
  idAlmacen: number;
  idMoneda: number;
  tipoComprobante: string; // 'FACTURA', 'BOLETA', etc.
  serieComprobante: string;
  numeroComprobante: string;
  fechaEmision: string; // ISO Date
  fechaContable: string; // ISO Date
  tipoCambio: number;
  estado: string; // 'BORRADOR', 'CONFIRMADO', 'ANULADO'
  observaciones?: string;

  // Totales
  subtotal: number;
  impuesto: number;
  total: number;

  detalles: DetalleCompra[];

  // Datos expandidos (opcional, depende del backend)
  razonSocialProveedor?: string;
  nombreAlmacen?: string;
}

export interface CompraFormData {
  idProveedor: number;
  idAlmacen: number;
  idMoneda: number;
  tipoComprobante: string;
  serieComprobante: string;
  numeroComprobante: string;
  fechaEmision: Date;
  tipoCambio: number;
  observaciones?: string;

  detalles: {
    idProducto: number;
    cantidad: number;
    precioUnitario: number;
  }[];
}

export interface DetalleCompraPayload {
  idProducto: number;
  idVariante?: number | null;
  descripcion?: string;
  cantidad: number;
  precioUnitarioCompra: number;
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
  moneda: string;
  tipoCambio: number;
  subtotal: number;
  impuesto: number;
  total: number;
  saldoPendiente: number;
  idEstadoPago: number;
  observaciones?: string;
  detalles: DetalleCompraPayload[];
}
