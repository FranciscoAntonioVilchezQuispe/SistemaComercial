import { useEffect } from "react";
import { useForm } from "react-hook-form";
import { Button } from "@/components/ui/button";
import { Loading } from "@compartido/componentes/feedback/Loading";
import { MensajeError } from "@compartido/componentes/feedback/MensajeError";
import { useEmpresa, useActualizarEmpresa } from "../hooks/useEmpresa";
import { EmpresaFormData } from "../tipos/empresa.types";
import { toast } from "sonner";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { ModuleTabBar } from "@/componentes/shared/ModuleTabBar";
import { RUTAS_TITULOS } from "@/config/rutasTitulos";

export function PaginaEmpresa() {
  const { data: empresa, isLoading, error } = useEmpresa();
  const actualizarMutation = useActualizarEmpresa();

  const {
    register,
    handleSubmit,
    reset,
    setValue,
    watch,
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
        console.error("Error al actualizar empresa:", err);
      },
    });
  };

  const tabsConfig = [
    { label: RUTAS_TITULOS["/configuracion/empresa"], to: "/configuracion/empresa" },
    { label: RUTAS_TITULOS["/configuracion/sucursales"], to: "/configuracion/sucursales" },
    { label: RUTAS_TITULOS["/configuracion/impuestos"], to: "/configuracion/impuestos" },
    { label: RUTAS_TITULOS["/configuracion/metodos-pago"], to: "/configuracion/metodos-pago" },
    { label: RUTAS_TITULOS["/configuracion/comprobantes"], to: "/configuracion/comprobantes" },
    { label: RUTAS_TITULOS["/configuracion/reglas-sunat"], to: "/configuracion/reglas-sunat" },
    { label: RUTAS_TITULOS["/configuracion/operaciones-sunat"], to: "/configuracion/operaciones-sunat" },
    { label: RUTAS_TITULOS["/configuracion/matriz-sunat"], to: "/configuracion/matriz-sunat" },
    { label: RUTAS_TITULOS["/configuracion/tablas-generales"], to: "/configuracion/tablas-generales" },

  ];

  if (isLoading) return <Loading mensaje="Cargando datos de empresa..." />;
  if (error) return <MensajeError mensaje={error.message} />;

  const labelClass = "text-sm font-medium leading-none";

  return (
    <div className="space-y-4">
      <ModuleTabBar tabs={tabsConfig} />

      <Card className="rounded-xl border border-muted/20 bg-card shadow-sm overflow-hidden">
        <CardHeader className="bg-muted/5 border-b pb-4">
          <CardTitle className="text-lg">Información Corporativa</CardTitle>
          <CardDescription>
            Configure los detalles legales y de contacto de su empresa.
          </CardDescription>
        </CardHeader>
        <CardContent className="p-6">
          <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              {/* RUC */}
              <div className="space-y-2">
                <Label className={labelClass}>RUC</Label>
                <Input
                  className="bg-muted/20 h-9"
                  {...register("ruc", {
                    required: "El RUC es requerido",
                    maxLength: 11,
                  })}
                />
                {errors.ruc && (
                  <p className="text-[11px] text-destructive font-medium">
                    {errors.ruc.message}
                  </p>
                )}
              </div>

              {/* Razón Social */}
              <div className="space-y-2">
                <Label className={labelClass}>Razón Social</Label>
                <Input
                  className="bg-muted/20 h-9"
                  {...register("razonSocial", {
                    required: "La Razón Social es requerida",
                  })}
                />
                {errors.razonSocial && (
                  <p className="text-[11px] text-destructive font-medium">
                    {errors.razonSocial.message}
                  </p>
                )}
              </div>

              {/* Nombre Comercial */}
              <div className="space-y-2">
                <Label className={labelClass}>Nombre Comercial</Label>
                <Input className="bg-muted/20 h-9" {...register("nombreComercial")} />
              </div>

              {/* Dirección Fiscal */}
              <div className="space-y-2 md:col-span-2">
                <Label className={labelClass}>Dirección Fiscal</Label>
                <Input
                  className="bg-muted/20 h-9"
                  {...register("direccionFiscal", {
                    required: "La Dirección es requerida",
                  })}
                />
                {errors.direccionFiscal && (
                  <p className="text-[11px] text-destructive font-medium">
                    {errors.direccionFiscal.message}
                  </p>
                )}
              </div>

              {/* Teléfono */}
              <div className="space-y-2">
                <Label className={labelClass}>Teléfono</Label>
                <Input className="bg-muted/20 h-9" {...register("telefono")} />
              </div>

              {/* Correo de Contacto */}
              <div className="space-y-2">
                <Label className={labelClass}>Correo de Contacto</Label>
                <Input
                  type="email"
                  className="bg-muted/20 h-9"
                  {...register("correoContacto")}
                />
              </div>

              {/* Sitio Web */}
              <div className="space-y-2">
                <Label className={labelClass}>Sitio Web</Label>
                <Input className="bg-muted/20 h-9" {...register("sitioWeb")} />
              </div>

              {/* Moneda Principal */}
              <div className="space-y-2">
                <Label className={labelClass}>Moneda Principal</Label>
                <Select
                  onValueChange={(val) => setValue("monedaPrincipal", val)}
                  value={watch("monedaPrincipal")}
                >
                  <SelectTrigger className="bg-muted/20 h-9">
                    <SelectValue placeholder="Seleccione moneda" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="PEN">Soles (PEN)</SelectItem>
                    <SelectItem value="USD">Dólares (USD)</SelectItem>
                  </SelectContent>
                </Select>
              </div>
            </div>

            <div className="flex justify-end pt-4 border-t">
              <Button
                type="submit"
                size="sm"
                disabled={!isDirty || actualizarMutation.isPending}
                className="px-8"
              >
                {actualizarMutation.isPending
                  ? "Guardando..."
                  : "Guardar Cambios"}
              </Button>
            </div>
          </form>
        </CardContent>
      </Card>
    </div>
  );
}

export default PaginaEmpresa;
