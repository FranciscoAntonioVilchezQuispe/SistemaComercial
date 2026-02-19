import { Package } from "lucide-react";
import { Card, CardContent, CardFooter } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Producto } from "../../tipos/catalogo.types";
import { formatearMoneda } from "@compartido/utilidades/moneda";

interface PropiedadesTarjetaProducto {
  producto: Producto;
  alSeleccionar?: (producto: Producto) => void;
  alEditar?: (producto: Producto) => void;
  mostrarAcciones?: boolean;
}

export function TarjetaProducto({
  producto,
  alSeleccionar,
  alEditar,
  mostrarAcciones = true,
}: PropiedadesTarjetaProducto) {
  const stockBajo = producto.stock <= producto.stockMinimo;

  return (
    <Card className="overflow-hidden hover:shadow-lg transition-shadow cursor-pointer">
      <div
        className="relative h-48 bg-muted flex items-center justify-center"
        onClick={() => alSeleccionar?.(producto)}
      >
        {producto.imagenPrincipalUrl ? (
          <img
            src={producto.imagenPrincipalUrl}
            alt={producto.nombre}
            className="w-full h-full object-cover"
          />
        ) : (
          <Package className="h-16 w-16 text-muted-foreground" />
        )}

        {/* Badges de estado */}
        <div className="absolute top-2 right-2 flex flex-col gap-1">
          {!producto.activo && <Badge variant="secondary">Inactivo</Badge>}
          {stockBajo && <Badge variant="destructive">Stock Bajo</Badge>}
        </div>
      </div>

      <CardContent className="p-4">
        <div className="space-y-2">
          <div>
            <h3 className="font-semibold line-clamp-2">{producto.nombre}</h3>
            <p className="text-sm text-muted-foreground">{producto.codigo}</p>
          </div>

          {producto.descripcion && (
            <p className="text-sm text-muted-foreground line-clamp-2">
              {producto.descripcion}
            </p>
          )}

          <div className="flex items-center justify-between">
            <div>
              <p className="text-2xl font-bold text-primary">
                {formatearMoneda(producto.precioVentaPublico)}
              </p>
              <p className="text-xs text-muted-foreground">
                Stock: {producto.stock} {producto.unidadMedida?.nombre}
              </p>
            </div>
          </div>
        </div>
      </CardContent>

      {mostrarAcciones && (
        <CardFooter className="p-4 pt-0 flex gap-2">
          <Button
            variant="outline"
            className="flex-1"
            onClick={() => alSeleccionar?.(producto)}
          >
            Ver Detalle
          </Button>
          <Button
            variant="default"
            className="flex-1"
            onClick={() => alEditar?.(producto)}
          >
            Editar
          </Button>
        </CardFooter>
      )}
    </Card>
  );
}
