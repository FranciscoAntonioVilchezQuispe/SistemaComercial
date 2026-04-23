import { useEffect, useState } from "react";
import { GridProductosPOS } from "../componentes/pos/GridProductosPOS";
import { CarritoCompras } from "../componentes/pos/CarritoCompras";
import { ModuleTabBar } from "@/componentes/shared/ModuleTabBar";
import { RUTAS_TITULOS } from "@/config/rutasTitulos";
import { ModalAperturaTurno } from "../componentes/pos/ModalAperturaTurno";
import { ModalCierreTurno } from "../componentes/pos/ModalCierreTurno";
import { ModalMovimientoCaja } from "../componentes/pos/ModalMovimientoCaja";
import { turnoService, TurnoVendedorDto } from "../servicios/turnoService";
import { Loader2, Receipt, LogOut, ArrowUpDown, Store } from "lucide-react";
import { Button } from "@/componentes/ui/button";

export function PaginaPOS() {
  const [turno, setTurno] = useState<TurnoVendedorDto | null>(null);
  const [cargando, setCargando] = useState(true);
  const [showModalApertura, setShowModalApertura] = useState(false);
  const [showModalCierre, setShowModalCierre] = useState(false);
  const [showModalMovimiento, setShowModalMovimiento] = useState(false);

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

  const handleTurnoCerrado = () => {
    setTurno(null);
    setShowModalCierre(false);
    setShowModalApertura(true);
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
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <ModuleTabBar tabs={tabsVentas} className="flex-1" />
        
        {turno && (
          <div className="flex items-center gap-2 px-4 py-1 bg-white dark:bg-slate-900 rounded-lg border shadow-sm">
            <div className="hidden md:flex items-center gap-2 mr-4 border-r pr-4 border-slate-200 dark:border-slate-800">
              <Store className="h-4 w-4 text-slate-400" />
              <span className="text-xs font-semibold text-slate-500">TURNO #{turno.id}</span>
            </div>
            
            <Button 
              variant="outline" 
              size="sm" 
              className="h-9 gap-2 text-xs font-bold"
              onClick={() => setShowModalMovimiento(true)}
            >
              <ArrowUpDown className="h-3.5 w-3.5 text-blue-500" />
              Movimiento
            </Button>

            <Button 
              variant="destructive" 
              size="sm" 
              className="h-9 gap-2 text-xs font-bold shadow-lg shadow-red-500/10"
              onClick={() => setShowModalCierre(true)}
            >
              <LogOut className="h-3.5 w-3.5" />
              Cerrar Turno
            </Button>
          </div>
        )}
      </div>
      
      {!turno && showModalApertura && (
          <ModalAperturaTurno 
              isOpen={showModalApertura} 
              onSuccess={handleTurnoAbierto} 
          />
      )}

      {turno && (
        <>
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-4 flex-1 overflow-hidden animate-in fade-in duration-500">
            {/* Productos - 2/3 del ancho */}
            <div className="lg:col-span-2 h-full overflow-hidden">
              <GridProductosPOS />
            </div>

            {/* Carrito - 1/3 del ancho */}
            <div className="h-full overflow-hidden">
              <CarritoCompras turnoId={turno.id} />
            </div>
          </div>

          <ModalCierreTurno 
            isOpen={showModalCierre}
            onClose={() => setShowModalCierre(false)}
            turnoId={turno.id}
            onSuccess={handleTurnoCerrado}
          />

          <ModalMovimientoCaja 
            isOpen={showModalMovimiento}
            onClose={() => setShowModalMovimiento(false)}
            cajaId={turno.cajaId}
            turnoId={turno.id}
            onSuccess={() => {}}
          />
        </>
      )}
    </div>
  );
}



