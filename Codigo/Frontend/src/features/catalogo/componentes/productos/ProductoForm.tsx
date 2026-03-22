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
  FormDescription,
} from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { Switch } from "@/components/ui/switch";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Producto, ProductoFormData } from "../../tipos/catalogo.types";
import { useCategorias } from "../../hooks/useCategorias";
import { useMarcas } from "../../hooks/useMarcas";
import { useUnidadesMedida } from "../../hooks/useUnidadesMedida";
import { useEffect } from "react";
import { limpiarDecimal } from "@compartido/utilidades";
import { toast } from "sonner";
import { Loading } from "@compartido/componentes/feedback/Loading";

const formSchema = z.object({
  // Información básica
  codigo: z.string().min(3, "El código debe tener al menos 3 caracteres"),
  nombre: z.string().min(3, "El nombre debe tener al menos 3 caracteres"),
  descripcion: z.string().optional(),

  // Relaciones
  idCategoria: z.coerce.number().min(0),
  idMarca: z.coerce.number().min(0),
  idUnidadMedida: z.coerce.number().min(0),
  idTipoProducto: z.coerce.number().optional(),

  // Códigos adicionales
  codigoBarras: z.string().optional(),
  sku: z.string().optional(),

  // Precios
  precioCompra: z.coerce.number().min(0, "El precio no puede ser negativo"),
  precioVentaPublico: z.coerce
    .number()
    .min(0, "El precio no puede ser negativo"),
  precioVentaMayorista: z.coerce
    .number()
    .min(0, "El precio no puede ser negativo"),
  precioVentaDistribuidor: z.coerce
    .number()
    .min(0, "El precio no puede ser negativo"),

  // Stock
  stockMinimo: z.coerce
    .number()
    .min(0, "El stock mínimo no puede ser negativo"),
  stockMaximo: z.coerce.number().optional(),

  // Configuración de inventario
  tieneVariantes: z.boolean(),
  permiteInventarioNegativo: z.boolean(),
  metodoValuacion: z.string().min(1, "Debe seleccionar un método"),

  // Configuración fiscal
  gravadoImpuesto: z.boolean(),
  porcentajeImpuesto: z.coerce.number().min(0).max(100),

  // Imagen
  imagenPrincipalUrl: z
    .string()
    .url("Debe ser una URL válida")
    .optional()
    .or(z.literal("")),

  // Auditoría
  activo: z.boolean(),
});

interface Props {
  datosIniciales?: Producto | null;
  alEnviar: (datos: ProductoFormData) => void;
  alCancelar: () => void;
  cargando?: boolean;
}

export function ProductoForm({
  datosIniciales,
  alEnviar,
  alCancelar,
  cargando,
}: Props) {
  // Hooks para cargar listas desplegables
  const { data: categoriasData, isLoading: cargandoCategorias } = useCategorias({
    activo: true,
    pageSize: 100,
    pageNumber: 1,
    search: "",
  });
  const { data: marcasData, isLoading: cargandoMarcas } = useMarcas({
    activo: true,
    pageSize: 100,
    pageNumber: 1,
    search: "",
  });
  const { data: unidadesData, isLoading: cargandoUnidades } = useUnidadesMedida(true);

  const cargandoCatalogos = cargandoCategorias || cargandoMarcas || cargandoUnidades;

  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      codigo: "",
      nombre: "",
      descripcion: "",
      idCategoria: 0,
      idMarca: 0,
      idUnidadMedida: 0,
      idTipoProducto: undefined,
      codigoBarras: "",
      sku: "",
      precioCompra: 0,
      precioVentaPublico: 0,
      precioVentaMayorista: 0,
      precioVentaDistribuidor: 0,
      stockMinimo: 5,
      stockMaximo: 100,
      tieneVariantes: false,
      permiteInventarioNegativo: false,
      metodoValuacion: "PE",
      gravadoImpuesto: true,
      porcentajeImpuesto: 18,
      imagenPrincipalUrl: "",
      activo: true,
    },
  });

  useEffect(() => {
    if (datosIniciales) {
      form.reset({
        codigo: datosIniciales.codigo,
        nombre: datosIniciales.nombre,
        descripcion: datosIniciales.descripcion || "",
        idCategoria: datosIniciales.idCategoria,
        idMarca: datosIniciales.idMarca,
        idUnidadMedida: datosIniciales.idUnidadMedida,
        idTipoProducto: datosIniciales.idTipoProducto ?? undefined,
        codigoBarras: datosIniciales.codigoBarras || "",
        sku: datosIniciales.sku || "",
        precioCompra: datosIniciales.precioCompra,
        precioVentaPublico: datosIniciales.precioVentaPublico,
        precioVentaMayorista: datosIniciales.precioVentaMayorista,
        precioVentaDistribuidor: datosIniciales.precioVentaDistribuidor,
        stockMinimo: datosIniciales.stockMinimo,
        stockMaximo: datosIniciales.stockMaximo,
        tieneVariantes: datosIniciales.tieneVariantes,
        permiteInventarioNegativo: datosIniciales.permiteInventarioNegativo,
        metodoValuacion: datosIniciales.metodoValuacion || "PE",
        gravadoImpuesto: datosIniciales.gravadoImpuesto,
        porcentajeImpuesto: datosIniciales.porcentajeImpuesto,
        imagenPrincipalUrl: datosIniciales.imagenPrincipalUrl || "",
        activo: datosIniciales.activo,
      });
    }
  }, [datosIniciales, form, cargandoCatalogos]);

  const gravadoImpuesto = form.watch("gravadoImpuesto");

  const onInvalid = (errors: any) => {
    const nombres: Record<string, string> = {
      codigo: "Código",
      nombre: "Nombre",
      idCategoria: "Categoría",
      idMarca: "Marca",
      idUnidadMedida: "Unidad de medida",
      precioCompra: "Precio compra",
      precioVentaPublico: "Precio público",
      stockMinimo: "Stock mínimo",
    };
    const campos = Object.keys(errors)
      .map((k) => nombres[k] || k)
      .join(", ");
    toast.error(`Campos con error: ${campos}`);
  };

  return (
    <Form {...form}>
      <form
        onSubmit={form.handleSubmit(alEnviar, onInvalid)}
        className="space-y-4 relative"
      >
        {cargandoCatalogos && (
          <div className="absolute inset-0 z-50 flex flex-col items-center justify-center bg-background/60 backdrop-blur-sm rounded-lg">
            <Loading mensaje="Sincronizando catálogos de marcas y categorías..." />
          </div>
        )}

        <Tabs defaultValue="general" className="w-full">
          <TabsList className="grid w-full grid-cols-2 md:grid-cols-4 h-auto">
            <TabsTrigger value="general">General</TabsTrigger>
            <TabsTrigger value="precios">Precios</TabsTrigger>
            <TabsTrigger value="inventario">Inventario</TabsTrigger>
            <TabsTrigger value="adicional">Adicional</TabsTrigger>
          </TabsList>

          {/* Pestaña: Información General */}
          <TabsContent value="general" className="space-y-4 min-h-[500px]">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <FormField
                control={form.control}
                name="codigo"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Código *</FormLabel>
                    <FormControl>
                      <Input placeholder="COD-001" {...field} value={field.value ?? ""} disabled={cargandoCatalogos} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="nombre"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Nombre *</FormLabel>
                    <FormControl>
                      <Input placeholder="Nombre del producto" {...field} value={field.value ?? ""} disabled={cargandoCatalogos} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
            </div>

            <FormField
              control={form.control}
              name="descripcion"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Descripción</FormLabel>
                  <FormControl>
                    <Textarea
                      placeholder="Descripción detallada"
                      className="resize-none"
                      {...field}
                      value={field.value ?? ""}
                      disabled={cargandoCatalogos}
                    />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />

            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              <FormField
                control={form.control}
                name="idCategoria"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Categoría *</FormLabel>
                    <Select
                      onValueChange={field.onChange}
                      value={field.value ? field.value.toString() : undefined}
                      disabled={cargandoCatalogos}
                    >
                      <FormControl>
                        <SelectTrigger>
                          <SelectValue placeholder="Categoría" />
                        </SelectTrigger>
                      </FormControl>
                      <SelectContent>
                        {categoriasData?.datos.map((cat) => (
                          <SelectItem key={cat.id} value={cat.id.toString()}>
                            {cat.nombre}
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
                name="idMarca"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Marca *</FormLabel>
                    <Select
                      onValueChange={field.onChange}
                      value={field.value ? field.value.toString() : undefined}
                      disabled={cargandoCatalogos}
                    >
                      <FormControl>
                        <SelectTrigger>
                          <SelectValue placeholder="Marca" />
                        </SelectTrigger>
                      </FormControl>
                      <SelectContent>
                        {marcasData?.datos.map((marca) => (
                          <SelectItem
                            key={marca.id}
                            value={marca.id.toString()}
                          >
                            {marca.nombre}
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
                name="idUnidadMedida"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Unidad *</FormLabel>
                    <Select
                      onValueChange={field.onChange}
                      value={field.value ? field.value.toString() : undefined}
                      disabled={cargandoCatalogos}
                    >
                      <FormControl>
                        <SelectTrigger>
                          <SelectValue placeholder="Unidad" />
                        </SelectTrigger>
                      </FormControl>
                      <SelectContent>
                        {unidadesData?.datos?.map((unidad) => (
                          <SelectItem
                            key={unidad.id}
                            value={unidad.id.toString()}
                          >
                            {unidad.nombre} ({unidad.simbolo || "?"})
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                    <FormMessage />
                  </FormItem>
                )}
              />
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <FormField
                control={form.control}
                name="codigoBarras"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Código de Barras</FormLabel>
                    <FormControl>
                      <Input placeholder="7501234567890" {...field} value={field.value ?? ""} disabled={cargandoCatalogos} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="sku"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>SKU</FormLabel>
                    <FormControl>
                      <Input placeholder="SKU-001" {...field} value={field.value ?? ""} disabled={cargandoCatalogos} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
            </div>
          </TabsContent>

          {/* Pestaña: Precios */}
          <TabsContent value="precios" className="space-y-4 min-h-[500px]">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <FormField
                control={form.control}
                name="precioCompra"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Precio de Compra *</FormLabel>
                    <FormControl>
                      <Input
                        type="text"
                        inputMode="decimal"
                        placeholder="0.00"
                        {...field}
                        value={field.value ?? ""}
                        disabled={cargandoCatalogos}
                        onChange={(e) =>
                          field.onChange(limpiarDecimal(e.target.value))
                        }
                      />
                    </FormControl>
                    <FormDescription>Costo de adquisición</FormDescription>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="precioVentaPublico"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Precio Venta Público *</FormLabel>
                    <FormControl>
                      <Input
                        type="text"
                        inputMode="decimal"
                        placeholder="0.00"
                        {...field}
                        value={field.value ?? ""}
                        disabled={cargandoCatalogos}
                        onChange={(e) =>
                          field.onChange(limpiarDecimal(e.target.value))
                        }
                      />
                    </FormControl>
                    <FormDescription>
                      Precio al consumidor final
                    </FormDescription>
                    <FormMessage />
                  </FormItem>
                )}
              />
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <FormField
                control={form.control}
                name="precioVentaMayorista"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Precio Venta Mayorista</FormLabel>
                    <FormControl>
                      <Input
                        type="text"
                        inputMode="decimal"
                        placeholder="0.00"
                        {...field}
                        value={field.value ?? ""}
                        disabled={cargandoCatalogos}
                        onChange={(e) =>
                          field.onChange(limpiarDecimal(e.target.value))
                        }
                      />
                    </FormControl>
                    <FormDescription>Precio para mayoristas</FormDescription>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="precioVentaDistribuidor"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Precio Venta Distribuidor</FormLabel>
                    <FormControl>
                      <Input
                        type="text"
                        inputMode="decimal"
                        placeholder="0.00"
                        {...field}
                        value={field.value ?? ""}
                        disabled={cargandoCatalogos}
                        onChange={(e) =>
                          field.onChange(limpiarDecimal(e.target.value))
                        }
                      />
                    </FormControl>
                    <FormDescription>
                      Precio para distribuidores
                    </FormDescription>
                    <FormMessage />
                  </FormItem>
                )}
              />
            </div>
          </TabsContent>

          {/* Pestaña: Inventario */}
          <TabsContent value="inventario" className="space-y-4 min-h-[500px]">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <FormField
                control={form.control}
                name="stockMinimo"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Stock Mínimo *</FormLabel>
                    <FormControl>
                      <Input
                        type="text"
                        inputMode="decimal"
                        placeholder="0"
                        {...field}
                        value={field.value ?? ""}
                        disabled={cargandoCatalogos}
                        onChange={(e) =>
                          field.onChange(limpiarDecimal(e.target.value))
                        }
                      />
                    </FormControl>
                    <FormDescription>
                      Alerta de reabastecimiento
                    </FormDescription>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="stockMaximo"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Stock Máximo</FormLabel>
                    <FormControl>
                      <Input
                        type="text"
                        inputMode="decimal"
                        placeholder="0"
                        {...field}
                        value={field.value ?? ""}
                        disabled={cargandoCatalogos}
                        onChange={(e) =>
                          field.onChange(limpiarDecimal(e.target.value))
                        }
                      />
                    </FormControl>
                    <FormDescription>Límite de almacenamiento</FormDescription>
                    <FormMessage />
                  </FormItem>
                )}
              />
            </div>

            <div className="space-y-4">
              <FormField
                control={form.control}
                name="tieneVariantes"
                render={({ field }) => (
                  <FormItem className="flex flex-row items-center justify-between rounded-lg border p-4">
                    <div className="space-y-0.5">
                      <FormLabel className="text-base">
                        Tiene Variantes
                      </FormLabel>
                      <FormDescription>
                        El producto tiene variaciones (tallas, colores, etc.)
                      </FormDescription>
                    </div>
                    <FormControl>
                      <Switch
                        checked={field.value}
                        onCheckedChange={field.onChange}
                        disabled={cargandoCatalogos}
                      />
                    </FormControl>
                  </FormItem>
                )}
              />

              <FormField
                control={form.control}
                name="permiteInventarioNegativo"
                render={({ field }) => (
                  <FormItem className="flex flex-row items-center justify-between rounded-lg border p-4">
                    <div className="space-y-0.5">
                      <FormLabel className="text-base">
                        Permite Inventario Negativo
                      </FormLabel>
                      <FormDescription>
                        Permite vender aunque no haya stock disponible
                      </FormDescription>
                    </div>
                    <FormControl>
                      <Switch
                        checked={field.value}
                        onCheckedChange={field.onChange}
                        disabled={cargandoCatalogos}
                      />
                    </FormControl>
                  </FormItem>
                )}
              />

              <FormField
                control={form.control}
                name="metodoValuacion"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Método de Valuación *</FormLabel>
                    <Select
                      onValueChange={field.onChange}
                      value={field.value}
                      disabled={cargandoCatalogos}
                    >
                      <FormControl>
                        <SelectTrigger>
                          <SelectValue placeholder="Seleccione método" />
                        </SelectTrigger>
                      </FormControl>
                      <SelectContent>
                        <SelectItem value="PE">PEPS (P. Entrar, P. Salir)</SelectItem>
                        <SelectItem value="PP">Promedio Ponderado</SelectItem>
                        <SelectItem value="UE">UEPS (Ú. Entrar, P. Salir)</SelectItem>
                      </SelectContent>
                    </Select>
                    <FormDescription>
                      Método para costeo de inventario
                    </FormDescription>
                    <FormMessage />
                  </FormItem>
                )}
              />
            </div>
          </TabsContent>

          {/* Pestaña: Adicional */}
          <TabsContent value="adicional" className="space-y-4 min-h-[500px]">
            <div className="space-y-4">
              <FormField
                control={form.control}
                name="gravadoImpuesto"
                render={({ field }) => (
                  <FormItem className="flex flex-row items-center justify-between rounded-lg border p-4">
                    <div className="space-y-0.5">
                      <FormLabel className="text-base">
                        Gravado con Impuesto
                      </FormLabel>
                      <FormDescription>
                        El producto está sujeto a impuestos
                      </FormDescription>
                    </div>
                    <FormControl>
                      <Switch
                        checked={field.value}
                        onCheckedChange={field.onChange}
                        disabled={cargandoCatalogos}
                      />
                    </FormControl>
                  </FormItem>
                )}
              />

              <FormField
                control={form.control}
                name="porcentajeImpuesto"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Porcentaje de Impuesto (%)</FormLabel>
                    <FormControl>
                      <Input
                        type="text"
                        inputMode="decimal"
                        placeholder="18.00"
                        disabled={!gravadoImpuesto}
                        {...field}
                        value={field.value ?? ""}
                        onChange={(e) =>
                          field.onChange(limpiarDecimal(e.target.value))
                        }
                      />
                    </FormControl>
                    <FormDescription>
                      Porcentaje de impuesto aplicable (ej: IGV 18%)
                    </FormDescription>
                    <FormMessage />
                  </FormItem>
                )}
              />

              <FormField
                control={form.control}
                name="imagenPrincipalUrl"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>URL de Imagen Principal</FormLabel>
                    <FormControl>
                      <Input
                        type="url"
                        placeholder="https://ejemplo.com/imagen.jpg"
                        {...field}
                        value={field.value ?? ""}
                        disabled={cargandoCatalogos}
                      />
                    </FormControl>
                    <FormDescription>
                      URL de la imagen principal del producto
                    </FormDescription>
                    <FormMessage />
                  </FormItem>
                )}
              />

              <FormField
                control={form.control}
                name="activo"
                render={({ field }) => (
                  <FormItem className="flex flex-row items-center justify-between rounded-lg border p-4">
                    <div className="space-y-0.5">
                      <FormLabel className="text-base">Estado Activo</FormLabel>
                      <FormDescription>
                        Producto disponible para venta/compra
                      </FormDescription>
                    </div>
                    <FormControl>
                      <Switch
                        checked={field.value}
                        onCheckedChange={field.onChange}
                        disabled={cargandoCatalogos}
                      />
                    </FormControl>
                  </FormItem>
                )}
              />
            </div>
          </TabsContent>
        </Tabs>

        <div className="flex justify-end gap-3 pt-4">
          <Button type="button" variant="outline" onClick={alCancelar} disabled={cargandoCatalogos}>
            Cancelar
          </Button>
          <Button type="submit" disabled={cargando || cargandoCatalogos}>
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
