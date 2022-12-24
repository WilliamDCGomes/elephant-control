import 'package:get/get.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/safe_box_card_widget.dart';

class FinancialHistoryController extends GetxController {
  final bool pouchHistory;
  late double? safeBoxAmount;
  late RxList<SafeBoxCardWidget> safeBoxCardWidgetList;
  late RxBool loadingAnimation;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;

  FinancialHistoryController(String title, this.safeBoxAmount, this.pouchHistory){
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
    if(pouchHistory){
      safeBoxCardWidgetList.value = <SafeBoxCardWidget>[
        SafeBoxCardWidget(
          operatorName: "José Victor",
          machineName: "Shopping Boulevard",
          pouchHistory: pouchHistory,
          deliveryDate: DateTime.now(),
        ),
        SafeBoxCardWidget(
          operatorName: "José Victor",
          machineName: "Supermercado Central",
          pouchHistory: pouchHistory,
          deliveryDate: DateTime.now().add(Duration(days: -3)),
        ),
        SafeBoxCardWidget(
          operatorName: "João Carlos",
          machineName: "Cinema Alameda",
          pouchHistory: pouchHistory,
          deliveryDate: DateTime.now().add(Duration(days: -5)),
        ),
      ];
    }
    else{
      safeBoxCardWidgetList.value = <SafeBoxCardWidget>[
        SafeBoxCardWidget(
          operatorName: "José Victor",
          machineName: "Shopping Boulevard",
          amount: 5896,
          pouchHistory: pouchHistory,
        ),
        SafeBoxCardWidget(
          operatorName: "José Victor",
          machineName: "Supermercado Central",
          amount: 3589,
          pouchHistory: pouchHistory,
        ),
        SafeBoxCardWidget(
          operatorName: "João Carlos",
          machineName: "Cinema Alameda",
          amount: 6204,
          pouchHistory: pouchHistory,
        ),
      ];
    }
  }
}