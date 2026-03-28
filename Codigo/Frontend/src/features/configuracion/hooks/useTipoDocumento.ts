import { useQuery, UseQueryResult } from "@tanstack/react-query";
import {
  servicioTipoDocumento,
  TipoDocumento,
} from "@/features/configuracion/servicios/servicioTipoDocumento";

/**
 * Hook para obtener los tipos de documento desde la tabla tipo_documento.
 */
export const useTipoDocumento = (): UseQueryResult<TipoDocumento[], Error> => {
  return useQuery({
    queryKey: ["tipos-documento"],
    queryFn: () => servicioTipoDocumento.obtenerTodos(),
    staleTime: 1000 * 60 * 10, // 10 minutos de caché
    refetchOnWindowFocus: false,
  });
};
