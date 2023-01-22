import 'package:elephant_control/base/models/machine/machine.dart';
import 'package:elephant_control/base/viewControllers/return_machine_viewcontroller.dart';

abstract class IMachineService {
  Future<List<Machine>> getMachinesByUserId();

  Future<bool> createOrUpdateMachine(Machine machine);

  Future<List<String>> getLocalizationsMachines(Machine machine);
  Future<List<Machine>> getAll();
  Future<List<ReturnMachineViewController>> getMachinesReturn(List<int> externalIds);
}
