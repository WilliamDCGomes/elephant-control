import 'package:elephant_control/app/utils/date_format_to_brazil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../../base/models/machine/machine.dart';
import '../../../../../../base/services/machine_service.dart';
import '../../../../../../base/services/report_service.dart';
import '../../../../../../base/viewControllers/report_viewcontroller.dart';
import '../../../../../utils/format_numbers.dart';
import '../../../../../utils/generate_report_pdf.dart';
import '../../../widgetsShared/button_widget.dart';
import '../../../widgetsShared/checkbox_list_tile_widget.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/popups/default_popup_widget.dart';
import '../../../widgetsShared/popups/information_popup.dart';
import '../../../widgetsShared/text_button_widget.dart';

class AdminReportController extends GetxController {
  late DateTime initialDateFilter;
  late DateTime finalDateFilter;
  late TimeOfDay initialHourFilter;
  late TimeOfDay finalHourFilter;
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

  AdminReportController() {
    _initializeVariables();
  }

  @override
  void onInit() async {
    super.onInit();
    await _getMachines();
    screenLoading.value = false;
  }

  _initializeVariables() {
    initialDateFilter = DateFormatToBrazil.firstDateOfMonth();
    finalDateFilter = DateTime.now();
    initialHourFilter = TimeOfDay(hour: 0, minute: 0);
    finalHourFilter = TimeOfDay(hour: 23, minute: 59);

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

      machinesList.forEach((element) => element.selected = true);

      machineSelected.value = "Todas as Máquinas";

      machinesList.sort((a, b) => a.name.compareTo(b.name));

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
    bool allMachinesSelected = true;
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
                  checked: allMachinesSelected,
                  justRead: true,
                  onChanged: () {},
                ),
              ),
              onTap: () async {
                setState(() {
                  allMachinesSelected = !allMachinesSelected;
                  machinesList.forEach((user) {
                    user.selected = allMachinesSelected;
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
                      if(allMachinesSelected && !machinesList[index].selected){
                        allMachinesSelected = machinesList[index].selected;
                      }
                      else if(!allMachinesSelected && machinesList[index].selected && machinesList.length == 1){
                        allMachinesSelected = true;
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

      initialDateFilter = DateTime(
        initialDateFilter.year,
        initialDateFilter.month,
        initialDateFilter.day,
        initialHourFilter.hour,
        initialHourFilter.minute,
      );
      finalDateFilter = DateTime(
        finalDateFilter.year,
        finalDateFilter.month,
        finalDateFilter.day,
        finalHourFilter.hour,
        finalHourFilter.minute,
      );

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

      reportViewController = await _reportService.getDefaultReport(
        initialDateFilter,
        finalDateFilter,
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

  generateReportPdf() async {
    try{
      if(reportViewController != null){

        var machines = machinesList.where((element) => element.selected);

        if(machines.isEmpty){
          await showDialog(
            context: Get.context!,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return InformationPopup(
                warningMessage: "Selecione pelo menos uma máquina para gerar o relatório.",
              );
            },
          );
          return;
        }

        List<String> machineNames = <String>[];
        machines.forEach((element) => machineNames.add(element.name));

        var reportFile = machineNames.length > 1 ? await GenerateReportPdf.generateGeneralPdf(machineNames, reportViewController!, DateFormatToBrazil.formatDateAndHour(initialDateFilter) + " até " + DateFormatToBrazil.formatDateAndHour(finalDateFilter)) :
        await GenerateReportPdf.generateSpecificPdf(machineNames.first, reportViewController!, DateFormatToBrazil.formatDateAndHour(initialDateFilter) + " até " + DateFormatToBrazil.formatDateAndHour(finalDateFilter));
        if(reportFile != null){
          await Share.shareXFiles(
            [XFile(reportFile.path)],
            text: "Relatório " + DateFormatToBrazil.formatDateAndHour(DateTime.now()),
          );
        }
        else{
          throw Exception();
        }
      }
    }
    catch(_){
      await showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Erro ao exportar o relatório! Tente diminuir a quantidade de máquinas selecionadas para exportar o relatório.",
          );
        },
      );
    }
  }

  showEspecificReport(){
    showOneReport.value = machineSelected.value != "Todas as Máquinas" && machineSelected.value != "Algumas Máquinas" && machineSelected.value != "Nenhuma Máquina";
  }

  filterPerInitialDate() async {
    DateTime auxDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      helpText: "SELECIONE UMA DATA",
      confirmText: "Selecionar",
      cancelText: "Cancelar",
      initialDate: initialDateFilter,
      firstDate: DateTime(auxDate.year - 2, auxDate.month, auxDate.day),
      lastDate: auxDate,
    );

    if (picked != null && picked != initialDateFilter) {
      initialDateFilter = picked;
      update(["initial-date-filter"]);
    }
  }

  filterPerFinalDate() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      helpText: "SELECIONE UMA DATA",
      confirmText: "Selecionar",
      cancelText: "Cancelar",
      initialDate: finalDateFilter,
      firstDate: DateTime(finalDateFilter.year - 2, finalDateFilter.month, finalDateFilter.day),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != finalDateFilter) {
      finalDateFilter = picked;
      update(["final-date-filter"]);
    }
  }

  filterPerInitialHour() async {
    var picked = await showTimePicker(
      context: Get.context!,
      helpText: "SELECIONE UMA HORA",
      confirmText: "Selecionar",
      cancelText: "Cancelar",
      initialTime: initialHourFilter,
    );

    if (picked != null && picked != initialDateFilter) {
      initialHourFilter = picked;
      update(["initial-hour-filter"]);
    }
  }

  filterPerFinalHour() async {
    var picked = await showTimePicker(
      context: Get.context!,
      helpText: "SELECIONE UMA HORA",
      confirmText: "Selecionar",
      cancelText: "Cancelar",
      initialTime: finalHourFilter,
    );

    if (picked != null && picked != finalHourFilter) {
      finalHourFilter = picked;
      update(["final-hour-filter"]);
    }
  }
}
