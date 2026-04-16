import { useState } from "react";
import { useForm } from "react-hook-form";
import { toast } from "sonner";
import { Lock, Unlock, CalendarDays } from "lucide-react";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/componentes/ui/card";
import { Button } from "@/componentes/ui/button";
import { Input } from "@/componentes/ui/input";
import { kardexService } from "../servicios/servicioKardex";
import { getCurrentPeriod } from "@/lib/datetime";

type FormValues = {
  periodo: string;
};

import { ModuleTabBar } from "@/componentes/shared/ModuleTabBar";
import { RUTAS_TITULOS } from "@/config/rutasTitulos";

export function PaginaKardexPeriodos() {
  const [procesandoAbrir, setProcesandoAbrir] = useState(false);
  const [procesandoCerrar, setProcesandoCerrar] = useState(false);

  const {
    register,
    handleSubmit,
    formState: { errors },
    watch,
  } = useForm<FormValues>({
    defaultValues: {
      periodo: getCurrentPeriod(), // YYYY-MM
    },
  });

  const periodoObservado = watch("periodo");

  const tabsInventario = [
     { label: RUTAS_TITULOS["/inventario/stock"], to: "/inventario/stock" },
    { label: RUTAS_TITULOS["/inventario/movimientos"], to: "/inventario/movimientos" },
    { label: RUTAS_TITULOS["/inventario/traslados"], to: "/inventario/traslados" },
    { label: RUTAS_TITULOS["/inventario/kardex/reporte"], to: "/inventario/kardex/reporte" },
    { label: RUTAS_TITULOS["/inventario/kardex/periodos"], to: "/inventario/kardex/periodos" },
    { label: RUTAS_TITULOS["/inventario/almacenes"], to: "/inventario/almacenes" },
  ];

  const onAbrir = async (data: FormValues) => {
    try {
      setProcesandoAbrir(true);
      // Hardcoded UsuarioId for now, should come from Auth context ideally
      const res = await kardexService.abrirPeriodo({
        periodo: data.periodo,
        usuarioId: 1,
      });
      toast.success(res.message || `Periodo ${data.periodo} abierto`);
    } catch (error: any) {
      console.error("Error al abrir el periodo:", error);
    } finally {
      setProcesandoAbrir(false);
    }
  };

  const onCerrar = async (data: FormValues) => {
    try {
      setProcesandoCerrar(true);
      const res = await kardexService.cerrarPeriodo({
        periodo: data.periodo,
        usuarioId: 1,
      });
      toast.success(res.message || `Periodo ${data.periodo} cerrado`);
    } catch (error: any) {
      console.error("Error al cerrar el periodo:", error);
    } finally {
      setProcesandoCerrar(false);
    }
  };

  return (
    <div className="space-y-4">
      <ModuleTabBar tabs={tabsInventario} />

      <div className="max-w-xl">
        <Card className="shadow-none border-muted/20">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <CalendarDays className="h-5 w-5" />
              Gestión de Mes Fiscal
            </CardTitle>
            <CardDescription>
              Operaciones válidas solo si el mes anterior está cerrado. Formato
              requerido: AAAA-MM
            </CardDescription>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              <div>
                <label className="text-sm font-medium mb-1 block">
                  Periodo a Gestionar
                </label>
                <Input
                  type="month"
                  {...register("periodo", {
                    required: "Este campo es obligatorio",
                  })}
                  className="w-full"
                />
                {errors.periodo && (
                  <p className="text-red-500 text-sm mt-1">
                    {errors.periodo.message}
                  </p>
                )}
              </div>

              <div className="flex gap-4 pt-4">
                <Button
                  onClick={handleSubmit(onAbrir)}
                  disabled={procesandoAbrir || procesandoCerrar}
                  className="w-full bg-green-600 hover:bg-green-700 text-white"
                  size="sm"
                >
                  <Unlock className="w-4 h-4 mr-2" />
                  Abrir Periodo {periodoObservado}
                </Button>
                <Button
                  onClick={handleSubmit(onCerrar)}
                  disabled={procesandoAbrir || procesandoCerrar}
                  variant="destructive"
                  className="w-full"
                  size="sm"
                >
                  <Lock className="w-4 h-4 mr-2" />
                  Cerrar Periodo {periodoObservado}
                </Button>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
