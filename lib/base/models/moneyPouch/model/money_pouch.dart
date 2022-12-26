import 'package:elephant_control/base/models/base/elephant_core.dart';
import 'package:json_annotation/json_annotation.dart';

part '../converter/money_pouch.g.dart';

@JsonSerializable()
class MoneyPouch extends ElephantCore {
  final int code;
  final double pouchValue;
  double? cardvalue;
  String? observation;
  final bool valueMatch;

  MoneyPouch({
    required this.code,
    required this.pouchValue,
    this.cardvalue,
    this.observation,
    required this.valueMatch,
    DateTime? change,
  });

  factory MoneyPouch.fromJson(Map<String, dynamic> json) => _$MoneyPouchFromJson(json);

  Map<String, dynamic> toJson() => _$MoneyPouchToJson(this);
}
