export interface TipoTributo {
  id: number;
  codigo: string;
  nombre: string;
  codigoInternacional: string;
  descripcion?: string;
  activado: boolean;
}

export type TipoTributoFormData = Omit<TipoTributo, "id" | "activado">;
