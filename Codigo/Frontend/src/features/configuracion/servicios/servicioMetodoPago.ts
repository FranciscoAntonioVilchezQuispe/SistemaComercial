import { apiConfiguracion } from "@/lib/axios";
import { MetodoPago, MetodoPagoFormData } from "../tipos/metodoPago.types";
import { PagedRequest, PagedResponse } from "@/types/pagination.types";

const BASE_URL = "/metodos-pago";

export const servicioMetodoPago = {
  obtenerTodos: async (params?: PagedRequest): Promise<PagedResponse<MetodoPago>> => {
    const response: any = await apiConfiguracion.get(BASE_URL, { params });
    return response.datos || response.data || response;
  },

  obtenerPorId: async (id: number): Promise<MetodoPago> => {
    const response: any = await apiConfiguracion.get(`${BASE_URL}/${id}`);
    return response.datos || response.data;
  },

  crear: async (datos: MetodoPagoFormData): Promise<MetodoPago> => {
    const response: any = await apiConfiguracion.post(BASE_URL, datos);
    return response.datos || response.data;
  },

  actualizar: async (id: number, datos: MetodoPagoFormData): Promise<MetodoPago> => {
    const response: any = await apiConfiguracion.put(`${BASE_URL}/${id}`, datos);
    return response.datos || response.data;
  },

  eliminar: async (id: number): Promise<void> => {
    await apiConfiguracion.delete(`${BASE_URL}/${id}`);
  },
};
