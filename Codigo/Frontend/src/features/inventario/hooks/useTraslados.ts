import {
  useMutation,
  useQuery,
  useQueryClient,
  UseQueryResult,
  UseMutationResult,
} from "@tanstack/react-query";
import {
  servicioTraslado,
  CrearTrasladoComando,
  RecibirTrasladoComando,
} from "../servicios/servicioTraslado";
import { toast } from "sonner";

export const useTraslados = (): UseQueryResult<any[], Error> => {
  return useQuery<any[]>({
    queryKey: ["traslados"],
    queryFn: () => servicioTraslado.obtenerTodos(),
  });
};

export const useCrearTraslado = (): UseMutationResult<
  any,
  Error,
  CrearTrasladoComando
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (comando: CrearTrasladoComando) =>
      servicioTraslado.crear(comando),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["traslados"] });
      queryClient.invalidateQueries({ queryKey: ["stock"] });
      toast.success("Traslado despachado exitosamente");
    },
    onError: (error: any) => {
      toast.error(
        "Error al despachar traslado: " +
          (error.response?.data?.message || error.message),
      );
    },
  });
};

export const useRecibirTraslado = (): UseMutationResult<
  any,
  Error,
  RecibirTrasladoComando
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (comando: RecibirTrasladoComando) =>
      servicioTraslado.recibir(comando),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["traslados"] });
      queryClient.invalidateQueries({ queryKey: ["stock"] });
      toast.success("Traslado recibido y stock actualizado");
    },
    onError: (error: any) => {
      toast.error(
        "Error al recibir traslado: " +
          (error.response?.data?.message || error.message),
      );
    },
  });
};
