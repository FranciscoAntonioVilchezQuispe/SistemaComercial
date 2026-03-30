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
import { ClienteResumen, ClienteDetalle, ClienteFormData } from "../types/cliente.types";
import { PagedRequest, PagedResponse } from "@/types/pagination.types";

const QUERY_KEY = ["clientes"];

export const useClientes = (
  paginacion?: PagedRequest,
  enabled: boolean = true,
): UseQueryResult<PagedResponse<ClienteResumen>, Error> => {
  return useQuery({
    queryKey: [...QUERY_KEY, "lista", paginacion],
    queryFn: () => obtenerClientes(paginacion),
    enabled: enabled,
  });
};

export const useCliente = (id: number): UseQueryResult<ClienteDetalle, Error> => {
  return useQuery({
    queryKey: [...QUERY_KEY, "detalle", id],
    queryFn: () => obtenerCliente(id),
    enabled: !!id,
  });
};

export const useCrearCliente = (): UseMutationResult<
  ClienteDetalle,
  Error,
  ClienteFormData
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: crearCliente,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: QUERY_KEY });
    },
  });
};

export const useActualizarCliente = (): UseMutationResult<
  ClienteDetalle,
  Error,
  { id: number; data: ClienteFormData }
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ id, data }: { id: number; data: ClienteFormData }) =>
      actualizarCliente(id, data),
    onSuccess: (_, { id }) => {
      queryClient.invalidateQueries({ queryKey: QUERY_KEY });
      queryClient.invalidateQueries({ queryKey: [...QUERY_KEY, "detalle", id] });
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
      queryClient.invalidateQueries({ queryKey: QUERY_KEY });
    },
  });
};
