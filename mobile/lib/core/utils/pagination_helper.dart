import 'dart:math';

/// Generic immutable pagination metadata and helper model for paginated lists.
class PaginationState<T> {
  final List<T> items;
  final int currentPage;
  final int pageSize;
  final int totalItems;

  const PaginationState({
    this.items = const [],
    this.currentPage = 1,
    this.pageSize = 10,
    this.totalItems = 0,
  });

  /// Total number of pages available.
  int get totalPages {
    if (pageSize <= 0 || totalItems <= 0) return 0;
    return (totalItems / pageSize).ceil();
  }

  /// Whether more items are available on subsequent pages.
  bool get hasMore => currentPage < totalPages;

  /// Whether a next page exists.
  bool get hasNextPage => currentPage < totalPages;

  /// Whether a previous page exists.
  bool get hasPreviousPage => currentPage > 1;

  /// Index of the first item on current page (1-based).
  int get startItemIndex {
    if (totalItems == 0) return 0;
    return (currentPage - 1) * pageSize + 1;
  }

  /// Index of the last item on current page (1-based).
  int get endItemIndex {
    if (totalItems == 0) return 0;
    return min(currentPage * pageSize, totalItems);
  }

  PaginationState<T> copyWith({
    List<T>? items,
    int? currentPage,
    int? pageSize,
    int? totalItems,
  }) {
    return PaginationState<T>(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalItems: totalItems ?? this.totalItems,
    );
  }

  /// Slices an in-memory list into a paginated subset.
  static PaginationState<E> paginateList<E>(
    List<E> allItems, {
    int page = 1,
    int pageSize = 10,
  }) {
    if (allItems.isEmpty) {
      return PaginationState<E>(
        items: const [],
        currentPage: 1,
        pageSize: pageSize,
        totalItems: 0,
      );
    }

    final safePage = max(1, page);
    final safePageSize = max(1, pageSize);
    final startIndex = (safePage - 1) * safePageSize;

    if (startIndex >= allItems.length) {
      return PaginationState<E>(
        items: const [],
        currentPage: safePage,
        pageSize: safePageSize,
        totalItems: allItems.length,
      );
    }

    final endIndex = min(startIndex + safePageSize, allItems.length);
    final pageItems = allItems.sublist(startIndex, endIndex);

    return PaginationState<E>(
      items: pageItems,
      currentPage: safePage,
      pageSize: safePageSize,
      totalItems: allItems.length,
    );
  }
}

