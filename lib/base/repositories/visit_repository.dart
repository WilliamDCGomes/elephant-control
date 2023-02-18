import 'package:elephant_control/base/models/visit/visit.dart';
import 'package:elephant_control/base/models/visitMedia/visit_media.dart';
import 'package:elephant_control/base/repositories/base/base_repository.dart';
import '../models/machine/machine.dart';
import '../models/userVisitMachine/user_visit_machine.dart';
import '../viewControllers/visit_list_viewcontroller.dart';
import '../viewControllers/visit_media_h_viewcontroller.dart';

class VisitRepository extends BaseRepository {
  Future<bool> createVisit(Visit visit) async {
    try {
      final _database = await context.database;
      visit.sent = false;
      visit.alteration = DateTime.now();
      visit.inclusion = DateTime.now();
      visit.active = true;
      final machine = await _database.query(Machine.tableName, where: "Id = ?", whereArgs: [visit.machineId]);
      if (machine.isNotEmpty) {
        final _machine = Machine.fromJsonRepository(machine.first);
        visit.lastPrizeMachine = _machine.lastPrize;
      }
      await context.insert(Visit.tableName, visit.toJsonRepository(false));
      final userVisitMachineDb = await _database.query(UserVisitMachine.tableName,
          where: "MachineId = ? AND DATE(VisitDay) = DATE(?) AND VisitId IS NULL",
          whereArgs: [visit.machineId, visit.inclusion?.toIso8601String()]);
      if (userVisitMachineDb.isNotEmpty) {
        final userVisitMachine = UserVisitMachine.fromJsonRepository(userVisitMachineDb.first);
        userVisitMachine.visitId = visit.id;
        await context.update(UserVisitMachine.tableName, userVisitMachine.toJsonRepository(), userVisitMachine.id!);
      }
      return true;
    } catch (_) {
      print(_.toString());
      return false;
    }
  }

  Future<bool> createVisitMedia(List<VisitMediaHViewController> visitsMedia) async {
    try {
      for (var visitMedia in visitsMedia) {
        final _visitMedia = VisitMedia(
          id: visitMedia.mediaId,
          inclusion: DateTime.now(),
          alteration: DateTime.now(),
          visitId: visitMedia.visitId!,
          type: visitMedia.type,
          extension: visitMedia.extension!,
          media: visitMedia.media!,
          sent: false,
        );
        await context.insert(VisitMedia.tableName, _visitMedia.toJsonRepository());
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<List<VisitListViewController>> getVisitsOperatorByUserId() async {
    try {
      final now = DateTime.now().toIso8601String();
      final query = """
                    SELECT 
                        CASE  
                          WHEN V.Id IS NULL 
                              THEN 0 
                          ELSE 
                              1 
                        END RealizedVisit,
                        CASE  
                          WHEN V.Id IS NULL 
                              THEN UVM.Id 
                          ELSE 
                              V.Id 
                        END Id,
                        CASE  
                          WHEN V.Id IS NULL 
                              THEN UVM.Inclusion 
                          ELSE 
                              V.Inclusion 
                        END Inclusion,
                        'Normal' as Priority,
                        CASE  
                          WHEN V.Id IS NULL 
                              THEN NULL 
                          ELSE 
                              V.Status 
                        END Status,
                        CASE  
                          WHEN V.Id IS NULL 
                              THEN 0 
                          ELSE 
                              V.MoneyQuantity 
                        END MoneyQuantity,
                        CASE  
                          WHEN V.Id IS NULL 
                              THEN 0 
                          ELSE 
                              V.StuffedAnimalsReplaceQuantity 
                        END StuffedAnimalsReplaceQuantity,
                        CASE  
                          WHEN V.Id IS NULL 
                              THEN 0 
                          ELSE 
                              V.StuffedAnimalsQuantity 
                        END StuffedAnimalsQuantity,
                        CASE  
                          WHEN V.MoneyWithdrawalQuantity IS NULL 
                              THEN 0 
                          ELSE
                              1
                        END MoneyPouchRetired,
                        M.Name as MachineName,
                        CASE  
                          WHEN V.Id IS NULL 
                              THEN UVM.Active 
                          ELSE 
                              V.Active 
                        END Active,
                        M.Id as MachineId
                     FROM ${UserVisitMachine.tableName} UVM
                    INNER JOIN ${Machine.tableName} M ON UVM.MachineId = M.Id
                    LEFT JOIN ${Visit.tableName} V ON UVM.VisitId = V.Id
                                                      AND DATE(V.Inclusion) = DATE('$now')
                    WHERE DATE(UVM.VisitDay) = DATE('$now')
                    """;
      final _database = await context.database;
      final results = await _database.rawQuery(query);
      if (results.isEmpty) return [];
      return results.map((e) => VisitListViewController.fromJsonRepository(e)).toList();
    } catch (_) {
      return [];
    }
  }
}
