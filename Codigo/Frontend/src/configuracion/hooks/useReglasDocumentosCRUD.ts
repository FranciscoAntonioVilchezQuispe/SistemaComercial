import {
  useQuery,
  useMutation,
  useQueryClient,
  UseQueryResult,
  UseMutationResult,
} from "@tanstack/react-query";
import {
  reglasDocumentoService,
  ReglaDocumento,
  ReglasResponse,
} from "../services/reglasDocumentoService";

export const useReglasDocumentosCRUD = (): UseQueryResult<
  ReglaDocumento[],
  Error
> => {
  return useQuery({
    queryKey: ["reglas-documentos-full"],
    queryFn: () => reglasDocumentoService.listarReglas(),
  });
};

export const useConfiguracionReglas = (): UseQueryResult<
  ReglasResponse,
  Error
> => {
  return useQuery({
    queryKey: ["reglas-documentos-config"],
    queryFn: () => reglasDocumentoService.obtenerConfiguracion(),
  });
};

export const useGuardarRegla = (): UseMutationResult<
  ReglaDocumento,
  Error,
  ReglaDocumento,
  unknown
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (regla: ReglaDocumento) =>
      reglasDocumentoService.guardarRegla(regla),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["reglas-documentos-full"] });
      queryClient.invalidateQueries({ queryKey: ["reglas-documentos-config"] });
    },
  });
};

export const useEliminarRegla = (): UseMutationResult<
  void,
  Error,
  number,
  unknown
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (id: number) => reglasDocumentoService.eliminarRegla(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["reglas-documentos-full"] });
      queryClient.invalidateQueries({ queryKey: ["reglas-documentos-config"] });
    },
  });
};

export const useActualizarRelaciones = (): UseMutationResult<
  void,
  Error,
  { codigoDocumento: string; idsTiposComprobante: number[] },
  unknown
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({
      codigoDocumento,
      idsTiposComprobante,
    }: {
      codigoDocumento: string;
      idsTiposComprobante: number[];
    }) =>
      reglasDocumentoService.actualizarRelaciones(
        codigoDocumento,
        idsTiposComprobante,
      ),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["reglas-documentos-config"] });
    },
  });
};
