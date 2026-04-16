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
import { TipoTributo, TipoTributoFormData } from "../tipos/tipoTributo.types";

const schema = z.object({
  codigo: z.string().length(4, "El código SUNAT debe tener 4 dígitos"),
  nombre: z.string().min(1, "El nombre es requerido"),
  codigoInternacional: z.string().min(1, "El código internacional (UN/ECE 5153) es requerido"),
  descripcion: z.string().optional(),
});

interface TipoTributoFormProps {
  datosIniciales?: TipoTributo;
  alEnviar: (datos: TipoTributoFormData) => void;
  alCancelar: () => void;
  cargando: boolean;
}

export function TipoTributoForm({
  datosIniciales,
  alEnviar,
  alCancelar,
  cargando,
}: TipoTributoFormProps) {
  const form = useForm<z.infer<typeof schema>>({
    resolver: zodResolver(schema),
    defaultValues: {
      codigo: "",
      nombre: "",
      codigoInternacional: "",
      descripcion: "",
    },
  });

  useEffect(() => {
    if (datosIniciales) {
      form.reset({
        codigo: datosIniciales.codigo,
        nombre: datosIniciales.nombre,
        codigoInternacional: datosIniciales.codigoInternacional,
        descripcion: datosIniciales.descripcion || "",
      });
    }
  }, [datosIniciales, form]);

  const onSubmit = (values: z.infer<typeof schema>) => {
    alEnviar(values);
  };

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
        <div className="grid grid-cols-2 gap-4">
          <FormField
            control={form.control}
            name="codigo"
            render={({ field }) => (
              <FormItem>
                <FormLabel>Cod. SUNAT (ID)</FormLabel>
                <FormControl>
                  <Input placeholder="Ej: 1000" {...field} maxLength={4} />
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />
          <FormField
            control={form.control}
            name="codigoInternacional"
            render={({ field }) => (
              <FormItem>
                <FormLabel>Cód. Internacional (UN/ECE)</FormLabel>
                <FormControl>
                  <Input placeholder="Ej: VAT, EXC" {...field} />
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />
        </div>

        <FormField
          control={form.control}
          name="nombre"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Nombre</FormLabel>
              <FormControl>
                <Input placeholder="Ej: IGV" {...field} />
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
              <FormLabel>Descripción</FormLabel>
              <FormControl>
                <Input placeholder="Ej: Impuesto General a las Ventas" {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />

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
