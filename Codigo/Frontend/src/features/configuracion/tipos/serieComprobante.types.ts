export interface SerieComprobante {
  id: number;
  idTipoComprobante: number;
  serie: string;
  correlativoActual: number;
  idAlmacen?: number;
  activado: boolean;
}

export type SerieComprobanteFormData = Omit<
  SerieComprobante,
  "id" | "activado"
>;
