import 'package:elephant_control/app/views/stylePages/app_colors.dart';
import 'package:get/get.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/maintenance_card_widget.dart';

class MaintenanceHistoryController extends GetxController {
  late RxList<MaintenanceCardWidget> maintenanceCardWidgetList;
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
        workPriority: "MÉDIA",
        priorityColor: AppColors.yellowDarkColor.value,
        clock1: "0",
        clock2: "0",
        pouchCollected: false,
        teddy: "0",
      ),
      MaintenanceCardWidget(
        machineName: "Cinema Alameda",
        status: "Pendente",
        workPriority: "BAIXA",
        priorityColor: AppColors.greenColor.value,
        clock1: "0",
        clock2: "0",
        pouchCollected: false,
        teddy: "0",
      ),
    ];
  }
}