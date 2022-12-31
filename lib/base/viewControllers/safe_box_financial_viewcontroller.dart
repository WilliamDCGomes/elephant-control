import 'package:json_annotation/json_annotation.dart';

part 'safe_box_financial_viewcontroller.g.dart';

@JsonSerializable()
class SafeBoxFinancialViewController {
  late String visitId;
  late String machineName;
  late String operatorName;
  late double? moneyWithDrawalQuantity;
  late DateTime receiveDate;

  SafeBoxFinancialViewController();

  factory SafeBoxFinancialViewController.fromJson(Map<String, dynamic> json) => _$SafeBoxFinancialViewControllerFromJson(json);

  Map<String, dynamic> toJson() => _$SafeBoxFinancialViewControllerToJson(this);
}