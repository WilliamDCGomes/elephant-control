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
    );

Map<String, dynamic> _$MoneyPouchValueViewControllerToJson(
        MoneyPouchValueViewController instance) =>
    <String, dynamic>{
      'value': instance.value,
      'quantity': instance.quantity,
    };
