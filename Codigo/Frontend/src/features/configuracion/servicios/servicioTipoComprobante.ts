import { apiConfiguracion } from "@/lib/axios";
import {
  TipoComprobante,
  TipoComprobanteFormData,
} from "../tipos/tipoComprobante.types";
import { PagedRequest, PagedResponse } from "@/types/pagination.types";

const BASE_URL = "/tipos-comprobante";

export const servicioTipoComprobante = {
  obtenerTodos: async (params?: PagedRequest & { modulo?: string }): Promise<PagedResponse<TipoComprobante>> => {
    const response: any = await apiConfiguracion.get(BASE_URL, { params });
    return response.datos || response.data || response;
  },

  crear: async (datos: TipoComprobanteFormData): Promise<TipoComprobante> => {
    const response: any = await apiConfiguracion.post(BASE_URL, datos);
    return response.datos || response.data;
  },

  actualizar: async (
    id: number,
    datos: TipoComprobanteFormData,
  ): Promise<TipoComprobante> => {
    const response: any = await apiConfiguracion.put(
      `${BASE_URL}/${id}`,
      datos,
    );
    return response.datos || response.data;
  },

  eliminar: async (id: number): Promise<void> => {
    await apiConfiguracion.delete(`${BASE_URL}/${id}`);
  },
};
