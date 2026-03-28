import { apiConfiguracion } from "@/lib/axios";

export interface UbigeoItem {
    codigo: string;
    nombre: string;
}

export interface UbigeoDetalle {
    codigo: string;
    distrito: string;
    codigoProvincia: string;
    provincia: string;
    codigoDepartamento: string;
    departamento: string;
    textoCompleto: string;
}

export interface UbigeoSearchResult {
    codigo: string;
    nombre: string;
    provincia: string;
    departamento: string;
    textoCompleto: string;
}

export const servicioUbigeo = {
    getDepartamentos: async () => {
        const response: any = await apiConfiguracion.get("/ubigeo/departamentos");
        return response.datos || response.data || [];
    },

    getProvincias: async (codigoDept: string) => {
        const response: any = await apiConfiguracion.get(`/ubigeo/provincias?dept=${codigoDept}`);
        return response.datos || response.data || [];
    },

    getDistritos: async (codigoProv: string) => {
        const response: any = await apiConfiguracion.get(`/ubigeo/distritos?prov=${codigoProv}`);
        return response.datos || response.data || [];
    },

    getDetalle: async (codigo6: string) => {
        const response: any = await apiConfiguracion.get(`/ubigeo/detalle/${codigo6}`);
        return response.data || response.datos || response;
    },

    search: async (q: string, limit: number = 15) => {
        const response: any = await apiConfiguracion.get(`/ubigeo/search?q=${q}&limit=${limit}`);
        return response.datos || response.data || [];
    }
};
