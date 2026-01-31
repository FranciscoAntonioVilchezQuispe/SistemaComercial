import { useEffect } from "react";
import { useForm } from "react-hook-form";
import { Button } from "@/components/ui/button";
import {
  TipoComprobante,
  TipoComprobanteFormData,
} from "../tipos/tipoComprobante.types";

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
  const {
    register,
    handleSubmit,
    reset,
    watch,
    formState: { errors },
  } = useForm<TipoComprobanteFormData>({
    defaultValues: {
      mueveStock: true,
      tipoMovimientoStock: "DEPENDIENTE",
    },
  });

  const mueveStockValue = watch("mueveStock");

  useEffect(() => {
    if (datosIniciales) {
      reset(datosIniciales);
    }
  }, [datosIniciales, reset]);

  const inputClass =
    "flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm transition-colors file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50";
  const labelClass =
    "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70";
  const checkboxClass =
    "h-4 w-4 rounded border-gray-300 text-primary focus:ring-primary";

  return (
    <form onSubmit={handleSubmit(alEnviar)} className="space-y-4">
      <div className="space-y-2">
        <label className={labelClass}>Código SUNAT</label>
        <input
          className={inputClass}
          {...register("codigo", { required: "El código es requerido" })}
          placeholder="Ej: 01, 03"
        />
        {errors.codigo && (
          <p className="text-sm text-destructive">{errors.codigo.message}</p>
        )}
      </div>

      <div className="space-y-2">
        <label className={labelClass}>Nombre</label>
        <input
          className={inputClass}
          {...register("nombre", { required: "El nombre es requerido" })}
          placeholder="Ej: Factura, Boleta de Venta"
        />
        {errors.nombre && (
          <p className="text-sm text-destructive">{errors.nombre.message}</p>
        )}
      </div>

      <div className="border rounded-md p-4 space-y-4">
        <div className="flex items-center space-x-2">
          <input
            type="checkbox"
            id="mueveStock"
            className={checkboxClass}
            {...register("mueveStock")}
          />
          <label htmlFor="mueveStock" className={labelClass}>
            Afecta Inventario (Mueve Stock)
          </label>
        </div>

        {mueveStockValue && (
          <div className="space-y-2">
            <label className={labelClass}>Tipo de Movimiento</label>
            <select className={inputClass} {...register("tipoMovimientoStock")}>
              <option value="DEPENDIENTE">
                Depende de Operación (Venta/Compra)
              </option>
              <option value="ENTRADA">Entrada (Aumenta Stock)</option>
              <option value="SALIDA">Salida (Disminuye Stock)</option>
              <option value="NEUTRO">Neutro (No Afecta - Informativo)</option>
            </select>
            <p className="text-xs text-muted-foreground">
              Determina cómo afectará este comprobante al Kardex.
            </p>
          </div>
        )}
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
