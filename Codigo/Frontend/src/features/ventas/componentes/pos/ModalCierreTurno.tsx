import { useState, useEffect, useMemo } from 'react';
import { 
    Dialog, 
    DialogContent, 
    DialogHeader, 
    DialogTitle, 
    DialogDescription,
    DialogFooter
} from '@/componentes/ui/dialog';
import { Button } from '@/componentes/ui/button';
import { Textarea } from '@/componentes/ui/textarea';
import { Input } from '@/componentes/ui/input';
import { Label } from '@/componentes/ui/label';
import { turnoService, CierreTurnoDto } from '../../servicios/turnoService';
import { TurnoResumenPrevio } from '../../tipos/ventas.types';
import { toast } from 'sonner';
import { ClipboardCheck, CreditCard, Landmark, AlertCircle, Loader2, Calculator, Info, Wallet } from 'lucide-react';
import { formatearMoneda } from '@/compartido/utilidades/moneda';

interface ModalCierreTurnoProps {
    isOpen: boolean;
    onClose: () => void;
    turnoId: number;
    onSuccess: (cierre: CierreTurnoDto) => void;
}

export const ModalCierreTurno = ({ isOpen, onClose, turnoId, onSuccess }: ModalCierreTurnoProps) => {
    const [observaciones, setObservaciones] = useState('');
    const [montoFisico, setMontoFisico] = useState<string>('0.00');
    const [loading, setLoading] = useState(false);
    const [cargandoResumen, setCargandoResumen] = useState(false);
    const [resumen, setResumen] = useState<TurnoResumenPrevio | null>(null);

    useEffect(() => {
        if (isOpen && turnoId) {
            cargarResumen();
        }
    }, [isOpen, turnoId]);

    const cargarResumen = async () => {
        setCargandoResumen(true);
        try {
            const data = await turnoService.obtenerResumenPrevioCierre(turnoId);
            setResumen(data);
            setMontoFisico(data.montoEsperadoEnCaja.toFixed(2));
        } catch (error) {
            console.error("Error al cargar resumen", error);
        } finally {
            setCargandoResumen(false);
        }
    };

    const diferencia = useMemo(() => {
        if (!resumen) return 0;
        const fisico = parseFloat(montoFisico) || 0;
        return fisico - resumen.montoEsperadoEnCaja;
    }, [montoFisico, resumen]);

    const handleCerrar = async () => {
        setLoading(true);
        try {
            const m = parseFloat(montoFisico);
            if (isNaN(m) || m < 0) {
                toast.error("Monto físico inválido");
                return;
            }

            const cierre = await turnoService.cerrarTurno(turnoId, m, observaciones);
            toast.success("Caja cerrada exitosamente");
            onSuccess(cierre);
        } catch (error: any) {
            // Manejado por interceptor
        } finally {
            setLoading(false);
        }
    };

    if (cargandoResumen) {
        return (
            <Dialog open={isOpen} onOpenChange={onClose}>
                <DialogContent className="sm:max-w-[500px] h-[400px] flex items-center justify-center">
                    <div className="text-center space-y-4">
                        <Loader2 className="h-10 w-10 animate-spin text-primary mx-auto" />
                        <p className="text-slate-500 font-medium">Calculando resumen de caja...</p>
                    </div>
                </DialogContent>
            </Dialog>
        );
    }

    return (
        <Dialog open={isOpen} onOpenChange={onClose}>
            <DialogContent className="sm:max-w-[550px] border-none shadow-2xl overflow-hidden p-0">
                <DialogHeader className="p-6 pb-0">
                    <div className="mx-auto bg-amber-100 p-3 rounded-full w-fit mb-2">
                        <ClipboardCheck className="h-6 w-6 text-amber-600" />
                    </div>
                    <DialogTitle className="text-2xl font-bold text-center">Cierre de Caja y Arqueo</DialogTitle>
                    <DialogDescription className="text-center">
                        Revisa los totales del sistema y registra el efectivo físico contado.
                    </DialogDescription>
                </DialogHeader>

                <div className="p-6 pt-4 space-y-6 overflow-y-auto max-h-[70vh]">
                    {/* Resumen de Ventas */}
                    <div className="bg-slate-50 dark:bg-slate-900 rounded-xl p-4 border border-slate-100 dark:border-slate-800 space-y-4">
                        <h4 className="font-bold text-xs text-slate-500 uppercase tracking-wider flex items-center gap-2">
                            <Calculator className="h-3 w-3" /> Totales según Sistema
                        </h4>
                        
                        <div className="grid grid-cols-2 gap-x-8 gap-y-3">
                            <div className="flex justify-between items-center text-sm">
                                <span className="text-muted-foreground flex items-center gap-1">
                                    <Wallet className="h-3 w-3" /> Apertura
                                </span>
                                <span className="font-medium">{formatearMoneda(resumen?.montoApertura || 0)}</span>
                            </div>
                            <div className="flex justify-between items-center text-sm">
                                <span className="text-muted-foreground flex items-center gap-1">
                                    <Landmark className="h-3 w-3" /> Ventas Efectivo
                                </span>
                                <span className="font-medium text-emerald-600">+{formatearMoneda(resumen?.totalEfectivo || 0)}</span>
                            </div>
                            <div className="flex justify-between items-center text-sm">
                                <span className="text-muted-foreground">Ingresos Manuales</span>
                                <span className="font-medium text-emerald-600">+{formatearMoneda(resumen?.totalIngresosManualles || 0)}</span>
                            </div>
                            <div className="flex justify-between items-center text-sm">
                                <span className="text-muted-foreground">Egresos Manuales</span>
                                <span className="font-medium text-red-600">-{formatearMoneda(resumen?.totalEgresosManualles || 0)}</span>
                            </div>
                            <div className="flex justify-between items-center text-sm col-span-2 pt-2 border-t">
                                <span className="font-bold text-slate-700 dark:text-slate-200">Efectivo Esperado (Soles)</span>
                                <span className="font-bold text-lg text-primary">{formatearMoneda(resumen?.montoEsperadoEnCaja || 0)}</span>
                            </div>
                        </div>

                        {/* Otros Medios de Pago */}
                        <div className="pt-2 border-t border-slate-200 dark:border-slate-700 grid grid-cols-2 gap-4">
                            <div className="flex items-center gap-2 opacity-70">
                                <CreditCard className="h-3 w-3 text-blue-500" />
                                <span className="text-xs text-muted-foreground">Tarjetas: {formatearMoneda(resumen?.totalTarjeta || 0)}</span>
                            </div>
                            <div className="flex items-center gap-2 opacity-70">
                                <Info className="h-3 w-3 text-indigo-500" />
                                <span className="text-xs text-muted-foreground">Transfer.: {formatearMoneda(resumen?.totalTransferencia || 0)}</span>
                            </div>
                        </div>
                    </div>

                    {/* Arqueo Físico */}
                    <div className="grid grid-cols-2 gap-4">
                        <div className="space-y-2">
                            <Label htmlFor="fisico" className="text-sm font-bold">Efectivo Físico Contado</Label>
                            <div className="relative">
                                <span className="absolute left-3 top-2.5 font-bold text-slate-400">S/</span>
                                <Input 
                                    id="fisico" 
                                    type="number" 
                                    step="0.01"
                                    className="pl-8 h-11 text-lg font-bold border-2 focus-visible:ring-primary"
                                    value={montoFisico}
                                    onChange={(e) => setMontoFisico(e.target.value)}
                                />
                            </div>
                        </div>
                        <div className="space-y-2">
                            <Label className="text-sm font-bold">Diferencia / Descuadre</Label>
                            <div className={`h-11 rounded-md flex items-center px-4 font-bold text-lg border-2 ${
                                diferencia === 0 ? 'bg-slate-50 border-slate-200 text-slate-500' : 
                                diferencia > 0 ? 'bg-emerald-50 border-emerald-200 text-emerald-600' : 
                                'bg-red-50 border-red-200 text-red-600'
                            }`}>
                                {diferencia > 0 && '+'}
                                {formatearMoneda(diferencia)}
                            </div>
                        </div>
                    </div>

                    <div className="space-y-2">
                        <Label htmlFor="obs" className="text-sm font-medium">Observaciones del Cierre</Label>
                        <Textarea 
                            id="obs" 
                            placeholder="Ej: El descuadre se debe a redondeo en sencillo. Todo conforme."
                            className="bg-slate-50 dark:bg-slate-900 resize-none h-20"
                            value={observaciones}
                            onChange={(e) => setObservaciones(e.target.value)}
                        />
                    </div>

                    <div className="flex gap-2 p-3 bg-blue-50 dark:bg-blue-950/20 rounded-lg text-blue-700 dark:text-blue-400 text-[11px] leading-tight">
                        <AlertCircle className="h-4 w-4 shrink-0" />
                        <p>El arqueo permite registrar la cantidad real de dinero en caja. Las diferencias serán reportadas al administrador automáticamente.</p>
                    </div>
                </div>

                <DialogFooter className="p-6 bg-slate-50 dark:bg-slate-900/50 border-t flex gap-3 sm:gap-0">
                    <Button variant="ghost" onClick={onClose} disabled={loading} className="flex-1">
                        Cancelar
                    </Button>
                    <Button 
                        onClick={handleCerrar} 
                        className="flex-1 bg-red-600 hover:bg-red-700 shadow-lg shadow-red-600/20 font-bold" 
                        disabled={loading}
                    >
                        {loading ? <Loader2 className="h-4 w-4 animate-spin mr-2" /> : null}
                        Confirmar Cierre de Caja
                    </Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>
    );
};
