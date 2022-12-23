// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incident_media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IncidentMedia _$IncidentMediaFromJson(Map<String, dynamic> json) =>
    IncidentMedia(
      incidentId: json['incidentId'] as String,
      type: $enumDecode(_$MediaTypeEnumMap, json['type']),
      mediaId: json['mediaId'] as String,
    )
      ..id = json['id'] as String?
      ..inclusion = json['inclusion'] == null
          ? null
          : DateTime.parse(json['inclusion'] as String)
      ..alteration = json['alteration'] == null
          ? null
          : DateTime.parse(json['alteration'] as String)
      ..active = json['active'] as bool?;

Map<String, dynamic> _$IncidentMediaToJson(IncidentMedia instance) =>
    <String, dynamic>{
      'id': instance.id,
      'inclusion': instance.inclusion?.toIso8601String(),
      'alteration': instance.alteration?.toIso8601String(),
      'active': instance.active,
      'incidentId': instance.incidentId,
      'type': _$MediaTypeEnumMap[instance.type]!,
      'mediaId': instance.mediaId,
    };

const _$MediaTypeEnumMap = {
  MediaType.stuffedAnimals: 0,
  MediaType.moneyWatch: 1,
  MediaType.machine: 2,
};
