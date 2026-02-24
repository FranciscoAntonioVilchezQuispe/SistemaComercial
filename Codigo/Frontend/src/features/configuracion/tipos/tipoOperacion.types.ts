export interface TipoOperacionSunat {
  id: number;
  codigo: string;
  nombre: string;
  activo: boolean;
}

export type TipoOperacionSunatFormData = Omit<TipoOperacionSunat, "id">;
