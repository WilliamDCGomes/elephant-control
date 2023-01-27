import 'package:json_annotation/json_annotation.dart';

part 'user_location_view_controller.g.dart';

@JsonSerializable()
class UserLocationViewController {
  late String longitude;
  late String latitude;
  late String userLocationId;
  String? cep;
  String? uf;
  String? city;
  String? address;
  String? district;

  UserLocationViewController({
    required this.longitude,
    required this.latitude,
    required this.userLocationId,
    this.cep,
    this.uf,
    this.city,
    this.address,
    this.district,
  });

  double get longitudeValue => longitude != "" ? double.parse(longitude) : 0;
  double get latitudeValue => latitude != "" ? double.parse(latitude) : 0;

  factory UserLocationViewController.fromJson(Map<String, dynamic> json) => _$UserLocationViewControllerFromJson(json);

  Map<String, dynamic> toJson() => _$UserLocationViewControllerToJson(this);
}
