import {
  useQuery,
  useMutation,
  useQueryClient,
  UseQueryResult,
  UseMutationResult,
} from "@tanstack/react-query";
import { servicioAfectacionIgv } from "../servicios/servicioAfectacionIgv";
import { AfectacionIgv, AfectacionIgvFormData } from "../tipos/afectacionIgv.types";
import { PagedRequest, PagedResponse } from "@/types/pagination.types";

export const useAfectacionesIgv = (
  paginacion?: PagedRequest,
): UseQueryResult<PagedResponse<AfectacionIgv>, Error> => {
  return useQuery<PagedResponse<AfectacionIgv>, Error>({
    queryKey: ["afectacionesIgv", paginacion],
    queryFn: () => servicioAfectacionIgv.obtenerTodos(paginacion),
  });
};

export const useAfectacionIgv = (id: number): UseQueryResult<AfectacionIgv, Error> => {
  return useQuery<AfectacionIgv, Error>({
    queryKey: ["afectacionesIgv", id],
    queryFn: () => servicioAfectacionIgv.obtenerPorId(id),
    enabled: !!id,
  });
};

export const useCrearAfectacionIgv = (): UseMutationResult<
  AfectacionIgv,
  Error,
  AfectacionIgvFormData,
  unknown
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: servicioAfectacionIgv.crear,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["afectacionesIgv"] });
    },
  });
};

export const useActualizarAfectacionIgv = (): UseMutationResult<
  AfectacionIgv,
  Error,
  { id: number; datos: AfectacionIgvFormData },
  unknown
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ id, datos }) => servicioAfectacionIgv.actualizar(id, datos),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["afectacionesIgv"] });
    },
  });
};

export const useEliminarAfectacionIgv = (): UseMutationResult<
  void,
  Error,
  number,
  unknown
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: servicioAfectacionIgv.eliminar,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["afectacionesIgv"] });
    },
  });
};

export const useInicializarAfectacionIgv = (): UseMutationResult<
  void,
  Error,
  void,
  unknown
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: servicioAfectacionIgv.inicializar,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["afectacionesIgv"] });
    },
  });
};
