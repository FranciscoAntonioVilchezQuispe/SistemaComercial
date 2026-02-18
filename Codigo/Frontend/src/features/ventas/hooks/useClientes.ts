import {
  useQuery,
  useMutation,
  useQueryClient,
  UseQueryResult,
  UseMutationResult,
} from "@tanstack/react-query";
import { toast } from "sonner";
import { servicioClientes } from "../servicios/servicioClientes";
import {
  Cliente,
  ClienteFormData,
  ClienteFiltros,
  RespuestaClientes,
} from "../tipos/ventas.types";
import { manejadorErrores } from "@/lib/axios/manejadorErrores";

const QUERY_KEY = "clientes";

/**
 * Hook para obtener lista de clientes con filtros
 */
export function useClientes(
  filtros?: ClienteFiltros,
  pagina: number = 1,
  elementosPorPagina: number = 10,
  enabled: boolean = true,
): UseQueryResult<RespuestaClientes, Error> {
  return useQuery({
    queryKey: [QUERY_KEY, filtros, pagina, elementosPorPagina],
    queryFn: () =>
      servicioClientes.obtenerClientes(filtros, pagina, elementosPorPagina),
    enabled: enabled,
  });
}

/**
 * Hook para obtener un cliente por ID
 */
export function useCliente(id: number): UseQueryResult<Cliente, Error> {
  return useQuery({
    queryKey: [QUERY_KEY, id],
    queryFn: () => servicioClientes.obtenerClientePorId(id),
    enabled: !!id,
  });
}

/**
 * Hook para buscar cliente por documento
 */
export function useBuscarClientePorDocumento(
  numeroDocumento: string,
): UseQueryResult<Cliente | null, Error> {
  return useQuery({
    queryKey: [QUERY_KEY, "documento", numeroDocumento],
    queryFn: () => servicioClientes.buscarPorDocumento(numeroDocumento),
    enabled: !!numeroDocumento && numeroDocumento.length >= 8,
  });
}

/**
 * Hook para crear un cliente
 */
export function useCrearCliente(): UseMutationResult<
  Cliente,
  Error,
  ClienteFormData
> {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (datos: ClienteFormData) =>
      servicioClientes.crearCliente(datos),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: [QUERY_KEY] });
      toast.success("Cliente creado exitosamente");
    },
    onError: (error) => {
      manejadorErrores(error);
    },
  });
}

/**
 * Hook para actualizar un cliente
 */
export function useActualizarCliente(): UseMutationResult<
  Cliente,
  Error,
  { id: number; datos: ClienteFormData }
> {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ id, datos }: { id: number; datos: ClienteFormData }) =>
      servicioClientes.actualizarCliente(id, datos),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: [QUERY_KEY] });
      toast.success("Cliente actualizado exitosamente");
    },
    onError: (error) => {
      manejadorErrores(error);
    },
  });
}

/**
 * Hook para eliminar un cliente
 */
export function useEliminarCliente(): UseMutationResult<void, Error, number> {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (id: number) => servicioClientes.eliminarCliente(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: [QUERY_KEY] });
      toast.success("Cliente eliminado exitosamente");
    },
    onError: (error) => {
      manejadorErrores(error);
    },
  });
}

/**
 * Hook para obtener historial de compras
 */
export function useHistorialCompras(
  idCliente: number,
): UseQueryResult<any, Error> {
  return useQuery({
    queryKey: [QUERY_KEY, idCliente, "historial"],
    queryFn: () => servicioClientes.obtenerHistorialCompras(idCliente),
    enabled: !!idCliente,
  });
}
