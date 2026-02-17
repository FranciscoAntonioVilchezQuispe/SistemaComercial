export enum EstadoOrdenCompra {
  Borrador = 39,
  Pendiente = 40,
  Aprobada = 41,
  Rechazada = 42,
}

export const EstadoOrdenCompraEtiquetas: Record<EstadoOrdenCompra, string> = {
  [EstadoOrdenCompra.Borrador]: "Borrador",
  [EstadoOrdenCompra.Pendiente]: "Pendiente",
  [EstadoOrdenCompra.Aprobada]: "Aprobada",
  [EstadoOrdenCompra.Rechazada]: "Rechazada",
};

export enum TablasGenerales {
  TIPO_DOCUMENTO = "TIPO_DOCUMENTO",
  TIPO_CLIENTE = "TIPO_CLIENTE",
  TIPO_MOVIMIENTO_CAJA = "TIPO_MOVIMIENTO_CAJA",
  TIPO_PRODUCTO = "TIPO_PRODUCTO",
  TIPO_MOVIMIENTO_INVENTARIO = "TIPO_MOVIMIENTO_INVENTARIO",
  TIPO_CUENTA_CONTABLE = "TIPO_CUENTA_CONTABLE",
  ESTADO_VENTA = "ESTADO_VENTA",
  ESTADO_COTIZACION = "ESTADO_COTIZACION",
  ESTADO_CAJA = "ESTADO_CAJA",
  ESTADO_ORDEN_COMPRA = "ESTADO_ORDEN_COMPRA",
  ESTADO_ASIENTO = "ESTADO_ASIENTO",
  ESTADO_PAGO = "ESTADO_PAGO",
  TIPO_MONEDA = "TIPO_MONEDA",
}

/**
 * Clase contenedora de Enums para el módulo de Compras
 */
export class ComprasConstantes {
  static readonly Estados = EstadoOrdenCompra;
  static readonly EtiquetasEstados = EstadoOrdenCompraEtiquetas;
  static readonly TablasGenerales = TablasGenerales;
}
