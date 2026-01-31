import { createSlice, PayloadAction } from "@reduxjs/toolkit";
import { Producto } from "../tipos/catalogo.types";

export interface ProductoState {
  lista: Producto[];
  seleccionado: Producto | null;
  cargando: boolean;
  error: string | null;
}

const initialState: ProductoState = {
  lista: [],
  seleccionado: null,
  cargando: false,
  error: null,
};

const productoSlice = createSlice({
  name: "productos",
  initialState,
  reducers: {
    setProductos: (state, action: PayloadAction<Producto[]>) => {
      state.lista = action.payload;
    },
    setCargando: (state, action: PayloadAction<boolean>) => {
      state.cargando = action.payload;
    },
    // más reducers
  },
});

export const { setProductos, setCargando } = productoSlice.actions;
export default productoSlice.reducer;
