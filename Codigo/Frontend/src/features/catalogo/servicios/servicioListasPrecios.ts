import { apiCatalogo } from "@/lib/axios";
import {
  RespuestaListasPrecios,
  ListaPrecio,
  ListaPrecioFormData,
} from "../tipos/catalogo.types";

const BASE_URL = "/listas-precios";

export const servicioListasPrecios = {
  obtenerListas: async (activo?: boolean): Promise<RespuestaListasPrecios> => {
    const params = new URLSearchParams();
    if (activo !== undefined) params.append("activo", activo.toString());

    const response: any = await apiCatalogo.get(
      `${BASE_URL}?${params.toString()}`,
    );
    return response;
  },

  crearLista: async (datos: ListaPrecioFormData): Promise<ListaPrecio> => {
    const response: any = await apiCatalogo.post(BASE_URL, datos);
    return response.data;
  },

  actualizarLista: async (
    id: number,
    datos: ListaPrecioFormData,
  ): Promise<ListaPrecio> => {
    const response: any = await apiCatalogo.put(`${BASE_URL}/${id}`, datos);
    return response.data;
  },

  eliminarLista: async (id: number): Promise<void> => {
    await apiCatalogo.delete(`${BASE_URL}/${id}`);
  },
};
