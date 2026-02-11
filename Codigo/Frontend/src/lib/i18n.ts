import { es } from "date-fns/locale";
import { format } from "date-fns";

export const APP_LOCALE = es;

export const formatFecha = (
  fecha: Date | number,
  formatStr: string = "PPP",
) => {
  return format(fecha, formatStr, { locale: APP_LOCALE });
};

export const formatMoneda = (cantidad: number) => {
  return new Intl.NumberFormat("es-PE", {
    style: "currency",
    currency: "PEN",
  }).format(cantidad);
};

export const formatDecimal = (cantidad: number, decimales: number = 2) => {
  return new Intl.NumberFormat("es-PE", {
    minimumFractionDigits: decimales,
    maximumFractionDigits: decimales,
  }).format(cantidad);
};

// Funciones de limpieza de inputs con Regex
export const limpiarSoloNumeros = (val: string) => val.replace(/\D/g, "");

export const limpiarDecimal = (val: string) => {
  // Permite solo números y un punto decimal
  let cleaned = val.replace(/[^0-9.]/g, "");
  // Evita múltiples puntos
  const parts = cleaned.split(".");
  if (parts.length > 2) {
    cleaned = parts[0] + "." + parts.slice(1).join("");
  }
  return cleaned;
};

export const limpiarGuiones = (val: string) => val.replace(/[^0-9-]/g, "");
