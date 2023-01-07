// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_machine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserMachine _$UserMachineFromJson(Map<String, dynamic> json) => UserMachine(
      userId: json['userId'] as String,
      machineId: json['machineId'] as String,
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

Map<String, dynamic> _$UserMachineToJson(UserMachine instance) =>
    <String, dynamic>{
      'id': instance.id,
      'inclusion': instance.inclusion?.toIso8601String(),
      'alteration': instance.alteration?.toIso8601String(),
      'active': instance.active,
      'includeUserId': instance.includeUserId,
      'userId': instance.userId,
      'machineId': instance.machineId,
    };
