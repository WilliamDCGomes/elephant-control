// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      name: json['name'] as String?,
      tellphone: json['tellphone'] as String?,
      document: json['document'] as String?,
      balanceMoney: json['balanceMoney'] as int?,
      balanceStuffedAnimals: json['balanceStuffedAnimals'] as int?,
      type: $enumDecode(_$UserTypeEnumMap, json['type']),
      pouchLastUpdate: json['pouchLastUpdate'] == null
          ? null
          : DateTime.parse(json['pouchLastUpdate'] as String),
      stuffedAnimalsLastUpdate: json['stuffedAnimalsLastUpdate'] == null
          ? null
          : DateTime.parse(json['stuffedAnimalsLastUpdate'] as String),
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
      'pouchLastUpdate': instance.pouchLastUpdate?.toIso8601String(),
      'balanceStuffedAnimals': instance.balanceStuffedAnimals,
      'stuffedAnimalsLastUpdate':
          instance.stuffedAnimalsLastUpdate?.toIso8601String(),
      'type': _$UserTypeEnumMap[instance.type]!,
    };

const _$UserTypeEnumMap = {
  UserType.operator: 0,
  UserType.treasury: 1,
  UserType.stockist: 2,
  UserType.admin: 3,
  UserType.none: 4,
};
