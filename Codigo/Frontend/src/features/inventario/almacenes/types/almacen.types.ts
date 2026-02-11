export interface Almacen {
  id: number;
  nombreAlmacen: string; // Changed from nombre
  direccion?: string;
  esPrincipal: boolean;
  activado: boolean;
  fechaCreacion: string;
}

export interface AlmacenFormData {
  id?: number;
  nombreAlmacen: string;
  direccion?: string;
  esPrincipal?: boolean;
  activado?: boolean;
}
