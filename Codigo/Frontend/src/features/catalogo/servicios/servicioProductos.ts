import { apiCatalogo } from "@/lib/axios";
import { Producto, ProductoFormData } from "../tipos/catalogo.types";

import { PagedRequest, PagedResponse } from "@/types/pagination.types";

const BASE_URL = "/productos";

export const servicioProductos = {
  obtenerProductos: async (
    req?: PagedRequest,
  ): Promise<PagedResponse<Producto>> => {
    const params = new URLSearchParams();
    if (req?.pageNumber) params.append("pageNumber", req.pageNumber.toString());
    if (req?.pageSize) params.append("pageSize", req.pageSize.toString());
    if (req?.search) params.append("search", req.search);
    if (req?.activo !== undefined && req?.activo !== null)
      params.append("activo", req.activo.toString());

    const response: any = await apiCatalogo.get(
      `${BASE_URL}?${params.toString()}`,
    );
    return response;
  },

  obtenerProductoPorId: async (id: number): Promise<Producto> => {
    const response: any = await apiCatalogo.get(`${BASE_URL}/${id}`);
    return response.data;
  },

  crearProducto: async (datos: ProductoFormData): Promise<Producto> => {
    const response: any = await apiCatalogo.post(BASE_URL, datos);
    return response.data;
  },

  actualizarProducto: async (
    id: number,
    datos: ProductoFormData,
  ): Promise<Producto> => {
    const response: any = await apiCatalogo.put(`${BASE_URL}/${id}`, datos);
    return response.data;
  },

  eliminarProducto: async (id: number): Promise<void> => {
    await apiCatalogo.delete(`${BASE_URL}/${id}`);
  },

  actualizarStock: async (id: number, cantidad: number): Promise<Producto> => {
    const response: any = await apiCatalogo.patch(`${BASE_URL}/${id}/stock`, {
      cantidad,
    });
    return response.data;
  },

  buscarPorCodigoBarras: async (
    codigoBarras: string,
  ): Promise<Producto | null> => {
    const response: any = await apiCatalogo.get(
      `${BASE_URL}/codigo-barras/${codigoBarras}`,
    );
    return response.data;
  },
};
