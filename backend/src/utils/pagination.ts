/**
 * Standard Pagination Utilities
 * Provides reusable helpers for offset, cursor, and metadata calculation across list endpoints.
 */

export interface PaginationParams {
  page: number;
  limit: number;
}

export interface PaginationMeta {
  page: number;
  limit: number;
  totalItems: number;
  totalPages: number;
  hasNextPage: boolean;
  hasPreviousPage: boolean;
}

export interface PaginatedResult<T> {
  items: T[];
  meta: PaginationMeta;
}

export class PaginationHelper {
  private static readonly DEFAULT_PAGE = 1;
  private static readonly DEFAULT_LIMIT = 10;
  private static readonly MAX_LIMIT = 100;

  /**
   * Parse query parameters into sanitized numeric page and limit values
   */
  static parseParams(query: { page?: unknown; limit?: unknown }): PaginationParams {
    const rawPage = parseInt(String(query.page), 10);
    const rawLimit = parseInt(String(query.limit), 10);

    const page = !isNaN(rawPage) && rawPage > 0 ? rawPage : PaginationHelper.DEFAULT_PAGE;
    let limit = !isNaN(rawLimit) && rawLimit > 0 ? rawLimit : PaginationHelper.DEFAULT_LIMIT;
    if (limit > PaginationHelper.MAX_LIMIT) {
      limit = PaginationHelper.MAX_LIMIT;
    }

    return { page, limit };
  }

  /**
   * Calculate pagination metadata based on total items
   */
  static computeMeta(totalItems: number, page: number, limit: number): PaginationMeta {
    const totalPages = Math.max(1, Math.ceil(totalItems / limit));
    return {
      page,
      limit,
      totalItems,
      totalPages,
      hasNextPage: page < totalPages,
      hasPreviousPage: page > 1,
    };
  }

  /**
   * Paginate an in-memory array with metadata
   */
  static paginateArray<T>(items: T[], page: number, limit: number): PaginatedResult<T> {
    const safePage = Math.max(1, page);
    const safeLimit = Math.max(1, limit);
    const offset = (safePage - 1) * safeLimit;
    const paginatedItems = items.slice(offset, offset + safeLimit);
    const meta = PaginationHelper.computeMeta(items.length, safePage, safeLimit);

    return {
      items: paginatedItems,
      meta,
    };
  }
}

