import { format, parseISO, formatDistanceToNow } from "date-fns";
import { es } from "date-fns/locale";

/**
 * Formatea una fecha en formato dd/MM/yyyy
 */
export const formatearFecha = (fecha: string | Date): string => {
  try {
    const fechaObj = typeof fecha === "string" ? parseISO(fecha) : fecha;
    return format(fechaObj, "dd/MM/yyyy", { locale: es });
  } catch (error) {
    console.error("Error al formatear fecha:", error);
    return "";
  }
};

/**
 * Formatea una fecha con hora en formato dd/MM/yyyy HH:mm
 */
export const formatearFechaHora = (fecha: string | Date): string => {
  try {
    const fechaObj = typeof fecha === "string" ? parseISO(fecha) : fecha;
    return format(fechaObj, "dd/MM/yyyy HH:mm", { locale: es });
  } catch (error) {
    console.error("Error al formatear fecha y hora:", error);
    return "";
  }
};

/**
 * Formatea una fecha en formato relativo (hace 2 horas, hace 3 días, etc.)
 */
export const formatearFechaRelativa = (fecha: string | Date): string => {
  try {
    const fechaObj = typeof fecha === "string" ? parseISO(fecha) : fecha;
    return formatDistanceToNow(fechaObj, { addSuffix: true, locale: es });
  } catch (error) {
    console.error("Error al formatear fecha relativa:", error);
    return "";
  }
};

/**
 * Formatea una fecha en formato largo (1 de enero de 2024)
 */
export const formatearFechaLarga = (fecha: string | Date): string => {
  try {
    const fechaObj = typeof fecha === "string" ? parseISO(fecha) : fecha;
    return format(fechaObj, "d 'de' MMMM 'de' yyyy", { locale: es });
  } catch (error) {
    console.error("Error al formatear fecha larga:", error);
    return "";
  }
};
