// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incident.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Incident _$IncidentFromJson(Map<String, dynamic> json) => Incident(
      description: json['description'] as String?,
      status: $enumDecode(_$IncidentStatusEnumMap, json['status']),
      responsibleUserId: json['responsibleUserId'] as String,
      operatorUserId: json['operatorUserId'] as String,
      machineId: json['machineId'] as String,
      visitId: json['visitId'] as String,
    )
      ..id = json['id'] as String?
      ..inclusion = json['inclusion'] == null
          ? null
          : DateTime.parse(json['inclusion'] as String)
      ..alteration = json['alteration'] == null
          ? null
          : DateTime.parse(json['alteration'] as String)
      ..active = json['active'] as bool?;

Map<String, dynamic> _$IncidentToJson(Incident instance) => <String, dynamic>{
      'id': instance.id,
      'inclusion': instance.inclusion?.toIso8601String(),
      'alteration': instance.alteration?.toIso8601String(),
      'active': instance.active,
      'description': instance.description,
      'status': _$IncidentStatusEnumMap[instance.status]!,
      'responsibleUserId': instance.responsibleUserId,
      'operatorUserId': instance.operatorUserId,
      'machineId': instance.machineId,
      'visitId': instance.visitId,
    };

const _$IncidentStatusEnumMap = {
  IncidentStatus.realized: 0,
  IncidentStatus.finished: 1,
};
