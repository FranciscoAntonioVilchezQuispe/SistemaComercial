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
import { AfectacionIgv, AfectacionIgvFormData } from "../tipos/afectacionIgv.types";

const schema = z.object({
  codigo: z.string().length(2, "El código SUNAT debe tener 2 dígitos"),
  descripcion: z.string().min(1, "La descripción es requerida"),
  esGravado: z.boolean().default(false),
  esExonerado: z.boolean().default(false),
  esInafecto: z.boolean().default(false),
  esGratuito: z.boolean().default(false),
  codigoTributoDefault: z.string().optional(),
  nombreTributoDefault: z.string().optional(),
});

interface AfectacionIgvFormProps {
  datosIniciales?: AfectacionIgv;
  alEnviar: (datos: AfectacionIgvFormData) => void;
  alCancelar: () => void;
  cargando: boolean;
}

export function AfectacionIgvForm({
  datosIniciales,
  alEnviar,
  alCancelar,
  cargando,
}: AfectacionIgvFormProps) {
  const form = useForm<z.infer<typeof schema>>({
    resolver: zodResolver(schema),
    defaultValues: {
      codigo: "",
      descripcion: "",
      esGravado: false,
      esExonerado: false,
      esInafecto: false,
      esGratuito: false,
      codigoTributoDefault: "1000",
      nombreTributoDefault: "IGV",
    },
  });

  useEffect(() => {
    if (datosIniciales) {
      form.reset({
        codigo: datosIniciales.codigo,
        descripcion: datosIniciales.descripcion,
        esGravado: datosIniciales.esGravado,
        esExonerado: datosIniciales.esExonerado,
        esInafecto: datosIniciales.esInafecto,
        esGratuito: datosIniciales.esGratuito,
        codigoTributoDefault: datosIniciales.codigoTributoDefault || "1000",
        nombreTributoDefault: datosIniciales.nombreTributoDefault || "IGV",
      });
    }
  }, [datosIniciales, form]);

  const onSubmit = (values: z.infer<typeof schema>) => {
    alEnviar(values);
  };

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
        <div className="grid grid-cols-4 gap-4">
          <div className="col-span-1">
            <FormField
              control={form.control}
              name="codigo"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Cod. SUNAT</FormLabel>
                  <FormControl>
                    <Input placeholder="Ej: 10" {...field} maxLength={2} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
          </div>
          <div className="col-span-3">
            <FormField
              control={form.control}
              name="descripcion"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Descripción</FormLabel>
                  <FormControl>
                    <Input placeholder="Ej: Gravado - Operación Onerosa" {...field} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
          </div>
        </div>

        <div className="grid grid-cols-2 gap-4">
          <FormField
            control={form.control}
            name="esGravado"
            render={({ field }) => (
              <FormItem className="flex flex-row items-center justify-between rounded-lg border p-3">
                <FormLabel className="text-sm">Es Gravado</FormLabel>
                <FormControl>
                  <Switch checked={field.value} onCheckedChange={field.onChange} />
                </FormControl>
              </FormItem>
            )}
          />
          <FormField
            control={form.control}
            name="esExonerado"
            render={({ field }) => (
              <FormItem className="flex flex-row items-center justify-between rounded-lg border p-3">
                <FormLabel className="text-sm">Es Exonerado</FormLabel>
                <FormControl>
                  <Switch checked={field.value} onCheckedChange={field.onChange} />
                </FormControl>
              </FormItem>
            )}
          />
          <FormField
            control={form.control}
            name="esInafecto"
            render={({ field }) => (
              <FormItem className="flex flex-row items-center justify-between rounded-lg border p-3">
                <FormLabel className="text-sm">Es Inafecto</FormLabel>
                <FormControl>
                  <Switch checked={field.value} onCheckedChange={field.onChange} />
                </FormControl>
              </FormItem>
            )}
          />
          <FormField
            control={form.control}
            name="esGratuito"
            render={({ field }) => (
              <FormItem className="flex flex-row items-center justify-between rounded-lg border p-3">
                <FormLabel className="text-sm">Es Gratuito</FormLabel>
                <FormControl>
                  <Switch checked={field.value} onCheckedChange={field.onChange} />
                </FormControl>
              </FormItem>
            )}
          />
        </div>

        <div className="grid grid-cols-2 gap-4">
          <FormField
            control={form.control}
            name="codigoTributoDefault"
            render={({ field }) => (
              <FormItem>
                <FormLabel>Cód. Tributo (Defecto)</FormLabel>
                <FormControl>
                  <Input placeholder="Ej: 1000" {...field} />
                </FormControl>
              </FormItem>
            )}
          />
          <FormField
            control={form.control}
            name="nombreTributoDefault"
            render={({ field }) => (
              <FormItem>
                <FormLabel>Nombre Tributo (Defecto)</FormLabel>
                <FormControl>
                  <Input placeholder="Ej: IGV" {...field} />
                </FormControl>
              </FormItem>
            )}
          />
        </div>

        <div className="flex justify-end gap-2 pt-4">
          <Button type="button" variant="outline" onClick={alCancelar}>
            Cancelar
          </Button>
          <Button type="submit" disabled={cargando}>
            {cargando ? "Guardando..." : datosIniciales ? "Actualizar" : "Crear"}
          </Button>
        </div>
      </form>
    </Form>
  );
}
