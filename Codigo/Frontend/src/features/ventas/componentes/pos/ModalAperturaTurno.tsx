import { useState, useEffect } from 'react';
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
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/componentes/ui/select';
import { turnoService, TurnoVendedorDto } from '../../servicios/turnoService';
import { servicioCajas } from '../../servicios/servicioCajas';
import { CajaListItem } from '../../tipos/ventas.types';
import { toast } from 'sonner';
import { Wallet, Store, ArrowRightCircle, Loader2 } from 'lucide-react';

interface ModalAperturaTurnoProps {
    isOpen: boolean;
    onSuccess: (turno: TurnoVendedorDto) => void;
}

export const ModalAperturaTurno = ({ isOpen, onSuccess }: ModalAperturaTurnoProps) => {
    const [cajaId, setCajaId] = useState<string>('');
    const [monto, setMonto] = useState<string>('0.00');
    const [loading, setLoading] = useState(false);
    const [cajas, setCajas] = useState<CajaListItem[]>([]);
    const [cargandoCajas, setCargandoCajas] = useState(false);

    useEffect(() => {
        if (isOpen) {
            cargarCajas();
        }
    }, [isOpen]);

    const cargarCajas = async () => {
        setCargandoCajas(true);
        try {
            const data = await servicioCajas.obtenerTodas();
            const cajasActivas = data.filter(c => c.activado);
            setCajas(cajasActivas);
            if (cajasActivas.length > 0) {
                setCajaId(cajasActivas[0].id.toString());
            }
        } catch (error) {
            console.error("Error al cargar cajas", error);
        } finally {
            setCargandoCajas(false);
        }
    };

    const handleAbrir = async () => {
        if (!cajaId) {
            toast.error("Debe seleccionar una caja");
            return;
        }

        setLoading(true);
        try {
            const m = parseFloat(monto);
            if (isNaN(m) || m < 0) {
                toast.error("Monto de apertura inválido");
                return;
            }

            const turno = await turnoService.abrirTurno(parseInt(cajaId), m);
            toast.success("Turno abierto exitosamente");
            onSuccess(turno);
        } catch (error: any) {
            // El interceptor ya maneja el toast si es error de API, 
            // pero si es un error local o específico lo capturamos aquí.
        } finally {
            setLoading(false);
        }
    };

    return (
        <Dialog open={isOpen} onOpenChange={() => {}}>
            <DialogContent className="sm:max-w-[425px] border-none shadow-2xl">
                <DialogHeader>
                    <div className="mx-auto bg-primary/10 p-3 rounded-full w-fit mb-2">
                        <Store className="h-6 w-6 text-primary" />
                    </div>
                    <DialogTitle className="text-2xl font-bold text-center">Apertura de Caja</DialogTitle>
                    <DialogDescription className="text-center">
                        Para iniciar las ventas del día, por favor selecciona la caja e ingresa el monto inicial.
                    </DialogDescription>
                </DialogHeader>
                <div className="grid gap-6 py-4">
                    <div className="space-y-2">
                        <Label htmlFor="caja">Seleccionar Caja</Label>
                        <Select value={cajaId} onValueChange={setCajaId} disabled={cargandoCajas}>
                            <SelectTrigger className="h-12 bg-slate-50 dark:bg-slate-900 border-slate-200">
                                {cargandoCajas ? (
                                    <div className="flex items-center gap-2">
                                        <Loader2 className="h-4 w-4 animate-spin" />
                                        <span>Cargando cajas...</span>
                                    </div>
                                ) : (
                                    <SelectValue placeholder="Seleccione una caja" />
                                )}
                            </SelectTrigger>
                            <SelectContent>
                                {cajas.map(caja => (
                                    <SelectItem key={caja.id} value={caja.id.toString()}>
                                        {caja.nombreCaja}
                                    </SelectItem>
                                ))}
                                {cajas.length === 0 && !cargandoCajas && (
                                    <SelectItem value="0" disabled>No hay cajas activas</SelectItem>
                                )}
                            </SelectContent>
                        </Select>
                    </div>
                    <div className="space-y-2">
                        <Label htmlFor="monto">Monto Inicial (Soles)</Label>
                        <div className="relative">
                            <span className="absolute left-3 top-3 font-semibold text-muted-foreground">S/</span>
                            <Input 
                                id="monto" 
                                type="number" 
                                step="0.01"
                                className="pl-10 h-12 text-lg font-semibold bg-slate-50 dark:bg-slate-900 border-slate-200"
                                value={monto}
                                onChange={(e) => setMonto(e.target.value)}
                            />
                        </div>
                    </div>
                </div>
                <DialogFooter>
                    <Button 
                        onClick={handleAbrir} 
                        className="w-full h-12 text-base font-bold shadow-lg shadow-primary/20" 
                        disabled={loading || cargandoCajas || cajas.length === 0}
                    >
                        {loading ? (
                            <div className="flex items-center gap-2">
                                <Loader2 className="h-5 w-5 animate-spin" />
                                Abriendo...
                            </div>
                        ) : (
                            <div className="flex items-center gap-2">
                                Iniciar Jornada <ArrowRightCircle className="h-5 w-5" />
                            </div>
                        )}
                    </Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>
    );
};
