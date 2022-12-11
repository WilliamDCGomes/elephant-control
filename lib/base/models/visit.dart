import 'package:elephant_control/base/models/base/elephant_core.dart';
import 'package:json_annotation/json_annotation.dart';

part 'visit.g.dart';

@JsonSerializable()
class Visit extends ElephantCore {
  late final int addedProducts;
  late final double moneyQuantity;
  late final double? moneyWithdrawalQuantity;
  late final int stuffedAnimalsQuantity;
  late final String latitude;
  late final String longitude;
  late final VisitStatus status;
  late final String machineId;
  late final bool moneyWithdrawal;
  late final int code;

  Visit({
    required this.addedProducts,
    required this.moneyQuantity,
    required this.moneyWithdrawalQuantity,
    required this.stuffedAnimalsQuantity,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.machineId,
    required this.moneyWithdrawal,
    required this.code,
  });

  Visit._();

  factory Visit.fromJson(Map<String, dynamic> json) => _$VisitFromJson(json);

  Map<String, dynamic> toJson() => _$VisitToJson(this);
}

enum VisitStatus {
  realized,
  moneyWithdrawal,
  possessionTreasury,
  moneyPouchReceived,
  moneyPouchLaunched,
  finished,
}
