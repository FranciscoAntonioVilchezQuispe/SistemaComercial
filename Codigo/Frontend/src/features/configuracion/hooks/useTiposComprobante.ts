import {
  useQuery,
  useMutation,
  useQueryClient,
  UseQueryResult,
  UseMutationResult,
} from "@tanstack/react-query";
import { servicioTipoComprobante } from "../servicios/servicioTipoComprobante";
import {
  TipoComprobante,
  TipoComprobanteFormData,
} from "../tipos/tipoComprobante.types";

export const useTiposComprobante = (): UseQueryResult<
  TipoComprobante[],
  Error
> => {
  return useQuery<TipoComprobante[], Error>({
    queryKey: ["tipos-comprobante"],
    queryFn: servicioTipoComprobante.obtenerTodos,
  });
};

export const useCrearTipoComprobante = (): UseMutationResult<
  TipoComprobante,
  Error,
  TipoComprobanteFormData,
  unknown
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: servicioTipoComprobante.crear,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["tipos-comprobante"] });
    },
  });
};

export const useActualizarTipoComprobante = (): UseMutationResult<
  TipoComprobante,
  Error,
  { id: number; datos: TipoComprobanteFormData },
  unknown
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ id, datos }) =>
      servicioTipoComprobante.actualizar(id, datos),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["tipos-comprobante"] });
    },
  });
};

export const useEliminarTipoComprobante = (): UseMutationResult<
  void,
  Error,
  number,
  unknown
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: servicioTipoComprobante.eliminar,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["tipos-comprobante"] });
    },
  });
};
