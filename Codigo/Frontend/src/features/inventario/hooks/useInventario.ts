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
  MovimientoInventario,
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
): UseQueryResult<PagedResponse<MovimientoInventario>, Error> => {
  return useQuery({
    queryKey: ["inventario", "movimientos", paginacion, filtros],
    queryFn: () => servicioInventario.obtenerMovimientos(paginacion, filtros),
  });
};

export const useRegistrarMovimiento = (): UseMutationResult<
  MovimientoInventario,
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
      toast.error(
        error.response?.data?.mensaje || "Error al registrar el movimiento",
      );
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
      toast.error(
        error.response?.data?.mensaje || "Error al realizar el ajuste",
      );
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
