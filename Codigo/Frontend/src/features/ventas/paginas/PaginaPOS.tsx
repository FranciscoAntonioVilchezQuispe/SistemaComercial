import { GridProductosPOS } from "../componentes/pos/GridProductosPOS";
import { CarritoCompras } from "../componentes/pos/CarritoCompras";

export function PaginaPOS() {
  return (
    <div className="h-full p-4">
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-4 h-full">
        {/* Productos - 2/3 del ancho */}
        <div className="lg:col-span-2 h-full">
          <GridProductosPOS />
        </div>

        {/* Carrito - 1/3 del ancho */}
        <div className="h-full">
          <CarritoCompras />
        </div>
      </div>
    </div>
  );
}

export default PaginaPOS;
