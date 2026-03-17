import { GridProductosPOS } from "../componentes/pos/GridProductosPOS";
import { CarritoCompras } from "../componentes/pos/CarritoCompras";
import { ModuleTabBar } from "@/componentes/shared/ModuleTabBar";
import { RUTAS_TITULOS } from "@/config/rutasTitulos";

export function PaginaPOS() {
  const tabsVentas = [
    { label: RUTAS_TITULOS["/ventas/pos"], to: "/ventas/pos" },
    { label: RUTAS_TITULOS["/ventas/lista"], to: "/ventas/lista" },
    { label: RUTAS_TITULOS["/ventas/cotizaciones"], to: "/ventas/cotizaciones" },
    { label: RUTAS_TITULOS["/clientes"], to: "/clientes" },
  ];

  return (
    <div className="flex flex-col gap-4 h-full">
      <ModuleTabBar tabs={tabsVentas} />
      
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-4 flex-1 overflow-hidden">
        {/* Productos - 2/3 del ancho */}
        <div className="lg:col-span-2 h-full overflow-hidden">
          <GridProductosPOS />
        </div>

        {/* Carrito - 1/3 del ancho */}
        <div className="h-full overflow-hidden">
          <CarritoCompras />
        </div>
      </div>
    </div>
  );
}

export default PaginaPOS;
