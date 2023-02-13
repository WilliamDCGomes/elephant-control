import 'package:json_annotation/json_annotation.dart';
import '../models/media/media.dart';
import '../models/visitMedia/visit_media.dart';
part 'visit_media_h_viewcontroller.g.dart';

@JsonSerializable()
class VisitMediaHViewController {
  String? media;
  String? mediaId;
  late MediaType type;
  String? visitId;
  String? incidentId;
  MediaExtension? extension;

  VisitMediaHViewController({
    this.media,
    this.mediaId,
    required this.type,
    required this.visitId,
    required this.extension,
  });
  factory VisitMediaHViewController.fromJson(Map<String, dynamic> json) => _$VisitMediaHViewControllerFromJson(json);

  Map<String, dynamic> toJson() => _$VisitMediaHViewControllerToJson(this);
}
