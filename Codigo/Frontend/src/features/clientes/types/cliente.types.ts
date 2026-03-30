/** Interface ligera para el listado de clientes (Grids) */
export interface ClienteResumen {
  id: number;
  idTipoDocumento: number;
  tipoDocumentoNombre: string;
  numeroDocumento: string;
  razonSocial: string;
  nombreComercial?: string;
  condicionSunat?: string;
  estadoSunat?: string;
  activado: boolean;
}

/** Interface completa para la ficha del cliente */
export interface ClienteDetalle {
  id: number;
  idTipoDocumento: number;
  tipoDocumentoNombre: string;
  numeroDocumento: string;
  razonSocial: string;
  nombreComercial?: string;
  direccion?: string;
  telefono?: string;
  email?: string;
  idTipoCliente?: number;
  tipoClienteNombre?: string;
  limiteCredito?: number;
  diasCredito?: number;
  idListaPrecioAsignada?: number;
  activado: boolean;
  ubigeo?: string;
  condicionSunat?: string;
  estadoSunat?: string;
  esAgenteRetencion: boolean;
  esBuenContribuyente: boolean;
  esAgentePercepcion: boolean;
  fechaUltimaConsultaSunat?: string;
  contactos?: ContactoCliente[];
}

/** @deprecated Usar ClienteResumen o ClienteDetalle */
export type Cliente = ClienteResumen | ClienteDetalle;

export interface ContactoCliente {
  id: number;
  idCliente: number;
  nombres: string;
  cargo?: string;
  telefono?: string;
  email?: string;
  esPrincipal: boolean;
  activado: boolean;
}

export interface ClienteFormData {
  idTipoDocumento: number;
  numeroDocumento: string;
  razonSocial: string;
  nombreComercial?: string;
  direccion?: string;
  telefono?: string;
  email?: string;
  idTipoCliente?: number;
  limiteCredito?: number;
  diasCredito?: number;
  idListaPrecioAsignada?: number;
  activado: boolean;
  ubigeo?: string;
  condicionSunat?: string;
  estadoSunat?: string;
  esAgenteRetencion: boolean;
  esBuenContribuyente: boolean;
  esAgentePercepcion: boolean;
  fechaUltimaConsultaSunat?: string;
}
