import { useEffect } from "react";
import { useForm } from "react-hook-form";
import { Button } from "@/components/ui/button";
import {
  SerieComprobante,
  SerieComprobanteFormData,
} from "../tipos/serieComprobante.types";
import { useTiposComprobante } from "../hooks/useTiposComprobante";
import { useAlmacenes } from "../../inventario/almacenes/hooks/useAlmacenes";
import { padIzquierda, limpiarSoloNumeros } from "@compartido/utilidades";

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

  const {
    register,
    handleSubmit,
    reset,
    setValue,
    formState: { errors },
  } = useForm<SerieComprobanteFormData>({
    defaultValues: {
      correlativoActual: 0,
    },
  });

  useEffect(() => {
    if (datosIniciales) {
      reset(datosIniciales);
    } else if (idTipoPreseleccionado) {
      reset({ idTipoComprobante: idTipoPreseleccionado });
    }
  }, [datosIniciales, idTipoPreseleccionado, reset]);

  const inputClass =
    "flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm transition-colors file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50";
  const labelClass =
    "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70";

  return (
    <form onSubmit={handleSubmit(alEnviar)} className="space-y-4">
      {!idTipoPreseleccionado && (
        <div className="space-y-2">
          <label className={labelClass}>Tipo de Comprobante</label>
          <select
            className={inputClass}
            {...register("idTipoComprobante", {
              required: "El tipo es requerido",
              valueAsNumber: true,
            })}
          >
            <option value="">Seleccione un tipo...</option>
            {tipos?.map((t) => (
              <option key={t.id} value={t.id}>
                {t.nombre}
              </option>
            ))}
          </select>
          {errors.idTipoComprobante && (
            <p className="text-sm text-destructive">
              {errors.idTipoComprobante.message}
            </p>
          )}
        </div>
      )}
      {/* If preselected, hidden field */}
      {idTipoPreseleccionado && (
        <input
          type="hidden"
          {...register("idTipoComprobante", { valueAsNumber: true })}
        />
      )}

      <div className="space-y-2">
        <label className={labelClass}>Serie</label>
        <input
          className={inputClass}
          {...register("serie", { required: "La serie es requerida" })}
          placeholder="Ej: F001, B001"
        />
        {errors.serie && (
          <p className="text-sm text-destructive">{errors.serie.message}</p>
        )}
      </div>

      <div className="space-y-2">
        <label className={labelClass}>Correlativo Actual</label>
        <input
          type="text"
          className={inputClass}
          {...register("correlativoActual", {
            required: true,
            onBlur: (e) => {
              const val = limpiarSoloNumeros(e.target.value);
              setValue("correlativoActual", padIzquierda(val) as any);
            },
          })}
          defaultValue={0}
        />
      </div>

      <div className="space-y-2">
        <label className={labelClass}>Almacén pertecene (Opcional)</label>
        <select
          className={inputClass}
          {...register("idAlmacen", { valueAsNumber: true })}
        >
          <option value="">Seleccione un almacén...</option>
          {almacenes?.map((almacen: any) => (
            <option key={almacen.id} value={almacen.id}>
              {almacen.nombreAlmacen}
            </option>
          ))}
        </select>
      </div>

      <div className="flex justify-end gap-2 pt-4">
        <Button type="button" variant="outline" onClick={alCancelar}>
          Cancelar
        </Button>
        <Button type="submit" disabled={cargando}>
          {cargando ? "Guardando..." : datosIniciales ? "Actualizar" : "Crear"}
        </Button>
      </div>
    </form>
  );
}
