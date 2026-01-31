import {
  useQuery,
  useMutation,
  useQueryClient,
  UseQueryResult,
} from "@tanstack/react-query";
import { toast } from "sonner";
import { servicioUnidadesMedida } from "../servicios/servicioUnidadesMedida";
import {
  UnidadMedidaFormData,
  RespuestaUnidadesMedida,
} from "../tipos/catalogo.types";
import { manejadorErrores } from "@/lib/axios/manejadorErrores";

const QUERY_KEY = "unidades-medida";

export function useUnidadesMedida(
  activo?: boolean,
): UseQueryResult<RespuestaUnidadesMedida, Error> {
  return useQuery({
    queryKey: [QUERY_KEY, activo],
    queryFn: () => servicioUnidadesMedida.obtenerUnidades(activo),
  });
}

export function useCrearUnidadMedida(): ReturnType<
  typeof useMutation<unknown, Error, UnidadMedidaFormData>
> {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (datos: UnidadMedidaFormData) =>
      servicioUnidadesMedida.crearUnidad(datos),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: [QUERY_KEY] });
      toast.success("Unidad de medida creada exitosamente");
    },
    onError: (error) => {
      manejadorErrores(error);
    },
  });
}

export function useActualizarUnidadMedida(): ReturnType<
  typeof useMutation<
    unknown,
    Error,
    { id: number; datos: UnidadMedidaFormData }
  >
> {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ id, datos }: { id: number; datos: UnidadMedidaFormData }) =>
      servicioUnidadesMedida.actualizarUnidad(id, datos),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: [QUERY_KEY] });
      toast.success("Unidad de medida actualizada exitosamente");
    },
    onError: (error) => {
      manejadorErrores(error);
    },
  });
}

export function useEliminarUnidadMedida(): ReturnType<
  typeof useMutation<void, Error, number>
> {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (id: number) => servicioUnidadesMedida.eliminarUnidad(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: [QUERY_KEY] });
      toast.success("Unidad de medida eliminada exitosamente");
    },
    onError: (error) => {
      manejadorErrores(error);
    },
  });
}
