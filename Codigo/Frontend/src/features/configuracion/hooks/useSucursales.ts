import {
  useQuery,
  useMutation,
  useQueryClient,
  UseQueryResult,
  UseMutationResult,
} from "@tanstack/react-query";
import { servicioSucursal } from "../servicios/servicioSucursal";
import { Sucursal, SucursalFormData } from "../tipos/sucursal.types";

export const useSucursales = (): UseQueryResult<Sucursal[], Error> => {
  return useQuery<Sucursal[], Error>({
    queryKey: ["sucursales"],
    queryFn: servicioSucursal.obtenerTodas,
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
