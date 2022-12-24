// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'machine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Machine _$MachineFromJson(Map<String, dynamic> json) => Machine(
      name: json['name'] as String,
      selected: json['selected'] as bool? ?? false,
    )
      ..id = json['id'] as String?
      ..inclusion = json['inclusion'] == null
          ? null
          : DateTime.parse(json['inclusion'] as String)
      ..alteration = json['alteration'] == null
          ? null
          : DateTime.parse(json['alteration'] as String)
      ..active = json['active'] as bool?
      ..lastVisit = json['lastVisit'] == null
          ? null
          : DateTime.parse(json['lastVisit'] as String)
      ..daysToNextVisit = json['daysToNextVisit'] as int?
      ..prize = (json['prize'] as num?)?.toDouble()
      ..balance = (json['balance'] as num?)?.toDouble()
      ..localization = json['localization'] as String
      ..longitude = json['longitude'] as String
      ..latitude = json['latitude'] as String
      ..cep = json['cep'] as String
      ..uf = json['uf'] as String
      ..city = json['city'] as String
      ..address = json['address'] as String
      ..number = json['number'] as String
      ..district = json['district'] as String
      ..complement = json['complement'] as String
      ..mimimumAverageValue = (json['mimimumAverageValue'] as num).toDouble()
      ..maximumAverageValue = (json['maximumAverageValue'] as num).toDouble();

Map<String, dynamic> _$MachineToJson(Machine instance) => <String, dynamic>{
      'id': instance.id,
      'inclusion': instance.inclusion?.toIso8601String(),
      'alteration': instance.alteration?.toIso8601String(),
      'active': instance.active,
      'name': instance.name,
      'lastVisit': instance.lastVisit?.toIso8601String(),
      'daysToNextVisit': instance.daysToNextVisit,
      'prize': instance.prize,
      'balance': instance.balance,
      'localization': instance.localization,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'cep': instance.cep,
      'uf': instance.uf,
      'city': instance.city,
      'address': instance.address,
      'number': instance.number,
      'district': instance.district,
      'complement': instance.complement,
      'mimimumAverageValue': instance.mimimumAverageValue,
      'maximumAverageValue': instance.maximumAverageValue,
      'selected': instance.selected,
    };