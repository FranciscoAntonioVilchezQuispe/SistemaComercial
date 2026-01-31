export interface TipoComprobante {
  id: number;
  codigo: string;
  nombre: string;
  mueveStock: boolean;
  // "ENTRADA", "SALIDA", "DEPENDIENTE"
  tipoMovimientoStock: string;
  activado: boolean;
}

export type TipoComprobanteFormData = Omit<TipoComprobante, "id" | "activado">;
