import 'package:elephant_control/base/models/base/elephant_core.dart';
import 'package:json_annotation/json_annotation.dart';
part 'media.g.dart';

@JsonSerializable()
class Media extends ElephantCore {
  late String base64;
  late String name;
  late MediaExtension extension;

  Media({
    required this.base64,
    required this.name,
    required this.extension,
  });

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
