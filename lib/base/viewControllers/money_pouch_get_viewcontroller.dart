class MoneyPouchGetViewController {
  late List<MoneyPouchValueList> moneyPouchValueList;
  late double fullValue;

  MoneyPouchGetViewController();

  MoneyPouchGetViewController.fromJson(Map<String, dynamic> json) {
    moneyPouchValueList = <MoneyPouchValueList>[];
    for(var pouch in json["pouchs"]){
      moneyPouchValueList.add(MoneyPouchValueList.fromJson(pouch));
    }
    fullValue = json["fullValue"];
  }
}

class MoneyPouchValueList {
  late String name;
  late DateTime alteration;
  late double moneyQuantity;

  MoneyPouchValueList();

  MoneyPouchValueList.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    alteration = DateTime.parse(json["alteration"]);
    moneyQuantity = json["moneyQuantity"];
  }
}

