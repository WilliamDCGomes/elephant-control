import 'package:json_annotation/json_annotation.dart';
import '../../context/elephant_context.dart';
import '../base/elephant_user_core.dart';
import '../base/elephant_core.dart';
part 'reminder_machine.g.dart';

@JsonSerializable()
class ReminderMachine extends ElephantUserCore {
  late String description;
  @JsonKey(fromJson: ElephantCore.fromJsonActive)
  late bool realized;
  late String machineId;
  @JsonKey(fromJson: ElephantCore.fromJsonActive)
  late bool sent;

  static dynamic toJsonNull(dynamic value) => null;
  static bool fromJsonSent(dynamic value) => value ?? true;

  ReminderMachine({
    required this.description,
    required this.realized,
    required this.machineId,
    super.id,
  });

  static String get tableName => "REMINDERMACHINE";

  static String get scriptCreateTable => """
      CREATE TABLE IF NOT EXISTS $tableName (${ElephantContext.queryElephantModelBase},
      Description TEXT, Realized BOOLEAN, MachineId TEXT, Sent BOOLEAN,
      IncludeUserId TEXT)""";

  factory ReminderMachine.fromJson(Map<String, dynamic> json) => _$ReminderMachineFromJson(json);
  factory ReminderMachine.fromJsonRepository(Map<String, dynamic> json) =>
      _$ReminderMachineFromJson(ElephantUserCore.fromJsonRepository(json));

  Map<String, dynamic> toJson() => _$ReminderMachineToJson(this);
  Map<String, dynamic> toJsonRepository() => ElephantUserCore.toJsonCapitalize(_$ReminderMachineToJson(this));
}
