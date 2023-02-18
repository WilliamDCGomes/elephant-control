import 'package:elephant_control/app/utils/format_numbers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../../base/models/machine/machine.dart';
import '../../../../../../base/services/machine_service.dart';
import '../../../../../../base/services/report_service.dart';
import '../../../../../../base/viewControllers/report_viewcontroller.dart';
import '../../../widgetsShared/button_widget.dart';
import '../../../widgetsShared/checkbox_list_tile_widget.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/popups/default_popup_widget.dart';
import '../../../widgetsShared/popups/information_popup.dart';
import '../../../widgetsShared/popups/month_year_picker_popup.dart';
import '../../../widgetsShared/text_button_widget.dart';

class ClosingReportController extends GetxController {
  late int month;
  late int year;
  late DateTime closingReportDateFilter;
  late RxBool screenLoading;
  late RxBool showOneReport;
  late RxString machineSelected;
  late RxList<String> machinesNameList;
  late RxList<Machine> machinesList;
  late ReportViewController? reportViewController;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late MachineService _machineService;
  late ReportService _reportService;
  late RxBool showInfos;

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
    month = DateTime.now().month;
    year = DateTime.now().year;
    closingReportDateFilter = DateTime.now();
    screenLoading = true.obs;
    showOneReport = false.obs;
    machineSelected = "".obs;
    machinesNameList = <String>[].obs;
    machinesList = <Machine>[].obs;
    reportViewController = null;
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
    _machineService = MachineService();
    _reportService = ReportService();
    showInfos = true.obs;
  }

  _getMachines() async {
    try {
      machinesList.value = await _machineService.getAll();

      machinesList.sort((a, b) => a.name.compareTo(b.name));

      machinesList.forEach((element) => element.selected = true);

      machineSelected.value = "Todas as Máquinas";

      for (var i = 0; i < machinesList.length; i++) {
        if (i + 1 < machinesList.length && machinesList[i].name.startsWith(machinesList[i + 1].name)) {
          machinesList[i + 1].name += " - rep";
        }
        if (!machinesList[i].name.contains(" - rep")) {
          machinesNameList.add(machinesList[i].name);
        }
      }

      await getReport(loadingEnabled: false);

      screenLoading.value = false;
    } catch (_) {
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

  selectedMachines() async {
    bool allUsersSelected = true;
    await showDialog(
      context: Get.context!,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => DefaultPopupWidget(
          title: "Selecione as máquinas",
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButtonWidget(
              widgetCustom: Align(
                alignment: Alignment.centerLeft,
                child: CheckboxListTileWidget(
                  radioText: "Selecionar todas",
                  size: 4.h,
                  checked: allUsersSelected,
                  justRead: true,
                  onChanged: () {},
                ),
              ),
              onTap: () async {
                setState(() {
                  allUsersSelected = !allUsersSelected;
                  machinesList.forEach((user) {
                    user.selected = allUsersSelected;
                  });
                });
              },
            ),
            SizedBox(
              height: 40.h,
              child: ListView.builder(
                itemCount: machinesList.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) => TextButtonWidget(
                  widgetCustom: Align(
                    alignment: Alignment.centerLeft,
                    child: CheckboxListTileWidget(
                      radioText: machinesList[index].name,
                      size: 4.h,
                      checked: machinesList[index].selected,
                      justRead: true,
                      onChanged: () {},
                    ),
                  ),
                  onTap: () async {
                    setState(() {
                      machinesList[index].selected = !machinesList[index].selected;
                      if(allUsersSelected && !machinesList[index].selected){
                        allUsersSelected = machinesList[index].selected;
                      }
                      else if(!allUsersSelected && machinesList[index].selected && machinesList.length == 1){
                        allUsersSelected = true;
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
                  if(machinesList.where((element) => element.selected).length == 1){
                    machineSelected.value = machinesList.firstWhere((element) => element.selected).name;
                  }
                  else if(machinesList.where((element) => element.selected).length == machinesList.length){
                    machineSelected.value = "Todas as Máquinas";
                  }
                  else if(machinesList.where((element) => element.selected).length > 1){
                    machineSelected.value = "Algumas Máquinas";
                  }
                  else{
                    machineSelected.value = "Nenhuma Máquina";
                  }

                  setState(() {
                    machinesList.sort((a, b) => a.name.compareTo(b.name));
                    machinesList.sort((a, b) => b.selected.toString().compareTo(a.selected.toString()));
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  getReport({bool loadingEnabled = true}) async {
    try {
      if(!machinesList.any((element) => element.selected)){
        await showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return InformationPopup(
              warningMessage: "Selecione pelo menos uma máquina para visualizar o relatório.",
            );
          },
        );
        return;
      }
      else if (loadingEnabled) {
        await loadingWithSuccessOrErrorWidget.startAnimation();
      }
      var machines = machinesList.where((element) => element.selected);

      List<String>? machineIdsSelected = <String>[];

      for(var machine in machines){
        if(machine.id != null){
          machineIdsSelected.add(machine.id!);
        }
      }

      //Para pegar tds os ids. Passar todos eles quebra o json
      if(machineIdsSelected.length == machinesList.length){
        machineIdsSelected = null;
      }
      else if(machineIdsSelected.length > 20){
        if (loadingEnabled) {
          await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
        }
        await showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return InformationPopup(
              warningMessage: "Não é possível passar mais de 20 máquinas ao mesmo tempo para filtrar.\nQuantidade adicionada: " + (machineIdsSelected != null ? FormatNumbers.scoreIntNumber(machineIdsSelected.length) : "0"),
            );
          },
        );
        return;
      }

      reportViewController = await _reportService.getClosingReport(
        closingReportDateFilter,
        machineIdsSelected,
      );
      showEspecificReport();
      update(["report-information"]);
      if (loadingEnabled) {
        await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
      }
    } catch (_) {
      if (loadingEnabled) {
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

  showEspecificReport(){
    showOneReport.value = machineSelected.value != "Todas as Máquinas" && machineSelected.value != "Algumas Máquinas" && machineSelected.value != "Nenhuma Máquina";
  }

  filterPerDate() async {
    await showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MonthYearPickerPopup(
          initialDate: closingReportDateFilter,
          returnFunction: (int returnMonth, int returnYear) => returnFunction(returnMonth, returnYear),
        );
      },
    );
  }

  returnFunction(int returnMonth, int returnYear) async {
    late DateTime picked;

    picked = DateTime(returnYear, returnMonth);

    if (picked != closingReportDateFilter) {
      closingReportDateFilter = picked;
      update(["initial-date-filter"]);
    }
  }
}
