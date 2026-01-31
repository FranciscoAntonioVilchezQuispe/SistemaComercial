export interface Empresa {
  id: number;
  ruc: string;
  razonSocial: string;
  nombreComercial: string;
  direccionFiscal: string;
  telefono: string;
  correoContacto: string;
  sitioWeb: string;
  logoUrl: string;
  monedaPrincipal: string; // "PEN", "USD", etc.
}

export type EmpresaFormData = Omit<Empresa, "id">;
