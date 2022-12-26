import 'package:elephant_control/base/models/base/elephant_core.dart';
import 'package:elephant_control/base/models/visitMedia/model/visit_media.dart';
import 'package:json_annotation/json_annotation.dart';
part '../converter/incident_media.g.dart';

@JsonSerializable()
class IncidentMedia extends ElephantCore {
  late String incidentId;
  late MediaType type;
  late String mediaId;

  IncidentMedia({
    required this.incidentId,
    required this.type,
    required this.mediaId,
  });

  factory IncidentMedia.fromJson(Map<String, dynamic> json) => _$IncidentMediaFromJson(json);

  Map<String, dynamic> toJson() => _$IncidentMediaToJson(this);
}
