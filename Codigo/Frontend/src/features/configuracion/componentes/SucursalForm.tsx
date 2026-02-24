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
import { Sucursal, SucursalFormData } from "../tipos/sucursal.types";
import { useEmpresa } from "../hooks/useEmpresa";

const schema = z.object({
  idEmpresa: z.coerce.number(),
  nombreSucursal: z.string().min(1, "El nombre es requerido"),
  direccion: z.string().optional().nullable(),
  telefono: z.string().optional().nullable(),
  esPrincipal: z.boolean().default(false),
  activado: z.boolean().default(true),
});

interface SucursalFormProps {
  datosIniciales?: Sucursal;
  alEnviar: (datos: SucursalFormData) => void;
  alCancelar: () => void;
  cargando: boolean;
}

export function SucursalForm({
  datosIniciales,
  alEnviar,
  alCancelar,
  cargando,
}: SucursalFormProps) {
  const { data: empresa } = useEmpresa();

  const form = useForm<z.infer<typeof schema>>({
    resolver: zodResolver(schema),
    defaultValues: {
      idEmpresa: empresa?.id || 0,
      nombreSucursal: "",
      direccion: "",
      telefono: "",
      esPrincipal: false,
      activado: true,
    },
  });

  useEffect(() => {
    if (datosIniciales) {
      form.reset({
        idEmpresa: datosIniciales.idEmpresa,
        nombreSucursal: datosIniciales.nombreSucursal,
        direccion: datosIniciales.direccion || "",
        telefono: datosIniciales.telefono || "",
        esPrincipal: datosIniciales.esPrincipal,
        activado: datosIniciales.activado,
      });
    } else if (empresa) {
      form.setValue("idEmpresa", empresa.id);
    }
  }, [datosIniciales, empresa, form]);

  const onSubmit = (values: z.infer<typeof schema>) => {
    alEnviar({
      idEmpresa: values.idEmpresa,
      nombreSucursal: values.nombreSucursal,
      direccion: values.direccion || null,
      telefono: values.telefono || null,
      esPrincipal: values.esPrincipal,
      activado: values.activado,
    });
  };

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
        {/* Hidden Empresa ID */}
        <input type="hidden" {...form.register("idEmpresa")} />

        <FormField
          control={form.control}
          name="nombreSucursal"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Nombre de Sucursal</FormLabel>
              <FormControl>
                <Input placeholder="Sede Principal" {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />

        <FormField
          control={form.control}
          name="direccion"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Dirección</FormLabel>
              <FormControl>
                <Input
                  placeholder="Av. Ejemplo 123"
                  {...field}
                  value={field.value || ""}
                />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />

        <FormField
          control={form.control}
          name="telefono"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Teléfono</FormLabel>
              <FormControl>
                <Input
                  placeholder="01 2345678"
                  {...field}
                  value={field.value || ""}
                />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />

        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 pt-2">
          <FormField
            control={form.control}
            name="esPrincipal"
            render={({ field }) => (
              <FormItem className="flex flex-row items-center justify-between rounded-lg border p-3">
                <div className="space-y-0.5">
                  <FormLabel>Es Sucursal Principal</FormLabel>
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
              <FormItem className="flex flex-row items-center justify-between rounded-lg border p-3">
                <div className="space-y-0.5">
                  <FormLabel>Estado Activo</FormLabel>
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
