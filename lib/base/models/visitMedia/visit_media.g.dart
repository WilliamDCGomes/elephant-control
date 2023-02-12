// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisitMedia _$VisitMediaFromJson(Map<String, dynamic> json) => VisitMedia(
      type: $enumDecode(_$MediaTypeEnumMap, json['type']),
      visitId: json['visitId'] as String,
      media: json['media'] as String,
      extension: $enumDecode(_$MediaExtensionEnumMap, json['extension']),
      id: json['id'] as String?,
      inclusion: json['inclusion'] == null
          ? null
          : DateTime.parse(json['inclusion'] as String),
      alteration: json['alteration'] == null
          ? null
          : DateTime.parse(json['alteration'] as String),
      sent: json['sent'] == null ? true : VisitMedia.fromJsonSent(json['sent']),
      mediaId: json['mediaId'] as String?,
    )
      ..active = ElephantCore.fromJsonActive(json['active'])
      ..includeUserId = json['includeUserId'] as String?;

Map<String, dynamic> _$VisitMediaToJson(VisitMedia instance) =>
    <String, dynamic>{
      'id': instance.id,
      'inclusion': instance.inclusion?.toIso8601String(),
      'alteration': instance.alteration?.toIso8601String(),
      'active': instance.active,
      'includeUserId': instance.includeUserId,
      'type': _$MediaTypeEnumMap[instance.type]!,
      'visitId': instance.visitId,
      'extension': _$MediaExtensionEnumMap[instance.extension]!,
      'media': instance.media,
      'mediaId': instance.mediaId,
      'sent': instance.sent,
    };

const _$MediaTypeEnumMap = {
  MediaType.stuffedAnimals: 0,
  MediaType.moneyWatch: 1,
  MediaType.machineBefore: 2,
  MediaType.machineAfter: 3,
  MediaType.firstOccurrencePicture: 4,
  MediaType.secondOccurrencePicture: 5,
  MediaType.occurrenceVideo: 6,
};

const _$MediaExtensionEnumMap = {
  MediaExtension.jpg: 0,
  MediaExtension.jpeg: 1,
  MediaExtension.png: 2,
  MediaExtension.pdf: 3,
  MediaExtension.mp4: 4,
};
