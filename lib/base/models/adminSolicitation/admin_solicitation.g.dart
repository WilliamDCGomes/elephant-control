// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_solicitation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminSolicitation _$AdminSolicitationFromJson(Map<String, dynamic> json) =>
    AdminSolicitation(
      Status: $enumDecode(_$StatusAdminSolicitationEnumMap, json['Status']),
      Type: $enumDecode(_$StatusAdminTypeEnumMap, json['Type']),
      VisitId: json['VisitId'] as String,
      SolicitationUserId: json['SolicitationUserId'] as String,
    )
      ..id = json['id'] as String?
      ..inclusion = json['inclusion'] == null
          ? null
          : DateTime.parse(json['inclusion'] as String)
      ..alteration = json['alteration'] == null
          ? null
          : DateTime.parse(json['alteration'] as String)
      ..active = ElephantCore.fromJsonActive(json['active'])
      ..includeUserId = json['includeUserId'] as String?;

Map<String, dynamic> _$AdminSolicitationToJson(AdminSolicitation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'inclusion': instance.inclusion?.toIso8601String(),
      'alteration': instance.alteration?.toIso8601String(),
      'active': instance.active,
      'includeUserId': instance.includeUserId,
      'Status': _$StatusAdminSolicitationEnumMap[instance.Status]!,
      'Type': _$StatusAdminTypeEnumMap[instance.Type]!,
      'VisitId': instance.VisitId,
      'SolicitationUserId': instance.SolicitationUserId,
    };

const _$StatusAdminSolicitationEnumMap = {
  StatusAdminSolicitation.pending: 0,
  StatusAdminSolicitation.accepted: 1,
  StatusAdminSolicitation.rejected: 2,
};

const _$StatusAdminTypeEnumMap = {
  StatusAdminType.moneyWithDrawal: 0,
};
