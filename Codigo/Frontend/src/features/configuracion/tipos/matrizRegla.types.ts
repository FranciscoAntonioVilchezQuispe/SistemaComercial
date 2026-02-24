import { TipoComprobante } from "./tipoComprobante.types";
import { TipoOperacionSunat } from "./tipoOperacion.types";

export interface MatrizReglaSunat {
  id: number;
  idTipoOperacion: number;
  idTipoComprobante: number;
  nivelObligatoriedad: number; // 0=N/A, 1=Principal, 2=Complementario
  activo: boolean;
  // Navegación
  tipoOperacion?: TipoOperacionSunat;
  tipoComprobante?: TipoComprobante;
}

export type MatrizReglaSunatFormData = Omit<
  MatrizReglaSunat,
  "id" | "tipoOperacion" | "tipoComprobante"
>;

export const NIVEL_OBLIGATORIEDAD: Record<number, string> = {
  0: "No Aplica",
  1: "Principal",
  2: "Complementario",
};
