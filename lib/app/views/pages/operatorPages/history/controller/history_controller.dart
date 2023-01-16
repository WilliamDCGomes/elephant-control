import 'package:get/get.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/maintenance_card_widget.dart';

class HistoryController extends GetxController {
  late RxList<MaintenanceCardWidget> maintenanceCardWidgetList;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;

  HistoryController(String title) {
    _initializeVariables();
  }

  _initializeVariables() {
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();

    maintenanceCardWidgetList = <MaintenanceCardWidget>[].obs;
  }
}
