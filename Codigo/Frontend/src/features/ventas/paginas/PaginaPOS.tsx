import { useEffect, useState } from "react";
import { GridProductosPOS } from "../componentes/pos/GridProductosPOS";
import { CarritoCompras } from "../componentes/pos/CarritoCompras";
import { ModuleTabBar } from "@/componentes/shared/ModuleTabBar";
import { RUTAS_TITULOS } from "@/config/rutasTitulos";
import { ModalAperturaTurno } from "../componentes/pos/ModalAperturaTurno";
import { turnoService, TurnoVendedorDto } from "../servicios/turnoService";
import { Loader2 } from "lucide-react";

export function PaginaPOS() {
  const [turno, setTurno] = useState<TurnoVendedorDto | null>(null);
  const [cargando, setCargando] = useState(true);
  const [showModalApertura, setShowModalApertura] = useState(false);

  useEffect(() => {
    verificarTurno();
  }, []);

  const verificarTurno = async () => {
    try {
      const data = await turnoService.obtenerTurnoActual();
      if (data) {
        setTurno(data);
      } else {
        setShowModalApertura(true);
      }
    } catch (error) {
      console.error("Error al verificar turno", error);
    } finally {
      setCargando(false);
    }
  };

  const handleTurnoAbierto = (nuevoTurno: TurnoVendedorDto) => {
    setTurno(nuevoTurno);
    setShowModalApertura(false);
  };

  const tabsVentas = [
    { label: RUTAS_TITULOS["/ventas/pos"], to: "/ventas/pos" },
    { label: RUTAS_TITULOS["/ventas/lista"], to: "/ventas/lista" },
    { label: RUTAS_TITULOS["/ventas/notas"], to: "/ventas/notas" },
    { label: RUTAS_TITULOS["/ventas/cotizaciones"], to: "/ventas/cotizaciones" },
    { label: RUTAS_TITULOS["/clientes"], to: "/clientes" },
  ];

  if (cargando) {
      return (
          <div className="h-full w-full flex flex-col items-center justify-center gap-4">
              <Loader2 className="h-10 w-10 animate-spin text-primary" />
              <p className="text-slate-500 animate-pulse font-medium">Validando sesión de caja...</p>
          </div>
      );
  }

  return (
    <div className="flex flex-col gap-4 h-full">
      <ModuleTabBar tabs={tabsVentas} />
      
      {!turno && showModalApertura && (
          <ModalAperturaTurno 
              isOpen={showModalApertura} 
              onSuccess={handleTurnoAbierto} 
          />
      )}

      {turno && (
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-4 flex-1 overflow-hidden animate-in">
            {/* Productos - 2/3 del ancho */}
            <div className="lg:col-span-2 h-full overflow-hidden">
              <GridProductosPOS />
            </div>

            {/* Carrito - 1/3 del ancho */}
            <div className="h-full overflow-hidden">
              <CarritoCompras turnoId={turno.id} />
            </div>
          </div>
      )}
    </div>
  );
}


