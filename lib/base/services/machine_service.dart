import 'package:elephant_control/base/models/machine.dart';
import 'package:elephant_control/base/services/base/base_service.dart';

class MachineService extends BaseService {
  Future<List<Machine>> getMachinesByUserId() async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'UserMachine/GetMachineByUserId';
      final response = await get(url, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response)) throw Exception();
      return (response.body as List).map((e) => Machine.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }
}
