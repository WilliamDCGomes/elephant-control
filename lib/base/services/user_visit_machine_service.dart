import 'package:elephant_control/base/models/visit.dart';
import 'package:elephant_control/base/models/visit_media.dart';
import 'package:elephant_control/base/services/base/base_service.dart';
import 'package:elephant_control/base/viewControllers/create_user_visit_machine_viewcontroller.dart';
import 'package:elephant_control/base/viewControllers/visit_list_viewcontroller.dart';
import 'package:json_annotation/json_annotation.dart';

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
}
