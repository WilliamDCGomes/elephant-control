// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'money_pouch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoneyPouch _$MoneyPouchFromJson(Map<String, dynamic> json) => MoneyPouch(
      code: json['code'] as int,
      pouchValue: (json['pouchValue'] as num).toDouble(),
      cardvalue: (json['cardvalue'] as num?)?.toDouble(),
      observation: json['observation'] as String?,
      valueMatch: json['valueMatch'] as bool,
    )
      ..id = json['id'] as String?
      ..inclusion = json['inclusion'] == null
          ? null
          : DateTime.parse(json['inclusion'] as String)
      ..alteration = json['alteration'] == null
          ? null
          : DateTime.parse(json['alteration'] as String)
      ..active = json['active'] as bool?
      ..includeUserId = json['includeUserId'] as String?
      ..differenceValue = (json['differenceValue'] as num?)?.toDouble()
      ..latitude = json['latitude'] as String?
      ..longitude = json['longitude'] as String?;

Map<String, dynamic> _$MoneyPouchToJson(MoneyPouch instance) =>
    <String, dynamic>{
      'id': instance.id,
      'inclusion': instance.inclusion?.toIso8601String(),
      'alteration': instance.alteration?.toIso8601String(),
      'active': instance.active,
      'includeUserId': instance.includeUserId,
      'code': instance.code,
      'pouchValue': instance.pouchValue,
      'cardvalue': instance.cardvalue,
      'observation': instance.observation,
      'valueMatch': instance.valueMatch,
      'differenceValue': instance.differenceValue,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
