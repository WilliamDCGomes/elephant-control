import 'package:json_annotation/json_annotation.dart';
import '../../context/elephant_context.dart';
import '../base/elephant_user_core.dart';
import '../visit/visit.dart';

part 'visit_log.g.dart';

@JsonSerializable()
class VisitLog extends ElephantUserCore {
  late String visitId;
  String? moneyPouchId;
  late String title;
  late String? description;
  late VisitStatus oldStatus;
  late VisitStatus newStatus;

  VisitLog({
    required this.visitId,
    required this.title,
    required this.description,
    required this.oldStatus,
    required this.newStatus,
    this.moneyPouchId,
  });

  static String get tableName => "VISITLOG";

  static String get scriptCreateTable => """
      CREATE TABLE IF NOT EXISTS $tableName (${ElephantContext.queryElephantModelBase},
       VisitId TEXT, Title TEXT, Description TEXT, OldStatus INTEGER,
       NewStatus INTEGER, Inclusion TEXT, IncludeUserId TEXT, MoneyPouchId TEXT)""";

  static String get migrationVersion2 => """
      ALTER TABLE $tableName ADD COLUMN MoneyPouchId TEXT""";
  factory VisitLog.fromJson(Map<String, dynamic> json) => _$VisitLogFromJson(json);

  Map<String, dynamic> toJson() => _$VisitLogToJson(this);
}
