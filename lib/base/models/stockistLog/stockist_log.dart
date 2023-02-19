import 'package:elephant_control/base/models/base/elephant_core.dart';
import 'package:json_annotation/json_annotation.dart';

part 'stockist_log.g.dart';

@JsonSerializable()
class StockistLog extends ElephantCore {
  final String description;
  final String observation;
  final int quantity;
  final bool added;
  final String stockistUserId;
  final String operatorUserId;

  StockistLog({
    required this.description,
    required this.observation,
    required this.quantity,
    required this.added,
    required this.stockistUserId,
    required this.operatorUserId,
  });

  factory StockistLog.fromJson(Map<String, dynamic> json) => _$StockistLogFromJson(json);

  Map<String, dynamic> toJson() => _$StockistLogToJson(this);
}
