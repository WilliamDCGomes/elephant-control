// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'total_main_menu_operator_view_controller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TotalMainMenuOperatorViewcontroller
    _$TotalMainMenuOperatorViewcontrollerFromJson(Map<String, dynamic> json) =>
        TotalMainMenuOperatorViewcontroller()
          ..visitId = json['visitId'] as String
          ..machineName = json['machineName'] as String
          ..inclusion = DateTime.parse(json['inclusion'] as String)
          ..hasIncident = json['hasIncident'] as bool;

Map<String, dynamic> _$TotalMainMenuOperatorViewcontrollerToJson(
        TotalMainMenuOperatorViewcontroller instance) =>
    <String, dynamic>{
      'visitId': instance.visitId,
      'machineName': instance.machineName,
      'inclusion': instance.inclusion.toIso8601String(),
      'hasIncident': instance.hasIncident,
    };
