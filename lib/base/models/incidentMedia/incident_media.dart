import 'package:elephant_control/base/models/visitMedia/visit_media.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../context/elephant_context.dart';
import '../base/elephant_user_core.dart';
import '../media/media.dart';
import '../base/elephant_core.dart';

part 'incident_media.g.dart';

@JsonSerializable()
class IncidentMedia extends ElephantUserCore {
  late String incidentId;
  late MediaType type;
  late MediaExtension extension;
  late String media;
  @JsonKey(fromJson: fromJsonSent)
  late bool sent;

  static bool fromJsonSent(dynamic value) => value is int ? value == 1 : value ?? true;

  IncidentMedia({
    required this.incidentId,
    required this.type,
    required this.media,
    required this.extension,
    required this.sent,
    super.id,
    super.inclusion,
    super.alteration,
  });

  static String get tableName => "INCIDENTMEDIA";

  static String get scriptCreateTable => """
      CREATE TABLE IF NOT EXISTS $tableName (${ElephantContext.queryElephantModelBase},
      Type INTEGER, IncidentId TEXT, Extension INTEGER, Media BLOB, Sent BOOLEAN,
      IncludeUserId TEXT)""";

  factory IncidentMedia.fromJson(Map<String, dynamic> json) => _$IncidentMediaFromJson(json);

  factory IncidentMedia.fromJsonRepository(Map<String, dynamic> json) =>
      _$IncidentMediaFromJson(ElephantUserCore.fromJsonRepository(json));

  Map<String, dynamic> toJson() => _$IncidentMediaToJson(this);

  Map<String, dynamic> toJsonRepository() => ElephantUserCore.toJsonCapitalize(_$IncidentMediaToJson(this));
}
