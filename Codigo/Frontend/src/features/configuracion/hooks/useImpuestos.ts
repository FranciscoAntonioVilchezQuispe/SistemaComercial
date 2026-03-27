import {
  useQuery,
  useMutation,
  useQueryClient,
  UseQueryResult,
  UseMutationResult,
} from "@tanstack/react-query";
import { servicioImpuesto } from "../servicios/servicioImpuesto";
import { Impuesto, ImpuestoFormData } from "../tipos/impuesto.types";

import { PagedRequest, PagedResponse } from "@/types/pagination.types";

export const useImpuestos = (
  paginacion?: PagedRequest,
): UseQueryResult<PagedResponse<Impuesto>, Error> => {
  return useQuery<PagedResponse<Impuesto>, Error>({
    queryKey: ["impuestos", paginacion],
    queryFn: () => servicioImpuesto.obtenerTodos(paginacion),
  });
};

export const useImpuesto = (id: number): UseQueryResult<Impuesto, Error> => {
  return useQuery<Impuesto, Error>({
    queryKey: ["impuestos", id],
    queryFn: () => servicioImpuesto.obtenerPorId(id),
    enabled: !!id,
  });
};

export const useCrearImpuesto = (): UseMutationResult<
  Impuesto,
  Error,
  ImpuestoFormData,
  unknown
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: servicioImpuesto.crear,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["impuestos"] });
    },
  });
};

export const useActualizarImpuesto = (): UseMutationResult<
  Impuesto,
  Error,
  { id: number; datos: ImpuestoFormData },
  unknown
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ id, datos }) => servicioImpuesto.actualizar(id, datos),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["impuestos"] });
    },
  });
};

export const useEliminarImpuesto = (): UseMutationResult<
  void,
  Error,
  number,
  unknown
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: servicioImpuesto.eliminar,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["impuestos"] });
    },
  });
};
