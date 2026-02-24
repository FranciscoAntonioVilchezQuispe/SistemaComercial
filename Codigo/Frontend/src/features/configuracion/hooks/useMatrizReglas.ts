import {
  useQuery,
  useMutation,
  useQueryClient,
  UseQueryResult,
  UseMutationResult,
} from "@tanstack/react-query";
import { servicioMatrizRegla } from "../servicios/servicioMatrizRegla";
import {
  MatrizReglaSunat,
  MatrizReglaSunatFormData,
} from "../tipos/matrizRegla.types";

export const useMatrizReglas = (): UseQueryResult<
  MatrizReglaSunat[],
  Error
> => {
  return useQuery<MatrizReglaSunat[], Error>({
    queryKey: ["matriz-reglas-sunat"],
    queryFn: servicioMatrizRegla.obtenerTodas,
  });
};

export const useCrearMatrizRegla = (): UseMutationResult<
  MatrizReglaSunat,
  Error,
  MatrizReglaSunatFormData,
  unknown
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: servicioMatrizRegla.crear,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["matriz-reglas-sunat"] });
    },
  });
};

export const useActualizarMatrizRegla = (): UseMutationResult<
  MatrizReglaSunat,
  Error,
  { id: number; datos: MatrizReglaSunatFormData },
  unknown
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ id, datos }) => servicioMatrizRegla.actualizar(id, datos),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["matriz-reglas-sunat"] });
    },
  });
};

export const useEliminarMatrizRegla = (): UseMutationResult<
  void,
  Error,
  number,
  unknown
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: servicioMatrizRegla.eliminar,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["matriz-reglas-sunat"] });
    },
  });
};
