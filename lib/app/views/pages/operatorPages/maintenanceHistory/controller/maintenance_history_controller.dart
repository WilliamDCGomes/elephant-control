import 'package:elephant_control/app/views/pages/operatorPages/maintenanceHistory/pages/add_new_maintenance_page.dart';
import 'package:elephant_control/app/views/stylePages/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/maintenance_card_widget.dart';
import '../../../widgetsShared/popups/confirmation_popup.dart';

class MaintenanceHistoryController extends GetxController {
  late RxList<MaintenanceCardWidget> maintenanceCardWidgetList;
  late RxList<MaintenanceCardWidget> allMaintenanceCardWidgetList;
  late RxBool loadingAnimation;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;

  MaintenanceHistoryController(){
    _initializeVariables();
    _inicializeList();
  }

  _initializeVariables(){
    loadingAnimation = false.obs;

    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget(
      loadingAnimation: loadingAnimation,
    );

    maintenanceCardWidgetList = <MaintenanceCardWidget>[].obs;
    allMaintenanceCardWidgetList = <MaintenanceCardWidget>[].obs;
  }

  _inicializeList(){
    maintenanceCardWidgetList.value = <MaintenanceCardWidget>[
      MaintenanceCardWidget(
        machineName: "Shopping Boulevard",
        status: "Finalizado",
        workPriority: "ALTA",
        priorityColor: AppColors.redColor.value,
        clock1: "2566321",
        clock2: "1556623",
        pouchCollected: true,
        teddy: "25",
      ),
      MaintenanceCardWidget(
        machineName: "Supermercado Central",
        status: "Pendente",
        workPriority: "NORMAL",
        priorityColor: AppColors.greenColor.value,
        clock1: "0",
        clock2: "0",
        pouchCollected: false,
        teddy: "0",
      ),
      MaintenanceCardWidget(
        machineName: "Cinema Alameda",
        status: "Pendente",
        workPriority: "NORMAL",
        priorityColor: AppColors.greenColor.value,
        clock1: "0",
        clock2: "0",
        pouchCollected: false,
        teddy: "0",
      ),
    ];

    allMaintenanceCardWidgetList.value = <MaintenanceCardWidget>[
      MaintenanceCardWidget(
        machineName: "Shopping Oeste",
        status: "Pendente",
        workPriority: "NORMAL",
        priorityColor: AppColors.greenColor.value,
        clock1: "0",
        clock2: "0",
        pouchCollected: false,
        teddy: "0",
      ),
      MaintenanceCardWidget(
        machineName: "Supermercado Oeste",
        status: "Pendente",
        workPriority: "ALTA",
        priorityColor: AppColors.redColor.value,
        clock1: "0",
        clock2: "0",
        pouchCollected: false,
        teddy: "0",
      ),
      MaintenanceCardWidget(
        machineName: "Cinepólis",
        status: "Pendente",
        workPriority: "NORMAL",
        priorityColor: AppColors.greenColor.value,
        clock1: "0",
        clock2: "0",
        pouchCollected: false,
        teddy: "0",
      ),
      MaintenanceCardWidget(
        machineName: "Supermercado Norte",
        status: "Pendente",
        workPriority: "ALTA",
        priorityColor: AppColors.redColor.value,
        clock1: "0",
        clock2: "0",
        pouchCollected: false,
        teddy: "0",
      ),
      MaintenanceCardWidget(
        machineName: "Parque de Diversão",
        status: "Pendente",
        workPriority: "NORMAL",
        priorityColor: AppColors.greenColor.value,
        clock1: "0",
        clock2: "0",
        pouchCollected: false,
        teddy: "0",
      ),
    ]; 
  }

  removeItemList(int index) async {
    await showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return ConfirmationPopup(
          title: "Aviso",
          subTitle: "Tem certeza que deseja remover esse atendimento da lista?",
          firstButton: () {},
          secondButton: () {
            allMaintenanceCardWidgetList.add(maintenanceCardWidgetList[index]);
            maintenanceCardWidgetList.removeAt(index);
          },
        );
      },
    );
  }

  newItem() async {
    Get.to(() => AppNewMaintenancePage(
      title: "Selecione um atendimento para adicionar a sua lista",
      controller: this,
    ));
  }
}