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
  FormDescription,
} from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Switch } from "@/componentes/ui/switch";
import { useEffect, useMemo } from "react";
import { SelectorTipoDocumento } from "@/compartido/componentes/formularios/SelectorTipoDocumento";
import { SelectorCatalogo } from "@/compartido/componentes/formularios/SelectorCatalogo";
import { useReglasDocumentos } from "@/configuracion/hooks/useReglasDocumentos";
import { limpiarSoloNumeros } from "@compartido/utilidades";
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
  telefono: z.string().optional(),
  email: z.string().email("Email inválido").optional().or(z.literal("")),
  idTipoCliente: z.coerce.number().optional(),
  limiteCredito: z.coerce.number().optional(),
  diasCredito: z.coerce.number().int().optional(),
  idListaPrecioAsignada: z.coerce.number().optional(),
  activado: z.boolean().default(true),
  
  // SUNAT
  ubigeo: z.string().max(6, "Máximo 6 caracteres").optional().or(z.literal("")),
  condicionSunat: z.string().optional(),
  estadoSunat: z.string().optional(),
  esAgenteRetencion: z.boolean().default(false),
  esBuenContribuyente: z.boolean().default(false),
  esAgentePercepcion: z.boolean().default(false),
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
      idTipoCliente: 0,
      limiteCredito: 0,
      diasCredito: 0,
      idListaPrecioAsignada: 0,
      activado: true,
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
        activado: cliente.activado ?? true,
        ubigeo: cliente.ubigeo || "",
        condicionSunat: cliente.condicionSunat || "HABIDO",
        estadoSunat: cliente.estadoSunat || "ACTIVO",
        esAgenteRetencion: cliente.esAgenteRetencion || false,
        esBuenContribuyente: cliente.esBuenContribuyente || false,
        esAgentePercepcion: cliente.esAgentePercepcion || false,
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
      activado: values.activado,
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
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-3">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-3">
          <FormField
            control={form.control}
            name="idTipoDocumento"
            render={({ field }) => (
              <SelectorTipoDocumento
                label="Tipo Documento"
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
                <FormLabel>Nro. Documento</FormLabel>
                <div className="flex gap-2">
                  <FormControl>
                    <Input 
                      {...field} 
                      placeholder="Número" 
                      className="font-mono text-lg tracking-wider"
                      maxLength={activeRule?.longitudMaxima || activeRule?.longitud}
                      onChange={(e) => {
                        const val = activeRule?.esNumerico
                          ? limpiarSoloNumeros(e.target.value)
                          : e.target.value;
                        field.onChange(val);
                      }}
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
              name="idTipoCliente"
              render={({ field }) => (
                <SelectorCatalogo
                  codigo="TIPO_CLIENTE"
                  label="Tipo Cliente"
                  value={field.value || 0}
                  onChange={(val) => {
                    const num = Number(val);
                    field.onChange(isNaN(num) ? 0 : num);
                  }}
                  placeholder="Seleccione Tipo"
                />
              )}
            />
          </div>

          <div className="md:col-span-4">
            <FormField
              control={form.control}
              name="razonSocial"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Razón Social / Nombres *</FormLabel>
                  <FormControl>
                    <Input {...field} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
          </div>

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
                  <Input {...field} placeholder="Número" />
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
                  <Input {...field} type="email" placeholder="correo@ejemplo.com" />
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
                <FormLabel>Límite Créd.</FormLabel>
                <FormControl>
                  <Input {...field} type="number" step="0.01" />
                </FormControl>
              </FormItem>
            )}
          />

          <FormField
            control={form.control}
            name="diasCredito"
            render={({ field }) => (
              <FormItem>
                <FormLabel>Días Créd.</FormLabel>
                <FormControl>
                  <Input {...field} type="number" />
                </FormControl>
              </FormItem>
            )}
          />

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

          <FormField
            control={form.control}
            name="activado"
            render={({ field }) => (
              <FormItem className="flex flex-row items-center justify-between rounded-lg border p-2 mt-1 md:col-span-4 bg-blue-50/5">
                <div className="flex flex-col">
                  <FormLabel className="text-xs">Estado Activo</FormLabel>
                  <FormDescription className="text-[10px] -mt-1">Permitir uso en operaciones.</FormDescription>
                </div>
                <FormControl>
                  <Switch checked={field.value} onCheckedChange={field.onChange} className="scale-75" />
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
