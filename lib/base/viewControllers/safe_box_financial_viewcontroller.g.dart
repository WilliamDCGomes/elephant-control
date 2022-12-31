// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'safe_box_financial_viewcontroller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SafeBoxFinancialViewController _$SafeBoxFinancialViewControllerFromJson(
        Map<String, dynamic> json) =>
    SafeBoxFinancialViewController()
      ..visitId = json['visitId'] as String
      ..machineName = json['machineName'] as String
      ..operatorName = json['operatorName'] as String
      ..moneyWithDrawalQuantity =
          (json['moneyWithDrawalQuantity'] as num?)?.toDouble()
      ..receiveDate = DateTime.parse(json['receiveDate'] as String);

Map<String, dynamic> _$SafeBoxFinancialViewControllerToJson(
        SafeBoxFinancialViewController instance) =>
    <String, dynamic>{
      'visitId': instance.visitId,
      'machineName': instance.machineName,
      'operatorName': instance.operatorName,
      'moneyWithDrawalQuantity': instance.moneyWithDrawalQuantity,
      'receiveDate': instance.receiveDate.toIso8601String(),
    };
