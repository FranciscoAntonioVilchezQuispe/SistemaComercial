import { apiCatalogo } from "@/lib/axios";
import {
  Categoria,
  CategoriaFormData,
  RespuestaCategorias,
} from "../tipos/catalogo.types";

const BASE_URL = "/categorias";

export const servicioCategorias = {
  obtenerCategorias: async (
    pageNumber: number = 1,
    pageSize: number = 10,
    search: string = "",
    activo: boolean | null = null,
  ): Promise<RespuestaCategorias> => {
    const params = new URLSearchParams({
      pageNumber: pageNumber.toString(),
      pageSize: pageSize.toString(),
      search,
    });

    if (activo !== null) {
      params.append("activo", activo.toString());
    }

    const response: any = await apiCatalogo.get(
      `${BASE_URL}?${params.toString()}`,
    );
    return response;
  },

  obtenerCategoriasJerarquicas: async (): Promise<Categoria[]> => {
    const response: any = await apiCatalogo.get(`${BASE_URL}/jerarquicas`);
    return response.data;
  },

  obtenerCategoriaPorId: async (id: number): Promise<Categoria> => {
    const response: any = await apiCatalogo.get(`${BASE_URL}/${id}`);
    return response.data;
  },

  crearCategoria: async (datos: CategoriaFormData): Promise<Categoria> => {
    const response: any = await apiCatalogo.post(BASE_URL, datos);
    return response.data;
  },

  actualizarCategoria: async (
    id: number,
    datos: CategoriaFormData,
  ): Promise<Categoria> => {
    const response: any = await apiCatalogo.put(`${BASE_URL}/${id}`, datos);
    return response.data;
  },

  eliminarCategoria: async (id: number): Promise<void> => {
    await apiCatalogo.delete(`${BASE_URL}/${id}`);
  },
};
