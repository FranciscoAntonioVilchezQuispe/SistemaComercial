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
import { Textarea } from "@/components/ui/textarea";
import { Categoria, CategoriaFormData } from "../../tipos/catalogo.types";
import { useEffect } from "react";

const formSchema = z.object({
  nombre: z.string().min(2, "El nombre debe tener al menos 2 caracteres"),
  descripcion: z.string().optional(),
});

interface Props {
  datosIniciales?: Categoria;
  alEnviar: (datos: CategoriaFormData) => void;
  alCancelar: () => void;
  cargando?: boolean;
}

export function CategoriaForm({
  datosIniciales,
  alEnviar,
  alCancelar,
  cargando,
}: Props) {
  const form = useForm<CategoriaFormData>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      nombre: "",
      descripcion: "",
    },
  });

  useEffect(() => {
    if (datosIniciales) {
      form.reset({
        nombre: datosIniciales.nombre,
        descripcion: datosIniciales.descripcion || "",
      });
    }
  }, [datosIniciales, form]);

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(alEnviar)} className="space-y-4">
        <FormField
          control={form.control}
          name="nombre"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Nombre</FormLabel>
              <FormControl>
                <Input placeholder="Ej: Electrónica" {...field} />
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
                <Textarea
                  placeholder="Descripción opcional"
                  className="resize-none"
                  {...field}
                />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        <div className="flex justify-end gap-3 pt-4">
          <Button type="button" variant="outline" onClick={alCancelar}>
            Cancelar
          </Button>
          <Button type="submit" disabled={cargando}>
            {datosIniciales ? "Actualizar" : "Crear"}
          </Button>
        </div>
      </form>
    </Form>
  );
}
