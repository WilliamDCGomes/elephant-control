import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/maintenance_card_widget.dart';

class OperatorsVisitsController extends GetxController {
  late DateTime dateFilter;
  late RxBool loadingAnimation;
  late RxString userSelected;
  late RxList<String> usersName;
  late RxList<MaintenanceCardWidget> maintenanceCardWidgetList;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;

  OperatorsVisitsController(){
    _initializeVariables();
    _initializeList();
  }

  _initializeVariables(){
    dateFilter = DateTime.now();
    loadingAnimation = false.obs;
    userSelected = "".obs;
    usersName = <String>[].obs;
    maintenanceCardWidgetList = <MaintenanceCardWidget>[].obs;
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget(
      loadingAnimation: loadingAnimation,
    );
  }

  _initializeList(){
    usersName.addAll([
      "João",
      "Marcos",
      "André",
      "Carlos",
    ]);
  }

  getVisitsUser(String userName){
    maintenanceCardWidgetList.value = <MaintenanceCardWidget>[
      MaintenanceCardWidget(
        machineName: "Shopping Boulevard",
        responsibleName: userName,
        city: "Jaú",
        status: "Finalizado".obs,
        workPriority: "ALTA",
        priorityColor: AppColors.redColor.value,
        clock1: "2566321",
        clock2: "1556623",
        pouchCollected: true,
        teddy: "25",
      ),
      MaintenanceCardWidget(
        machineName: "Supermercado Central",
        responsibleName: userName,
        city: "Bauru",
        status: "Pendente".obs,
        workPriority: "NORMAL",
        priorityColor: AppColors.greenColor.value,
        clock1: "0",
        clock2: "0",
        pouchCollected: false,
        teddy: "0",
      ),
      MaintenanceCardWidget(
        machineName: "Cinema Alameda",
        responsibleName: userName,
        city: "Campinas",
        status: "Pendente".obs,
        workPriority: "NORMAL",
        priorityColor: AppColors.greenColor.value,
        clock1: "0",
        clock2: "0",
        pouchCollected: false,
        teddy: "0",
      ),
    ];
  }

  filterPerDate() async {
    DateTime auxDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      helpText: "SELECIONE UMA DATA",
      confirmText: "Selecionar",
      cancelText: "Cancelar",
      initialDate: dateFilter,
      firstDate: DateTime(auxDate.year - 2, auxDate.month, auxDate.day),
      lastDate: auxDate,
    );

    if (picked != null && picked != dateFilter) {
      dateFilter = picked;
      update(["date-filter"]);
    }
  }
}