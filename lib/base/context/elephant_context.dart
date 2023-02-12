import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import '../../flavors.dart';
import '../migrations/migration_1.dart';
import '../models/incident/incident.dart';
import '../models/incidentMedia/incident_media.dart';
import '../models/machine/machine.dart';
import '../models/media/media.dart';
import '../models/moneyPouch/money_pouch.dart';
import '../models/reminderMachine/reminder_machine.dart';
import '../models/stokistPlush/stokist_plush.dart';
import '../models/store/store.dart';
import '../models/storeUser/store_user.dart';
import '../models/user/user.dart';
import '../models/userMachine/user_machine.dart';
import '../models/userVisitMachine/user_visit_machine.dart';
import '../models/visit/visit.dart';
import '../models/visitLog/visit_log.dart';
import '../models/visitMedia/visit_media.dart';

class ElephantContext {
  static Database? _database;
  static const int _databaseVersion = 4;
  static const String queryElephantModelBase =
      "Id TEXT PRIMARY KEY NOT NULL, Alteration TEXT, Inclusion TEXT, Active BOOLEAN";

  static final ElephantContext _elephantContext = ElephantContext._internal();
  factory ElephantContext() => _elephantContext;
  ElephantContext._internal();

  Future<String> get pathDatabase async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = "${directory.path}/BK_Elephant_${F.extension}.db";
    return dbPath;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase({String? path}) async {
    path ??= await pathDatabase;
    var database = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDb,
      onUpgrade: _updgradeDb,
    );
    return database;
  }

  Future<void> _createDb(Database db, int newVersion) async {
    List<Map<String, String>> tables = <Map<String, String>>[
      {
        "scriptCreateTable": Incident.scriptCreateTable,
        "tableName": Incident.tableName,
      },
      {
        "scriptCreateTable": IncidentMedia.scriptCreateTable,
        "tableName": IncidentMedia.tableName,
      },
      {
        "scriptCreateTable": Machine.scriptCreateTable,
        "tableName": Machine.tableName,
      },
      {
        "scriptCreateTable": ReminderMachine.scriptCreateTable,
        "tableName": ReminderMachine.tableName,
      },
      {
        "scriptCreateTable": User.scriptCreateTable,
        "tableName": User.tableName,
      },
      {
        "scriptCreateTable": UserMachine.scriptCreateTable,
        "tableName": UserMachine.tableName,
      },
      {
        "scriptCreateTable": UserVisitMachine.scriptCreateTable,
        "tableName": UserVisitMachine.tableName,
      },
      {
        "scriptCreateTable": Visit.scriptCreateTable,
        "tableName": Visit.tableName,
      },
      {
        "scriptCreateTable": VisitMedia.scriptCreateTable,
        "tableName": VisitMedia.tableName,
      },
    ];

    for (var table in tables) {
      try {
        await db.execute(table["scriptCreateTable"] as String);
      } catch (e) {
        if (kDebugMode) {
          log(
            name: "LOG - Erro Ocorrido",
            "Erro ao executar CREATE TABLE IF NOT EXISTS na tabela ${table["tableName"]}: " + e.toString(),
          );
        }
      }
    }
  }

  Future<void> _updgradeDb(Database db, int oldVersion, int newVersion) async {
    try {
      int oldVersionAux = oldVersion;
      while (oldVersionAux < newVersion) {
        switch (oldVersionAux) {
          case 1:
          case 2:
          case 3:
            await Migration1(db).executeMigrations();
            break;
          default:
            log("Sem migrations");
        }
        oldVersionAux++;
      }
    } catch (_) {}
  }

  Future<bool> exportDatabase() async {
    try {
      Directory? docDirectory =
          Platform.isAndroid ? Directory('/storage/emulated/0/Download') : await getDownloadsDirectory();
      if (docDirectory == null) throw Exception();
      String newDirectory = "${docDirectory.path}/BK_${DateTime.now().microsecondsSinceEpoch}_Elephant_${F.extension}.db";
      File db = File(await pathDatabase);
      PermissionStatus _statusPermissao = await Permission.storage.status;
      if (!_statusPermissao.isGranted) {
        PermissionStatus denied = await Permission.storage.request();
        if (denied.isPermanentlyDenied) await openAppSettings();
      }
      XFile file = XFile((await db.copy(newDirectory)).path);
      await Share.shareXFiles([file]);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteDb() async {
    try {
      _database = await database;
      _database = null;
      await deleteDatabase(await pathDatabase);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<int?> insert(String tableName, Map<String, dynamic> model) async {
    try {
      _database = await database;
      return await _database!.insert(
        tableName,
        model,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (_) {
      return null;
    }
  }

  Future<bool> insertList(String tableName, Iterable<Map<String, dynamic>> models) async {
    try {
      _database = await database;
      for (var model in models) {
        await _database?.insert(
          tableName,
          model,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<Map<String, Object?>?> findById(String tableName, String id) async {
    try {
      _database = await database;
      var result = await _database!.query(
        tableName,
        where: "Id = ?",
        whereArgs: [id],
      );
      if (result.isNotEmpty) return result.first;
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<Map<String, Object?>>> find(String tableName) async {
    try {
      _database = await database;
      List<Map<String, Object?>> results = await _database!.query(tableName);
      if (results.isEmpty) throw Exception();
      return results;
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, Object?>>?> findAtivos(String tableName, {String? columnToOrder}) async {
    try {
      _database = await database;
      List<Map<String, Object?>> results = await _database!.query(
        tableName,
        where: "Active = ?",
        whereArgs: [1],
        orderBy: columnToOrder != null ? "$columnToOrder ASC" : null,
      );
      if (results.isNotEmpty) return results;
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<int?> update(String tableName, Map<String, dynamic> model, String id) async {
    try {
      _database = await database;
      var update = await _database!.update(
        tableName,
        model,
        where: "Id = ?",
        whereArgs: [id],
      );
      return update;
    } catch (e) {
      return null;
    }
  }

  Future<int?> removeBoolean(String tableName, Map<String, dynamic> model) async {
    try {
      _database = await database;
      return await _database!.update(
        tableName,
        model,
        where: "Id = ?",
        whereArgs: [model["Id"]],
      );
    } catch (e) {
      return null;
    }
  }

  Future<int?> removeTrully(String tableName, String id) async {
    try {
      _database = await database;
      return await _database!.delete(
        tableName,
        where: "Id = ?",
        whereArgs: [id],
      );
    } catch (e) {
      return null;
    }
  }

  Future<int?> removeAllTrully(String tableName) async {
    try {
      _database = await database;
      return await _database!.delete(
        tableName,
      );
    } catch (e) {
      return null;
    }
  }

  Future<String> getLastAlteration(String tableName) async {
    try {
      _database = await database;
      List<Map<String, dynamic>> results = await _database!.query(
        tableName,
        orderBy: "Alteration DESC LIMIT 1",
      );
      if (results.isEmpty) throw Exception();
      return results.first["Alteration"];
    } catch (e) {
      return "";
    }
  }

  Future<List<Map<String, Object?>>> getNotSent(String tableName) async {
    try {
      _database = await database;
      List<Map<String, Object?>> results = await _database!.query(
        tableName,
        where: "Sent = ?",
        whereArgs: [0],
      );
      if (results.isEmpty) throw Exception();
      return results;
    } catch (e) {
      return [];
    }
  }
}
