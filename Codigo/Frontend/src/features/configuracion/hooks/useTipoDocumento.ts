import { useQuery, UseQueryResult } from "@tanstack/react-query";
import {
  tipoDocumentoService,
  TipoDocumento,
} from "../services/tipoDocumentoService";

/**
 * Hook para obtener los tipos de documento desde la tabla tipo_documento.
 * Utiliza React Query para el manejo de caché y estado.
 */
export const useTipoDocumento = (): UseQueryResult<TipoDocumento[], Error> => {
  return useQuery({
    queryKey: ["tipos-documento"],
    queryFn: () => tipoDocumentoService.getAll(),
    select: (response: any) => response.datos || response.data || [],
    staleTime: 1000 * 60 * 10, // 10 minutos de caché
    refetchOnWindowFocus: false,
  });
};
