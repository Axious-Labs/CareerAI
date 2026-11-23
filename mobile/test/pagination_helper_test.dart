import 'package:flutter_test/flutter_test.dart';
import 'package:careerai_mobile/core/utils/pagination_helper.dart';

void main() {
  group('PaginationState Unit Tests', () {
    test('totalPages and navigation flags calculate accurately', () {
      const page1 = PaginationState<String>(
        items: ['a', 'b', 'c'],
        currentPage: 1,
        pageSize: 3,
        totalItems: 10,
      );

      expect(page1.totalPages, 4);
      expect(page1.hasMore, isTrue);
      expect(page1.hasNextPage, isTrue);
      expect(page1.hasPreviousPage, isFalse);
      expect(page1.startItemIndex, 1);
      expect(page1.endItemIndex, 3);

      final page4 = page1.copyWith(currentPage: 4);
      expect(page4.hasMore, isFalse);
      expect(page4.hasNextPage, isFalse);
      expect(page4.hasPreviousPage, isTrue);
      expect(page4.startItemIndex, 10);
      expect(page4.endItemIndex, 10);
    });

    test('zero total items handles edge cases cleanly', () {
      const emptyPage = PaginationState<int>(
        items: [],
        currentPage: 1,
        pageSize: 10,
        totalItems: 0,
      );

      expect(emptyPage.totalPages, 0);
      expect(emptyPage.hasMore, isFalse);
      expect(emptyPage.startItemIndex, 0);
      expect(emptyPage.endItemIndex, 0);
    });

    test('paginateList subsets list for valid page range', () {
      final fullList = List.generate(25, (i) => 'Item $i');

      final page1 = PaginationState.paginateList(fullList, page: 1, pageSize: 10);
      expect(page1.items.length, 10);
      expect(page1.items.first, 'Item 0');
      expect(page1.items.last, 'Item 9');
      expect(page1.totalItems, 25);
      expect(page1.totalPages, 3);

      final page3 = PaginationState.paginateList(fullList, page: 3, pageSize: 10);
      expect(page3.items.length, 5);
      expect(page3.items.first, 'Item 20');
      expect(page3.items.last, 'Item 24');

      final outOfBounds = PaginationState.paginateList(fullList, page: 10, pageSize: 10);
      expect(outOfBounds.items, isEmpty);
      expect(outOfBounds.totalItems, 25);
    });

    test('paginateList handles empty list gracefully', () {
      final emptyResult = PaginationState.paginateList<String>([], page: 1, pageSize: 10);
      expect(emptyResult.items, isEmpty);
      expect(emptyResult.totalItems, 0);
      expect(emptyResult.totalPages, 0);
    });
  });
}

