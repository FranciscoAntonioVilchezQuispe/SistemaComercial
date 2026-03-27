import { apiConfiguracion } from "@/lib/axios";
import { Impuesto, ImpuestoFormData } from "../tipos/impuesto.types";
import { PagedRequest, PagedResponse } from "@/types/pagination.types";

const BASE_URL = "/impuestos";

export const servicioImpuesto = {
  obtenerTodos: async (params?: PagedRequest): Promise<PagedResponse<Impuesto>> => {
    const response: any = await apiConfiguracion.get(BASE_URL, { params });
    return response.datos || response.data || response;
  },

  obtenerPorId: async (id: number): Promise<Impuesto> => {
    const response: any = await apiConfiguracion.get(`${BASE_URL}/${id}`);
    return response.datos || response.data;
  },

  crear: async (datos: ImpuestoFormData): Promise<Impuesto> => {
    const response: any = await apiConfiguracion.post(BASE_URL, datos);
    return response.datos || response.data;
  },

  actualizar: async (id: number, datos: ImpuestoFormData): Promise<Impuesto> => {
    const response: any = await apiConfiguracion.put(`${BASE_URL}/${id}`, datos);
    return response.datos || response.data;
  },

  eliminar: async (id: number): Promise<void> => {
    await apiConfiguracion.delete(`${BASE_URL}/${id}`);
  },
};
