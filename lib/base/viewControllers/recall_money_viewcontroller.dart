import 'package:json_annotation/json_annotation.dart';
part 'recall_money_viewcontroller.g.dart';

@JsonSerializable()
class RecallMoneyViewController {
  final String name;
  final String id;
  final double totalValue;

  RecallMoneyViewController({required this.name, required this.id, required this.totalValue});

  factory RecallMoneyViewController.fromJson(Map<String, dynamic> json) => _$RecallMoneyViewControllerFromJson(json);

  Map<String, dynamic> toJson() => _$RecallMoneyViewControllerToJson(this);
}
