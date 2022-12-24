import 'package:json_annotation/json_annotation.dart';
part 'user_visit_machine_viewcontroller.g.dart';

@JsonSerializable()
class UserVisitMachineViewController {
  late String machineId;
  late String machineName;
  late String id;
  late DateTime visitDay;

  UserVisitMachineViewController({
    required this.machineId,
    required this.machineName,
    required this.id,
    required this.visitDay,
  });

  factory UserVisitMachineViewController.fromJson(Map<String, dynamic> json) => _$UserVisitMachineViewControllerFromJson(json);

  Map<String, dynamic> toJson() => _$UserVisitMachineViewControllerToJson(this);
}
