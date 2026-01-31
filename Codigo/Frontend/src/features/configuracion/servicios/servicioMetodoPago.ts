import { apiConfiguracion } from "@/lib/axios";
import { MetodoPago, MetodoPagoFormData } from "../tipos/metodoPago.types";

const BASE_URL = "/metodos-pago";

export const servicioMetodoPago = {
  obtenerTodos: async (): Promise<MetodoPago[]> => {
    const response: any = await apiConfiguracion.get(BASE_URL);
    return response.data || response;
  },

  crear: async (datos: MetodoPagoFormData): Promise<MetodoPago> => {
    const response: any = await apiConfiguracion.post(BASE_URL, datos);
    return response.data;
  },

  actualizar: async (
    id: number,
    datos: MetodoPagoFormData,
  ): Promise<MetodoPago> => {
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
