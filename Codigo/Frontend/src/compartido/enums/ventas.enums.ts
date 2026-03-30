/**
 * Estados de Venta y Pago sincronizados con el Backend
 */

export enum EstadoVenta {
  Completada = 29,
  Anulada = 30,
  PendientePago = 31,
}

export enum EstadoPago {
  Pagado = 46,
  Parcial = 47,
  Credito = 48,
  Pendiente = 49,
  Anulado = 50,
}
