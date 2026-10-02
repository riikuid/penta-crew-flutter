import 'package:json_annotation/json_annotation.dart';

/// `2024-01-05` ↔ `DateTime`. Default json_serializable uses full ISO-8601,
/// which Laravel `date` columns do not want back.
///
/// ```dart
/// @DateOnlyConverter() DateTime? dateOfEntry,
/// ```
class DateOnlyConverter implements JsonConverter<DateTime, String> {
  const DateOnlyConverter();

  @override
  DateTime fromJson(String json) => DateTime.parse(json);

  @override
  String toJson(DateTime object) {
    final y = object.year.toString().padLeft(4, '0');
    final m = object.month.toString().padLeft(2, '0');
    final d = object.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}

/// Laravel booleans often arrive as `0`/`1` or `"0"`/`"1"`.
///
/// ```dart
/// @BoolIntConverter() @Default(false) bool isActive,
/// ```
class BoolIntConverter implements JsonConverter<bool, Object?> {
  const BoolIntConverter();

  @override
  bool fromJson(Object? json) => switch (json) {
    final bool b => b,
    final num n => n != 0,
    final String s => s == '1' || s.toLowerCase() == 'true',
    _ => false,
  };

  @override
  Object toJson(bool object) => object ? 1 : 0;
}

/// Numbers that the API sometimes sends as strings (`"12.50"`).
class NumFromStringConverter implements JsonConverter<num?, Object?> {
  const NumFromStringConverter();

  @override
  num? fromJson(Object? json) => switch (json) {
    final num n => n,
    final String s => num.tryParse(s),
    _ => null,
  };

  @override
  Object? toJson(num? object) => object;
}
