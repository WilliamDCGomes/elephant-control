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
  late RxBool screenLoading;
  late RxBool nextScreenLoading;
  late TextEditingController searchMachines;
  late final RxList<VisitListViewController> _visits;
  late final RxList<Machine> _machines;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidgetTwo;
  late final VisitService _visitService;
  late final MachineService _machineService;
  late final UserVisitMachineService _userVisitMachineService;

  MaintenanceHistoryController() {
    _initializeVariables();
  }

  @override
  void onInit() async {
    await getVisitsOperatorByUserId(showLoad: false);
    screenLoading.value = false;
    super.onInit();
  }

  //Getters
  List<VisitListViewController> get visits => _visits;
  List<Machine> get machines {
    if (searchMachines.text.isNotEmpty) {
      return _machines.where((p0) => p0.name.toLowerCase().startsWith(searchMachines.text.toLowerCase())).toList();
    } else {
      return _machines;
    }
  }

  _initializeVariables() {
    screenLoading = true.obs;
    nextScreenLoading = true.obs;
    searchMachines = TextEditingController();
    _visits = <VisitListViewController>[].obs;
    _machines = <Machine>[].obs;
    _visitService = VisitService();
    _userVisitMachineService = UserVisitMachineService();
    _machineService = MachineService();

    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
    loadingWithSuccessOrErrorWidgetTwo = LoadingWithSuccessOrErrorWidget();
  }

  void updateList() => _machines.refresh();

  Future<void> getVisitsOperatorByUserId({bool showLoad = true}) async {
    try {
      if(showLoad){
        await loadingWithSuccessOrErrorWidget.startAnimation();
      }
      else{
        screenLoading.value = true;
      }
      _visits.clear();
      _visits.addAll(await _visitService.getVisitsOperatorByUserId());
    } catch (_) {
      _visits.clear();
    } finally {
      if(showLoad){
        await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
      }
      else{
        screenLoading.value = false;
      }
    }
  }

  Future<void> getMachineVisitByUserId({bool showLoad = true}) async {
    try {
      if(showLoad) {
        await loadingWithSuccessOrErrorWidgetTwo.startAnimation();
      }
      _machines.clear();
      _machines.addAll(await _machineService.getMachineVisitByUserId());
      if (_machines.isNotEmpty) _machines.sort((a, b) => a.name.trim().toLowerCase().compareTo(b.name.trim().toLowerCase()));
    } catch (_) {
      _machines.clear();
    } finally {
      if(showLoad) {
        await loadingWithSuccessOrErrorWidgetTwo.stopAnimation(justLoading: true);
      }
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
      await loadingWithSuccessOrErrorWidgetTwo.stopAnimation(justLoading: true);
    }
  }

  newItem() async {
    Get.to(() => AppNewMaintenancePage(
          title: "Selecione um atendimento para adicionar a sua lista",
          controller: this,
        ));
  }
}
