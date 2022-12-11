// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authenticate_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthenticateResponse _$AuthenticateResponseFromJson(
        Map<String, dynamic> json) =>
    AuthenticateResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      login: json['login'] as String,
      expirationDate: DateTime.parse(json['expirationDate'] as String),
      token: json['token'] as String,
      userType: $enumDecode(_$UserTypeEnumMap, json['userType']),
    );

Map<String, dynamic> _$AuthenticateResponseToJson(
        AuthenticateResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'login': instance.login,
      'expirationDate': instance.expirationDate.toIso8601String(),
      'token': instance.token,
      'userType': _$UserTypeEnumMap[instance.userType]!,
    };

const _$UserTypeEnumMap = {
  UserType.operator: 0,
  UserType.treasury: 1,
  UserType.admin: 2,
};
