// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'money_pouch_value_list_viewcontroller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoneyPouchValueListViewController _$MoneyPouchValueListViewControllerFromJson(
        Map<String, dynamic> json) =>
    MoneyPouchValueListViewController()
      ..name = json['name'] as String
      ..userName = json['userName'] as String
      ..alteration = DateTime.parse(json['alteration'] as String)
      ..moneyQuantity = (json['moneyQuantity'] as num).toDouble();

Map<String, dynamic> _$MoneyPouchValueListViewControllerToJson(
        MoneyPouchValueListViewController instance) =>
    <String, dynamic>{
      'name': instance.name,
      'userName': instance.userName,
      'alteration': instance.alteration.toIso8601String(),
      'moneyQuantity': instance.moneyQuantity,
    };
