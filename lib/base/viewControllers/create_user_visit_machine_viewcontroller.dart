import 'package:json_annotation/json_annotation.dart';
part 'create_user_visit_machine_viewcontroller.g.dart';

@JsonSerializable()
class CreateUserVisitMachineViewController {
  final List<String> machineIds;
  final DateTime visitDay;

  CreateUserVisitMachineViewController({
    this.machineIds = const [],
    required this.visitDay,
  });

  factory CreateUserVisitMachineViewController.fromJson(Map<String, dynamic> json) => _$CreateUserVisitMachineViewControllerFromJson(json);

  Map<String, dynamic> toJson() => _$CreateUserVisitMachineViewControllerToJson(this);
}
