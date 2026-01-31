import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Button } from "@/components/ui/button";
import {
  ChevronLeft,
  ChevronRight,
  ChevronsLeft,
  ChevronsRight,
} from "lucide-react";
import { usePaginacion } from "@compartido/hooks/usePaginacion";
import { Loading } from "../feedback/Loading";
import { EstadoVacio } from "../feedback/EstadoVacio";
import { MensajeError } from "../feedback/MensajeError";

interface Columna<T> {
  clave: string;
  titulo: string;
  renderizar?: (item: T) => React.ReactNode;
  ancho?: string;
}

interface PropiedadesTablaPaginada<T> {
  datos: T[];
  columnas: Columna<T>[];
  cargando?: boolean;
  error?: string;
  elementosPorPaginaOpciones?: number[];
  mensajeVacio?: string;
  descripcionVacio?: string;
}

export function TablaPaginada<T extends Record<string, any>>({
  datos,
  columnas,
  cargando = false,
  error,
  elementosPorPaginaOpciones = [10, 25, 50, 100],
  mensajeVacio = "No hay datos disponibles",
  descripcionVacio = "No se encontraron registros para mostrar",
}: PropiedadesTablaPaginada<T>) {
  const {
    paginaActual,
    elementosPorPagina,
    totalPaginas,
    irAPagina,
    paginaSiguiente,
    paginaAnterior,
    cambiarElementosPorPagina,
    obtenerIndiceInicio,
    obtenerIndiceFin,
  } = usePaginacion(datos.length);

  // Estados de carga y error
  if (cargando) {
    return <Loading mensaje="Cargando datos..." />;
  }

  if (error) {
    return <MensajeError mensaje={error} />;
  }

  if (datos.length === 0) {
    return <EstadoVacio titulo={mensajeVacio} descripcion={descripcionVacio} />;
  }

  // Datos paginados
  const datosPaginados = datos.slice(obtenerIndiceInicio(), obtenerIndiceFin());

  return (
    <div className="space-y-4">
      {/* Tabla */}
      <div className="rounded-md border">
        <Table>
          <TableHeader>
            <TableRow>
              {columnas.map((columna) => (
                <TableHead key={columna.clave} style={{ width: columna.ancho }}>
                  {columna.titulo}
                </TableHead>
              ))}
            </TableRow>
          </TableHeader>
          <TableBody>
            {datosPaginados.map((item, index) => (
              <TableRow key={index}>
                {columnas.map((columna) => (
                  <TableCell key={columna.clave}>
                    {columna.renderizar
                      ? columna.renderizar(item)
                      : item[columna.clave]}
                  </TableCell>
                ))}
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </div>

      {/* Controles de paginación */}
      <div className="flex items-center justify-between">
        <div className="flex items-center space-x-2">
          <p className="text-sm text-muted-foreground">
            Mostrando {obtenerIndiceInicio() + 1} a {obtenerIndiceFin()} de{" "}
            {datos.length} registros
          </p>
        </div>

        <div className="flex items-center space-x-6">
          {/* Selector de elementos por página */}
          <div className="flex items-center space-x-2">
            <p className="text-sm text-muted-foreground">Filas por página:</p>
            <Select
              value={elementosPorPagina.toString()}
              onValueChange={(valor) =>
                cambiarElementosPorPagina(Number(valor))
              }
            >
              <SelectTrigger className="h-8 w-[70px]">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                {elementosPorPaginaOpciones.map((opcion) => (
                  <SelectItem key={opcion} value={opcion.toString()}>
                    {opcion}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          {/* Navegación de páginas */}
          <div className="flex items-center space-x-2">
            <p className="text-sm text-muted-foreground">
              Página {paginaActual} de {totalPaginas}
            </p>
            <div className="flex items-center space-x-1">
              <Button
                variant="outline"
                size="icon"
                className="h-8 w-8"
                onClick={() => irAPagina(1)}
                disabled={paginaActual === 1}
              >
                <ChevronsLeft className="h-4 w-4" />
              </Button>
              <Button
                variant="outline"
                size="icon"
                className="h-8 w-8"
                onClick={paginaAnterior}
                disabled={paginaActual === 1}
              >
                <ChevronLeft className="h-4 w-4" />
              </Button>
              <Button
                variant="outline"
                size="icon"
                className="h-8 w-8"
                onClick={paginaSiguiente}
                disabled={paginaActual === totalPaginas}
              >
                <ChevronRight className="h-4 w-4" />
              </Button>
              <Button
                variant="outline"
                size="icon"
                className="h-8 w-8"
                onClick={() => irAPagina(totalPaginas)}
                disabled={paginaActual === totalPaginas}
              >
                <ChevronsRight className="h-4 w-4" />
              </Button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
