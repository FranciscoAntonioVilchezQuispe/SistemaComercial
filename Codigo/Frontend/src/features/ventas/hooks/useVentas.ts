import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { toast } from "sonner";
import { servicioVentas } from "../servicios/servicioVentas";
import { VentaFormData, VentaFiltros } from "../tipos/ventas.types";
import { manejadorErrores } from "@/lib/axios/manejadorErrores";

const QUERY_KEY = "ventas";

/**
 * Hook para obtener lista de ventas con filtros
 */
export function useVentas(
  filtros?: VentaFiltros,
  pagina: number = 1,
  elementosPorPagina: number = 10,
): any {
  return useQuery({
    queryKey: [QUERY_KEY, filtros, pagina, elementosPorPagina],
    queryFn: () =>
      servicioVentas.obtenerVentas(filtros, pagina, elementosPorPagina),
  });
}

/**
 * Hook para obtener una venta por ID
 */
export function useVenta(id: number): any {
  return useQuery({
    queryKey: [QUERY_KEY, id],
    queryFn: () => servicioVentas.obtenerVentaPorId(id),
    enabled: !!id,
  });
}

/**
 * Hook para obtener ventas del día
 */
export function useVentasDelDia(): any {
  return useQuery({
    queryKey: [QUERY_KEY, "hoy"],
    queryFn: () => servicioVentas.obtenerVentasDelDia(),
    refetchInterval: 30000, // Refetch cada 30 segundos
  });
}

/**
 * Hook para crear una venta
 */
export function useCrearVenta(): any {
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
export function useAnularVenta(): any {
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
): any {
  return useQuery({
    queryKey: [QUERY_KEY, "estadisticas", fechaInicio, fechaFin],
    queryFn: () => servicioVentas.obtenerEstadisticas(fechaInicio, fechaFin),
    enabled: !!fechaInicio && !!fechaFin,
  });
}

/**
 * Hook para obtener series por tipo de comprobante y almacén
 */
export function useSeries(idTipoComprobante: number, idAlmacen?: number): any {
  return useQuery({
    queryKey: ["series", idTipoComprobante, idAlmacen],
    queryFn: () => servicioVentas.obtenerSeries(idTipoComprobante, idAlmacen),
    enabled: !!idTipoComprobante,
  });
}
