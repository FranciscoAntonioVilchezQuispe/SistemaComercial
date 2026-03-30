import api from "@/lib/axios";
import { CompraResumen, CompraDetalle, CrearCompraPayload } from "../types/compra.types";
import { PagedRequest, PagedResponse } from "@/types/pagination.types";

export const obtenerCompras = async (
  paginacion?: PagedRequest,
): Promise<PagedResponse<CompraResumen>> => {
  const params = paginacion || {};
  const respuesta: any = await api.get("/compras", { params });
  return respuesta;
};

export const obtenerCompra = async (id: number): Promise<CompraDetalle> => {
  const respuesta: any = await api.get(`/compras/${id}`);
  return respuesta.data || respuesta.datos;
};

export const registrarCompra = async (
  data: CrearCompraPayload,
): Promise<CompraDetalle> => {
  const respuesta: any = await api.post("/compras", data);
  return respuesta.data || respuesta.datos;
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

export const registrarNotaCreditoCompra = async (datos: any): Promise<any> => {
  const respuesta: any = await api.post("/compras/notas/credito", datos);
  return respuesta.datos || respuesta.data;
};

export const registrarNotaDebitoCompra = async (datos: any): Promise<any> => {
  const respuesta: any = await api.post("/compras/notas/debito", datos);
  return respuesta.datos || respuesta.data;
};
