import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import * as z from "zod";
import { useCrearAlmacen, useActualizarAlmacen } from "../hooks/useAlmacenes";
import { useSucursales } from "@/features/configuracion/hooks/useSucursales";
import { Almacen, AlmacenFormData } from "../types/almacen.types";
import { Button } from "@/componentes/ui/button";
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
  FormDescription,
} from "@/componentes/ui/form";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/componentes/ui/select";
import { Input } from "@/componentes/ui/input";
import { Switch } from "@/componentes/ui/switch";
import { useEffect } from "react";

const formSchema = z.object({
  nombreAlmacen: z.string().min(1, "El nombre es requerido"),
  direccion: z.string().optional(),
  idSucursal: z.coerce.number().min(1, "La sucursal es requerida"),
  esPrincipal: z.boolean().default(false),
  activado: z.boolean().default(true),
});

interface AlmacenFormProps {
  almacen?: Almacen;
  onSuccess: () => void;
  onCancel: () => void;
}

export function AlmacenForm({
  almacen,
  onSuccess,
  onCancel,
}: AlmacenFormProps) {
  const crear = useCrearAlmacen();
  const actualizar = useActualizarAlmacen();
  const { data: sucursales } = useSucursales();

  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      nombreAlmacen: "",
      direccion: "",
      idSucursal: 0,
      esPrincipal: false,
      activado: true,
    },
  });

  useEffect(() => {
    if (almacen) {
      form.reset({
        nombreAlmacen: almacen.nombreAlmacen,
        direccion: almacen.direccion || "",
        idSucursal: almacen.idSucursal,
        esPrincipal: almacen.esPrincipal,
        activado: almacen.activado,
      });
    }
  }, [almacen, form]);

  const onSubmit = (values: z.infer<typeof formSchema>) => {
    const data: AlmacenFormData = {
      ...values,
      direccion: values.direccion || undefined,
    };

    if (almacen) {
      actualizar.mutate(
        { id: almacen.id, data },
        {
          onSuccess: () => {
            onSuccess();
          },
        },
      );
    } else {
      crear.mutate(data, {
        onSuccess: () => {
          onSuccess();
        },
      });
    }
  };

  const isPending = crear.isPending || actualizar.isPending;

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
        <FormField
          control={form.control}
          name="nombreAlmacen"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Nombre del Almacén</FormLabel>
              <FormControl>
                <Input {...field} placeholder="Ej. Almacén Central" />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />

        <FormField
          control={form.control}
          name="idSucursal"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Sucursal</FormLabel>
              <Select
                onValueChange={(val) => field.onChange(parseInt(val))}
                value={field.value?.toString()}
              >
                <FormControl>
                  <SelectTrigger>
                    <SelectValue placeholder="Seleccione una sucursal" />
                  </SelectTrigger>
                </FormControl>
                <SelectContent>
                  {sucursales?.map((s) => (
                    <SelectItem key={s.id} value={s.id.toString()}>
                      {s.nombreSucursal}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
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
                <Input {...field} placeholder="Ubicación física" />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />

        <div className="grid grid-cols-2 gap-4">
          <FormField
            control={form.control}
            name="esPrincipal"
            render={({ field }) => (
              <FormItem className="flex flex-row items-center justify-between rounded-lg border p-3 shadow-sm">
                <div className="space-y-0.5">
                  <FormLabel>Es Principal</FormLabel>
                  <FormDescription>
                    Marcar si es el almacén principal de la empresa.
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

          <FormField
            control={form.control}
            name="activado"
            render={({ field }) => (
              <FormItem className="flex flex-row items-center justify-between rounded-lg border p-3 shadow-sm">
                <div className="space-y-0.5">
                  <FormLabel>Activado</FormLabel>
                  <FormDescription>
                    Disponible para operaciones.
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
        </div>

        <div className="flex justify-end gap-2 pt-4">
          <Button type="button" variant="outline" onClick={onCancel}>
            Cancelar
          </Button>
          <Button type="submit" disabled={isPending}>
            {isPending ? "Guardando..." : "Guardar"}
          </Button>
        </div>
      </form>
    </Form>
  );
}
