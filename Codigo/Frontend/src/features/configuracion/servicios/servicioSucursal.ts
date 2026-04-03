import { apiConfiguracion } from "@/lib/axios";
import { Sucursal, SucursalFormData } from "../tipos/sucursal.types";
import { PagedRequest, PagedResponse } from "@/types/pagination.types";

const BASE_URL = "/sucursales";

export const servicioSucursal = {
  obtenerTodas: async (params?: PagedRequest): Promise<PagedResponse<Sucursal>> => {
    const response: any = await apiConfiguracion.get(BASE_URL, { params });
    return response as PagedResponse<Sucursal>;
  },

  obtenerPorId: async (id: number): Promise<Sucursal> => {
    const response: any = await apiConfiguracion.get(`${BASE_URL}/${id}`);
    return response.datos || response.data;
  },

  crear: async (datos: SucursalFormData): Promise<Sucursal> => {
    const response: any = await apiConfiguracion.post(BASE_URL, datos);
    return response.datos || response.data;
  },

  actualizar: async (id: number, datos: SucursalFormData): Promise<Sucursal> => {
    const response: any = await apiConfiguracion.put(`${BASE_URL}/${id}`, datos);
    return response.datos || response.data;
  },

  eliminar: async (id: number): Promise<void> => {
    await apiConfiguracion.delete(`${BASE_URL}/${id}`);
  },
};
