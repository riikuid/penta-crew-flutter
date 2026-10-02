// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sample_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SampleCategory _$SampleCategoryFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_SampleCategory', json, ($checkedConvert) {
      final val = _SampleCategory(
        id: $checkedConvert('id', (v) => (v as num).toInt()),
        name: $checkedConvert('name', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$SampleCategoryToJson(_SampleCategory instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
