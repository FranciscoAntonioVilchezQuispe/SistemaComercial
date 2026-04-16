import { Download, FileSpreadsheet, FileJson, Table } from "lucide-react";
import { Button } from "@/componentes/ui/button";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/componentes/ui/dropdown-menu";
import * as XLSX from "xlsx";

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
  
  const prepararDatos = () => {
    return datos.map(item => {
      const objetoFormateado: Record<string, any> = {};
      columnas.forEach(col => {
        objetoFormateado[col.titulo] = item[col.clave];
      });
      return objetoFormateado;
    });
  };

  const exportarExcel = () => {
    const datosFormateados = prepararDatos();
    const worksheet = XLSX.utils.json_to_sheet(datosFormateados);
    const workbook = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(workbook, worksheet, "Datos");
    
    // Auto-ajustar columnas (opcional pero recomendado para premium feel)
    const max_width = datosFormateados.reduce((w, r) => Math.max(w, Object.values(r).join("").length), 10);
    worksheet["!cols"] = columnas.map(() => ({ wch: max_width }));

    XLSX.writeFile(workbook, `${nombreArchivo}.xlsx`);
  };

  const exportarCSV = () => {
    // Crear encabezados
    const encabezados = columnas.map((col) => col.titulo).join(",");

    // Crear filas
    const filas = datos.map((item) =>
      columnas
        .map((col) => {
          const valor = item[col.clave];
          // Escapar comillas y envolver en comillas si contiene comas
          const valorTexto = String(valor ?? "");
          return valorTexto.includes(",")
            ? `"${valorTexto.replace(/"/g, '""')}"`
            : valorTexto;
        })
        .join(","),
    );

    // Combinar todo
    const csv = [encabezados, ...filas].join("\n");

    // Descargar con BOM para asegurar soporte de caracteres especiales en Excel
    const blob = new Blob(["\ufeff" + csv], { type: "text/csv;charset=utf-8;" });
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
        <Button variant="outline" size="sm" className="border-sky-200 text-sky-700 hover:bg-sky-50 shadow-sm">
          <Download className="mr-2 h-4 w-4" />
          Exportar Datos
        </Button>
      </DropdownMenuTrigger>
      <DropdownMenuContent align="end" className="w-48">
        <DropdownMenuItem onClick={exportarExcel} className="cursor-pointer">
          <FileSpreadsheet className="mr-2 h-4 w-4 text-green-600" />
          <span>Excel (.xlsx)</span>
        </DropdownMenuItem>
        <DropdownMenuItem onClick={exportarCSV} className="cursor-pointer">
          <Table className="mr-2 h-4 w-4 text-blue-600" />
          <span>CSV (.csv)</span>
        </DropdownMenuItem>
        <DropdownMenuItem onClick={exportarJSON} className="cursor-pointer">
          <FileJson className="mr-2 h-4 w-4 text-amber-600" />
          <span>JSON (.json)</span>
        </DropdownMenuItem>
      </DropdownMenuContent>
    </DropdownMenu>
  );
}
