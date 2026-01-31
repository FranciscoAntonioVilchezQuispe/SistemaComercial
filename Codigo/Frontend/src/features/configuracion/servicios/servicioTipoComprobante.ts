import { apiConfiguracion } from "@/lib/axios";
import {
  TipoComprobante,
  TipoComprobanteFormData,
} from "../tipos/tipoComprobante.types";

const BASE_URL = "/tipos-comprobante";

export const servicioTipoComprobante = {
  obtenerTodos: async (): Promise<TipoComprobante[]> => {
    const response: any = await apiConfiguracion.get(BASE_URL);
    return response.data || response;
  },

  crear: async (datos: TipoComprobanteFormData): Promise<TipoComprobante> => {
    const response: any = await apiConfiguracion.post(BASE_URL, datos);
    return response.data;
  },

  actualizar: async (
    id: number,
    datos: TipoComprobanteFormData,
  ): Promise<TipoComprobante> => {
    const response: any = await apiConfiguracion.put(
      `${BASE_URL}/${id}`,
      datos,
    );
    return response.data;
  },

  eliminar: async (id: number): Promise<void> => {
    await apiConfiguracion.delete(`${BASE_URL}/${id}`);
  },
};
