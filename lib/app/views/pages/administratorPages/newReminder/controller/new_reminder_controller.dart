import 'package:elephant_control/app/views/pages/widgetsShared/loading_with_success_or_error_widget.dart';
import 'package:elephant_control/base/services/machine_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../base/models/machine/machine.dart';
import '../../../widgetsShared/popups/information_popup.dart';

class NewReminderController extends GetxController {
  late RxBool screenLoading;
  late final RxList<Machine> _machines;
  late final MachineService _machineService;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late final TextEditingController _searchMachines;

  NewReminderController() {
    _initializeVariables();
  }

  @override
  onInit() async {
    await _getMachines();
    super.onInit();
  }

  _initializeVariables() {
    screenLoading = true.obs;
    _machines = RxList<Machine>([]);
    _machineService = MachineService();
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
    _searchMachines = TextEditingController();
  }

  List<Machine> get machines => searchMachines.text.toLowerCase().trim().isEmpty
      ? _machines.where((p0) => p0.active == true).toList()
      : _machines
          .where(
              (p0) => p0.name.toLowerCase().trim().contains(searchMachines.text.toLowerCase().trim()) && p0.active == true)
          .toList();
  TextEditingController get searchMachines => _searchMachines;

  void updateList() => update(['machines']);

  Future<void> _getMachines() async {
    try {
      _machines.clear();
      _machines.addAll(await _machineService.getAllMachines());
      _machines.sort((a, b) => a.name.compareTo(b.name));
      _machines.refresh();
      screenLoading.value = false;
    } catch (_) {
      _machines.clear();
      await showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Erro buscar as máquinas! Tente novamente mais tarde.",
          );
        },
      );
      Get.back();
    }
  }
}
