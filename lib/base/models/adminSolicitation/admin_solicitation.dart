import 'package:json_annotation/json_annotation.dart';
import '../../context/elephant_context.dart';
import '../base/elephant_user_core.dart';
part 'admin_solicitation.g.dart';

@JsonSerializable()
class AdminSolicitation extends ElephantUserCore {
  late StatusAdminSolicitation Status;
  late StatusAdminType Type;
  late String VisitId;
  late String SolicitationUserId;

  AdminSolicitation({
    required this.Status,
    required this.Type,
    required this.VisitId,
    required this.SolicitationUserId,
  });

  static String get tableName => "ADMINSOLICITATION";

  static String get scriptCreateTable => """
      CREATE TABLE IF NOT EXISTS $tableName (${ElephantContext.queryElephantModelBase},
      Status INTEGER, Type INTEGER, VisitId TEXT, SolicitationUserId TEXT)""";

  factory AdminSolicitation.fromJson(Map<String, dynamic> json) => _$AdminSolicitationFromJson(json);

  Map<String, dynamic> toJson() => _$AdminSolicitationToJson(this);
}

enum StatusAdminSolicitation {
  @JsonValue(0)
  pending,
  @JsonValue(1)
  accepted,
  @JsonValue(2)
  rejected,
}

enum StatusAdminType {
  @JsonValue(0)
  moneyWithDrawal,
}
