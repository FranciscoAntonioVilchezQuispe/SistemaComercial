import { useState } from "react";
import { 
  ArrowLeft, 
  RefreshCcw
} from "lucide-react";
import { useNavigate } from "react-router-dom";
import { useReporteStockCritico, useListaAlmacenes } from "../../inventario/hooks/useInventario";
import { usePagination } from "@/hooks/usePagination";
import { Button } from "@/componentes/ui/button";
import { Card, CardContent } from "@/componentes/ui/card";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/componentes/ui/table";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/componentes/ui/select";
import { ExportadorTabla } from "@/compartido/componentes/tablas/ExportadorTabla";
import { Badge } from "@/componentes/ui/badge";

export function PaginaReporteStockCritico() {
  const navigate = useNavigate();
  const { paginacion, cambiarPagina } = usePagination();
  const [idAlmacen, setIdAlmacen] = useState<number | undefined>(undefined);

  const { data, isLoading, refetch } = useReporteStockCritico(paginacion, idAlmacen);
  const { data: almacenes } = useListaAlmacenes();

  const columnasExportar = [
    { clave: "codigoProducto", titulo: "Código" },
    { clave: "nombreProducto", titulo: "Producto" },
    { clave: "nombreAlmacen", titulo: "Almacén" },
    { clave: "cantidadActual", titulo: "Stock Actual" },
    { clave: "stockMinimo", titulo: "Stock Mínimo" },
    { clave: "diferencia", titulo: "Diferencia" },
  ];

  return (
    <div className="space-y-6 animate-in fade-in duration-500">
      <div className="flex items-center gap-4">
        <Button 
          variant="outline" 
          size="icon" 
          onClick={() => navigate("/reportes")}
          className="rounded-full"
        >
          <ArrowLeft className="h-4 w-4" />
        </Button>
        <div>
          <h1 className="text-2xl font-bold tracking-tight">Reporte de Stock Crítico</h1>
          <p className="text-muted-foreground text-sm">
            Productos con existencias inferiores al nivel de seguridad configurado.
          </p>
        </div>
      </div>

      <Card className="shadow-none border-muted/20">
        <CardContent className="pt-6">
          <div className="flex flex-col md:flex-row gap-4 items-end justify-between">
            <div className="flex flex-col gap-2 min-w-[250px]">
              <label className="text-xs font-semibold uppercase text-slate-500">Filtrar por Almacén</label>
              <Select
                onValueChange={(val) => setIdAlmacen(val === "all" ? undefined : Number(val))}
              >
                <SelectTrigger>
                  <SelectValue placeholder="Todos los Almacenes" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">Todos los Almacenes</SelectItem>
                  {almacenes?.map((a) => (
                    <SelectItem key={a.id} value={a.id.toString()}>
                      {a.nombreAlmacen}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>

            <div className="flex gap-2">
              <Button variant="outline" size="sm" onClick={() => refetch()} disabled={isLoading}>
                <RefreshCcw className={`h-4 w-4 mr-2 ${isLoading ? 'animate-spin' : ''}`} />
                Actualizar
              </Button>
              <ExportadorTabla 
                datos={data?.datos || []}
                columnas={columnasExportar as any}
                nombreArchivo="reporte_stock_critico"
              />
            </div>
          </div>
        </CardContent>
      </Card>

      <Card className="shadow-none border-muted/20 overflow-hidden">
        <Table>
          <TableHeader className="bg-slate-50">
            <TableRow>
              <TableHead className="font-bold">Código</TableHead>
              <TableHead className="font-bold">Producto</TableHead>
              <TableHead className="font-bold">Almacén</TableHead>
              <TableHead className="text-right font-bold">Stock Actual</TableHead>
              <TableHead className="text-right font-bold">Stock Mínimo</TableHead>
              <TableHead className="text-right font-bold">Diferencia</TableHead>
              <TableHead className="text-center font-bold">Estado</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {isLoading ? (
              Array.from({ length: 5 }).map((_, i) => (
                <TableRow key={i}>
                  <TableCell colSpan={7} className="h-12 animate-pulse bg-slate-50/50" />
                </TableRow>
              ))
            ) : data?.datos.length === 0 ? (
              <TableRow>
                <TableCell colSpan={7} className="text-center h-32 text-muted-foreground">
                  No se encontraron productos con stock crítico en este momento.
                </TableCell>
              </TableRow>
            ) : (
              data?.datos.map((item: any) => (
                <TableRow key={`${item.idProducto}-${item.idAlmacen}`} className="hover:bg-slate-50/50 transition-colors">
                  <TableCell className="font-medium">{item.codigoProducto}</TableCell>
                  <TableCell>{item.nombreProducto}</TableCell>
                  <TableCell>
                    <Badge variant="outline" className="font-normal text-xs">
                      {item.nombreAlmacen}
                    </Badge>
                  </TableCell>
                  <TableCell className="text-right font-semibold">{item.cantidadActual.toFixed(2)}</TableCell>
                  <TableCell className="text-right text-muted-foreground">{item.stockMinimo.toFixed(2)}</TableCell>
                  <TableCell className="text-right">
                    <span className="text-destructive font-bold">
                      {item.diferencia.toFixed(2)}
                    </span>
                  </TableCell>
                  <TableCell className="text-center">
                    <Badge variant="destructive" className="bg-red-100 text-red-600 hover:bg-red-100 border-none shadow-none">
                      REPOSICIÓN
                    </Badge>
                  </TableCell>
                </TableRow>
              ))
            )}
          </TableBody>
        </Table>

        {data && data.totalPages > 1 && (
          <div className="flex items-center justify-between px-4 py-4 bg-slate-50 border-t">
            <p className="text-sm text-muted-foreground">
              Mostrando página {data.pageNumber} de {data.totalPages}
            </p>
            <div className="flex gap-2">
              <Button
                variant="outline"
                size="sm"
                onClick={() => cambiarPagina(data.pageNumber - 1)}
                disabled={data.pageNumber === 1}
              >
                Anterior
              </Button>
              <Button
                variant="outline"
                size="sm"
                onClick={() => cambiarPagina(data.pageNumber + 1)}
                disabled={data.pageNumber === data.totalPages}
              >
                Siguiente
              </Button>
            </div>
          </div>
        )}
      </Card>
    </div>
  );
}
