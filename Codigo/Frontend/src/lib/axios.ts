/// <reference types="vite/client" />
import axios, {
  AxiosInstance,
  AxiosResponse,
  InternalAxiosRequestConfig,
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
      const token = localStorage.getItem("token");
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

  // Interceptor para manejar respuestas estandarizadas o errores
  instance.interceptors.response.use(
    (response: AxiosResponse) => {
      const data = response.data;
      
      // Si la respuesta tiene un formato estandarizado con un status interno
      // y ese status indica un error (distinto de 200 o 201), lanzamos error.
      if (data && typeof data.status === 'number' && ![200, 201].includes(data.status)) {
        const mensajeError = data.message || "Error en la operación";
        
        // Capturamos el error interno del negocio
        capturadorErrores.capturar(mensajeError, 'API', {
          metadata: { 
            statusInterno: data.status,
            url: response.config.url,
            metodo: response.config.method
          }
        });

        toast.error(mensajeError, {
          description: `Código Interno: ${data.status}`,
        });
        
        const error = new Error(mensajeError);
        (error as any).response = response;
        throw error;
      }

      return data;
    },
    (error) => {
      if (error.response?.status === 401) {
        localStorage.removeItem("token");
        if (window.location.pathname !== "/login") {
          window.location.href = "/login";
        }
      }

      // Registro sistemático del error de red
      capturadorErrores.capturar(error, 'API', {
        metadata: {
          status: error.response?.status,
          url: error.config?.url,
          metodo: error.config?.method,
          data: error.response?.data
        }
      });

      // Manejo de alertas automáticas
      const errorData = error.response?.data;
      let mensaje =
        errorData?.message ||
        errorData?.Message ||
        error.message ||
        "Ocurrió un error inesperado";

      if (errorData?.errors && Array.isArray(errorData.errors) && errorData.errors.length > 0) {
          const primerError = errorData.errors[0];
          mensaje = primerError.error || primerError.message || mensaje;
      }

      toast.error(mensaje, {
        description: `Código: ${error.response?.status || 500}`,
      });

      return Promise.reject(error);
    },
  );

  return instance;
};

// Instancias para microservicios específicos (APUNTANDO AL GATEWAY 5000)
// Todas apuntan a la base /api del Gateway.
// Las rutas específicas (ej: /proveedores, /marcas) se definen en los servicios y son rooteadas por YARP.
const GATEWAY_BASE_URL = "http://localhost:5000/api";

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
