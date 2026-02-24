import { useState } from "react";
import { Search, Package } from "lucide-react";
import { Input } from "@/components/ui/input";
import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { useQuery } from "@tanstack/react-query";
import { useProductos } from "@features/catalogo";
import { useCarrito } from "../../hooks/useCarrito";
import { useDebounce } from "@compartido/hooks/useDebounce";
import { formatearMoneda } from "@compartido/utilidades/moneda";
import { Loading } from "@compartido/componentes/feedback/Loading";
import { apiInventario } from "@/lib/axios";

// TODO: Obtener del contexto de usuario/sucursal. Por ahora almacén 1.
const ID_ALMACEN_POS = 1;

interface StockDto {
  idProducto: number;
  cantidadActual: number;
}

interface RespuestaStock {
  data: StockDto[];
}

export function GridProductosPOS() {
  const [busqueda, setBusqueda] = useState("");
  const busquedaDebounced = useDebounce(busqueda, 300);

  const { data, isLoading } = useProductos({
    search: busquedaDebounced,
    activo: true,
    pageNumber: 1,
    pageSize: 20,
  });

  // Cargar stock real desde Inventario.API
  const { data: stockData } = useQuery<RespuestaStock>({
    queryKey: ["stock-almacen", ID_ALMACEN_POS],
    queryFn: () =>
      apiInventario.get(`/inventario/stock/almacen/${ID_ALMACEN_POS}`),
    staleTime: 1000 * 30, // 30 segundos
  });

  // Mapa idProducto → cantidadActual para búsqueda O(1)
  const stockMap = new Map<number, number>(
    (stockData?.data ?? []).map((s) => [s.idProducto, s.cantidadActual]),
  );

  const { agregarProducto } = useCarrito();

  const productos = data?.datos || [];

  return (
    <div className="h-full flex flex-col gap-4">
      {/* Búsqueda */}
      <div className="relative">
        <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
        <Input
          placeholder="Buscar productos por nombre o código..."
          value={busqueda}
          onChange={(e) => setBusqueda(e.target.value)}
          className="pl-10"
        />
      </div>

      {/* Grid de productos */}
      <div className="flex-1 overflow-y-auto">
        {isLoading ? (
          <Loading mensaje="Cargando productos..." />
        ) : (
          <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
            {productos.map((producto) => {
              // Usar stock real de Inventario.API; si no hay registro = 0
              const stockReal = stockMap.get(producto.id) ?? 0;
              const stockBajo = stockReal <= producto.stockMinimo;
              const sinStock = stockReal === 0;

              return (
                <Card
                  key={producto.id}
                  className={`p-4 cursor-pointer hover:shadow-lg transition-shadow ${
                    sinStock ? "opacity-50 cursor-not-allowed" : ""
                  }`}
                  onClick={() => !sinStock && agregarProducto(producto, 1)}
                >
                  <div className="space-y-2">
                    {/* Imagen */}
                    <div className="relative aspect-square bg-muted rounded-lg flex items-center justify-center">
                      {producto.imagenPrincipalUrl ? (
                        <img
                          src={producto.imagenPrincipalUrl}
                          alt={producto.nombre}
                          className="w-full h-full object-cover rounded-lg"
                        />
                      ) : (
                        <Package className="h-12 w-12 text-muted-foreground" />
                      )}

                      {/* Badges */}
                      {stockBajo && !sinStock && (
                        <Badge
                          variant="destructive"
                          className="absolute top-2 right-2 text-xs"
                        >
                          Stock Bajo
                        </Badge>
                      )}
                      {sinStock && (
                        <Badge
                          variant="secondary"
                          className="absolute top-2 right-2 text-xs"
                        >
                          Sin Stock
                        </Badge>
                      )}
                    </div>

                    {/* Información */}
                    <div>
                      <p className="font-medium line-clamp-2 text-sm">
                        {producto.nombre}
                      </p>
                      <p className="text-xs text-muted-foreground">
                        {producto.codigo}
                      </p>
                    </div>

                    {/* Precio y stock */}
                    <div className="flex items-center justify-between">
                      <p className="text-lg font-bold text-primary">
                        {formatearMoneda(producto.precioVentaPublico)}
                      </p>
                      <p className="text-xs text-muted-foreground">
                        Stock: {stockReal}
                      </p>
                    </div>
                  </div>
                </Card>
              );
            })}
          </div>
        )}
      </div>
    </div>
  );
}
