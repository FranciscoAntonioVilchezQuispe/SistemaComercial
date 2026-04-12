import { format, parseISO, formatDistanceToNow, differenceInHours } from "date-fns";
import { es } from "date-fns/locale";

export const APP_LOCALE = es;

/**
 * Formatea una fecha usando un string de formato (por defecto PPP)
 */
export const formatFecha = (
  fecha: Date | number | string | null | undefined,
  formatStr: string = "dd/MM/yyyy",
): string => {
  if (!fecha) return "";
  try {
    let fechaObj: Date | number;
    if (typeof fecha === "string") {
      fechaObj = parseISO(fecha);
    } else {
      fechaObj = fecha;
    }
    
    // Validar si la fecha es válida antes de formatear
    if (fechaObj instanceof Date && isNaN(fechaObj.getTime())) {
      return "";
    }

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
export const formatearFechaHora = (fecha: string | Date | null | undefined): string => {
  return formatFecha(fecha, "dd/MM/yyyy HH:mm");
};

/**
 * Formatea una fecha en formato relativo (hace 2 horas, hace 3 días, etc.)
 */
export const formatearFechaRelativa = (fecha: string | Date | null | undefined): string => {
  if (!fecha) return "";
  try {
    const fechaObj = typeof fecha === "string" ? parseISO(fecha) : fecha;
    
    if (fechaObj instanceof Date && isNaN(fechaObj.getTime())) {
      return "";
    }

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
export const formatearFechaLarga = (fecha: string | Date | null | undefined): string => {
  return formatFecha(fecha, "d 'de' MMMM 'de' yyyy");
};

/**
 * Determina si han pasado menos de 24 horas desde la fecha indicada (v1.0)
 * @param fecha Fecha de referencia (ISO string o Date)
 */
export const quedenMenosDe24Horas = (fecha: string | Date | null | undefined): boolean => {
  if (!fecha) return false;
  try {
    const fechaObj = typeof fecha === "string" ? parseISO(fecha) : fecha;
    if (fechaObj instanceof Date && isNaN(fechaObj.getTime())) return false;
    
    // Calcula la diferencia en horas entre "ahora" y la fecha de creación
    const horasTranscurridas = Math.abs(differenceInHours(new Date(), fechaObj));
    return horasTranscurridas < 24;
  } catch (error) {
    return false;
  }
};
