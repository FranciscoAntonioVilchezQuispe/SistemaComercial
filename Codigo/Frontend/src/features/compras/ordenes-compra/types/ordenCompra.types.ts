export interface DetalleOrdenCompra {
  id: number;
  idProducto: number;
  idVariante?: number;
  cantidadSolicitada: number;
  precioUnitarioPactado: number;
  subtotal: number;
  cantidadRecibida?: number;
  
  // Datos expandidos opcionales para visualización si el backend los enviara enriquecidos,
  // aunque por defecto el DTO simple tal vez no los tenga, suele ser útil tenerlos definidos.
  nombreProducto?: string; 
}

export interface OrdenCompra {
  id: number;
  codigoOrden: string;
  idProveedor: number;
  idAlmacenDestino: number;
  fechaEmision: string; // ISO Date String
  fechaEntregaEstimada?: string; // ISO Date String
  idEstado: number; 
  totalImporte: number;
  observaciones?: string;
  
  detalles: DetalleOrdenCompra[];

  // Propiedades de navegación / expandidas para la grilla
  // (Dependerá de si el backend las popula o si mapeamos en el frontend)
  razonSocialProveedor?: string;
  nombreAlmacen?: string;
  nombreEstado?: string;
}

export interface DetalleOrdenCompraForm {
  idProducto: number;
  // idVariante?: number; // Omitido por simplicidad inicial si no se usan variantes
  cantidadSolicitada: number;
  precioUnitarioPactado: number;
}

export interface OrdenCompraFormData {
  codigoOrden: string;
  idProveedor: number;
  idAlmacenDestino: number;
  fechaEmision: Date;
  fechaEntregaEstimada?: Date;
  idEstado: number;
  observaciones?: string;
  
  detalles: DetalleOrdenCompraForm[];
}
