import axios from 'axios';
import { apiGatewayURL } from '@/compartido/configuracion/entorno.config';
import type { CajaListItem, MovimientoCajaDetalle } from '../tipos/ventas.types';

const getHeaders = () => ({
    'Authorization': `Bearer ${localStorage.getItem('sc_token')}`
});

export const servicioCajas = {
    obtenerTodas: async (): Promise<CajaListItem[]> => {
        const response = await axios.get<{ data: CajaListItem[] }>(`${apiGatewayURL}/api/cajas`, {
            headers: getHeaders()
        });
        // El endpoint actual devuelve ToReturnList<Caja> que tiene propiedad 'data'
        return response.data.data ?? [];
    },

    crear: async (data: { nombreCaja: string; idAlmacen: number }): Promise<CajaListItem> => {
        const response = await axios.post<CajaListItem>(`${apiGatewayURL}/api/cajas`, data, {
            headers: getHeaders()
        });
        return response.data;
    },

    actualizar: async (id: number, data: { nombreCaja: string; idAlmacen: number }): Promise<CajaListItem> => {
        const response = await axios.put<CajaListItem>(`${apiGatewayURL}/api/cajas/${id}`, data, {
            headers: getHeaders()
        });
        return response.data;
    },

    cambiarEstado: async (id: number, activado: boolean): Promise<void> => {
        await axios.patch(`${apiGatewayURL}/api/cajas/${id}/estado`, { activado }, {
            headers: getHeaders()
        });
    },

    registrarMovimiento: async (cajaId: number, data: {
        idTurnoVendedor?: number;
        idTipoMovimiento: number;
        monto: number; // positivo = ingreso, negativo = egreso
        concepto: string;
    }): Promise<MovimientoCajaDetalle> => {
        const response = await axios.post<MovimientoCajaDetalle>(
            `${apiGatewayURL}/api/cajas/${cajaId}/movimientos`,
            data,
            { headers: getHeaders() }
        );
        return response.data;
    },

    obtenerMovimientosTurno: async (cajaId: number, turnoId: number): Promise<MovimientoCajaDetalle[]> => {
        const response = await axios.get<MovimientoCajaDetalle[]>(
            `${apiGatewayURL}/api/cajas/${cajaId}/movimientos`,
            { params: { turnoId }, headers: getHeaders() }
        );
        return response.data ?? [];
    }
};
