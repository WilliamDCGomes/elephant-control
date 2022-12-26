// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../model/visit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Visit _$VisitFromJson(Map<String, dynamic> json) => Visit(
      addedProducts: json['addedProducts'] as int,
      moneyQuantity: (json['moneyQuantity'] as num).toDouble(),
      moneyWithdrawalQuantity:
          (json['moneyWithdrawalQuantity'] as num?)?.toDouble(),
      stuffedAnimalsQuantity: json['stuffedAnimalsQuantity'] as int,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      status: $enumDecode(_$VisitStatusEnumMap, json['status']),
      machineId: json['machineId'] as String,
      moneyWithdrawal: json['moneyWithdrawal'] as bool,
      code: json['code'] as int?,
      observation: json['observation'] as String?,
    )
      ..id = json['id'] as String?
      ..inclusion = json['inclusion'] == null
          ? null
          : DateTime.parse(json['inclusion'] as String)
      ..alteration = json['alteration'] == null
          ? null
          : DateTime.parse(json['alteration'] as String)
      ..active = json['active'] as bool?
      ..moneyPouch = json['moneyPouch'] == null
          ? null
          : MoneyPouch.fromJson(json['moneyPouch'] as Map<String, dynamic>);

Map<String, dynamic> _$VisitToJson(Visit instance) => <String, dynamic>{
      'id': instance.id,
      'inclusion': instance.inclusion?.toIso8601String(),
      'alteration': instance.alteration?.toIso8601String(),
      'active': instance.active,
      'addedProducts': instance.addedProducts,
      'moneyQuantity': instance.moneyQuantity,
      'moneyWithdrawalQuantity': instance.moneyWithdrawalQuantity,
      'stuffedAnimalsQuantity': instance.stuffedAnimalsQuantity,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'status': _$VisitStatusEnumMap[instance.status]!,
      'machineId': instance.machineId,
      'moneyWithdrawal': instance.moneyWithdrawal,
      'code': instance.code,
      'observation': instance.observation,
      'moneyPouch': instance.moneyPouch,
    };

const _$VisitStatusEnumMap = {
  VisitStatus.realized: 0,
  VisitStatus.moneyWithdrawal: 1,
  VisitStatus.moneyPouchLaunched: 2,
  VisitStatus.finished: 3,
};
