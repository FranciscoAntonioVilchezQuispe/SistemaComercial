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
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/componentes/ui/select';
import { turnoService, TurnoVendedorDto } from '../../servicios/turnoService';
import { toast } from 'sonner';
import { Wallet, Store, ArrowRightCircle } from 'lucide-react';

interface ModalAperturaTurnoProps {
    isOpen: boolean;
    onSuccess: (turno: TurnoVendedorDto) => void;
}

export const ModalAperturaTurno = ({ isOpen, onSuccess }: ModalAperturaTurnoProps) => {
    const [cajaId, setCajaId] = useState<string>('1'); // Por simplicidad, caja 1 por defecto
    const [monto, setMonto] = useState<string>('0.00');
    const [loading, setLoading] = useState(false);

    const handleAbrir = async () => {
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
            toast.error(error.response?.data || "Error al abrir turno");
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
                        <Select value={cajaId} onValueChange={setCajaId}>
                            <SelectTrigger className="h-12 bg-slate-50 dark:bg-slate-900 border-slate-200">
                                <SelectValue placeholder="Seleccione una caja" />
                            </SelectTrigger>
                            <SelectContent>
                                <SelectItem value="1">Caja Principal - Central</SelectItem>
                                <SelectItem value="2">Caja 02 - Pasillo A</SelectItem>
                            </SelectContent>
                        </Select>
                    </div>
                    <div className="space-y-2">
                        <Label htmlFor="monto">Monto Inicial (Soles)</Label>
                        <div className="relative">
                            <Wallet className="absolute left-3 top-3 h-5 w-5 text-muted-foreground" />
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
                        className="w-full h-12 text-base" 
                        disabled={loading}
                    >
                        {loading ? "Abriendo..." : (
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
