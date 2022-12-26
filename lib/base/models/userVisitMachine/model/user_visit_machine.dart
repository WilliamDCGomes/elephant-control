import 'package:elephant_control/base/models/base/elephant_core.dart';
import 'package:json_annotation/json_annotation.dart';
part '../converter/user_visit_machine.g.dart';

@JsonSerializable()
class UserVisitMachine extends ElephantCore {
  late String userId;
  late String machineId;
  late DateTime visitDay;

  UserVisitMachine({
    required this.userId,
    required this.machineId,
    required this.visitDay,
  });

  factory UserVisitMachine.fromJson(Map<String, dynamic> json) => _$UserVisitMachineFromJson(json);

  Map<String, dynamic> toJson() => _$UserVisitMachineToJson(this);
}
