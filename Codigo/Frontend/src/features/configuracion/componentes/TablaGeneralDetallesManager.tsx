import { useState } from "react";
import {
  useTablasGeneralesDetalles,
  useCrearDetalle,
  useActualizarDetalle,
  useEliminarDetalle,
} from "../hooks/useTablaGeneral";
import {
  TablaGeneral,
  TablaGeneralDetalle,
  TablaGeneralDetalleFormData,
} from "../tipos/tablaGeneral.types";
import { Button } from "@/components/ui/button";
import { Plus, Edit2, Trash2, CheckCircle, XCircle } from "lucide-react";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import * as z from "zod";
import { Input } from "@/components/ui/input";
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from "@/components/ui/form";
import { Checkbox } from "@/components/ui/checkbox";
import { MensajeError } from "@compartido/componentes/feedback/MensajeError";
import { Loading } from "@compartido/componentes/feedback/Loading";

interface Props {
  tabla: TablaGeneral;
}

const esquemaDetalle = z.object({
  codigo: z.string().min(1, "Requerido"),
  nombre: z.string().min(1, "Requerido"),
  orden: z.coerce.number().min(0), // Use coerce for numbers from inputs
  estado: z.boolean().default(true),
});

export function TablaGeneralDetallesManager({ tabla }: Props) {
  console.log("Tabla:", tabla);
  const {
    data: detalles,
    isLoading,
    error,
  } = useTablasGeneralesDetalles(tabla.id);
  const crearDetalle = useCrearDetalle();
  const actualizarDetalle = useActualizarDetalle();
  const eliminarDetalle = useEliminarDetalle();

  const [detalleAEditar, setDetalleAEditar] =
    useState<TablaGeneralDetalle | null>(null);
  const [modalFormOpen, setModalFormOpen] = useState(false);

  const handleCreate = () => {
    setDetalleAEditar(null);
    setModalFormOpen(true);
  };

  const handleEdit = (detalle: TablaGeneralDetalle) => {
    setDetalleAEditar(detalle);
    setModalFormOpen(true);
  };

  const handleDelete = (detalle: TablaGeneralDetalle) => {
    if (confirm(`¿Eliminar valor ${detalle.nombre}?`)) {
      eliminarDetalle.mutate({
        idDetalle: detalle.id,
        idTabla: tabla.id,
      });
    }
  };

  const closeForm = () => setModalFormOpen(false);

  if (isLoading) return <Loading mensaje="Cargando detalles..." />;
  if (error) return <MensajeError mensaje={error.message} />;

  return (
    <div className="space-y-4">
      <div className="flex justify-between items-center">
        <h3 className="text-lg font-medium">Valores de {tabla.nombre}</h3>
        <Button size="sm" onClick={handleCreate}>
          <Plus className="h-4 w-4 mr-1" /> Agregar Valor
        </Button>
      </div>

      <div className="border rounded-md">
        <table className="w-full text-sm">
          <thead className="bg-muted/50">
            <tr>
              <th className="p-2 text-left">Orden</th>
              <th className="p-2 text-left">Código</th>
              <th className="p-2 text-left">Nombre</th>
              <th className="p-2 text-center">Estado</th>
              <th className="p-2 text-right">Acciones</th>
            </tr>
          </thead>
          <tbody>
            {(detalles || []).length === 0 && (
              <tr>
                <td
                  colSpan={5}
                  className="p-4 text-center text-muted-foreground"
                >
                  No hay valores registrados
                </td>
              </tr>
            )}
            {(detalles || []).map((d) => (
              <tr key={d.id} className="border-t">
                <td className="p-2">{d.orden}</td>
                <td className="p-2 font-mono text-xs">{d.codigo}</td>
                <td className="p-2">{d.nombre}</td>
                <td className="p-2 text-center">
                  {d.estado ? (
                    <CheckCircle className="h-4 w-4 text-green-500 mx-auto" />
                  ) : (
                    <XCircle className="h-4 w-4 text-gray-300 mx-auto" />
                  )}
                </td>
                <td className="p-2 text-right space-x-1">
                  <Button
                    variant="ghost"
                    size="icon"
                    className="h-8 w-8"
                    onClick={() => handleEdit(d)}
                  >
                    <Edit2 className="h-3 w-3" />
                  </Button>
                  <Button
                    variant="ghost"
                    size="icon"
                    className="h-8 w-8 text-destructive"
                    onClick={() => handleDelete(d)}
                  >
                    <Trash2 className="h-3 w-3" />
                  </Button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      <Dialog open={modalFormOpen} onOpenChange={setModalFormOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>
              {detalleAEditar ? "Editar Valor" : "Nuevo Valor"}
            </DialogTitle>
          </DialogHeader>
          <DetalleForm
            key={detalleAEditar?.id || "new"}
            idTabla={tabla.id}
            datosIniciales={detalleAEditar}
            onSuccess={closeForm}
            onCancel={closeForm}
            isLoading={crearDetalle.isPending || actualizarDetalle.isPending}
            crearFn={crearDetalle.mutateAsync}
            actualizarFn={actualizarDetalle.mutateAsync}
          />
        </DialogContent>
      </Dialog>
    </div>
  );
}

function DetalleForm({
  idTabla,
  datosIniciales,
  onSuccess,
  onCancel,
  isLoading,
  crearFn,
  actualizarFn,
}: any) {
  const form = useForm<TablaGeneralDetalleFormData>({
    resolver: zodResolver(esquemaDetalle),
    defaultValues: {
      codigo: datosIniciales?.codigo || "",
      nombre: datosIniciales?.nombre || "",
      orden: datosIniciales?.orden || 0,
      estado: datosIniciales?.estado ?? true,
    },
  });

  const onSubmit = async (data: TablaGeneralDetalleFormData) => {
    try {
      if (datosIniciales) {
        await actualizarFn({
          idDetalle: datosIniciales.id,
          idTabla,
          datos: data,
        });
      } else {
        await crearFn({ idTabla, datos: data });
      }
      onSuccess();
    } catch (e) {
      console.error(e);
    }
  };

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-3">
        <FormField
          control={form.control}
          name="codigo"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Código</FormLabel>
              <FormControl>
                <Input {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        <FormField
          control={form.control}
          name="nombre"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Nombre</FormLabel>
              <FormControl>
                <Input {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        <FormField
          control={form.control}
          name="orden"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Orden</FormLabel>
              <FormControl>
                <Input type="number" {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        <FormField
          control={form.control}
          name="estado"
          render={({ field }) => (
            <FormItem className="flex flex-row items-start space-x-3 space-y-0 p-2">
              <FormControl>
                <Checkbox
                  checked={field.value}
                  onCheckedChange={field.onChange}
                />
              </FormControl>
              <FormLabel className="font-normal">Activo</FormLabel>
            </FormItem>
          )}
        />

        <div className="flex justify-end gap-2 pt-2">
          <Button type="button" variant="outline" onClick={onCancel}>
            Cancelar
          </Button>
          <Button type="submit" disabled={isLoading}>
            {isLoading ? "Guardando..." : "Guardar"}
          </Button>
        </div>
      </form>
    </Form>
  );
}
