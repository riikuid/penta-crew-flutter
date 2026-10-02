/// One page of a Laravel paginator.
///
/// Accepts both shapes Laravel produces:
/// - Resource collection: `{ "data": [...], "meta": { "current_page", "last_page", "total" } }`
/// - Plain `->paginate()`: `{ "data": [...], "current_page", "last_page", "total" }`
///
/// Hand-written on purpose: a generic freezed class would need
/// `genericArgumentFactories` boilerplate in every model for no gain.
///
/// ```dart
/// parse: (body) => Paginated.fromJson(body, SampleItem.fromJson),
/// ```
class Paginated<T> {
  const Paginated({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.total,
    this.meta = const {},
  });

  factory Paginated.fromJson(
    dynamic body,
    T Function(Map<String, dynamic> json) fromJsonT,
  ) {
    if (body is! Map) {
      throw FormatException('Expected a paginator object, got ${body.runtimeType}');
    }
    final raw = body['data'];
    if (raw is! List) {
      throw FormatException('Expected "data" to be a list, got ${raw.runtimeType}');
    }
    final meta = body['meta'] is Map ? body['meta'] as Map : body;
    final items = raw
        .map((e) => fromJsonT(Map<String, dynamic>.from(e as Map)))
        .toList();

    return Paginated(
      data: items,
      currentPage: _asInt(meta['current_page']) ?? 1,
      lastPage: _asInt(meta['last_page']) ?? 1,
      total: _asInt(meta['total']) ?? items.length,
      meta: Map<String, dynamic>.from(meta)..remove('data'),
    );
  }

  final List<T> data;
  final int currentPage;
  final int lastPage;
  final int total;

  /// Raw paginator meta, so endpoints can carry extras next to the page
  /// numbers (`meta.summary` on history, `meta.unread_count` on notifications).
  final Map<String, dynamic> meta;

  bool get hasMore => currentPage < lastPage;
  bool get isEmpty => data.isEmpty;

  @override
  String toString() =>
      'Paginated(${data.length} items, page $currentPage/$lastPage, total $total)';
}

int? _asInt(Object? value) => switch (value) {
  final int i => i,
  final num n => n.toInt(),
  final String s => int.tryParse(s),
  _ => null,
};
