import 'package:elephant_control/app/views/pages/operatorPages/maintenanceHistory/pages/add_new_maintenance_page.dart';
import 'package:elephant_control/base/models/machine/machine.dart';
import 'package:elephant_control/base/services/machine_service.dart';
import 'package:elephant_control/base/services/user_visit_machine_service.dart';
import 'package:elephant_control/base/services/visit_service.dart';
import 'package:elephant_control/base/viewControllers/visit_list_viewcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/popups/information_popup.dart';

class MaintenanceHistoryController extends GetxController {
  late TextEditingController searchMachines;
  late final RxList<VisitListViewController> _visits;
  late final RxList<Machine> _machines;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidgetTwo;
  late final VisitService _visitService;
  late final MachineService _machineService;
  late final UserVisitMachineService _userVisitMachineService;
  late final RxList<Machine> _machinesScreen;

  MaintenanceHistoryController() {
    _initializeVariables();
  }

  @override
  void onInit() async {
    await Future.delayed(Duration(milliseconds: 200));
    await getVisitsOperatorByUserId();
    super.onInit();
  }

  //Getters
  List<VisitListViewController> get visits => _visits
      // .where(
      //   (p0) => p0.inclusion?.day == DateTime.now().day && p0.inclusion?.month == DateTime.now().month && p0.inclusion?.year == DateTime.now().year,
      // )
      // .toList();
      ;
  List<Machine> get machines => _machinesScreen;

  _initializeVariables() {
    searchMachines = TextEditingController();
    _visits = <VisitListViewController>[].obs;
    _machines = <Machine>[].obs;
    _machinesScreen = <Machine>[].obs;
    _visitService = VisitService();
    _userVisitMachineService = UserVisitMachineService();
    _machineService = MachineService();

    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
    loadingWithSuccessOrErrorWidgetTwo = LoadingWithSuccessOrErrorWidget();
  }

  Future<void> getVisitsOperatorByUserId() async {
    try {
      await loadingWithSuccessOrErrorWidget.startAnimation();
      _visits.clear();
      _visits.addAll(await _visitService.getVisitsOperatorByUserId());
    } catch (_) {
      _visits.clear();
    } finally {
      await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
    }
  }

  searchMachinesByName(String machineName) {
    try {
      _machinesScreen.clear();
      if (machineName.isNotEmpty) {
        _machinesScreen.addAll(_machines.where((p0) => p0.name.toLowerCase().startsWith(machineName.toLowerCase())));
      } else {
        _machinesScreen.addAll(_machines);
      }
      _machinesScreen.sort((a, b) => a.name.compareTo(b.name));
    } catch (_) {
      _machinesScreen.value = <Machine>[];
    }
  }

  Future<void> getMachineVisitByUserId() async {
    try {
      await loadingWithSuccessOrErrorWidgetTwo.startAnimation();
      _machines.clear();
      _machines.addAll(await _machineService.getMachineVisitByUserId());
      _machinesScreen.addAll(_machines);
      if (_machinesScreen.isNotEmpty) _machinesScreen.sort((a, b) => a.name.compareTo(b.name));
    } catch (_) {
      _machines.clear();
    } finally {
      await loadingWithSuccessOrErrorWidgetTwo.stopAnimation(justLoading: true);
    }
  }

  Future<void> deleteOrUndeleteVisitDay(VisitListViewController visit) async {
    try {
      await loadingWithSuccessOrErrorWidget.startAnimation();
      if (visit.active == true) {
        final visitDeletedOrUndelete = await UserVisitMachineService().deleteUserVisitMachine(visit.id!);
        if (visitDeletedOrUndelete) visit.active = false;
      } else {
        final visitDeletedOrUndelete = await UserVisitMachineService().unDeleteUserVisitMachine(visit.id!);
        if (visitDeletedOrUndelete) visit.active = false;
      }
    } catch (_) {
    } finally {
      _visits.refresh();
      await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
    }
  }

  Future<void> createuserMachine(String machineId) async {
    try {
      await loadingWithSuccessOrErrorWidgetTwo.startAnimation();
      final userMachineCreated = await _userVisitMachineService.createUserVisitMachine(machineId, DateTime.now());
      if (!userMachineCreated) throw Exception();
      await showDialog(context: Get.context!, builder: (_) => InformationPopup(warningMessage: "Máquina adicionada com sucesso"));
      Get.back();
    } catch (_) {
      if (!loadingWithSuccessOrErrorWidgetTwo.isLoading.isTrue) await loadingWithSuccessOrErrorWidgetTwo.stopAnimation(fail: true);
      await showDialog(context: Get.context!, builder: (_) => InformationPopup(warningMessage: "Erro ao adicionar máquina"));
    } finally {
      if (!loadingWithSuccessOrErrorWidgetTwo.isLoading.isTrue) await loadingWithSuccessOrErrorWidgetTwo.stopAnimation();
    }
  }

  newItem() async {
    Get.to(() => AppNewMaintenancePage(
          title: "Selecione um atendimento para adicionar a sua lista",
          controller: this,
        ));
  }
}
