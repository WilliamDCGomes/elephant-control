import 'package:elephant_control/base/models/userMachine/user_machine.dart';
import 'package:elephant_control/base/services/base/base_service.dart';
import 'package:elephant_control/base/viewControllers/user_machine_viewcontroller.dart';

import 'base/iservice_post.dart';

class UserMachineService extends BaseService with MixinService {
  Future<bool> createuserMachine(UserMachineViewController userMachineViewController) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'UserMachine/CreateUserMachine';
      final response = await post(url, userMachineViewController.toJson(), headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response)) throw Exception();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteUserMachine(UserMachineViewController userMachineViewController) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'UserMachine/DeleteUserMachine';
      final response = await post(url, userMachineViewController.toJson(), headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response)) throw Exception();
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<List<UserMachine>> getOffline() async {
    try {
      final lastAlteraion = await context.getLastAlteration(UserMachine.tableName);
      final token = await getToken();
      final url = baseUrlApi + 'UserMachine/GetByAlteration';
      final response = await get(url, query: {
        "Alteration": lastAlteraion,
      }, headers: {
        'Authorization': 'Bearer ${token}'
      });
      if (hasErrorResponse(response)) throw Exception();
      var machines = (response.body as List).map((e) => UserMachine.fromJson(e)).toList();
      for (var element in machines) {
        await context.insert(UserMachine.tableName, element.toJsonRepository());
      }
      return machines;
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<UserMachine>> postOffline() {
    throw UnimplementedError();
  }
}
