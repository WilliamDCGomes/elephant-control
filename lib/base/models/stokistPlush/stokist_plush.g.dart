// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stokist_plush.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StokistPlush _$StokistPlushFromJson(Map<String, dynamic> json) => StokistPlush(
      balanceStuffedAnimals: json['balanceStuffedAnimals'] as int,
    )
      ..id = json['id'] as String?
      ..inclusion = json['inclusion'] == null
          ? null
          : DateTime.parse(json['inclusion'] as String)
      ..alteration = json['alteration'] == null
          ? null
          : DateTime.parse(json['alteration'] as String)
      ..active = json['active'] as bool?
      ..includeUserId = json['includeUserId'] as String?;

Map<String, dynamic> _$StokistPlushToJson(StokistPlush instance) =>
    <String, dynamic>{
      'id': instance.id,
      'inclusion': instance.inclusion?.toIso8601String(),
      'alteration': instance.alteration?.toIso8601String(),
      'active': instance.active,
      'includeUserId': instance.includeUserId,
      'balanceStuffedAnimals': instance.balanceStuffedAnimals,
    };
