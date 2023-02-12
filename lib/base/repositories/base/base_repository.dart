import 'package:elephant_control/base/context/elephant_context.dart';
import 'package:sqflite/sqflite.dart';

class BaseRepository {
  late final ElephantContext context;

  BaseRepository() {
    context = ElephantContext();
  }

  Future<Database> get database async {
    return await context.database;
  }
}
