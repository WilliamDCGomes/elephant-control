import 'package:elephant_control/app/views/pages/operatorPages/maintenanceHistory/pages/add_new_maintenance_page.dart';
import 'package:elephant_control/app/views/stylePages/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/maintenance_card_widget.dart';
import '../../../widgetsShared/popups/confirmation_popup.dart';
import '../../../widgetsShared/popups/information_popup.dart';
import '../popups/filter_maintenance_list_popup.dart';
import '../widgets/city_item_card_widget.dart';

class MaintenanceHistoryController extends GetxController {
  late RxList<MaintenanceCardWidget> maintenanceCardWidgetList;
  late RxList<MaintenanceCardWidget> allMaintenanceCardWidgetList;
  late RxList<MaintenanceCardWidget> allMaintenanceCardWidgetFilteredList;
  late RxList<CityItemCardWidget> cityItemCardWidgetList;
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
    allMaintenanceCardWidgetFilteredList = <MaintenanceCardWidget>[].obs;
    cityItemCardWidgetList = <CityItemCardWidget>[].obs;
  }

  _inicializeList(){
    maintenanceCardWidgetList.value = <MaintenanceCardWidget>[
      MaintenanceCardWidget(
        machineName: "Shopping Boulevard",
        city: "Jaú",
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
        city: "Bauru",
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
        city: "Campinas",
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
        city: "Campinas",
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
        city: "Jaú",
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
        machineName: "Supermercado Norte",
        city: "Botucatu",
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
        city: "Lençóis Paulista",
        status: "Pendente".obs,
        workPriority: "NORMAL",
        priorityColor: AppColors.greenColor.value,
        clock1: "0",
        clock2: "0",
        pouchCollected: false,
        teddy: "0",
      ),
    ];

    allMaintenanceCardWidgetList.sort((a, b) => a.workPriority.compareTo(b.workPriority));
    allMaintenanceCardWidgetFilteredList.addAll(allMaintenanceCardWidgetList);

    cityItemCardWidgetList.value = <CityItemCardWidget>[
      CityItemCardWidget(
        title: "Jaú",
      ),
      CityItemCardWidget(
        title: "Bauru",
      ),
      CityItemCardWidget(
        title: "Campinas",
      ),
      CityItemCardWidget(
        title: "Botucatu",
      ),
      CityItemCardWidget(
        title: "Lençóis Paulista",
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
            allMaintenanceCardWidgetFilteredList.add(
              MaintenanceCardWidget(
                machineName: maintenanceCardWidgetList[index].machineName,
                city: maintenanceCardWidgetList[index].city,
                status: maintenanceCardWidgetList[index].status.value.obs,
                workPriority: maintenanceCardWidgetList[index].workPriority,
                priorityColor: maintenanceCardWidgetList[index].priorityColor,
                clock1: maintenanceCardWidgetList[index].clock1,
                clock2: maintenanceCardWidgetList[index].clock2,
                pouchCollected: maintenanceCardWidgetList[index].pouchCollected,
                teddy: maintenanceCardWidgetList[index].teddy,
              ),
            );
            allMaintenanceCardWidgetList.add(
              MaintenanceCardWidget(
                machineName: maintenanceCardWidgetList[index].machineName,
                city: maintenanceCardWidgetList[index].city,
                status: maintenanceCardWidgetList[index].status.value.obs,
                workPriority: maintenanceCardWidgetList[index].workPriority,
                priorityColor: maintenanceCardWidgetList[index].priorityColor,
                clock1: maintenanceCardWidgetList[index].clock1,
                clock2: maintenanceCardWidgetList[index].clock2,
                pouchCollected: maintenanceCardWidgetList[index].pouchCollected,
                teddy: maintenanceCardWidgetList[index].teddy,
              ),
            );
            allMaintenanceCardWidgetList.sort((a, b) => a.workPriority.compareTo(b.workPriority));
            allMaintenanceCardWidgetFilteredList.sort((a, b) => a.workPriority.compareTo(b.workPriority));
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

  callFilterMaintenanceList() async {
    await showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return FilterMaintenanceListPopup(
          controller: this,
        );
      },
    );
  }

  filterMaintenanceList(int index){
    try{
      cityItemCardWidgetList.forEach((element) => element.isSelected = false);
      cityItemCardWidgetList[index].isSelected = true;
      allMaintenanceCardWidgetFilteredList.clear();
      for(var item in allMaintenanceCardWidgetList){
        if(item.city == cityItemCardWidgetList[index].title){
          allMaintenanceCardWidgetFilteredList.add(item);
        }
      }
    }
    catch(_){
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Erro ao filtrar a lista",
          );
        },
      );
      allMaintenanceCardWidgetFilteredList.addAll(allMaintenanceCardWidgetList);
    }
    finally{
      Get.back();
    }
  }

  removeFilter() async {
    await showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return ConfirmationPopup(
          title: "Aviso",
          subTitle: "Tem certeza que deseja remover o filtro?",
          firstButton: () {},
          secondButton: () async {
            allMaintenanceCardWidgetFilteredList.clear();
            cityItemCardWidgetList.forEach((element) => element.isSelected = false);
            allMaintenanceCardWidgetFilteredList.addAll(allMaintenanceCardWidgetList);
            await showDialog(
              context: Get.context!,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return InformationPopup(
                  warningMessage: "Filtro removido com sucesso",
                );
              },
            );
            refreshList();
            Get.back();
            Get.back();
          },
        );
      },
    );
  }
}