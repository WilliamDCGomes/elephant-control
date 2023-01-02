import 'package:json_annotation/json_annotation.dart';

part 'money_pouch_value_list_viewcontroller.g.dart';

@JsonSerializable()
class MoneyPouchValueListViewController {
  late String name;
  late String userName;
  late DateTime alteration;
  late double moneyQuantity;

  MoneyPouchValueListViewController();

  factory MoneyPouchValueListViewController.fromJson(Map<String, dynamic> json) => _$MoneyPouchValueListViewControllerFromJson(json);

  Map<String, dynamic> toJson() => _$MoneyPouchValueListViewControllerToJson(this);
}