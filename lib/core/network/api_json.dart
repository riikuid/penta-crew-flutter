/// Helpers for the usual Laravel envelope: `{ "message": "...", "data": ... }`.
/// Use inside `dioCall(parse: ...)`.
library;

/// `body['data']` when present, otherwise the body itself.
dynamic unwrapData(dynamic body) =>
    body is Map && body.containsKey('data') ? body['data'] : body;

/// Body (or its `data`) as a JSON object. Throws a clear error otherwise, which
/// `dioCall` turns into a `Failed`.
Map<String, dynamic> asObject(dynamic body) {
  final data = unwrapData(body);
  if (data is Map<String, dynamic>) return data;
  if (data is Map) return Map<String, dynamic>.from(data);
  throw FormatException('Expected a JSON object, got ${data.runtimeType}');
}

/// Body (or its `data`) as a list of JSON objects.
List<Map<String, dynamic>> asList(dynamic body) {
  final data = unwrapData(body);
  if (data is! List) {
    throw FormatException('Expected a JSON array, got ${data.runtimeType}');
  }
  return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
}
