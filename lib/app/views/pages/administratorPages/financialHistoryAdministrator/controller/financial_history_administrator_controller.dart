import 'package:get/get.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/safe_box_card_widget.dart';

class FinancialHistoryAdministratorController extends GetxController {
  late RxDouble safeBoxAmount;
  late RxBool loadingAnimation;
  late RxString userSelected;
  late RxList<String> usersName;
  late RxList<SafeBoxCardWidget> safeBoxCardWidgetList;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;

  FinancialHistoryAdministratorController(){
    _initializeVariables();
    _initializeList();
  }

  _initializeVariables(){
    loadingAnimation = false.obs;
    userSelected = "".obs;
    safeBoxAmount = 0.0.obs;
    usersName = <String>[].obs;
    safeBoxCardWidgetList = <SafeBoxCardWidget>[].obs;
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget(
      loadingAnimation: loadingAnimation,
    );
  }

  _initializeList(){
    usersName.addAll([
      "Ana",
      "Paula",
      "Roberta",
      "Carol",
    ]);
  }

  getVisitsUser(String userName){
    safeBoxAmount.value = 0;
    safeBoxCardWidgetList.value = <SafeBoxCardWidget>[
      SafeBoxCardWidget(
        operatorName: userName,
        machineName: "Shopping Boulevard",
        amount: 5896,
        pouchHistory: false,
      ),
      SafeBoxCardWidget(
        operatorName: userName,
        machineName: "Supermercado Central",
        amount: 3589,
        pouchHistory: false,
      ),
      SafeBoxCardWidget(
        operatorName: userName,
        machineName: "Cinema Alameda",
        amount: 6204,
        pouchHistory: false,
      ),
    ];

    safeBoxCardWidgetList.forEach((element) {
      if(element.amount != null) {
        safeBoxAmount.value += element.amount!;
      }
    });
  }
}