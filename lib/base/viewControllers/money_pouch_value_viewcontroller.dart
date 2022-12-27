import 'package:json_annotation/json_annotation.dart';

part 'money_pouch_value_viewcontroller.g.dart';

@JsonSerializable()
class MoneyPouchValueViewController {
  final double value;
  final int quantity;
  final DateTime lastUpdateQuantity;
  final DateTime lastUpdateValue;

  MoneyPouchValueViewController({
    required this.value,
    required this.quantity,
    required this.lastUpdateQuantity,
    required this.lastUpdateValue,
  });

  factory MoneyPouchValueViewController.fromJson(Map<String, dynamic> json) => _$MoneyPouchValueViewControllerFromJson(json);

  Map<String, dynamic> toJson() => _$MoneyPouchValueViewControllerToJson(this);
}
