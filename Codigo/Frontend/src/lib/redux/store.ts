import { configureStore } from "@reduxjs/toolkit";

// Importar reducers aquí cuando estén creados
// import autenticacionReducer from '@features/autenticacion/store/autenticacionSlice';
// import productoReducer from '@features/catalogo/store/productoSlice';

export const store = configureStore({
  reducer: {
    // Agregar reducers aquí
    // autenticacion: autenticacionReducer,
    // producto: productoReducer,
  },
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware({
      serializableCheck: {
        // Ignorar estas rutas de acción para checks de serialización
        ignoredActions: ["persist/PERSIST"],
      },
    }),
});

// Tipos inferidos del store
export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;
