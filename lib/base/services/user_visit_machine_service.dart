import 'package:elephant_control/base/services/base/base_service.dart';
import 'package:elephant_control/base/viewControllers/create_user_visit_machine_viewcontroller.dart';
import 'package:elephant_control/base/viewControllers/user_visit_machine_viewcontroller.dart';
import '../models/userVisitMachine/user_visit_machine.dart';
import 'base/iservice_post.dart';

class UserVisitMachineService extends BaseService with MixinService {
  Future<bool> createUserVisitMachineWithList(
      CreateUserVisitMachineViewController createUserVisitMachineViewController) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'UserVisitMachine/CreateUserVisitMachineWithList';
      final data = createUserVisitMachineViewController.toJson();
      final response = await post(url, data, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response) || response.body is! bool) throw Exception();
      return response.body;
    } catch (_) {
      return false;
    }
  }

  Future<bool> createUserVisitMachine(String machineId, DateTime visitDay) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'UserVisitMachine/CreateUserVisitMachine';
      final response = await post(url, null,
          query: {"MachineId": machineId, "VisitDay": visitDay.toIso8601String()},
          headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response) || response.body is! bool) throw Exception();
      return response.body;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteUserVisitMachine(String userVisitMachineId) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'UserVisitMachine/DeleteUserVisitMachine';
      final response = await delete(url,
          query: {"UserVisitMachineId": userVisitMachineId}, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response) || response.body is! bool) throw Exception();
      return response.body;
    } catch (_) {
      return false;
    }
  }

  Future<bool> unDeleteUserVisitMachine(String userVisitMachineId) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'UserVisitMachine/UndeleteUserVisitMachine';
      final response = await delete(url,
          query: {"UserVisitMachineId": userVisitMachineId}, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response) || response.body is! bool) throw Exception();
      return response.body;
    } catch (_) {
      return false;
    }
  }

  Future<List<UserVisitMachineViewController>> getUserVisitMachineByUserId() async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'UserVisitMachine/GetUserVisitMachineByUserId';
      final response = await get(url, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response) || response.body is! bool) throw Exception();
      return (response.body as List).map((e) => UserVisitMachineViewController.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<UserVisitMachineViewController>> getUserVisitMachineByUserIdAndVisitDay(DateTime visitDay) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'UserVisitMachine/GetUserVisitMachineByUserIdAndVisitDay';
      final response =
          await get(url, query: {"VisitDay": visitDay.toIso8601String()}, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response)) throw Exception();
      final machines = (response.body as List).map((e) => UserVisitMachineViewController.fromJson(e)).toList();
      return machines;
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<UserVisitMachine>> getOffline() async {
    try {
      final lastAlteraion = await context.getLastAlteration(UserVisitMachine.tableName);
      final token = await getToken();
      final url = baseUrlApi + 'UserVisitMachine/GetByAlteration';
      final response = await get(url, query: {
        "Alteration": lastAlteraion,
      }, headers: {
        'Authorization': 'Bearer ${token}'
      });
      if (hasErrorResponse(response)) throw Exception();
      var machines = (response.body as List).map((e) => UserVisitMachine.fromJson(e)).toList();
      for (var element in machines) {
        await context.insert(UserVisitMachine.tableName, element.toJsonRepository());
      }
      return machines;
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<UserVisitMachine>> postOffline() async {
    try {
      List<UserVisitMachine> userVisitMachines = [];
      final itens = await context.getNotSent(UserVisitMachine.tableName);
      for (var item in itens) {
        final itemConvertido = UserVisitMachine.fromJsonRepository(item);
        final token = await getToken();
        final url = baseUrlApi + 'UserVisitMachine/CreateUserVisitMachine';
        final response = await post(url, null,
            query: {"MachineId": itemConvertido.machineId, "VisitDay": itemConvertido.visitDay.toIso8601String()},
            headers: {'Authorization': 'Bearer ${token}'});
        if (hasErrorResponse(response)) continue;
        userVisitMachines.add(itemConvertido);
        itemConvertido.sent = true;
        await context.update(UserVisitMachine.tableName, itemConvertido.toJsonRepository(), itemConvertido.id!);
      }
      return userVisitMachines;
    } catch (_) {
      return [];
    }
  }
}
