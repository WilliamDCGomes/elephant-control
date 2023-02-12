// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_visit_machine_viewcontroller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserVisitMachineViewController _$UserVisitMachineViewControllerFromJson(
        Map<String, dynamic> json) =>
    UserVisitMachineViewController(
      machineId: json['machineId'] as String,
      machineName: json['machineName'] as String,
      id: json['id'] as String,
      visitDay: DateTime.parse(json['visitDay'] as String),
      lastVisit: json['lastVisit'] == null
          ? null
          : DateTime.parse(json['lastVisit'] as String),
      reminders: (json['reminders'] as List<dynamic>?)
              ?.map((e) => ReminderMachine.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$UserVisitMachineViewControllerToJson(
        UserVisitMachineViewController instance) =>
    <String, dynamic>{
      'machineId': instance.machineId,
      'machineName': instance.machineName,
      'id': instance.id,
      'visitDay': instance.visitDay.toIso8601String(),
      'lastVisit': instance.lastVisit?.toIso8601String(),
      'reminders': instance.reminders,
    };
