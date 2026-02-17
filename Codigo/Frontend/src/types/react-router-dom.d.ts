import "react-router-dom";
import "@remix-run/router";

declare module "@remix-run/router" {
  export interface FutureConfig {
    v7_startTransition?: boolean;
    v7_relativeSplatPath?: boolean;
    v7_fetcherPersist?: boolean;
    v7_normalizeFormMethod?: boolean;
    v7_partialHydration?: boolean;
    v7_skipActionErrorRevalidation?: boolean;
  }
}

declare module "react-router-dom" {
  export interface FutureConfig {
    v7_startTransition?: boolean;
    v7_relativeSplatPath?: boolean;
    v7_fetcherPersist?: boolean;
    v7_normalizeFormMethod?: boolean;
    v7_partialHydration?: boolean;
    v7_skipActionErrorRevalidation?: boolean;
  }
}
