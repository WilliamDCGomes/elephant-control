import 'package:elephant_control/base/models/machine/machine.dart';
import 'package:elephant_control/base/models/reminderMachine/reminder_machine.dart';
import 'package:elephant_control/base/services/base/base_service.dart';
import 'package:elephant_control/base/viewControllers/return_machine_viewcontroller.dart';
import '../models/user/user.dart';
import 'interfaces/imachine_service.dart';

class MachineService extends BaseService implements IMachineService {
  Future<List<Machine>> getMachinesByUserId() async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'UserMachine/GetMachineByUserId';
      final response = await get(url, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response)) throw Exception();
      var machines = (response.body as List).map((e) => Machine.fromJson(e)).toList();
      return machines;
    } catch (_) {
      return [];
    }
  }

  Future<Machine?> getMachineById(String machineId) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'Machine/GetMachineById';
      final response = await get(url, query: {"MachineId": machineId}, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response)) throw Exception();
      var machine = Machine.fromJson(response.body);
      return machine;
    } catch (_) {
      return null;
    }
  }

  Future<bool> setAverageMachine(String machineId) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'Machine/SetAverageMachine';
      final response = await get(url, query: {"MachineId": machineId}, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response) || response.body is! bool) throw Exception();
      return response.body;
    } catch (_) {
      return false;
    }
  }

  Future<List<Machine>> getMachineVisitByUserId() async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'UserMachine/GetMachineVisitByUserId';
      final response = await get(url, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response)) throw Exception();
      var machines = (response.body as List).map((e) => Machine.fromJson(e)).toList();
      return machines;
    } catch (_) {
      return [];
    }
  }

  Future<List<Machine>> getUserMachineByUserId() async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'UserMachine/GetUserMachineByUserId';
      final response = await get(url, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response)) throw Exception();
      var machines = (response.body as List).map((e) => Machine.fromJson(e)).toList();
      return machines;
    } catch (_) {
      return [];
    }
  }

  Future<List<Machine>> getUserMachineByMachineId(String machineId) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'UserMachine/GetUserMachineByMachineId';
      final response = await get(url, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response)) throw Exception();
      var machines = (response.body as List).map((e) => Machine.fromJson(e)).toList();
      return machines;
    } catch (_) {
      return [];
    }
  }

  Future<List<User>> getUsersByMachineId(String machineId) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'UserMachine/GetUsersByMachineId';
      final response = await get(url, query: {"MachineId": machineId}, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response)) throw Exception();
      var machines = (response.body as List).map((e) => User.fromJson(e)).toList();
      return machines;
    } catch (_) {
      return [];
    }
  }

  Future<List<Machine>> getAll() async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'Machine/GetAll';
      final response = await get(url, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response)) throw Exception();
      var machines = (response.body as List).map((e) => Machine.fromJson(e)).toList();
      return machines;
    } catch (_) {
      return [];
    }
  }

  Future<List<Machine>> getAllMachines() async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'Machine/GetAllMachines';
      final response = await get(url, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response)) throw Exception();
      var machines = (response.body as List).map((e) => Machine.fromJson(e)).toList();
      return machines;
    } catch (_) {
      return [];
    }
  }

  Future<bool> createOrUpdateMachine(Machine machine) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'Machine/CreateOrUpdateMachine';
      final response = await post(url, machine.toJson(), headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response) || response.body is! bool) throw Exception();
      return response.body;
    } catch (_) {
      return false;
    }
  }

  Future<List<String>> getLocalizationsMachines(Machine machine) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'Machine/GetLocalizationMachines';
      final response = await get(url, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response)) throw Exception();
      return (response.body as List).map((e) => e.toString()).toList();
    } catch (_) {
      return [];
    }
  }

  Future<bool> createOrEditReminder(ReminderMachine reminder) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'Machine/CreateOrEditReminderMachine';
      final response = await post(url, null, query: {
        "MachineId": reminder.machineId,
        "Description": reminder.description,
        "Realized": reminder.realized.toString(),
        "ReminderId": reminder.id,
      }, headers: {
        'Authorization': 'Bearer ${token}'
      });
      if (hasErrorResponse(response) || response.body is! bool) throw Exception();
      return response.body;
    } catch (_) {
      return false;
    }
  }

  Future<List<ReturnMachineViewController>> getMachinesReturn(List<int> externalIds) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'Machine/GetMachinesVmPay';
      final response = await get(url, query: {
        "externalIds": externalIds.map((e) => e.toString()).toList(),
      }, headers: {
        'Authorization': 'Bearer ${token}'
      });
      if (hasErrorResponse(response)) throw Exception();
      var machines = (response.body as List).map((e) => ReturnMachineViewController.fromJson(e)).toList();
      return machines;
    } catch (_) {
      return [];
    }
  }
}
