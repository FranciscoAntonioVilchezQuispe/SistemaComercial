import { useEffect } from "react";
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
} from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Switch } from "@/components/ui/switch";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import {
  TipoComprobante,
  TipoComprobanteFormData,
} from "../tipos/tipoComprobante.types";

const schema = z.object({
  codigo: z.string().min(1, "El código es requerido"),
  nombre: z.string().min(1, "El nombre es requerido"),
  mueveStock: z.boolean().default(true),
  tipoMovimientoStock: z.string().default("DEPENDIENTE"),
  esCompra: z.boolean().default(false),
  esVenta: z.boolean().default(false),
  esOrdenCompra: z.boolean().default(false),
});

interface TipoComprobanteFormProps {
  datosIniciales?: TipoComprobante;
  alEnviar: (datos: TipoComprobanteFormData) => void;
  alCancelar: () => void;
  cargando: boolean;
}

export function TipoComprobanteForm({
  datosIniciales,
  alEnviar,
  alCancelar,
  cargando,
}: TipoComprobanteFormProps) {
  const form = useForm<z.infer<typeof schema>>({
    resolver: zodResolver(schema),
    defaultValues: {
      codigo: "",
      nombre: "",
      mueveStock: true,
      tipoMovimientoStock: "DEPENDIENTE",
      esCompra: false,
      esVenta: false,
      esOrdenCompra: false,
    },
  });

  const mueveStockValue = form.watch("mueveStock");

  useEffect(() => {
    if (datosIniciales) {
      form.reset({
        codigo: datosIniciales.codigo,
        nombre: datosIniciales.nombre,
        mueveStock: datosIniciales.mueveStock,
        tipoMovimientoStock:
          datosIniciales.tipoMovimientoStock || "DEPENDIENTE",
        esCompra: datosIniciales.esCompra,
        esVenta: datosIniciales.esVenta,
        esOrdenCompra: datosIniciales.esOrdenCompra,
      });
    }
  }, [datosIniciales, form]);

  const onSubmit = (values: z.infer<typeof schema>) => {
    alEnviar({
      codigo: values.codigo,
      nombre: values.nombre,
      mueveStock: values.mueveStock,
      tipoMovimientoStock: values.mueveStock
        ? values.tipoMovimientoStock
        : "NEUTRO",
      esCompra: values.esCompra,
      esVenta: values.esVenta,
      esOrdenCompra: values.esOrdenCompra,
    });
  };

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
        <FormField
          control={form.control}
          name="codigo"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Código SUNAT</FormLabel>
              <FormControl>
                <Input placeholder="Ej: 01, 03" {...field} />
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
              <FormLabel>Nombre</FormLabel>
              <FormControl>
                <Input placeholder="Ej: Factura, Boleta de Venta" {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />

        <div className="border rounded-md p-4 space-y-4">
          <FormField
            control={form.control}
            name="mueveStock"
            render={({ field }) => (
              <FormItem className="flex flex-row items-center justify-between">
                <div className="space-y-0.5">
                  <FormLabel>Afecta Inventario (Mueve Stock)</FormLabel>
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

          {mueveStockValue && (
            <FormField
              control={form.control}
              name="tipoMovimientoStock"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Tipo de Movimiento</FormLabel>
                  <Select onValueChange={field.onChange} value={field.value}>
                    <FormControl>
                      <SelectTrigger>
                        <SelectValue placeholder="Seleccione un tipo..." />
                      </SelectTrigger>
                    </FormControl>
                    <SelectContent>
                      <SelectItem value="DEPENDIENTE">
                        Depende de Operación (Venta/Compra)
                      </SelectItem>
                      <SelectItem value="ENTRADA">
                        Entrada (Aumenta Stock)
                      </SelectItem>
                      <SelectItem value="SALIDA">
                        Salida (Disminuye Stock)
                      </SelectItem>
                      <SelectItem value="NEUTRO">
                        Neutro (No Afecta - Informativo)
                      </SelectItem>
                    </SelectContent>
                  </Select>
                  <p className="text-xs text-muted-foreground pt-1">
                    Determina cómo afectará este comprobante al Kardex.
                  </p>
                  <FormMessage />
                </FormItem>
              )}
            />
          )}
        </div>

        <div className="border rounded-md p-4 space-y-4">
          <p className="text-sm font-medium leading-none">
            Módulos donde es visible
          </p>
          <div className="flex flex-col space-y-3 pt-2">
            <FormField
              control={form.control}
              name="esCompra"
              render={({ field }) => (
                <FormItem className="flex flex-row items-center justify-between">
                  <div className="space-y-0.5">
                    <FormLabel>Compras</FormLabel>
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

            <FormField
              control={form.control}
              name="esVenta"
              render={({ field }) => (
                <FormItem className="flex flex-row items-center justify-between">
                  <div className="space-y-0.5">
                    <FormLabel>Ventas</FormLabel>
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

            <FormField
              control={form.control}
              name="esOrdenCompra"
              render={({ field }) => (
                <FormItem className="flex flex-row items-center justify-between">
                  <div className="space-y-0.5">
                    <FormLabel>Orden de Compra</FormLabel>
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
        </div>

        <div className="flex justify-end gap-2 pt-4">
          <Button type="button" variant="outline" onClick={alCancelar}>
            Cancelar
          </Button>
          <Button type="submit" disabled={cargando}>
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
