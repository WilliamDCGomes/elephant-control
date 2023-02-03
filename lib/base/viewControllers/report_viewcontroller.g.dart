// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_viewcontroller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportViewController _$ReportViewControllerFromJson(
        Map<String, dynamic> json) =>
    ReportViewController()
      ..plushAdded = json['plushAdded'] as int
      ..plushRemoved = json['plushRemoved'] as int
      ..plushInTheMachine = json['plushInTheMachine'] as int
      ..machineValue = json['machineValue'] as int
      ..minimumAverageValue = (json['minimumAverageValue'] as num?)?.toDouble()
      ..maximumAverageValue = (json['maximumAverageValue'] as num?)?.toDouble()
      ..averageValue = (json['averageValue'] as num?)?.toDouble()
      ..numbersOfPouchRemoved = json['numbersOfPouchRemoved'] as int
      ..pouchCollectedDates = (json['pouchCollectedDates'] as List<dynamic>?)
          ?.map((e) => DateTime.parse(e as String))
          .toList()
      ..numbersOfTimesOutOffAverage = json['numbersOfTimesOutOffAverage'] as int
      ..numbersOfVisits = json['numbersOfVisits'] as int
      ..outOffAverageValues = (json['outOffAverageValues'] as List<dynamic>?)
          ?.map((e) => (e as num?)?.toDouble())
          .toList()
      ..outOffAverageDates = (json['outOffAverageDates'] as List<dynamic>?)
          ?.map((e) => DateTime.parse(e as String))
          .toList()
      ..visitDays = (json['visitDays'] as List<dynamic>?)
          ?.map((e) => DateTime.parse(e as String))
          .toList()
      ..operatorsWhoVisitMachines =
          (json['operatorsWhoVisitMachines'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList()
      ..operatorsWhoCollectedPouchsList =
          (json['operatorsWhoCollectedPouchsList'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList();

Map<String, dynamic> _$ReportViewControllerToJson(
        ReportViewController instance) =>
    <String, dynamic>{
      'plushAdded': instance.plushAdded,
      'plushRemoved': instance.plushRemoved,
      'plushInTheMachine': instance.plushInTheMachine,
      'machineValue': instance.machineValue,
      'minimumAverageValue': instance.minimumAverageValue,
      'maximumAverageValue': instance.maximumAverageValue,
      'averageValue': instance.averageValue,
      'numbersOfPouchRemoved': instance.numbersOfPouchRemoved,
      'pouchCollectedDates': instance.pouchCollectedDates
          ?.map((e) => e.toIso8601String())
          .toList(),
      'numbersOfTimesOutOffAverage': instance.numbersOfTimesOutOffAverage,
      'numbersOfVisits': instance.numbersOfVisits,
      'outOffAverageValues': instance.outOffAverageValues,
      'outOffAverageDates':
          instance.outOffAverageDates?.map((e) => e.toIso8601String()).toList(),
      'visitDays': instance.visitDays?.map((e) => e.toIso8601String()).toList(),
      'operatorsWhoVisitMachines': instance.operatorsWhoVisitMachines,
      'operatorsWhoCollectedPouchsList':
          instance.operatorsWhoCollectedPouchsList,
    };
