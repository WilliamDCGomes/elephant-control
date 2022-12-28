// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'money_pouch_viewcontroller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoneyPouchViewController _$MoneyPouchViewControllerFromJson(
        Map<String, dynamic> json) =>
    MoneyPouchViewController(
      pouchValue: (json['pouchValue'] as num).toDouble(),
      cardValue: (json['cardValue'] as num).toDouble(),
      observation: json['observation'] as String?,
      differenceValue: (json['differenceValue'] as num?)?.toDouble(),
      visitId: json['visitId'] as String,
    )
      ..code = json['code'] as int?
      ..moneyPouchId = json['moneyPouchId'] as String?
      ..valueMatch = json['valueMatch'] as bool?
      ..visitCode = json['visitCode'] as int?;

Map<String, dynamic> _$MoneyPouchViewControllerToJson(
        MoneyPouchViewController instance) =>
    <String, dynamic>{
      'observation': instance.observation,
      'visitId': instance.visitId,
      'pouchValue': instance.pouchValue,
      'cardValue': instance.cardValue,
      'code': instance.code,
      'moneyPouchId': instance.moneyPouchId,
      'valueMatch': instance.valueMatch,
      'visitCode': instance.visitCode,
      'differenceValue': instance.differenceValue,
    };
