import 'package:elephant_control/base/models/adminSolicitation/admin_solicitation.dart';
import 'package:elephant_control/base/models/visitLog/visit_log.dart';
import 'package:sqflite/sqflite.dart';
import 'base_migration.dart';

class Migration1 extends BaseMigration {
  Migration1(Database database)
      : super(
          database,
          [
            AdminSolicitation.scriptCreateTable,
            VisitLog.migrationVersion2,
          ],
        );
}
