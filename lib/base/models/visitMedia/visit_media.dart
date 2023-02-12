import 'package:json_annotation/json_annotation.dart';
import '../base/elephant_user_core.dart';
import '../../context/elephant_context.dart';
import '../media/media.dart';
import '../base/elephant_core.dart';

part 'visit_media.g.dart';

@JsonSerializable()
class VisitMedia extends ElephantUserCore {
  late MediaType type;
  late String visitId;
  late MediaExtension extension;
  late String media;
  @JsonKey(fromJson: fromJsonSent)
  late bool sent;

  VisitMedia({
    required this.type,
    required this.visitId,
    required this.media,
    required this.extension,
    super.id,
    super.inclusion,
    super.alteration,
    this.sent = true,
  });

  static bool fromJsonSent(dynamic value) => value is int ? value == 1 : value ?? true;

  static String get tableName => "VISITMEDIA";

  static String get scriptCreateTable => """
      CREATE TABLE IF NOT EXISTS $tableName (${ElephantContext.queryElephantModelBase},
      Type INTEGER, VisitId TEXT, Extension INTEGER, Media BLOB, Sent BOOLEAN, IncludeUserId TEXT)""";

  factory VisitMedia.fromJson(Map<String, dynamic> json) => _$VisitMediaFromJson(json);

  factory VisitMedia.fromJsonRepository(Map<String, dynamic> json) =>
      _$VisitMediaFromJson(ElephantUserCore.fromJsonRepository(json));

  Map<String, dynamic> toJson() => _$VisitMediaToJson(this);

  Map<String, dynamic> toJsonRepository() => ElephantUserCore.toJsonCapitalize(_$VisitMediaToJson(this));
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
}
