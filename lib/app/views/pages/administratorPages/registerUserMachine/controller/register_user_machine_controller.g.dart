// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_user_machine_controller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MachineOperator _$MachineOperatorFromJson(Map<String, dynamic> json) =>
    MachineOperator(
      UserId: json['UserId'] as String,
      machine: (json['machine'] as List<dynamic>)
          .map((e) => Machine.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MachineOperatorToJson(MachineOperator instance) =>
    <String, dynamic>{
      'UserId': instance.UserId,
      'machine': instance.machine,
    };
