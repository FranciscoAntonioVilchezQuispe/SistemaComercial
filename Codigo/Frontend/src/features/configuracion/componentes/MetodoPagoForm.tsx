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
import { MetodoPago, MetodoPagoFormData } from "../tipos/metodoPago.types";
import { SelectorCatalogo } from "@/compartido/componentes/formularios/SelectorCatalogo";

const schema = z.object({
  codigo: z.string().min(1, "El código es requerido"),
  nombre: z.string().min(1, "El nombre es requerido"),
  idTipoDocumentoPago: z.coerce.number().optional().nullable(),
  esEfectivo: z.boolean().default(false),
});

interface MetodoPagoFormProps {
  datosIniciales?: MetodoPago;
  alEnviar: (datos: MetodoPagoFormData) => void;
  alCancelar: () => void;
  cargando: boolean;
}

export function MetodoPagoForm({
  datosIniciales,
  alEnviar,
  alCancelar,
  cargando,
}: MetodoPagoFormProps) {
  const form = useForm<z.infer<typeof schema>>({
    resolver: zodResolver(schema),
    defaultValues: {
      codigo: "",
      nombre: "",
      idTipoDocumentoPago: null,
      esEfectivo: false,
    },
  });

  useEffect(() => {
    if (datosIniciales) {
      form.reset({
        codigo: datosIniciales.codigo,
        nombre: datosIniciales.nombre,
        idTipoDocumentoPago: datosIniciales.idTipoDocumentoPago,
        esEfectivo: datosIniciales.esEfectivo,
      });
    }
  }, [datosIniciales, form]);

  const onSubmit = (values: z.infer<typeof schema>) => {
    alEnviar({
      codigo: values.codigo,
      nombre: values.nombre,
      idTipoDocumentoPago: values.idTipoDocumentoPago || undefined,
      esEfectivo: values.esEfectivo,
    });
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
                <Input placeholder="EFE, DEP, TAR" {...field} />
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
                <Input placeholder="Efectivo, Depósito..." {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />

        <FormField
          control={form.control}
          name="idTipoDocumentoPago"
          render={({ field }) => (
            <SelectorCatalogo
              codigo="METODO_PAGO_TIPO"
              label="Tipo Documento de Pago (Opcional)"
              value={field.value || 0}
              onChange={(val) => field.onChange(val ? Number(val) : null)}
              placeholder="Seleccione Documento..."
            />
          )}
        />

        <FormField
          control={form.control}
          name="esEfectivo"
          render={({ field }) => (
            <FormItem className="flex flex-row items-center justify-between rounded-lg border p-3">
              <div className="space-y-0.5">
                <FormLabel>Es Efectivo</FormLabel>
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
