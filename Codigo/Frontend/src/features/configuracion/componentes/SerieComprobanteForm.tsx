import { useEffect, useState } from "react";
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
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import {
  SerieComprobante,
  SerieComprobanteFormData,
} from "../tipos/serieComprobante.types";
import { useTiposComprobante } from "../hooks/useTiposComprobante";
import { useAlmacenes } from "../../inventario/almacenes/hooks/useAlmacenes";
import { padIzquierda, limpiarSoloNumeros } from "@compartido/utilidades";

const schema = z.object({
  idTipoComprobante: z.coerce.number().min(1, "El tipo es requerido"),
  serie: z.string().min(1, "La serie es requerida"),
  correlativoActual: z.coerce.number().min(0, "Debe ser al menos 0"),
  idAlmacen: z.coerce.number().optional().nullable(),
});

interface SerieComprobanteFormProps {
  datosIniciales?: SerieComprobante;
  idTipoPreseleccionado?: number | null;
  alEnviar: (datos: SerieComprobanteFormData) => void;
  alCancelar: () => void;
  cargando: boolean;
}

export function SerieComprobanteForm({
  datosIniciales,
  idTipoPreseleccionado,
  alEnviar,
  alCancelar,
  cargando,
}: SerieComprobanteFormProps) {
  const { data: tipos } = useTiposComprobante();
  const { data: almacenes } = useAlmacenes();

  const [inputCorrelativo, setInputCorrelativo] = useState("00000000");

  const form = useForm<z.infer<typeof schema>>({
    resolver: zodResolver(schema),
    defaultValues: {
      idTipoComprobante: idTipoPreseleccionado || 0,
      serie: "",
      correlativoActual: 0,
      idAlmacen: null,
    },
  });

  useEffect(() => {
    if (datosIniciales) {
      form.reset({
        idTipoComprobante: datosIniciales.idTipoComprobante,
        serie: datosIniciales.serie,
        correlativoActual: datosIniciales.correlativoActual,
        idAlmacen: datosIniciales.idAlmacen,
      });
      setInputCorrelativo(
        padIzquierda(String(datosIniciales.correlativoActual)),
      );
    } else if (idTipoPreseleccionado) {
      form.setValue("idTipoComprobante", idTipoPreseleccionado);
    }
  }, [datosIniciales, idTipoPreseleccionado, form]);

  const onSubmit = (values: z.infer<typeof schema>) => {
    alEnviar({
      idTipoComprobante: values.idTipoComprobante,
      serie: values.serie,
      correlativoActual: Number(inputCorrelativo) || 0,
      idAlmacen: values.idAlmacen || undefined,
    });
  };

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
        {!idTipoPreseleccionado && (
          <FormField
            control={form.control}
            name="idTipoComprobante"
            render={({ field }) => (
              <FormItem>
                <FormLabel>Tipo de Comprobante</FormLabel>
                <Select
                  onValueChange={field.onChange}
                  value={field.value ? String(field.value) : ""}
                >
                  <FormControl>
                    <SelectTrigger>
                      <SelectValue placeholder="Seleccione un tipo..." />
                    </SelectTrigger>
                  </FormControl>
                  <SelectContent>
                    {tipos?.map((t) => (
                      <SelectItem key={t.id} value={String(t.id)}>
                        {t.nombre}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
                <FormMessage />
              </FormItem>
            )}
          />
        )}

        {/* If preselected, hidden field */}
        {idTipoPreseleccionado && (
          <input
            type="hidden"
            {...form.register("idTipoComprobante")}
            value={idTipoPreseleccionado}
          />
        )}

        <FormField
          control={form.control}
          name="serie"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Serie</FormLabel>
              <FormControl>
                <Input placeholder="Ej: F001, B001" {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />

        {/* Mantenemos un input local para el padding, pero controlamos en submit y en Zod */}
        <div className="space-y-2">
          <FormLabel>Correlativo Actual</FormLabel>
          <Input
            value={inputCorrelativo}
            onChange={(e) => {
              const val = limpiarSoloNumeros(e.target.value);
              setInputCorrelativo(val);
            }}
            onBlur={() => {
              setInputCorrelativo(padIzquierda(inputCorrelativo));
              form.setValue("correlativoActual", Number(inputCorrelativo) || 0);
            }}
            placeholder="00000000"
          />
          {form.formState.errors.correlativoActual && (
            <p className="text-sm font-medium text-destructive">
              {form.formState.errors.correlativoActual.message}
            </p>
          )}
        </div>

        <FormField
          control={form.control}
          name="idAlmacen"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Almacén pertecene (Opcional)</FormLabel>
              <Select
                onValueChange={field.onChange}
                value={field.value ? String(field.value) : ""}
              >
                <FormControl>
                  <SelectTrigger>
                    <SelectValue placeholder="Seleccione un almacén..." />
                  </SelectTrigger>
                </FormControl>
                <SelectContent>
                  {almacenes?.map((almacen: any) => (
                    <SelectItem key={almacen.id} value={String(almacen.id)}>
                      {almacen.nombreAlmacen}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
              <FormMessage />
            </FormItem>
          )}
        />

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
