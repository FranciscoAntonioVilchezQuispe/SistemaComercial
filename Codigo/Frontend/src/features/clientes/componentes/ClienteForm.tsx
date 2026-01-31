import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import * as z from "zod";
import { useCrearCliente, useActualizarCliente } from "../hooks/useClientes";
import { Cliente, ClienteFormData } from "../types/cliente.types";
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
  idTipoCliente: z.coerce.number().optional(),
  limiteCredito: z.coerce.number().optional(),
  diasCredito: z.coerce.number().int().optional(),
  idListaPrecioAsignada: z.coerce.number().optional(),
});

interface ClienteFormProps {
  cliente?: Cliente;
  onSuccess: () => void;
  onCancel: () => void;
}

export function ClienteForm({
  cliente,
  onSuccess,
  onCancel,
}: ClienteFormProps) {
  const crear = useCrearCliente();
  const actualizar = useActualizarCliente();

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
      idTipoCliente: 0,
      limiteCredito: 0,
      diasCredito: 0,
      idListaPrecioAsignada: 0,
    },
  });

  useEffect(() => {
    if (cliente) {
      form.reset({
        idTipoDocumento: cliente.idTipoDocumento,
        numeroDocumento: cliente.numeroDocumento,
        razonSocial: cliente.razonSocial,
        nombreComercial: cliente.nombreComercial || "",
        direccion: cliente.direccion || "",
        telefono: cliente.telefono || "",
        email: cliente.email || "",
        idTipoCliente: cliente.idTipoCliente || 0,
        limiteCredito: cliente.limiteCredito || 0,
        diasCredito: cliente.diasCredito || 0,
        idListaPrecioAsignada: cliente.idListaPrecioAsignada || 0,
      });
    }
  }, [cliente, form]);

  const onSubmit = (values: z.infer<typeof formSchema>) => {
    const data: ClienteFormData = {
      ...values,
      idTipoCliente: values.idTipoCliente || undefined,
      limiteCredito: values.limiteCredito || undefined,
      diasCredito: values.diasCredito || undefined,
      idListaPrecioAsignada: values.idListaPrecioAsignada || undefined,
      nombreComercial: values.nombreComercial || undefined,
      direccion: values.direccion || undefined,
      telefono: values.telefono || undefined,
      email: values.email || undefined,
    };

    if (cliente) {
      actualizar.mutate(
        { id: cliente.id, data },
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
                  <FormLabel>Razón Social / Nombres</FormLabel>
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

          <FormField
            control={form.control}
            name="idTipoCliente"
            render={({ field }) => (
              <SelectorCatalogo
                codigo="TIPO_CLIENTE"
                label="Tipo Cliente"
                value={field.value || 0}
                onChange={(val) => field.onChange(Number(val))}
                placeholder="Seleccione Tipo"
              />
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

          <FormField
            control={form.control}
            name="limiteCredito"
            render={({ field }) => (
              <FormItem>
                <FormLabel>Límite Crédito</FormLabel>
                <FormControl>
                  <Input {...field} type="number" step="0.01" />
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />

          <FormField
            control={form.control}
            name="diasCredito"
            render={({ field }) => (
              <FormItem>
                <FormLabel>Días Crédito</FormLabel>
                <FormControl>
                  <Input {...field} type="number" />
                </FormControl>
                <FormMessage />
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
