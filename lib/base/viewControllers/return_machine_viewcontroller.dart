import 'package:json_annotation/json_annotation.dart';

part 'return_machine_viewcontroller.g.dart';

@JsonSerializable()
class ReturnMachineViewController {
  int? id;
  late String asset_number;

  ReturnMachineViewController({
    this.id,
    required this.asset_number,
  });

  factory ReturnMachineViewController.fromJson(Map<String, dynamic> json) => _$ReturnMachineViewControllerFromJson(json);

  Map<String, dynamic> toJson() => _$ReturnMachineViewControllerToJson(this);
}
