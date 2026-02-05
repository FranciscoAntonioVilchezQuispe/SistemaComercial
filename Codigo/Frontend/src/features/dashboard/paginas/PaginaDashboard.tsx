import { 
  ShoppingCart, 
  Users, 
  DollarSign, 
  Package,
  Calendar,
  MoreVertical,
  ChevronRight,
  BarChart3
} from 'lucide-react'
import { cn } from '@/lib/utils'
import { ContenedorPagina } from '@/compartido/componentes/ContenedorPagina'
import { TarjetaEstadistica } from '@/compartido/componentes/TarjetaEstadistica'
import { Card, CardHeader, CardTitle, CardContent, CardDescription } from '@/componentes/ui/card'
import { Badge } from '@/componentes/ui/badge'
import { 
  Table, 
  TableBody, 
  TableCell, 
  TableHead, 
  TableHeader, 
  TableRow 
} from '@/componentes/ui/table'
import { Avatar, AvatarFallback } from '@/componentes/ui/avatar'
import { Button } from '@/componentes/ui/button'

export default function PaginaDashboard() {
  return (
    <ContenedorPagina
      titulo="Buen día, Administrador"
      descripcion="Aquí tienes el resumen de lo que está ocurriendo en tu negocio hoy."
      acciones={
        <div className="flex gap-2 flex-wrap">
          <Button variant="outline" size="sm" className="hidden sm:flex gap-2">
            <Calendar className="h-4 w-4" />
            Últimos 30 días
          </Button>
          <Button size="sm" className="gap-2">
            <DollarSign className="h-4 w-4" />
            Nueva Venta
          </Button>
        </div>
      }
    >
      {/* Grid de KPIs */}
      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4 mb-8">
        <TarjetaEstadistica
          titulo="Ventas del Día"
          valor="S/ 12,450.00"
          icono={DollarSign}
          cambio={12.5}
          tendencia="positivo"
          descripcion="vsc. ayer"
        />
        <TarjetaEstadistica
          titulo="Productos Vendidos"
          valor="184"
          icono={Package}
          cambio={5.2}
          tendencia="positivo"
          descripcion="vs. ayer"
        />
        <TarjetaEstadistica
          titulo="Nuevos Clientes"
          valor="12"
          icono={Users}
          cambio={2.4}
          tendencia="negativo"
          descripcion="vs. promedio"
        />
        <TarjetaEstadistica
          titulo="Ticket Promedio"
          valor="S/ 67.80"
          icono={ShoppingCart}
          cambio={0.8}
          tendencia="neutral"
          descripcion="vs. semana pasada"
        />
      </div>

      <div className="grid gap-6 md:grid-cols-2 laptop:grid-cols-7 mb-8">
        {/* Gráfico (Simplificado con Card por ahora) */}
        <Card className="laptop:col-span-4">
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <div className="space-y-1">
              <CardTitle>Rendimiento Mensual</CardTitle>
              <CardDescription>Comparativa de ventas y compras del periodo</CardDescription>
            </div>
            <Button variant="ghost" size="icon">
              <MoreVertical className="h-4 w-4" />
            </Button>
          </CardHeader>
          <CardContent className="h-[300px] flex items-center justify-center bg-muted/20 rounded-md border m-4 mt-0">
            <div className="text-center space-y-2">
              <BarChart3 className="h-12 w-12 text-muted-foreground/30 mx-auto" />
              <p className="text-sm text-muted-foreground font-medium">Área reservada para gráfico interactivo</p>
              <p className="text-xs text-muted-foreground/60">Integrando Recharts...</p>
            </div>
          </CardContent>
        </Card>

        {/* Ventas Recientes */}
        <Card className="laptop:col-span-3">
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle>Ventas Recientes</CardTitle>
            <Button variant="link" size="sm" className="h-auto p-0 text-primary">
              Ver todas
            </Button>
          </CardHeader>
          <CardContent>
            <div className="space-y-6">
              {[
                { cliente: "Juan Pérez", monto: "S/ 450.00", hora: "Hace 5 min", status: "Completada" },
                { cliente: "María García", monto: "S/ 1,200.00", hora: "Hace 12 min", status: "Pendiente" },
                { cliente: "Tienda El Sol", monto: "S/ 3,450.00", hora: "Hace 45 min", status: "Completada" },
                { cliente: "Roberto Ruiz", monto: "S/ 89.90", hora: "Hace 1 h", status: "Completada" },
                { cliente: "Elena Mas", monto: "S/ 230.00", hora: "Hace 2 h", status: "Cancelada" },
              ].map((venta, i) => (
                <div key={i} className="flex items-center gap-4">
                  <Avatar className="h-9 w-9 border">
                    <AvatarFallback className="bg-primary/5 text-primary text-xs font-bold">
                      {venta.cliente.split(' ').map(n => n[0]).join('')}
                    </AvatarFallback>
                  </Avatar>
                  <div className="flex-1 space-y-1">
                    <p className="text-sm font-medium leading-none">{venta.cliente}</p>
                    <p className="text-xs text-muted-foreground">{venta.hora}</p>
                  </div>
                  <div className="text-right space-y-1">
                    <p className="text-sm font-bold">{venta.monto}</p>
                    <Badge variant={venta.status === 'Completada' ? 'default' : venta.status === 'Pendiente' ? 'secondary' : 'destructive'} 
                      className="text-[9px] px-1.5 py-0 h-4 uppercase font-bold tracking-tight"
                    >
                      {venta.status}
                    </Badge>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      </div>

      <div className="grid gap-6 md:grid-cols-2">
        {/* Productos con Bajo Stock */}
        <Card>
          <CardHeader>
            <div className="flex items-center justify-between">
              <div className="space-y-1">
                <CardTitle className="flex items-center gap-2">
                  <Package className="h-5 w-5 text-orange-500" />
                  Alerta de Inventario
                </CardTitle>
                <CardDescription>Productos que requieren reposición inmediata</CardDescription>
              </div>
              <Badge variant="destructive">Critico</Badge>
            </div>
          </CardHeader>
          <CardContent>
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Producto</TableHead>
                  <TableHead className="text-right">Stock</TableHead>
                  <TableHead className="text-right">Mínimo</TableHead>
                  <TableHead></TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {[
                  { nombre: "Aceite de Motor 20W50", stock: 5, min: 20 },
                  { nombre: "Filtro de Aire Premium", stock: 2, min: 10 },
                  { nombre: "Bujía Triple Electrodo", stock: 45, min: 100 },
                ].map((p, i) => (
                  <TableRow key={i}>
                    <TableCell className="font-medium text-sm">{p.nombre}</TableCell>
                    <TableCell className="text-right text-destructive font-bold">{p.stock}</TableCell>
                    <TableCell className="text-right text-muted-foreground">{p.min}</TableCell>
                    <TableCell className="text-right">
                      <Button variant="ghost" size="icon" className="h-8 w-8">
                        <ChevronRight className="h-4 w-4" />
                      </Button>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </CardContent>
        </Card>

        {/* Top Categorías */}
        <Card>
          <CardHeader>
            <CardTitle>Categorías más Vendidas</CardTitle>
            <CardDescription>Distribución de ventas por línea de producto</CardDescription>
          </CardHeader>
          <CardContent className="space-y-5">
            {[
              { nombre: "Lubricantes", porcentaje: 45, color: "bg-blue-500", monto: "S/ 5,600" },
              { nombre: "Repuestos", porcentaje: 30, color: "bg-indigo-500", monto: "S/ 3,750" },
              { nombre: "Accesorios", porcentaje: 15, color: "bg-emerald-500", monto: "S/ 1,875" },
              { nombre: "Servicios", porcentaje: 10, color: "bg-amber-500", monto: "S/ 1,250" },
            ].map((cat, i) => (
              <div key={i} className="space-y-2">
                <div className="flex items-center justify-between text-sm">
                  <span className="font-medium">{cat.nombre}</span>
                  <span className="text-muted-foreground font-bold">{cat.monto} ({cat.porcentaje}%)</span>
                </div>
                <div className="h-2 w-full bg-muted rounded-full overflow-hidden">
                  <div className={cn("h-full rounded-full transition-all", cat.color)} style={{ width: `${cat.porcentaje}%` }} />
                </div>
              </div>
            ))}
          </CardContent>
        </Card>
      </div>
    </ContenedorPagina>
  )
}
