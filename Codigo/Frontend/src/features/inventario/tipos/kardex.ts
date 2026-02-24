export interface KardexReporteItemDto {
  fecha: string;
  tipoDocumentoSunat: string;
  serieDocumento: string;
  numeroDocumento: string;
  tipoOperacionSunat: string;
  entradaCantidad: number;
  entradaCostoUnitario: number;
  entradaCostoTotal: number;
  salidaCantidad: number;
  salidaCostoUnitario: number;
  salidaCostoTotal: number;
  saldoCantidad: number;
  saldoCostoUnitario: number;
  saldoCostoTotal: number;
}

export interface KardexReporteDto {
  periodo: string;
  rucEmpresa: string;
  razonSocialEmpresa: string;
  establecimiento: string;
  codigoExistencia: string;
  tipoExistencia: string;
  descripcionExistencia: string;
  codigoUnidadMedida: string;
  metodoValuacion: string;
  detalles: KardexReporteItemDto[];
}

export interface PeriodoRequest {
  periodo: string;
  usuarioId: number;
}
