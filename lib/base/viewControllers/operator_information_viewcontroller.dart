import 'package:elephant_control/base/models/visit/visit.dart';
import 'package:json_annotation/json_annotation.dart';

part 'operator_information_viewcontroller.g.dart';

@JsonSerializable()
class OperatorInformationViewController {
  final List<Visit> visitsUser;
  final List<Visit> visitsWithMoneydrawal;
  final int balanceMoney;
  final DateTime? pouchLastUpdate;
  final int balanceStuffedAnimals;
  final DateTime? stuffedAnimalsLastUpdate;

  OperatorInformationViewController({
    required this.visitsUser,
    required this.visitsWithMoneydrawal,
    required this.balanceMoney,
    required this.pouchLastUpdate,
    required this.balanceStuffedAnimals,
    required this.stuffedAnimalsLastUpdate,
  });

  factory OperatorInformationViewController.fromJson(Map<String, dynamic> json) => _$OperatorInformationViewControllerFromJson(json);

  Map<String, dynamic> toJson() => _$OperatorInformationViewControllerToJson(this);
}
