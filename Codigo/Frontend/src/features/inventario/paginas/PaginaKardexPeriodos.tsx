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
import { ContenedorPagina } from "@/compartido/componentes/ContenedorPagina";
import { kardexService } from "../servicios/servicioKardex";

type FormValues = {
  periodo: string;
};

export default function PaginaKardexPeriodos() {
  const [procesandoAbrir, setProcesandoAbrir] = useState(false);
  const [procesandoCerrar, setProcesandoCerrar] = useState(false);

  const {
    register,
    handleSubmit,
    formState: { errors },
    watch,
  } = useForm<FormValues>({
    defaultValues: {
      periodo: new Date().toISOString().slice(0, 7), // YYYY-MM
    },
  });

  const periodoObservado = watch("periodo");

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
      toast.error(error.response?.data?.message || "Error al abrir el periodo");
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
      toast.error(
        error.response?.data?.message || "Error al cerrar el periodo",
      );
    } finally {
      setProcesandoCerrar(false);
    }
  };

  return (
    <ContenedorPagina
      titulo="Control de Periodos del Kardex"
      descripcion="Abre o cierra meses fiscales para permitir u bloquear movimientos en el Kardex"
    >
      <div className="max-w-xl mt-6">
        <Card>
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
                >
                  <Unlock className="w-4 h-4 mr-2" />
                  Abrir Periodo {periodoObservado}
                </Button>
                <Button
                  onClick={handleSubmit(onCerrar)}
                  disabled={procesandoAbrir || procesandoCerrar}
                  variant="destructive"
                  className="w-full"
                >
                  <Lock className="w-4 h-4 mr-2" />
                  Cerrar Periodo {periodoObservado}
                </Button>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>
    </ContenedorPagina>
  );
}
