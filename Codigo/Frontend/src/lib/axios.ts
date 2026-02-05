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
