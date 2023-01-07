import 'package:json_annotation/json_annotation.dart';
import '../../context/elephant_context.dart';
import '../base/elephant_user_core.dart';
import '../visit/visit.dart';

part 'visit_log.g.dart';

@JsonSerializable()
class VisitLog extends ElephantUserCore {
  late String visitId;
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
  });

  static String get tableName => "VISITLOG";

  static String get scriptCreateTable => """
      CREATE TABLE IF NOT EXISTS $tableName (${ElephantContext.queryElephantModelBase},
       VisitId TEXT, Title TEXT, Description TEXT, OldStatus INTEGER,
       NewStatus INTEGER, Inclusion TEXT, IncludeUserId TEXT)""";

  factory VisitLog.fromJson(Map<String, dynamic> json) => _$VisitLogFromJson(json);

  Map<String, dynamic> toJson() => _$VisitLogToJson(this);
}