import 'package:json_annotation/json_annotation.dart';

part 'report_viewcontroller.g.dart';

@JsonSerializable()
class ReportViewController {
  late int plushAdded;
  late int plushRemoved;
  late int plushInTheMachine;
  late int machineValue;
  late double? minimumAverageValue;
  late double? maximumAverageValue;
  late double? averageValue;
  late int numbersOfPouchRemoved;
  late List<DateTime>? pouchCollectedDates;
  late int numbersOfTimesOutOffAverage;
  late int numbersOfVisits;
  late List<double?>? outOffAverageValues;
  late List<DateTime>? outOffAverageDates;
  late List<DateTime>? visitDays;
  late List<String>? operatorsWhoVisitMachines;
  late List<String>? operatorsWhoCollectedPouchsList;

  ReportViewController();

  factory ReportViewController.fromJson(Map<String, dynamic> json) => _$ReportViewControllerFromJson(json);

  Map<String, dynamic> toJson() => _$ReportViewControllerToJson(this);
}