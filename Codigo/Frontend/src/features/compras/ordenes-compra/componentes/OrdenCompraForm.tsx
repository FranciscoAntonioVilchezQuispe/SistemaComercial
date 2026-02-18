import React from "react";
import { useForm, useFieldArray } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import * as z from "zod";
import { CalendarIcon, Trash2, Plus, Check } from "lucide-react";
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
  PopoverAnchor,
} from "@/components/ui/popover";
import {
  Command,
  CommandEmpty,
  CommandGroup,
  CommandItem,
  CommandList,
} from "@/components/ui/command";
import { Calendar } from "@/components/ui/calendar";
import { Separator } from "@/components/ui/separator";
import { Textarea } from "@/components/ui/textarea";

import { useRegistrarOrdenCompra } from "../hooks/useOrdenesCompra";
import { useProveedores } from "@/features/compras/proveedores/hooks/useProveedores";
import { useAlmacenes } from "@/features/inventario/almacenes/hooks/useAlmacenes";
import { useProductos } from "@/features/catalogo/hooks/useProductos";
import { APP_LOCALE, limpiarDecimal } from "@/lib/i18n";
import { SelectorProveedorV2 } from "@/compartido/componentes/formularios/SelectorProveedorV2";
import { EstadoOrdenCompra } from "../../constantes";

const ordenCompraSchema = z.object({
  codigoOrden: z.string().min(1, "Código requerido"),
  idProveedor: z.coerce.number().min(1, "Seleccione un proveedor"),
  idAlmacenDestino: z.coerce.number().min(1, "Seleccione un almacén"),
  fechaEmision: z.date(),
  fechaEntregaEstimada: z.date().optional(),
  idEstado: z.coerce.number().optional().default(EstadoOrdenCompra.Pendiente),
  observaciones: z.string().optional(),
  detalles: z
    .array(
      z.object({
        idProducto: z.coerce.number().min(1, "Producto requerido"),
        cantidadSolicitada: z.coerce.number().min(0.01, "Cantidad inválida"),
        precioUnitarioPactado: z.coerce.number().min(0, "Precio inválido"),
      }),
    )
    .min(1, "Debe agregar al menos un producto"),
});

type OrdenCompraFormValues = z.infer<typeof ordenCompraSchema>;

interface OrdenCompraFormProps {
  onSuccess: () => void;
  onCancel: () => void;
}

const ProductInput = ({
  value,
  onChange,
  productos,
  placeholder = "Buscar producto...",
  onSearch,
}: {
  value: number;
  onChange: (id: number) => void;
  productos: any[];
  placeholder?: string;
  onSearch: (term: string) => void;
}) => {
  const [open, setOpen] = React.useState(false);
  const [inputValue, setInputValue] = React.useState("");

  React.useEffect(() => {
    if (value) {
      const selected = productos.find((p) => p.id === value);
      if (selected) {
        setInputValue(selected.nombre);
      }
    }
  }, [value, productos]);

  const handleKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === "Enter") {
      if (open) return;
      e.preventDefault();
      onSearch(inputValue);
      setOpen(true);
    }
  };

  return (
    <Command className="overflow-visible bg-transparent" shouldFilter={false}>
      <Popover open={open} onOpenChange={setOpen}>
        <PopoverAnchor asChild>
          <div className="relative w-full">
            <Input
              placeholder={placeholder}
              value={inputValue}
              onChange={(e) => {
                const newValue = e.target.value;
                setInputValue(newValue);
                if (newValue === "") {
                  onChange(0);
                  setOpen(false);
                }
              }}
              onKeyDown={handleKeyDown}
              className="pr-8"
            />
          </div>
        </PopoverAnchor>
        <PopoverContent
          className="w-[300px] p-0"
          align="start"
          onOpenAutoFocus={(e) => e.preventDefault()}
        >
          <CommandList>
            <CommandEmpty>Presiona Enter para buscar.</CommandEmpty>
            <CommandGroup>
              {productos.map((producto) => (
                <CommandItem
                  key={producto.id}
                  value={producto.id.toString()}
                  onSelect={() => {
                    onChange(producto.id);
                    setInputValue(producto.nombre);
                    setOpen(false);
                  }}
                >
                  <Check
                    className={cn(
                      "mr-2 h-4 w-4",
                      value === producto.id ? "opacity-100" : "opacity-0",
                    )}
                  />
                  {producto.nombre}
                </CommandItem>
              ))}
            </CommandGroup>
          </CommandList>
        </PopoverContent>
      </Popover>
    </Command>
  );
};

export function OrdenCompraForm({ onSuccess, onCancel }: OrdenCompraFormProps) {
  const registrar = useRegistrarOrdenCompra();
  const [terminoBusqueda, setTerminoBusqueda] = React.useState("");
  const [busquedaProveedor, setBusquedaProveedor] = React.useState("");

  // Only fetch when search term is present or initial load if needed
  const { data: proveedores = [], refetch: buscarProveedores } = useProveedores(
    busquedaProveedor,
    false,
  );

  const { data: almacenes } = useAlmacenes();
  const { data: productosData } = useProductos({
    pageNumber: 1,
    pageSize: 50,
    search: terminoBusqueda,
  });
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
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
          <FormField
            control={form.control}
            name="codigoOrden"
            render={({ field }) => (
              <FormItem>
                <FormLabel>Código Orden</FormLabel>
                <FormControl>
                  <Input
                    {...field}
                    placeholder="OC-00000000"
                    disabled
                    className="bg-muted font-bold"
                  />
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />

          <FormField
            control={form.control}
            name="idProveedor"
            render={({ field }) => (
              <FormItem className="col-span-3">
                <FormLabel>Proveedor</FormLabel>
                <SelectorProveedorV2
                  value={field.value}
                  onChange={(p) => field.onChange(p?.id || 0)}
                  proveedores={proveedores}
                  onSearch={handleSearchProveedor}
                />
                <FormMessage />
              </FormItem>
            )}
          />

          <FormField
            control={form.control}
            name="idAlmacenDestino"
            render={({ field }) => (
              <FormItem>
                <FormLabel>Almacén Destino</FormLabel>
                <FormControl>
                  <select
                    className="flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm transition-colors file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50"
                    value={field.value}
                    onChange={(e) => field.onChange(Number(e.target.value))}
                  >
                    <option value={0}>Seleccione Almacén</option>
                    {almacenes?.map((a) => (
                      <option key={a.id} value={a.id}>
                        {a.nombreAlmacen}
                      </option>
                    ))}
                  </select>
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />

          <FormField
            control={form.control}
            name="fechaEmision"
            render={({ field }) => (
              <FormItem className="flex flex-col mt-2">
                <FormLabel>Fecha Emisión</FormLabel>
                <Popover>
                  <PopoverTrigger asChild>
                    <FormControl>
                      <Button
                        variant={"outline"}
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
                        date > new Date() || date < new Date("1900-01-01")
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
              <FormItem className="flex flex-col mt-2">
                <FormLabel>Entrega Estimada</FormLabel>
                <Popover>
                  <PopoverTrigger asChild>
                    <FormControl>
                      <Button
                        variant={"outline"}
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
                className="grid grid-cols-12 gap-2 mb-2 items-end"
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
                        <ProductInput
                          value={field.value}
                          onChange={(id) => field.onChange(id)}
                          productos={productos}
                          onSearch={setTerminoBusqueda}
                        />
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
                        productos.find(
                          (p) =>
                            p.id === form.watch(`detalles.${index}.idProducto`),
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
                  >
                    <Trash2 className="h-4 w-4 text-destructive" />
                  </Button>
                </div>
              </div>
            ))}

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
                <Textarea {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />

        <div className="flex justify-end gap-2 pt-4">
          <Button type="button" variant="outline" onClick={onCancel}>
            Cancelar
          </Button>
          <Button type="submit" disabled={registrar.isPending}>
            {registrar.isPending ? "Procesando..." : "Guardar Orden"}
          </Button>
        </div>
      </form>
    </Form>
  );
}
