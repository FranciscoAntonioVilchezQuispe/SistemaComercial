import { useQuery } from "@tanstack/react-query";
import {
  reglasDocumentoService,
  ReglasResponse,
} from "../services/reglasDocumentoService";

export const useReglasDocumentos = () => {
  return useQuery<ReglasResponse>({
    queryKey: ["reglas-documentos"],
    queryFn: reglasDocumentoService.obtenerConfiguracion,
    staleTime: 1000 * 60 * 60, // 1 hora de caché (cambian muy poco)
  });
};
