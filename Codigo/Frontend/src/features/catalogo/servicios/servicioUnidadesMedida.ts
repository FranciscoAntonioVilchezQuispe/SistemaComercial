import { apiCatalogo } from "@/lib/axios";
import {
  RespuestaUnidadesMedida,
  UnidadMedida,
  UnidadMedidaFormData,
} from "../tipos/catalogo.types";

const BASE_URL = "/unidades-medida"; // Corregido: con guion según backend

export const servicioUnidadesMedida = {
  obtenerUnidades: async (
    activo?: boolean,
  ): Promise<RespuestaUnidadesMedida> => {
    const params = new URLSearchParams();
    if (activo !== undefined) params.append("activo", activo.toString());

    // Asumiendo que las unidades podrían no estar paginadas igual que marcas o usamos un endpoint simple
    // Ajustar según backend. Si usa PagedRequest, adaptar.
    // Por ahora, asumimos que devuelve una lista o estructura similar.
    // Revisando catalogo.types: RespuestaUnidadesMedida tiene datos: UnidadMedida[] y total.

    const response: any = await apiCatalogo.get(
      `${BASE_URL}?${params.toString()}`,
    );
    return response;
  },

  crearUnidad: async (datos: UnidadMedidaFormData): Promise<UnidadMedida> => {
    const response: any = await apiCatalogo.post(BASE_URL, datos);
    return response.data;
  },

  actualizarUnidad: async (
    id: number,
    datos: UnidadMedidaFormData,
  ): Promise<UnidadMedida> => {
    const response: any = await apiCatalogo.put(`${BASE_URL}/${id}`, datos);
    return response.data;
  },

  eliminarUnidad: async (id: number): Promise<void> => {
    await apiCatalogo.delete(`${BASE_URL}/${id}`);
  },
};
