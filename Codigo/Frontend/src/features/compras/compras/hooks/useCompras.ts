import {
  useQuery,
  useMutation,
  useQueryClient,
  UseQueryResult,
  UseMutationResult,
} from "@tanstack/react-query";
import { CompraResumen, CompraDetalle, CrearCompraPayload } from "../types/compra.types";
import * as servicio from "../servicios/servicioCompras";
import { PagedRequest, PagedResponse } from "@/types/pagination.types";

const QUERY_KEY = ["compras"];

export const useCompras = (
  paginacion?: PagedRequest,
): UseQueryResult<PagedResponse<CompraResumen>, Error> => {
  return useQuery({
    queryKey: [...QUERY_KEY, "lista", paginacion],
    queryFn: () => servicio.obtenerCompras(paginacion),
  });
};

export const useCompra = (id: number): UseQueryResult<CompraDetalle, Error> => {
  return useQuery({
    queryKey: [...QUERY_KEY, "detalle", id],
    queryFn: () => servicio.obtenerCompra(id),
    enabled: !!id,
  });
};

export const useRegistrarCompra = (): UseMutationResult<
  CompraDetalle,
  Error,
  CrearCompraPayload
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: servicio.registrarCompra,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: QUERY_KEY });
      // También podríamos invalidar el stock si el backend lo actualiza inmediatamente
      queryClient.invalidateQueries({ queryKey: ["productos"] });
    },
  });
};

export const useConfirmarCompra = (): UseMutationResult<
  void,
  Error,
  number
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: servicio.confirmarCompra,
    onSuccess: (_, id) => {
      queryClient.invalidateQueries({ queryKey: QUERY_KEY });
      queryClient.invalidateQueries({ queryKey: [...QUERY_KEY, "detalle", id] });
    },
  });
};

export const useEliminarCompra = (): UseMutationResult<void, Error, number> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: servicio.eliminarCompra,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: QUERY_KEY });
      queryClient.invalidateQueries({ queryKey: ["productos"] });
    },
  });
};

/**
 * Hook para obtener el reporte de compras por proveedor
 */
export function useReporteComprasProveedor(
  fechaInicio?: string,
  fechaFin?: string,
  top: number = 10,
): UseQueryResult<any[], Error> {
  return useQuery({
    queryKey: [...QUERY_KEY, "reporte", "compras-proveedor", fechaInicio, fechaFin, top],
    queryFn: () => servicio.obtenerReporteComprasProveedor(fechaInicio, fechaFin, top),
  });
}
