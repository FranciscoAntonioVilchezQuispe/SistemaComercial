export interface DetalleVenta {
  idProducto: number;
  nombreProducto: string;
  cantidad: number;
  precioUnitario: number;
  subtotal: number;
  impuesto: number;
  total: number;
}

export interface Venta {
  id: number;
  idCliente: number;
  idAlmacen: number;
  idVendedor: number;
  idMoneda: number;
  tipoComprobante: string; // 'FACTURA', 'BOLETA'
  serieComprobante: string;
  numeroComprobante: string;
  fechaEmision: string;
  tipoCambio: number;
  estado: string; // 'PENDIENTE', 'COMPLETADA', 'ANULADA'
  observaciones?: string;

  // Totales
  subtotal: number;
  impuesto: number;
  total: number;

  detalles: DetalleVenta[];

  // Datos expandidos
  razonSocialCliente?: string;
  nombreAlmacen?: string;
  nombreVendedor?: string;
}

export interface VentaFormData {
  idCliente: number;
  idAlmacen: number;
  idMoneda: number;
  tipoComprobante: string;
  tipoCambio: number;
  observaciones?: string;

  detalles: {
    idProducto: number;
    cantidad: number;
    precioUnitario: number;
    impuesto: number; // Porcentaje o monto? Generalmente calculado en backend, pero frontend puede enviar precio con/sin IGV
  }[];
}
