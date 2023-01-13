// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_list_viewcontroller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisitListViewController _$VisitListViewControllerFromJson(
        Map<String, dynamic> json) =>
    VisitListViewController(
      priority: json['priority'] as String,
      status: $enumDecodeNullable(_$VisitStatusEnumMap, json['status']),
      moneyQuantity: (json['moneyQuantity'] as num).toDouble(),
      stuffedAnimalsReplaceQuantity:
          (json['stuffedAnimalsReplaceQuantity'] as num).toDouble(),
      stuffedAnimalsQuantity:
          (json['stuffedAnimalsQuantity'] as num).toDouble(),
      moneyPouchRetired: json['moneyPouchRetired'] as bool,
      machineName: json['machineName'] as String,
      realizedVisit: json['realizedVisit'] as bool?,
    )
      ..id = json['id'] as String?
      ..inclusion = json['inclusion'] == null
          ? null
          : DateTime.parse(json['inclusion'] as String)
      ..alteration = json['alteration'] == null
          ? null
          : DateTime.parse(json['alteration'] as String)
      ..active = json['active'] as bool?
      ..includeUserId = json['includeUserId'] as String?;

Map<String, dynamic> _$VisitListViewControllerToJson(
        VisitListViewController instance) =>
    <String, dynamic>{
      'id': instance.id,
      'inclusion': instance.inclusion?.toIso8601String(),
      'alteration': instance.alteration?.toIso8601String(),
      'active': instance.active,
      'includeUserId': instance.includeUserId,
      'priority': instance.priority,
      'status': _$VisitStatusEnumMap[instance.status],
      'moneyQuantity': instance.moneyQuantity,
      'stuffedAnimalsReplaceQuantity': instance.stuffedAnimalsReplaceQuantity,
      'stuffedAnimalsQuantity': instance.stuffedAnimalsQuantity,
      'moneyPouchRetired': instance.moneyPouchRetired,
      'machineName': instance.machineName,
      'realizedVisit': instance.realizedVisit,
    };

const _$VisitStatusEnumMap = {
  VisitStatus.realized: 0,
  VisitStatus.moneyWithdrawal: 1,
  VisitStatus.moneyPouchLaunched: 2,
  VisitStatus.finished: 3,
  VisitStatus.noStatus: 4,
  VisitStatus.solicitationPending: 5,
};
