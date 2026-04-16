export interface AfectacionIgv {
  id: number;
  codigo: string;
  descripcion: string;
  esGravado: boolean;
  esExonerado: boolean;
  esInafecto: boolean;
  esGratuito: boolean;
  codigoTributoDefault?: string;
  nombreTributoDefault?: string;
  activado: boolean;
}

export type AfectacionIgvFormData = Omit<AfectacionIgv, "id" | "activado">;
