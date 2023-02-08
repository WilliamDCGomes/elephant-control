import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../base/models/machine/machine.dart';
import '../../../../../../base/services/machine_service.dart';
import '../../../../../../base/services/report_service.dart';
import '../../../../../../base/viewControllers/report_viewcontroller.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/popups/information_popup.dart';

class ClosingReportController extends GetxController {
  late DateTime closingReportDateFilter;
  late RxBool screenLoading;
  late RxString machineSelected;
  late RxList<String> machinesNameList;
  late RxList<Machine> machinesList;
  late ReportViewController? reportViewController;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late MachineService _machineService;
  late ReportService _reportService;

  ClosingReportController() {
    _initializeVariables();
  }

  @override
  void onInit() async {
    super.onInit();
    await _getMachines();
    screenLoading.value = false;
  }

  _initializeVariables() {
    closingReportDateFilter = DateTime.now();
    screenLoading = true.obs;
    machineSelected = "".obs;
    machinesNameList = <String>[].obs;
    machinesList = <Machine>[].obs;
    reportViewController = null;
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
    _machineService = MachineService();
    _reportService = ReportService();
  }

  _getMachines() async {
    try{
      machinesList.value = await _machineService.getAll();

      machinesList.sort((a, b) => a.name.compareTo(b.name));

      machinesNameList.add("Todas");

      for (var i = 0; i < machinesList.length; i++) {
        if (i + 1 < machinesList.length && machinesList[i].name.startsWith(machinesList[i + 1].name)) {
          machinesList[i + 1].name += " - rep";
        }
        if(!machinesList[i].name.contains(" - rep")) {
          machinesNameList.add(machinesList[i].name);
        }
      }

      machineSelected.value = machinesNameList.first;
      await getReport(loadingEnabled: false);

      screenLoading.value = false;
    }
    catch(_){
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

  getReport({bool loadingEnabled = true}) async {
    try{
      if(loadingEnabled){
        await loadingWithSuccessOrErrorWidget.startAnimation();
      }

      reportViewController = await _reportService.getClosingReport(
        closingReportDateFilter,
        machineSelected.value != "" && machineSelected.value != "Todas" ?
        machinesList.firstWhere((element) => element.name == machineSelected.value).id :
        null,
      );

      update(["report-information"]);
      if(loadingEnabled){
        await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
      }
    }
    catch(_){
      if(loadingEnabled){
        await loadingWithSuccessOrErrorWidget.stopAnimation(fail: true);
      }
      await showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Erro gerar relatório! Tente novamente mais tarde.",
          );
        },
      );
    }
  }

  filterPerInitialDate() async {
    DateTime auxDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      helpText: "SELECIONE UMA DATA",
      confirmText: "Selecionar",
      cancelText: "Cancelar",
      initialDate: closingReportDateFilter,
      firstDate: DateTime(auxDate.year - 2, auxDate.month, auxDate.day),
      lastDate: auxDate,
    );

    if (picked != null && picked != closingReportDateFilter) {
      closingReportDateFilter = picked;
      update(["initial-date-filter"]);
    }
  }
}