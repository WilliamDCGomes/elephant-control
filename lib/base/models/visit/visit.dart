import 'package:elephant_control/base/models/machine/machine.dart';
import 'package:elephant_control/base/models/moneyPouch/money_pouch.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../context/elephant_context.dart';
import '../base/elephant_user_core.dart';
import '../base/elephant_core.dart';

part 'visit.g.dart';

@JsonSerializable()
class Visit extends ElephantUserCore {
  late double moneyQuantity;
  double? moneyWithdrawalQuantity;
  late int stuffedAnimalsQuantity;
  late int stuffedAnimalsReplaceQuantity;
  String? latitude;
  String? longitude;
  int? code;
  late VisitStatus status;
  String? observation;
  DateTime? lastVisitMachineCurrentDay;
  String? responsibleUserId;
  @JsonKey(fromJson: ElephantCore.fromJsonActive)
  late bool offline;
  double? lastPrizeMachine;
  late String machineId;
  Machine? machine;
  String? moneyPouchId;
  MoneyPouch? moneyPouch;
  @JsonKey(fromJson: ElephantCore.fromJsonActive)
  late bool monthClosure;
  @JsonKey(fromJson: ElephantCore.fromJsonActive)
  late bool moneyWithDrawal;
  @JsonKey(fromJson: fromJsonSent, toJson: toJsonNull)
  late bool sent;
  @JsonKey(toJson: toJsonNull)
  double? debit;
  @JsonKey(toJson: toJsonNull)
  double? credit;
  @JsonKey(ignore: true)
  bool checked = false;

  static String? toJsonNull(dynamic value) => null;

  static bool fromJsonSent(dynamic value) => value is int ? value == 1 : value ?? true;

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
    required this.moneyPouchId,
    required this.lastVisitMachineCurrentDay,
    required this.offline,
    this.sent = true,
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
      IncludeUserId TEXT, MoneyWithdrawalQuantity DECIMAL,
      MoneyPouchId TEXT, Code INTEGER, StuffedAnimalsReplaceQuantity INTEGER,
      Observation TEXT, MoneyWithDrawal INTEGER, LastVisitMachineCurrentDay TEXT, Sent BOOLEAN,
      LastPrizeMachine DECIMAL, Offline BOOLEAN, MonthClosure BOOLEAN)""";

  factory Visit.fromJson(Map<String, dynamic> json) => _$VisitFromJson(json);

  factory Visit.fromJsonRepository(Map<String, dynamic> json) => _$VisitFromJson(ElephantUserCore.fromJsonRepository(json));

  Map<String, dynamic> toJson() => _$VisitToJson(this);

  Map<String, dynamic> toJsonRepository(bool sent) {
    final json = _$VisitToJson(this);
    json.remove("machine");
    json.remove("moneyPouch");
    json.remove("debit");
    json.remove("credit");
    json['sent'] = sent;
    return ElephantUserCore.toJsonCapitalize(json);
  }
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
