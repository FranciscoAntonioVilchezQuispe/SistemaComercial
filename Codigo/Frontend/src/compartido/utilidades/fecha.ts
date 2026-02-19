import { format, parseISO, formatDistanceToNow } from "date-fns";
import { es } from "date-fns/locale";

export const APP_LOCALE = es;

/**
 * Formatea una fecha usando un string de formato (por defecto PPP)
 */
export const formatFecha = (
  fecha: Date | number | string,
  formatStr: string = "dd/MM/yyyy",
): string => {
  try {
    const fechaObj = typeof fecha === "string" ? parseISO(fecha) : fecha;
    return format(fechaObj, formatStr, { locale: APP_LOCALE });
  } catch (error) {
    console.error("Error al formatear fecha:", error);
    return "";
  }
};

/**
 * Alias de formatFecha para compatibilidad
 */
export const formatearFecha = formatFecha;

/**
 * Formatea una fecha con hora en formato dd/MM/yyyy HH:mm
 */
export const formatearFechaHora = (fecha: string | Date): string => {
  return formatFecha(fecha, "dd/MM/yyyy HH:mm");
};

/**
 * Formatea una fecha en formato relativo (hace 2 horas, hace 3 días, etc.)
 */
export const formatearFechaRelativa = (fecha: string | Date): string => {
  try {
    const fechaObj = typeof fecha === "string" ? parseISO(fecha) : fecha;
    return formatDistanceToNow(fechaObj, {
      addSuffix: true,
      locale: APP_LOCALE,
    });
  } catch (error) {
    console.error("Error al formatear fecha relativa:", error);
    return "";
  }
};

/**
 * Formatea una fecha en formato largo (1 de enero de 2024)
 */
export const formatearFechaLarga = (fecha: string | Date): string => {
  return formatFecha(fecha, "d 'de' MMMM 'de' yyyy");
};
