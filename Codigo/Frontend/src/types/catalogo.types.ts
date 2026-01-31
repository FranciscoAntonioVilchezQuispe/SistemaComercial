export interface ValorCatalogo {
  id: number;
  codigo: string;
  nombre: string;
  descripcion?: string;
  valorReferencia?: string;
  orden?: number;
  activo: boolean;
}

export interface Catalogo {
  id: number;
  codigo: string;
  nombre: string;
  descripcion?: string;
  valores: ValorCatalogo[];
}
