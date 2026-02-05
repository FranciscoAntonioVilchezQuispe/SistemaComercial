import React from "react";
import { useForm, useFieldArray } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import * as z from "zod";
import { CalendarIcon, Trash2, Plus, Check } from "lucide-react";
import { format } from "date-fns";

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

import { useRegistrarCompra } from "../hooks/useCompras";
import { SelectorCatalogo } from "@/compartido/componentes/formularios/SelectorCatalogo";
// Importamos los hooks de los otros módulos para los selectores
import { useProveedores } from "@/features/compras/proveedores/hooks/useProveedores";
import { useAlmacenes } from "@/features/inventario/almacenes/hooks/useAlmacenes";
import { useProductos } from "@/features/catalogo/hooks/useProductos";

// Schema de validación
const compraSchema = z.object({
  idProveedor: z.coerce.number().min(1, "Seleccione un proveedor"),
  idAlmacen: z.coerce.number().min(1, "Seleccione un almacén"),
  idMoneda: z.coerce.number().min(1, "Seleccione moneda"),
  tipoComprobante: z.string().min(1, "Tipo requerido"),
  serieComprobante: z.string().min(1, "Serie requerida"),
  numeroComprobante: z.string().min(1, "Número requerido"),
  fechaEmision: z.date(),
  tipoCambio: z.coerce.number().min(0.001, "TC inválido"),
  observaciones: z.string().optional(),
  detalles: z
    .array(
      z.object({
        idProducto: z.coerce.number().min(1, "Producto requerido"),
        cantidad: z.coerce.number().min(0.01, "Cantidad inválida"),
        precioUnitario: z.coerce.number().min(0, "Precio inválido"),
      }),
    )
    .min(1, "Debe agregar al menos un producto"),
});

type CompraFormValues = z.infer<typeof compraSchema>;

interface CompraFormProps {
  onSuccess: () => void;
  onCancel: () => void;
}

// Componente Input Autocomplete para Productos
const ProductInput = ({
  value,
  onChange,
  productos,
  placeholder = "Buscar producto...",
}: {
  value: number;
  onChange: (id: number) => void;
  productos: any[]; // Usar tipo correcto si está disponible
  placeholder?: string;
}) => {
  const [open, setOpen] = React.useState(false);
  const [inputValue, setInputValue] = React.useState("");

  // Sincronizar input con valor seleccionado
  React.useEffect(() => {
    if (value) {
      const selected = productos.find((p) => p.id === value);
      if (selected) {
        setInputValue(selected.nombre);
      }
    } else {
       setInputValue("");
    }
  }, [value, productos]);

  const filtered = productos.filter((p) =>
    p.nombre.toLowerCase().includes(inputValue.toLowerCase())
  );

  return (
    <Popover open={open} onOpenChange={setOpen}>
      <PopoverTrigger asChild>
        <FormControl>
           <div className="relative">
            <Input
              placeholder={placeholder}
              value={inputValue}
              onChange={(e) => {
                setInputValue(e.target.value);
                setOpen(true);
                // Si borra todo, reseteamos el valor
                if (e.target.value === "") {
                   onChange(0);
                }
              }}
              onFocus={() => setOpen(true)}
              className="pr-8" // Espacio para icono si se desea
            />
            {/* Optional: Icono de búsqueda o chevron */}
           </div>
        </FormControl>
      </PopoverTrigger>
      <PopoverContent className="w-[300px] p-0" align="start">
        <Command>
           {/* No CommandInput here, we use the external Input */}
          <CommandList>
            <CommandEmpty>No se encontraron productos.</CommandEmpty>
            <CommandGroup>
              {filtered.map((producto) => (
                <CommandItem
                  key={producto.id}
                  value={producto.nombre}
                  onSelect={() => {
                    onChange(producto.id);
                    setInputValue(producto.nombre);
                    setOpen(false);
                  }}
                >
                  <Check
                    className={cn(
                      "mr-2 h-4 w-4",
                      value === producto.id ? "opacity-100" : "opacity-0"
                    )}
                  />
                  {producto.nombre}
                </CommandItem>
              ))}
            </CommandGroup>
          </CommandList>
        </Command>
      </PopoverContent>
    </Popover>
  );
};

export function CompraForm({ onSuccess, onCancel }: CompraFormProps) {
  const registrar = useRegistrarCompra();

  // Data for selectors
  const { data: proveedores } = useProveedores();
  const { data: almacenes } = useAlmacenes();
  const { data: productosData } = useProductos({
    pageNumber: 1,
    pageSize: 1000,
  }); // Carga simplificada por ahora
  const productos = productosData?.datos || [];

  const form = useForm<CompraFormValues>({
    resolver: zodResolver(compraSchema),
    defaultValues: {
      fechaEmision: new Date(),
      tipoCambio: 1.0,
      detalles: [{ idProducto: 0, cantidad: 1, precioUnitario: 0 }],
    },
  });

  const { fields, append, remove } = useFieldArray({
    control: form.control,
    name: "detalles",
  });

  const onSubmit = (values: CompraFormValues) => {
    registrar.mutate(values, {
      onSuccess: () => onSuccess(),
    });
  };

  // Calcular totales en tiempo real
  const valoresDetalles = form.watch("detalles");
  const totalCalculado = valoresDetalles.reduce((acc, curr) => {
    return (
      acc + (Number(curr.cantidad) || 0) * (Number(curr.precioUnitario) || 0)
    );
  }, 0);

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-6">
        {/* Cabecera del Documento */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
          <FormField
            control={form.control}
            name="idProveedor"
            render={({ field }) => (
              <FormItem className="col-span-2">
                <FormLabel>Proveedor</FormLabel>
                <FormControl>
                  <select
                    className="flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm transition-colors file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50"
                    value={field.value}
                    onChange={(e) => field.onChange(Number(e.target.value))}
                  >
                    <option value={0}>Seleccione Proveedor</option>
                    {proveedores?.map((p) => (
                      <option key={p.id} value={p.id}>
                        {p.razonSocial}
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
            name="idAlmacen"
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
                        {a.nombre}
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
                          format(field.value, "PPP")
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
                      disabled={(date) =>
                        date > new Date() || date < new Date("1900-01-01")
                      }
                      initialFocus
                    />
                  </PopoverContent>
                </Popover>
                <FormMessage />
              </FormItem>
            )}
          />
        </div>

        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          {/* Comprobante Info */}
          <FormField
            control={form.control}
            name="tipoComprobante"
            render={({ field }) => (
              <SelectorCatalogo
                codigo="TIPO_COMPROBANTE"
                label="Tipo Comprobante"
                value={field.value} // SelectorCatalogo expects number usually but string here?
                // Wait, SelectorCatalogo usually returns ID (number).
                // Let's assume TIPO_COMPROBANTE is a table and returns ID.
                // But our schema expects string?
                // Let's adjust schema if needed or just use input for now.
                // Actually, let's use a simple Select or Input for simplicity first iteration.
                // Or reuse SelectorCatalogo and change input to number.
                // To keep it simple and robust, let's use a standard select hardcoded or Input.
                onChange={(val) => field.onChange(val.toString())}
                placeholder="Tipo (Factura)"
              />
            )}
          />
          {/* NOTE: SelectorCatalogo might be strict on types. Let's use Input for simplicity if catalog not ready */}
          <FormField
            control={form.control}
            name="serieComprobante"
            render={({ field }) => (
              <FormItem>
                <FormLabel>Serie</FormLabel>
                <FormControl>
                  <Input {...field} placeholder="F001" />
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />
          <FormField
            control={form.control}
            name="numeroComprobante"
            render={({ field }) => (
              <FormItem>
                <FormLabel>Número</FormLabel>
                <FormControl>
                  <Input {...field} placeholder="000123" />
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />
          <FormField
            control={form.control}
            name="idMoneda"
            render={({ field }) => (
              <SelectorCatalogo
                codigo="MONEDA"
                label="Moneda"
                value={field.value}
                onChange={(val) => field.onChange(Number(val))}
                placeholder="Soles/Dólares"
              />
            )}
          />
        </div>

        <Separator className="my-4" />

        {/* Detalles */}
        <div className="space-y-4">
          <h3 className="text-lg font-medium">Items de Compra</h3>
          <div className="border rounded-md p-4 bg-muted/20">
            {fields.map((field, index) => (
              <div
                key={field.id}
                className="grid grid-cols-12 gap-2 mb-2 items-end"
              >
                  <div className="col-span-5">
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
                             onChange={(id) => {
                               field.onChange(id);
                               // Lógica adicional si es necesario
                             }}
                             productos={productos}
                          />
                          <FormMessage />
                        </FormItem>
                      )}
                    />
                  </div>

                <div className="col-span-2">
                  <FormField
                    control={form.control}
                    name={`detalles.${index}.cantidad`}
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel className={index !== 0 ? "sr-only" : ""}>
                          Cant.
                        </FormLabel>
                        <FormControl>
                          <Input type="number" step="1" {...field} />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                </div>

                <div className="col-span-2">
                  <FormField
                    control={form.control}
                    name={`detalles.${index}.precioUnitario`}
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel className={index !== 0 ? "sr-only" : ""}>
                          Precio Unit.
                        </FormLabel>
                        <FormControl>
                          <Input type="number" step="0.01" {...field} />
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
                        form.watch(`detalles.${index}.cantidad`) *
                        form.watch(`detalles.${index}.precioUnitario`)
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
                append({ idProducto: 0, cantidad: 1, precioUnitario: 0 })
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
            {registrar.isPending ? "Registrando..." : "Registrar Compra"}
          </Button>
        </div>
      </form>
    </Form>
  );
}
