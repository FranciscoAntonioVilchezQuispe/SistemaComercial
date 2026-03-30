/**
 * Enums basados en los Catálogos SUNAT para Documentos Electrónicos
 */

export enum TipoComprobanteSunat {
  Factura = "01",
  Boleta = "03",
  NotaCredito = "07",
  NotaDebito = "08",
  ComprobanteRetencion = "20",
}

export enum MotivoNotaCredito {
  AnulacionOperacion = "01",
  AnulacionPorErrorRuc = "02",
  CorreccionPorErrorDescripcion = "03",
  DescuentoGlobal = "04",
  DescuentoPorItem = "05",
  DevolucionTotal = "06",
  DevolucionPorItem = "07",
  Bonificacion = "08",
  DisminucionValor = "09",
  Otros = "10",
}

export enum MotivoNotaDebito {
  InteresesPorMora = "01",
  AumentoValor = "02",
  PenalidadesOtros = "03",
}

export enum EstadoSunat {
  Pendiente = "PENDIENTE",
  Aceptado = "ACEPTADO",
  Rechazado = "RECHAZADO",
  Anulado = "ANULADO",
  Error = "ERROR",
}
