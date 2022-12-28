import 'package:elephant_control/base/models/base/elephant_core.dart';
import 'package:json_annotation/json_annotation.dart';
part 'incident.g.dart';

@JsonSerializable()
class Incident extends ElephantCore {
  String? description;
  late IncidentStatus status;
  late String machineId;
  late String visitId;

  Incident({
    this.description,
    required this.status,
    required this.machineId,
    required this.visitId,
  });

  factory Incident.fromJson(Map<String, dynamic> json) => _$IncidentFromJson(json);

  Map<String, dynamic> toJson() => _$IncidentToJson(this);
}

enum IncidentStatus {
  @JsonValue(0)
  realized,
  @JsonValue(1)
  finished,
}
