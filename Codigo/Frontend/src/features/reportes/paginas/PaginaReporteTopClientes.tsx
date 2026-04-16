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
  PieChart, 
  Pie, 
  Cell, 
  Tooltip, 
  ResponsiveContainer, 
  Legend 
} from "recharts";
import { Filter, UserCheck, Calendar, Wallet } from "lucide-react";
import { useTopClientes } from "@/features/ventas/hooks/useVentas";
import { formatCurrency } from "@/lib/utils";
import { Skeleton } from "@/componentes/ui/skeleton";
import { ExportadorTabla } from "@/compartido/componentes/tablas/ExportadorTabla";

export default function PaginaReporteTopClientes() {
  const [fechaInicio, setFechaInicio] = useState(
    new Date(new Date().setDate(new Date().getDate() - 30)).toISOString().split("T")[0]
  );
  const [fechaFin, setFechaFin] = useState(new Date().toISOString().split("T")[0]);
  const [top, setTop] = useState(10);

  const { data: topClientes, isLoading } = useTopClientes(fechaInicio, fechaFin, top);

  const columnasExport = [
    { clave: "razonSocial", titulo: "Cliente" },
    { clave: "numeroDocumento", titulo: "Nro. Documento" },
    { clave: "cantidadOperaciones", titulo: "Operaciones" },
    { clave: "totalComprado", titulo: "Ventas Totales (PEN)" },
  ];

  const COLORS = ["#0ea5e9", "#10b981", "#f59e0b", "#f43f5e", "#8b5cf6", "#ec4899", "#14b8a6", "#f97316"];


  return (
    <div className="flex-1 space-y-4 p-8 pt-6">
      <div className="flex items-center justify-between space-y-2">
        <div>
          <h2 className="text-3xl font-bold tracking-tight">Top Clientes</h2>
          <p className="text-muted-foreground">
            Análisis de los clientes con mayor volumen de compras acumuladas.
          </p>
        </div>
        <div className="flex items-center space-x-2">
          {topClientes && (
            <ExportadorTabla 
              datos={topClientes} 
              nombreArchivo={`Top_Clientes_${fechaInicio}_${fechaFin}`}
              columnas={columnasExport}
            />
          )}
        </div>
      </div>

      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <Filter className="h-5 w-5 text-sky-500" />
            Filtros del Periodo
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
              <Label htmlFor="top">Límite</Label>
              <Input
                id="top"
                type="number"
                min={5}
                max={50}
                value={top}
                onChange={(e) => setTop(parseInt(e.target.value))}
              />
            </div>
            <Button className="w-full bg-sky-600 hover:bg-sky-700">
              Generar Análisis
            </Button>
          </div>
        </CardContent>
      </Card>

      <div className="grid gap-4 md:grid-cols-2">
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Wallet className="h-5 w-5 text-green-500" />
              Distribución de Participación
            </CardTitle>
            <CardDescription>
              Representación del peso de cada cliente en el total facturado.
            </CardDescription>
          </CardHeader>
          <CardContent>
            {isLoading ? (
              <Skeleton className="h-[350px] w-full rounded-full" />
            ) : (
              <div className="h-[350px]">
                <ResponsiveContainer width="100%" height="100%">
                  <PieChart>
                    <Pie
                      data={topClientes}
                      cx="50%"
                      cy="50%"
                      innerRadius={80}
                      outerRadius={120}
                      paddingAngle={5}
                      dataKey="totalComprado"
                      nameKey="razonSocial"
                    >
                      {topClientes?.map((_: any, index: number) => (
                        <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                      ))}
                    </Pie>
                    <Tooltip 
                      formatter={(value: any) => formatCurrency(value)}
                      contentStyle={{ borderRadius: "10px", border: "none" }}
                    />
                    <Legend />
                  </PieChart>
                </ResponsiveContainer>
              </div>
            )}
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <UserCheck className="h-5 w-5 text-blue-500" />
              Métricas de Clientes
            </CardTitle>
          </CardHeader>
          <CardContent>
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Cliente</TableHead>
                  <TableHead className="text-center">Ops.</TableHead>
                  <TableHead className="text-right">Total Acumulado</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {isLoading ? (
                  Array.from({ length: 5 }).map((_, i) => (
                    <TableRow key={i}>
                      <TableCell><Skeleton className="h-4 w-40" /></TableCell>
                      <TableCell><Skeleton className="h-4 w-8 mx-auto" /></TableCell>
                      <TableCell><Skeleton className="h-4 w-24 ml-auto" /></TableCell>
                    </TableRow>
                  ))
                ) : (
                  topClientes?.map((item: any) => (
                    <TableRow key={item.idCliente} className="hover:bg-muted/50 transition-colors">
                      <TableCell className="font-medium">
                        <p>{item.razonSocial}</p>
                        <span className="text-xs text-muted-foreground">{item.numeroDocumento}</span>
                      </TableCell>
                      <TableCell className="text-center">
                        <span className="bg-sky-100 text-sky-800 text-[10px] font-bold px-2 py-1 rounded-full uppercase">
                           {item.cantidadOperaciones}
                        </span>
                      </TableCell>
                      <TableCell className="text-right font-bold text-sky-900">
                        {formatCurrency(item.totalComprado)}
                      </TableCell>
                    </TableRow>
                  ))
                )}
                {!isLoading && topClientes?.length === 0 && (
                  <TableRow>
                    <TableCell colSpan={3} className="text-center py-10 text-muted-foreground italic">
                      No se encontraron movimientos.
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
