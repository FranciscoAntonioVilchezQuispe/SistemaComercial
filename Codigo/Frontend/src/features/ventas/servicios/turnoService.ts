import axios from 'axios';
import { apiGatewayURL } from '@/compartido/configuracion/entorno.config';
import type { TurnoResumenPrevio, TurnoHistorialItem } from '../tipos/ventas.types';

export interface TurnoVendedorDto {
    id: number;
    usuarioVendedorId: number;
    cajaId: number;
    fechaInicio: string;
    fechaFin?: string;
    montoApertura: number;
    montoCierre?: number;
    estado: string;
}

export interface CierreTurnoDto {
    id: number;
    turnoVendedorId: number;
    fechaGeneracion: string;
    totalVentas: number;
    totalEfectivo: number;
    totalTarjeta: number;
    totalTransferencia: number;
    totalOtros: number;
    cantidadTransacciones: number;
    observaciones?: string;
    estado: string;
    // Nuevos campos de arqueo:
    totalIngresosManualles: number;
    totalEgresosManualles: number;
    montoEsperado: number;
    montoFisicoContado: number;
    diferenciaArqueo: number;
}

export const turnoService = {
    obtenerTurnoActual: async (): Promise<TurnoVendedorDto | null> => {
        try {
            const token = localStorage.getItem('sc_token');
            const response = await axios.get<TurnoVendedorDto>(`${apiGatewayURL}/api/turnos/actual`, {
                headers: { 'Authorization': `Bearer ${token}` }
            });
            return response.data;
        } catch (error: any) {
            if (error.response?.status === 404) return null;
            throw error;
        }
    },

    abrirTurno: async (cajaId: number, montoApertura: number): Promise<TurnoVendedorDto> => {
        const token = localStorage.getItem('sc_token');
        const response = await axios.post<TurnoVendedorDto>(`${apiGatewayURL}/api/turnos/abrir`, 
            { cajaId, montoApertura },
            { headers: { 'Authorization': `Bearer ${token}` } }
        );
        return response.data;
    },

    cerrarTurno: async (turnoVendedorId: number, montoFisicoContado: number, observaciones?: string): Promise<CierreTurnoDto> => {
        const token = localStorage.getItem('sc_token');
        const response = await axios.post<CierreTurnoDto>(`${apiGatewayURL}/api/turnos/cerrar`, 
            { turnoVendedorId, montoFisicoContado, observaciones },
            { headers: { 'Authorization': `Bearer ${token}` } }
        );
        return response.data;
    },

    obtenerResumenPrevioCierre: async (turnoId: number): Promise<TurnoResumenPrevio> => {
        const token = localStorage.getItem('sc_token');
        const response = await axios.get<TurnoResumenPrevio>(
            `${apiGatewayURL}/api/turnos/resumen-previo/${turnoId}`,
            { headers: { 'Authorization': `Bearer ${token}` } }
        );
        return response.data;
    },

    obtenerHistorialTurnos: async (params: {
        pageNumber?: number;
        pageSize?: number;
        cajaId?: number;
        estado?: string;
        fechaDesde?: string;
        fechaHasta?: string;
    }): Promise<{ datos: TurnoHistorialItem[]; total: number; totalPages: number }> => {
        const token = localStorage.getItem('sc_token');
        const response = await axios.get(`${apiGatewayURL}/api/turnos/historial`, {
            params,
            headers: { 'Authorization': `Bearer ${token}` }
        });
        return response.data;
    }
};
