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
  FormDescription,
} from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Switch } from "@/components/ui/switch";
import { useEffect } from "react";
import { SelectorCatalogo } from "@/compartido/componentes/formularios/SelectorCatalogo";
import {
  useClientes,
  useCrearCliente,
} from "@/features/clientes/hooks/useClientes";
import { ClienteFormData } from "@/features/clientes/types/cliente.types";
import { toast } from "sonner";
import { limpiarSoloNumeros, limpiarGuiones } from "@/lib/i18n";

const formSchema = z.object({
  idTipoDocumento: z.coerce
    .number()
    .min(1, "Debe seleccionar un tipo de documento"),
  numeroDocumento: z.string().min(1, "El número de documento es requerido"),
  razonSocial: z.string().min(1, "La razón social es requerida"),
  nombreComercial: z.string().optional(),
  direccion: z.string().optional(),
  telefono: z
    .string()
    .regex(/^\d*$/, "El teléfono solo debe contener números")
    .optional(),
  email: z.string().email("Email inválido").optional().or(z.literal("")),
  paginaWeb: z.string().url("URL inválida").optional().or(z.literal("")),
  agregarACliente: z.boolean().default(true),
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
  const { data: clientes } = useClientes();
  const crearCliente = useCrearCliente();

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
      agregarACliente: true,
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
        agregarACliente: false,
      });
    }
  }, [proveedor, form]);

  const onSubmit = async (values: z.infer<typeof formSchema>) => {
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
            toast.success("Proveedor actualizado exitosamente");
            onSuccess();
          },
        },
      );
    } else {
      // Registrar Proveedor
      crear.mutate(data, {
        onSuccess: async () => {
          // Si el switch está activo, intentar registrar como cliente
          if (values.agregarACliente) {
            const clienteExistente = clientes?.find(
              (c) => c.numeroDocumento === values.numeroDocumento,
            );

            if (!clienteExistente) {
              const clienteData: ClienteFormData = {
                idTipoDocumento: values.idTipoDocumento,
                numeroDocumento: values.numeroDocumento,
                razonSocial: values.razonSocial,
                nombreComercial: values.nombreComercial || undefined,
                direccion: values.direccion || undefined,
                telefono: values.telefono || undefined,
                email: values.email || undefined,
              };

              try {
                await crearCliente.mutateAsync(clienteData);
                toast.success(
                  "Proveedor registrado y también agregado como cliente",
                );
              } catch (error) {
                console.error("Error al crear cliente:", error);
                toast.error(
                  "Proveedor registrado, pero hubo un error al crear el cliente",
                );
              }
            } else {
              toast.info(
                "Proveedor registrado. El cliente ya existía en la base de datos.",
              );
            }
          } else {
            toast.success("Proveedor registrado exitosamente");
          }

          // Limpiar campos para dejar uno nuevo
          form.reset({
            idTipoDocumento: 0,
            numeroDocumento: "",
            razonSocial: "",
            nombreComercial: "",
            direccion: "",
            telefono: "",
            email: "",
            paginaWeb: "",
            agregarACliente: true,
          });
          // No llamamos a onSuccess() para mantener el diálogo abierto
        },
        onError: () => {
          toast.error("Error al registrar el proveedor");
        },
      });
    }
  };

  const isPending =
    crear.isPending || actualizar.isPending || crearCliente.isPending;

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
                label="Tipo Documento *"
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
                <FormLabel>Nro. Documento *</FormLabel>
                <FormControl>
                  <Input
                    {...field}
                    onChange={(e) =>
                      field.onChange(limpiarGuiones(e.target.value))
                    }
                    placeholder="RUC / DNI"
                  />
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
                  <FormLabel>Razón Social *</FormLabel>
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
                  <Input
                    {...field}
                    onChange={(e) => {
                      field.onChange(limpiarSoloNumeros(e.target.value));
                    }}
                    placeholder="Solo números"
                  />
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

          {!proveedor && (
            <div className="md:col-span-2">
              <FormField
                control={form.control}
                name="agregarACliente"
                render={({ field }) => (
                  <FormItem className="flex flex-row items-center justify-between rounded-lg border p-3 shadow-sm bg-blue-50/50">
                    <div className="space-y-0.5">
                      <FormLabel className="text-blue-700">
                        Agregar a cliente
                      </FormLabel>
                      <FormDescription>
                        Crea un registro automático en el módulo de clientes con
                        estos datos.
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
          )}
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
