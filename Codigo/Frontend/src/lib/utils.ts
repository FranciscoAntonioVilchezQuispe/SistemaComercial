import { type ClassValue, clsx } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

export function formatCurrency(value: number, currency: string = 'S/'): string {
  const numericValue = typeof value === 'number' ? value : Number(value);
  return new Intl.NumberFormat('es-PE', {
    style: 'currency',
    currency: currency === 'S/' ? 'PEN' : currency,
    minimumFractionDigits: 2
  }).format(numericValue).replace('PEN', 'S/');
}

export function formatDate(date: string | Date): string {
  if (!date) return '-';
  const d = typeof date === 'string' ? new Date(date) : date;
  return new Intl.DateTimeFormat('es-PE').format(d);
}
