import 'package:json_annotation/json_annotation.dart';
import '../../context/elephant_context.dart';
import '../base/elephant_user_core.dart';
import '../base/elephant_core.dart';
part 'media.g.dart';

@JsonSerializable()
class Media extends ElephantUserCore {
  late String base64;
  late String name;
  late MediaExtension extension;

  Media({
    required this.base64,
    required this.name,
    required this.extension,
  });

  static String get tableName => "MEDIA";

  static String get scriptCreateTable => """
      CREATE TABLE IF NOT EXISTS $tableName (${ElephantContext.queryElephantModelBase},
      Base64 TEXT, Extension INTEGER, IncludeUserId TEXT,
      Name TEXT)""";

  factory Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);

  Map<String, dynamic> toJson() => _$MediaToJson(this);
}

enum MediaExtension {
  @JsonValue(0)
  jpg,
  @JsonValue(1)
  jpeg,
  @JsonValue(2)
  png,
  @JsonValue(3)
  pdf,
  @JsonValue(4)
  mp4,
}
