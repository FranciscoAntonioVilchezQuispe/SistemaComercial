import { useState } from "react";
import { Search, ArrowUpDown } from "lucide-react";
import { useMovimientos, useTiposMovimiento } from "../hooks/useInventario";
import { TablaMovimientos } from "../componentes/movimientos/TablaMovimientos";
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
import { SelectorRangoFecha } from "@/compartido/componentes/formularios/SelectorRangoFecha";
import { MovimientoFiltros } from "../tipos/inventario.types";

export function PaginaMovimientos() {
  const [pagina] = useState(1);
  const [filtros, setFiltros] = useState<MovimientoFiltros>({});

  const { data, isLoading } = useMovimientos(filtros, pagina, 10);
  const { data: tipos } = useTiposMovimiento();

  return (
    <div className="p-6 space-y-6">
      <div className="flex justify-between items-center flex-wrap gap-4">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">
            Movimientos de Inventario
          </h1>
          <p className="text-muted-foreground">
            Historial detallado de todas las entradas, salidas y ajustes
            realizados.
          </p>
        </div>
        <div className="flex gap-2">
          <Button variant="outline">
            <ArrowUpDown className="mr-2 h-4 w-4" />
            Reporte Kardex
          </Button>
        </div>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Búsqueda y Filtros Históricos</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div className="relative">
              <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
              <Input
                placeholder="Buscar por producto o ref..."
                className="pl-8"
                onChange={(e) =>
                  setFiltros({
                    ...filtros,
                    idProducto: Number(e.target.value) || undefined,
                  })
                }
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
              <Button variant="ghost" onClick={() => setFiltros({})}>
                Limpiar
              </Button>
            </div>
          </div>
        </CardContent>
      </Card>

      <Card>
        <CardContent className="pt-6">
          <TablaMovimientos
            movimientos={data?.datos || []}
            isLoading={isLoading}
          />
        </CardContent>
      </Card>
    </div>
  );
}
