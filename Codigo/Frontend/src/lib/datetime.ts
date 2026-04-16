import { format, parseISO, isValid } from 'date-fns';
import { es } from 'date-fns/locale';

/**
 * CONFIGURACIÓN GLOBAL DE FECHAS (PERÚ)
 */
export const DATE_CONFIG = {
  timezone: 'America/Lima',
  displayFormat: 'dd/MM/yyyy',
  displayDateTimeFormat: 'dd/MM/yyyy HH:mm:ss',
  apiDateFormat: 'yyyy-MM-dd',
  apiDateTimeFormat: "yyyy-MM-dd'T'HH:mm:ss",
};

/**
 * Obtiene la fecha y hora actual ajustada a Lima (UTC-5)
 */
export const getCurrentDateTime = (): Date => {
  // En un navegador, el objeto Date local depende del sistema.
  // Pero para consistencia con el backend, podemos forzar el offset de Lima si fuera necesario.
  // Por ahora devolvemos el Date nativo, asumiendo que el navegador está en la zona correcta
  // o que la lógica de visualización se encargará del ajuste.
  // eslint-disable-next-line no-restricted-syntax
  return new Date();
};

/**
 * Formatea una fecha para visualización (DD/MM/YYYY)
 */
export const formatDateForDisplay = (date: Date | string | undefined | null): string => {
  if (!date) return '-';
  const dateObj = typeof date === 'string' ? parseISO(date) : date;
  if (!isValid(dateObj)) return '-';
  return format(dateObj, DATE_CONFIG.displayFormat, { locale: es });
};

/**
 * Formatea una fecha y hora para visualización (DD/MM/YYYY HH:MM:SS)
 */
export const formatDateTimeForDisplay = (date: Date | string | undefined | null): string => {
  if (!date) return '-';
  const dateObj = typeof date === 'string' ? parseISO(date) : date;
  if (!isValid(dateObj)) return '-';
  return format(dateObj, DATE_CONFIG.displayDateTimeFormat, { locale: es });
};

/**
 * Formatea una fecha para enviar a la API (YYYY-MM-DD)
 */
export const formatDateForAPI = (date: Date | string | undefined | null): string | null => {
  if (!date) return null;
  const dateObj = typeof date === 'string' ? parseISO(date) : date;
  if (!isValid(dateObj)) return null;
  return format(dateObj, DATE_CONFIG.apiDateFormat);
};

/**
 * Convierte una cadena de la API a un objeto Date
 */
export const parseAPIDate = (dateString: string | undefined | null): Date | null => {
  if (!dateString) return null;
  const date = parseISO(dateString);
  return isValid(date) ? date : null;
};

/**
 * Obtiene el periodo actual en formato YYYY-MM
 */
export const getCurrentPeriod = (): string => {
  return format(getCurrentDateTime(), 'yyyy-MM');
};
