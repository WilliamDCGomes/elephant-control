import 'package:elephant_control/base/models/userMachine/user_machine.dart';
import 'package:elephant_control/base/models/userVisitMachine/user_visit_machine.dart';
import 'package:elephant_control/base/repositories/base/base_repository.dart';
import 'package:elephant_control/base/repositories/user_visit_machine_repository.dart';

import '../models/machine/machine.dart';

class MachineRepository extends BaseRepository {
  Future<List<Machine>> getMachineVisitByUserId() async {
    try {
      final query = """
                    SELECT DISTINCT 
                      M.Id,
                      M.Name,
                      M.Uf,
                      M.BalanceStuffedAnimals as Balance,
                      M.Prize,
                      M.LastPrize,
                      M.Longitude,
                      M.Active,
                      M.Address,
                      M.Alteration,
                      M.Cep,
                      M.City,
                      M.Complement,
                      M.DaysToNextVisit,
                      M.District,
                      M.Latitude,
                      M.MaximumAverageValue,
                      M.MinimumAverageValue,
                      M.Localization,
                      M.Number,
                      0 as MachineAddOtherList
                    FROM ${Machine.tableName} M
                    LEFT JOIN ${UserVisitMachine.tableName} UVM ON M.Id = UVM.MachineId AND UVM.VisitId IS NULL AND UVM.Active = 1
                    INNER JOIN ${UserMachine.tableName} UM ON M.Id = UM.MachineId
                    WHERE M.Active = 1 AND UVM.Id IS NULL
                    """;
      final _database = await database;
      final result = await _database.rawQuery(query);
      final machines = result.map((e) => Machine.fromJsonRepository(e)).toList();
      for (var element in machines) {
        element.reminders = await UserVisitMachineRepository().getRemindersByUserVisitMachineId(element.id!);
      }
      return machines;
    } catch (_) {
      return <Machine>[];
    }
  }
}
