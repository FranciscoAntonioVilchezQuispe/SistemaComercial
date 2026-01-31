/**
 * Formatea un número como moneda en soles peruanos
 */
export const formatearMoneda = (
  valor: number,
  opciones?: {
    mostrarSimbolo?: boolean;
    decimales?: number;
  },
): string => {
  const { mostrarSimbolo = true, decimales = 2 } = opciones || {};

  const valorFormateado = new Intl.NumberFormat("es-PE", {
    minimumFractionDigits: decimales,
    maximumFractionDigits: decimales,
  }).format(valor);

  return mostrarSimbolo ? `S/ ${valorFormateado}` : valorFormateado;
};

/**
 * Formatea un número con separadores de miles
 */
export const formatearNumero = (
  valor: number,
  decimales: number = 0,
): string => {
  return new Intl.NumberFormat("es-PE", {
    minimumFractionDigits: decimales,
    maximumFractionDigits: decimales,
  }).format(valor);
};

/**
 * Formatea un número como porcentaje
 */
export const formatearPorcentaje = (
  valor: number,
  decimales: number = 2,
): string => {
  return `${formatearNumero(valor, decimales)}%`;
};

/**
 * Convierte un string de moneda a número
 */
export const parsearMoneda = (valor: string): number => {
  // Eliminar símbolos de moneda y espacios
  const valorLimpio = valor.replace(/[S/\s]/g, "");
  // Convertir a número
  return parseFloat(valorLimpio) || 0;
};
