import { apiCatalogo } from "@/lib/axios";
import { Marca, MarcaFormData } from "../tipos/catalogo.types";
import { PagedRequest, PagedResponse } from "@/types/pagination.types";

const BASE_URL = "/marcas";

export const servicioMarcas = {
  obtenerMarcas: async (req?: PagedRequest): Promise<PagedResponse<Marca>> => {
    const params = new URLSearchParams();
    if (req?.pageNumber) params.append("pageNumber", req.pageNumber.toString());
    if (req?.pageSize) params.append("pageSize", req.pageSize.toString());
    if (req?.search) params.append("search", req.search);
    if (req?.activo !== undefined && req?.activo !== null)
      params.append("activo", req.activo.toString());
    console.log(params.toString());
    const response: any = await apiCatalogo.get(
      `${BASE_URL}?${params.toString()}`,
    );
    return response;
  },

  obtenerMarcaPorId: async (id: number): Promise<Marca> => {
    const response: any = await apiCatalogo.get(`${BASE_URL}/${id}`);
    return response.data;
  },

  crearMarca: async (datos: MarcaFormData): Promise<Marca> => {
    const response: any = await apiCatalogo.post(BASE_URL, datos);
    return response.data;
  },

  actualizarMarca: async (id: number, datos: MarcaFormData): Promise<Marca> => {
    const response: any = await apiCatalogo.put(`${BASE_URL}/${id}`, datos);
    return response.data;
  },

  eliminarMarca: async (id: number): Promise<void> => {
    await apiCatalogo.delete(`${BASE_URL}/${id}`);
  },
};
