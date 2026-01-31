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
} from "../tipos/inventario.types";
import { toast } from "sonner";

export const useStock = (
  filtros: InventarioFiltros = {},
): UseQueryResult<{ datos: StockProducto[]; total: number }, Error> => {
  return useQuery({
    queryKey: ["inventario", "stock", filtros],
    queryFn: () => servicioInventario.obtenerStock(filtros),
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
  filtros: MovimientoFiltros = {},
  pagina: number = 1,
  limite: number = 10,
): UseQueryResult<{ datos: MovimientoInventario[]; total: number }, Error> => {
  return useQuery({
    queryKey: ["inventario", "movimientos", filtros, pagina, limite],
    queryFn: () =>
      servicioInventario.obtenerMovimientos(filtros, pagina, limite),
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

export const useAlmacenes = (): UseQueryResult<
  { id: number; nombre: string }[],
  Error
> => {
  return useQuery({
    queryKey: ["inventario", "catalogos", "almacenes"],
    queryFn: () => servicioInventario.obtenerAlmacenes(),
    staleTime: 1000 * 60 * 60, // 1 hora
  });
};
