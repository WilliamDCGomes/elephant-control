import 'package:elephant_control/base/models/base/elephant_core.dart';
import 'package:elephant_control/base/models/machine/model/machine.dart';
import 'package:elephant_control/base/models/moneyPouch/model/money_pouch.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'visit.g.dart';

@JsonSerializable()
class Visit extends ElephantCore {
  late int addedProducts;
  late double moneyQuantity;
  double? moneyWithdrawalQuantity;
  int? stuffedAnimalsQuantity;
  String? latitude;
  String? longitude;
  late VisitStatus status;
  late String machineId;
  late bool moneyWithDrawal;
  late int code;
  String? observation;
  MoneyPouch? moneyPouch;
  Machine? machine;
  late String responsibleUserId;
  @JsonKey(ignore: true)
  bool checked = false;

  Visit({
    required this.addedProducts,
    required this.moneyQuantity,
    required this.moneyWithdrawalQuantity,
    required this.stuffedAnimalsQuantity,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.machineId,
    required this.moneyWithDrawal,
    required this.code,
    required this.observation,
    required this.moneyPouch,
    required this.machine,
  });

  Visit.emptyConstructor() {
    id = const Uuid().v4();
    inclusion = DateTime.now();
    active = true;
  }

  factory Visit.fromJson(Map<String, dynamic> json) => _$VisitFromJson(json);

  Map<String, dynamic> toJson() => _$VisitToJson(this);
}

enum VisitStatus {
  @JsonValue(0)
  realized,
  @JsonValue(1)
  moneyWithdrawal,
  @JsonValue(2)
  moneyPouchLaunched,
  @JsonValue(3)
  finished,
}