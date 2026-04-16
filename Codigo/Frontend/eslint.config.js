import js from "@eslint/js";
import tseslint from "typescript-eslint";
import reactHooks from "eslint-plugin-react-hooks";
import reactRefresh from "eslint-plugin-react-refresh";
import globals from "globals";

export default tseslint.config(
  { ignores: ["dist", "node_modules", "eslint.config.js"] },
  {
    extends: [js.configs.recommended, ...tseslint.configs.recommended],
    files: ["**/*.{ts,tsx}"],
    languageOptions: {
      ecmaVersion: 2020,
      globals: {
        ...globals.browser,
        ...globals.es2020,
      },
    },
    plugins: {
      "react-hooks": reactHooks,
      "react-refresh": reactRefresh,
    },
    rules: {
      ...reactHooks.configs.recommended.rules,
      "react-refresh/only-export-components": [
        "warn",
        { allowConstantExport: true },
      ],
      "no-restricted-syntax": [
        "error",
        {
          selector: "NewExpression[callee.name='Date'][arguments.length=0]",
          message: 'No usar "new Date()". Usar getCurrentDateTime() de "@/lib/datetime" para asegurar consistencia con la zona horaria de Lima (UTC-5).',
        },
        {
          selector: "CallExpression[callee.property.name='toISOString']",
          message: 'Evitar toISOString() directo. Usar formatDateForAPI() o formatDateTimeForAPI() de "@/lib/datetime" para asegurar el formato y zona horaria correcta.',
        },
      ],
    },
  }
);
