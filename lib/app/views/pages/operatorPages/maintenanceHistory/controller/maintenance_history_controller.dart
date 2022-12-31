import 'package:elephant_control/app/views/pages/operatorPages/maintenanceHistory/pages/add_new_maintenance_page.dart';
import 'package:elephant_control/base/models/machine/model/machine.dart';
import 'package:elephant_control/base/services/machine_service.dart';
import 'package:elephant_control/base/services/user_visit_machine_service.dart';
import 'package:elephant_control/base/services/visit_service.dart';
import 'package:elephant_control/base/viewControllers/visit_list_viewcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/popups/information_popup.dart';

class MaintenanceHistoryController extends GetxController {
  //MaintenanceCardWidget
  late final RxList<VisitListViewController> _visits;
  late final RxList<Machine> _machines;
  // late RxList<MaintenanceCardWidget> maintenanceCardWidgetList;
  // late RxList<MaintenanceCardWidget> allMaintenanceCardWidgetList;
  // late RxList<MaintenanceCardWidget> allMaintenanceCardWidgetFilteredList;
  // late RxList<CityItemCardWidget> cityItemCardWidgetList;
  late RxBool loadingAnimation;
  late RxBool loadingAnimationTwo;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidgetTwo;
  late final VisitService _visitService;
  late final MachineService _machineService;
  late final UserVisitMachineService _userVisitMachineService;

  MaintenanceHistoryController() {
    _initializeVariables();
    // _inicializeList();
  }

  @override
  void onInit() async {
    await Future.delayed(Duration(milliseconds: 200));
    await _getVisitsOperatorByUserId();
    super.onInit();
  }

  //Getters
  List<VisitListViewController> get visits => _visits
      .where(
        (p0) => p0.inclusion?.day == DateTime.now().day && p0.inclusion?.month == DateTime.now().month && p0.inclusion?.year == DateTime.now().year,
      )
      .toList();
  List<Machine> get machines => _machines;

  _initializeVariables() {
    _visits = <VisitListViewController>[].obs;
    _machines = <Machine>[].obs;
    _visitService = VisitService();
    _userVisitMachineService = UserVisitMachineService();
    _machineService = MachineService();
    loadingAnimation = false.obs;
    loadingAnimationTwo = false.obs;

    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget(
      loadingAnimation: loadingAnimation,
    );
    loadingWithSuccessOrErrorWidgetTwo = LoadingWithSuccessOrErrorWidget(
      loadingAnimation: loadingAnimationTwo,
    );

    // maintenanceCardWidgetList = <MaintenanceCardWidget>[].obs;
    // allMaintenanceCardWidgetList = <MaintenanceCardWidget>[].obs;
    // allMaintenanceCardWidgetFilteredList = <MaintenanceCardWidget>[].obs;
    // cityItemCardWidgetList = <CityItemCardWidget>[].obs;
  }

  Future<void> _getVisitsOperatorByUserId() async {
    try {
      loadingAnimation.value = true;
      await loadingWithSuccessOrErrorWidget.startAnimation();
      _visits.clear();
      _visits.addAll(await _visitService.getVisitsOperatorByUserId());
    } catch (_) {
      _visits.clear();
    } finally {
      await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
      loadingAnimation.value = false;
    }
  }

  Future<void> getMachineVisitByUserId() async {
    try {
      loadingAnimationTwo.value = true;
      await loadingWithSuccessOrErrorWidgetTwo.startAnimation();
      _machines.clear();
      _machines.addAll(await _machineService.getMachineVisitByUserId());
      if (_machines.isNotEmpty) _machines.sort((a, b) => a.name.compareTo(b.name));
    } catch (_) {
      _machines.clear();
    } finally {
      await loadingWithSuccessOrErrorWidgetTwo.stopAnimation(justLoading: true);
    }
  }

  Future<void> createuserMachine(String machineId) async {
    try {
      final userMachineCreated = await _userVisitMachineService.createUserVisitMachine(machineId, DateTime.now());
      if (!userMachineCreated) throw Exception();
      await showDialog(context: Get.context!, builder: (_) => InformationPopup(warningMessage: "Máquina adicionada com sucesso"));
      Get.back();
    } catch (_) {
      await showDialog(context: Get.context!, builder: (_) => InformationPopup(warningMessage: "Erro ao adicionar máquina"));
    } finally {}
  }
  // _inicializeList() {
  //   maintenanceCardWidgetList.value = <MaintenanceCardWidget>[
  //     MaintenanceCardWidget(
  //       machineName: "Shopping Boulevard",
  //       city: "Jaú",
  //       status: "Finalizado".obs,
  //       workPriority: "ALTA",
  //       priorityColor: AppColors.redColor.value,
  //       clock1: "2566321",
  //       clock2: "1556623",
  //       pouchCollected: true,
  //       teddy: "25",
  //       showMap: true,
  //     ),
  //     MaintenanceCardWidget(
  //       machineName: "Supermercado Central",
  //       city: "Bauru",
  //       status: "Pendente".obs,
  //       workPriority: "NORMAL",
  //       priorityColor: AppColors.greenColor.value,
  //       clock1: "0",
  //       clock2: "0",
  //       pouchCollected: false,
  //       teddy: "0",
  //       showMap: true,
  //     ),
  //     MaintenanceCardWidget(
  //       machineName: "Cinema Alameda",
  //       city: "Campinas",
  //       status: "Pendente".obs,
  //       workPriority: "NORMAL",
  //       priorityColor: AppColors.greenColor.value,
  //       clock1: "0",
  //       clock2: "0",
  //       pouchCollected: false,
  //       teddy: "0",
  //       showMap: true,
  //     ),
  //   ];

  //   allMaintenanceCardWidgetList.value = <MaintenanceCardWidget>[
  //     MaintenanceCardWidget(
  //       machineName: "Shopping Oeste",
  //       city: "Campinas",
  //       status: "Pendente".obs,
  //       workPriority: "NORMAL",
  //       priorityColor: AppColors.greenColor.value,
  //       clock1: "0",
  //       clock2: "0",
  //       pouchCollected: false,
  //       teddy: "0",
  //     ),
  //     MaintenanceCardWidget(
  //       machineName: "Supermercado Oeste",
  //       city: "Jaú",
  //       status: "Pendente".obs,
  //       workPriority: "ALTA",
  //       priorityColor: AppColors.redColor.value,
  //       clock1: "0",
  //       clock2: "0",
  //       pouchCollected: false,
  //       teddy: "0",
  //     ),
  //     MaintenanceCardWidget(
  //       machineName: "Cinepólis",
  //       city: "Bauru",
  //       status: "Pendente".obs,
  //       workPriority: "NORMAL",
  //       priorityColor: AppColors.greenColor.value,
  //       clock1: "0",
  //       clock2: "0",
  //       pouchCollected: false,
  //       teddy: "0",
  //     ),
  //     MaintenanceCardWidget(
  //       machineName: "Supermercado Norte",
  //       city: "Botucatu",
  //       status: "Pendente".obs,
  //       workPriority: "ALTA",
  //       priorityColor: AppColors.redColor.value,
  //       clock1: "0",
  //       clock2: "0",
  //       pouchCollected: false,
  //       teddy: "0",
  //     ),
  //     MaintenanceCardWidget(
  //       machineName: "Parque de Diversão",
  //       city: "Lençóis Paulista",
  //       status: "Pendente".obs,
  //       workPriority: "NORMAL",
  //       priorityColor: AppColors.greenColor.value,
  //       clock1: "0",
  //       clock2: "0",
  //       pouchCollected: false,
  //       teddy: "0",
  //     ),
  //   ];

  //   allMaintenanceCardWidgetList.sort((a, b) => a.workPriority.compareTo(b.workPriority));
  //   allMaintenanceCardWidgetFilteredList.addAll(allMaintenanceCardWidgetList);

  //   cityItemCardWidgetList.value = <CityItemCardWidget>[
  //     CityItemCardWidget(
  //       title: "Jaú",
  //     ),
  //     CityItemCardWidget(
  //       title: "Bauru",
  //     ),
  //     CityItemCardWidget(
  //       title: "Campinas",
  //     ),
  //     CityItemCardWidget(
  //       title: "Botucatu",
  //     ),
  //     CityItemCardWidget(
  //       title: "Lençóis Paulista",
  //     ),
  //   ];
  // }

  // removeItemList(int index) async {
  //   await showDialog(
  //     context: Get.context!,
  //     builder: (BuildContext context) {
  //       return ConfirmationPopup(
  //         title: "Aviso",
  //         subTitle: "Tem certeza que deseja remover esse atendimento da lista?",
  //         firstButton: () {},
  //         secondButton: () {
  //           maintenanceCardWidgetList[index].showMap = false;
  //           allMaintenanceCardWidgetFilteredList.add(
  //             MaintenanceCardWidget(
  //               machineName: maintenanceCardWidgetList[index].machineName,
  //               city: maintenanceCardWidgetList[index].city,
  //               status: maintenanceCardWidgetList[index].status.value.obs,
  //               workPriority: maintenanceCardWidgetList[index].workPriority,
  //               priorityColor: maintenanceCardWidgetList[index].priorityColor,
  //               clock1: maintenanceCardWidgetList[index].clock1,
  //               clock2: maintenanceCardWidgetList[index].clock2,
  //               pouchCollected: maintenanceCardWidgetList[index].pouchCollected,
  //               teddy: maintenanceCardWidgetList[index].teddy,
  //             ),
  //           );
  //           allMaintenanceCardWidgetList.add(
  //             MaintenanceCardWidget(
  //               machineName: maintenanceCardWidgetList[index].machineName,
  //               city: maintenanceCardWidgetList[index].city,
  //               status: maintenanceCardWidgetList[index].status.value.obs,
  //               workPriority: maintenanceCardWidgetList[index].workPriority,
  //               priorityColor: maintenanceCardWidgetList[index].priorityColor,
  //               clock1: maintenanceCardWidgetList[index].clock1,
  //               clock2: maintenanceCardWidgetList[index].clock2,
  //               pouchCollected: maintenanceCardWidgetList[index].pouchCollected,
  //               teddy: maintenanceCardWidgetList[index].teddy,
  //             ),
  //           );
  //           allMaintenanceCardWidgetList.sort((a, b) => a.workPriority.compareTo(b.workPriority));
  //           allMaintenanceCardWidgetFilteredList.sort((a, b) => a.workPriority.compareTo(b.workPriority));
  //           maintenanceCardWidgetList[index].operatorDeletedMachine.value = true;
  //           maintenanceCardWidgetList[index].status.value = "Excluido";
  //           maintenanceCardWidgetList.sort(
  //             (a, b) => a.operatorDeletedMachine.toString().compareTo(
  //                   b.operatorDeletedMachine.toString(),
  //                 ),
  //           );
  //           refreshList();
  //         },
  //       );
  //     },
  //   );
  // }

  newItem() async {
    Get.to(() => AppNewMaintenancePage(
          title: "Selecione um atendimento para adicionar a sua lista",
          controller: this,
        ));
  }

  // callFilterMaintenanceList() async {
  //   await showDialog(
  //     context: Get.context!,
  //     builder: (BuildContext context) {
  //       return FilterMaintenanceListPopup(
  //         controller: this,
  //       );
  //     },
  //   );
  // }

  // filterMaintenanceList(int index) {
  //   try {
  //     cityItemCardWidgetList.forEach((element) => element.isSelected = false);
  //     cityItemCardWidgetList[index].isSelected = true;
  //     allMaintenanceCardWidgetFilteredList.clear();
  //     for (var item in allMaintenanceCardWidgetList) {
  //       if (item.city == cityItemCardWidgetList[index].title) {
  //         allMaintenanceCardWidgetFilteredList.add(item);
  //       }
  //     }
  //   } catch (_) {
  //     showDialog(
  //       context: Get.context!,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return InformationPopup(
  //           warningMessage: "Erro ao filtrar a lista",
  //         );
  //       },
  //     );
  //     allMaintenanceCardWidgetFilteredList.addAll(allMaintenanceCardWidgetList);
  //   } finally {
  //     Get.back();
  //   }
  // }

  // removeFilter() async {
  //   await showDialog(
  //     context: Get.context!,
  //     builder: (BuildContext context) {
  //       return ConfirmationPopup(
  //         title: "Aviso",
  //         subTitle: "Tem certeza que deseja remover o filtro?",
  //         firstButton: () {},
  //         secondButton: () async {
  //           allMaintenanceCardWidgetFilteredList.clear();
  //           cityItemCardWidgetList.forEach((element) => element.isSelected = false);
  //           allMaintenanceCardWidgetFilteredList.addAll(allMaintenanceCardWidgetList);
  //           await showDialog(
  //             context: Get.context!,
  //             barrierDismissible: false,
  //             builder: (BuildContext context) {
  //               return InformationPopup(
  //                 warningMessage: "Filtro removido com sucesso",
  //               );
  //             },
  //           );
  //           refreshList();
  //           Get.back();
  //           Get.back();
  //         },
  //       );
  //     },
  //   );
  // }
}
