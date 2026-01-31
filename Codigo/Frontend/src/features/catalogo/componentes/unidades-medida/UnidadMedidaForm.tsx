import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import * as z from "zod";
import { Button } from "@/components/ui/button";
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Switch } from "@/components/ui/switch";
import { UnidadMedida } from "../../tipos/catalogo.types";
import {
  useCrearUnidadMedida,
  useActualizarUnidadMedida,
} from "../../hooks/useUnidadesMedida";

const formSchema = z.object({
  codigo: z.string().min(1, "El código es requerido").max(10),
  nombre: z.string().min(1, "El nombre es requerido"),
  simbolo: z.string().optional(),
  descripcion: z.string().optional(),
  activo: z.boolean().default(true),
});

type FormValues = z.infer<typeof formSchema>;

interface UnidadMedidaFormProps {
  unidad: UnidadMedida | null;
  onSuccess: () => void;
  onCancel: () => void;
}

export function UnidadMedidaForm({
  unidad,
  onSuccess,
  onCancel,
}: UnidadMedidaFormProps) {
  const crearMutation = useCrearUnidadMedida();
  const actualizarMutation = useActualizarUnidadMedida();

  const form = useForm<FormValues>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      codigo: unidad?.codigo || "",
      nombre: unidad?.nombre || "",
      simbolo: unidad?.simbolo || "",
      descripcion: unidad?.descripcion || "",
      activo: unidad?.activo ?? true,
    },
  });

  const onSubmit = (values: FormValues) => {
    if (unidad) {
      actualizarMutation.mutate(
        { id: unidad.id, datos: values },
        { onSuccess },
      );
    } else {
      crearMutation.mutate(values, { onSuccess });
    }
  };

  const isSubmitting = crearMutation.isPending || actualizarMutation.isPending;

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
        <FormField
          control={form.control}
          name="codigo"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Código</FormLabel>
              <FormControl>
                <Input {...field} placeholder="UND, KG, LT..." />
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
                <Input {...field} placeholder="Unidad, Kilogramo, Litro..." />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />

        <FormField
          control={form.control}
          name="simbolo"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Símbolo (Opcional)</FormLabel>
              <FormControl>
                <Input {...field} placeholder="Ud, Kg, Lt..." />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />

        <FormField
          control={form.control}
          name="descripcion"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Descripción (Opcional)</FormLabel>
              <FormControl>
                <Input {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />

        <FormField
          control={form.control}
          name="activo"
          render={({ field }) => (
            <FormItem className="flex items-center justify-between rounded-lg border p-3">
              <FormLabel>Activo</FormLabel>
              <FormControl>
                <Switch
                  checked={field.value}
                  onCheckedChange={field.onChange}
                />
              </FormControl>
            </FormItem>
          )}
        />

        <div className="flex justify-end gap-2 pt-4">
          <Button type="button" variant="outline" onClick={onCancel}>
            Cancelar
          </Button>
          <Button type="submit" disabled={isSubmitting}>
            {isSubmitting ? "Guardando..." : unidad ? "Actualizar" : "Crear"}
          </Button>
        </div>
      </form>
    </Form>
  );
}
