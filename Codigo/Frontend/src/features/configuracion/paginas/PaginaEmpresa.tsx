import { useEffect } from "react";
import { useForm } from "react-hook-form";
import { Button } from "@/components/ui/button";
import { Loading } from "@compartido/componentes/feedback/Loading";
import { MensajeError } from "@compartido/componentes/feedback/MensajeError";
import { useEmpresa, useActualizarEmpresa } from "../hooks/useEmpresa";
import { EmpresaFormData } from "../tipos/empresa.types";
import { toast } from "sonner";

export function PaginaEmpresa() {
  const { data: empresa, isLoading, error } = useEmpresa();
  const actualizarMutation = useActualizarEmpresa();

  const {
    register,
    handleSubmit,
    reset,
    formState: { errors, isDirty },
  } = useForm<EmpresaFormData>();

  useEffect(() => {
    if (empresa) {
      reset(empresa);
    }
  }, [empresa, reset]);

  const onSubmit = (data: EmpresaFormData) => {
    actualizarMutation.mutate(data, {
      onSuccess: () => {
        toast.success("Empresa actualizada correctamente");
      },
      onError: (err) => {
        toast.error("Error al actualizar empresa: " + err.message);
      },
      onSettled: () => {
        // Optionally reset isDirty, but react-hook-form handles it if we reset with new values or if values match.
        // Usually we might want to refetch or just let the mutation update the cache.
      },
    });
  };

  if (isLoading) return <Loading mensaje="Cargando datos de empresa..." />;

  // If 404, we might want to handle it optionally to allow creation, but for now just show error.
  if (error) return <MensajeError mensaje={error.message} />;

  const inputClass =
    "flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm transition-colors file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50";
  const labelClass =
    "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70";

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold">Datos de la Empresa</h1>
        <p className="text-muted-foreground">
          Gestión de la información corporativa y fiscal.
        </p>
      </div>

      <div className="rounded-xl border bg-card text-card-foreground shadow">
        <div className="flex flex-col space-y-1.5 p-6">
          <h3 className="font-semibold leading-none tracking-tight">
            Editar Información
          </h3>
          <p className="text-sm text-muted-foreground">
            Actualice los detalles que se mostrarán en reportes y comprobantes.
          </p>
        </div>
        <div className="p-6 pt-0">
          <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              {/* RUC */}
              <div className="space-y-2">
                <label className={labelClass}>RUC</label>
                <input
                  className={inputClass}
                  {...register("ruc", {
                    required: "El RUC es requerido",
                    maxLength: 11,
                  })}
                />
                {errors.ruc && (
                  <p className="text-sm text-destructive">
                    {errors.ruc.message}
                  </p>
                )}
              </div>

              {/* Razón Social */}
              <div className="space-y-2">
                <label className={labelClass}>Razón Social</label>
                <input
                  className={inputClass}
                  {...register("razonSocial", {
                    required: "La Razón Social es requerida",
                  })}
                />
                {errors.razonSocial && (
                  <p className="text-sm text-destructive">
                    {errors.razonSocial.message}
                  </p>
                )}
              </div>

              {/* Nombre Comercial */}
              <div className="space-y-2">
                <label className={labelClass}>Nombre Comercial</label>
                <input
                  className={inputClass}
                  {...register("nombreComercial")}
                />
              </div>

              {/* Dirección Fiscal */}
              <div className="space-y-2 md:col-span-2">
                <label className={labelClass}>Dirección Fiscal</label>
                <input
                  className={inputClass}
                  {...register("direccionFiscal", {
                    required: "La Dirección es requerida",
                  })}
                />
                {errors.direccionFiscal && (
                  <p className="text-sm text-destructive">
                    {errors.direccionFiscal.message}
                  </p>
                )}
              </div>

              {/* Teléfono */}
              <div className="space-y-2">
                <label className={labelClass}>Teléfono</label>
                <input className={inputClass} {...register("telefono")} />
              </div>

              {/* Correo de Contacto */}
              <div className="space-y-2">
                <label className={labelClass}>Correo de Contacto</label>
                <input
                  type="email"
                  className={inputClass}
                  {...register("correoContacto")}
                />
              </div>

              {/* Sitio Web */}
              <div className="space-y-2">
                <label className={labelClass}>Sitio Web</label>
                <input className={inputClass} {...register("sitioWeb")} />
              </div>

              {/* URL Logo */}
              <div className="space-y-2">
                <label className={labelClass}>URL de Logo</label>
                <input className={inputClass} {...register("logoUrl")} />
              </div>

              {/* Moneda Principal */}
              <div className="space-y-2">
                <label className={labelClass}>Moneda Principal</label>
                <select className={inputClass} {...register("monedaPrincipal")}>
                  <option value="PEN">Soles (PEN)</option>
                  <option value="USD">Dólares (USD)</option>
                </select>
              </div>
            </div>

            <div className="flex justify-end pt-4">
              <Button
                type="submit"
                disabled={!isDirty || actualizarMutation.isPending}
              >
                {actualizarMutation.isPending
                  ? "Guardando..."
                  : "Guardar Cambios"}
              </Button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
}
