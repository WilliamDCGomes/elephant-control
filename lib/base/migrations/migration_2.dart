import 'package:sqflite/sqflite.dart';
import '../models/stokistPlush/stokist_plush.dart';
import 'base_migration.dart';

class Migration2 extends BaseMigration {
  Migration2(Database database)
      : super(
    database,
    [
      StokistPlush.scriptCreateTable,
    ],
  );
}