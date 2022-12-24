import 'package:json_annotation/json_annotation.dart';
part 'user_machine_viewcontroller.g.dart';

@JsonSerializable()
class UserMachineViewController {
  final String userId;
  final String machineId;

  UserMachineViewController({
    required this.userId,
    required this.machineId,
  });

  factory UserMachineViewController.fromJson(Map<String, dynamic> json) => _$UserMachineViewControllerFromJson(json);

  Map<String, dynamic> toJson() => _$UserMachineViewControllerToJson(this);
}
