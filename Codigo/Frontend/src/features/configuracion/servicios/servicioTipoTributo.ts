import { apiConfiguracion } from "@/lib/axios";
import { TipoTributo, TipoTributoFormData } from "../tipos/tipoTributo.types";
import { PagedRequest, PagedResponse } from "@/types/pagination.types";

const BASE_URL = "/configuracion/tipo-tributo";

export const servicioTipoTributo = {
  obtenerTodos: async (params?: PagedRequest): Promise<PagedResponse<TipoTributo>> => {
    const response: any = await apiConfiguracion.get(BASE_URL, { params });
    return response as PagedResponse<TipoTributo>;
  },

  obtenerPorId: async (id: number): Promise<TipoTributo> => {
    const response: any = await apiConfiguracion.get(`${BASE_URL}/${id}`);
    return response.datos || response.data;
  },

  crear: async (datos: TipoTributoFormData): Promise<TipoTributo> => {
    const response: any = await apiConfiguracion.post(BASE_URL, datos);
    return response.datos || response.data;
  },

  actualizar: async (id: number, datos: TipoTributoFormData): Promise<TipoTributo> => {
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
