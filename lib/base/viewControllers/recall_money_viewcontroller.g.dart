// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recall_money_viewcontroller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecallMoneyViewController _$RecallMoneyViewControllerFromJson(
        Map<String, dynamic> json) =>
    RecallMoneyViewController(
      name: json['name'] as String,
      id: json['id'] as String,
      totalValue: (json['totalValue'] as num).toDouble(),
    );

Map<String, dynamic> _$RecallMoneyViewControllerToJson(
        RecallMoneyViewController instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'totalValue': instance.totalValue,
    };
