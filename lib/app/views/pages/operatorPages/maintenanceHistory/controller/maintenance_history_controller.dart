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
  late Function refreshList;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;

  MaintenanceHistoryController(this.refreshList){
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
        status: "Finalizado".obs,
        workPriority: "ALTA",
        priorityColor: AppColors.redColor.value,
        clock1: "2566321",
        clock2: "1556623",
        pouchCollected: true,
        teddy: "25",
        showMap: true,
      ),
      MaintenanceCardWidget(
        machineName: "Supermercado Central",
        status: "Pendente".obs,
        workPriority: "NORMAL",
        priorityColor: AppColors.greenColor.value,
        clock1: "0",
        clock2: "0",
        pouchCollected: false,
        teddy: "0",
        showMap: true,
      ),
      MaintenanceCardWidget(
        machineName: "Cinema Alameda",
        status: "Pendente".obs,
        workPriority: "NORMAL",
        priorityColor: AppColors.greenColor.value,
        clock1: "0",
        clock2: "0",
        pouchCollected: false,
        teddy: "0",
        showMap: true,
      ),
    ];

    allMaintenanceCardWidgetList.value = <MaintenanceCardWidget>[
      MaintenanceCardWidget(
        machineName: "Shopping Oeste",
        status: "Pendente".obs,
        workPriority: "NORMAL",
        priorityColor: AppColors.greenColor.value,
        clock1: "0",
        clock2: "0",
        pouchCollected: false,
        teddy: "0",
      ),
      MaintenanceCardWidget(
        machineName: "Supermercado Oeste",
        status: "Pendente".obs,
        workPriority: "ALTA",
        priorityColor: AppColors.redColor.value,
        clock1: "0",
        clock2: "0",
        pouchCollected: false,
        teddy: "0",
      ),
      MaintenanceCardWidget(
        machineName: "Cinepólis",
        status: "Pendente".obs,
        workPriority: "NORMAL",
        priorityColor: AppColors.greenColor.value,
        clock1: "0",
        clock2: "0",
        pouchCollected: false,
        teddy: "0",
      ),
      MaintenanceCardWidget(
        machineName: "Supermercado Norte",
        status: "Pendente".obs,
        workPriority: "ALTA",
        priorityColor: AppColors.redColor.value,
        clock1: "0",
        clock2: "0",
        pouchCollected: false,
        teddy: "0",
      ),
      MaintenanceCardWidget(
        machineName: "Parque de Diversão",
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

  removeItemList(int index) async {
    await showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return ConfirmationPopup(
          title: "Aviso",
          subTitle: "Tem certeza que deseja remover esse atendimento da lista?",
          firstButton: () {},
          secondButton: () {
            maintenanceCardWidgetList[index].showMap = false;
            allMaintenanceCardWidgetList.add(
              MaintenanceCardWidget(
                machineName: maintenanceCardWidgetList[index].machineName,
                status: maintenanceCardWidgetList[index].status.value.obs,
                workPriority: maintenanceCardWidgetList[index].workPriority,
                priorityColor: maintenanceCardWidgetList[index].priorityColor,
                clock1: maintenanceCardWidgetList[index].clock1,
                clock2: maintenanceCardWidgetList[index].clock2,
                pouchCollected: maintenanceCardWidgetList[index].pouchCollected,
                teddy: maintenanceCardWidgetList[index].teddy,
              ),
            );
            maintenanceCardWidgetList[index].operatorDeletedMachine.value = true;
            maintenanceCardWidgetList[index].status.value = "Excluido";
            maintenanceCardWidgetList.sort(
              (a, b) => a.operatorDeletedMachine.toString().compareTo(
                b.operatorDeletedMachine.toString(),
              ),
            );
            refreshList();
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