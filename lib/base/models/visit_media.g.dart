// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisitMedia _$VisitMediaFromJson(Map<String, dynamic> json) => VisitMedia(
      base64: json['base64'] as String?,
      mediaId: json['mediaId'] as String?,
      type: $enumDecode(_$MediaTypeEnumMap, json['type']),
      visitId: json['visitId'] as String?,
      extension:
          $enumDecodeNullable(_$MediaExtensionEnumMap, json['extension']),
    )
      ..id = json['id'] as String?
      ..inclusion = json['inclusion'] == null
          ? null
          : DateTime.parse(json['inclusion'] as String)
      ..alteration = json['alteration'] == null
          ? null
          : DateTime.parse(json['alteration'] as String)
      ..active = json['active'] as bool?
      ..incidentId = json['incidentId'] as String?;

Map<String, dynamic> _$VisitMediaToJson(VisitMedia instance) =>
    <String, dynamic>{
      'id': instance.id,
      'inclusion': instance.inclusion?.toIso8601String(),
      'alteration': instance.alteration?.toIso8601String(),
      'active': instance.active,
      'base64': instance.base64,
      'mediaId': instance.mediaId,
      'type': _$MediaTypeEnumMap[instance.type]!,
      'visitId': instance.visitId,
      'incidentId': instance.incidentId,
      'extension': _$MediaExtensionEnumMap[instance.extension],
    };

const _$MediaTypeEnumMap = {
  MediaType.stuffedAnimals: 0,
  MediaType.moneyWatch: 1,
  MediaType.machine: 2,
};

const _$MediaExtensionEnumMap = {
  MediaExtension.jpg: 0,
  MediaExtension.jpeg: 1,
  MediaExtension.png: 2,
  MediaExtension.pdf: 3,
  MediaExtension.mp4: 4,
};
