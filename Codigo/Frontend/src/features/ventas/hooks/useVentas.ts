import { useQuery, useMutation, useQueryClient, UseQueryResult } from "@tanstack/react-query";
import { toast } from "sonner";
import { servicioVentas } from "../servicios/servicioVentas";
import { VentaFormData, Venta } from "../tipos/ventas.types";
import { manejadorErrores } from "@/lib/axios/manejadorErrores";
import { PagedRequest, PagedResponse } from "@/types/pagination.types";

const QUERY_KEY = "ventas";

/**
 * Hook para obtener lista de ventas paginada
 */
export function useVentas(
  paginacion?: PagedRequest,
): UseQueryResult<PagedResponse<Venta>, Error> {
  return useQuery({
    queryKey: [QUERY_KEY, paginacion],
    queryFn: () => servicioVentas.obtenerVentas(paginacion),
  });
}

/**
 * Hook para obtener una venta por ID
 */
export function useVenta(id: number): UseQueryResult<Venta, Error> {
  return useQuery({
    queryKey: [QUERY_KEY, id],
    queryFn: () => servicioVentas.obtenerVentaPorId(id),
    enabled: !!id,
  });
}

/**
 * Hook para obtener ventas del día
 */
export function useVentasDelDia(): UseQueryResult<Venta[], Error> {
  return useQuery({
    queryKey: [QUERY_KEY, "hoy"],
    queryFn: () => servicioVentas.obtenerVentasDelDia(),
    refetchInterval: 30000,
  });
}

/**
 * Hook para crear una venta
 */
export function useCrearVenta() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (datos: VentaFormData) => servicioVentas.crearVenta(datos),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: [QUERY_KEY] });
      toast.success("Venta registrada exitosamente");
    },
    onError: (error) => {
      manejadorErrores(error);
    },
  });
}

/**
 * Hook para anular una venta
 */
export function useAnularVenta() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ id, motivo }: { id: number; motivo: string }) =>
      servicioVentas.anularVenta(id, motivo),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: [QUERY_KEY] });
      toast.success("Venta anulada exitosamente");
    },
    onError: (error) => {
      manejadorErrores(error);
    },
  });
}

/**
 * Hook para obtener estadísticas de ventas
 */
export function useEstadisticasVentas(
  fechaInicio: string,
  fechaFin: string,
) {
  return useQuery({
    queryKey: [QUERY_KEY, "estadisticas", fechaInicio, fechaFin],
    queryFn: () => servicioVentas.obtenerEstadisticas(fechaInicio, fechaFin),
    enabled: !!fechaInicio && !!fechaFin,
  });
}

/**
 * Hook para obtener series por tipo de comprobante y almacén
 */
export function useSeries(idTipoComprobante: number, idAlmacen?: number) {
  return useQuery({
    queryKey: ["series", idTipoComprobante, idAlmacen],
    queryFn: () => servicioVentas.obtenerSeries(idTipoComprobante, idAlmacen),
    enabled: !!idTipoComprobante,
  });
}

/**
 * Hook para obtener lista de cotizaciones paginada
 */
export function useCotizaciones(
  paginacion?: PagedRequest,
): UseQueryResult<PagedResponse<any>, Error> {
  return useQuery({
    queryKey: ["cotizaciones", paginacion],
    queryFn: () => servicioVentas.obtenerCotizaciones(paginacion),
  });
}
