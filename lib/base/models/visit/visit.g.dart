// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Visit _$VisitFromJson(Map<String, dynamic> json) => Visit(
      moneyQuantity: (json['moneyQuantity'] as num).toDouble(),
      moneyWithdrawalQuantity:
          (json['moneyWithdrawalQuantity'] as num?)?.toDouble(),
      stuffedAnimalsQuantity: json['stuffedAnimalsQuantity'] as int,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      status: $enumDecode(_$VisitStatusEnumMap, json['status']),
      machineId: json['machineId'] as String,
      moneyWithDrawal: json['moneyWithDrawal'] as bool,
      code: json['code'] as int?,
      observation: json['observation'] as String?,
      moneyPouch: json['moneyPouch'] == null
          ? null
          : MoneyPouch.fromJson(json['moneyPouch'] as Map<String, dynamic>),
      machine: json['machine'] == null
          ? null
          : Machine.fromJson(json['machine'] as Map<String, dynamic>),
      responsibleUserId: json['responsibleUserId'] as String?,
      stuffedAnimalsReplaceQuantity:
          json['stuffedAnimalsReplaceQuantity'] as int,
    )
      ..id = json['id'] as String?
      ..inclusion = json['inclusion'] == null
          ? null
          : DateTime.parse(json['inclusion'] as String)
      ..alteration = json['alteration'] == null
          ? null
          : DateTime.parse(json['alteration'] as String)
      ..active = json['active'] as bool?
      ..includeUserId = json['includeUserId'] as String?
      ..moneyPouchId = json['moneyPouchId'] as String?;

Map<String, dynamic> _$VisitToJson(Visit instance) => <String, dynamic>{
      'id': instance.id,
      'inclusion': instance.inclusion?.toIso8601String(),
      'alteration': instance.alteration?.toIso8601String(),
      'active': instance.active,
      'includeUserId': instance.includeUserId,
      'moneyQuantity': instance.moneyQuantity,
      'moneyWithdrawalQuantity': instance.moneyWithdrawalQuantity,
      'stuffedAnimalsQuantity': instance.stuffedAnimalsQuantity,
      'stuffedAnimalsReplaceQuantity': instance.stuffedAnimalsReplaceQuantity,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'status': _$VisitStatusEnumMap[instance.status]!,
      'machineId': instance.machineId,
      'moneyWithDrawal': instance.moneyWithDrawal,
      'code': instance.code,
      'observation': instance.observation,
      'moneyPouchId': instance.moneyPouchId,
      'moneyPouch': instance.moneyPouch,
      'machine': instance.machine,
      'responsibleUserId': instance.responsibleUserId,
    };

const _$VisitStatusEnumMap = {
  VisitStatus.realized: 0,
  VisitStatus.moneyWithdrawal: 1,
  VisitStatus.moneyPouchLaunched: 2,
  VisitStatus.finished: 3,
  VisitStatus.noStatus: 4,
};
