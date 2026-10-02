// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HistorySummary _$HistorySummaryFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      '_HistorySummary',
      json,
      ($checkedConvert) {
        final val = _HistorySummary(
          workedCount: $checkedConvert(
            'worked_count',
            (v) => (v as num?)?.toInt() ?? 0,
          ),
          workedSince: $checkedConvert(
            'worked_since',
            (v) => _$JsonConverterFromJson<String, DateTime>(
              v,
              const DateOnlyConverter().fromJson,
            ),
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'workedCount': 'worked_count',
        'workedSince': 'worked_since',
      },
    );

Map<String, dynamic> _$HistorySummaryToJson(_HistorySummary instance) =>
    <String, dynamic>{
      'worked_count': instance.workedCount,
      'worked_since': _$JsonConverterToJson<String, DateTime>(
        instance.workedSince,
        const DateOnlyConverter().toJson,
      ),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
