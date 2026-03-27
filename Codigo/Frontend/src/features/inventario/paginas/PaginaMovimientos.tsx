import { useState } from "react";
import { Search, ArrowUpDown } from "lucide-react";
import { useMovimientos, useTiposMovimiento } from "../hooks/useInventario";
import { usePagination } from "@/hooks/usePagination";
import { TablaMovimientos } from "../componentes/movimientos/TablaMovimientos";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card, CardContent } from "@/components/ui/card";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { SelectorRangoFecha } from "@/compartido/componentes/formularios/SelectorRangoFecha";
import { MovimientoFiltros } from "../tipos/inventario.types";
import { ModuleTabBar } from "@/componentes/shared/ModuleTabBar";
import { RUTAS_TITULOS } from "@/config/rutasTitulos";

export function PaginaMovimientos() {
  const {
    paginacion,
    cambiarPagina,
    cambiarPageSize,
    cambiarBusqueda,
  } = usePagination();
  
  const [filtros, setFiltros] = useState<MovimientoFiltros>({});

  const { data, isLoading } = useMovimientos(paginacion, filtros);
  const { data: tipos } = useTiposMovimiento();

  const tabsInventario = [
    { label: RUTAS_TITULOS["/inventario/stock"], to: "/inventario/stock" },
    { label: RUTAS_TITULOS["/inventario/movimientos"], to: "/inventario/movimientos" },
    { label: RUTAS_TITULOS["/inventario/traslados"], to: "/inventario/traslados" },
    { label: RUTAS_TITULOS["/inventario/kardex/reporte"], to: "/inventario/kardex/reporte" },
    { label: RUTAS_TITULOS["/inventario/kardex/periodos"], to: "/inventario/kardex/periodos" },
    { label: RUTAS_TITULOS["/inventario/almacenes"], to: "/inventario/almacenes" },
  ];

  return (
    <div className="space-y-4">
      <ModuleTabBar tabs={tabsInventario} />

      <div className="flex justify-end gap-2 mb-2">
        <Button variant="outline" size="sm">
          <ArrowUpDown className="mr-2 h-4 w-4" />
          Reporte Kardex
        </Button>
      </div>

      <Card className="shadow-none border-muted/20">
        <CardContent className="pt-6">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div className="relative">
              <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
              <Input
                placeholder="Buscar por producto o ref..."
                className="pl-8"
                onChange={(e) => cambiarBusqueda(e.target.value)}
              />
            </div>
            <Select
              onValueChange={(val) =>
                setFiltros({ ...filtros, idTipoMovimiento: Number(val) })
              }
            >
              <SelectTrigger>
                <SelectValue placeholder="Tipo Movimiento" />
              </SelectTrigger>
              <SelectContent>
                {tipos?.map((t: any) => (
                  <SelectItem key={t.id} value={t.id.toString()}>
                    {t.nombre}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
            <div className="col-span-1 md:col-span-2 flex gap-2">
              <SelectorRangoFecha
                alCambiarRango={(rango) =>
                  setFiltros({
                    ...filtros,
                    fechaInicio: rango?.from?.toISOString(),
                    fechaFin: rango?.to?.toISOString(),
                  })
                }
              />
              <Button variant="ghost" onClick={() => setFiltros({})} size="sm">
                Limpiar
              </Button>
            </div>
          </div>
        </CardContent>
      </Card>

      <Card className="shadow-none border-muted/20">
        <CardContent className="pt-6">
          <TablaMovimientos
            movimientos={data?.datos || []}
            isLoading={isLoading}
            pagination={data}
            onPageChange={cambiarPagina}
            onPageSizeChange={cambiarPageSize}
            onSearchChange={cambiarBusqueda}
          />
        </CardContent>
      </Card>
    </div>
  );
}
