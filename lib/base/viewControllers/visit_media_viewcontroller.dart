import 'package:json_annotation/json_annotation.dart';
import '../models/visitMedia/visit_media.dart';

part 'visit_media_viewcontroller.g.dart';

@JsonSerializable()
class VisitMediaViewController {
  late String image;
  late MediaType visitType;
  late DateTime inclusion;

  VisitMediaViewController({
    required this.image,
    required this.visitType,
    required this.inclusion,
  });

  VisitMediaViewController.emptyConstructor();

  factory VisitMediaViewController.fromJson(Map<String, dynamic> json) => _$VisitMediaViewControllerFromJson(json);

  Map<String, dynamic> toJson() => _$VisitMediaViewControllerToJson(this);
}