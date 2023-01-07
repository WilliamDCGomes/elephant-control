import 'package:elephant_control/base/models/visitMedia/visit_media.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../context/elephant_context.dart';
import '../base/elephant_user_core.dart';
part 'incident_media.g.dart';

@JsonSerializable()
class IncidentMedia extends ElephantUserCore {
  late String incidentId;
  late MediaType type;
  late String mediaId;

  IncidentMedia({
    required this.incidentId,
    required this.type,
    required this.mediaId,
  });

  static String get tableName => "INCIDENTMEDIA";

  static String get scriptCreateTable => """
      CREATE TABLE IF NOT EXISTS $tableName (${ElephantContext.queryElephantModelBase},
      Type INTEGER, IncidentId TEXT, MediaId TEXT, Inclusion TEXT, 
      IncludeUserId TEXT)""";

  factory IncidentMedia.fromJson(Map<String, dynamic> json) => _$IncidentMediaFromJson(json);

  Map<String, dynamic> toJson() => _$IncidentMediaToJson(this);
}
