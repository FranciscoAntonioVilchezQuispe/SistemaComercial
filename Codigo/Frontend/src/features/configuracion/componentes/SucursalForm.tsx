import { useEffect } from "react";
import { useForm } from "react-hook-form";
import { Button } from "@/components/ui/button";
import { Sucursal, SucursalFormData } from "../tipos/sucursal.types";
import { useEmpresa } from "../hooks/useEmpresa";

interface SucursalFormProps {
  datosIniciales?: Sucursal;
  alEnviar: (datos: SucursalFormData) => void;
  alCancelar: () => void;
  cargando: boolean;
}

export function SucursalForm({
  datosIniciales,
  alEnviar,
  alCancelar,
  cargando,
}: SucursalFormProps) {
  const { data: empresa } = useEmpresa();

  const {
    register,
    handleSubmit,
    reset,
    formState: { errors },
  } = useForm<SucursalFormData>({
    defaultValues: {
      esPrincipal: false,
    },
  });

  useEffect(() => {
    if (datosIniciales) {
      reset(datosIniciales);
    } else if (empresa) {
      reset({ idEmpresa: empresa.id }); // Pre-set current company ID
    }
  }, [datosIniciales, empresa, reset]);

  const inputClass =
    "flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm transition-colors file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50";
  const labelClass =
    "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70";
  const checkboxClass =
    "h-4 w-4 rounded border-gray-300 text-primary focus:ring-primary";

  return (
    <form onSubmit={handleSubmit(alEnviar)} className="space-y-4">
      {/* Hidden Empresa ID */}
      <input type="hidden" {...register("idEmpresa")} />

      <div className="space-y-2">
        <label className={labelClass}>Nombre de Sucursal</label>
        <input
          className={inputClass}
          {...register("nombreSucursal", {
            required: "El nombre es requerido",
          })}
        />
        {errors.nombreSucursal && (
          <p className="text-sm text-destructive">
            {errors.nombreSucursal.message}
          </p>
        )}
      </div>

      <div className="space-y-2">
        <label className={labelClass}>Dirección</label>
        <input className={inputClass} {...register("direccion")} />
      </div>

      <div className="space-y-2">
        <label className={labelClass}>Teléfono</label>
        <input className={inputClass} {...register("telefono")} />
      </div>

      <div className="flex items-center space-x-2 pt-2">
        <input
          type="checkbox"
          id="esPrincipal"
          className={checkboxClass}
          {...register("esPrincipal")}
        />
        <label htmlFor="esPrincipal" className={labelClass}>
          Es Sucursal Principal
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
