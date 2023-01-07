import 'package:json_annotation/json_annotation.dart';
import '../../context/elephant_context.dart';
import '../base/elephant_user_core.dart';
part 'user_visit_machine.g.dart';

@JsonSerializable()
class UserVisitMachine extends ElephantUserCore {
  late String userId;
  late String machineId;
  late DateTime visitDay;

  UserVisitMachine({
    required this.userId,
    required this.machineId,
    required this.visitDay,
  });

  static String get tableName => "USERVISITMACHINE";

  static String get scriptCreateTable => """
      CREATE TABLE IF NOT EXISTS $tableName (${ElephantContext.queryElephantModelBase},
      VisitDay TEXT, UserId TEXT, MachineId TEXT, Inclusion TEXT,
      IncludeUserId TEXT, VisitId TEXT)""";

  factory UserVisitMachine.fromJson(Map<String, dynamic> json) => _$UserVisitMachineFromJson(json);

  Map<String, dynamic> toJson() => _$UserVisitMachineToJson(this);
}
