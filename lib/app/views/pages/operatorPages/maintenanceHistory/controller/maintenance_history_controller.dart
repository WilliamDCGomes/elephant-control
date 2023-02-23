import 'package:elephant_control/app/views/pages/operatorPages/maintenanceHistory/pages/add_new_maintenance_page.dart';
import 'package:elephant_control/base/models/machine/machine.dart';
import 'package:elephant_control/base/repositories/machine_repository.dart';
import 'package:elephant_control/base/repositories/user_visit_machine_repository.dart';
import 'package:elephant_control/base/repositories/visit_repository.dart';
import 'package:elephant_control/base/services/machine_service.dart';
import 'package:elephant_control/base/services/user_visit_machine_service.dart';
import 'package:elephant_control/base/services/visit_service.dart';
import 'package:elephant_control/base/viewControllers/visit_list_viewcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../widgetsShared/button_widget.dart';
import '../../../widgetsShared/checkbox_list_tile_widget.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/popups/default_popup_widget.dart';
import '../../../widgetsShared/popups/information_popup.dart';
import '../../../widgetsShared/text_button_widget.dart';

class MaintenanceHistoryController extends GetxController {
  late RxBool screenLoading;
  late RxBool nextScreenLoading;
  late TextEditingController searchMachines;
  late final RxList<VisitListViewController> _visits;
  late final RxList<Machine> _machines;
  late RxList<Machine> machinesScreen;
  late List<Machine> _machinesCities;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidgetTwo;
  late final VisitService _visitService;
  late final MachineService _machineService;
  late final UserVisitMachineService _userVisitMachineService;
  late final bool offline;
  late bool firstGetMachineCities;

  MaintenanceHistoryController(this.offline) {
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

  _initializeVariables() {
    firstGetMachineCities = true;
    screenLoading = true.obs;
    nextScreenLoading = true.obs;
    searchMachines = TextEditingController();
    _visits = <VisitListViewController>[].obs;
    _machines = <Machine>[].obs;
    machinesScreen = <Machine>[].obs;
    _machinesCities = <Machine>[].obs;
    _visitService = VisitService();
    _userVisitMachineService = UserVisitMachineService();
    _machineService = MachineService();

    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
    loadingWithSuccessOrErrorWidgetTwo = LoadingWithSuccessOrErrorWidget();
  }

  void updateList() {
    if (searchMachines.text.isNotEmpty) {
      machinesScreen.clear();
      machinesScreen.addAll(_machines.where((p0) => p0.name.toLowerCase().contains(searchMachines.text.toLowerCase())).toList());
      _getMachineCities(machinesScreen);
    }
    else {
      machinesScreen.addAll(_machines);
      _getMachineCities(machinesScreen);
    }
    machinesScreen.refresh();
  }

  Future<void> getVisitsOperatorByUserId({bool showLoad = true}) async {
    try {
      if (showLoad) {
        await loadingWithSuccessOrErrorWidget.startAnimation();
      } else {
        screenLoading.value = true;
      }
      _visits.clear();
      _visits.addAll(
          (offline ? await VisitRepository().getVisitsOperatorByUserId() : await _visitService.getVisitsOperatorByUserId())
              .toList()
            ..sort((a, b) => (a.machineName).compareTo(b.machineName))
            ..sort((a, b) => (a.status?.index ?? -1).compareTo(b.status?.index ?? -1))
            ..sort((a, b) => (a.active == true ? -1 : 0).compareTo(b.active == true ? -1 : 0)));


    } catch (_) {
      _visits.clear();
    } finally {
      // _visits.sort((a, b) => (a.status?.index ?? -1).compareTo(b.status?.index ?? -1));
      // _visits.sort((a, b) {
      //   if (a.status == null || b.status == null) {
      //     return -1;
      //   }
      //   return 0;
      // });
      _visits.refresh();
      if (showLoad) {
        await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
      } else {
        screenLoading.value = false;
      }
    }
  }

  Future<void> getMachineVisitByUserId({bool showLoad = true}) async {
    try {
      if (showLoad) {
        await loadingWithSuccessOrErrorWidgetTwo.startAnimation();
      }
      _machines.clear();
      machinesScreen.clear();
      _machines.addAll(
          offline ? await MachineRepository().getMachineVisitByUserId() : await _machineService.getMachineVisitByUserId());
      if (_machines.isNotEmpty) _machines.sort((a, b) => a.name.trim().toLowerCase().compareTo(b.name.trim().toLowerCase()));
      machinesScreen.addAll(_machines);
      _getMachineCities(machinesScreen);
    } catch (_) {
      _machines.clear();
      machinesScreen.clear();
    } finally {
      if (showLoad) {
        await loadingWithSuccessOrErrorWidgetTwo.stopAnimation(justLoading: true);
      }
    }
  }

  _getMachineCities(List<Machine> allMachines){
    _machinesCities.clear();
    for(var machine in allMachines){
      if(!_machinesCities.any((element) => element.city.trim() == machine.city.trim()) && machine.city.trim() != ""){
        if(firstGetMachineCities){
          machine.selected = true;
        }
        _machinesCities.add(machine);
      }
    }
    firstGetMachineCities = false;
  }

  selectedCities() async {
    bool allCitiesSelected = true;
    await showDialog(
      context: Get.context!,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => DefaultPopupWidget(
          title: "Selecione as cidades das máquinas que deseja filtrar",
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButtonWidget(
              widgetCustom: Align(
                alignment: Alignment.centerLeft,
                child: CheckboxListTileWidget(
                  radioText: "Selecionar todas",
                  size: 4.h,
                  checked: allCitiesSelected,
                  justRead: true,
                  onChanged: () {},
                ),
              ),
              onTap: () async {
                setState(() {
                  allCitiesSelected = !allCitiesSelected;
                  _machinesCities.forEach((user) {
                    user.selected = allCitiesSelected;
                  });
                });
              },
            ),
            SizedBox(
              height: 40.h,
              child: ListView.builder(
                itemCount: _machinesCities.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) => TextButtonWidget(
                  widgetCustom: Align(
                    alignment: Alignment.centerLeft,
                    child: CheckboxListTileWidget(
                      radioText: _machinesCities[index].city,
                      size: 4.h,
                      checked: _machinesCities[index].selected,
                      justRead: true,
                      onChanged: () {},
                    ),
                  ),
                  onTap: () async {
                    setState(() {
                      _machinesCities[index].selected = !_machinesCities[index].selected;
                      if(allCitiesSelected && !_machinesCities[index].selected){
                        allCitiesSelected = _machinesCities[index].selected;
                      }
                      else if(!allCitiesSelected && _machinesCities[index].selected && _machinesCities.length == 1){
                        allCitiesSelected = true;
                      }
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(2.h),
              child: ButtonWidget(
                hintText: "SELECIONAR",
                textSize: 16.sp,
                fontWeight: FontWeight.bold,
                widthButton: double.infinity,
                onPressed: () {
                  Get.back();

                  setState(() {
                    _machinesCities.sort((a, b) => a.name.compareTo(b.name));
                    _machinesCities.sort((a, b) => b.selected.toString().compareTo(a.selected.toString()));
                  });

                  if(_machinesCities.where((element) => element.selected).length == _machinesCities.length){
                    updateList();
                  }
                  else{
                    _filterListPerCities();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _filterListPerCities(){
    try{
      var selectedMachines = _machinesCities.where((element) => element.selected).toList();
      machinesScreen.clear();
      machinesScreen.addAll(_machines.where((machine) => selectedMachines.any((element) => element.city.trim() == machine.city.trim())));
      machinesScreen.refresh();
    }
    catch(_){
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Erro ao filtrar a lista.",
          );
        },
      );
    }
  }

  Future<void> deleteOrUndeleteVisitDay(VisitListViewController visit) async {
    try {
      await loadingWithSuccessOrErrorWidget.startAnimation();
      if (visit.active == true) {
        final visitDeletedOrUndelete = offline
            ? await UserVisitMachineRepository().deleteUserVisitMachine(visit.id!, visit.realizedVisit == true)
            : await UserVisitMachineService().deleteUserVisitMachine(visit.id!);
        if (visitDeletedOrUndelete) visit.active = false;
      } else {
        final visitDeletedOrUndelete = offline
            ? await UserVisitMachineRepository().unDeleteUserVisitMachine(visit.id!)
            : await UserVisitMachineService().unDeleteUserVisitMachine(visit.id!);
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
      final userMachineCreated = offline
          ? await UserVisitMachineRepository().createUserVisitMachine(machineId, DateTime.now())
          : await _userVisitMachineService.createUserVisitMachine(machineId, DateTime.now());
      if (!userMachineCreated) throw Exception();
      await loadingWithSuccessOrErrorWidgetTwo.stopAnimation();
      await showDialog(
          context: Get.context!, builder: (_) => InformationPopup(warningMessage: "Máquina adicionada com sucesso"));
      Get.back();
    } catch (_) {
      await loadingWithSuccessOrErrorWidgetTwo.stopAnimation(fail: true);
      await showDialog(context: Get.context!, builder: (_) => InformationPopup(warningMessage: "Erro ao adicionar máquina"));
    }
  }

  newItem() async {
    Get.to(() => AppNewMaintenancePage(
          title: "Selecione um atendimento para adicionar a sua lista",
          controller: this,
        ));
  }
}
