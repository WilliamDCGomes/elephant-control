import 'package:json_annotation/json_annotation.dart';
import '../../context/elephant_context.dart';
import '../base/elephant_user_core.dart';
part 'incident.g.dart';

@JsonSerializable()
class Incident extends ElephantUserCore {
  String? description;
  late IncidentStatus status;
  late String responsibleUserId;
  late String operatorUserId;
  late String machineId;
  late String visitId;

  Incident({
    this.description,
    required this.status,
    required this.machineId,
    required this.visitId,
  });

  static String get tableName => "INCIDENT";

  static String get scriptCreateTable => """
      CREATE TABLE IF NOT EXISTS $tableName (${ElephantContext.queryElephantModelBase},
      Description TEXT, Code INTEGER, Status INTEGER, ResponsibleUserId TEXT,
      OperatorUserId TEXT, MachineId TEXT, VisitId TEXT, Inclusion TEXT,
      IncludeUserId TEXT)""";

  factory Incident.fromJson(Map<String, dynamic> json) => _$IncidentFromJson(json);

  Map<String, dynamic> toJson() => _$IncidentToJson(this);
}

enum IncidentStatus {
  @JsonValue(0)
  realized,
  @JsonValue(1)
  finished,
}