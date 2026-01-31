import { Link, useLocation } from 'react-router-dom'
import { ChevronRight, Home } from 'lucide-react'
import {
  Breadcrumb,
  BreadcrumbItem,
  BreadcrumbLink,
  BreadcrumbList,
  BreadcrumbPage,
  BreadcrumbSeparator,
} from "@/componentes/ui/breadcrumb"

export function Breadcrumbs() {
  const localizacion = useLocation()
  const rutas = localizacion.pathname.split('/').filter(x => x)

  return (
    <Breadcrumb className="mb-4">
      <BreadcrumbList>
        <BreadcrumbItem>
          <BreadcrumbLink asChild>
            <Link to="/dashboard" className="flex items-center gap-1">
              <Home className="h-3.5 w-3.5" />
              <span className="sr-only">Inicio</span>
            </Link>
          </BreadcrumbLink>
        </BreadcrumbItem>
        
        {rutas.map((ruta, indice) => {
          const url = `/${rutas.slice(0, indice + 1).join('/')}`
          const esUltimo = indice === rutas.length - 1
          const titulo = ruta.charAt(0).toUpperCase() + ruta.slice(1).replace(/-/g, ' ')

          return (
            <div key={url} className="flex items-center gap-1.5">
              <BreadcrumbSeparator>
                <ChevronRight className="h-3.5 w-3.5" />
              </BreadcrumbSeparator>
              <BreadcrumbItem>
                {esUltimo ? (
                  <BreadcrumbPage className="font-medium text-foreground">{titulo}</BreadcrumbPage>
                ) : (
                  <BreadcrumbLink asChild>
                    <Link to={url}>{titulo}</Link>
                  </BreadcrumbLink>
                )}
              </BreadcrumbItem>
            </div>
          )
        })}
      </BreadcrumbList>
    </Breadcrumb>
  )
}
