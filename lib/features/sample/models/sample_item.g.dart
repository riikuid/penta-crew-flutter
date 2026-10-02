// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sample_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SampleItem _$SampleItemFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_SampleItem', json, ($checkedConvert) {
      final val = _SampleItem(
        id: $checkedConvert('id', (v) => (v as num).toInt()),
        title: $checkedConvert('title', (v) => v as String),
        description: $checkedConvert('description', (v) => v as String?),
        createdAt: $checkedConvert(
          'created_at',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        category: $checkedConvert(
          'category',
          (v) => v == null
              ? null
              : SampleCategory.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    }, fieldKeyMap: const {'createdAt': 'created_at'});

Map<String, dynamic> _$SampleItemToJson(_SampleItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'created_at': instance.createdAt?.toIso8601String(),
      'category': instance.category?.toJson(),
    };
