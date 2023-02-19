import 'package:json_annotation/json_annotation.dart';

part 'money_pouch_viewcontroller.g.dart';

@JsonSerializable()
class MoneyPouchViewController {
  final String? observation;
  final String visitId;
  final double pouchValue;
  final double creditValue;
  final double debitValue;
  final double pixValue;
  int? code;
  String? moneyPouchId;
  bool? valueMatch;
  int? visitCode;
  double? differenceValue;

  MoneyPouchViewController({
    required this.pouchValue,
    required this.creditValue,
    required this.debitValue,
    required this.pixValue,
    this.observation,
    this.differenceValue,
    required this.visitId,
  });

  factory MoneyPouchViewController.fromJson(Map<String, dynamic> json) => _$MoneyPouchViewControllerFromJson(json);

  Map<String, dynamic> toJson() => _$MoneyPouchViewControllerToJson(this);
}
