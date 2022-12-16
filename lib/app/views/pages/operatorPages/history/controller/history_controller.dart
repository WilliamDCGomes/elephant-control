import 'package:elephant_control/app/views/stylePages/app_colors.dart';
import 'package:get/get.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/maintenance_card_widget.dart';

class HistoryController extends GetxController {
  late RxList<MaintenanceCardWidget> maintenanceCardWidgetList;
  late RxBool loadingAnimation;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;

  HistoryController(){
    _initializeVariables();
    _inicializeList();
  }

  _initializeVariables(){
    loadingAnimation = false.obs;

    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget(
      loadingAnimation: loadingAnimation,
    );

    maintenanceCardWidgetList = <MaintenanceCardWidget>[].obs;
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
      ),
      MaintenanceCardWidget(
        machineName: "Supermercado Central",
        status: "Finalizado".obs,
        workPriority: "NORMAL",
        priorityColor: AppColors.greenColor.value,
        clock1: "266321",
        clock2: "156623",
        pouchCollected: true,
        teddy: "39",
      ),
      MaintenanceCardWidget(
        machineName: "Cinema Alameda",
        status: "Finalizado".obs,
        workPriority: "NORMAL",
        priorityColor: AppColors.greenColor.value,
        clock1: "5266321",
        clock2: "256623",
        pouchCollected: true,
        teddy: "55",
      ),
    ];
  }
}