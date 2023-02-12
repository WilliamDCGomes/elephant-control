// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_media_viewcontroller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisitMediaViewController _$VisitMediaViewControllerFromJson(
        Map<String, dynamic> json) =>
    VisitMediaViewController(
      image: json['image'] as String,
      mediaType: $enumDecode(_$MediaTypeEnumMap, json['mediaType']),
      inclusion: DateTime.parse(json['inclusion'] as String),
    )..mediaId = json['mediaId'] as String;

Map<String, dynamic> _$VisitMediaViewControllerToJson(
        VisitMediaViewController instance) =>
    <String, dynamic>{
      'image': instance.image,
      'mediaId': instance.mediaId,
      'mediaType': _$MediaTypeEnumMap[instance.mediaType]!,
      'inclusion': instance.inclusion.toIso8601String(),
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
