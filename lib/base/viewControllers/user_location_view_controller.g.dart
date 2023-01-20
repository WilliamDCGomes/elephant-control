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
    );

Map<String, dynamic> _$UserLocationViewControllerToJson(
        UserLocationViewController instance) =>
    <String, dynamic>{
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'userLocationId': instance.userLocationId,
      'cep': instance.cep,
      'uf': instance.uf,
      'city': instance.city,
      'address': instance.address,
      'district': instance.district,
    };
