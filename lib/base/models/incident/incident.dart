import 'package:json_annotation/json_annotation.dart';
import '../../context/elephant_context.dart';
import '../base/elephant_user_core.dart';
import '../base/elephant_core.dart';
part 'incident.g.dart';

@JsonSerializable()
class Incident extends ElephantUserCore {
  String? description;
  late int code;
  late IncidentStatus status;
  late String responsibleUserId;
  late String operatorUserId;
  late String machineId;
  late String visitId;
  @JsonKey(fromJson: fromJsonSent)
  late bool sent;

  static bool fromJsonSent(dynamic value) => value ?? true;

  Incident({
    this.description,
    required this.status,
    required this.machineId,
    required this.visitId,
    this.sent = true,
  });

  static String get tableName => "INCIDENT";

  static String get scriptCreateTable => """
      CREATE TABLE IF NOT EXISTS $tableName (${ElephantContext.queryElephantModelBase},
      Description TEXT, Code INTEGER, Status INTEGER, ResponsibleUserId TEXT,
      OperatorUserId TEXT, MachineId TEXT, VisitId TEXT, Sent BOOLEAN,
      IncludeUserId TEXT)""";

  factory Incident.fromJson(Map<String, dynamic> json) => _$IncidentFromJson(json);

  factory Incident.fromJsonRepository(Map<String, dynamic> json) =>
      _$IncidentFromJson(ElephantUserCore.fromJsonRepository(json));

  Map<String, dynamic> toJson() => _$IncidentToJson(this);

  Map<String, dynamic> toJsonRepository() => ElephantUserCore.toJsonCapitalize(_$IncidentToJson(this));
}

enum IncidentStatus {
  @JsonValue(0)
  realized,
  @JsonValue(1)
  finished,
}
