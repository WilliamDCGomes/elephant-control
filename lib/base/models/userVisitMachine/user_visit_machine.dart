import 'package:json_annotation/json_annotation.dart';
import '../../context/elephant_context.dart';
import '../base/elephant_core.dart';
import '../base/elephant_user_core.dart';
part 'user_visit_machine.g.dart';

@JsonSerializable()
class UserVisitMachine extends ElephantUserCore {
  late String userId;
  late String machineId;
  late DateTime visitDay;
  @JsonKey(fromJson: fromJsonSent)
  late bool sent;
  String? visitId;

  static bool fromJsonSent(dynamic value) => value is int ? value == 1 : value ?? true;

  UserVisitMachine({
    required this.userId,
    required this.machineId,
    required this.visitDay,
    this.sent = true,
    this.visitId,
    super.id,
    super.inclusion,
    super.active,
    super.alteration,
  });

  static String get tableName => "USERVISITMACHINE";

  static String get scriptCreateTable => """
      CREATE TABLE IF NOT EXISTS $tableName (${ElephantContext.queryElephantModelBase},
      VisitDay TEXT, UserId TEXT, MachineId TEXT,
      IncludeUserId TEXT, VisitId TEXT, Sent BOOLEAN)""";

  factory UserVisitMachine.fromJson(Map<String, dynamic> json) => _$UserVisitMachineFromJson(json);

  factory UserVisitMachine.fromJsonRepository(Map<String, dynamic> json) =>
      _$UserVisitMachineFromJson(ElephantUserCore.fromJsonRepository(json));

  Map<String, dynamic> toJson() => _$UserVisitMachineToJson(this);

  Map<String, dynamic> toJsonRepository() => ElephantUserCore.toJsonCapitalize(_$UserVisitMachineToJson(this));
}
