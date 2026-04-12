/**
 * Tipos para Notas de Crédito, Notas de Débito y Catálogos SUNAT UBL 2.1
 */

export interface NotaResumen {
  id: number;
  idNota: number;
  serie: string;
  numero: number;
  tipoComprobante: string;
  fechaEmision: string;
  clienteRazonSocial: string;
  idEstado: number;
  estadoNombre: string;
  estadoCpe: string;
  total: number;
  totalFilas: number;
}

export interface MotivoNota {
  idMotivo: number;
  codigoSunat: string;
  descripcion: string;
}

export interface EstadoCpe {
  idEstado: string;
  descripcion: string;
}

export interface DetalleNotaPayload {
  idVentaDetalle?: number;
  idProducto: number;
  descripcion?: string;
  unidadMedida?: string;
  cantidad: number;
  precioUnitario: number;
}

export interface CrearNotaPayload {
  idVentaReferencia: number;
  serie: string;
  idTipoNota: number; // ID del motivo en BD
  motivoSustento: string; // "Anulación de la operación"
  afectaStock: boolean;
  detalles: DetalleNotaPayload[];
}
