// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisitLog _$VisitLogFromJson(Map<String, dynamic> json) => VisitLog(
      visitId: json['visitId'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      oldStatus: $enumDecode(_$VisitStatusEnumMap, json['oldStatus']),
      newStatus: $enumDecode(_$VisitStatusEnumMap, json['newStatus']),
      moneyPouchId: json['moneyPouchId'] as String?,
    )
      ..id = json['id'] as String?
      ..inclusion = json['inclusion'] == null
          ? null
          : DateTime.parse(json['inclusion'] as String)
      ..alteration = json['alteration'] == null
          ? null
          : DateTime.parse(json['alteration'] as String)
      ..active = ElephantCore.fromJsonActive(json['active'])
      ..includeUserId = json['includeUserId'] as String?;

Map<String, dynamic> _$VisitLogToJson(VisitLog instance) => <String, dynamic>{
      'id': instance.id,
      'inclusion': instance.inclusion?.toIso8601String(),
      'alteration': instance.alteration?.toIso8601String(),
      'active': instance.active,
      'includeUserId': instance.includeUserId,
      'visitId': instance.visitId,
      'moneyPouchId': instance.moneyPouchId,
      'title': instance.title,
      'description': instance.description,
      'oldStatus': _$VisitStatusEnumMap[instance.oldStatus]!,
      'newStatus': _$VisitStatusEnumMap[instance.newStatus]!,
    };

const _$VisitStatusEnumMap = {
  VisitStatus.realized: 0,
  VisitStatus.moneyWithdrawal: 1,
  VisitStatus.moneyPouchLaunched: 2,
  VisitStatus.finished: 3,
  VisitStatus.noStatus: 4,
  VisitStatus.solicitationPending: 5,
};
