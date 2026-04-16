import { 
  FileText, 
  BarChart3, 
  Package, 
  Users, 
  ShoppingBag, 
  TrendingUp, 
  AlertTriangle,
  ArrowRight
} from "lucide-react";
import { Link } from "react-router-dom";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/componentes/ui/card";
import { Button } from "@/components/ui/button";

const reportes = [
  {
    categoria: "Inventario",
    color: "text-blue-600",
    bg: "bg-blue-50",
    items: [
      {
        titulo: "Stock Crítico",
        descripcion: "Productos que requieren reposición inmediata por bajo stock.",
        icon: <AlertTriangle className="h-5 w-5" />,
        ruta: "/reportes/stock-critico",
      },
      {
        titulo: "Kardex Valorizado",
        descripcion: "Reporte oficial SUNAT (Formato 13.1) con costos promedio.",
        icon: <BarChart3 className="h-5 w-5" />,
        ruta: "/inventario/kardex/reporte",
      },
      {
        titulo: "Valorización de Almacén",
        descripcion: "Valor total de las existencias actuales a costo real.",
        icon: <Package className="h-5 w-5" />,
        ruta: "/reportes/valorizacion",
        proximamente: true
      }
    ]
  },
  {
    categoria: "Ventas",
    color: "text-green-600",
    bg: "bg-green-50",
    items: [
      {
        titulo: "Ranking de Productos",
        descripcion: "Top de productos con mayor volumen de venta.",
        icon: <TrendingUp className="h-5 w-5" />,
        ruta: "/reportes/ranking-productos",
      },
      {
        titulo: "Mayores Compradores",
        descripcion: "Ranking de clientes por volumen de facturación.",
        icon: <Users className="h-5 w-5" />,
        ruta: "/reportes/top-clientes",
      },
      {
        titulo: "Registro de Ventas",
        descripcion: "Libro auxiliar de ventas para declaración mensual.",
        icon: <FileText className="h-5 w-5" />,
        ruta: "/reportes/registro-ventas",
        proximamente: true
      }
    ]
  },
  {
    categoria: "Compras",
    color: "text-purple-600",
    bg: "bg-purple-50",
    items: [
      {
        titulo: "Compras por Proveedor",
        descripcion: "Resumen de adquisiciones y gastos por proveedor.",
        icon: <ShoppingBag className="h-5 w-5" />,
        ruta: "/reportes/compras-proveedor",
      },
      {
        titulo: "Registro de Compras",
        descripcion: "Libro auxiliar de compras para declaración de IGV.",
        icon: <FileText className="h-5 w-5" />,
        ruta: "/reportes/registro-compras",
        proximamente: true
      }
    ]
  }
];

export function PaginaReportesHub() {
  return (
    <div className="space-y-8 animate-in fade-in duration-500">
      <div className="flex flex-col gap-2">
        <h1 className="text-3xl font-bold tracking-tight text-slate-900">Centro de Inteligencia</h1>
        <p className="text-slate-500 max-w-2xl">
          Accede a reportes estratégicos y operativos para la toma de decisiones basada en datos reales de tu negocio.
        </p>
      </div>

      <div className="grid gap-8">
        {reportes.map((seccion) => (
          <div key={seccion.categoria} className="space-y-4">
            <h2 className={`text-sm font-bold uppercase tracking-wider ${seccion.color}`}>
              Módulo de {seccion.categoria}
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              {seccion.items.map((reporte) => (
                <Card 
                  key={reporte.titulo} 
                  className={`group border-muted/20 shadow-none hover:shadow-md transition-all duration-300 ${reporte.proximamente ? 'opacity-70 grayscale-[0.5]' : ''}`}
                >
                  <CardHeader className="pb-3">
                    <div className={`p-2 w-fit rounded-lg ${seccion.bg} ${seccion.color} mb-3 group-hover:scale-110 transition-transform`}>
                      {reporte.icon}
                    </div>
                    <CardTitle className="text-lg flex items-center justify-between">
                      {reporte.titulo}
                      {reporte.proximamente && (
                        <span className="text-[10px] font-bold bg-slate-100 text-slate-500 px-2 py-0.5 rounded-full uppercase">Próximamente</span>
                      )}
                    </CardTitle>
                    <CardDescription className="text-sm line-clamp-2">
                      {reporte.descripcion}
                    </CardDescription>
                  </CardHeader>
                  <CardContent>
                    {!reporte.proximamente ? (
                      <Button asChild variant="outline" size="sm" className="w-full justify-between group-hover:bg-slate-50">
                        <Link to={reporte.ruta}>
                          Generar Reporte
                          <ArrowRight className="h-4 w-4 ml-2 group-hover:translate-x-1 transition-transform" />
                        </Link>
                      </Button>
                    ) : (
                      <Button disabled variant="ghost" size="sm" className="w-full">
                        En desarrollo
                      </Button>
                    )}
                  </CardContent>
                </Card>
              ))}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
