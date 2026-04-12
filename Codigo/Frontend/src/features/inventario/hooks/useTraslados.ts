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
import { PagedRequest, PagedResponse } from "@/types/pagination.types";
import { Traslado } from "../tipos/inventario.types";

export const useTraslados = (
  paginacion?: PagedRequest,
): UseQueryResult<PagedResponse<Traslado>, Error> => {
  return useQuery<PagedResponse<Traslado>>({
    queryKey: ["traslados", paginacion],
    queryFn: () => servicioTraslado.obtenerTodos(paginacion),
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
      console.error("Error al despachar traslado:", error);
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
      console.error("Error al recibir traslado:", error);
    },
  });
};
