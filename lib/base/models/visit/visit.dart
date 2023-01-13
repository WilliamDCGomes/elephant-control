import 'package:elephant_control/base/models/machine/machine.dart';
import 'package:elephant_control/base/models/moneyPouch/money_pouch.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../context/elephant_context.dart';
import '../base/elephant_user_core.dart';

part 'visit.g.dart';

@JsonSerializable()
class Visit extends ElephantUserCore {
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
  String? moneyPouchId;
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

  static String get tableName => "VISIT";

  static String get scriptCreateTable => """
      CREATE TABLE IF NOT EXISTS $tableName (${ElephantContext.queryElephantModelBase},
      MoneyQuantity DECIMAL, StuffedAnimalsQuantity INTEGER, Latitude TEXT,
      Longitude TEXT, Status INTEGER, ResponsibleUserId TEXT, MachineId TEXT,
      Inclusion TEXT, IncludeUserId TEXT, MoneyWithdrawalQuantity DECIMAL,
      MoneyPouchId TEXT, Code INTEGER, StuffedAnimalsReplaceQuantity INTEGER,
      Observation TEXT)""";

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
  noStatus("Não Informado"),
  @JsonValue(5)
  solicitationPending("Solicitação para retirada de dinheiro pendente");

  final String description;
  const VisitStatus(this.description);
}
