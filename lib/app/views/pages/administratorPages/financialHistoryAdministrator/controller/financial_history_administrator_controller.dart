import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../base/models/user/model/user.dart';
import '../../../../../../base/services/interfaces/iuser_service.dart';
import '../../../../../../base/services/interfaces/ivisit_service.dart';
import '../../../../../../base/services/user_service.dart';
import '../../../../../../base/services/visit_service.dart';
import '../../../../../../base/viewControllers/safe_box_financial_viewcontroller.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/popups/information_popup.dart';

class FinancialHistoryAdministratorController extends GetxController {
  late RxDouble safeBoxAmount;
  late RxString userSelected;
  late RxList<String> usersName;
  late RxList<User> users;
  late RxList<SafeBoxFinancialViewController> safeBoxHistoryList;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late IUserService _userService;
  late IVisitService _visitService;

  FinancialHistoryAdministratorController(){
    _initializeVariables();
  }

  @override
  void onInit() async {
    await Future.delayed(Duration(milliseconds: 200));
    await loadingWithSuccessOrErrorWidget.startAnimation();
    await _getUsers();
    super.onInit();
  }

  _initializeVariables(){
    userSelected = "".obs;
    safeBoxAmount = 0.0.obs;
    usersName = <String>[].obs;
    users = <User>[].obs;
    safeBoxHistoryList = <SafeBoxFinancialViewController>[].obs;
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
    _userService = UserService();
    _visitService = VisitService();
  }

  _getUsers() async {
    try{
      users.value = await _userService.getAllUserByType(UserType.treasury);

      users.sort((a, b) => a.name.compareTo(b.name));
      for (var i = 0; i < users.length; i++) {
        if (i + 1 < users.length) {
          try {
            if (users[i].name.startsWith(users[i + 1].name)) {
              late List<String> userName;
              userName = users[i].name.trim().split(' ');
              if (userName.length > 1) {
                users[i + 1].name += " - ${int.parse(userName.last) + 1}";
              } else {
                users[i].name += " - 1";
                users[i + 1].name += " - 2";
              }
            }
          } catch (_) {}
        }
      }

      usersName.add("Todos");
      users.forEach((element) => usersName.add(element.name));

      userSelected.value = usersName.first;
      await getVisitsUser(loadingEnabled: false);

      await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
    }
    catch(_){
      await loadingWithSuccessOrErrorWidget.stopAnimation(fail: true);
      await showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Erro buscar os usuários! Tente novamente mais tarde.",
          );
        },
      );
      Get.back();
    }
  }

  getVisitsUser({bool loadingEnabled = true}) async {
    try{
      if(loadingEnabled){
        await loadingWithSuccessOrErrorWidget.startAnimation();
      }

      safeBoxAmount.value = 0;
      User? user = null;
      if(userSelected.value != "Todos"){
        user = users.firstWhere((element) => element.name == userSelected.value);
      }
      safeBoxHistoryList.value = await _visitService.getVisitsOfFinancialByUserId(
        user != null ? user.id ?? null : null,
      );
      safeBoxHistoryList.forEach((element) {
        safeBoxAmount.value += element.moneyWithDrawalQuantity ?? 0;
      });
      update(["safebox-list"]);

      if(loadingEnabled){
        await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
      }
    }
    catch(_){
      if(loadingEnabled){
        await loadingWithSuccessOrErrorWidget.stopAnimation(fail: true);
      }
      await showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Erro buscar o histórico do cofre! Tente novamente mais tarde.",
          );
        },
      );
    }
  }
}