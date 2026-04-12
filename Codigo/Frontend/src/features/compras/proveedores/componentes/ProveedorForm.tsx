import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import * as z from "zod";
import {
  useCrearProveedor,
  useActualizarProveedor,
} from "../hooks/useProveedores";
import { Proveedor, ProveedorFormData } from "../types/proveedor.types";
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
import { Input } from "@/componentes/ui/input";
import { Switch } from "@/componentes/ui/switch";
import { useEffect, useMemo } from "react";
import { SelectorTipoDocumento } from "@/compartido/componentes/formularios/SelectorTipoDocumento";
import {
  useClientes,
  useCrearCliente,
} from "@/features/clientes/hooks/useClientes";
import { ClienteFormData } from "@/features/clientes/types/cliente.types";
import { toast } from "sonner";
import { limpiarSoloNumeros } from "@compartido/utilidades";
import { useReglasDocumentos } from "@/configuracion/hooks/useReglasDocumentos";
import { motion } from "framer-motion";
import { Search, ShieldCheck } from "lucide-react";
import { Badge } from "@/componentes/ui/badge";
import { UbigeoSelector } from "@/componentes/shared/UbigeoSelector";

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
  
  // SUNAT
  ubigeo: z.string().max(6, "Máximo 6 caracteres").optional().or(z.literal("")),
  condicionSunat: z.string().optional(),
  estadoSunat: z.string().optional(),
  esAgenteRetencion: z.boolean().default(false),
  esBuenContribuyente: z.boolean().default(false),
  esAgentePercepcion: z.boolean().default(false),
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
  const { data: configReglas } = useReglasDocumentos();

  const rulesMap = useMemo(() => {
    if (!configReglas?.reglas) return {};
    return configReglas.reglas.reduce((acc: any, curr) => {
      if (curr.id) acc[curr.id.toString()] = curr;
      return acc;
    }, {});
  }, [configReglas]);

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
      ubigeo: "",
      condicionSunat: "HABIDO",
      estadoSunat: "ACTIVO",
      esAgenteRetencion: false,
      esBuenContribuyente: false,
      esAgentePercepcion: false,
    },
  });

  const selectedTipoDocId = form.watch("idTipoDocumento");
  const activeRule = rulesMap[selectedTipoDocId.toString()];

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
        ubigeo: proveedor.ubigeo || "",
        condicionSunat: proveedor.condicionSunat || "HABIDO",
        estadoSunat: proveedor.estadoSunat || "ACTIVO",
        esAgenteRetencion: proveedor.esAgenteRetencion || false,
        esBuenContribuyente: proveedor.esBuenContribuyente || false,
        esAgentePercepcion: proveedor.esAgentePercepcion || false,
      });
    }
  }, [proveedor, form]);

  const onSubmit = async (values: z.infer<typeof formSchema>) => {
    // Validar longitud mínima si existe en la regla
    if (activeRule?.longitud && values.numeroDocumento.length < activeRule.longitud) {
        toast.error(`El documento para ${activeRule.nombre} debe tener al menos ${activeRule.longitud} caracteres`);
        return;
    }

    const data: ProveedorFormData = {
      ...values,
      nombreComercial: values.nombreComercial || undefined,
      direccion: values.direccion || undefined,
      telefono: values.telefono || undefined,
      email: values.email || undefined,
      paginaWeb: values.paginaWeb || undefined,
      ubigeo: values.ubigeo,
      condicionSunat: values.condicionSunat,
      estadoSunat: values.estadoSunat,
      esAgenteRetencion: values.esAgenteRetencion,
      esAgentePercepcion: values.esAgentePercepcion,
      esBuenContribuyente: values.esBuenContribuyente,
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
            const clienteExistente = clientes?.datos?.find(
              (c: any) => c.numeroDocumento === values.numeroDocumento,
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
                idTipoCliente: values.idTipoDocumento === 1 ? 1 : 2, // 1: DNI (Persona), 2: RUC/Otros (Empresa)
                activado: true,
                ubigeo: values.ubigeo,
                condicionSunat: values.condicionSunat,
                estadoSunat: values.estadoSunat,
                esAgenteRetencion: values.esAgenteRetencion,
                esAgentePercepcion: values.esAgentePercepcion,
                esBuenContribuyente: values.esBuenContribuyente,
              };

              try {
                await crearCliente.mutateAsync(clienteData);
                toast.success(
                  "Proveedor registrado y también agregado como cliente",
                );
              } catch (error) {
                console.error("Error al crear cliente:", error);
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
            ubigeo: "",
            condicionSunat: "HABIDO",
            estadoSunat: "ACTIVO",
            esAgenteRetencion: false,
            esBuenContribuyente: false,
            esAgentePercepcion: false,
          });
          // No llamamos a onSuccess() para mantener el diálogo abierto
        },
        onError: (error) => {
          console.error("Error al registrar el proveedor:", error);
        },
      });
    }
  };

  const isPending =
    crear.isPending || actualizar.isPending || crearCliente.isPending;

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
          <FormField
            control={form.control}
            name="idTipoDocumento"
            render={({ field }) => (
              <SelectorTipoDocumento
                label="Tipo Documento *"
                value={field.value}
                onChange={(val) => {
                  field.onChange(Number(val));
                  form.setValue("numeroDocumento", "");
                }}
                placeholder="Tipo"
              />
            )}
          />

          <FormField
            control={form.control}
            name="numeroDocumento"
            render={({ field }) => (
              <FormItem>
                <FormLabel>Nro. Documento *</FormLabel>
                <div className="flex gap-2">
                  <FormControl>
                    <Input
                      {...field}
                      className="font-mono text-lg tracking-wider"
                      maxLength={activeRule?.longitudMaxima || activeRule?.longitud}
                      onChange={(e) => {
                        const val = activeRule?.esNumerico
                          ? limpiarSoloNumeros(e.target.value)
                          : e.target.value;
                        field.onChange(val);
                      }}
                      placeholder="Número"
                    />
                  </FormControl>
                  {field.value.length >= 8 && (
                    <Button 
                      type="button" 
                      variant="secondary" 
                      size="icon" 
                      title="Consultar SUNAT"
                      className="shrink-0"
                      onClick={() => {
                        if (field.value.length === 11) {
                          form.setValue("condicionSunat", "HABIDO");
                          form.setValue("estadoSunat", "ACTIVO");
                        }
                      }}
                    >
                      <Search className="h-4 w-4" />
                    </Button>
                  )}
                </div>
                <FormMessage />
              </FormItem>
            )}
          />

          <div className="md:col-span-2">
            <FormField
              control={form.control}
              name="nombreComercial"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Nombre Comercial</FormLabel>
                  <FormControl>
                    <Input {...field} placeholder="Opcional" />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
          </div>

          <div className="md:col-span-4">
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

          <div className="md:col-span-4">
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

          <div className="md:col-span-1">
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
          </div>

          <div className="md:col-span-1">
            <FormField
              control={form.control}
              name="email"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Email</FormLabel>
                  <FormControl>
                    <Input {...field} type="email" placeholder="correo@ejemplo.com" />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
          </div>

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

          {/* Sección SUNAT PREMIUM - COMPACTA */}
          <div className="md:col-span-4 mt-2">
            <motion.div 
              initial={{ opacity: 0, scale: 0.98 }}
              animate={{ opacity: 1, scale: 1 }}
              className="rounded-xl border border-blue-100 bg-blue-50/20 p-3 dark:border-blue-900/30 dark:bg-blue-900/10"
            >
              <div className="flex items-center gap-2 mb-3 text-blue-700 dark:text-blue-400">
                <ShieldCheck className="h-4 w-4" />
                <h3 className="font-bold text-[11px] uppercase tracking-widest">Información SUNAT UBL 2.1</h3>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-4 gap-3">
                <FormField
                  control={form.control}
                  name="ubigeo"
                  render={({ field }) => (
                    <FormItem className="md:col-span-4">
                      <FormLabel className="text-[10px] uppercase font-black opacity-60">Ubigeo INEI (Dpto / Prov / Dist)</FormLabel>
                      <FormControl>
                        <UbigeoSelector 
                          value={field.value} 
                          onValueChange={field.onChange} 
                        />
                      </FormControl>
                    </FormItem>
                  )}
                />

                <FormField
                  control={form.control}
                  name="estadoSunat"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel className="text-[10px] uppercase font-black opacity-60">Estado</FormLabel>
                      <div className="flex items-center h-9 px-2 rounded-md bg-white border border-blue-100 dark:bg-slate-950 dark:border-blue-900/30">
                        <Badge variant={field.value === 'ACTIVO' ? 'secondary' : 'destructive'} className="text-[10px] py-0 px-2 h-5">
                          {field.value || 'N/A'}
                        </Badge>
                      </div>
                    </FormItem>
                  )}
                />

                <FormField
                  control={form.control}
                  name="condicionSunat"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel className="text-[10px] uppercase font-black opacity-60">Condición</FormLabel>
                      <div className="flex items-center h-9 px-2 rounded-md bg-white border border-blue-100 dark:bg-slate-950 dark:border-blue-900/30">
                        <Badge variant={field.value === 'HABIDO' ? 'outline' : 'secondary'} className="text-[10px] border-blue-200 text-blue-700 py-0 px-2 h-5">
                          {field.value || 'N/A'}
                        </Badge>
                      </div>
                    </FormItem>
                  )}
                />

                <div className="md:col-span-4 grid grid-cols-3 gap-2 pt-2 border-t border-blue-100/50 dark:border-blue-900/10">
                  <FormField
                    control={form.control}
                    name="esAgenteRetencion"
                    render={({ field }) => (
                      <FormItem className="flex items-center gap-2 space-y-0">
                        <FormControl>
                          <Switch checked={field.value} onCheckedChange={field.onChange} className="scale-75" />
                        </FormControl>
                        <FormLabel className="text-[9px] uppercase font-bold text-blue-800/70 dark:text-blue-300">Retención</FormLabel>
                      </FormItem>
                    )}
                  />
                  <FormField
                    control={form.control}
                    name="esAgentePercepcion"
                    render={({ field }) => (
                      <FormItem className="flex items-center gap-2 space-y-0">
                        <FormControl>
                          <Switch checked={field.value} onCheckedChange={field.onChange} className="scale-75" />
                        </FormControl>
                        <FormLabel className="text-[9px] uppercase font-bold text-blue-800/70 dark:text-blue-300">Percepción</FormLabel>
                      </FormItem>
                    )}
                  />
                  <FormField
                    control={form.control}
                    name="esBuenContribuyente"
                    render={({ field }) => (
                      <FormItem className="flex items-center gap-2 space-y-0">
                        <FormControl>
                          <Switch checked={field.value} onCheckedChange={field.onChange} className="scale-75" />
                        </FormControl>
                        <FormLabel className="text-[9px] uppercase font-bold text-blue-800/70 dark:text-blue-300">Buen Contrib.</FormLabel>
                      </FormItem>
                    )}
                  />
                </div>
              </div>
            </motion.div>
          </div>

          {!proveedor && (
            <div className="md:col-span-4">
              <FormField
                control={form.control}
                name="agregarACliente"
                render={({ field }) => (
                  <FormItem className="flex flex-row items-center justify-between rounded-lg border p-2 shadow-sm bg-blue-50/10">
                    <div className="flex flex-col">
                      <FormLabel className="text-blue-700 text-xs">Agregar a cliente</FormLabel>
                      <FormDescription className="text-[10px] -mt-1">Crea un registro automático en clientes.</FormDescription>
                    </div>
                    <FormControl>
                      <Switch checked={field.value} onCheckedChange={field.onChange} className="scale-90" />
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
