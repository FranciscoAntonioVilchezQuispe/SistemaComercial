import { Card, CardContent, CardHeader, CardTitle } from '@/componentes/ui/card'
import { cn } from '@/lib/utils'
import { TrendingUp, TrendingDown, Minus } from 'lucide-react'

/**
 * Tarjeta de estadística para el dashboard
 * Muestra un KPI con su variación porcentual
 */
interface PropiedadesTarjetaEstadistica {
  titulo: string
  valor: string | number
  icono: React.ComponentType<{ className?: string }>
  cambio?: number
  descripcion?: string
  tendencia?: 'positivo' | 'negativo' | 'neutral'
  className?: string
}

export function TarjetaEstadistica({
  titulo,
  valor,
  icono: Icono,
  cambio,
  descripcion,
  tendencia = 'neutral',
  className
}: PropiedadesTarjetaEstadistica) {
  const esquemasColor = {
    positivo: {
      texto: 'text-success',
      fondo: 'bg-success/10',
      icono: TrendingUp
    },
    negativo: {
      texto: 'text-destructive',
      fondo: 'bg-destructive/10',
      icono: TrendingDown
    },
    neutral: {
      texto: 'text-muted-foreground',
      fondo: 'bg-muted',
      icono: Minus
    }
  }

  const esquema = esquemasColor[tendencia]
  const IconoTendencia = esquema.icono

  return (
    <Card className={cn("overflow-hidden transition-all hover:shadow-md", className)}>
      <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
        <CardTitle className="text-sm font-medium text-muted-foreground uppercase tracking-wider">
          {titulo}
        </CardTitle>
        <div className="bg-primary/10 p-2 rounded-lg text-primary">
          <Icono className="h-5 w-5" />
        </div>
      </CardHeader>
      <CardContent>
        <div className="text-3xl font-bold tracking-tight">{valor}</div>
        <div className="flex items-center gap-2 mt-1">
          {cambio !== undefined && (
            <span className={cn(
              "text-xs font-semibold px-1.5 py-0.5 rounded-full flex items-center gap-0.5",
              esquema.texto,
              esquema.fondo
            )}>
              <IconoTendencia className="h-3 w-3" />
              {Math.abs(cambio)}%
            </span>
          )}
          {descripcion && (
            <span className="text-xs text-muted-foreground italic">
              {descripcion}
            </span>
          )}
        </div>
      </CardContent>
    </Card>
  )
}
