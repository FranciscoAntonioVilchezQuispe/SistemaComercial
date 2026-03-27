import {
  useQuery,
  useMutation,
  useQueryClient,
  UseQueryResult,
  UseMutationResult,
} from "@tanstack/react-query";
import { Proveedor, ProveedorFormData } from "../types/proveedor.types";
import * as servicio from "../servicios/servicioProveedores";

import { PagedRequest, PagedResponse } from "@/types/pagination.types";

export const useProveedores = (
  paginacion?: PagedRequest,
  enabled: boolean = true,
): UseQueryResult<PagedResponse<Proveedor>, Error> => {
  return useQuery({
    queryKey: ["proveedores", paginacion],
    queryFn: () => servicio.obtenerProveedores(paginacion),
    enabled: enabled,
  });
};

export const useProveedor = (id: number): UseQueryResult<Proveedor, Error> => {
  return useQuery({
    queryKey: ["proveedores", id],
    queryFn: () => servicio.obtenerProveedor(id),
    enabled: !!id,
  });
};

export const useCrearProveedor = (): UseMutationResult<
  Proveedor,
  Error,
  ProveedorFormData
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: servicio.crearProveedor,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["proveedores"] });
    },
  });
};

export const useActualizarProveedor = (): UseMutationResult<
  void,
  Error,
  { id: number; data: ProveedorFormData }
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ id, data }) => servicio.actualizarProveedor(id, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["proveedores"] });
    },
  });
};

export const useEliminarProveedor = (): UseMutationResult<
  void,
  Error,
  number
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: servicio.eliminarProveedor,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["proveedores"] });
    },
  });
};
