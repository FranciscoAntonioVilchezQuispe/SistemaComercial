import { apiConfiguracion } from "@/lib/axios";
import {
  TipoOperacionSunat,
  TipoOperacionSunatFormData,
} from "../tipos/tipoOperacion.types";

const BASE_URL = "/operaciones-sunat";

export const servicioTipoOperacion = {
  obtenerTodos: async (): Promise<TipoOperacionSunat[]> => {
    const response: any = await apiConfiguracion.get(BASE_URL);
    return response.datos || response.data || response;
  },

  crear: async (
    datos: TipoOperacionSunatFormData,
  ): Promise<TipoOperacionSunat> => {
    const response: any = await apiConfiguracion.post(BASE_URL, datos);
    return response.datos || response.data;
  },

  actualizar: async (
    id: number,
    datos: TipoOperacionSunatFormData,
  ): Promise<TipoOperacionSunat> => {
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
