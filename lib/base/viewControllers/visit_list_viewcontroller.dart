import 'package:elephant_control/base/models/base/elephant_core.dart';
import 'package:elephant_control/base/models/visit/visit.dart';
import 'package:json_annotation/json_annotation.dart';
import '../models/base/elephant_user_core.dart';

part 'visit_list_viewcontroller.g.dart';

@JsonSerializable()
class VisitListViewController extends ElephantUserCore {
  final String priority;
  VisitStatus? status;
  final double moneyQuantity;
  final double stuffedAnimalsReplaceQuantity;
  final double stuffedAnimalsQuantity;
  @JsonKey(fromJson: ElephantCore.fromJsonActive)
  final bool moneyPouchRetired;
  final String machineName;
  @JsonKey(fromJson: ElephantCore.fromJsonActive)
  bool? realizedVisit;

  VisitListViewController({
    required this.priority,
    required this.status,
    required this.moneyQuantity,
    required this.stuffedAnimalsReplaceQuantity,
    required this.stuffedAnimalsQuantity,
    required this.moneyPouchRetired,
    required this.machineName,
    this.realizedVisit,
  });

  factory VisitListViewController.fromJson(Map<String, dynamic> json) => _$VisitListViewControllerFromJson(json);

  factory VisitListViewController.fromJsonRepository(Map<String, dynamic> json) =>
      _$VisitListViewControllerFromJson(ElephantUserCore.fromJsonRepository(json));

  Map<String, dynamic> toJson() => _$VisitListViewControllerToJson(this);
}
