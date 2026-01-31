export interface Almacen {
  id: number;
  nombre: string;
  direccion?: string;
  esPrincipal: boolean;
  activo: boolean;
  fechaCreacion: string;
}

export interface AlmacenFormData {
  id?: number;
  nombre: string;
  direccion?: string;
  esPrincipal?: boolean;
  activo?: boolean;
}
