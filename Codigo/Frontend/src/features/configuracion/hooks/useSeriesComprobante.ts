import {
  useQuery,
  useMutation,
  useQueryClient,
  UseQueryResult,
  UseMutationResult,
} from "@tanstack/react-query";
import { servicioSerieComprobante } from "../servicios/servicioSerieComprobante";
import {
  SerieComprobante,
  SerieComprobanteFormData,
} from "../tipos/serieComprobante.types";

export const useSeriesComprobante = (): UseQueryResult<
  SerieComprobante[],
  Error
> => {
  return useQuery<SerieComprobante[], Error>({
    queryKey: ["series"],
    queryFn: servicioSerieComprobante.obtenerTodas,
  });
};

export const useSeriesPorTipo = (
  idTipo: number | null,
): UseQueryResult<SerieComprobante[], Error> => {
  return useQuery<SerieComprobante[], Error>({
    queryKey: ["series", "tipo", idTipo],
    queryFn: () => servicioSerieComprobante.obtenerPorTipo(idTipo!),
    enabled: !!idTipo,
  });
};

export const useCrearSerieComprobante = (): UseMutationResult<
  SerieComprobante,
  Error,
  SerieComprobanteFormData,
  unknown
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: servicioSerieComprobante.crear,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["series"] });
    },
  });
};

export const useActualizarSerieComprobante = (): UseMutationResult<
  SerieComprobante,
  Error,
  { id: number; datos: SerieComprobanteFormData },
  unknown
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ id, datos }) =>
      servicioSerieComprobante.actualizar(id, datos),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["series"] });
    },
  });
};

export const useEliminarSerieComprobante = (): UseMutationResult<
  void,
  Error,
  number,
  unknown
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: servicioSerieComprobante.eliminar,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["series"] });
    },
  });
};
