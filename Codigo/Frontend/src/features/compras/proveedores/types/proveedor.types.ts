export interface Proveedor {
  id: number;
  idTipoDocumento: number;
  numeroDocumento: string;
  razonSocial: string;
  nombreComercial?: string;
  direccion?: string;
  telefono?: string;
  email?: string;
  paginaWeb?: string;
  activado: boolean;
  fechaCreacion: string;
}

export interface ProveedorFormData {
  id?: number;
  idTipoDocumento: number;
  numeroDocumento: string;
  razonSocial: string;
  nombreComercial?: string;
  direccion?: string;
  telefono?: string;
  email?: string;
  paginaWeb?: string;
  activado?: boolean;
}
