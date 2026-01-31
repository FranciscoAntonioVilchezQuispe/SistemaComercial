import api from "@/lib/axios";
import { Almacen, AlmacenFormData } from "../types/almacen.types";

export const obtenerAlmacenes = async (): Promise<any> => {
  const respuesta = await api.get("/inventario/almacenes");
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
