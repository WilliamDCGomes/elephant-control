// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreUser _$StoreUserFromJson(Map<String, dynamic> json) => StoreUser(
      storeId: json['storeId'] as String,
      userId: json['userId'] as String,
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

Map<String, dynamic> _$StoreUserToJson(StoreUser instance) => <String, dynamic>{
      'id': instance.id,
      'inclusion': instance.inclusion?.toIso8601String(),
      'alteration': instance.alteration?.toIso8601String(),
      'active': instance.active,
      'includeUserId': instance.includeUserId,
      'storeId': instance.storeId,
      'userId': instance.userId,
    };
