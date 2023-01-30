import 'package:elephant_control/base/services/machine_service.dart';
import '../../base/models/machine/machine.dart';

class ValidAverage{
  Future<bool> valid(String machineId, String clock1, String clock2) async {
    try {
      MachineService _machineService = MachineService();
      Machine? _machine = await _machineService.getMachineById(machineId);

      if(_machine != null && (_machine.minimumAverageValue == 0 || _machine.maximumAverageValue == 0)){
        if(await _machineService.setAverageMachine(machineId)){
          _machine = await _machineService.getMachineById(machineId);
        }
      }

      if(_machine != null){
        double averageValue = int.parse(clock1) / int.parse(clock2);

        return averageValue < _machine.minimumAverageValue || averageValue > _machine.maximumAverageValue;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}