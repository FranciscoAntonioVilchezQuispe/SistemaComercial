import { useQuery, UseQueryResult } from "@tanstack/react-query";
import { servicioTipoComprobante } from "../servicios/servicioTipoComprobante";
import { TipoComprobante } from "../tipos/tipoComprobante.types";
import { PagedResponse } from "@/types/pagination.types";

/**
 * Hook para obtener los tipos de comprobante.
 */
export const useTipoComprobante = (modulo?: string): UseQueryResult<PagedResponse<TipoComprobante>, Error> => {
  return useQuery({
    queryKey: ["tipos-comprobante", modulo],
    queryFn: () => servicioTipoComprobante.obtenerTodos({ modulo, pageNumber: 1, pageSize: 100 }),
    staleTime: 1000 * 60 * 60, // 1 hora de caché
  });
};
