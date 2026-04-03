import { apiConfiguracion } from "@/lib/axios";
import {
  SerieComprobante,
  SerieComprobanteFormData,
} from "../tipos/serieComprobante.types";
import { PagedRequest, PagedResponse } from "@/types/pagination.types";

const BASE_URL = "/series";

export const servicioSerieComprobante = {
  obtenerTodas: async (params?: PagedRequest): Promise<PagedResponse<SerieComprobante>> => {
    const response: any = await apiConfiguracion.get(BASE_URL, { params });
    return response as PagedResponse<SerieComprobante>;
  },

  obtenerPorTipo: async (idTipo: number): Promise<SerieComprobante[]> => {
    const response: any = await apiConfiguracion.get(
      `${BASE_URL}/tipo/${idTipo}`,
    );
    const lista = response.datos || response.data || response;
    return Array.isArray(lista) ? lista : [];
  },

  crear: async (datos: SerieComprobanteFormData): Promise<SerieComprobante> => {
    const response: any = await apiConfiguracion.post(BASE_URL, datos);
    return response.datos || response.data;
  },

  actualizar: async (
    id: number,
    datos: SerieComprobanteFormData,
  ): Promise<SerieComprobante> => {
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
