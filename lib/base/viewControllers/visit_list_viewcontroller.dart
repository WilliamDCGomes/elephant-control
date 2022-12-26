import 'package:elephant_control/base/models/base/elephant_core.dart';
import 'package:elephant_control/base/models/visit/model/visit.dart';
import 'package:json_annotation/json_annotation.dart';

part 'visit_list_viewcontroller.g.dart';

@JsonSerializable()
class VisitListViewController extends ElephantCore {
  final String priority;
  final VisitStatus status;
  final double moneyQuantity;
  final int stuffedAnimalsReplaceQuantity;
  final int stuffedAnimalsRetiredQuantity;
  final bool moneyPouchRetired;
  final String machineName;

  VisitListViewController({
    required this.priority,
    required this.status,
    required this.moneyQuantity,
    required this.stuffedAnimalsReplaceQuantity,
    required this.stuffedAnimalsRetiredQuantity,
    required this.moneyPouchRetired,
    required this.machineName,
  });

  factory VisitListViewController.fromJson(Map<String, dynamic> json) => _$VisitListViewControllerFromJson(json);

  Map<String, dynamic> toJson() => _$VisitListViewControllerToJson(this);
}
