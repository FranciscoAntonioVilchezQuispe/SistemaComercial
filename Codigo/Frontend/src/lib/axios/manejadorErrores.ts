import { AxiosError } from "axios";
import { toast } from "sonner";

interface ErrorResponse {
  mensaje?: string;
  errores?: Record<string, string[]>;
}

export const manejadorErrores = (error: unknown) => {
  if (error instanceof AxiosError) {
    const errorData = error.response?.data as ErrorResponse;

    // Error de validación (400)
    if (error.response?.status === 400) {
      if (errorData?.errores) {
        // Mostrar errores de validación
        Object.entries(errorData.errores).forEach(([campo, mensajes]) => {
          mensajes.forEach((mensaje) => {
            toast.error(`${campo}: ${mensaje}`);
          });
        });
      } else if (errorData?.mensaje) {
        toast.error(errorData.mensaje);
      } else {
        toast.error("Error de validación");
      }
      return;
    }

    // Error de autenticación (401)
    if (error.response?.status === 401) {
      toast.error("Sesión expirada. Por favor, inicia sesión nuevamente.");
      return;
    }

    // Error de permisos (403)
    if (error.response?.status === 403) {
      toast.error("No tienes permisos para realizar esta acción");
      return;
    }

    // Error no encontrado (404)
    if (error.response?.status === 404) {
      toast.error("Recurso no encontrado");
      return;
    }

    // Error del servidor (500)
    if (error.response?.status === 500) {
      toast.error("Error del servidor. Por favor, intenta más tarde.");
      return;
    }

    // Error de red
    if (error.message === "Network Error") {
      toast.error("Error de conexión. Verifica tu conexión a internet.");
      return;
    }

    // Error genérico
    toast.error(errorData?.mensaje || "Ha ocurrido un error inesperado");
  } else {
    // Error no relacionado con Axios
    console.error("Error no manejado:", error);
    toast.error("Ha ocurrido un error inesperado");
  }
};
