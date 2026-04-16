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
  ResponsiveContainer
} from "recharts";
import { Filter, Truck, Calendar, ShoppingBag } from "lucide-react";
import { useReporteComprasProveedor } from "@/features/compras/compras/hooks/useCompras";
import { formatCurrency, formatDate } from "@/lib/utils";
import { Skeleton } from "@/componentes/ui/skeleton";
import { ExportadorTabla } from "@/compartido/componentes/tablas/ExportadorTabla";

export default function PaginaReporteComprasProveedor() {
  const [fechaInicio, setFechaInicio] = useState(
    new Date(new Date().setDate(new Date().getDate() - 30)).toISOString().split("T")[0]
  );
  const [fechaFin, setFechaFin] = useState(new Date().toISOString().split("T")[0]);
  const [top, setTop] = useState(10);

  const { data: comprasProveedor, isLoading } = useReporteComprasProveedor(fechaInicio, fechaFin, top);

  const columnasExport = [
    { clave: "razonSocial", titulo: "Proveedor" },
    { clave: "numeroDocumento", titulo: "RUC / DNI" },
    { clave: "cantidadFacturas", titulo: "Nro. Documentos" },
    { clave: "totalComprado", titulo: "Inversión Total (PEN)" },
    { clave: "fechaUltimaCompra", titulo: "Última Compra" },
  ];

  return (
    <div className="flex-1 space-y-4 p-8 pt-6">
      <div className="flex items-center justify-between space-y-2">
        <div>
          <h2 className="text-3xl font-bold tracking-tight text-slate-900">Compras por Proveedor</h2>
          <p className="text-muted-foreground">
            Análisis de adquisiciones y volumen de negocio por socio comercial.
          </p>
        </div>
        <div className="flex items-center space-x-2">
          {comprasProveedor && (
            <ExportadorTabla 
              datos={comprasProveedor} 
              nombreArchivo={`Compras_Proveedor_${fechaInicio}_${fechaFin}`}
              columnas={columnasExport}
            />
          )}
        </div>
      </div>

      <Card className="border-purple-100 shadow-sm">
        <CardHeader className="pb-3">
          <CardTitle className="text-lg font-semibold flex items-center gap-2">
            <Filter className="h-5 w-5 text-purple-500" />
            Parámetros del Análisis
          </CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid gap-4 md:grid-cols-4 items-end">
            <div className="space-y-2">
              <Label htmlFor="fechaInicio">Desde</Label>
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
              <Label htmlFor="fechaFin">Hasta</Label>
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
              <Label htmlFor="top">Top Proveedores</Label>
              <Input
                id="top"
                type="number"
                min={5}
                max={50}
                value={top}
                onChange={(e) => setTop(parseInt(e.target.value))}
              />
            </div>
            <Button className="w-full bg-purple-600 hover:bg-purple-700 shadow-sm transition-all active:scale-[0.98]">
              Refrescar Datos
            </Button>
          </div>
        </CardContent>
      </Card>

      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-7">
        <Card className="col-span-4 border-none shadow-md overflow-hidden bg-gradient-to-br from-white to-purple-50/30">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <ShoppingBag className="h-5 w-5 text-purple-600" />
              Inversión por Proveedor
            </CardTitle>
            <CardDescription>
              Comparativa de montos totales facturados por proveedor en el periodo.
            </CardDescription>
          </CardHeader>
          <CardContent className="h-[400px]">
            {isLoading ? (
              <Skeleton className="h-full w-full" />
            ) : (
              <ResponsiveContainer width="100%" height="100%">
                <BarChart data={comprasProveedor} layout="vertical" margin={{ left: 30, right: 30 }}>
                  <CartesianGrid strokeDasharray="3 3" horizontal={true} vertical={false} stroke="#e2e8f0" />
                  <XAxis type="number" fontSize={12} tickLine={false} axisLine={false} tickFormatter={(value: number) => `S/ ${value}`} />
                  <YAxis 
                    dataKey="razonSocial" 
                    type="category" 
                    fontSize={10} 
                    tickLine={false} 
                    axisLine={false} 
                    width={150}
                  />
                  <Tooltip 
                    formatter={(value: any) => formatCurrency(value)}
                    cursor={{ fill: '#f1f5f9' }}
                    contentStyle={{ borderRadius: '12px', border: 'none', boxShadow: '0 10px 15px -3px rgba(0, 0, 0, 0.1)' }}
                  />
                  <Bar dataKey="totalComprado" fill="#8b5cf6" radius={[0, 4, 4, 0]} barSize={30} />
                </BarChart>
              </ResponsiveContainer>
            )}
          </CardContent>
        </Card>

        <Card className="col-span-3 border-none shadow-md">
          <CardHeader>
            <CardTitle className="flex items-center gap-2 text-slate-800">
              <Truck className="h-5 w-5 text-slate-600" />
              Detalle de Adquisiciones
            </CardTitle>
          </CardHeader>
          <CardContent>
            <Table>
              <TableHeader>
                <TableRow className="hover:bg-transparent">
                  <TableHead>Proveedor</TableHead>
                  <TableHead className="text-center">Docs.</TableHead>
                  <TableHead className="text-right">Total (PEN)</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {isLoading ? (
                  Array.from({ length: 6 }).map((_, i) => (
                    <TableRow key={i}>
                      <TableCell><Skeleton className="h-4 w-32" /></TableCell>
                      <TableCell><Skeleton className="h-4 w-8 mx-auto" /></TableCell>
                      <TableCell><Skeleton className="h-4 w-20 ml-auto" /></TableCell>
                    </TableRow>
                  ))
                ) : (
                  comprasProveedor?.map((item: any) => (
                    <TableRow key={item.idProveedor} className="group hover:bg-slate-50">
                      <TableCell className="py-3">
                        <p className="font-semibold text-slate-700 line-clamp-1 group-hover:text-purple-700 transition-colors">{item.razonSocial}</p>
                        <div className="flex items-center gap-2 mt-0.5">
                          <span className="text-[10px] text-muted-foreground">{item.numeroDocumento}</span>
                          {item.fechaUltimaCompra && (
                            <span className="text-[10px] bg-slate-100 text-slate-500 px-1.5 rounded">
                              Última: {formatDate(item.fechaUltimaCompra)}
                            </span>
                          )}
                        </div>
                      </TableCell>
                      <TableCell className="text-center">
                        <span className="inline-flex items-center justify-center h-6 w-6 rounded-full bg-purple-100 text-purple-700 text-[11px] font-bold">
                          {item.cantidadFacturas}
                        </span>
                      </TableCell>
                      <TableCell className="text-right font-bold text-slate-900">
                        {formatCurrency(item.totalComprado)}
                      </TableCell>
                    </TableRow>
                  ))
                )}
                {!isLoading && (!comprasProveedor || comprasProveedor.length === 0) && (
                  <TableRow>
                    <TableCell colSpan={3} className="text-center py-12 text-muted-foreground italic">
                      No se registraron compras en este periodo.
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
