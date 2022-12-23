// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_user_visit_machine_viewcontroller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateUserVisitMachineViewController
    _$CreateUserVisitMachineViewControllerFromJson(Map<String, dynamic> json) =>
        CreateUserVisitMachineViewController(
          machineIds: (json['machineIds'] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toList() ??
              const [],
          visitDay: DateTime.parse(json['visitDay'] as String),
        );

Map<String, dynamic> _$CreateUserVisitMachineViewControllerToJson(
        CreateUserVisitMachineViewController instance) =>
    <String, dynamic>{
      'machineIds': instance.machineIds,
      'visitDay': instance.visitDay.toIso8601String(),
    };
