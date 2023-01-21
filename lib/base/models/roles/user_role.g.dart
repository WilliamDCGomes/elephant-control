// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRole _$UserRoleFromJson(Map<String, dynamic> json) => UserRole(
      userId: json['userId'] as String,
      roleId: json['roleId'] as String,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$UserRoleToJson(UserRole instance) => <String, dynamic>{
      'userId': instance.userId,
      'roleId': instance.roleId,
      'name': instance.name,
    };
