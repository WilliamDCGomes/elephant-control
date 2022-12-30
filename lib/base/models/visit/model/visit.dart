import 'package:elephant_control/base/models/base/elephant_core.dart';
import 'package:elephant_control/base/models/machine/model/machine.dart';
import 'package:elephant_control/base/models/moneyPouch/model/money_pouch.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'visit.g.dart';

@JsonSerializable()
class Visit extends ElephantCore {
  late double moneyQuantity;
  double? moneyWithdrawalQuantity;
  late int stuffedAnimalsQuantity;
  late int stuffedAnimalsReplaceQuantity;
  String? latitude;
  String? longitude;
  late VisitStatus status;
  late String machineId;
  late bool moneyWithDrawal;
  int? code;
  String? observation;
  MoneyPouch? moneyPouch;
  Machine? machine;
  String? responsibleUserId;
  @JsonKey(ignore: true)
  bool checked = false;

  static String? toJsonNull(dynamic value) => null;

  Visit({
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
    required this.responsibleUserId,
    required this.stuffedAnimalsReplaceQuantity,
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
  realized("Realizada"),
  @JsonValue(1)
  moneyWithdrawal("Malote retirado"),
  @JsonValue(2)
  moneyPouchLaunched("Malote lançado"),
  @JsonValue(3)
  finished("Finalizada"),
  @JsonValue(4)
  noStatus("Não Informado");

  final String description;
  const VisitStatus(this.description);
}
