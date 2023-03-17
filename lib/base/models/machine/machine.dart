import 'package:elephant_control/base/models/reminderMachine/reminder_machine.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../context/elephant_context.dart';
import '../base/elephant_user_core.dart';
import '../base/elephant_core.dart';
part 'machine.g.dart';

@JsonSerializable()
class Machine extends ElephantUserCore {
  late String name;
  String? machineType;
  DateTime? lastVisit;
  int? daysToNextVisit;
  double? prize;
  double? lastPrize;
  double? balanceStuffedAnimals;
  double? lastBalanceStuffedAnimals;
  String? storeId;
  late String localization;
  late String longitude;
  late String latitude;
  late String cep;
  late String uf;
  late String city;
  late String address;
  late String number;
  late String district;
  late String complement;
  late double minimumAverageValue;
  late double maximumAverageValue;
  @JsonKey(defaultValue: false, fromJson: ElephantCore.fromJsonActive)
  late bool monthClosure;
  int? externalId;
  @JsonKey(fromJson: ElephantCore.fromJsonActive)
  bool? machineAddOtherList;
  List<ReminderMachine>? reminders;
  @JsonKey(ignore: true)
  late bool selected;
  @JsonKey(fromJson: fromJsonSent)
  late bool sent;

  static bool fromJsonSent(dynamic value) => value is int ? value == 1 : value ?? true;

  Machine({
    required this.name,
    this.selected = false,
    super.id,
    this.lastVisit,
    this.reminders,
    this.monthClosure = false,
    this.sent = false,
  });

  Machine.emptyConstructor() {
    id = const Uuid().v4();
    inclusion = DateTime.now();
    active = true;
  }

  static String get tableName => "MACHINE";

  static String get scriptCreateTable => """
      CREATE TABLE IF NOT EXISTS $tableName (${ElephantContext.queryElephantModelBase},
      Name TEXT, StoreId TEXT, IncludeUserId TEXT,
      LastBalanceStuffedAnimals DECIMAL, DaysToNextVisit INTEGER,
      LastVisit TEXT, Prize DECIMAL, Address TEXT, Cep TEXT,
      City TEXT, Complement TEXT, District TEXT, Latitude TEXT,
      Localization TEXT, Longitude TEXT, Number TEXT,
      Uf TEXT, MaximumAverageValue DECIMAL, MinimumAverageValue DECIMAL, Sent BOOLEAN,
      LastPrize DECIMAL, BalanceStuffedAnimals DECIMAL, ExternalId INTEGER,
      MachineAddOtherList BOOLEAN, MachineType TEXT, MonthClosure BOOLEAN)""";

  static String get migration4 => """
      ALTER TABLE $tableName ADD COLUMN MonthClosure BOOLEAN;
      """;

  factory Machine.fromJson(Map<String, dynamic> json) => _$MachineFromJson(json);

  factory Machine.fromJsonRepository(Map<String, dynamic> json) =>
      _$MachineFromJson(ElephantUserCore.fromJsonRepository(json));

  Map<String, dynamic> toJson() => _$MachineToJson(this);

  Map<String, dynamic> toJsonRepository() {
    final json = _$MachineToJson(this);
    json.remove('reminders');
    return ElephantUserCore.toJsonCapitalize(json);
  }
}
