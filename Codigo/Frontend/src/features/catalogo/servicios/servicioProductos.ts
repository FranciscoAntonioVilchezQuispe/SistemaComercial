import { apiCatalogo } from "@/lib/axios";
import { ProductoResumen, ProductoDetalle, ProductoFormData } from "../tipos/catalogo.types";
import { PagedRequest, PagedResponse } from "@/types/pagination.types";

const BASE_URL = "/productos";

export const servicioProductos = {
  obtenerProductos: async (
    req?: PagedRequest,
  ): Promise<PagedResponse<ProductoResumen>> => {
    const params = new URLSearchParams();
    params.append("pageNumber", (req?.pageNumber || 1).toString());
    params.append("pageSize", (req?.pageSize || 10).toString());

    if (req?.search) params.append("search", req.search);
    if (req?.activo !== undefined && req?.activo !== null)
      params.append("activo", req.activo.toString());

    const response: any = await apiCatalogo.get(
      `${BASE_URL}?${params.toString()}`,
    );
    return response;
  },

  obtenerProductoPorId: async (id: number): Promise<ProductoDetalle> => {
    const response: any = await apiCatalogo.get(`${BASE_URL}/${id}`);
    return response.data;
  },

  crearProducto: async (datos: ProductoFormData): Promise<ProductoDetalle> => {
    const response: any = await apiCatalogo.post(BASE_URL, datos);
    return response.data; // ToReturn<T>
  },

  actualizarProducto: async (
    id: number,
    datos: ProductoFormData,
  ): Promise<ProductoDetalle> => {
    const response: any = await apiCatalogo.put(`${BASE_URL}/${id}`, datos);
    return response.data; // ToReturn<T>
  },

  eliminarProducto: async (id: number): Promise<void> => {
    await apiCatalogo.delete(`${BASE_URL}/${id}`);
  },

  actualizarStock: async (id: number, cantidad: number): Promise<ProductoDetalle> => {
    const response: any = await apiCatalogo.patch(`${BASE_URL}/${id}/stock`, {
      cantidad,
    });
    return response.data;
  },

  buscarPorCodigoBarras: async (
    codigoBarras: string,
  ): Promise<ProductoDetalle | null> => {
    const response: any = await apiCatalogo.get(
      `${BASE_URL}/codigo-barras/${codigoBarras}`,
    );
    return response.data;
  },
};
