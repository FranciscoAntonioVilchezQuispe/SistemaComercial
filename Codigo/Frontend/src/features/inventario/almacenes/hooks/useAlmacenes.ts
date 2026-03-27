import {
  useQuery,
  useMutation,
  useQueryClient,
  UseQueryResult,
  UseMutationResult,
} from "@tanstack/react-query";
import { Almacen, AlmacenFormData } from "../types/almacen.types";
import * as servicio from "../servicios/servicioAlmacenes";
import { PagedRequest, PagedResponse } from "@/types/pagination.types";

export const useAlmacenes = (
  paginacion?: PagedRequest,
): UseQueryResult<PagedResponse<Almacen>, Error> => {
  return useQuery({
    queryKey: ["almacenes", paginacion],
    queryFn: () => servicio.obtenerAlmacenes(paginacion),
  });
};

export const useAlmacen = (id: number): UseQueryResult<Almacen, Error> => {
  return useQuery({
    queryKey: ["almacenes", id],
    queryFn: () => servicio.obtenerAlmacen(id),
    enabled: !!id,
  });
};

export const useCrearAlmacen = (): UseMutationResult<
  Almacen,
  Error,
  AlmacenFormData
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: servicio.crearAlmacen,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["almacenes"] });
    },
  });
};

export const useActualizarAlmacen = (): UseMutationResult<
  void,
  Error,
  { id: number; data: AlmacenFormData }
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ id, data }) => servicio.actualizarAlmacen(id, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["almacenes"] });
    },
  });
};

export const useEliminarAlmacen = (): UseMutationResult<
  void,
  Error,
  number
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: servicio.eliminarAlmacen,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["almacenes"] });
    },
  });
};
