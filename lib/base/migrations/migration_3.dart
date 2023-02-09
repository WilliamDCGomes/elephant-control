import 'package:sqflite/sqflite.dart';
import '../models/machine/machine.dart';
import 'base_migration.dart';

class Migration3 extends BaseMigration {
  Migration3(Database database)
      : super(
    database,
    [
      Machine.addColumnMachineType,
    ],
  );
}