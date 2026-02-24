import React from "react";
import { useForm, useFieldArray } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import * as z from "zod";
import { format } from "date-fns";
import { es } from "date-fns/locale";
import { Search, CalendarIcon, Trash2, Plus, Check } from "lucide-react";

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
import { toast } from "sonner";

import { useRegistrarCompra } from "../hooks/useCompras";
import { SelectorTipoComprobante } from "@/compartido/componentes/formularios/SelectorTipoComprobante";
import { SelectorCatalogo } from "@/compartido/componentes/formularios/SelectorCatalogo";
import { SelectorProveedorV2 } from "@/compartido/componentes/formularios/SelectorProveedorV2";

import {
  useProveedores,
  useProveedor,
} from "@/features/compras/proveedores/hooks/useProveedores";
import { useAlmacenes } from "@/features/inventario/almacenes/hooks/useAlmacenes";
import {
  useProductos,
  useProducto,
} from "@/features/catalogo/hooks/useProductos";
import { useReglasDocumentos } from "@/configuracion/hooks/useReglasDocumentos";
import { useSeriesPorTipo } from "@/features/configuracion/hooks/useSeriesComprobante";

import {
  limpiarSoloNumeros,
  padIzquierda,
  limpiarDecimal,
  formatMoneda,
  calcularIGV,
} from "@compartido/utilidades";
import { obtenerOrdenesCompra } from "@/features/compras/ordenes-compra/servicios/ordenCompraService";
import {
  EstadoOrdenCompra,
  ComprasConstantes,
} from "@/features/compras/constantes";
import { CrearCompraPayload } from "../types/compra.types";

// Schema de validación

const compraSchema = z.object({
  idProveedor: z.coerce.number().min(1, "Seleccione un proveedor"),
  idAlmacen: z.coerce.number().min(1, "Seleccione un almacén"),
  idMoneda: z.coerce.number().min(1, "Seleccione moneda"),
  tipoComprobante: z.string().min(1, "Tipo requerido"),
  serieComprobante: z.string().min(1, "Serie requerida"),
  numeroComprobante: z.string().min(1, "Número requerido"),
  fechaEmision: z.date(),
  fechaVencimiento: z.date().optional().nullable(),
  tipoCambio: z.coerce.number().min(0.001, "TC inválido"),
  observaciones: z.string().optional(),
  detalles: z
    .array(
      z.object({
        idProducto: z.coerce.number().min(1, "Producto requerido"),
        cantidad: z.coerce.number().min(0.01, "Cantidad inválida"),
        precioUnitario: z.coerce.number().min(0, "Precio inválido"),
        afectacionIgv: z.enum(["G", "E", "I"]).default("G"),
        unidadMedida: z.string().optional(),
      }),
    )
    .min(1, "Debe agregar al menos un producto"),
});

type CompraFormValues = z.infer<typeof compraSchema>;

interface CompraFormProps {
  onSuccess: () => void;
  onCancel: () => void;
  datosIniciales?: Partial<CompraFormValues>;
  readOnly?: boolean;
}

// Componente Input Autocomplete para Productos
const ProductInput = ({
  value,
  onChange,
  onProductSelect,
  placeholder = "Buscar (Enter)...",
  disabled = false,
}: {
  value: number;
  onChange: (id: number) => void;
  onProductSelect?: (producto: any) => void;
  placeholder?: string;
  disabled?: boolean;
}) => {
  const [open, setOpen] = React.useState(false);
  const [inputValue, setInputValue] = React.useState("");
  const [searchTerm, setSearchTerm] = React.useState("");

  // Buscar usando la query de forma condicional al término ingresado
  const { data: qData, isFetching } = useProductos(
    { search: searchTerm, pageSize: 50, pageNumber: 1 },
    { enabled: !!searchTerm },
  );
  const productosEncontrados = qData?.datos || [];

  // Cuando se selecciona un ID preexistente (e.j. al editar / OC),
  // buscamos ese producto individual directamente
  const { data: productoSeleccionado } = useProducto(value);

  React.useEffect(() => {
    if (value && !inputValue && productoSeleccionado) {
      setInputValue(productoSeleccionado.nombre);
    } else if (!value) {
      setInputValue("");
    }
  }, [value, productoSeleccionado]);

  const handleKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === "Enter") {
      e.preventDefault();
      e.stopPropagation(); // Evitar submit del formulario
      if (inputValue.trim().length >= 2) {
        setSearchTerm(inputValue.trim());
        setOpen(true);
      } else {
        toast.info("Ingrese al menos 2 caracteres para buscar");
      }
    }
  };

  return (
    <Popover open={open && !disabled} onOpenChange={setOpen}>
      <PopoverTrigger asChild>
        <FormControl>
          <div className="relative">
            <Input
              placeholder={placeholder}
              value={inputValue}
              onChange={(e) => {
                if (disabled) return;
                setInputValue(e.target.value);
                // Si borra todo, reseteamos el valor
                if (e.target.value === "") {
                  onChange(0);
                  if (onProductSelect) onProductSelect(null);
                }
              }}
              onKeyDown={handleKeyDown}
              className="pr-8"
              disabled={disabled}
            />
            {isFetching ? (
              <span className="absolute right-3 top-1/2 -translate-y-1/2 text-xs text-muted-foreground animate-pulse">
                ...
              </span>
            ) : (
              <Search className="absolute right-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
            )}
          </div>
        </FormControl>
      </PopoverTrigger>
      <PopoverContent className="w-[300px] p-0" align="start">
        <Command>
          <CommandList>
            <CommandEmpty>No se encontraron productos.</CommandEmpty>
            <CommandGroup>
              {productosEncontrados.map((producto: any) => (
                <CommandItem
                  key={producto.id}
                  value={producto.nombre}
                  onSelect={() => {
                    onChange(producto.id);
                    setInputValue(producto.nombre);
                    if (onProductSelect) onProductSelect(producto);
                    setOpen(false);
                  }}
                >
                  <Check
                    className={cn(
                      "mr-2 h-4 w-4",
                      value === producto.id ? "opacity-100" : "opacity-0",
                    )}
                  />
                  <div className="flex flex-col">
                    <span>{producto.nombre}</span>
                    <span className="text-xs text-muted-foreground">
                      {producto.codigo || ""}
                    </span>
                  </div>
                </CommandItem>
              ))}
            </CommandGroup>
          </CommandList>
        </Command>
      </PopoverContent>
    </Popover>
  );
};

// ... (imports consolidados arriba)

// Eliminamos ProviderSelector local que estaba aquí

// ... (imports existentes)

export function CompraForm({
  onSuccess,
  onCancel,
  datosIniciales,
  readOnly = false,
}: CompraFormProps) {
  const registrar = useRegistrarCompra();
  const [busquedaOrden, setBusquedaOrden] = React.useState("");
  const [buscandoOrden, setBuscandoOrden] = React.useState(false);

  // Provider search state
  const [busquedaProv, setBusquedaProv] = React.useState("");

  const { data: proveedores = [], refetch: buscarProveedores } = useProveedores(
    busquedaProv,
    false,
  );

  const handleSearchProveedor = (term: string) => {
    setBusquedaProv(term);
    setTimeout(() => buscarProveedores(), 0);
  };

  const { data: almacenes } = useAlmacenes();
  // Se quitó la carga masiva inicial de productos

  const form = useForm<CompraFormValues>({
    resolver: zodResolver(compraSchema),
    defaultValues: {
      idProveedor: 0,
      idAlmacen: 0,
      idMoneda: 1, // Soles por defecto

      tipoComprobante: "",
      serieComprobante: "",
      numeroComprobante: "",
      fechaEmision: new Date(),
      fechaVencimiento: null,
      tipoCambio: 1.0,
      observaciones: "",
      detalles: [
        {
          idProducto: 0,
          cantidad: 1,
          precioUnitario: 0,
          afectacionIgv: "G",
          unidadMedida: "",
        },
      ],
      ...datosIniciales,
    },
  });

  const tipoComprobanteWatch = form.watch("tipoComprobante");
  const { data: series = [] } = useSeriesPorTipo(
    tipoComprobanteWatch ? Number(tipoComprobanteWatch) : null,
  );

  // Auto-asignar serie al cambiar el tipo de comprobante
  React.useEffect(() => {
    if (!datosIniciales?.serieComprobante && series.length > 0) {
      form.setValue("serieComprobante", series[0].serie);
      if (!datosIniciales?.numeroComprobante) {
        form.setValue("numeroComprobante", "000000"); // Valor temporal para validar
      }
    }
  }, [series, form, datosIniciales]);

  // Fetch selected provider data explicitly if ID exists (for pre-fill)
  const idProveedorWatch = form.watch("idProveedor");
  const { data: proveedorSeleccionadoData } = useProveedor(
    idProveedorWatch || 0,
  );

  // Merge search results with selected provider to ensure it appears in the list
  const listaProveedores = React.useMemo(() => {
    let lista = [...proveedores];

    // Si tenemos un proveedor seleccionado de la base de datos (por fetch)
    if (
      proveedorSeleccionadoData &&
      !lista.some((p) => p.id === proveedorSeleccionadoData.id)
    ) {
      lista.push(proveedorSeleccionadoData);
    }

    // Si tenemos info del proveedor en datosIniciales (para visualización instantánea)
    if (
      datosIniciales?.idProveedor &&
      !lista.some((p) => p.id === datosIniciales.idProveedor)
    ) {
      lista.push({
        id: datosIniciales.idProveedor,
        razonSocial: (datosIniciales as any).razonSocialProveedor,
        numeroDocumento: (datosIniciales as any).numeroDocumentoProveedor,
        idTipoDocumento: (datosIniciales as any).idTipoDocumentoProveedor,
        activado: true,
        fechaCreacion: new Date().toISOString(),
      } as any);
    }

    return lista;
  }, [proveedores, proveedorSeleccionadoData, datosIniciales]);

  const { fields, append, remove, replace } = useFieldArray({
    control: form.control,
    name: "detalles",
  });

  // Efecto para cargar datosIniciales si cambian (por ejemplo, al venir de redirección)
  React.useEffect(() => {
    if (datosIniciales) {
      form.reset({
        fechaEmision: new Date(),
        tipoCambio: 1.0,
        ...datosIniciales,
      });
    }
  }, [datosIniciales, form]);

  const handleBuscarOrden = async (
    e: React.KeyboardEvent<HTMLInputElement>,
  ) => {
    if (e.key === "Enter") {
      e.preventDefault();
      if (!busquedaOrden.trim()) return;

      setBuscandoOrden(true);
      try {
        // Obtenemos todas las órdenes (idealmente habría un endpoint de búsqueda directa)
        const ordenes = await obtenerOrdenesCompra();
        const ordenEncontrada = ordenes.find(
          (o) =>
            o.codigoOrden.toLowerCase() === busquedaOrden.toLowerCase().trim(),
        );

        if (!ordenEncontrada) {
          toast.error("No se encontró ninguna orden con ese código.");
          setBuscandoOrden(false);
          return;
        }

        if (ordenEncontrada.idEstado !== EstadoOrdenCompra.Aprobada) {
          toast.warning("La orden encontrada no está aprobada.");
          setBuscandoOrden(false);
          return;
        }

        // Llenar el formulario
        form.setValue("idProveedor", ordenEncontrada.idProveedor);
        form.setValue("idAlmacen", ordenEncontrada.idAlmacenDestino);
        form.setValue(
          "observaciones",
          `Orden de Compra: ${ordenEncontrada.codigoOrden}`,
        );

        // Mapear detalles
        const nuevosDetalles = ordenEncontrada.detalles.map((d) => ({
          idProducto: d.idProducto,
          cantidad: d.cantidadSolicitada,
          precioUnitario: d.precioUnitarioPactado,
          afectacionIgv: "G" as const,
        }));

        replace(nuevosDetalles);
        toast.success(
          `Datos cargados de la Orden ${ordenEncontrada.codigoOrden}`,
        );
      } catch (error) {
        console.error(error);
        toast.error("Error al buscar la orden de compra.");
      } finally {
        setBuscandoOrden(false);
      }
    }
  };

  const onSubmit = (values: CompraFormValues) => {
    // Calcular totales
    let baseGravada = 0;
    let baseExonerada = 0;
    let baseInafecta = 0;

    values.detalles.forEach((curr) => {
      const sub =
        (Number(curr.cantidad) || 0) * (Number(curr.precioUnitario) || 0);
      if (curr.afectacionIgv === "G") baseGravada += sub;
      else if (curr.afectacionIgv === "E") baseExonerada += sub;
      else if (curr.afectacionIgv === "I") baseInafecta += sub;
    });

    const impuesto = baseGravada * 0.18; // Asumiendo 18% para gravados
    const total = baseGravada + baseExonerada + baseInafecta + impuesto;

    // Construir payload que coincida con CompraDto del backend
    const payload: CrearCompraPayload = {
      idProveedor: values.idProveedor,
      idAlmacen: values.idAlmacen,
      idOrdenCompraRef: null, // O mapearlo si existe
      idTipoComprobante: Number(values.tipoComprobante), // Convertir a number
      serieComprobante: values.serieComprobante,
      numeroComprobante: values.numeroComprobante,
      fechaEmision: values.fechaEmision,
      fechaContable: values.fechaEmision, // Usar misma fecha por defecto
      fechaVencimiento: values.fechaVencimiento ?? null,
      moneda: values.idMoneda === 52 ? "USD" : "PEN", // Mapeo dinámico (52=USD)
      tipoCambio: values.tipoCambio,
      baseGravada: baseGravada,
      baseExonerada: baseExonerada,
      baseInafecta: baseInafecta,
      impuesto: impuesto,
      total: total,
      saldoPendiente: total, // Inicialmente el saldo es el total
      idEstadoPago: 1, // 1: Pendiente (Asumiendo ID)
      observaciones: values.observaciones,
      detalles: values.detalles.map((d) => ({
        idProducto: d.idProducto,
        idVariante: null,
        descripcion: "", // Backend lo puede llenar o dejar vacío
        cantidad: d.cantidad,
        precioUnitarioCompra: d.precioUnitario, // Mapeo clave para que el backend lo reciba bien
        afectacionIgv: d.afectacionIgv as "G" | "E" | "I",
        subtotal: d.cantidad * d.precioUnitario,
      })),
    };

    registrar.mutate(payload, {
      onSuccess: () => onSuccess(),
    });
  };

  // Reglas de Negocio SUNAT y Bloqueos
  const idProveedor = form.watch("idProveedor");
  const { data: configReglas } = useReglasDocumentos();

  const proveedorSeleccionado = React.useMemo(
    () => listaProveedores?.find((p) => p.id === idProveedor),
    [listaProveedores, idProveedor],
  );

  const seccionBloqueada = !idProveedor || idProveedor === 0;

  const [codigoDocumentoProv, setCodigoDocumentoProv] = React.useState<
    string | undefined
  >();

  // Sincronizar código cuando el proveedor ya viene cargado (ej. edición o búsqueda)
  React.useEffect(() => {
    if (proveedorSeleccionado && configReglas?.reglas) {
      const regla = configReglas.reglas.find(
        (r) => r.id === proveedorSeleccionado.idTipoDocumento,
      );
      if (regla) setCodigoDocumentoProv(regla.codigo);
    }
  }, [proveedorSeleccionado, configReglas]);

  const idsPermitidos = React.useMemo(() => {
    if (!codigoDocumentoProv || !configReglas?.relaciones) return [];
    return configReglas.relaciones
      .filter((r) => r.codigoDocumento === codigoDocumentoProv)
      .map((r) => r.idTipoComprobante.toString());
  }, [codigoDocumentoProv, configReglas]);

  // Forzar Factura si es RUC (6) o aplicar regla de relación
  React.useEffect(() => {
    if (proveedorSeleccionado) {
      // Si solo permite uno (ej. RUC -> Factura), lo forzamos
      if (idsPermitidos.length === 1) {
        form.setValue("tipoComprobante", idsPermitidos[0]);
      } else if (
        idsPermitidos.length > 1 &&
        !idsPermitidos.includes(form.getValues("tipoComprobante"))
      ) {
        // Si el actual no es válido, limpiamos
        form.setValue("tipoComprobante", "");
      }
    }
  }, [proveedorSeleccionado, idsPermitidos, form]);

  // Calcular totales en tiempo real
  const valoresDetalles = form.watch("detalles");
  const baseGravadaCalc = valoresDetalles
    .filter((d) => d.afectacionIgv === "G")
    .reduce(
      (acc, curr) =>
        acc + (Number(curr.cantidad) || 0) * (Number(curr.precioUnitario) || 0),
      0,
    );
  const baseExoneradaCalc = valoresDetalles
    .filter((d) => d.afectacionIgv === "E")
    .reduce(
      (acc, curr) =>
        acc + (Number(curr.cantidad) || 0) * (Number(curr.precioUnitario) || 0),
      0,
    );
  const baseInafectaCalc = valoresDetalles
    .filter((d) => d.afectacionIgv === "I")
    .reduce(
      (acc, curr) =>
        acc + (Number(curr.cantidad) || 0) * (Number(curr.precioUnitario) || 0),
      0,
    );
  const subtotalCalc = baseGravadaCalc + baseExoneradaCalc + baseInafectaCalc;
  const impuestoCalc = calcularIGV(baseGravadaCalc); // Usando utilidad calcularIGV
  const totalCalculado = subtotalCalc + impuestoCalc;

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-6">
        {/* Buscador de Orden de Compra - Ocular en modo lectura */}
        {!readOnly && (
          <div className="bg-blue-50/50 p-4 rounded-lg border border-blue-100 flex items-center gap-4">
            <div className="flex-1 max-w-md relative">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
              <Input
                placeholder="Escriba código de Orden de Compra y presione Enter (ej. OC-001)..."
                className="pl-9 bg-white"
                value={busquedaOrden}
                onChange={(e) => setBusquedaOrden(e.target.value)}
                onKeyDown={handleBuscarOrden}
                disabled={buscandoOrden}
              />
            </div>
            {buscandoOrden && (
              <span className="text-sm text-muted-foreground animate-pulse">
                Buscando...
              </span>
            )}
            <div className="text-sm text-muted-foreground">
              <span className="font-semibold text-blue-700">Tip:</span> Presione
              Enter para cargar los datos automáticamente.
            </div>
          </div>
        )}

        {/* Cabecera del Documento */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
          <FormField
            control={form.control}
            name="idProveedor"
            render={({ field }) => (
              <FormItem className="col-span-3">
                <FormLabel>Proveedor</FormLabel>
                <FormControl>
                  <SelectorProveedorV2
                    value={field.value}
                    onChange={(p) => {
                      field.onChange(p?.id || 0);
                      if (!p) {
                        form.setValue("tipoComprobante", "");
                      }
                    }}
                    proveedores={listaProveedores}
                    onSearch={handleSearchProveedor}
                    onTipoDocChange={setCodigoDocumentoProv}
                    disabled={readOnly}
                  />
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />

          <FormField
            control={form.control}
            name="idAlmacen"
            render={({ field }) => (
              <FormItem className="col-span-1">
                <FormLabel>Almacén Destino</FormLabel>
                <FormControl>
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
                          format(field.value, "PPP", { locale: es })
                        ) : (
                          <span>Seleccione fecha</span>
                        )}
                        <CalendarIcon className="ml-auto h-4 w-4 opacity-50" />
                      </Button>
                    </FormControl>
                  </PopoverTrigger>
                  {!readOnly && (
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
                  )}
                </Popover>
                <FormMessage />
              </FormItem>
            )}
          />

          <FormField
            control={form.control}
            name="fechaVencimiento"
            render={({ field }) => (
              <FormItem className="flex flex-col mt-2">
                <FormLabel>Vencimiento (Opcional)</FormLabel>
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
                          format(field.value, "PPP", { locale: es })
                        ) : (
                          <span>Seleccione fecha</span>
                        )}
                        <CalendarIcon className="ml-auto h-4 w-4 opacity-50" />
                      </Button>
                    </FormControl>
                  </PopoverTrigger>
                  {!readOnly && (
                    <PopoverContent className="w-auto p-0" align="start">
                      <Calendar
                        mode="single"
                        selected={field.value ?? undefined}
                        onSelect={field.onChange}
                        initialFocus
                      />
                    </PopoverContent>
                  )}
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
              <SelectorTipoComprobante
                label="Tipo Comprobante"
                value={field.value}
                onChange={(val) => field.onChange(val.toString())}
                placeholder="Tipo (Factura)"
                disabled={
                  readOnly ||
                  seccionBloqueada ||
                  (proveedorSeleccionado && idsPermitidos.length === 1)
                }
                codigoDocumento={codigoDocumentoProv}
                modulo="COMPRA"
              />
            )}
          />

          <FormField
            control={form.control}
            name="serieComprobante"
            render={({ field }) => (
              <FormItem>
                <FormLabel>Serie</FormLabel>
                <FormControl>
                  <Input
                    {...field}
                    placeholder="F001"
                    disabled={seccionBloqueada || readOnly}
                  />
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />

          <FormField
            control={form.control}
            name="numeroComprobante"
            render={({ field }) => (
              <FormItem className={!readOnly ? "hidden" : ""}>
                <FormLabel>Número</FormLabel>
                <FormControl>
                  <Input
                    {...field}
                    placeholder="000123"
                    onChange={(e) =>
                      field.onChange(limpiarSoloNumeros(e.target.value))
                    }
                    onBlur={() => field.onChange(padIzquierda(field.value))}
                    disabled={seccionBloqueada || readOnly}
                  />
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
                codigo={ComprasConstantes.TablasGenerales.TIPO_MONEDA}
                label="Moneda"
                value={field.value}
                onChange={(val: string) => field.onChange(Number(val))}
                placeholder="Soles/Dólares"
                disabled={seccionBloqueada || readOnly}
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
                <div className="col-span-3">
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
                          }}
                          onProductSelect={(prod) => {
                            if (prod?.unidadMedida?.codigo) {
                              form.setValue(
                                `detalles.${index}.unidadMedida`,
                                prod.unidadMedida.codigo,
                              );
                            }
                          }}
                          disabled={readOnly}
                        />
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                </div>

                <div className="col-span-2">
                  <FormField
                    control={form.control}
                    name={`detalles.${index}.afectacionIgv`}
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel className={index !== 0 ? "sr-only" : ""}>
                          Afect. IGV
                        </FormLabel>
                        <FormControl>
                          <select
                            className="flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50"
                            {...field}
                            disabled={readOnly}
                          >
                            <option value="G">Gravado</option>
                            <option value="E">Exonerado</option>
                            <option value="I">Inafecto</option>
                          </select>
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                </div>

                <div className="col-span-1">
                  <FormField
                    control={form.control}
                    name={`detalles.${index}.unidadMedida`}
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel className={index !== 0 ? "sr-only" : ""}>
                          U.M.
                        </FormLabel>
                        <FormControl>
                          <Input
                            type="text"
                            {...field}
                            value={field.value || ""}
                            disabled
                            className="bg-muted/50 font-mono text-center text-xs"
                            placeholder="UND"
                          />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                </div>

                <div className="col-span-1">
                  <FormField
                    control={form.control}
                    name={`detalles.${index}.cantidad`}
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel className={index !== 0 ? "sr-only" : ""}>
                          Cant.
                        </FormLabel>
                        <FormControl>
                          <Input
                            type="text"
                            {...field}
                            onChange={(e) => {
                              field.onChange(limpiarDecimal(e.target.value));
                            }}
                            disabled={readOnly}
                            className="text-right"
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
                    name={`detalles.${index}.precioUnitario`}
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel className={index !== 0 ? "sr-only" : ""}>
                          P.U. (Sin IGV)
                        </FormLabel>

                        <FormControl>
                          <Input
                            type="text"
                            {...field}
                            onChange={(e) => {
                              field.onChange(limpiarDecimal(e.target.value));
                            }}
                            disabled={readOnly}
                            className="text-right font-mono"
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
                    <div className="h-9 flex justify-end items-center px-3 text-sm font-medium font-mono text-right">
                      {formatMoneda(
                        (Number(form.watch(`detalles.${index}.cantidad`)) ||
                          0) *
                          (Number(
                            form.watch(`detalles.${index}.precioUnitario`),
                          ) || 0),
                      )}
                    </div>
                  </div>
                </div>

                {!readOnly && (
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
                )}
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
                    cantidad: 1,
                    precioUnitario: 0,
                    afectacionIgv: "G",
                  })
                }
                className="mt-2"
              >
                <Plus className="h-4 w-4 mr-2" /> Agregar Item
              </Button>
            )}
          </div>

          <div className="flex flex-col items-end gap-2 text-base">
            <div className="flex justify-end gap-4 text-muted-foreground w-48">
              <span>Subtotal:</span>
              <span>{formatMoneda(subtotalCalc)}</span>
            </div>
            <div className="flex justify-end gap-4 text-muted-foreground w-48 border-b pb-2">
              <span>IGV (18%):</span>
              <span>{formatMoneda(impuestoCalc)}</span>
            </div>
            <div className="flex justify-end gap-4 text-xl font-bold w-48 pt-1">
              <span>Total:</span>
              <span>{formatMoneda(totalCalculado)}</span>
            </div>
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
                <Textarea
                  {...field}
                  value={field.value ?? ""}
                  disabled={readOnly}
                />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />

        <div className="flex justify-end gap-2 pt-4">
          <Button type="button" variant="outline" onClick={onCancel}>
            {readOnly ? "Cerrar" : "Cancelar"}
          </Button>
          {!readOnly && (
            <Button type="submit" disabled={registrar.isPending}>
              {registrar.isPending ? "Registrando..." : "Registrar Compra"}
            </Button>
          )}
        </div>
      </form>
    </Form>
  );
}
