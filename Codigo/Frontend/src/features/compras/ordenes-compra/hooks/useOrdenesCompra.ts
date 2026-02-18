import {
  useQuery,
  useMutation,
  useQueryClient,
  UseQueryResult,
  UseMutationResult,
} from "@tanstack/react-query";
import {
  obtenerOrdenesCompra,
  obtenerOrdenCompra,
  registrarOrdenCompra,
  cambiarEstadoOrdenCompra,
  obtenerSiguienteNumero,
} from "../servicios/ordenCompraService";
import { OrdenCompra, OrdenCompraFormData } from "../types/ordenCompra.types";

export const useOrdenesCompra = (): UseQueryResult<OrdenCompra[], Error> => {
  return useQuery({
    queryKey: ["ordenes-compra"],
    queryFn: obtenerOrdenesCompra,
  });
};

export const useSiguienteNumeroOrdenCompra = (): UseQueryResult<
  string,
  Error
> => {
  return useQuery({
    queryKey: ["ordenes-compra", "siguiente-numero"],
    queryFn: obtenerSiguienteNumero,
    staleTime: 0, // Siempre obtener el más reciente al abrir el form
  });
};

export const useOrdenCompra = (
  id: number,
): UseQueryResult<OrdenCompra, Error> => {
  return useQuery({
    queryKey: ["ordenes-compra", id],
    queryFn: () => obtenerOrdenCompra(id),
    enabled: !!id,
  });
};

export const useRegistrarOrdenCompra = (): UseMutationResult<
  OrdenCompra,
  Error,
  OrdenCompraFormData
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (data: OrdenCompraFormData) => registrarOrdenCompra(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["ordenes-compra"] });
    },
  });
};

export const useCambiarEstadoOrdenCompra = (): UseMutationResult<
  void,
  Error,
  { id: number; idEstado: number }
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ id, idEstado }: { id: number; idEstado: number }) =>
      cambiarEstadoOrdenCompra(id, idEstado),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["ordenes-compra"] });
    },
  });
};
