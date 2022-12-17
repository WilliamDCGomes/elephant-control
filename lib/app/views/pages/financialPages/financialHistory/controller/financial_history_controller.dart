import 'package:get/get.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/safe_box_card_widget.dart';

class FinancialHistoryController extends GetxController {
  late double safeBoxAmount;
  late RxList<SafeBoxCardWidget> safeBoxCardWidgetList;
  late RxBool loadingAnimation;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;

  FinancialHistoryController(String title, this.safeBoxAmount){
    _initializeVariables();
    _inicializeList();
  }

  _initializeVariables(){
    loadingAnimation = false.obs;

    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget(
      loadingAnimation: loadingAnimation,
    );

    safeBoxCardWidgetList = <SafeBoxCardWidget>[].obs;
  }

  _inicializeList(){
    safeBoxCardWidgetList.value = <SafeBoxCardWidget>[
      SafeBoxCardWidget(
        operatorName: "José Victor",
        machineName: "Shopping Boulevard",
        amount: 5896,
      ),
      SafeBoxCardWidget(
        operatorName: "José Victor",
        machineName: "Supermercado Central",
        amount: 3589,
      ),
      SafeBoxCardWidget(
        operatorName: "João Carlos",
        machineName: "Cinema Alameda",
        amount: 6204,
      ),
    ];
  }
}