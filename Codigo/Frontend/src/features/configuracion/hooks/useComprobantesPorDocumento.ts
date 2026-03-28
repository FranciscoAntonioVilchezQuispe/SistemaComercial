import { useQuery, UseQueryResult } from "@tanstack/react-query";
import { servicioReglaDocumento } from "@/features/configuracion/servicios/servicioReglaDocumento";
import { TipoComprobante } from "../tipos/tipoComprobante.types";

/**
 * Hook para obtener los tipos de comprobante permitidos para un código de documento específico (DNI, RUC, etc.)
 * @param codigoDocumento Código SUNAT del documento (ej. '1' para DNI, '6' para RUC)
 */
export const useComprobantesPorDocumento = (
  codigoDocumento?: string,
): UseQueryResult<TipoComprobante[], Error> => {
  return useQuery({
    queryKey: ["tipos-comprobante-filtrados", codigoDocumento],
    queryFn: () => servicioReglaDocumento.listarComprobantesPorDocumento(codigoDocumento!),
    enabled: !!codigoDocumento,
    staleTime: 1000 * 60 * 30, // 30 minutos de caché
  });
};
