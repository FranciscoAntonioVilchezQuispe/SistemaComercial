export interface MetodoPago {
  id: number;
  codigo: string;
  nombre: string;
  esEfectivo: boolean;
  idTipoDocumentoPago?: number; // Opcional, según DTO
  activado: boolean;
}

export type MetodoPagoFormData = Omit<MetodoPago, "id" | "activado">;
