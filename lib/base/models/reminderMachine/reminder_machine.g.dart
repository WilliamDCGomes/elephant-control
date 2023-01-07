// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_machine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReminderMachine _$ReminderMachineFromJson(Map<String, dynamic> json) =>
    ReminderMachine(
      description: json['description'] as String,
      realized: json['realized'] as bool,
      machineId: json['machineId'] as String,
      id: json['id'] as String?,
    )
      ..inclusion = json['inclusion'] == null
          ? null
          : DateTime.parse(json['inclusion'] as String)
      ..alteration = json['alteration'] == null
          ? null
          : DateTime.parse(json['alteration'] as String)
      ..active = json['active'] as bool?
      ..includeUserId = json['includeUserId'] as String?;

Map<String, dynamic> _$ReminderMachineToJson(ReminderMachine instance) =>
    <String, dynamic>{
      'id': instance.id,
      'inclusion': instance.inclusion?.toIso8601String(),
      'alteration': instance.alteration?.toIso8601String(),
      'active': instance.active,
      'includeUserId': instance.includeUserId,
      'description': instance.description,
      'realized': instance.realized,
      'machineId': instance.machineId,
    };
