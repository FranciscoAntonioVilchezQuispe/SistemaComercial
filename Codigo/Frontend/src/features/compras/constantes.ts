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

/**
 * Clase contenedora de Enums para el módulo de Compras
 */
export class ComprasConstantes {
  static readonly Estados = EstadoOrdenCompra;
  static readonly EtiquetasEstados = EstadoOrdenCompraEtiquetas;
}
