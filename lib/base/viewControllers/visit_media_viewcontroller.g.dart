// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_media_viewcontroller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisitMediaViewController _$VisitMediaViewControllerFromJson(
        Map<String, dynamic> json) =>
    VisitMediaViewController(
      image: json['image'] as String,
      visitType: $enumDecode(_$MediaTypeEnumMap, json['visitType']),
      inclusion: DateTime.parse(json['inclusion'] as String),
    );

Map<String, dynamic> _$VisitMediaViewControllerToJson(
        VisitMediaViewController instance) =>
    <String, dynamic>{
      'image': instance.image,
      'visitType': _$MediaTypeEnumMap[instance.visitType]!,
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
