export interface ReglaDocumento {
  codigo: string;
  nombre: string;
  longitud: number;
  esNumerico: boolean;
}

export const REGLAS_DOCUMENTOS: Record<string, ReglaDocumento> = {
  "1": { codigo: "1", nombre: "DNI", longitud: 8, esNumerico: true },
  "6": { codigo: "6", nombre: "RUC", longitud: 11, esNumerico: true },
  "4": {
    codigo: "4",
    nombre: "CARNET EXTRANJERIA",
    longitud: 12,
    esNumerico: false,
  },
};

export const RELACION_DOC_COMPROBANTE: Record<string, string[]> = {
  "6": ["01"], // RUC -> Factura
  "1": ["03", "01"], // DNI -> Boleta
};

export const COMPROBANTES_SUNAT = {
  FACTURA: "01",
  BOLETA: "03",
  NOTA_CREDITO: "07",
  NOTA_DEBITO: "08",
};
