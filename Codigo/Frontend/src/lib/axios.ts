/// <reference types="vite/client" />
import axios, {
  AxiosInstance,
  AxiosResponse,
  InternalAxiosRequestConfig
} from "axios";
import { toast } from "sonner";

import { capturadorErrores } from "../compartido/utilidades/capturadorErrores";

// Función factory para crear instancias con interceptores comunes
const createApiInstance = (baseURL: string): AxiosInstance => {
  const instance = axios.create({
    baseURL,
    headers: {
      "Content-Type": "application/json",
    },
  });

  // Interceptor para agregar token (si existe)
  instance.interceptors.request.use(
    (config: InternalAxiosRequestConfig) => {
      const token = localStorage.getItem("sc_token");
      if (token && config.headers) {
        config.headers.Authorization = `Bearer ${token}`;
      }
      return config;
    },
    (error) => {
      capturadorErrores.capturar(error, 'API', { componente: 'AxiosRequest' });
      return Promise.reject(error);
    },
  );

  // Variable para controlar el spam de mensajes de permisos (403)
  let lastForbiddenToastTime = 0;
  const FORBIDDEN_TOAST_COOLDOWN = 3000; // 3 segundos

  // Interceptor para manejar respuestas estandarizadas o errores
  instance.interceptors.response.use(
    (response: AxiosResponse) => {
      const data = response.data;
      
      if (data && typeof data.status === 'number' && ![200, 201].includes(data.status)) {
        const mensajeError = data.message || "Lo sentimos, no pudimos completar esta operación.";
        
        capturadorErrores.capturar(mensajeError, 'API', {
          metadata: { 
            statusInterno: data.status,
            url: response.config.url,
            metodo: response.config.method
          }
        });

        toast.error(mensajeError, {
          description: `Referencia: ${data.status}`,
        });
        
        const error = new Error(mensajeError);
        (error as any).response = response;
        throw error;
      }

      return data;
    },
    (error) => {
      if (error.response?.status === 401) {
        localStorage.removeItem("sc_token");
        localStorage.removeItem("sc_refresh");
        if (window.location.pathname !== "/login") {
          window.location.href = "/login";
        }
        return Promise.reject(error);
      } 
      
      const isForbidden = error.response?.status === 403;
      
      // Registro sistemático del error
      capturadorErrores.capturar(error, 'API', {
        metadata: {
          status: error.response?.status,
          url: error.config?.url,
          metodo: error.config?.method,
          data: error.response?.data
        }
      });

      // Manejo de alertas automáticas
      const skipToast = (error.config as any)?._skipToast;
      
      if (!skipToast) {
        // Lógica de unificación para 403 (Permisos)
        if (isForbidden) {
          const now = Date.now();
          if (now - lastForbiddenToastTime > FORBIDDEN_TOAST_COOLDOWN) {
            toast.warning("Acceso restringido", {
              description: "No tienes los permisos necesarios para algunas funciones de esta sección.",
              duration: 5000
            });
            lastForbiddenToastTime = now;
          }
        } else {
          const errorData = error.response?.data;
          let mensaje =
            errorData?.message ||
            errorData?.Message ||
            (typeof errorData === 'string' ? errorData : null) ||
            error.message ||
            "Ocurrió un inconveniente inesperado.";

          if (errorData?.errors && typeof errorData.errors === 'object') {
             const primerError = Object.values(errorData.errors)[0];
             if (Array.isArray(primerError) && primerError.length > 0) {
               mensaje = primerError[0];
             }
          }

          toast.error(mensaje, {
            description: `Código de error: ${error.response?.status || 500}`,
          });
        }

        (error as any)._sentToast = true;
      }

      return Promise.reject(error);
    },
  );

  return instance;
};

// Instancias para microservicios específicos (LEER DESDE .ENV)
// Todas apuntan a la base /api del Gateway.
// Las rutas específicas (ej: /proveedores, /marcas) se definen en los servicios y son rooteadas por YARP.
const GATEWAY_BASE_URL = import.meta.env.VITE_API_URL || "http://localhost:5000/api";

export const apiIdentidad = createApiInstance(GATEWAY_BASE_URL);
export const apiConfiguracion = createApiInstance(GATEWAY_BASE_URL);
export const apiCatalogo = createApiInstance(GATEWAY_BASE_URL);
export const apiInventario = createApiInstance(GATEWAY_BASE_URL);
export const apiVentas = createApiInstance(GATEWAY_BASE_URL);
export const apiCompras = createApiInstance(GATEWAY_BASE_URL);
export const apiClientes = createApiInstance(GATEWAY_BASE_URL);
export const apiContabilidad = createApiInstance(GATEWAY_BASE_URL);

// Instancia por defecto
const api = createApiInstance(GATEWAY_BASE_URL);

export default api;
