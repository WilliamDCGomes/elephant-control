import 'package:json_annotation/json_annotation.dart';

part 'add_money_pouch_viewcontroller.g.dart';

@JsonSerializable()
class AddMoneyPouchViewController {
  final String? userOperatorId;
  final int code;
  final String? observation;
  final String visitId;
  final String? latitude;
  final String? longitude;

  AddMoneyPouchViewController({
    required this.userOperatorId,
    required this.code,
    this.observation,
    required this.visitId,
    this.latitude,
    this.longitude,
  });

  factory AddMoneyPouchViewController.fromJson(Map<String, dynamic> json) => _$AddMoneyPouchViewControllerFromJson(json);

  Map<String, dynamic> toJson() => _$AddMoneyPouchViewControllerToJson(this);
}
