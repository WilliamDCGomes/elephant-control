import 'package:sqflite/sqflite.dart';
import 'base_migration.dart';

class Migration1 extends BaseMigration {
  Migration1(Database database) : super(
    database,
    [],
  );
}
