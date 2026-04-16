import { useState } from 'react';
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
import { Label } from '@/componentes/ui/label';
import { turnoService, CierreTurnoDto } from '../../servicios/turnoService';
import { toast } from 'sonner';
import { ClipboardCheck, CreditCard, Landmark, AlertCircle } from 'lucide-react';
import { formatearMoneda } from '@/compartido/utilidades/moneda';

interface ModalCierreTurnoProps {
    isOpen: boolean;
    onClose: () => void;
    turnoId: number;
    onSuccess: (cierre: CierreTurnoDto) => void;
}

export const ModalCierreTurno = ({ isOpen, onClose, turnoId, onSuccess }: ModalCierreTurnoProps) => {
    const [observaciones, setObservaciones] = useState('');
    const [loading, setLoading] = useState(false);

    const handleCerrar = async () => {
        setLoading(true);
        try {
            const cierre = await turnoService.cerrarTurno(turnoId, observaciones);
            toast.success("Caja cerrada exitosamente");
            onSuccess(cierre);
        } catch (error: any) {
            toast.error(error.response?.data || "Error al cerrar caja");
        } finally {
            setLoading(false);
        }
    };

    return (
        <Dialog open={isOpen} onOpenChange={onClose}>
            <DialogContent className="sm:max-w-[500px] border-none shadow-2xl">
                <DialogHeader>
                    <div className="mx-auto bg-amber-100 p-3 rounded-full w-fit mb-2">
                        <ClipboardCheck className="h-6 w-6 text-amber-600" />
                    </div>
                    <DialogTitle className="text-2xl font-bold text-center">Cierre de Caja</DialogTitle>
                    <DialogDescription className="text-center">
                        Estás a punto de finalizar tu jornada. Revisa el resumen de ventas antes de confirmar.
                    </DialogDescription>
                </DialogHeader>

                <div className="py-4 space-y-4">
                    <div className="bg-slate-50 dark:bg-slate-900 rounded-xl p-4 border border-slate-100 dark:border-slate-800 space-y-3">
                        <h4 className="font-semibold text-sm text-slate-500 uppercase tracking-wider">Resumen de Ventas (Referencial)</h4>
                        
                        <div className="grid grid-cols-2 gap-4">
                            <div className="flex items-center gap-2">
                                <Landmark className="h-4 w-4 text-emerald-500" />
                                <div>
                                    <p className="text-xs text-muted-foreground">Efectivo</p>
                                    <p className="font-bold">{formatearMoneda(0)}</p>
                                </div>
                            </div>
                            <div className="flex items-center gap-2">
                                <CreditCard className="h-4 w-4 text-blue-500" />
                                <div>
                                    <p className="text-xs text-muted-foreground">Tarjetas</p>
                                    <p className="font-bold">{formatearMoneda(0)}</p>
                                </div>
                            </div>
                        </div>
                        
                        <div className="pt-2 border-t border-slate-200 dark:border-slate-700">
                            <div className="flex justify-between items-center text-lg font-bold">
                                <span>Total General</span>
                                <span className="text-primary">{formatearMoneda(0)}</span>
                            </div>
                        </div>
                    </div>

                    <div className="space-y-2">
                        <Label htmlFor="obs">Observaciones / Descuadres</Label>
                        <Textarea 
                            id="obs" 
                            placeholder="Ej: Se entregó S/ 500.00 al supervisor. Todo conforme."
                            className="bg-slate-50 dark:bg-slate-900 resize-none h-24"
                            value={observaciones}
                            onChange={(e) => setObservaciones(e.target.value)}
                        />
                    </div>

                    <div className="flex gap-2 p-3 bg-red-50 dark:bg-red-950/20 rounded-lg text-red-600 dark:text-red-400 text-xs">
                        <AlertCircle className="h-4 w-4 shrink-0" />
                        <p>Una vez cerrada la caja no podrás registrar nuevas ventas hasta abrir un nuevo turno.</p>
                    </div>
                </div>

                <DialogFooter className="flex gap-2 sm:gap-0">
                    <Button variant="ghost" onClick={onClose} disabled={loading} className="flex-1">
                        Cancelar
                    </Button>
                    <Button 
                        onClick={handleCerrar} 
                        className="flex-1 bg-red-600 hover:bg-red-700" 
                        disabled={loading}
                    >
                        {loading ? "Cerrando..." : "Confirmar Cierre"}
                    </Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>
    );
};
