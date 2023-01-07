import 'package:json_annotation/json_annotation.dart';
import '../../context/elephant_context.dart';
import '../base/elephant_user_core.dart';
part 'user_machine.g.dart';

@JsonSerializable()
class UserMachine extends ElephantUserCore {
  late String userId;
  late String machineId;

  UserMachine({
    required this.userId,
    required this.machineId,
  });

  static String get tableName => "USERMACHINE";

  static String get scriptCreateTable => """
      CREATE TABLE IF NOT EXISTS $tableName (${ElephantContext.queryElephantModelBase},
      MachineId TEXT, Inclusion TEXT, IncludeUserId TEXT, UserId TEXT)""";

  factory UserMachine.fromJson(Map<String, dynamic> json) => _$UserMachineFromJson(json);

  Map<String, dynamic> toJson() => _$UserMachineToJson(this);
}