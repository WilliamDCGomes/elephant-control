// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_media_h_viewcontroller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisitMediaHViewController _$VisitMediaHViewControllerFromJson(
        Map<String, dynamic> json) =>
    VisitMediaHViewController(
      media: json['media'] as String?,
      mediaId: json['mediaId'] as String?,
      type: $enumDecode(_$MediaTypeEnumMap, json['type']),
      visitId: json['visitId'] as String?,
      extension:
          $enumDecodeNullable(_$MediaExtensionEnumMap, json['extension']),
    )..incidentId = json['incidentId'] as String?;

Map<String, dynamic> _$VisitMediaHViewControllerToJson(
        VisitMediaHViewController instance) =>
    <String, dynamic>{
      'media': instance.media,
      'mediaId': instance.mediaId,
      'type': _$MediaTypeEnumMap[instance.type]!,
      'visitId': instance.visitId,
      'incidentId': instance.incidentId,
      'extension': _$MediaExtensionEnumMap[instance.extension],
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
