import 'package:elephant_control/base/models/base/elephant_core.dart';
import 'package:json_annotation/json_annotation.dart';

import 'media.dart';
part 'visit_media.g.dart';

@JsonSerializable()
class VisitMedia extends ElephantCore {
  late String base64;
  late MediaType type;
  late String visitId;
  late MediaExtension extension;

  VisitMedia({
    required this.base64,
    required this.type,
    required this.visitId,
    required this.extension,
  });

  factory VisitMedia.fromJson(Map<String, dynamic> json) => _$VisitMediaFromJson(json);

  Map<String, dynamic> toJson() => _$VisitMediaToJson(this);
}

enum MediaType {
  @JsonValue(0)
  stuffedAnimals,
  @JsonValue(1)
  moneyWatch,
  @JsonValue(2)
  machine,
}
