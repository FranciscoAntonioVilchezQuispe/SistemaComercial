export interface Impuesto {
  id: number;
  codigo: string;
  nombre: string;
  porcentaje: number;
  esIgv: boolean;
  activado: boolean;
}

export type ImpuestoFormData = Omit<Impuesto, "id" | "activado">;
