import { useDispatch, useSelector, useStore } from "react-redux";
import type { RootState, AppDispatch } from "./store";

// Hooks tipados para usar en toda la aplicación
export const useAppDispatch = useDispatch.withTypes<AppDispatch>();
export const useAppSelector = useSelector.withTypes<RootState>();
export const useAppStore = useStore.withTypes<typeof import("./store").store>();
