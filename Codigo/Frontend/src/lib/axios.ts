/// <reference types="vite/client" />
import axios, {
  AxiosInstance,
  AxiosResponse,
  InternalAxiosRequestConfig,
} from "axios";

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
    (error) => Promise.reject(error),
  );

  // Interceptor para manejar respuestas estandarizadas o errores
  instance.interceptors.response.use(
    (response: AxiosResponse) => {
      // Devolvemos el data directamente que contiene el Wrapper ToReturn/ToReturnList
      return response.data;
    },
    (error) => {
      if (error.response?.status === 401) {
        localStorage.removeItem("token");
        if (window.location.pathname !== "/login") {
          window.location.href = "/login";
        }
      }
      return Promise.reject(error);
    },
  );

  return instance;
};

// URL Base dinámica desde variables de entorno
const getUrl = (port: number, envVar: string) => {
  return import.meta.env[envVar] || `http://localhost:${port}/api`;
};

// Instancias para microservicios específicos
export const apiIdentidad = createApiInstance(
  getUrl(5001, "VITE_API_IDENTIDAD_URL"),
);
export const apiConfiguracion = createApiInstance(
  getUrl(5002, "VITE_API_CONFIGURACION_URL"),
);
export const apiCatalogo = createApiInstance(
  getUrl(5008, "VITE_API_CATALOGO_URL"),
);
export const apiInventario = createApiInstance(
  getUrl(5003, "VITE_API_INVENTARIO_URL"),
);
export const apiVentas = createApiInstance(getUrl(5005, "VITE_API_VENTAS_URL"));
export const apiCompras = createApiInstance(
  getUrl(5010, "VITE_API_COMPRAS_URL"),
);
export const apiClientes = createApiInstance(
  getUrl(5009, "VITE_API_CLIENTES_URL"),
);
export const apiContabilidad = createApiInstance(
  getUrl(5004, "VITE_API_CONTABILIDAD_URL"),
);

// Instancia por defecto (apunta a Ventas o Gateway si se requiere)
const api = apiVentas;

export default api;
