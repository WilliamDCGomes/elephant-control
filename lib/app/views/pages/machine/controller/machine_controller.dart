import 'package:elephant_control/app/views/pages/widgetsShared/loading_with_success_or_error_widget.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/popups/information_popup.dart';
import 'package:elephant_control/base/services/machine_service.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import '../../../../../base/models/machine/model/machine.dart';
import '../../administratorPages/registerMachine/page/register_machine_page.dart';

class MachineController extends GetxController {
  late TextEditingController searchMachines;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late final MachineService _machineService;
  late final RxList<Machine> _machines;
  late final RxList<Machine> _machinesScreen;

  MachineController() {
    searchMachines = TextEditingController();
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
    _machineService = MachineService();
    _machines = <Machine>[].obs;
    _machinesScreen = <Machine>[].obs;
  }
  @override
  onInit() async {
    await Future.delayed(Duration(milliseconds: 200));
    await getMachines();
    super.onInit();
  }

  //Getters
  List<Machine> get machines => _machinesScreen;

  Future<void> getMachines() async {
    try {
      await loadingWithSuccessOrErrorWidget.startAnimation();
      _machines.clear();
      _machines.addAll(await _machineService.getAll());
    } catch (e) {
      print(e);
    } finally {
      _machines.refresh();
      _machinesScreen.addAll(_machines);
      _machinesScreen.sort((a, b) => a.name.compareTo(b.name));
      await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
    }
  }

  searchMachinesByName(String machineName){
    try{
      _machinesScreen.clear();
      if(machineName.isNotEmpty) {
        _machinesScreen.addAll(_machines.where((p0) =>
            p0.name.toLowerCase().startsWith(machineName.toLowerCase())));
      }
      else{
        _machinesScreen.addAll(_machines);
      }
      _machinesScreen.sort((a, b) => a.name.compareTo(b.name));
    }
    catch(_){
      _machinesScreen.value = <Machine>[];
    }
  }

  Future<void> addUserMachine() async {
    try {
      await loadingWithSuccessOrErrorWidget.startAnimation();
    } catch (_) {
    } finally {
      await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
    }
  }

  Future<void> deleteMachine(Machine machine) async {
    try {
      await loadingWithSuccessOrErrorWidget.startAnimation();
      machine.active = false;
      final deleted = await _machineService.createOrUpdateMachine(machine);
      if (!deleted) throw Exception();
      await showDialog(context: Get.context!, builder: (context) => InformationPopup(warningMessage: "Máquina deletada com sucesso"));
    } catch (_) {
      await showDialog(context: Get.context!, builder: (context) => InformationPopup(warningMessage: "Não foi possível deletar a máquina"));
    } finally {
      await getMachines();
      await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
    }
  }

  Future<void> editMachine(Machine machine) async {
    final _machine = await Get.to(() => RegisterMachinePage(machine: machine, edit: true,));
    if (_machine is! Machine) return;
    try {
      await loadingWithSuccessOrErrorWidget.startAnimation();
      final editted = await _machineService.createOrUpdateMachine(machine);
      if (!editted) throw Exception();
      await loadingWithSuccessOrErrorWidget.stopAnimation();
      await showDialog(context: Get.context!, builder: (context) => InformationPopup(warningMessage: "Máquina editada com sucesso"));
    } catch (_) {
      await loadingWithSuccessOrErrorWidget.stopAnimation(fail: true);
      await showDialog(context: Get.context!, builder: (context) => InformationPopup(warningMessage: "Não foi possível editar a máquina"));
    }
  }
}
