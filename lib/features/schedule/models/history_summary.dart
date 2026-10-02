import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/json/converters.dart';

part 'history_summary.freezed.dart';
part 'history_summary.g.dart';

/// `meta.summary` of `GET /schedule/history` (contract §5.2): the "06 events
/// worked since Jul 2026" counter on D2 and the Worked tile on B1.
@freezed
abstract class HistorySummary with _$HistorySummary {
  const factory HistorySummary({
    @Default(0) int workedCount,
    @DateOnlyConverter() DateTime? workedSince,
  }) = _HistorySummary;

  factory HistorySummary.fromJson(Map<String, dynamic> json) =>
      _$HistorySummaryFromJson(json);

  /// Reads the summary out of a paginator's raw `meta`; empty when absent.
  factory HistorySummary.fromMeta(Map<String, dynamic> meta) {
    final raw = meta['summary'];
    if (raw is Map) return HistorySummary.fromJson(Map<String, dynamic>.from(raw));
    return const HistorySummary();
  }
}
