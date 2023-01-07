import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

class BaseMigration {
  final List<String> migrations;
  final Database database;

  BaseMigration(this.database, this.migrations);

  Future<void> executeMigrations() async {
    for (var migration in migrations) {
      try {
        await database.execute(migration);
      } catch (e) {
        if (kDebugMode) {
          log(
            "Erro ao executar ALTER TABLE\nO Script $migration falhou: " + e.toString(),
            name: "LOG - Erro Ocorrido");
        }
      }
    }
  }
}