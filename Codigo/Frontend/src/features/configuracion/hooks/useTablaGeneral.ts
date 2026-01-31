import {
  useQuery,
  useMutation,
  useQueryClient,
  UseQueryResult,
  UseMutationResult,
} from "@tanstack/react-query";
import { servicioTablaGeneral } from "../servicios/servicioTablaGeneral";
import {
  TablaGeneralFormData,
  TablaGeneralDetalleFormData,
  TablaGeneralDetalle,
} from "../tipos/tablaGeneral.types";
import { toast } from "sonner";
import { PagedRequest } from "@/types/pagination.types";

const QUERY_KEY = "tablas-generales";
const QUERY_KEY_DETALLES = "tablas-generales-detalles";

export function useTablasGenerales(req?: PagedRequest) {
  return useQuery({
    queryKey: [QUERY_KEY, req],
    queryFn: () => servicioTablaGeneral.obtenerTablas(req),
  });
}

export function useTablasGeneralesDetalles(
  idTabla: number,
): UseQueryResult<TablaGeneralDetalle[], Error> {
  console.log("ID tabla hook:", idTabla);
  return useQuery({
    queryKey: [QUERY_KEY_DETALLES, idTabla],
    queryFn: () => servicioTablaGeneral.obtenerDetalles(idTabla),
    enabled: !!idTabla,
    // Cada vez que se abre el diálogo (click en "Valores"),
    // forzamos un nuevo llamado al backend para tener datos frescos.
    refetchOnMount: "always",
    staleTime: 0,
  });
}

export function useCrearTabla() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (datos: TablaGeneralFormData) =>
      servicioTablaGeneral.crearTabla(datos),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: [QUERY_KEY] });
      toast.success("Tabla creada exitosamente");
    },
    onError: (error: Error) => {
      toast.error(`Error al crear tabla: ${error.message}`);
    },
  });
}

export function useActualizarTabla() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ id, datos }: { id: number; datos: TablaGeneralFormData }) =>
      servicioTablaGeneral.actualizarTabla(id, datos),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: [QUERY_KEY] });
      toast.success("Tabla actualizada exitosamente");
    },
    onError: (error: Error) => {
      toast.error(`Error al actualizar tabla: ${error.message}`);
    },
  });
}

export function useEliminarTabla(): UseMutationResult<void, Error, number> {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (id: number) => servicioTablaGeneral.eliminarTabla(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: [QUERY_KEY] });
      toast.success("Tabla eliminada exitosamente");
    },
    onError: (error: Error) => {
      toast.error(`Error al eliminar tabla: ${error.message}`);
    },
  });
}

// DETALLES

export function useCrearDetalle() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({
      idTabla,
      datos,
    }: {
      idTabla: number;
      datos: TablaGeneralDetalleFormData;
    }) => servicioTablaGeneral.crearDetalle(idTabla, datos),
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({
        queryKey: [QUERY_KEY_DETALLES, variables.idTabla],
      });
      // Also invalidate main table queries to update counts if we display them
      queryClient.invalidateQueries({ queryKey: [QUERY_KEY] });
      toast.success("Detalle agregado exitosamente");
    },
    onError: (error: Error) => {
      toast.error(`Error al agregar detalle: ${error.message}`);
    },
  });
}

export function useActualizarDetalle() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({
      idDetalle,
      idTabla: _idTabla,
      datos,
    }: {
      idDetalle: number;
      idTabla: number;
      datos: TablaGeneralDetalleFormData;
    }) => servicioTablaGeneral.actualizarDetalle(idDetalle, datos),
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({
        queryKey: [QUERY_KEY_DETALLES, variables.idTabla],
      });
      toast.success("Detalle actualizado exitosamente");
    },
    onError: (error: Error) => {
      toast.error(`Error al actualizar detalle: ${error.message}`);
    },
  });
}

export function useEliminarDetalle() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({
      idDetalle,
      idTabla: _idTabla,
    }: {
      idDetalle: number;
      idTabla: number;
    }) => servicioTablaGeneral.eliminarDetalle(idDetalle),
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({
        queryKey: [QUERY_KEY_DETALLES, variables.idTabla],
      });
      queryClient.invalidateQueries({ queryKey: [QUERY_KEY] });
      toast.success("Detalle eliminado exitosamente");
    },
    onError: (error: Error) => {
      toast.error(`Error al eliminar detalle: ${error.message}`);
    },
  });
}
