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
  FormDescription,
} from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Switch } from "@/components/ui/switch";
import { ListaPrecio } from "../../tipos/catalogo.types";
import {
  useCrearListaPrecio,
  useActualizarListaPrecio,
} from "../../hooks/useListasPrecios";

const formSchema = z.object({
  codigo: z.string().min(1, "El código es requerido").max(20),
  nombre: z.string().min(1, "El nombre es requerido"),
  descripcion: z.string().optional(),
  activo: z.boolean().default(true),
});

type FormValues = z.infer<typeof formSchema>;

interface ListaPrecioFormProps {
  lista: ListaPrecio | null;
  onSuccess: () => void;
  onCancel: () => void;
}

export function ListaPrecioForm({
  lista,
  onSuccess,
  onCancel,
}: ListaPrecioFormProps) {
  const crearMutation = useCrearListaPrecio();
  const actualizarMutation = useActualizarListaPrecio();

  const form = useForm<FormValues>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      codigo: lista?.codigo || "",
      nombre: lista?.nombre || "",
      descripcion: lista?.descripcion || "",
      activo: lista?.activo ?? true,
    },
  });

  const onSubmit = (values: FormValues) => {
    if (lista) {
      actualizarMutation.mutate({ id: lista.id, datos: values }, { onSuccess });
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
                <Input
                  {...field}
                  placeholder="MAYORISTA, PUBLICO, DISTRIBUIDOR..."
                />
              </FormControl>
              <FormDescription>
                Identificador único de la lista (ej: MAYORISTA)
              </FormDescription>
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
                <Input
                  {...field}
                  placeholder="Precio Mayorista, Precio Público..."
                />
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
                <Textarea {...field} rows={3} />
              </FormControl>
              <FormDescription>
                Describe cuándo usar esta lista de precios
              </FormDescription>
              <FormMessage />
            </FormItem>
          )}
        />

        <FormField
          control={form.control}
          name="activo"
          render={({ field }) => (
            <FormItem className="flex items-center justify-between rounded-lg border p-3">
              <div>
                <FormLabel>Activo</FormLabel>
                <FormDescription>
                  Solo las listas activas estarán disponibles para usar
                </FormDescription>
              </div>
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
            {isSubmitting ? "Guardando..." : lista ? "Actualizar" : "Crear"}
          </Button>
        </div>
      </form>
    </Form>
  );
}
