import { Breadcrumbs } from './Breadcrumbs'
import { motion } from 'framer-motion'
import { cn } from '@/lib/utils'

interface PropiedadesContenedorPagina {
  titulo: string
  descripcion?: string
  acciones?: React.ReactNode
  children: React.ReactNode
  className?: string
}

export function ContenedorPagina({
  titulo,
  descripcion,
  acciones,
  children,
  className
}: PropiedadesContenedorPagina) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.3, ease: 'easeOut' }}
      className={cn("flex flex-col gap-6", className)}
    >
      <div className="flex flex-col gap-1">
        <Breadcrumbs />
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
          <div className="space-y-1">
            <h1 className="text-2xl sm:text-3xl font-bold tracking-tight text-foreground">
              {titulo}
            </h1>
            {descripcion && (
              <p className="text-sm text-muted-foreground max-w-2xl">
                {descripcion}
              </p>
            )}
          </div>
          {acciones && (
            <div className="flex items-center gap-3 self-end sm:self-center">
              {acciones}
            </div>
          )}
        </div>
      </div>

      <div className="flex-1">
        {children}
      </div>
    </motion.div>
  )
}
