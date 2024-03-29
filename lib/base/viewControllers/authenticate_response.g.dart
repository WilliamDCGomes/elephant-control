// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authenticate_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthenticateResponse _$AuthenticateResponseFromJson(
        Map<String, dynamic> json) =>
    AuthenticateResponse(
      id: json['id'] as String?,
      name: json['name'] as String?,
      login: json['login'] as String?,
      expirationDate: json['expirationDate'] == null
          ? null
          : DateTime.parse(json['expirationDate'] as String),
      token: json['token'] as String?,
      userType: $enumDecodeNullable(_$UserTypeEnumMap, json['userType']),
      success: json['success'] as bool,
    );

Map<String, dynamic> _$AuthenticateResponseToJson(
        AuthenticateResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'login': instance.login,
      'expirationDate': instance.expirationDate?.toIso8601String(),
      'token': instance.token,
      'userType': _$UserTypeEnumMap[instance.userType],
      'success': instance.success,
    };

const _$UserTypeEnumMap = {
  UserType.operator: 0,
  UserType.treasury: 1,
  UserType.stockist: 2,
  UserType.admin: 3,
  UserType.adminPrivileges: 4,
};
