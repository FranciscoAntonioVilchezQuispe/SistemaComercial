import { Download, FileSpreadsheet } from "lucide-react";
import { Button } from "@/components/ui/button";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";

interface PropiedadesExportadorTabla<T> {
  datos: T[];
  nombreArchivo: string;
  columnas: Array<{
    clave: keyof T;
    titulo: string;
  }>;
}

export function ExportadorTabla<T extends Record<string, any>>({
  datos,
  nombreArchivo,
  columnas,
}: PropiedadesExportadorTabla<T>) {
  const exportarCSV = () => {
    // Crear encabezados
    const encabezados = columnas.map((col) => col.titulo).join(",");

    // Crear filas
    const filas = datos.map((item) =>
      columnas
        .map((col) => {
          const valor = item[col.clave];
          // Escapar comillas y envolver en comillas si contiene comas
          const valorTexto = String(valor || "");
          return valorTexto.includes(",")
            ? `"${valorTexto.replace(/"/g, '""')}"`
            : valorTexto;
        })
        .join(","),
    );

    // Combinar todo
    const csv = [encabezados, ...filas].join("\n");

    // Descargar
    const blob = new Blob([csv], { type: "text/csv;charset=utf-8;" });
    const url = URL.createObjectURL(blob);
    const link = document.createElement("a");
    link.href = url;
    link.download = `${nombreArchivo}.csv`;
    link.click();
    URL.revokeObjectURL(url);
  };

  const exportarJSON = () => {
    const json = JSON.stringify(datos, null, 2);
    const blob = new Blob([json], { type: "application/json" });
    const url = URL.createObjectURL(blob);
    const link = document.createElement("a");
    link.href = url;
    link.download = `${nombreArchivo}.json`;
    link.click();
    URL.revokeObjectURL(url);
  };

  return (
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <Button variant="outline" size="sm">
          <Download className="mr-2 h-4 w-4" />
          Exportar
        </Button>
      </DropdownMenuTrigger>
      <DropdownMenuContent align="end">
        <DropdownMenuItem onClick={exportarCSV}>
          <FileSpreadsheet className="mr-2 h-4 w-4" />
          Exportar como CSV
        </DropdownMenuItem>
        <DropdownMenuItem onClick={exportarJSON}>
          <FileSpreadsheet className="mr-2 h-4 w-4" />
          Exportar como JSON
        </DropdownMenuItem>
      </DropdownMenuContent>
    </DropdownMenu>
  );
}
