import 'package:elephant_control/base/models/base/elephant_core.dart';
import 'package:elephant_control/base/models/visit/visit.dart';
import 'package:json_annotation/json_annotation.dart';

part 'visit_list_viewcontroller.g.dart';

@JsonSerializable()
class VisitListViewController extends ElephantCore {
  final String priority;
  final String responsibleName;
  VisitStatus? status;
  final double moneyQuantity;
  final double stuffedAnimalsReplaceQuantity;
  final double stuffedAnimalsQuantity;
  final bool moneyPouchRetired;
  final String machineName;
  bool? realizedVisit;
  String? latitude;
  String? longitude;

  VisitListViewController({
    required this.priority,
    required this.responsibleName,
    required this.status,
    required this.moneyQuantity,
    required this.stuffedAnimalsReplaceQuantity,
    required this.stuffedAnimalsQuantity,
    required this.moneyPouchRetired,
    required this.machineName,
    this.realizedVisit,
    this.latitude,
    this.longitude,
  });

  factory VisitListViewController.fromJson(Map<String, dynamic> json) => _$VisitListViewControllerFromJson(json);

  Map<String, dynamic> toJson() => _$VisitListViewControllerToJson(this);
}
