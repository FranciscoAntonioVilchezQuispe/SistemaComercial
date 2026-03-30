/**
 * Formatea un número como moneda en soles peruanos
 */
export const formatMoneda = (
  valor: number | null | undefined,
  opciones?: {
    mostrarSimbolo?: boolean;
    decimales?: number;
  },
): string => {
  const { mostrarSimbolo = true, decimales = 2 } = opciones || {};

  // Manejar valores nulos o indefinidos para evitar NaN
  if (valor === null || valor === undefined || isNaN(Number(valor))) {
    return mostrarSimbolo ? `S/ 0.00` : "0.00";
  }

  const valorNum = Number(valor);

  const valorFormateado = new Intl.NumberFormat("es-PE", {
    minimumFractionDigits: decimales,
    maximumFractionDigits: decimales,
  }).format(valorNum);

  return mostrarSimbolo ? `S/ ${valorFormateado}` : valorFormateado;
};

/**
 * Alias de formatMoneda para compatibilidad
 */
export const formatearMoneda = formatMoneda;

/**
 * Formatea un número con separadores de miles y decimales fijos
 */
export const formatDecimal = (valor: number | null | undefined, decimales: number = 2): string => {
  if (valor === null || valor === undefined || isNaN(Number(valor))) {
    return "0.00";
  }
  
  return new Intl.NumberFormat("es-PE", {
    minimumFractionDigits: decimales,
    maximumFractionDigits: decimales,
  }).format(Number(valor));
};

/**
 * Formatea un número con separadores de miles
 */
export const formatearNumero = (
  valor: number | null | undefined,
  decimales: number = 0,
): string => {
  return formatDecimal(valor, decimales);
};

/**
 * Formatea un número como porcentaje
 */
export const formatearPorcentaje = (
  valor: number | null | undefined,
  decimales: number = 2,
): string => {
  return `${formatDecimal(valor, decimales)}%`;
};

/**
 * Convierte un string de moneda a número
 */
export const parsearMoneda = (valor: string): number => {
  // Eliminar símbolos de moneda y espacios
  const valorLimpio = valor.replace(/[S/\s]/g, "").replace(/,/g, "");
  // Convertir a número
  return parseFloat(valorLimpio) || 0;
};
