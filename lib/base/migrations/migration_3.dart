import 'package:elephant_control/base/models/machine/machine.dart';
import 'package:sqflite/sqflite.dart';
import 'base_migration.dart';

class Migration3 extends BaseMigration {
  Migration3(Database database)
      : super(
          database,
          [
            Machine.migration4,
          ],
        );
}
