import React from "react";
import { useForm, useFieldArray } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import * as z from "zod";
import { CalendarIcon, Trash2, Plus, ShoppingBag } from "lucide-react";
import { format } from "date-fns";
import { toast } from "sonner";

import { cn } from "@/lib/utils";
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
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from "@/components/ui/popover";
import { Calendar } from "@/components/ui/calendar";
import { Separator } from "@/components/ui/separator";
import { Textarea } from "@/components/ui/textarea";

import { SelectorProducto } from "@/compartido/componentes/formularios/SelectorProducto";

import { useRegistrarOrdenCompra } from "../hooks/useOrdenesCompra";
import { useProveedores } from "@/features/compras/proveedores/hooks/useProveedores";
import { useAlmacenes } from "@/features/inventario/almacenes/hooks/useAlmacenes";
import { useProductos } from "@/features/catalogo/hooks/useProductos";
import { APP_LOCALE, limpiarDecimal } from "@compartido/utilidades";
import { SelectorProveedorV2 } from "@/compartido/componentes/formularios/SelectorProveedorV2";
import { EstadoOrdenCompra } from "../../constantes";
import { OrdenCompra } from "../types/ordenCompra.types";

const ordenCompraSchema = z.object({
  codigoOrden: z.string().min(1, "El código de orden es requerido"),
  idProveedor: z.coerce.number({
    invalid_type_error: "Seleccione un proveedor válido",
    required_error: "El proveedor es obligatorio",
  }).min(1, "Debe seleccionar un proveedor"),
  idAlmacenDestino: z.coerce.number({
    invalid_type_error: "Seleccione un almacén válido",
    required_error: "El almacén es obligatorio",
  }).min(1, "Debe seleccionar un almacén"),
  fechaEmision: z.date({
    required_error: "La fecha de emisión es obligatoria",
  }),
  fechaEntregaEstimada: z.date().optional(),
  idEstado: z.coerce.number().optional().default(EstadoOrdenCompra.Pendiente),
  observaciones: z.string().optional(),
  detalles: z
    .array(
      z.object({
        idProducto: z.coerce.number({
          invalid_type_error: "Producto no válido",
        }).min(1, "El producto es requerido"),
        cantidadSolicitada: z.coerce.number({
          invalid_type_error: "La cantidad debe ser un número",
        }).min(0.01, "La cantidad mínima es 0.01"),
        precioUnitarioPactado: z.coerce.number({
          invalid_type_error: "El precio debe ser un número",
        }).min(0, "El precio no puede ser negativo"),
      }),
    )
    .min(1, "Debe agregar al menos un producto a la orden"),
});

type OrdenCompraFormValues = z.infer<typeof ordenCompraSchema>;

interface OrdenCompraFormProps {
  onSuccess: () => void;
  onCancel: () => void;
  data?: OrdenCompra;
  readOnly?: boolean;
}


export function OrdenCompraForm({
  onSuccess,
  onCancel,
  data,
  readOnly = false,
}: OrdenCompraFormProps) {
  const registrar = useRegistrarOrdenCompra();
  const [terminoBusqueda, setTerminoBusqueda] = React.useState("");
  const [busquedaProveedor, setBusquedaProveedor] = React.useState("");

  // Only fetch when search term is present or initial load if needed
  const { data: qProveedores, refetch: buscarProveedores } = useProveedores(
    { search: busquedaProveedor, pageNumber: 1, pageSize: 100 },
    false,
  );
  const proveedores = qProveedores?.datos || [];

  const { data: qAlmacenes } = useAlmacenes();
  const almacenes = qAlmacenes?.datos || [];
  const { data: productosData } = useProductos(
    {
      pageNumber: 1,
      pageSize: 50,
      search: terminoBusqueda,
    },
    { enabled: !!terminoBusqueda },
  );
  const productos = productosData?.datos || [];

  const handleSearchProveedor = (term: string) => {
    setBusquedaProveedor(term);
    setTimeout(() => buscarProveedores(), 0);
  };

  const form = useForm<OrdenCompraFormValues>({
    resolver: zodResolver(ordenCompraSchema),
    defaultValues: {
      codigoOrden: "[AUTOGENERADO]",
      fechaEmision: new Date(),
      idEstado: EstadoOrdenCompra.Pendiente,
      idAlmacenDestino: 0,
      detalles: [
        { idProducto: 0, cantidadSolicitada: 1, precioUnitarioPactado: 0 },
      ],
    },
  });

  React.useEffect(() => {
    if (data) {
      form.reset({
        codigoOrden: data.codigoOrden,
        idProveedor: data.idProveedor,
        idAlmacenDestino: data.idAlmacenDestino,
        fechaEmision: new Date(data.fechaEmision),
        fechaEntregaEstimada: data.fechaEntregaEstimada
          ? new Date(data.fechaEntregaEstimada)
          : undefined,
        idEstado: data.idEstado,
        observaciones: data.observaciones || "",
        detalles: data.detalles.map((d) => ({
          idProducto: d.idProducto,
          cantidadSolicitada: d.cantidadSolicitada,
          precioUnitarioPactado: d.precioUnitarioPactado,
        })),
      });
    }
  }, [data, form]);

  React.useEffect(() => {
    if (almacenes && almacenes.length === 1) {
      form.setValue("idAlmacenDestino", almacenes[0].id);
    }
  }, [almacenes, form]);

  const { fields, append, remove } = useFieldArray({
    control: form.control,
    name: "detalles",
  });

  const onSubmit = (values: OrdenCompraFormValues) => {
    registrar.mutate(values, {
      onSuccess: () => {
        toast.success("Orden de compra guardada exitosamente");
        form.reset();
        onSuccess();
      },
    });
  };

  const totalCalculado = form.watch("detalles").reduce((acc, curr) => {
    return (
      acc +
      (Number(curr.cantidadSolicitada) || 0) *
        (Number(curr.precioUnitarioPactado) || 0)
    );
  }, 0);

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-6">
        {readOnly && data?.codigoOrden && (
          <div className="flex items-center justify-between gap-2 mb-2 bg-muted/50 p-4 rounded-lg border border-muted-foreground/10">
            <div className="flex items-center gap-3">
              <ShoppingBag className="h-6 w-6 text-primary" />
              <div>
                <h2 className="text-xl font-bold text-foreground">
                  Orden de Compra: {data.codigoOrden}
                </h2>
                <p className="text-xs text-muted-foreground uppercase tracking-widest font-semibold">
                  Visualización de documento
                </p>
              </div>
            </div>
            {data.idEstado && (
              <div className="flex flex-col items-end">
                <span className="text-[10px] uppercase font-bold text-muted-foreground mb-1">Estado</span>
                <div className="px-3 py-1 bg-primary/10 text-primary rounded-full text-xs font-bold border border-primary/20">
                  {data.idEstado === EstadoOrdenCompra.Pendiente ? "Pendiente" : 
                   data.idEstado === EstadoOrdenCompra.Aprobada ? "Aprobada" : "Rechazada"}
                </div>
              </div>
            )}
          </div>
        )}
        {/* FILA 1: Proveedor - Jerarquía Máxima */}
        <div className="grid grid-cols-1 gap-4">
          <FormField
            control={form.control}
            name="idProveedor"
            render={({ field }) => (
              <FormItem className="col-span-full">
                <FormLabel>Proveedor</FormLabel>
                {readOnly ? (
                  <Input
                    value={data?.razonSocialProveedor || `Prov. #${field.value}`}
                    readOnly
                    disabled
                    className="bg-muted font-medium"
                  />
                ) : (
                  <SelectorProveedorV2
                    value={field.value}
                    onChange={(p) => field.onChange(p?.id || 0)}
                    proveedores={proveedores}
                    onSearch={handleSearchProveedor}
                    disabled={readOnly}
                  />
                )}
                <FormMessage />
              </FormItem>
            )}
          />
        </div>

        {/* FILA 2: Datos Administrativos y de Control */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 items-end">
          <FormField
            control={form.control}
            name="idAlmacenDestino"
            render={({ field }) => (
              <FormItem>
                <FormLabel>Almacén Destino</FormLabel>
                <FormControl>
                  {readOnly ? (
                    <Input
                      value={data?.nombreAlmacen || `Almacén #${field.value}`}
                      readOnly
                      disabled
                      className="bg-muted font-medium"
                    />
                  ) : (
                    <select
                      className="flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm transition-colors file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50"
                      value={field.value}
                      onChange={(e) => field.onChange(Number(e.target.value))}
                      disabled={readOnly}
                    >
                      <option value={0}>Seleccione Almacén</option>
                      {almacenes?.map((a) => (
                        <option key={a.id} value={a.id}>
                          {a.nombreAlmacen}
                        </option>
                      ))}
                    </select>
                  )}
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />

          <FormField
            control={form.control}
            name="fechaEmision"
            render={({ field }) => (
              <FormItem className="flex flex-col">
                <FormLabel>Fecha Emisión</FormLabel>
                <Popover>
                  <PopoverTrigger asChild>
                    <FormControl>
                      <Button
                        variant={"outline"}
                        disabled={readOnly}
                        className={cn(
                          "w-full pl-3 text-left font-normal",
                          !field.value && "text-muted-foreground",
                        )}
                      >
                        {field.value ? (
                          format(field.value, "PPP", { locale: APP_LOCALE })
                        ) : (
                          <span>Seleccione fecha</span>
                        )}
                        <CalendarIcon className="ml-auto h-4 w-4 opacity-50" />
                      </Button>
                    </FormControl>
                  </PopoverTrigger>
                  <PopoverContent className="w-auto p-0" align="start">
                    <Calendar
                      mode="single"
                      selected={field.value}
                      onSelect={field.onChange}
                      locale={APP_LOCALE}
                      disabled={(date) =>
                        readOnly || date > new Date() || date < new Date("1900-01-01")
                      }
                    />
                  </PopoverContent>
                </Popover>
                <FormMessage />
              </FormItem>
            )}
          />

          <FormField
            control={form.control}
            name="fechaEntregaEstimada"
            render={({ field }) => (
              <FormItem className="flex flex-col">
                <FormLabel>Entrega Estimada</FormLabel>
                <Popover>
                  <PopoverTrigger asChild>
                    <FormControl>
                      <Button
                        variant={"outline"}
                        disabled={readOnly}
                        className={cn(
                          "w-full pl-3 text-left font-normal",
                          !field.value && "text-muted-foreground",
                        )}
                      >
                        {field.value ? (
                          format(field.value, "PPP", { locale: APP_LOCALE })
                        ) : (
                          <span>Sin fecha</span>
                        )}
                        <CalendarIcon className="ml-auto h-4 w-4 opacity-50" />
                      </Button>
                    </FormControl>
                  </PopoverTrigger>
                  <PopoverContent className="w-auto p-0" align="start">
                    <Calendar
                      mode="single"
                      selected={field.value}
                      onSelect={field.onChange}
                      locale={APP_LOCALE}
                      disabled={readOnly}
                    />
                  </PopoverContent>
                </Popover>
                <FormMessage />
              </FormItem>
            )}
          />
        </div>

        <Separator className="my-4" />

        <div className="space-y-4">
          <h3 className="text-lg font-medium">Items de la Orden</h3>
          <div className="border rounded-md p-4 bg-muted/20">
            {fields.map((field, index) => (
              <div
                key={field.id}
                className="grid grid-cols-12 gap-2 mb-2 items-start"
              >
                <div className="col-span-4">
                  <FormField
                    control={form.control}
                    name={`detalles.${index}.idProducto`}
                    render={({ field }) => (
                      <FormItem className="flex flex-col">
                        <FormLabel className={index !== 0 ? "sr-only" : ""}>
                          Producto
                        </FormLabel>
                        {readOnly ? (
                          <Input
                            value={data?.detalles[index]?.nombreProducto || `Prod. #${field.value}`}
                            readOnly
                            disabled
                            className="bg-muted font-medium"
                          />
                        ) : (
                          <SelectorProducto
                            value={field.value}
                            onChange={(id) => field.onChange(id)}
                            onProductSelect={(prod) => {
                              if (prod) {
                                form.setValue(
                                  `detalles.${index}.precioUnitarioPactado`,
                                  prod.precioVentaPublico || 0,
                                );
                              }
                            }}
                            productos={productos}
                            onSearch={setTerminoBusqueda}
                            disabled={readOnly}
                          />
                        )}
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                </div>

                <div className="col-span-1">
                  <div className="space-y-2">
                    <label
                      className={cn(
                        "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70",
                        index !== 0 ? "sr-only" : "",
                      )}
                    >
                      U.M.
                    </label>
                    <Input
                      className="bg-muted px-2 text-center h-9"
                      readOnly
                      disabled
                      value={
                        readOnly && data?.detalles[index]?.unidadMedidaSimbolo
                          ? data.detalles[index].unidadMedidaSimbolo
                          : productos.find(
                              (p) =>
                                p.id ===
                                form.watch(`detalles.${index}.idProducto`),
                            )?.unidadMedida?.simbolo || "-"
                      }
                    />
                  </div>
                </div>

                <div className="col-span-2">
                  <FormField
                    control={form.control}
                    name={`detalles.${index}.cantidadSolicitada`}
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel className={index !== 0 ? "sr-only" : ""}>
                          Cant.
                        </FormLabel>
                        <FormControl>
                          <Input
                            type="text"
                            {...field}
                            onChange={(e) =>
                              field.onChange(limpiarDecimal(e.target.value))
                            }
                            disabled={readOnly}
                          />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                </div>

                <div className="col-span-2">
                  <FormField
                    control={form.control}
                    name={`detalles.${index}.precioUnitarioPactado`}
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel className={index !== 0 ? "sr-only" : ""}>
                          Precio Pactado
                        </FormLabel>
                        <FormControl>
                          <Input
                            type="text"
                            {...field}
                            onChange={(e) =>
                              field.onChange(limpiarDecimal(e.target.value))
                            }
                            disabled={readOnly}
                          />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                </div>

                <div className="col-span-2">
                  <div className="space-y-2">
                    <label
                      className={cn(
                        "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70",
                        index !== 0 ? "sr-only" : "",
                      )}
                    >
                      Subtotal
                    </label>
                    <div className="h-9 flex items-center px-3 text-sm font-medium">
                      {(
                        form.watch(`detalles.${index}.cantidadSolicitada`) *
                        form.watch(`detalles.${index}.precioUnitarioPactado`)
                      ).toFixed(2)}
                    </div>
                  </div>
                </div>

                <div className="col-span-1">
                  <Button
                    variant="ghost"
                    size="icon"
                    type="button"
                    onClick={() => remove(index)}
                    disabled={readOnly}
                    className={cn("h-8 w-8", readOnly && "opacity-0 pointer-events-none")}
                  >
                    <Trash2 className="h-4 w-4 text-destructive" />
                  </Button>
                </div>
              </div>
            ))}

            {!readOnly && (
              <Button
                type="button"
                variant="outline"
                size="sm"
                onClick={() =>
                  append({
                    idProducto: 0,
                    cantidadSolicitada: 1,
                    precioUnitarioPactado: 0,
                  })
                }
                className="mt-2"
              >
                <Plus className="h-4 w-4 mr-2" /> Agregar Item
              </Button>
            )}
          </div>

          <div className="flex justify-end gap-4 text-xl font-bold">
            <span>Total:</span>
            <span>{totalCalculado.toFixed(2)}</span>
          </div>
        </div>

        <Separator className="my-4" />

        <FormField
          control={form.control}
          name="observaciones"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Observaciones</FormLabel>
              <FormControl>
                <Textarea {...field} disabled={readOnly} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />

        {!readOnly && (
          <div className="flex justify-end gap-2 pt-4">
            <Button type="button" variant="outline" onClick={onCancel}>
              Cancelar
            </Button>
            <Button type="submit" disabled={registrar.isPending}>
              {registrar.isPending ? "Procesando..." : "Guardar Orden"}
            </Button>
          </div>
        )}
      </form>
    </Form>
  );
}
