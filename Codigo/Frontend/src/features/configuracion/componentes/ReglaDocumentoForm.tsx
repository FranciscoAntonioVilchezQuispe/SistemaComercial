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
import { Switch } from "@/components/ui/switch";
import { ReglaDocumento } from "@configuracion/services/reglasDocumentoService";

const formSchema = z.object({
  id: z.number().optional(),
  codigo: z.string().min(1, "El código es requerido").max(10),
  nombre: z.string().min(1, "El nombre es requerido").max(100),
  longitud: z.coerce.number().min(1, "La longitud debe ser al menos 1"),
  esNumerico: z.boolean().default(true),
  estado: z.boolean().default(true),
  activado: z.boolean().default(true),
});

type ReglaFormData = z.infer<typeof formSchema>;

interface Props {
  datosIniciales?: ReglaDocumento;
  alEnviar: (datos: ReglaFormData) => void;
  alCancelar: () => void;
  cargando?: boolean;
}

export function ReglaDocumentoForm({
  datosIniciales,
  alEnviar,
  alCancelar,
  cargando,
}: Props) {
  const form = useForm<ReglaFormData>({
    resolver: zodResolver(formSchema),
    defaultValues: datosIniciales || {
      codigo: "",
      nombre: "",
      longitud: 8,
      esNumerico: true,
      estado: true,
      activado: true,
    },
  });

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(alEnviar)} className="space-y-4">
        <div className="grid grid-cols-2 gap-4">
          <FormField
            control={form.control}
            name="codigo"
            render={({ field }) => (
              <FormItem>
                <FormLabel>Código SUNAT</FormLabel>
                <FormControl>
                  <Input placeholder="Ej. 1, 6" {...field} />
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
                <FormLabel>Nombre de Documento</FormLabel>
                <FormControl>
                  <Input placeholder="Ej. DNI, RUC" {...field} />
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />
        </div>

        <FormField
          control={form.control}
          name="longitud"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Longitud Exacta</FormLabel>
              <FormControl>
                <Input type="number" {...field} />
              </FormControl>
              <FormDescription>
                Cantidad de caracteres que debe tener el documento.
              </FormDescription>
              <FormMessage />
            </FormItem>
          )}
        />

        <div className="grid grid-cols-2 gap-4">
          <FormField
            control={form.control}
            name="esNumerico"
            render={({ field }) => (
              <FormItem className="flex flex-row items-center justify-between rounded-lg border p-3 shadow-sm">
                <div className="space-y-0.5">
                  <FormLabel>Solo Números</FormLabel>
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

          <FormField
            control={form.control}
            name="activado"
            render={({ field }) => (
              <FormItem className="flex flex-row items-center justify-between rounded-lg border p-3 shadow-sm">
                <div className="space-y-0.5">
                  <FormLabel>Registro Activo</FormLabel>
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
        </div>

        <div className="flex justify-end gap-2 pt-4">
          <Button type="button" variant="outline" onClick={alCancelar}>
            Cancelar
          </Button>
          <Button type="submit" disabled={cargando}>
            {cargando ? "Guardando..." : "Guardar Tipo"}
          </Button>
        </div>
      </form>
    </Form>
  );
}
