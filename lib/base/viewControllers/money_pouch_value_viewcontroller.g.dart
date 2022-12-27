// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'money_pouch_value_viewcontroller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoneyPouchValueViewController _$MoneyPouchValueViewControllerFromJson(
        Map<String, dynamic> json) =>
    MoneyPouchValueViewController(
      value: (json['value'] as num).toDouble(),
      quantity: json['quantity'] as int,
      lastUpdateQuantity: DateTime.parse(json['lastUpdateQuantity'] as String),
      lastUpdateValue: DateTime.parse(json['lastUpdateValue'] as String),
    );

Map<String, dynamic> _$MoneyPouchValueViewControllerToJson(
        MoneyPouchValueViewController instance) =>
    <String, dynamic>{
      'value': instance.value,
      'quantity': instance.quantity,
      'lastUpdateQuantity': instance.lastUpdateQuantity.toIso8601String(),
      'lastUpdateValue': instance.lastUpdateValue.toIso8601String(),
    };
