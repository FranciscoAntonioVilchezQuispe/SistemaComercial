import { useQuery } from "@tanstack/react-query";
import {
  servicioReglaDocumento,
  ReglasResponse,
} from "@/features/configuracion/servicios/servicioReglaDocumento";

export const useReglasDocumentos = () => {
  return useQuery<ReglasResponse>({
    queryKey: ["reglas-documentos"],
    queryFn: () => servicioReglaDocumento.obtenerConfiguracion(),
    staleTime: 1000 * 60 * 60, // 1 hora de caché (cambian muy poco)
  });
};
