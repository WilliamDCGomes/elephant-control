import 'money_pouch_value_list_viewcontroller.dart';

class MoneyPouchGetViewController {
  late List<MoneyPouchValueListViewController> moneyPouchValueList;
  late double fullValue;

  MoneyPouchGetViewController();

  MoneyPouchGetViewController.fromJson(Map<String, dynamic> json) {
    moneyPouchValueList = <MoneyPouchValueListViewController>[];
    for(var pouch in json["pouchs"]){
      moneyPouchValueList.add(MoneyPouchValueListViewController.fromJson(pouch));
    }
    fullValue = json["fullValue"];
  }
}