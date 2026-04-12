import { useState, useEffect } from "react";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { 
  Select, 
  SelectContent, 
  SelectItem, 
  SelectTrigger, 
  SelectValue 
} from "@/components/ui/select";
import { Switch } from "@/components/ui/switch";
import { 
  Loader2, 
  FileText, 
  MessageSquare, 
  RotateCcw, 
  CheckCircle2, 
  HelpCircle,
  Settings
} from "lucide-react";
import { TipoComprobanteSunat } from "@/compartido/enums";
import { VentaDetalle } from "../tipos/ventas.types";
import { servicioVentas } from "../servicios/servicioVentas";
import { toast } from "sonner";
import { MotivoNota } from "../tipos/notas.types";
import { useTiposComprobante } from "@/features/configuracion/hooks/useTiposComprobante";
import { SerieComprobante } from "@/features/configuracion/tipos/serieComprobante.types";

interface ModalCrearNotaSunatProps {
  idVenta: number | null;
  open: boolean;
  onOpenChange: (open: boolean) => void;
  onSuccess: () => void;
}

export function ModalCrearNotaSunat({
  idVenta,
  open,
  onOpenChange,
  onSuccess,
}: ModalCrearNotaSunatProps) {
  const [venta, setVenta] = useState<VentaDetalle | null>(null);
  const [tipoNota, setTipoNota] = useState<TipoComprobanteSunat>(TipoComprobanteSunat.NotaCredito);
  const [motivoSunat, setMotivoSunat] = useState<string>("");
  const [sustento, setSustento] = useState("");
  const [afectaStock, setAfectaStock] = useState(true);
  const [isLoading, setIsLoading] = useState(false);
  const [isFetching, setIsFetching] = useState(false);

  const [idTipoComprobante, setIdTipoComprobante] = useState<number | null>(null);
  const [series, setSeries] = useState<SerieComprobante[]>([]);
  const [serieSeleccionada, setSerieSeleccionada] = useState<string>("");

  const [motivos, setMotivos] = useState<MotivoNota[]>([]);

  // Hook para cargar los tipos de comprobante y encontrar el ID correspondiente
  const { data: dataTipos } = useTiposComprobante({ pageNumber: 1, pageSize: 100 });

  useEffect(() => {
    if (open && idVenta) {
      cargarVenta(idVenta);
    } else {
      setVenta(null);
      setSustento("");
      setMotivoSunat("");
      setMotivos([]);
    }
  }, [open, idVenta]);

  useEffect(() => {
    if (open && dataTipos?.datos) {
      const tipo = dataTipos.datos.find(t => t.codigo === (tipoNota as string));
      if (tipo) {
        setIdTipoComprobante(tipo.id);
      }
    }
  }, [tipoNota, open, dataTipos]);

  useEffect(() => {
    if (open && idTipoComprobante && venta?.idAlmacen) {
      cargarSeries(idTipoComprobante, venta.idAlmacen);
    }
  }, [idTipoComprobante, venta, open]);

  useEffect(() => {
    if (open) {
      cargarMotivos(tipoNota);
    }
  }, [tipoNota, open]);

  const cargarSeries = async (idTipo: number, idAlm: number) => {
    try {
      const data = await servicioVentas.obtenerSeries(idTipo, idAlm);
      setSeries(data);
      if (data.length > 0) {
        setSerieSeleccionada(data[0].serie);
      } else {
        setSerieSeleccionada("");
      }
    } catch (error) {
      console.error("Error al cargar las series:", error);
    }
  };

  const cargarMotivos = async (tipo: string) => {
    try {
      const data = tipo === TipoComprobanteSunat.NotaCredito 
        ? await servicioVentas.obtenerMotivosCredito()
        : await servicioVentas.obtenerMotivosDebito();
      setMotivos(data);
      if (data.length > 0) setMotivoSunat(data[0].idMotivo.toString());
    } catch (error) {
      console.error("Error al cargar los motivos SUNAT:", error);
    }
  };

  const cargarVenta = async (id: number) => {
    try {
      setIsFetching(true);
      const data = await servicioVentas.obtenerVentaPorId(id);
      setVenta(data);
      setSustento(`Nota de Crédito/Débito por la venta ${data.serie}-${data.numero.toString().padStart(8, '0')}`);
      // El motivoSunat se setea en cargarMotivos automáticamente
    } catch (error) {
      console.error("No se pudo cargar el detalle de la venta:", error);
      onOpenChange(false);
    } finally {
      setIsFetching(false);
    }
  };

  if (!idVenta) return null;

  const handleGuardar = async () => {
    if (!venta) return;
    if (!motivoSunat || !sustento.trim() || !serieSeleccionada) {
      toast.error("Complete todos los campos obligatorios (incluyendo la serie)");
      return;
    }

    try {
      setIsLoading(true);
      
      const payload = {
        idVentaReferencia: venta.id,
        serie: serieSeleccionada, // Campo obligatorio corregido
        tipoNota: tipoNota,
        idTipoNota: parseInt(motivoSunat),
        motivoSustento: sustento,
        afectaStock: afectaStock,
        detalles: venta.detalles?.map(d => ({
          idProducto: d.idProducto,
          idVentaDetalle: d.id,
          descripcion: d.descripcionProducto,
          cantidad: d.cantidad,
          precioUnitario: d.precioUnitario
        })) || []
      };

      if (tipoNota === TipoComprobanteSunat.NotaCredito) {
        await servicioVentas.crearNotaCredito(payload);
        toast.success("Nota de Crédito generada exitosamente");
      } else {
        await servicioVentas.crearNotaDebito(payload);
        toast.success("Nota de Débito generada exitosamente");
      }

      onSuccess();
      onOpenChange(false);
    } catch (error: any) {
      console.error("Error al generar la nota:", error);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-[500px]">
        <DialogHeader className="sr-only">
          <DialogTitle>Emitir Nota SUNAT</DialogTitle>
          <DialogDescription>
            Formulario para la emisión de notas de crédito y débito electrónicas.
          </DialogDescription>
        </DialogHeader>
        
        {isFetching ? (
          <div className="flex flex-col items-center justify-center p-20 gap-4">
            <Loader2 className="h-8 w-8 animate-spin text-primary" />
            <p className="text-sm text-muted-foreground">Cargando datos de la venta...</p>
          </div>
        ) : venta ? (
          <>
            <DialogHeader>
              <DialogTitle>Emitir Nota SUNAT (Referencia: {venta.serie}-{venta.numero.toString().padStart(8, '0')})</DialogTitle>
              <DialogDescription>
                Seleccione el tipo de nota e indique el motivo SUNAT correspondiente.
              </DialogDescription>
            </DialogHeader>
            {/* ... resto del contenido ... */}
            <div className="flex flex-col gap-5 py-4">
              {/* ... contenido del formulario ... */}
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label htmlFor="tipoNota" className="flex items-center gap-1.5 font-semibold text-sm">
                    <FileText className="h-4 w-4 text-primary" />
                    Tipo de Nota
                  </Label>
                  <Select 
                    value={tipoNota} 
                    onValueChange={(val: TipoComprobanteSunat) => setTipoNota(val)}
                  >
                    <SelectTrigger id="tipoNota" className="bg-muted/30 border-muted-foreground/20">
                      <SelectValue placeholder="Seleccione Tipo" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value={TipoComprobanteSunat.NotaCredito}>Crédito (07)</SelectItem>
                      <SelectItem value={TipoComprobanteSunat.NotaDebito}>Débito (08)</SelectItem>
                    </SelectContent>
                  </Select>
                </div>

                <div className="space-y-2">
                  <Label htmlFor="serieNota" className="flex items-center gap-1.5 font-semibold text-sm">
                    <Settings className="h-4 w-4 text-primary" />
                    Serie de Nota
                  </Label>
                  <Select 
                    value={serieSeleccionada} 
                    onValueChange={setSerieSeleccionada}
                    disabled={series.length === 0}
                  >
                    <SelectTrigger id="serieNota" className="bg-muted/30 border-muted-foreground/20">
                      <SelectValue placeholder={series.length > 0 ? "Seleccione Serie" : "Sin Series"} />
                    </SelectTrigger>
                    <SelectContent>
                      {series.map(s => (
                        <SelectItem key={s.id} value={s.serie}>
                          {s.serie} (Sig: {s.correlativoActual + 1})
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                  {series.length === 0 && !isFetching && (
                    <p className="text-[10px] text-destructive font-medium italic">No hay series configuradas para este comprobante.</p>
                  )}
                </div>

                <div className="space-y-2">
                  <Label htmlFor="motivoSunat" className="flex items-center gap-1.5 font-semibold text-sm">
                    <Settings className="h-4 w-4 text-primary" />
                    Motivo SUNAT
                  </Label>
                  <Select value={motivoSunat} onValueChange={setMotivoSunat}>
                    <SelectTrigger id="motivoSunat" className="bg-muted/30 border-muted-foreground/20">
                      <SelectValue placeholder="Motivo" />
                    </SelectTrigger>
                    <SelectContent>
                      {motivos.map(m => (
                        <SelectItem key={m.idMotivo} value={m.idMotivo.toString()}>
                          {m.codigoSunat} - {m.descripcion}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>
              </div>

              <div className="space-y-2">
                <Label htmlFor="sustento" className="flex items-center gap-1.5 font-semibold text-sm">
                  <MessageSquare className="h-4 w-4 text-primary" />
                  Sustento detallado
                </Label>
                <Textarea 
                  id="sustento" 
                  className="resize-none min-h-[90px] bg-muted/30 border-muted-foreground/20 focus:bg-background transition-colors" 
                  placeholder="Describa el motivo de la nota..." 
                  value={sustento}
                  onChange={(e) => setSustento(e.target.value)}
                />
              </div>

              <div className="p-4 rounded-xl border border-primary/20 bg-primary/5 flex items-center justify-between group hover:bg-primary/10 transition-colors">
                <div className="flex gap-3 items-center">
                  <div className="p-2.5 rounded-lg bg-primary/10 text-primary group-hover:scale-110 transition-transform">
                    <RotateCcw className="h-5 w-5" />
                  </div>
                  <div className="space-y-0.5">
                    <Label className="text-sm font-bold cursor-pointer" onClick={() => setAfectaStock(!afectaStock)}>
                      ¿Afecta Inventario?
                    </Label>
                    <p className="text-[11px] text-muted-foreground flex items-center gap-1">
                      <HelpCircle className="h-3 w-3" />
                      El stock se ajustará automáticamente
                    </p>
                  </div>
                </div>
                <Switch 
                  checked={afectaStock} 
                  onCheckedChange={setAfectaStock}
                  className="data-[state=checked]:bg-primary"
                />
              </div>
            </div>

            <DialogFooter className="gap-2 sm:gap-0">
              <Button variant="ghost" onClick={() => onOpenChange(false)} disabled={isLoading} className="hover:bg-muted/50">
                Cancelar
              </Button>
              <Button 
                onClick={handleGuardar} 
                disabled={isLoading}
                className="gap-2 shadow-lg shadow-primary/20 font-bold"
              >
                {isLoading ? "Emitiendo..." : (
                  <>
                    <CheckCircle2 className="h-4 w-4" /> 
                    Generar Documento
                  </>
                )}
              </Button>
            </DialogFooter>
          </>
        ) : (
          <div className="p-10 text-center text-destructive font-medium">No se pudieron cargar los datos de la venta.</div>
        )}
      </DialogContent>
    </Dialog>
  );
}
