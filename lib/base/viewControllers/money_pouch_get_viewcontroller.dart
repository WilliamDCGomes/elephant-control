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
  late String userName;
  late DateTime alteration;
  late double moneyQuantity;

  MoneyPouchValueList();

  MoneyPouchValueList.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    userName = json["userName"];
    alteration = DateTime.parse(json["alteration"]);
    moneyQuantity = json["moneyQuantity"];
  }
}

