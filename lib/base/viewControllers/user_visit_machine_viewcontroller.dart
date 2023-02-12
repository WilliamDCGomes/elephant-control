import 'package:elephant_control/base/models/reminderMachine/reminder_machine.dart';
import 'package:json_annotation/json_annotation.dart';

import '../models/base/elephant_user_core.dart';
part 'user_visit_machine_viewcontroller.g.dart';

@JsonSerializable()
class UserVisitMachineViewController {
  late String machineId;
  late String machineName;
  late String id;
  late DateTime visitDay;
  DateTime? lastVisit;
  @JsonKey(defaultValue: <ReminderMachine>[])
  late List<ReminderMachine> reminders;

  UserVisitMachineViewController({
    required this.machineId,
    required this.machineName,
    required this.id,
    required this.visitDay,
    required this.lastVisit,
    required this.reminders,
  });

  factory UserVisitMachineViewController.fromJson(Map<String, dynamic> json) =>
      _$UserVisitMachineViewControllerFromJson(json);

  factory UserVisitMachineViewController.fromJsonRepository(Map<String, dynamic> json) =>
      _$UserVisitMachineViewControllerFromJson(ElephantUserCore.fromJsonRepository(json));

  Map<String, dynamic> toJson() => _$UserVisitMachineViewControllerToJson(this);
}
