import 'package:json_annotation/json_annotation.dart';

part 'total_main_menu_operator_view_controller.g.dart';

@JsonSerializable()
class TotalMainMenuOperatorViewcontroller {
  late String visitId;
  late String machineName;
  late DateTime inclusion;
  late bool hasIncident;

  TotalMainMenuOperatorViewcontroller();

  factory TotalMainMenuOperatorViewcontroller.fromJson(Map<String, dynamic> json) =>
      _$TotalMainMenuOperatorViewcontrollerFromJson(json);

  Map<String, dynamic> toJson() => _$TotalMainMenuOperatorViewcontrollerToJson(this);
}
