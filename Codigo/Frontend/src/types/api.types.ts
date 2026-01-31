export interface ToReturn<T> {
  success: boolean;
  message: string;
  data: T;
  statusCode: number;
}

export interface ToReturnList<T> {
  success: boolean;
  message: string;
  data: T[];
  totalRecords: number;
  statusCode: number;
}

export interface ToReturnError<T = null> {
  success: boolean;
  message: string;
  errors?: string[];
  data: T | null;
  statusCode: number;
}
