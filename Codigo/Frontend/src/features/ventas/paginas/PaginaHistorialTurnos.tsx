import { useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import { 
    Search, 
    Calendar, 
    LayoutList, 
    ChevronLeft, 
    ChevronRight,
    Eye,
    Receipt,
    History
} from 'lucide-react';
import { format } from 'date-fns';
import { es } from 'date-fns/locale';

import { Button } from '@/compartido/componentes/ui/button';
import { Input } from '@/compartido/componentes/ui/input';
import { Badge } from '@/compartido/componentes/ui/badge';
import { Card, CardContent, CardHeader, CardTitle } from '@/compartido/componentes/ui/card';
import { 
    Select, 
    SelectContent, 
    SelectItem, 
    SelectTrigger, 
    SelectValue 
} from '@/compartido/componentes/ui/select';
import { Separator } from '@/compartido/componentes/ui/separator';

import { turnoService } from '../servicios/turnoService';
import { servicioCajas } from '../servicios/servicioCajas';
import type { TurnoHistorialItem } from '../tipos/ventas.types';

export function PaginaHistorialTurnos() {
    const [pagina, setPagina] = useState(1);
    const [cajaId, setCajaId] = useState<string>('all');
    const [estado, setEstado] = useState<string>('all');
    const [fechaDesde, setFechaDesde] = useState<string>('');
    const [fechaHasta, setFechaHasta] = useState<string>('');

    const pageSize = 10;

    const { data: cajas = [] } = useQuery({
        queryKey: ['cajas-list'],
        queryFn: () => servicioCajas.obtenerTodas()
    });

    const { data, isLoading } = useQuery({
        queryKey: ['historial-turnos', pagina, cajaId, estado, fechaDesde, fechaHasta],
        queryFn: () => turnoService.obtenerHistorialTurnos({
            pageNumber: pagina,
            pageSize,
            cajaId: cajaId === 'all' ? undefined : parseInt(cajaId),
            estado: estado === 'all' ? undefined : estado,
            fechaDesde: fechaDesde || undefined,
            fechaHasta: fechaHasta || undefined
        })
    });

    const turnos = data?.datos ?? [];
    const total = data?.total ?? 0;
    const totalPages = Math.ceil(total / pageSize);

    const formatCurrency = (value: number) => {
        return new Intl.NumberFormat('es-PE', { style: 'currency', currency: 'PEN' }).format(value);
    };

    return (
        <div className="p-6 space-y-6 animate-in fade-in duration-500">
            <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
                <div>
                    <h1 className="text-3xl font-bold tracking-tight">Historial de Turnos</h1>
                    <p className="text-muted-foreground">Consulta y audita los cierres de caja realizados.</p>
                </div>
                <div className="flex items-center gap-2">
                    <Button variant="outline" className="gap-2">
                        <Receipt className="h-4 w-4" /> Exportar
                    </Button>
                </div>
            </div>

            <Card className="border-none shadow-md bg-white/50 dark:bg-slate-900/50 backdrop-blur-sm">
                <CardHeader className="pb-3">
                    <CardTitle className="text-lg font-semibold flex items-center gap-2">
                        <Search className="h-5 w-5 text-primary" /> Filtros de Búsqueda
                    </CardTitle>
                </CardHeader>
                <CardContent>
                    <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
                        <div className="space-y-2">
                            <label className="text-xs font-medium uppercase text-muted-foreground">Caja</label>
                            <Select value={cajaId} onValueChange={setCajaId}>
                                <SelectTrigger>
                                    <SelectValue placeholder="Todas las cajas" />
                                </SelectTrigger>
                                <SelectContent>
                                    <SelectItem value="all">Todas las cajas</SelectItem>
                                    {cajas.map(c => (
                                        <SelectItem key={c.id} value={String(c.id)}>{c.nombreCaja}</SelectItem>
                                    ))}
                                </SelectContent>
                            </Select>
                        </div>
                        <div className="space-y-2">
                            <label className="text-xs font-medium uppercase text-muted-foreground">Estado</label>
                            <Select value={estado} onValueChange={setEstado}>
                                <SelectTrigger>
                                    <SelectValue placeholder="Todos los estados" />
                                </SelectTrigger>
                                <SelectContent>
                                    <SelectItem value="all">Todos los estados</SelectItem>
                                    <SelectItem value="ABIERTO">Abierto</SelectItem>
                                    <SelectItem value="CERRADO">Cerrado</SelectItem>
                                </SelectContent>
                            </Select>
                        </div>
                        <div className="space-y-2">
                            <label className="text-xs font-medium uppercase text-muted-foreground">Desde</label>
                            <div className="relative">
                                <Calendar className="absolute left-3 top-2.5 h-4 w-4 text-muted-foreground" />
                                <Input 
                                    type="date" 
                                    className="pl-10" 
                                    value={fechaDesde}
                                    onChange={(e) => setFechaDesde(e.target.value)}
                                />
                            </div>
                        </div>
                        <div className="space-y-2">
                            <label className="text-xs font-medium uppercase text-muted-foreground">Hasta</label>
                            <div className="relative">
                                <Calendar className="absolute left-3 top-2.5 h-4 w-4 text-muted-foreground" />
                                <Input 
                                    type="date" 
                                    className="pl-10"
                                    value={fechaHasta}
                                    onChange={(e) => setFechaHasta(e.target.value)}
                                />
                            </div>
                        </div>
                    </div>
                </CardContent>
            </Card>

            <Card className="border-none shadow-xl overflow-hidden bg-white dark:bg-slate-900">
                <div className="overflow-x-auto">
                    <table className="w-full text-sm">
                        <thead>
                            <tr className="bg-slate-50 dark:bg-slate-800/50 border-b">
                                <th className="px-6 py-4 text-left font-semibold text-slate-600 dark:text-slate-300">Caja / Vendedor</th>
                                <th className="px-6 py-4 text-left font-semibold text-slate-600 dark:text-slate-300">Apertura</th>
                                <th className="px-6 py-4 text-left font-semibold text-slate-600 dark:text-slate-300">Cierre</th>
                                <th className="px-6 py-4 text-right font-semibold text-slate-600 dark:text-slate-300">Monto Inic.</th>
                                <th className="px-6 py-4 text-right font-semibold text-slate-600 dark:text-slate-300">Ventas</th>
                                <th className="px-6 py-4 text-right font-semibold text-slate-600 dark:text-slate-300">Monto Final</th>
                                <th className="px-6 py-4 text-center font-semibold text-slate-600 dark:text-slate-300">Estado</th>
                                <th className="px-6 py-4 text-right font-semibold text-slate-600 dark:text-slate-300">Acciones</th>
                            </tr>
                        </thead>
                        <tbody className="divide-y">
                            {isLoading ? (
                                Array.from({ length: 5 }).map((_, i) => (
                                    <tr key={i} className="animate-pulse">
                                        <td colSpan={8} className="px-6 py-4">
                                            <div className="h-4 bg-slate-100 dark:bg-slate-800 rounded w-full"></div>
                                        </td>
                                    </tr>
                                ))
                            ) : turnos.length === 0 ? (
                                <tr>
                                    <td colSpan={8} className="px-6 py-12 text-center text-muted-foreground">
                                        <div className="flex flex-col items-center gap-2">
                                            <LayoutList className="h-10 w-10 opacity-20" />
                                            <p>No se encontraron turnos con los filtros aplicados.</p>
                                        </div>
                                    </td>
                                </tr>
                            ) : (
                                turnos.map((turno: TurnoHistorialItem) => (
                                    <tr key={turno.id} className="hover:bg-slate-50/50 dark:hover:bg-slate-800/50 transition-colors">
                                        <td className="px-6 py-4">
                                            <div className="flex flex-col">
                                                <span className="font-bold text-slate-900 dark:text-white">{turno.nombreCaja}</span>
                                                <span className="text-xs text-muted-foreground">{turno.nombreVendedor || 'Vendedor #' + turno.usuarioVendedorId}</span>
                                            </div>
                                        </td>
                                        <td className="px-6 py-4">
                                            <div className="flex flex-col">
                                                <span className="text-slate-700 dark:text-slate-300">
                                                    {format(new Date(turno.fechaInicio), 'dd/MM/yyyy', { locale: es })}
                                                </span>
                                                <span className="text-xs text-muted-foreground">
                                                    {format(new Date(turno.fechaInicio), 'HH:mm:ss')}
                                                </span>
                                            </div>
                                        </td>
                                        <td className="px-6 py-4">
                                            {turno.fechaFin ? (
                                                <div className="flex flex-col">
                                                    <span className="text-slate-700 dark:text-slate-300">
                                                        {format(new Date(turno.fechaFin), 'dd/MM/yyyy', { locale: es })}
                                                    </span>
                                                    <span className="text-xs text-muted-foreground">
                                                        {format(new Date(turno.fechaFin), 'HH:mm:ss')}
                                                    </span>
                                                </div>
                                            ) : (
                                                <span className="text-xs italic text-muted-foreground">En curso...</span>
                                            )}
                                        </td>
                                        <td className="px-6 py-4 text-right font-medium">
                                            {formatCurrency(turno.montoApertura)}
                                        </td>
                                        <td className="px-6 py-4 text-right">
                                            <div className="flex flex-col items-end">
                                                <span className="font-semibold text-green-600 dark:text-green-400">
                                                    {formatCurrency(turno.totalVentas)}
                                                </span>
                                                <span className="text-[10px] uppercase font-bold text-muted-foreground">
                                                    {turno.cantidadTransacciones} Ops
                                                </span>
                                            </div>
                                        </td>
                                        <td className="px-6 py-4 text-right font-bold text-slate-900 dark:text-white">
                                            {turno.montoCierre !== null && turno.montoCierre !== undefined 
                                                ? formatCurrency(turno.montoCierre) 
                                                : '-'}
                                        </td>
                                        <td className="px-6 py-4 text-center">
                                            <Badge variant={turno.estado === 'ABIERTO' ? 'default' : 'secondary'} 
                                                   className={turno.estado === 'ABIERTO' 
                                                       ? 'bg-emerald-100 text-emerald-700 hover:bg-emerald-100 border-emerald-200' 
                                                       : 'bg-slate-100 text-slate-700 hover:bg-slate-100 border-slate-200'}>
                                                {turno.estado}
                                            </Badge>
                                        </td>
                                        <td className="px-6 py-4 text-right">
                                            <Button variant="ghost" size="icon" className="h-8 w-8 text-primary hover:text-primary hover:bg-primary/10">
                                                <Eye className="h-4 w-4" />
                                            </Button>
                                        </td>
                                    </tr>
                                ))
                            )}
                        </tbody>
                    </table>
                </div>

                {totalPages > 1 && (
                    <div className="px-6 py-4 bg-slate-50 dark:bg-slate-800/50 border-t flex items-center justify-between">
                        <p className="text-xs text-muted-foreground">
                            Mostrando <span className="font-semibold">{turnos.length}</span> de <span className="font-semibold">{total}</span> turnos
                        </p>
                        <div className="flex items-center gap-2">
                            <Button 
                                variant="outline" 
                                size="sm" 
                                onClick={() => setPagina(p => Math.max(1, p - 1))}
                                disabled={pagina === 1}
                            >
                                <ChevronLeft className="h-4 w-4" />
                            </Button>
                            <span className="text-xs font-medium">Página {pagina} de {totalPages}</span>
                            <Button 
                                variant="outline" 
                                size="sm" 
                                onClick={() => setPagina(p => Math.min(totalPages, p + 1))}
                                disabled={pagina === totalPages}
                            >
                                <ChevronRight className="h-4 w-4" />
                            </Button>
                        </div>
                    </div>
                )}
            </Card>
        </div>
    );
}
