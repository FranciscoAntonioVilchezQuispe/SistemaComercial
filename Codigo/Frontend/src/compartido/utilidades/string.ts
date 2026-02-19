/**
 * Elimina todo lo que no sea dígito de un string
 */
export const limpiarSoloNumeros = (val: string): string =>
  val.replace(/\D/g, "");

/**
 * Elimina guiones de un string
 */
export const limpiarGuiones = (val: string): string => val.replace(/-/g, "");

/**
 * Permite solo números y un punto decimal, evitando múltiples puntos
 */
export const limpiarDecimal = (val: string): string => {
  let cleaned = val.replace(/[^0-9.]/g, "");
  const parts = cleaned.split(".");
  if (parts.length > 2) {
    cleaned = parts[0] + "." + parts.slice(1).join("");
  }
  return cleaned;
};

/**
 * Rellena con ceros a la izquierda hasta alcanzar el largo deseado
 */
export const padIzquierda = (val: string, largo: number = 8): string => {
  if (!val) return "";
  return val.padStart(largo, "0");
};
