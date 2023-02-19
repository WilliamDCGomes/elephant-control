// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'machine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Machine _$MachineFromJson(Map<String, dynamic> json) => Machine(
      name: json['name'] as String,
      id: json['id'] as String?,
      lastVisit: json['lastVisit'] == null
          ? null
          : DateTime.parse(json['lastVisit'] as String),
      reminders: (json['reminders'] as List<dynamic>?)
          ?.map((e) => ReminderMachine.fromJson(e as Map<String, dynamic>))
          .toList(),
      monthClosure: json['monthClosure'] == null
          ? false
          : ElephantCore.fromJsonActive(json['monthClosure']),
    )
      ..inclusion = json['inclusion'] == null
          ? null
          : DateTime.parse(json['inclusion'] as String)
      ..alteration = json['alteration'] == null
          ? null
          : DateTime.parse(json['alteration'] as String)
      ..active = ElephantCore.fromJsonActive(json['active'])
      ..includeUserId = json['includeUserId'] as String?
      ..machineType = json['machineType'] as String?
      ..daysToNextVisit = json['daysToNextVisit'] as int?
      ..prize = (json['prize'] as num?)?.toDouble()
      ..lastPrize = (json['lastPrize'] as num?)?.toDouble()
      ..balanceStuffedAnimals =
          (json['balanceStuffedAnimals'] as num?)?.toDouble()
      ..lastBalanceStuffedAnimals =
          (json['lastBalanceStuffedAnimals'] as num?)?.toDouble()
      ..storeId = json['storeId'] as String?
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
      ..minimumAverageValue = (json['minimumAverageValue'] as num).toDouble()
      ..maximumAverageValue = (json['maximumAverageValue'] as num).toDouble()
      ..externalId = json['externalId'] as int?
      ..machineAddOtherList =
          ElephantCore.fromJsonActive(json['machineAddOtherList'])
      ..sent = Machine.fromJsonSent(json['sent']);

Map<String, dynamic> _$MachineToJson(Machine instance) => <String, dynamic>{
      'id': instance.id,
      'inclusion': instance.inclusion?.toIso8601String(),
      'alteration': instance.alteration?.toIso8601String(),
      'active': instance.active,
      'includeUserId': instance.includeUserId,
      'name': instance.name,
      'machineType': instance.machineType,
      'lastVisit': instance.lastVisit?.toIso8601String(),
      'daysToNextVisit': instance.daysToNextVisit,
      'prize': instance.prize,
      'lastPrize': instance.lastPrize,
      'balanceStuffedAnimals': instance.balanceStuffedAnimals,
      'lastBalanceStuffedAnimals': instance.lastBalanceStuffedAnimals,
      'storeId': instance.storeId,
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
      'minimumAverageValue': instance.minimumAverageValue,
      'maximumAverageValue': instance.maximumAverageValue,
      'monthClosure': instance.monthClosure,
      'externalId': instance.externalId,
      'machineAddOtherList': instance.machineAddOtherList,
      'reminders': instance.reminders,
      'sent': instance.sent,
    };
