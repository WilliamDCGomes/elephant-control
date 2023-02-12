import 'package:elephant_control/app/utils/logged_user.dart';
import 'package:elephant_control/base/models/machine/machine.dart';
import 'package:elephant_control/base/models/reminderMachine/reminder_machine.dart';
import 'package:elephant_control/base/models/userVisitMachine/user_visit_machine.dart';
import 'package:elephant_control/base/models/visit/visit.dart';
import 'package:elephant_control/base/repositories/base/base_repository.dart';

import '../viewControllers/user_visit_machine_viewcontroller.dart';

class UserVisitMachineRepository extends BaseRepository {
  Future<List<UserVisitMachineViewController>> getUserVisitMachineByUserIdAndVisitDay(DateTime visitDay) async {
    try {
      final _database = await database;
      final query = """
                    SELECT M.Name as MachineName, M.Id as MachineId, 
                           UVM.Id, UVM.VisitDay, M.LastVisit FROM ${Machine.tableName} M
                    INNER JOIN ${UserVisitMachine.tableName} UVM ON M.Id = UVM.MachineId AND UVM.Active = 1 
                                                                AND DATE(UVM.VisitDay) = DATE('${visitDay.toIso8601String()}')
                                                                AND UVM.VisitId IS NULL
                    WHERE M.Active = 1
                    """;
      final result = await _database.rawQuery(query);
      if (result.isEmpty) throw Exception();
      final userVisitMachine = result.map((e) => UserVisitMachineViewController.fromJsonRepository(e)).toList();
      for (var element in userVisitMachine) {
        element.reminders = await getRemindersByUserVisitMachineId(element.machineId);
      }
      return userVisitMachine;
    } catch (_) {
      return [];
    }
  }

  Future<List<ReminderMachine>> getRemindersByUserVisitMachineId(String machineId) async {
    try {
      final _database = await database;
      final query = """
                    SELECT * FROM ${ReminderMachine.tableName} 
                    WHERE MachineId = '$machineId' AND Active = 1
                    """;
      final result = await _database.rawQuery(query);
      if (result.isEmpty) throw Exception();
      return result.map((e) => ReminderMachine.fromJson(e)).toList();
    } catch (_) {
      return <ReminderMachine>[];
    }
  }

  Future<bool> createUserVisitMachine(String machineId, DateTime visitDay) async {
    try {
      if (await userVisitMachineExistsForUser(machineId, visitDay)) throw Exception();
      final userVisitMachine = UserVisitMachine(
        machineId: machineId,
        visitDay: visitDay,
        userId: LoggedUser.id,
        sent: false,
        visitId: null,
        active: true,
        inclusion: DateTime.now(),
        alteration: DateTime.now(),
      );
      final result = await context.insert(UserVisitMachine.tableName, userVisitMachine.toJsonRepository());
      if (result == null) throw Exception();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> userVisitMachineExistsForUser(String machineId, DateTime visitDay) async {
    try {
      final query = """
                    SELECT UVM.Id FROM ${UserVisitMachine.tableName} UVM
                    LEFT JOIN ${Visit.tableName} V ON UVM.VisitId = V.Id
                    WHERE UVM.Active = 1 AND UVM.MachineId = '$machineId' AND V.Active = 1
                    AND DATE(UVM.VisitDay) = DATE('${visitDay.toIso8601String()}') AND V.Id IS NULL
                    """;
      final _database = await database;
      final result = await _database.rawQuery(query);
      return result.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteUserVisitMachine(String id) async {
    try {
      final query = "UPDATE ${UserVisitMachine.tableName} SET Active = 0 WHERE Id = '$id'";
      final _database = await database;
      final result = await _database.rawUpdate(query);
      return result == 1;
    } catch (_) {
      return false;
    }
  }

  Future<bool> unDeleteUserVisitMachine(String id) async {
    try {
      final query = "UPDATE ${UserVisitMachine.tableName} SET Active = 1 WHERE Id = '$id'";
      final _database = await database;
      final result = await _database.rawUpdate(query);
      return result == 1;
    } catch (_) {
      return false;
    }
  }
}
