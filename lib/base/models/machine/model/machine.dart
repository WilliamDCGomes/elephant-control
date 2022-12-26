import 'package:elephant_control/base/models/base/elephant_core.dart';
import 'package:json_annotation/json_annotation.dart';
part '../converter/machine.g.dart';

@JsonSerializable()
class Machine extends ElephantCore {
  final String name;
  DateTime? lastVisit;
  int? daysToNextVisit;
  double? prize;
  double? balance;
  late String localization;
  late String longitude;
  late String latitude;
  late String cep;
  late String uf;
  late String city;
  late String address;
  late String number;
  late String district;
  late String complement;
  late double minimumAverageValue;
  late double maximumAverageValue;
  late bool selected;

  Machine({required this.name, this.selected = false});

  factory Machine.fromJson(Map<String, dynamic> json) => _$MachineFromJson(json);

  Map<String, dynamic> toJson() => _$MachineToJson(this);
}
