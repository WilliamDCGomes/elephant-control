// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'last_machines_visit_viewcontroller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LastMachinesVisitViewController _$LastMachinesVisitViewControllerFromJson(
        Map<String, dynamic> json) =>
    LastMachinesVisitViewController()
      ..machineName = json['machineName'] as String
      ..inclusion = DateTime.parse(json['inclusion'] as String);

Map<String, dynamic> _$LastMachinesVisitViewControllerToJson(
        LastMachinesVisitViewController instance) =>
    <String, dynamic>{
      'machineName': instance.machineName,
      'inclusion': instance.inclusion.toIso8601String(),
    };
