import 'package:elephant_control/base/models/adminSolicitation/admin_solicitation.dart';
import 'package:elephant_control/base/models/visitLog/visit_log.dart';
import 'package:sqflite/sqflite.dart';
import '../models/incident/incident.dart';
import '../models/incidentMedia/incident_media.dart';
import '../models/machine/machine.dart';
import '../models/reminderMachine/reminder_machine.dart';
import '../models/user/user.dart';
import '../models/userMachine/user_machine.dart';
import '../models/userVisitMachine/user_visit_machine.dart';
import '../models/visit/visit.dart';
import '../models/visitMedia/visit_media.dart';
import 'base_migration.dart';

class Migration1 extends BaseMigration {
  Migration1(Database database)
      : super(
          database,
          [
            ("DELETE FROM " + Incident.tableName),
            ("DELETE FROM " + IncidentMedia.tableName),
            ("DELETE FROM " + Machine.tableName),
            ("DELETE FROM " + ReminderMachine.tableName),
            ("DELETE FROM " + User.tableName),
            ("DELETE FROM " + UserMachine.tableName),
            ("DELETE FROM " + UserVisitMachine.tableName),
            ("DELETE FROM " + Visit.tableName),
            ("DELETE FROM " + VisitMedia.tableName),
            ("DROP TABLE IF EXISTS ${Incident.tableName}"),
            ("DROP TABLE IF EXISTS ${IncidentMedia.tableName}"),
            ("DROP TABLE IF EXISTS ${Machine.tableName}"),
            ("DROP TABLE IF EXISTS ${ReminderMachine.tableName}"),
            ("DROP TABLE IF EXISTS ${User.tableName}"),
            ("DROP TABLE IF EXISTS ${UserMachine.tableName}"),
            ("DROP TABLE IF EXISTS ${UserVisitMachine.tableName}"),
            ("DROP TABLE IF EXISTS ${Visit.tableName}"),
            ("DROP TABLE IF EXISTS ${VisitMedia.tableName}"),
            Incident.scriptCreateTable,
            IncidentMedia.scriptCreateTable,
            Machine.scriptCreateTable,
            ReminderMachine.scriptCreateTable,
            User.scriptCreateTable,
            UserMachine.scriptCreateTable,
            UserVisitMachine.scriptCreateTable,
            Visit.scriptCreateTable,
            VisitMedia.scriptCreateTable,
          ],
        );
}
