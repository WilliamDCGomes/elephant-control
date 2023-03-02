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
  late double? creditValue;
  late double? debitValue;
  late double? pixValue;
  late double? totalPouchValue;
  late int numbersOfPouchRemoved;
  late List<DateTime>? pouchCollectedDates;
  late int numbersOfTimesOutOffAverage;
  late int numbersOfVisits;
  late List<double?>? outOffAverageValues;
  late List<DateTime>? outOffAverageDates;
  late List<DateTime>? visitDays;
  late List<String>? operatorsWhoVisitMachines;
  late List<String>? operatorsWhoCollectedPouchsList;
  late List<String>? machineReportInformation;

  List<Map<String, String>> get getMachineName {
    List<Map<String, String>> tempList = <Map<String, String>>[];
    if(machineReportInformation != null && machineReportInformation!.isNotEmpty){
      for(var machineReport in machineReportInformation!){
        var value = machineReport.split(';');
        if(value.length == 5){
          tempList.add(
            {
              "machineName": value[0],
              "firstMoneyQuantity": value[1],
              "firstMachineDate": value[2],
              "secondMoneyQuantity": value[3],
              "secondMachineDate": value[4],
            },
          );
        }
      }
    }
    return tempList;
  }

  ReportViewController();

  factory ReportViewController.fromJson(Map<String, dynamic> json) => _$ReportViewControllerFromJson(json);

  Map<String, dynamic> toJson() => _$ReportViewControllerToJson(this);
}
