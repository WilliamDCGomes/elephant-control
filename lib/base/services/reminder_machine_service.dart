import 'package:elephant_control/base/models/reminderMachine/reminder_machine.dart';
import 'package:elephant_control/base/services/base/base_service.dart';
import 'base/iservice_post.dart';

class ReminderMachineService extends BaseService with MixinService {
  @override
  Future<List<ReminderMachine>> getOffline() async {
    try {
      final lastAlteraion = await context.getLastAlteration(ReminderMachine.tableName);
      final token = await getToken();
      final url = baseUrlApi + 'Machine/GetReminderMachineByAlteration';
      final response = await get(url, query: {
        "Alteration": lastAlteraion,
      }, headers: {
        'Authorization': 'Bearer ${token}'
      });
      if (hasErrorResponse(response)) throw Exception();
      var machines = (response.body as List).map((e) => ReminderMachine.fromJson(e)).toList();
      for (var element in machines) {
        await context.insert(ReminderMachine.tableName, element.toJsonRepository());
      }
      return machines;
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<ReminderMachine>> postOffline() {
    throw UnimplementedError();
  }
}
