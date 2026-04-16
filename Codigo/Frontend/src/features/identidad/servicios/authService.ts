import axios from 'axios';
import { apiGatewayURL } from '@/compartido/configuracion/entorno.config';

export interface LoginComando {
    username: string;
    password: string;
}

export interface UsuarioInfo {
    id: number;
    username: string;
    nombres: string;
    apellidos: string;
    email: string;
    roles: string;
}

export interface LoginRespuesta {
    token: string;
    refreshToken: string;
    usuario: UsuarioInfo;
}

// Wrapper que devuelve el backend (IToReturn<T>)
interface ApiWrapper<T> {
    data: T;
    status: number;
    message: string;
    transactionId: string;
}

export const authService = {
    login: async (comando: LoginComando): Promise<LoginRespuesta> => {
        const response = await axios.post<ApiWrapper<LoginRespuesta>>(`${apiGatewayURL}/api/auth/login`, comando);
        const respuesta = response.data?.data;
        if (respuesta?.token) {
            localStorage.setItem('sc_token', respuesta.token);
            localStorage.setItem('sc_refresh', respuesta.refreshToken);
        }
        return respuesta;
    },

    refresh: async (refreshToken: string): Promise<LoginRespuesta> => {
        const response = await axios.post<ApiWrapper<LoginRespuesta>>(`${apiGatewayURL}/api/auth/refresh`, { refreshToken });
        const respuesta = response.data?.data;
        if (respuesta?.token) {
            localStorage.setItem('sc_token', respuesta.token);
            localStorage.setItem('sc_refresh', respuesta.refreshToken);
        }
        return respuesta;
    },

    logout: () => {
        localStorage.removeItem('sc_token');
        localStorage.removeItem('sc_refresh');
    },
    
    getToken: () => localStorage.getItem('sc_token'),
    getRefreshToken: () => localStorage.getItem('sc_refresh')
};
