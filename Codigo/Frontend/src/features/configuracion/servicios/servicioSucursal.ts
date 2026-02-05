import { apiConfiguracion } from "@/lib/axios";
import { Sucursal, SucursalFormData } from "../tipos/sucursal.types";

const BASE_URL = "/sucursales";

export const servicioSucursal = {
  obtenerTodas: async (): Promise<Sucursal[]> => {
    const response: any = await apiConfiguracion.get(BASE_URL);
    // Asumiendo que retorna { data: [...] } o directamente [...]
    // Si usa ToReturnList, response.data es el array
    return response.datos || response.data || response;
  },

  crear: async (datos: SucursalFormData): Promise<Sucursal> => {
    const response: any = await apiConfiguracion.post(BASE_URL, datos);
    return response.datos || response.data;
  },

  actualizar: async (
    id: number,
    datos: SucursalFormData,
  ): Promise<Sucursal> => {
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
