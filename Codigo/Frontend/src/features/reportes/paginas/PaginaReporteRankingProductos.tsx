import { useState } from "react";
import { 
  Card, 
  CardContent, 
  CardHeader, 
  CardTitle, 
  CardDescription 
} from "@/componentes/ui/card";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/componentes/ui/table";
import { Button } from "@/componentes/ui/button";
import { Input } from "@/componentes/ui/input";
import { Label } from "@/componentes/ui/label";
import { 
  BarChart, 
  Bar, 
  XAxis, 
  YAxis, 
  CartesianGrid, 
  Tooltip, 
  ResponsiveContainer, 
  Cell 
} from "recharts";
import { Filter, TrendingUp, Calendar, Box } from "lucide-react";
import { useRankingProductos } from "@/features/ventas/hooks/useVentas";
import { formatCurrency } from "@/lib/utils";
import { Skeleton } from "@/componentes/ui/skeleton";
import { ExportadorTabla } from "@/compartido/componentes/tablas/ExportadorTabla";

export default function PaginaReporteRankingProductos() {
  const [fechaInicio, setFechaInicio] = useState(
    new Date(new Date().setDate(new Date().getDate() - 30)).toISOString().split("T")[0]
  );
  const [fechaFin, setFechaFin] = useState(new Date().toISOString().split("T")[0]);
  const [top, setTop] = useState(10);

  const { data: ranking, isLoading } = useRankingProductos(fechaInicio, fechaFin, top);

  const columnasExport = [
    { clave: "nombreProducto", titulo: "Producto" },
    { clave: "codigoProducto", titulo: "Código" },
    { clave: "cantidadVendida", titulo: "Cantidad Vendida" },
    { clave: "totalVendido", titulo: "Total Ingresos (PEN)" },
  ];

  const COLORS = ["#3b82f6", "#10b981", "#f59e0b", "#ef4444", "#8b5cf6", "#ec4899"];

  return (
    <div className="flex-1 space-y-4 p-8 pt-6">
      <div className="flex items-center justify-between space-y-2">
        <div>
          <h2 className="text-3xl font-bold tracking-tight">Ranking de Productos</h2>
          <p className="text-muted-foreground">
            Análisis de los productos más vendidos en un rango de fechas.
          </p>
        </div>
        <div className="flex items-center space-x-2">
          {ranking && (
            <ExportadorTabla 
              datos={ranking} 
              nombreArchivo={`Ranking_Productos_${fechaInicio}_${fechaFin}`}
              columnas={columnasExport}
            />
          )}
        </div>
      </div>

      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <Filter className="h-5 w-5 text-blue-500" />
            Filtros de Reporte
          </CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid gap-4 md:grid-cols-4 items-end">
            <div className="space-y-2">
              <Label htmlFor="fechaInicio">Fecha Inicio</Label>
              <div className="relative">
                <Calendar className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
                <Input
                  id="fechaInicio"
                  type="date"
                  className="pl-9"
                  value={fechaInicio}
                  onChange={(e) => setFechaInicio(e.target.value)}
                />
              </div>
            </div>
            <div className="space-y-2">
              <Label htmlFor="fechaFin">Fecha Fin</Label>
              <div className="relative">
                <Calendar className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
                <Input
                  id="fechaFin"
                  type="date"
                  className="pl-9"
                  value={fechaFin}
                  onChange={(e) => setFechaFin(e.target.value)}
                />
              </div>
            </div>
            <div className="space-y-2">
              <Label htmlFor="top">Top N</Label>
              <Input
                id="top"
                type="number"
                min={5}
                max={50}
                value={top}
                onChange={(e) => setTop(parseInt(e.target.value))}
              />
            </div>
            <Button variant="default" className="w-full">
              Actualizar Reporte
            </Button>
          </div>
        </CardContent>
      </Card>

      <div className="grid gap-4 md:grid-cols-7">
        <Card className="col-span-4">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <TrendingUp className="h-5 w-5 text-green-500" />
              Visualización por Ingresos
            </CardTitle>
            <CardDescription>
              Comparativa de ventas totales por producto (PEN)
            </CardDescription>
          </CardHeader>
          <CardContent className="pl-2">
            {isLoading ? (
              <Skeleton className="h-[350px] w-full" />
            ) : (
              <div className="h-[350px]">
                <ResponsiveContainer width="100%" height="100%">
                  <BarChart data={ranking}>
                    <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#f1f5f9" />
                    <XAxis 
                      dataKey="nombreProducto" 
                      fontSize={12} 
                      tickLine={false} 
                      axisLine={false}
                      tick={{ fill: "#64748b" }}
                    />
                    <YAxis 
                      fontSize={12} 
                      tickLine={false} 
                      axisLine={false}
                      tickFormatter={(value: number) => `S/ ${value}`}
                      tick={{ fill: "#64748b" }}
                    />
                    <Tooltip 
                      formatter={(value: any) => formatCurrency(value)}
                      contentStyle={{ borderRadius: "8px", border: "none", boxShadow: "0 4px 12px rgba(0,0,0,0.1)" }}
                    />
                    <Bar dataKey="totalVendido" radius={[4, 4, 0, 0]}>
                      {ranking?.map((_: any, index: number) => (
                        <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                      ))}
                    </Bar>
                  </BarChart>
                </ResponsiveContainer>
              </div>
            )}
          </CardContent>
        </Card>

        <Card className="col-span-3">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Box className="h-5 w-5 text-purple-500" />
              Tabla Detallada
            </CardTitle>
          </CardHeader>
          <CardContent>
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Producto</TableHead>
                  <TableHead className="text-right">Cant.</TableHead>
                  <TableHead className="text-right">Total</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {isLoading ? (
                   Array.from({ length: 5 }).map((_, i) => (
                    <TableRow key={i}>
                      <TableCell><Skeleton className="h-4 w-32" /></TableCell>
                      <TableCell><Skeleton className="h-4 w-12 ml-auto" /></TableCell>
                      <TableCell><Skeleton className="h-4 w-20 ml-auto" /></TableCell>
                    </TableRow>
                  ))
                ) : (
                  ranking?.map((item: any) => (
                    <TableRow key={item.idProducto}>
                      <TableCell className="font-medium">
                        <p className="line-clamp-1">{item.nombreProducto}</p>
                        <span className="text-xs text-muted-foreground">{item.codigoProducto}</span>
                      </TableCell>
                      <TableCell className="text-right">{item.cantidadVendida}</TableCell>
                      <TableCell className="text-right font-semibold">
                        {formatCurrency(item.totalVendido)}
                      </TableCell>
                    </TableRow>
                  ))
                )}
                {!isLoading && ranking?.length === 0 && (
                  <TableRow>
                    <TableCell colSpan={3} className="text-center py-10 text-muted-foreground">
                      No hay datos para el rango seleccionado.
                    </TableCell>
                  </TableRow>
                )}
              </TableBody>
            </Table>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
