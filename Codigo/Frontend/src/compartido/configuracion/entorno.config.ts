/**
 * Configuración de entorno para el Sistema Comercial.
 * Centraliza las variables de import.meta.env para facilitar su uso.
 */

// Se extrae la URL base del Gateway. 
// Vite requiere que las variables de entorno comiencen con VITE_
const baseApi = import.meta.env.VITE_API_URL || "http://localhost:5000/api";

/**
 * URL base del API Gateway (sin el sufijo /api para permitir concatenación manual en los servicios)
 */
export const apiGatewayURL = baseApi.replace(/\/api$/, "");
