import { useQuery, UseQueryResult } from "@tanstack/react-query";
import { reglasDocumentoService } from "../services/reglasDocumentoService";
import { TipoComprobante } from "@/features/configuracion/tipos/tipoComprobante.types";

export const useComprobantesPorDocumento = (
  codigoDocumento?: string,
): UseQueryResult<TipoComprobante[], Error> => {
  return useQuery<TipoComprobante[]>({
    queryKey: ["comprobantes-por-documento", codigoDocumento],
    queryFn: () =>
      codigoDocumento
        ? reglasDocumentoService.listarComprobantesPorDocumento(codigoDocumento)
        : Promise.resolve([]),
    enabled: !!codigoDocumento,
    staleTime: 1000 * 60 * 60, // 1 hora de caché
  });
};
