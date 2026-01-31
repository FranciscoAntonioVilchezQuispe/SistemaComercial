import { useEffect } from "react";
import { useForm } from "react-hook-form";
import { Button } from "@/components/ui/button";
import { MetodoPago, MetodoPagoFormData } from "../tipos/metodoPago.types";

interface MetodoPagoFormProps {
  datosIniciales?: MetodoPago;
  alEnviar: (datos: MetodoPagoFormData) => void;
  alCancelar: () => void;
  cargando: boolean;
}

export function MetodoPagoForm({
  datosIniciales,
  alEnviar,
  alCancelar,
  cargando,
}: MetodoPagoFormProps) {
  const {
    register,
    handleSubmit,
    reset,
    formState: { errors },
  } = useForm<MetodoPagoFormData>({
    defaultValues: {
      esEfectivo: false,
    },
  });

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
        <label className={labelClass}>Código</label>
        <input
          className={inputClass}
          {...register("codigo", { required: "El código es requerido" })}
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
        />
        {errors.nombre && (
          <p className="text-sm text-destructive">{errors.nombre.message}</p>
        )}
      </div>

      <div className="space-y-2">
        {/* TODO: Add logic to select "Tipo Documento Pago" if applicable (from catalog or other source) */}
        <label className={labelClass}>ID Tipo Documento (Opcional)</label>
        <input
          type="number"
          className={inputClass}
          {...register("idTipoDocumentoPago", { valueAsNumber: true })}
        />
      </div>

      <div className="flex items-center space-x-2 pt-2">
        <input
          type="checkbox"
          id="esEfectivo"
          className={checkboxClass}
          {...register("esEfectivo")}
        />
        <label htmlFor="esEfectivo" className={labelClass}>
          Es Efectivo
        </label>
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
