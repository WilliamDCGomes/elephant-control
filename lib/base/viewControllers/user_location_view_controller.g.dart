// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_location_view_controller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLocationViewController _$UserLocationViewControllerFromJson(
        Map<String, dynamic> json) =>
    UserLocationViewController(
      longitude: json['longitude'] as String,
      latitude: json['latitude'] as String,
      userLocationId: json['userLocationId'] as String,
      cep: json['cep'] as String?,
      uf: json['uf'] as String?,
      city: json['city'] as String?,
      address: json['address'] as String?,
      district: json['district'] as String?,
    )
      ..id = json['id'] as String?
      ..inclusion = json['inclusion'] == null
          ? null
          : DateTime.parse(json['inclusion'] as String)
      ..alteration = json['alteration'] == null
          ? null
          : DateTime.parse(json['alteration'] as String)
      ..active = json['active'] as bool?
      ..includeUserId = json['includeUserId'] as String?;

Map<String, dynamic> _$UserLocationViewControllerToJson(
        UserLocationViewController instance) =>
    <String, dynamic>{
      'id': instance.id,
      'inclusion': instance.inclusion?.toIso8601String(),
      'alteration': instance.alteration?.toIso8601String(),
      'active': instance.active,
      'includeUserId': instance.includeUserId,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'userLocationId': instance.userLocationId,
      'cep': instance.cep,
      'uf': instance.uf,
      'city': instance.city,
      'address': instance.address,
      'district': instance.district,
    };
