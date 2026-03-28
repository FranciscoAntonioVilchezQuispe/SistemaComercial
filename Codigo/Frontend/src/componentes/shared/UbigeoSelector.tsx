import { useState, useEffect } from "react";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/componentes/ui/select";
import { servicioUbigeo, UbigeoItem } from "@/features/configuracion/servicios/servicioUbigeo";
import { Loader2, MapPin } from "lucide-react";
import { Badge } from "@/componentes/ui/badge";

interface UbigeoSelectorProps {
  value?: string; // Código de 6 dígitos
  onValueChange: (value: string) => void;
  disabled?: boolean;
}

export function UbigeoSelector({
  value,
  onValueChange,
  disabled = false,
}: UbigeoSelectorProps) {
  const [departamentos, setDepartamentos] = useState<UbigeoItem[]>([]);
  const [provincias, setProvincias] = useState<UbigeoItem[]>([]);
  const [distritos, setDistritos] = useState<UbigeoItem[]>([]);

  const [selectedDept, setSelectedDept] = useState<string>("");
  const [selectedProv, setSelectedProv] = useState<string>("");
  const [selectedDist, setSelectedDist] = useState<string>("");

  const [loading, setLoading] = useState(false);
  const [loadingLevels, setLoadingLevels] = useState({
    dept: false,
    prov: false,
    dist: false,
  });

  // 1. Cargar Departamentos al inicio
  useEffect(() => {
    const cargarDepartamentos = async () => {
      setLoadingLevels((prev) => ({ ...prev, dept: true }));
      try {
        const data = await servicioUbigeo.getDepartamentos();
        setDepartamentos(data);
      } catch (e) {
        console.error("Error al cargar departamentos:", e);
      } finally {
        setLoadingLevels((prev) => ({ ...prev, dept: false }));
      }
    };
    cargarDepartamentos();
  }, []);

  // 2. Manejar Precarga si llega un valor inicial (6 dígitos)
  useEffect(() => {
    if (value && value.length === 6 && !selectedDist) {
      const precargarJerarquia = async () => {
        setLoading(true);
        try {
          const detalle = await servicioUbigeo.getDetalle(value);
          if (detalle) {
            setSelectedDept(detalle.codigoDepartamento);
            
            // Cargar provincias del depto
            const provs = await servicioUbigeo.getProvincias(detalle.codigoDepartamento);
            setProvincias(provs);
            setSelectedProv(detalle.codigoProvincia);

            // Cargar distritos de la provincia
            const dists = await servicioUbigeo.getDistritos(detalle.codigoProvincia);
            setDistritos(dists);
            setSelectedDist(detalle.codigo);
          }
        } catch (e) {
          console.error("Error al precargar ubigeo:", e);
        } finally {
          setLoading(false);
        }
      };
      precargarJerarquia();
    }
  }, [value]);

  // Handler: Cambio Departamento
  const handleDeptChange = async (deptCode: string) => {
    setSelectedDept(deptCode);
    setSelectedProv("");
    setSelectedDist("");
    setProvincias([]);
    setDistritos([]);
    
    if (!deptCode) return;

    setLoadingLevels((prev) => ({ ...prev, prov: true }));
    try {
      const data = await servicioUbigeo.getProvincias(deptCode);
      setProvincias(data);
    } catch (e) {
      console.error("Error al cargar provincias:", e);
    } finally {
      setLoadingLevels((prev) => ({ ...prev, prov: false }));
    }
  };

  // Handler: Cambio Provincia
  const handleProvChange = async (provCode: string) => {
    setSelectedProv(provCode);
    setSelectedDist("");
    setDistritos([]);

    if (!provCode) return;

    setLoadingLevels((prev) => ({ ...prev, dist: true }));
    try {
      const data = await servicioUbigeo.getDistritos(provCode);
      setDistritos(data);
    } catch (e) {
      console.error("Error al cargar distritos:", e);
    } finally {
      setLoadingLevels((prev) => ({ ...prev, dist: false }));
    }
  };

  // Handler: Cambio Distrito
  const handleDistChange = (distCode: string) => {
    setSelectedDist(distCode);
    onValueChange(distCode);
  };

  return (
    <div className="space-y-4">
      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4">
        {/* Departamento */}
        <div className="flex flex-col gap-1.5 min-w-[140px]">
          <label className="text-[10px] font-bold text-muted-foreground/70 uppercase tracking-tight">Departamento</label>
          <Select
            value={selectedDept}
            onValueChange={handleDeptChange}
            disabled={disabled || loading || loadingLevels.dept}
          >
            <SelectTrigger className="h-9 truncate">
              <SelectValue placeholder="Seleccione..." />
            </SelectTrigger>
            <SelectContent className="max-h-[300px]">
              {departamentos.map((d) => (
                <SelectItem key={d.codigo} value={d.codigo} className="text-xs">
                  {d.nombre}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>

        {/* Provincia */}
        <div className="flex flex-col gap-1.5 min-w-[140px]">
          <label className="text-[10px] font-bold text-muted-foreground/70 uppercase tracking-tight">Provincia</label>
          <Select
            value={selectedProv}
            onValueChange={handleProvChange}
            disabled={disabled || loading || !selectedDept || loadingLevels.prov}
          >
            <SelectTrigger className="h-9 truncate">
              <SelectValue placeholder="Seleccione..." />
            </SelectTrigger>
            <SelectContent className="max-h-[300px]">
              {provincias.map((p) => (
                <SelectItem key={p.codigo} value={p.codigo} className="text-xs">
                  {p.nombre}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>

        {/* Distrito */}
        <div className="flex flex-col gap-1.5 min-w-[140px]">
          <label className="text-[10px] font-bold text-muted-foreground/70 uppercase tracking-tight">Distrito</label>
          <Select
            value={selectedDist}
            onValueChange={handleDistChange}
            disabled={disabled || loading || !selectedProv || loadingLevels.dist}
          >
            <SelectTrigger className="h-9 truncate">
              <SelectValue placeholder="Seleccione..." />
            </SelectTrigger>
            <SelectContent className="max-h-[300px]">
              {distritos.map((d) => (
                <SelectItem key={d.codigo} value={d.codigo} className="text-xs">
                  {d.nombre}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>
      </div>

      {selectedDist && (
        <div className="flex items-center gap-2 p-2 bg-slate-50 dark:bg-slate-900 rounded-md border border-dashed border-slate-200 dark:border-slate-800 transition-all">
          <MapPin className="h-4 w-4 text-primary" />
          <span className="text-xs font-medium text-slate-600 dark:text-slate-400">Ubigeo Seleccionado:</span>
          <Badge variant="outline" className="text-[10px] font-bold bg-white dark:bg-black">
            {selectedDist}
          </Badge>
        </div>
      )}

      {(loading || loadingLevels.dept || loadingLevels.prov || loadingLevels.dist) && (
        <div className="flex items-center gap-2 text-[10px] text-muted-foreground animate-pulse">
          <Loader2 className="h-3 w-3 animate-spin" />
          Sincronizando catálogo INEI...
        </div>
      )}
    </div>
  );
}
