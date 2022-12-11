// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      name: json['name'] as String?,
      tellphone: json['tellphone'] as String?,
      document: json['document'] as String?,
      balanceMoney: (json['balanceMoney'] as num?)?.toDouble(),
      balanceStuffesAnimals:
          (json['balanceStuffesAnimals'] as num?)?.toDouble(),
      type: $enumDecode(_$UserTypeEnumMap, json['type']),
    )
      ..id = json['id'] as String?
      ..inclusion = json['inclusion'] == null
          ? null
          : DateTime.parse(json['inclusion'] as String)
      ..alteration = json['alteration'] == null
          ? null
          : DateTime.parse(json['alteration'] as String)
      ..active = json['active'] as bool?;

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'inclusion': instance.inclusion?.toIso8601String(),
      'alteration': instance.alteration?.toIso8601String(),
      'active': instance.active,
      'name': instance.name,
      'tellphone': instance.tellphone,
      'document': instance.document,
      'balanceMoney': instance.balanceMoney,
      'balanceStuffesAnimals': instance.balanceStuffesAnimals,
      'type': _$UserTypeEnumMap[instance.type]!,
    };

const _$UserTypeEnumMap = {
  UserType.operator: 0,
  UserType.treasury: 1,
  UserType.admin: 2,
};
