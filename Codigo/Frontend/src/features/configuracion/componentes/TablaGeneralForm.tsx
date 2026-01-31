import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import * as z from "zod";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from "@/components/ui/form";
import {
  TablaGeneral,
  TablaGeneralFormData,
} from "../tipos/tablaGeneral.types";
import { useEffect } from "react";

const esquema = z.object({
  codigo: z
    .string()
    .min(1, "El código es requerido")
    .max(50, "Máximo 50 caracteres"),
  nombre: z
    .string()
    .min(1, "El nombre es requerido")
    .max(100, "Máximo 100 caracteres"),
  descripcion: z.string().max(255, "Máximo 255 caracteres").optional(),
  esSistema: z.boolean().default(false),
});

interface Props {
  datosIniciales?: TablaGeneral;
  alEnviar: (datos: TablaGeneralFormData) => void;
  alCancelar: () => void;
  cargando: boolean;
}

export function TablaGeneralForm({
  datosIniciales,
  alEnviar,
  alCancelar,
  cargando,
}: Props) {
  const form = useForm<TablaGeneralFormData>({
    resolver: zodResolver(esquema),
    defaultValues: {
      codigo: "",
      nombre: "",
      descripcion: "",
      esSistema: false,
    },
  });

  useEffect(() => {
    if (datosIniciales) {
      form.reset({
        codigo: datosIniciales.codigo,
        nombre: datosIniciales.nombre,
        descripcion: datosIniciales.descripcion || "",
        esSistema: datosIniciales.esSistema,
      });
    }
  }, [datosIniciales, form]);

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(alEnviar)} className="space-y-4">
        <FormField
          control={form.control}
          name="codigo"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Código</FormLabel>
              <FormControl>
                <Input
                  placeholder="Ej: TIPO_DOCUMENTO"
                  {...field}
                  disabled={!!datosIniciales} // Code usually shouldn't change
                />
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
                <Input placeholder="Ej: Tipo de Documento" {...field} />
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
                <Input placeholder="Descripción opcional" {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />

        <div className="flex justify-end space-x-2 pt-4">
          <Button type="button" variant="outline" onClick={alCancelar}>
            Cancelar
          </Button>
          <Button type="submit" disabled={cargando}>
            {cargando ? "Guardando..." : "Guardar"}
          </Button>
        </div>
      </form>
    </Form>
  );
}
