import { useEffect } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import * as z from "zod";
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Switch } from "@/components/ui/switch";
import { Impuesto, ImpuestoFormData } from "../tipos/impuesto.types";

const schema = z.object({
  codigo: z.string().min(1, "El código es requerido"),
  nombre: z.string().min(1, "El nombre es requerido"),
  porcentaje: z.coerce
    .number()
    .min(0, "Debe ser mayor o igual a 0")
    .max(100, "Max 100%"),
  esIgv: z.boolean().default(false),
});

interface ImpuestoFormProps {
  datosIniciales?: Impuesto;
  alEnviar: (datos: ImpuestoFormData) => void;
  alCancelar: () => void;
  cargando: boolean;
}

export function ImpuestoForm({
  datosIniciales,
  alEnviar,
  alCancelar,
  cargando,
}: ImpuestoFormProps) {
  const form = useForm<z.infer<typeof schema>>({
    resolver: zodResolver(schema),
    defaultValues: {
      codigo: "",
      nombre: "",
      porcentaje: 0,
      esIgv: false,
    },
  });

  useEffect(() => {
    if (datosIniciales) {
      form.reset({
        codigo: datosIniciales.codigo,
        nombre: datosIniciales.nombre,
        porcentaje: datosIniciales.porcentaje,
        esIgv: datosIniciales.esIgv,
      });
    }
  }, [datosIniciales, form]);

  const onSubmit = (values: z.infer<typeof schema>) => {
    alEnviar(values);
  };

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
                <Input placeholder="Ej: IGV, ISC" {...field} />
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
                <Input placeholder="Impuesto General" {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />

        <FormField
          control={form.control}
          name="porcentaje"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Porcentaje (%)</FormLabel>
              <FormControl>
                <Input type="number" step="0.01" {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />

        <FormField
          control={form.control}
          name="esIgv"
          render={({ field }) => (
            <FormItem className="flex flex-row items-center justify-between rounded-lg border p-3">
              <div className="space-y-0.5">
                <FormLabel>Es IGV (Impuesto General a las Ventas)</FormLabel>
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
          <Button type="button" variant="outline" onClick={alCancelar}>
            Cancelar
          </Button>
          <Button type="submit" disabled={cargando}>
            {cargando
              ? "Guardando..."
              : datosIniciales
                ? "Actualizar"
                : "Crear"}
          </Button>
        </div>
      </form>
    </Form>
  );
}
