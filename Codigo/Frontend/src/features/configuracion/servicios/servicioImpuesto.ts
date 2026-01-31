import { apiConfiguracion } from "@/lib/axios";
import { Impuesto, ImpuestoFormData } from "../tipos/impuesto.types";

const BASE_URL = "/impuestos";

export const servicioImpuesto = {
  obtenerTodos: async (): Promise<Impuesto[]> => {
    const response: any = await apiConfiguracion.get(BASE_URL);
    return response.data || response;
  },

  crear: async (datos: ImpuestoFormData): Promise<Impuesto> => {
    const response: any = await apiConfiguracion.post(BASE_URL, datos);
    return response.data;
  },

  actualizar: async (
    id: number,
    datos: ImpuestoFormData,
  ): Promise<Impuesto> => {
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
