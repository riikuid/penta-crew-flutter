import 'package:flutter_test/flutter_test.dart';
import 'package:penta_crew/core/network/paginated.dart';

void main() {
  int parseId(Map<String, dynamic> json) => json['id'] as int;

  test('parses resource-collection shape (meta)', () {
    final page = Paginated.fromJson({
      'data': [
        {'id': 1},
        {'id': 2},
      ],
      'meta': {'current_page': 1, 'last_page': 3, 'total': 6},
    }, parseId);

    expect(page.data, [1, 2]);
    expect(page.currentPage, 1);
    expect(page.lastPage, 3);
    expect(page.total, 6);
    expect(page.hasMore, isTrue);
  });

  test('parses plain paginate() shape (top-level, string numbers)', () {
    final page = Paginated.fromJson({
      'data': [
        {'id': 7},
      ],
      'current_page': '2',
      'last_page': '2',
      'total': '3',
    }, parseId);

    expect(page.data, [7]);
    expect(page.currentPage, 2);
    expect(page.lastPage, 2);
    expect(page.hasMore, isFalse);
  });

  test('exposes raw meta extras (summary, unread_count) without "data"', () {
    final page = Paginated.fromJson({
      'data': [{'id': 1}],
      'meta': {
        'current_page': 1,
        'last_page': 1,
        'total': 1,
        'summary': {'worked_count': 6, 'worked_since': '2026-07-01'},
      },
    }, parseId);

    expect(page.meta['summary'], {'worked_count': 6, 'worked_since': '2026-07-01'});
    expect(page.meta.containsKey('data'), isFalse);

    final plain = Paginated.fromJson({
      'data': [{'id': 1}],
      'current_page': 1,
      'last_page': 1,
      'total': 1,
      'unread_count': 3,
    }, parseId);
    expect(plain.meta['unread_count'], 3);
    expect(plain.meta.containsKey('data'), isFalse);
  });

  test('throws FormatException on a non-paginator body', () {
    expect(() => Paginated.fromJson([1, 2], parseId), throwsFormatException);
    expect(
      () => Paginated.fromJson({'data': 'nope'}, parseId),
      throwsFormatException,
    );
  });
}
