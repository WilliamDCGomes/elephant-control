import 'package:elephant_control/app/views/pages/widgetsShared/loading_with_success_or_error_widget.dart';
import 'package:elephant_control/base/services/machine_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../base/models/machine/model/machine.dart';

class ListMachineController extends GetxController {
  late final RxList<Machine> _machines;
  late final MachineService _machineService;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late final TextEditingController _searchMachines;

  ListMachineController() {
    _machines = RxList<Machine>([]);
    _machineService = MachineService();
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
    _searchMachines = TextEditingController();
    getMachines();
  }

  List<Machine> get machines => searchMachines.text.toLowerCase().trim().isEmpty ? _machines.where((p0) => p0.active == true).toList() : _machines.where((p0) => p0.name.toLowerCase().trim().contains(searchMachines.text.toLowerCase().trim()) && p0.active == true).toList();
  TextEditingController get searchMachines => _searchMachines;

  void updateList() => update(['machines']);

  void getMachines() async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      await loadingWithSuccessOrErrorWidget.startAnimation();
      _machines.clear();
      _machines.addAll(await _machineService.getAllMachines());
    } catch (_) {
      _machines.clear();
    } finally {
      _machines.sort((a, b) => a.name.compareTo(b.name));
      _machines.refresh();
      await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
    }
  }
}
