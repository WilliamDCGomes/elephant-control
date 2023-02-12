// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'elephant_core.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ElephantCore _$ElephantCoreFromJson(Map<String, dynamic> json) => ElephantCore(
      id: json['id'] as String?,
      inclusion: json['inclusion'] == null
          ? null
          : DateTime.parse(json['inclusion'] as String),
      alteration: json['alteration'] == null
          ? null
          : DateTime.parse(json['alteration'] as String),
      active: ElephantCore.fromJsonActive(json['active']),
    );

Map<String, dynamic> _$ElephantCoreToJson(ElephantCore instance) =>
    <String, dynamic>{
      'id': instance.id,
      'inclusion': instance.inclusion?.toIso8601String(),
      'alteration': instance.alteration?.toIso8601String(),
      'active': instance.active,
    };
