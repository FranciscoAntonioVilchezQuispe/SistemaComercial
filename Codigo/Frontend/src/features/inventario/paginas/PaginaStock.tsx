import { useState } from "react";
import { Search, Package, AlertTriangle, Plus, History } from "lucide-react";
import { useStock, useAlmacenes } from "../hooks/useInventario";
import { TablaStock } from "../componentes/stock/TablaStock";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { InventarioFiltros, StockProducto } from "../tipos/inventario.types";
import { ExportadorTabla } from "@/compartido/componentes/tablas/ExportadorTabla";

export function PaginaStock() {
  const [filtros, setFiltros] = useState<InventarioFiltros>({});

  const { data, isLoading } = useStock(filtros);
  const { data: almacenes } = useAlmacenes();

  const handleVerKardex = (item: StockProducto) => {
    console.log("Ver Kardex de:", item.idProducto);
    // Redirigir a página de Kardex con params
  };

  const handleAjustar = (item: StockProducto) => {
    console.log("Ajustar stock de:", item.idProducto);
    // Abrir modal de ajuste
  };

  const columnasExportar = [
    { clave: "producto" as any, titulo: "Producto" },
    { clave: "almacen" as any, titulo: "Almacén" },
    { clave: "cantidadActual" as any, titulo: "Stock Actual" },
    { clave: "ubicacion" as any, titulo: "Ubicación" },
  ];

  return (
    <div className="p-6 space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">
            Stock de Inventario
          </h1>
          <p className="text-muted-foreground">
            Consulta y gestiona las existencias en tiempo real por almacén.
          </p>
        </div>
        <div className="flex items-center gap-2">
          <ExportadorTabla
            datos={data?.datos || []}
            nombreArchivo="stock_inventario"
            columnas={columnasExportar}
          />
          <Button variant="default">
            <Plus className="mr-2 h-4 w-4" />
            Nuevo Movimiento
          </Button>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <Card className="bg-primary/5 border-primary/20">
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">
              Total Productos
            </CardTitle>
            <Package className="h-4 w-4 text-primary" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{data?.total || 0}</div>
            <p className="text-xs text-muted-foreground">
              En todos los almacenes
            </p>
          </CardContent>
        </Card>
        <Card className="bg-destructive/5 border-destructive/20">
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Stock Bajo</CardTitle>
            <AlertTriangle className="h-4 w-4 text-destructive" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-destructive">
              {data?.datos.filter(
                (d: StockProducto) => d.cantidadActual <= d.cantidadMinima,
              ).length || 0}
            </div>
            <p className="text-xs text-muted-foreground">
              Requieren reposición urgente
            </p>
          </CardContent>
        </Card>
        <Card className="bg-green-500/5 border-green-500/20">
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Almacenes</CardTitle>
            <History className="h-4 w-4 text-green-500" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{almacenes?.length || 0}</div>
            <p className="text-xs text-muted-foreground">
              Puntos de control activos
            </p>
          </CardContent>
        </Card>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Búsqueda y Filtros</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div className="relative col-span-1 md:col-span-2">
              <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
              <Input
                placeholder="Buscar por nombre o código de producto..."
                className="pl-8"
                value={filtros.busqueda || ""}
                onChange={(e) =>
                  setFiltros({ ...filtros, busqueda: e.target.value })
                }
              />
            </div>
            <Select
              onValueChange={(val) =>
                setFiltros({ ...filtros, idAlmacen: Number(val) })
              }
            >
              <SelectTrigger>
                <SelectValue placeholder="Todos los Almacenes" />
              </SelectTrigger>
              <SelectContent>
                {almacenes?.map((a: any) => (
                  <SelectItem key={a.id} value={a.id.toString()}>
                    {a.nombre}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
            <Button
              variant={filtros.bajoStock ? "destructive" : "outline"}
              onClick={() =>
                setFiltros({ ...filtros, bajoStock: !filtros.bajoStock })
              }
            >
              <AlertTriangle className="mr-2 h-4 w-4" />
              {filtros.bajoStock ? "Ver Todos" : "Sólo Stock Bajo"}
            </Button>
          </div>
        </CardContent>
      </Card>

      <Card>
        <CardContent className="pt-6">
          <TablaStock
            stock={data?.datos || []}
            isLoading={isLoading}
            onAjustar={handleAjustar}
            onVerKardex={handleVerKardex}
          />
        </CardContent>
      </Card>
    </div>
  );
}
