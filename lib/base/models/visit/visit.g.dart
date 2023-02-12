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
      moneyWithDrawal: ElephantCore.fromJsonActive(json['moneyWithDrawal']),
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
      moneyPouchId: json['moneyPouchId'] as String?,
      lastVisitMachineCurrentDay: json['lastVisitMachineCurrentDay'] == null
          ? null
          : DateTime.parse(json['lastVisitMachineCurrentDay'] as String),
      offline: ElephantCore.fromJsonActive(json['offline']),
      sent: json['sent'] == null ? true : Visit.fromJsonSent(json['sent']),
    )
      ..id = json['id'] as String?
      ..inclusion = json['inclusion'] == null
          ? null
          : DateTime.parse(json['inclusion'] as String)
      ..alteration = json['alteration'] == null
          ? null
          : DateTime.parse(json['alteration'] as String)
      ..active = ElephantCore.fromJsonActive(json['active'])
      ..includeUserId = json['includeUserId'] as String?
      ..lastPrizeMachine = (json['lastPrizeMachine'] as num?)?.toDouble()
      ..monthClosure = ElephantCore.fromJsonActive(json['monthClosure'])
      ..debit = (json['debit'] as num?)?.toDouble()
      ..credit = (json['credit'] as num?)?.toDouble();

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
      'code': instance.code,
      'status': _$VisitStatusEnumMap[instance.status]!,
      'observation': instance.observation,
      'lastVisitMachineCurrentDay':
          instance.lastVisitMachineCurrentDay?.toIso8601String(),
      'responsibleUserId': instance.responsibleUserId,
      'offline': instance.offline,
      'lastPrizeMachine': instance.lastPrizeMachine,
      'machineId': instance.machineId,
      'machine': instance.machine,
      'moneyPouchId': instance.moneyPouchId,
      'moneyPouch': instance.moneyPouch,
      'monthClosure': instance.monthClosure,
      'moneyWithDrawal': instance.moneyWithDrawal,
      'sent': Visit.toJsonNull(instance.sent),
      'debit': Visit.toJsonNull(instance.debit),
      'credit': Visit.toJsonNull(instance.credit),
    };

const _$VisitStatusEnumMap = {
  VisitStatus.realized: 0,
  VisitStatus.moneyWithdrawal: 1,
  VisitStatus.moneyPouchLaunched: 2,
  VisitStatus.finished: 3,
  VisitStatus.noStatus: 4,
  VisitStatus.solicitationPending: 5,
};
