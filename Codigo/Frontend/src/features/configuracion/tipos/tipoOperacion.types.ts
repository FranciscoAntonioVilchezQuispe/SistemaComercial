export interface TipoOperacionSunat {
  id: number;
  codigo: string;
  nombre: string;
  activado: boolean;
}

export type TipoOperacionSunatFormData = Omit<TipoOperacionSunat, "id">;
