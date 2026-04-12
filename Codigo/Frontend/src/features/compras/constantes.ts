import { EstadoOrdenCompra, TablasGenerales } from "../../compartido/enums";

export { EstadoOrdenCompra, TablasGenerales };

export const EstadoOrdenCompraEtiquetas: Record<EstadoOrdenCompra, string> = {
  [EstadoOrdenCompra.Borrador]: "Borrador",
  [EstadoOrdenCompra.Pendiente]: "Pendiente",
  [EstadoOrdenCompra.Aprobada]: "Aprobada",
  [EstadoOrdenCompra.Rechazada]: "Rechazada",
  [EstadoOrdenCompra.Facturada]: "Facturada",
};

/**
 * Clase contenedora de Enums para el módulo de Compras
 */
export class ComprasConstantes {
  static readonly Estados = EstadoOrdenCompra;
  static readonly EtiquetasEstados = EstadoOrdenCompraEtiquetas;
  static readonly TablasGenerales = TablasGenerales;
}
