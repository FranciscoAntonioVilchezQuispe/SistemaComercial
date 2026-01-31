/**
 * Valida si un email tiene formato válido
 */
export const validarEmail = (email: string): boolean => {
  const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return regex.test(email);
};

/**
 * Valida si un RUC peruano es válido (11 dígitos)
 */
export const validarRUC = (ruc: string): boolean => {
  // Debe tener exactamente 11 dígitos
  if (!/^\d{11}$/.test(ruc)) {
    return false;
  }

  // El primer dígito debe ser 1 o 2 (persona natural) o 2 (persona jurídica)
  const primerDigito = parseInt(ruc[0]);
  if (primerDigito !== 1 && primerDigito !== 2) {
    return false;
  }

  return true;
};

/**
 * Valida si un DNI peruano es válido (8 dígitos)
 */
export const validarDNI = (dni: string): boolean => {
  return /^\d{8}$/.test(dni);
};

/**
 * Valida si un teléfono peruano es válido
 */
export const validarTelefono = (telefono: string): boolean => {
  // Celular: 9 dígitos empezando con 9
  // Fijo: 7 dígitos (Lima) o 6 dígitos (provincias)
  return /^9\d{8}$/.test(telefono) || /^\d{6,7}$/.test(telefono);
};
