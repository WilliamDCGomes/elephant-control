import 'package:elephant_control/base/models/base/elephant_core.dart';
import 'package:json_annotation/json_annotation.dart';
part 'reminder.g.dart';

@JsonSerializable()
class Reminder extends ElephantCore {
  late String description;
  late bool realized;
  final String machineId;

  Reminder({required this.description, required this.realized, required this.machineId, super.id});

  factory Reminder.fromJson(Map<String, dynamic> json) => _$ReminderFromJson(json);

  Map<String, dynamic> toJson() => _$ReminderToJson(this);
}
