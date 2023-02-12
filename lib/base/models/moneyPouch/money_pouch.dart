import 'package:json_annotation/json_annotation.dart';
import '../../context/elephant_context.dart';
import '../base/elephant_user_core.dart';
import '../base/elephant_core.dart';

part 'money_pouch.g.dart';

@JsonSerializable()
class MoneyPouch extends ElephantUserCore {
  late int code;
  late double pouchValue;
  double? cardvalue;
  String? observation;
  late bool valueMatch;
  double? differenceValue;
  String? latitude;
  String? longitude;

  MoneyPouch({
    required this.code,
    required this.pouchValue,
    this.cardvalue,
    this.observation,
    required this.valueMatch,
    DateTime? change,
  });

  static String get tableName => "MONEYPOUCH";

  static String get scriptCreateTable => """
      CREATE TABLE IF NOT EXISTS $tableName (${ElephantContext.queryElephantModelBase},
      PouchValue DECIMAL, CardValue DECIMAL, ValueMatch BOOLEAN,
      IncludeUserId TEXT, Code INTEGER, Observation TEXT, DifferenceValue DECIMAL,
      Latitude TEXT, Longitude TEXT)""";

  factory MoneyPouch.fromJson(Map<String, dynamic> json) => _$MoneyPouchFromJson(json);

  Map<String, dynamic> toJson() => _$MoneyPouchToJson(this);
}
