import api from "@/lib/axios";
import { Almacen, AlmacenFormData } from "../types/almacen.types";
import { PagedRequest, PagedResponse } from "@/types/pagination.types";

export const obtenerAlmacenes = async (
  paginacion?: PagedRequest,
): Promise<PagedResponse<Almacen>> => {
  const params = paginacion || {};
  const respuesta: any = await api.get("/inventario/almacenes", { params });
  return respuesta;
};

export const obtenerAlmacen = async (id: number): Promise<Almacen> => {
  const respuesta = await api.get(`/inventario/almacenes/${id}`);
  return respuesta.data;
};

export const crearAlmacen = async (data: AlmacenFormData): Promise<Almacen> => {
  const respuesta = await api.post("/inventario/almacenes", data);
  return respuesta.data;
};

export const actualizarAlmacen = async (
  id: number,
  data: AlmacenFormData,
): Promise<void> => {
  await api.put(`/inventario/almacenes/${id}`, data);
};

export const eliminarAlmacen = async (id: number): Promise<void> => {
  await api.delete(`/inventario/almacenes/${id}`);
};
