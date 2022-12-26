import 'package:elephant_control/base/models/machine/model/machine.dart';

abstract class IMachineService {
  Future<List<Machine>> getMachinesByUserId();

  Future<bool> createMachine(Machine machine);

  Future<List<String>> getLocalizationsMachines(Machine machine);
}