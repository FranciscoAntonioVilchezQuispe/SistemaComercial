import { useQuery, UseQueryResult } from "@tanstack/react-query";
import {
  tipoComprobanteService,
  TipoComprobante,
} from "../services/tipoComprobanteService";

/**
 * Hook para obtener los tipos de comprobante desde la tabla tipo_comprobante.
 * Utiliza React Query para el manejo de caché y estado.
 */
export const useTipoComprobante = (): UseQueryResult<
  TipoComprobante[],
  Error
> => {
  return useQuery({
    queryKey: ["tipos-comprobante"],
    queryFn: () => tipoComprobanteService.getAll(),
    select: (response: any) => response.datos || response.data || [],
    staleTime: 1000 * 60 * 10, // 10 minutos de caché
    refetchOnWindowFocus: false,
  });
};
