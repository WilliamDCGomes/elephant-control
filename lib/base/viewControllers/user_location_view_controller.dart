import 'package:elephant_control/app/utils/date_format_to_brazil.dart';
import 'package:json_annotation/json_annotation.dart';
import '../models/base/elephant_core.dart';

part 'user_location_view_controller.g.dart';

@JsonSerializable()
class UserLocationViewController extends ElephantCore{
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
  String get streetName {
    if(address == null || address == ""){
      return "Rua desconhecida.";
    }
    return "Endereço: " + address!;
  }
  String get districtName {
    if(district == null || district == ""){
      return "Bairro desconhecido.";
    }
    return "Bairro: " + district!;
  }
  String get cityStateName {
    if(city == null || city == "" || uf == null || uf == ""){
      return "Cidade desconhecida.";
    }
    return "Cidade: " + city! + "/" + uf!;
  }
  String get dateRegisterName {
    return "Data do registro: " + DateFormatToBrazil.formatDateAndHour(inclusion);
  }

  factory UserLocationViewController.fromJson(Map<String, dynamic> json) => _$UserLocationViewControllerFromJson(json);

  Map<String, dynamic> toJson() => _$UserLocationViewControllerToJson(this);
}
