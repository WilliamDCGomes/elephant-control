// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operator_information_viewcontroller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OperatorInformationViewController _$OperatorInformationViewControllerFromJson(
        Map<String, dynamic> json) =>
    OperatorInformationViewController(
      visitsUser: (json['visitsUser'] as List<dynamic>)
          .map((e) => Visit.fromJson(e as Map<String, dynamic>))
          .toList(),
      visitsWithMoneydrawal: (json['visitsWithMoneydrawal'] as List<dynamic>)
          .map((e) => Visit.fromJson(e as Map<String, dynamic>))
          .toList(),
      balanceMoney: json['balanceMoney'] as int,
      pouchLastUpdate: json['pouchLastUpdate'] == null
          ? null
          : DateTime.parse(json['pouchLastUpdate'] as String),
      balanceStuffedAnimals: json['balanceStuffedAnimals'] as int,
      stuffedAnimalsLastUpdate: json['stuffedAnimalsLastUpdate'] == null
          ? null
          : DateTime.parse(json['stuffedAnimalsLastUpdate'] as String),
    );

Map<String, dynamic> _$OperatorInformationViewControllerToJson(
        OperatorInformationViewController instance) =>
    <String, dynamic>{
      'visitsUser': instance.visitsUser,
      'visitsWithMoneydrawal': instance.visitsWithMoneydrawal,
      'balanceMoney': instance.balanceMoney,
      'pouchLastUpdate': instance.pouchLastUpdate?.toIso8601String(),
      'balanceStuffedAnimals': instance.balanceStuffedAnimals,
      'stuffedAnimalsLastUpdate':
          instance.stuffedAnimalsLastUpdate?.toIso8601String(),
    };
