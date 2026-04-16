import {
  useQuery,
  useMutation,
  useQueryClient,
  UseQueryResult,
  UseMutationResult,
} from "@tanstack/react-query";
import { servicioInventario } from "../servicios/servicioInventario";
import {
  InventarioFiltros,
  MovimientoFiltros,
  RegistroMovimientoDTO,
  AjusteStockDTO,
  StockProducto,
  MovimientoResumen,
  MovimientoDetalle,
  KardexProducto,
  Traslado,
} from "../tipos/inventario.types";
import { Almacen } from "../almacenes/types/almacen.types";
import { PagedRequest, PagedResponse } from "@/types/pagination.types";
import { toast } from "sonner";

export const useStock = (
  paginacion?: PagedRequest,
  filtros: InventarioFiltros = {},
): UseQueryResult<PagedResponse<StockProducto>, Error> => {
  return useQuery({
    queryKey: ["inventario", "stock", paginacion, filtros],
    queryFn: () => servicioInventario.obtenerStock(paginacion, filtros),
  });
};

export const useReporteStockCritico = (
  paginacion?: PagedRequest,
  idAlmacen?: number,
): UseQueryResult<PagedResponse<any>, Error> => {
  return useQuery({
    queryKey: ["inventario", "reporte", "stock-critico", paginacion, idAlmacen],
    queryFn: () => servicioInventario.obtenerReporteStockCritico(paginacion, idAlmacen),
  });
};

export const useStockProducto = (
  idProducto: number,
): UseQueryResult<StockProducto[], Error> => {
  return useQuery({
    queryKey: ["inventario", "stock", "producto", idProducto],
    queryFn: () => servicioInventario.obtenerStockPorProducto(idProducto),
    enabled: !!idProducto,
  });
};

export const useMovimientos = (
  paginacion?: PagedRequest,
  filtros: MovimientoFiltros = {},
): UseQueryResult<PagedResponse<MovimientoResumen>, Error> => {
  return useQuery({
    queryKey: ["inventario", "movimientos", paginacion, filtros],
    queryFn: () => servicioInventario.obtenerMovimientos(paginacion, filtros),
  });
};

/**
 * Hook para obtener el detalle de un movimiento por ID
 */
export const useMovimiento = (id: number): UseQueryResult<MovimientoDetalle, Error> => {
  return useQuery({
    queryKey: ["inventario", "movimientos", id],
    queryFn: () => servicioInventario.obtenerMovimientoPorId(id),
    enabled: !!id,
  });
};

export const useRegistrarMovimiento = (): UseMutationResult<
  MovimientoDetalle,
  Error,
  RegistroMovimientoDTO
> => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (movimiento: RegistroMovimientoDTO) =>
      servicioInventario.registrarMovimiento(movimiento),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["inventario"] });
      toast.success("Movimiento registrado correctamente");
    },
    onError: (error: any) => {
      console.error("Error al registrar el movimiento:", error);
    },
  });
};

export const useAjustarStock = (): UseMutationResult<
  any,
  Error,
  AjusteStockDTO
> => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (ajuste: AjusteStockDTO) =>
      servicioInventario.ajustarStock(ajuste),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["inventario", "stock"] });
      toast.success("Ajuste de stock realizado correctamente");
    },
    onError: (error: any) => {
      console.error("Error al realizar el ajuste:", error);
    },
  });
};

export const useKardex = (
  idProducto: number,
  idAlmacen: number,
  fechaInicio: string,
  fechaFin: string,
): UseQueryResult<KardexProducto, Error> => {
  return useQuery({
    queryKey: [
      "inventario",
      "kardex",
      idProducto,
      idAlmacen,
      fechaInicio,
      fechaFin,
    ],
    queryFn: () =>
      servicioInventario.obtenerKardex(
        idProducto,
        idAlmacen,
        fechaInicio,
        fechaFin,
      ),
    enabled: !!idProducto && !!idAlmacen && !!fechaInicio && !!fechaFin,
  });
};

export const useTiposMovimiento = (): UseQueryResult<
  { id: number; nombre: string }[],
  Error
> => {
  return useQuery({
    queryKey: ["inventario", "catalogos", "tipos-movimiento"],
    queryFn: () => servicioInventario.obtenerTiposMovimiento(),
    staleTime: 1000 * 60 * 60, // 1 hora
  });
};

export const useTraslados = (
  paginacion?: PagedRequest,
): UseQueryResult<PagedResponse<Traslado>, Error> => {
  return useQuery({
    queryKey: ["inventario", "traslados", paginacion],
    queryFn: () => servicioInventario.obtenerTraslados(paginacion),
  });
};

export const useAlmacenes = (
  paginacion?: PagedRequest,
): UseQueryResult<PagedResponse<Almacen>, Error> => {
  return useQuery({
    queryKey: ["inventario", "almacenes", paginacion],
    queryFn: () => servicioInventario.obtenerAlmacenes(paginacion),
  });
};

export const useListaAlmacenes = (): UseQueryResult<Almacen[], Error> => {
  return useQuery({
    queryKey: ["inventario", "catalogos", "almacenes"],
    queryFn: async () => {
      const resp = await servicioInventario.obtenerAlmacenes({
        pageNumber: 1,
        pageSize: 1000,
      });
      return resp.datos;
    },
    staleTime: 1000 * 60 * 60, // 1 hora
  });
};
