import {
  useQuery,
  useMutation,
  useQueryClient,
  UseQueryResult,
  UseMutationResult,
} from "@tanstack/react-query";
import {
  obtenerClientes,
  obtenerCliente,
  crearCliente,
  actualizarCliente,
  eliminarCliente,
} from "../servicios/servicioClientes";
import { Cliente, ClienteFormData } from "../types/cliente.types";

export const useClientes = (): UseQueryResult<Cliente[], Error> => {
  return useQuery({
    queryKey: ["clientes"],
    queryFn: obtenerClientes,
  });
};

export const useCliente = (id: number): UseQueryResult<Cliente, Error> => {
  return useQuery({
    queryKey: ["clientes", id],
    queryFn: () => obtenerCliente(id),
    enabled: !!id,
  });
};

export const useCrearCliente = (): UseMutationResult<
  Cliente,
  Error,
  ClienteFormData
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: crearCliente,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["clientes"] });
    },
  });
};

export const useActualizarCliente = (): UseMutationResult<
  Cliente,
  Error,
  { id: number; data: ClienteFormData }
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ id, data }: { id: number; data: ClienteFormData }) =>
      actualizarCliente(id, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["clientes"] });
    },
  });
};

export const useEliminarCliente = (): UseMutationResult<
  void,
  Error,
  number
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: eliminarCliente,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["clientes"] });
    },
  });
};
