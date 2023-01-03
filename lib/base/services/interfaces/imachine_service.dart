import 'package:elephant_control/base/models/machine/model/machine.dart';

abstract class IMachineService {
  Future<List<Machine>> getMachinesByUserId();

  Future<bool> createOrUpdateMachine(Machine machine);

  Future<List<String>> getLocalizationsMachines(Machine machine);
  Future<List<Machine>> getAll();
}
