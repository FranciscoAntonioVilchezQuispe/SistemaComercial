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
  ubigeo?: string;
  condicionSunat?: string;
  estadoSunat?: string;
  esAgenteRetencion: boolean;
  esBuenContribuyente: boolean;
  esAgentePercepcion: boolean;
  fechaUltimaConsultaSunat?: string;
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
  ubigeo?: string;
  condicionSunat?: string;
  estadoSunat?: string;
  esAgenteRetencion: boolean;
  esBuenContribuyente: boolean;
  esAgentePercepcion: boolean;
  fechaUltimaConsultaSunat?: string;
}
