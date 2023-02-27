// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_money_pouch_viewcontroller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddMoneyPouchViewController _$AddMoneyPouchViewControllerFromJson(
        Map<String, dynamic> json) =>
    AddMoneyPouchViewController(
      userOperatorId: json['userOperatorId'] as String?,
      code: json['code'] as int,
      observation: json['observation'] as String?,
      visitId: json['visitId'] as String,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
    );

Map<String, dynamic> _$AddMoneyPouchViewControllerToJson(
        AddMoneyPouchViewController instance) =>
    <String, dynamic>{
      'userOperatorId': instance.userOperatorId,
      'code': instance.code,
      'observation': instance.observation,
      'visitId': instance.visitId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
