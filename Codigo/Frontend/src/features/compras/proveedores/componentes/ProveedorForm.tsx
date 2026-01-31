import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import * as z from "zod";
import {
  useCrearProveedor,
  useActualizarProveedor,
} from "../hooks/useProveedores";
import { Proveedor, ProveedorFormData } from "../types/proveedor.types";
import { Button } from "@/components/ui/button";
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { useEffect } from "react";
import { SelectorCatalogo } from "@/compartido/componentes/formularios/SelectorCatalogo";

const formSchema = z.object({
  idTipoDocumento: z.coerce
    .number()
    .min(1, "Debe seleccionar un tipo de documento"),
  numeroDocumento: z.string().min(1, "El número de documento es requerido"),
  razonSocial: z.string().min(1, "La razón social es requerida"),
  nombreComercial: z.string().optional(),
  direccion: z.string().optional(),
  telefono: z.string().optional(),
  email: z.string().email("Email inválido").optional().or(z.literal("")),
  paginaWeb: z.string().url("URL inválida").optional().or(z.literal("")),
});

interface ProveedorFormProps {
  proveedor?: Proveedor;
  onSuccess: () => void;
  onCancel: () => void;
}

export function ProveedorForm({
  proveedor,
  onSuccess,
  onCancel,
}: ProveedorFormProps) {
  const crear = useCrearProveedor();
  const actualizar = useActualizarProveedor();

  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      idTipoDocumento: 0,
      numeroDocumento: "",
      razonSocial: "",
      nombreComercial: "",
      direccion: "",
      telefono: "",
      email: "",
      paginaWeb: "",
    },
  });

  useEffect(() => {
    if (proveedor) {
      form.reset({
        idTipoDocumento: proveedor.idTipoDocumento,
        numeroDocumento: proveedor.numeroDocumento,
        razonSocial: proveedor.razonSocial,
        nombreComercial: proveedor.nombreComercial || "",
        direccion: proveedor.direccion || "",
        telefono: proveedor.telefono || "",
        email: proveedor.email || "",
        paginaWeb: proveedor.paginaWeb || "",
      });
    }
  }, [proveedor, form]);

  const onSubmit = (values: z.infer<typeof formSchema>) => {
    const data: ProveedorFormData = {
      ...values,
      nombreComercial: values.nombreComercial || undefined,
      direccion: values.direccion || undefined,
      telefono: values.telefono || undefined,
      email: values.email || undefined,
      paginaWeb: values.paginaWeb || undefined,
    };

    if (proveedor) {
      actualizar.mutate(
        { id: proveedor.id, data },
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
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <FormField
            control={form.control}
            name="idTipoDocumento"
            render={({ field }) => (
              <SelectorCatalogo
                codigo="TIPO_DOCUMENTO"
                label="Tipo Documento"
                value={field.value}
                onChange={(val) => field.onChange(Number(val))}
                placeholder="Seleccione Tipo Doc."
              />
            )}
          />

          <FormField
            control={form.control}
            name="numeroDocumento"
            render={({ field }) => (
              <FormItem>
                <FormLabel>Nro. Documento</FormLabel>
                <FormControl>
                  <Input {...field} placeholder="RUC / DNI" />
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />

          <div className="md:col-span-2">
            <FormField
              control={form.control}
              name="razonSocial"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Razón Social</FormLabel>
                  <FormControl>
                    <Input {...field} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
          </div>

          <FormField
            control={form.control}
            name="nombreComercial"
            render={({ field }) => (
              <FormItem>
                <FormLabel>Nombre Comercial</FormLabel>
                <FormControl>
                  <Input {...field} />
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />

          <div className="md:col-span-2">
            <FormField
              control={form.control}
              name="direccion"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Dirección</FormLabel>
                  <FormControl>
                    <Input {...field} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
          </div>

          <FormField
            control={form.control}
            name="telefono"
            render={({ field }) => (
              <FormItem>
                <FormLabel>Teléfono</FormLabel>
                <FormControl>
                  <Input {...field} />
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />

          <FormField
            control={form.control}
            name="email"
            render={({ field }) => (
              <FormItem>
                <FormLabel>Email</FormLabel>
                <FormControl>
                  <Input {...field} type="email" />
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />

          <div className="md:col-span-2">
            <FormField
              control={form.control}
              name="paginaWeb"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Página Web</FormLabel>
                  <FormControl>
                    <Input {...field} placeholder="https://example.com" />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
          </div>
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
