import api from "@/lib/axios";
import { Cliente, ClienteFormData } from "../types/cliente.types";

export const obtenerClientes = async (): Promise<Cliente[]> => {
  const response: any = await api.get("/clientes");
  return response.datos || response.data || [];
};

export const obtenerCliente = async (id: number): Promise<Cliente> => {
  const response: any = await api.get(`/clientes/${id}`);
  return response.datos || response.data;
};

export const crearCliente = async (
  cliente: ClienteFormData,
): Promise<Cliente> => {
  const response: any = await api.post("/clientes", cliente);
  return response.datos || response.data;
};

export const actualizarCliente = async (
  id: number,
  cliente: ClienteFormData,
): Promise<Cliente> => {
  const response: any = await api.put(`/clientes/${id}`, cliente);
  return response.datos || response.data;
};

export const eliminarCliente = async (id: number): Promise<void> => {
  await api.delete(`/clientes/${id}`);
};
