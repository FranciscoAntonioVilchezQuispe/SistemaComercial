export interface Cliente {
  id: number;
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
  contactos?: ContactoCliente[];
}

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
}
