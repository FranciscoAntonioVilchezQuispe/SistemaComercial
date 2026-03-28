import {
  useQuery,
  useMutation,
  useQueryClient,
  UseQueryResult,
  UseMutationResult,
} from "@tanstack/react-query";
import {
  servicioReglaDocumento,
  ReglaDocumento,
  ReglasResponse,
} from "@/features/configuracion/servicios/servicioReglaDocumento";

export const useReglasDocumentosCRUD = (): UseQueryResult<
  ReglaDocumento[],
  Error
> => {
  return useQuery({
    queryKey: ["reglas-documentos-full"],
    queryFn: () => servicioReglaDocumento.listarReglas(),
  });
};

export const useConfiguracionReglas = (): UseQueryResult<
  ReglasResponse,
  Error
> => {
  return useQuery({
    queryKey: ["reglas-documentos-config"],
    queryFn: () => servicioReglaDocumento.obtenerConfiguracion(),
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
      servicioReglaDocumento.guardarRegla(regla),
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
    mutationFn: (id: number) => servicioReglaDocumento.eliminarRegla(id),
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
      servicioReglaDocumento.actualizarRelaciones(
        codigoDocumento,
        idsTiposComprobante,
      ),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["reglas-documentos-config"] });
    },
  });
};
