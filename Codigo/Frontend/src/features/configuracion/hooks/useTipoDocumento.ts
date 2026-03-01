import { useQuery, UseQueryResult } from "@tanstack/react-query";
import {
  tipoDocumentoService,
  TipoDocumento,
} from "../services/tipoDocumentoService";

/**
 * Hook para obtener los tipos de documento desde la tabla tipo_documento.
 * El servicio ya extrae los datos de la respuesta del API, por lo que
 * este hook los recibe directamente como TipoDocumento[].
 */
export const useTipoDocumento = (): UseQueryResult<TipoDocumento[], Error> => {
  return useQuery({
    queryKey: ["tipos-documento"],
    queryFn: () => tipoDocumentoService.getAll(),
    staleTime: 1000 * 60 * 10, // 10 minutos de caché
    refetchOnWindowFocus: false,
  });
};
