// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stockist_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockistLog _$StockistLogFromJson(Map<String, dynamic> json) => StockistLog(
      description: json['description'] as String,
      observation: json['observation'] as String,
      quantity: json['quantity'] as int,
      added: json['added'] as bool,
      stockistUserId: json['stockistUserId'] as String,
      operatorUserId: json['operatorUserId'] as String,
    )
      ..id = json['id'] as String?
      ..inclusion = json['inclusion'] == null
          ? null
          : DateTime.parse(json['inclusion'] as String)
      ..alteration = json['alteration'] == null
          ? null
          : DateTime.parse(json['alteration'] as String)
      ..active = ElephantCore.fromJsonActive(json['active']);

Map<String, dynamic> _$StockistLogToJson(StockistLog instance) =>
    <String, dynamic>{
      'id': instance.id,
      'inclusion': instance.inclusion?.toIso8601String(),
      'alteration': instance.alteration?.toIso8601String(),
      'active': instance.active,
      'description': instance.description,
      'observation': instance.observation,
      'quantity': instance.quantity,
      'added': instance.added,
      'stockistUserId': instance.stockistUserId,
      'operatorUserId': instance.operatorUserId,
    };
