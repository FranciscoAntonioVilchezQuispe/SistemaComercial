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
import { Input } from '@/componentes/ui/input';
import { Label } from '@/componentes/ui/label';
import { Textarea } from '@/componentes/ui/textarea';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/componentes/ui/select';
import { servicioCajas } from '../../servicios/servicioCajas';
import { toast } from 'sonner';
import { ArrowDownCircle, ArrowUpCircle, Loader2, DollarSign, FileText } from 'lucide-react';

interface ModalMovimientoCajaProps {
    isOpen: boolean;
    onClose: () => void;
    cajaId: number;
    turnoId?: number;
    onSuccess: () => void;
}

export const ModalMovimientoCaja = ({ isOpen, onClose, cajaId, turnoId, onSuccess }: ModalMovimientoCajaProps) => {
    const [tipo, setTipo] = useState<'INGRESO' | 'EGRESO'>('EGRESO');
    const [monto, setMonto] = useState<string>('');
    const [concepto, setConcepto] = useState<string>('');
    const [loading, setLoading] = useState(false);

    const handleGuardar = async () => {
        const m = parseFloat(monto);
        if (isNaN(m) || m <= 0) {
            toast.error("Ingrese un monto válido mayor a cero");
            return;
        }

        if (!concepto.trim()) {
            toast.error("Debe ingresar el concepto del movimiento");
            return;
        }

        setLoading(true);
        try {
            // El backend espera el monto con signo según tipo si no se especifica el tipo explícitamente,
            // pero el servicio ya indica que positivo = ingreso, negativo = egreso.
            const montoFinal = tipo === 'INGRESO' ? m : -m;
            
            await servicioCajas.registrarMovimiento(cajaId, {
                idTurnoVendedor: turnoId,
                idTipoMovimiento: tipo === 'INGRESO' ? 1 : 2, // Convención: 1 Ingreso, 2 Egreso (ver Tarea B)
                monto: montoFinal,
                concepto: concepto.trim()
            });

            toast.success(`${tipo} registrado correctamente`);
            onSuccess();
            onClose();
            // Reset form
            setMonto('');
            setConcepto('');
        } catch (error: any) {
            // Manejado por interceptor
        } finally {
            setLoading(false);
        }
    };

    return (
        <Dialog open={isOpen} onOpenChange={onClose}>
            <DialogContent className="sm:max-w-[425px] border-none shadow-2xl">
                <DialogHeader>
                    <div className={`mx-auto p-3 rounded-full w-fit mb-2 ${tipo === 'INGRESO' ? 'bg-emerald-100 text-emerald-600' : 'bg-red-100 text-red-600'}`}>
                        {tipo === 'INGRESO' ? <ArrowUpCircle className="h-6 w-6" /> : <ArrowDownCircle className="h-6 w-6" />}
                    </div>
                    <DialogTitle className="text-2xl font-bold text-center">Movimiento de Caja</DialogTitle>
                    <DialogDescription className="text-center">
                        Registra una entrada o salida manual de efectivo de la caja actual.
                    </DialogDescription>
                </DialogHeader>

                <div className="grid gap-5 py-4">
                    <div className="space-y-2">
                        <Label>Tipo de Movimiento</Label>
                        <div className="grid grid-cols-2 gap-2">
                            <Button 
                                type="button"
                                variant={tipo === 'INGRESO' ? 'default' : 'outline'}
                                className={tipo === 'INGRESO' ? 'bg-emerald-600 hover:bg-emerald-700' : ''}
                                onClick={() => setTipo('INGRESO')}
                            >
                                <ArrowUpCircle className="h-4 w-4 mr-2" /> Ingreso
                            </Button>
                            <Button 
                                type="button"
                                variant={tipo === 'EGRESO' ? 'default' : 'outline'}
                                className={tipo === 'EGRESO' ? 'bg-red-600 hover:bg-red-700' : ''}
                                onClick={() => setTipo('EGRESO')}
                            >
                                <ArrowDownCircle className="h-4 w-4 mr-2" /> Egreso
                            </Button>
                        </div>
                    </div>

                    <div className="space-y-2">
                        <Label htmlFor="monto_mov">Monto (Soles)</Label>
                        <div className="relative">
                            <DollarSign className="absolute left-3 top-3 h-4 w-4 text-muted-foreground" />
                            <Input 
                                id="monto_mov" 
                                type="number" 
                                step="0.01"
                                placeholder="0.00"
                                className="pl-10 h-11 text-lg font-semibold"
                                value={monto}
                                onChange={(e) => setMonto(e.target.value)}
                            />
                        </div>
                    </div>

                    <div className="space-y-2">
                        <Label htmlFor="concepto">Concepto / Motivo</Label>
                        <div className="relative">
                            <FileText className="absolute left-3 top-3 h-4 w-4 text-muted-foreground" />
                            <Textarea 
                                id="concepto" 
                                placeholder="Ej: Pago de limpieza, Compra de útiles, etc."
                                className="pl-10 min-h-[100px] resize-none"
                                value={concepto}
                                onChange={(e) => setConcepto(e.target.value)}
                            />
                        </div>
                    </div>
                </div>

                <DialogFooter className="gap-2 sm:gap-0">
                    <Button variant="ghost" onClick={onClose} disabled={loading} className="flex-1">
                        Cancelar
                    </Button>
                    <Button 
                        onClick={handleGuardar} 
                        className={`flex-1 font-bold ${tipo === 'INGRESO' ? 'bg-emerald-600 hover:bg-emerald-700 shadow-emerald-600/20' : 'bg-red-600 hover:bg-red-700 shadow-red-600/20'} shadow-lg`} 
                        disabled={loading}
                    >
                        {loading ? <Loader2 className="h-4 w-4 animate-spin mr-2" /> : null}
                        Registrar {tipo.toLowerCase()}
                    </Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>
    );
};
