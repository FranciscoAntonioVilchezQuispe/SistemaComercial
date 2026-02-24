import {
  useQuery,
  useMutation,
  useQueryClient,
  UseQueryResult,
  UseMutationResult,
} from "@tanstack/react-query";
import { servicioTipoOperacion } from "../servicios/servicioTipoOperacion";
import {
  TipoOperacionSunat,
  TipoOperacionSunatFormData,
} from "../tipos/tipoOperacion.types";

export const useTiposOperacion = (): UseQueryResult<
  TipoOperacionSunat[],
  Error
> => {
  return useQuery<TipoOperacionSunat[], Error>({
    queryKey: ["tipos-operacion-sunat"],
    queryFn: servicioTipoOperacion.obtenerTodos,
  });
};

export const useCrearTipoOperacion = (): UseMutationResult<
  TipoOperacionSunat,
  Error,
  TipoOperacionSunatFormData,
  unknown
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: servicioTipoOperacion.crear,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["tipos-operacion-sunat"] });
    },
  });
};

export const useActualizarTipoOperacion = (): UseMutationResult<
  TipoOperacionSunat,
  Error,
  { id: number; datos: TipoOperacionSunatFormData },
  unknown
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ id, datos }) => servicioTipoOperacion.actualizar(id, datos),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["tipos-operacion-sunat"] });
    },
  });
};

export const useEliminarTipoOperacion = (): UseMutationResult<
  void,
  Error,
  number,
  unknown
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: servicioTipoOperacion.eliminar,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["tipos-operacion-sunat"] });
    },
  });
};
