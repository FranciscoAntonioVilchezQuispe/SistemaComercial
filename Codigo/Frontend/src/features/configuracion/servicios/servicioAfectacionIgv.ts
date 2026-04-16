import { apiConfiguracion } from "@/lib/axios";
import { AfectacionIgv, AfectacionIgvFormData } from "../tipos/afectacionIgv.types";
import { PagedRequest, PagedResponse } from "@/types/pagination.types";

const BASE_URL = "/configuracion/tipo-afectacion";

export const servicioAfectacionIgv = {
  obtenerTodos: async (params?: PagedRequest): Promise<PagedResponse<AfectacionIgv>> => {
    const response: any = await apiConfiguracion.get(BASE_URL, { params });
    return response as PagedResponse<AfectacionIgv>;
  },

  obtenerPorId: async (id: number): Promise<AfectacionIgv> => {
    const response: any = await apiConfiguracion.get(`${BASE_URL}/${id}`);
    return response.datos || response.data;
  },

  crear: async (datos: AfectacionIgvFormData): Promise<AfectacionIgv> => {
    const response: any = await apiConfiguracion.post(BASE_URL, datos);
    return response.datos || response.data;
  },

  actualizar: async (id: number, datos: AfectacionIgvFormData): Promise<AfectacionIgv> => {
    const response: any = await apiConfiguracion.put(`${BASE_URL}/${id}`, datos);
    return response.datos || response.data;
  },

  eliminar: async (id: number): Promise<void> => {
    await apiConfiguracion.delete(`${BASE_URL}/${id}`);
  },

  inicializar: async (): Promise<void> => {
    await apiConfiguracion.post(`${BASE_URL}/inicializar`);
  },
};
