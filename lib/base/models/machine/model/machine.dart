import 'package:elephant_control/base/models/base/elephant_core.dart';
import 'package:elephant_control/base/models/machine/model/reminder.dart';
import 'package:json_annotation/json_annotation.dart';
part 'machine.g.dart';

@JsonSerializable()
class Machine extends ElephantCore {
  late String name;
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
  bool? machineAddOtherList;
  List<Reminder>? reminders;
  @JsonKey(ignore: true)
  late bool selected;

  Machine({required this.name, this.selected = false, super.id, this.lastVisit, this.reminders});

  factory Machine.fromJson(Map<String, dynamic> json) => _$MachineFromJson(json);

  Map<String, dynamic> toJson() => _$MachineToJson(this);
}
