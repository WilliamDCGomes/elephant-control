import 'package:elephant_control/base/services/base/base_service.dart';
import 'package:elephant_control/base/viewControllers/user_machine_viewcontroller.dart';

class UserMachineService extends BaseService {
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
}
