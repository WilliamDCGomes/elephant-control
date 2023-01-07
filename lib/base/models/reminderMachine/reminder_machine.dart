import 'package:json_annotation/json_annotation.dart';
import '../../context/elephant_context.dart';
import '../base/elephant_user_core.dart';
part 'reminder_machine.g.dart';

@JsonSerializable()
class ReminderMachine extends ElephantUserCore {
  late String description;
  late bool realized;
  late String machineId;

  ReminderMachine({
    required this.description,
    required this.realized,
    required this.machineId,
    super.id,
  });

  static String get tableName => "REMINDERMACHINE";

  static String get scriptCreateTable => """
      CREATE TABLE IF NOT EXISTS $tableName (${ElephantContext.queryElephantModelBase},
      Description TEXT, Realized BOOLEAN, MachineId TEXT, Inclusion TEXT,
      IncludeUserId TEXT)""";

  factory ReminderMachine.fromJson(Map<String, dynamic> json) => _$ReminderMachineFromJson(json);

  Map<String, dynamic> toJson() => _$ReminderMachineToJson(this);
}
