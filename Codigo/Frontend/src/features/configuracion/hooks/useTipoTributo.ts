import {
  useQuery,
  useMutation,
  useQueryClient,
  UseQueryResult,
  UseMutationResult,
} from "@tanstack/react-query";
import { servicioTipoTributo } from "../servicios/servicioTipoTributo";
import { TipoTributo, TipoTributoFormData } from "../tipos/tipoTributo.types";
import { PagedRequest, PagedResponse } from "@/types/pagination.types";

export const useTiposTributo = (
  paginacion?: PagedRequest,
): UseQueryResult<PagedResponse<TipoTributo>, Error> => {
  return useQuery<PagedResponse<TipoTributo>, Error>({
    queryKey: ["tiposTributo", paginacion],
    queryFn: () => servicioTipoTributo.obtenerTodos(paginacion),
  });
};

export const useTipoTributo = (id: number): UseQueryResult<TipoTributo, Error> => {
  return useQuery<TipoTributo, Error>({
    queryKey: ["tiposTributo", id],
    queryFn: () => servicioTipoTributo.obtenerPorId(id),
    enabled: !!id,
  });
};

export const useCrearTipoTributo = (): UseMutationResult<
  TipoTributo,
  Error,
  TipoTributoFormData,
  unknown
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: servicioTipoTributo.crear,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["tiposTributo"] });
    },
  });
};

export const useActualizarTipoTributo = (): UseMutationResult<
  TipoTributo,
  Error,
  { id: number; datos: TipoTributoFormData },
  unknown
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ id, datos }) => servicioTipoTributo.actualizar(id, datos),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["tiposTributo"] });
    },
  });
};

export const useEliminarTipoTributo = (): UseMutationResult<
  void,
  Error,
  number,
  unknown
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: servicioTipoTributo.eliminar,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["tiposTributo"] });
    },
  });
};

export const useInicializarTipoTributo = (): UseMutationResult<
  void,
  Error,
  void,
  unknown
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: servicioTipoTributo.inicializar,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["tiposTributo"] });
    },
  });
};
