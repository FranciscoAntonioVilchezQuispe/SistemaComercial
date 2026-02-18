import { useQuery, UseQueryResult } from "@tanstack/react-query";
import { tipoComprobanteService } from "../services/tipoComprobanteService";
import { TipoComprobante } from "../tipos/tipoComprobante.types";
import { ToReturnList } from "@/types/api.types";

/**
 * Hook para obtener los tipos de comprobante desde la tabla tipo_comprobante.
 * Utiliza React Query para el manejo de caché y estado.
 */
export const useTipoComprobante = (
  modulo?: string,
): UseQueryResult<TipoComprobante[], Error> => {
  return useQuery<ToReturnList<TipoComprobante>, Error, TipoComprobante[]>({
    queryKey: ["tipos-comprobante", modulo],
    queryFn: () => tipoComprobanteService.getAll(modulo),
    select: (response) => {
      // response es ToReturnList<TipoComprobante>, por lo tanto response.data es TipoComprobante[]
      const data = response.data || [];

      // Mapeo seguro para manejar inconsistencias de backend (PascalCase vs camelCase)
      return data.map((item: any) => ({
        id: item.id || item.Id,
        codigo: item.codigo || item.Codigo,
        nombre: item.nombre || item.Nombre,
        mueveStock: item.mueveStock || item.MueveStock,
        tipoMovimientoStock:
          item.tipoMovimientoStock || item.TipoMovimientoStock,
        activado: item.activado || item.Activado,
        esCompra: item.esCompra || item.EsCompra || false,
        esVenta: item.esVenta || item.EsVenta || false,
        esOrdenCompra: item.esOrdenCompra || item.EsOrdenCompra || false,
      }));
    },
    staleTime: 1000 * 60 * 10, // 10 minutos de caché
    refetchOnWindowFocus: false,
  });
};
