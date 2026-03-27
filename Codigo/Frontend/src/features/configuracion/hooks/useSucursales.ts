import {
  useQuery,
  useMutation,
  useQueryClient,
  UseQueryResult,
  UseMutationResult,
} from "@tanstack/react-query";
import { servicioSucursal } from "../servicios/servicioSucursal";
import { Sucursal, SucursalFormData } from "../tipos/sucursal.types";

import { PagedRequest, PagedResponse } from "@/types/pagination.types";

export const useSucursales = (
  paginacion?: PagedRequest,
): UseQueryResult<PagedResponse<Sucursal>, Error> => {
  return useQuery<PagedResponse<Sucursal>, Error>({
    queryKey: ["sucursales", paginacion],
    queryFn: () => servicioSucursal.obtenerTodas(paginacion),
  });
};

export const useCrearSucursal = (): UseMutationResult<
  Sucursal,
  Error,
  SucursalFormData,
  unknown
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: servicioSucursal.crear,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["sucursales"] });
    },
  });
};

export const useActualizarSucursal = (): UseMutationResult<
  Sucursal,
  Error,
  { id: number; datos: SucursalFormData },
  unknown
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ id, datos }) => servicioSucursal.actualizar(id, datos),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["sucursales"] });
    },
  });
};

export const useEliminarSucursal = (): UseMutationResult<
  void,
  Error,
  number,
  unknown
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: servicioSucursal.eliminar,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["sucursales"] });
    },
  });
};
