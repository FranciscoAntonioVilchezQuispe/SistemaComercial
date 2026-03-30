import api from "@/lib/axios";
import { ClienteResumen, ClienteDetalle, ClienteFormData } from "../types/cliente.types";
import { PagedRequest, PagedResponse } from "@/types/pagination.types";

export const obtenerClientes = async (
  params?: PagedRequest,
): Promise<PagedResponse<ClienteResumen>> => {
  const response: any = await api.get("/clientes", { params });
  return response;
};

export const obtenerCliente = async (id: number): Promise<ClienteDetalle> => {
  const response: any = await api.get(`/clientes/${id}`);
  return response.data || response.datos;
};

export const crearCliente = async (
  cliente: ClienteFormData,
): Promise<ClienteDetalle> => {
  const response: any = await api.post("/clientes", cliente);
  return response.data || response.datos;
};

export const actualizarCliente = async (
  id: number,
  cliente: ClienteFormData,
): Promise<ClienteDetalle> => {
  const response: any = await api.put(`/clientes/${id}`, cliente);
  return response.data || response.datos;
};

export const eliminarCliente = async (id: number): Promise<void> => {
  await api.delete(`/clientes/${id}`);
};
