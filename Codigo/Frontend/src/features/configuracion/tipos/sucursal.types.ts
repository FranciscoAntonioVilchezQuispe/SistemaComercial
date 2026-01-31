export interface Sucursal {
  id: number;
  idEmpresa: number;
  nombreSucursal: string;
  direccion: string | null;
  telefono: string | null;
  esPrincipal: boolean;
  activado: boolean;
}

export type SucursalFormData = Omit<Sucursal, "id" | "activado">;
