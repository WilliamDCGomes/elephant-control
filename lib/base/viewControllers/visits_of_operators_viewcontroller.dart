import 'package:elephant_control/base/models/visit/visit.dart';
import 'package:json_annotation/json_annotation.dart';

part 'visits_of_operators_viewcontroller.g.dart';

@JsonSerializable()
class VisitOfOperatorsViewController {
  late String visitId;
  late String machineName;
  late String operatorName;
  late DateTime visitDate;
  late double firstClock;
  late int? secondClock;
  late int addedProducts;
  late VisitStatus visitStatus;
  late int? periodDaysToVisit;
  late DateTime? lastMachineVisit;
  late String visitedMachine;

  VisitOfOperatorsViewController();

  factory VisitOfOperatorsViewController.fromJson(Map<String, dynamic> json) => _$VisitOfOperatorsViewControllerFromJson(json);

  Map<String, dynamic> toJson() => _$VisitOfOperatorsViewControllerToJson(this);
}
