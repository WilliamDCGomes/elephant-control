import 'package:json_annotation/json_annotation.dart';
import '../../context/elephant_context.dart';
import '../base/elephant_user_core.dart';
import '../media/media.dart';
part 'visit_media.g.dart';

@JsonSerializable()
class VisitMedia extends ElephantUserCore {
  String? base64;
  String? mediaId;
  late MediaType type;
  String? visitId;
  String? incidentId;
  MediaExtension? extension;

  VisitMedia({
    this.base64,
    this.mediaId,
    required this.type,
    required this.visitId,
    required this.extension,
  });

  static String get tableName => "VISITMEDIA";

  static String get scriptCreateTable => """
      CREATE TABLE IF NOT EXISTS $tableName (${ElephantContext.queryElephantModelBase},
      Type INTEGER, VisitId TEXT, MediaId TEXT, Inclusion TEXT, IncludeUserId TEXT)""";

  factory VisitMedia.fromJson(Map<String, dynamic> json) => _$VisitMediaFromJson(json);

  Map<String, dynamic> toJson() => _$VisitMediaToJson(this);
}

enum MediaType {
  @JsonValue(0)
  stuffedAnimals,
  @JsonValue(1)
  moneyWatch,
  @JsonValue(2)
  machineBefore,
  @JsonValue(3)
  machineAfter,
  @JsonValue(4)
  firstOccurrencePicture,
  @JsonValue(5)
  secondOccurrencePicture,
  @JsonValue(6)
  occurrenceVideo,
}
