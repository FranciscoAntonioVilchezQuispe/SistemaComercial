/**
 * Configuración Fiscal para Perú (SUNAT)
 */
export const FISCAL_CONFIG = {
  /**
   * Porcentaje de IGV estándar (18.00%)
   */
  PORCENTAJE_IGV: 18.00,

  /**
   * Factor divisor para obtener base imponible (1.18)
   */
  FACTOR_IGV: 1.18,

  /**
   * Símbolos y códigos de moneda
   */
  MONEDA: {
    SIMBOLO: "S/",
    CODIGO: "PEN",
    NOMBRE: "Soles",
  },

  /**
   * Códigos de tributo SUNAT (Catálogo 05)
   */
  TRIBUTOS: {
    IGV: "1000",
    ISC: "2000",
    OTROS: "9999",
  },
};
