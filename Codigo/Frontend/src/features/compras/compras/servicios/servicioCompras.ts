import api from "@/lib/axios";
import { Compra, CrearCompraPayload } from "../types/compra.types";
import { PagedRequest, PagedResponse } from "@/types/pagination.types";

export const obtenerCompras = async (
  paginacion?: PagedRequest,
): Promise<PagedResponse<Compra>> => {
  const params = paginacion || {};
  const respuesta: any = await api.get("/compras", { params });
  return respuesta;
};

export const obtenerCompra = async (id: number): Promise<Compra> => {
  const respuesta: any = await api.get(`/compras/${id}`);
  return respuesta.datos || respuesta.data;
};

export const registrarCompra = async (
  data: CrearCompraPayload,
): Promise<Compra> => {
  const respuesta: any = await api.post("/compras", data);
  return respuesta.datos || respuesta.data;
};

export const confirmarCompra = async (id: number): Promise<void> => {
  await api.post(`/compras/${id}/confirmar`);
};

export const anularCompra = async (id: number): Promise<void> => {
  await api.post(`/compras/${id}/anular`);
};

export const eliminarCompra = async (id: number): Promise<void> => {
  await api.delete(`/compras/${id}`);
};
