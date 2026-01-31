import api from "@/lib/axios";
import { Proveedor, ProveedorFormData } from "../types/proveedor.types";

export const obtenerProveedores = async (): Promise<Proveedor[]> => {
  const respuesta = await api.get("/compras/proveedores");
  return respuesta.data;
};

export const obtenerProveedor = async (id: number): Promise<Proveedor> => {
  const respuesta = await api.get(`/compras/proveedores/${id}`);
  return respuesta.data;
};

export const crearProveedor = async (
  data: ProveedorFormData,
): Promise<Proveedor> => {
  const respuesta = await api.post("/compras/proveedores", data);
  return respuesta.data;
};

export const actualizarProveedor = async (
  id: number,
  data: ProveedorFormData,
): Promise<void> => {
  await api.put(`/compras/proveedores/${id}`, data);
};

export const eliminarProveedor = async (id: number): Promise<void> => {
  await api.delete(`/compras/proveedores/${id}`);
};
