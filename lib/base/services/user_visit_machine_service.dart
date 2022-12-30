import 'package:elephant_control/base/services/base/base_service.dart';
import 'package:elephant_control/base/viewControllers/create_user_visit_machine_viewcontroller.dart';
import 'package:elephant_control/base/viewControllers/user_visit_machine_viewcontroller.dart';

class UserVisitMachineService extends BaseService {
  Future<bool> createUserVisitMachineWithList(CreateUserVisitMachineViewController createUserVisitMachineViewController) async {
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
      final response = await post(url, null, query: {"MachineId": machineId, "VisitDay": visitDay.toIso8601String()}, headers: {'Authorization': 'Bearer ${token}'});
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
      final response = await delete(url, query: {"UserVisitMachineId": userVisitMachineId}, headers: {'Authorization': 'Bearer ${token}'});
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
      final response = await delete(url, query: {"UserVisitMachineId": userVisitMachineId}, headers: {'Authorization': 'Bearer ${token}'});
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
      final response = await get(url, query: {"VisitDay": visitDay.toIso8601String()}, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response)) throw Exception();
      return (response.body as List).map((e) => UserVisitMachineViewController.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }
}
