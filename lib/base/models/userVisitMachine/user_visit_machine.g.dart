// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_visit_machine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserVisitMachine _$UserVisitMachineFromJson(Map<String, dynamic> json) =>
    UserVisitMachine(
      userId: json['userId'] as String,
      machineId: json['machineId'] as String,
      visitDay: DateTime.parse(json['visitDay'] as String),
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

Map<String, dynamic> _$UserVisitMachineToJson(UserVisitMachine instance) =>
    <String, dynamic>{
      'id': instance.id,
      'inclusion': instance.inclusion?.toIso8601String(),
      'alteration': instance.alteration?.toIso8601String(),
      'active': instance.active,
      'includeUserId': instance.includeUserId,
      'userId': instance.userId,
      'machineId': instance.machineId,
      'visitDay': instance.visitDay.toIso8601String(),
    };
