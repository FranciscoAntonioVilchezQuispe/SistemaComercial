export interface TipoComprobante {
  id: number;
  codigo: string;
  nombre: string;
  mueveStock: boolean;
  // "ENTRADA", "SALIDA", "DEPENDIENTE"
  tipoMovimientoStock: string;
  activado: boolean;
  esCompra: boolean;
  esVenta: boolean;
  esOrdenCompra: boolean;
}

export type TipoComprobanteFormData = Omit<TipoComprobante, "id" | "activado">;
