// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visits_of_operators_viewcontroller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisitOfOperatorsViewController _$VisitOfOperatorsViewControllerFromJson(
        Map<String, dynamic> json) =>
    VisitOfOperatorsViewController()
      ..visitId = json['visitId'] as String
      ..machineName = json['machineName'] as String
      ..operatorName = json['operatorName'] as String
      ..visitDate = DateTime.parse(json['visitDate'] as String)
      ..firstClock = (json['firstClock'] as num).toDouble()
      ..secondClock = json['secondClock'] as int?
      ..addedProducts = json['addedProducts'] as int
      ..visitStatus = $enumDecode(_$VisitStatusEnumMap, json['visitStatus'])
      ..periodDaysToVisit = json['periodDaysToVisit'] as int?
      ..lastMachineVisit = json['lastMachineVisit'] == null
          ? null
          : DateTime.parse(json['lastMachineVisit'] as String)
      ..visitedMachine = json['visitedMachine'] as String
      ..vInclusion = DateTime.parse(json['vInclusion'] as String);

Map<String, dynamic> _$VisitOfOperatorsViewControllerToJson(
        VisitOfOperatorsViewController instance) =>
    <String, dynamic>{
      'visitId': instance.visitId,
      'machineName': instance.machineName,
      'operatorName': instance.operatorName,
      'visitDate': instance.visitDate.toIso8601String(),
      'firstClock': instance.firstClock,
      'secondClock': instance.secondClock,
      'addedProducts': instance.addedProducts,
      'visitStatus': _$VisitStatusEnumMap[instance.visitStatus]!,
      'periodDaysToVisit': instance.periodDaysToVisit,
      'lastMachineVisit': instance.lastMachineVisit?.toIso8601String(),
      'visitedMachine': instance.visitedMachine,
      'vInclusion': instance.vInclusion.toIso8601String(),
    };

const _$VisitStatusEnumMap = {
  VisitStatus.realized: 0,
  VisitStatus.moneyWithdrawal: 1,
  VisitStatus.moneyPouchLaunched: 2,
  VisitStatus.finished: 3,
  VisitStatus.noStatus: 4,
  VisitStatus.solicitationPending: 5,
};
