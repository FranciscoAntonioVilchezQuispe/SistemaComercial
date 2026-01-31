export interface PagedRequest {
  pageNumber: number;
  pageSize: number;
  sortBy?: string;
  sortDirection?: "asc" | "desc";
  search?: string;
  activo?: boolean | null;
}

export interface PagedResponse<T> {
  datos: T[];
  total: number;
  pageNumber: number;
  pageSize: number;
  totalPages: number;
  hasPreviousPage: boolean;
  hasNextPage: boolean;
  status: number;
  message: string;
  transactionId: string;
}
