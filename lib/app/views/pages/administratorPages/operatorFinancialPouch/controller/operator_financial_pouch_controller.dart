import 'package:elephant_control/base/models/user/user.dart';
import 'package:elephant_control/base/services/money_pouch_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../base/services/interfaces/imoney_pouch_service.dart';
import '../../../../../../base/services/interfaces/iuser_service.dart';
import '../../../../../../base/services/user_service.dart';
import '../../../../../../base/viewControllers/money_pouch_get_viewcontroller.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/popups/information_popup.dart';

class OperatorPouchController extends GetxController {
  final bool withOperator;
  late RxString userSelected;
  late RxInt pouchQuantity;
  late RxDouble fullValue;
  late RxList<User> users;
  late RxList<String> usersName;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late MoneyPouchGetViewController? moneyPouchGetViewController;
  late IUserService _userService;
  late IMoneyPouchService _moneyPouchService;

  OperatorPouchController(this.withOperator){
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
    pouchQuantity= 0.obs;
    fullValue = 0.0.obs;
    users = <User>[].obs;
    usersName = <String>[].obs;
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
    _userService = UserService();
    _moneyPouchService = MoneyPouchService();
    moneyPouchGetViewController = null;
  }

  _getUsers() async {
    try{
      if(withOperator){
        users.value = await _userService.getAllUserByType(UserType.operator);
      }
      else{
        users.value = await _userService.getAllUserByType(UserType.treasury);
      }

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
      await getPouchUser(loadingEnabled: false);

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

  getPouchUser({bool loadingEnabled = true}) async {
    try{
      fullValue.value = 0;
      pouchQuantity.value = 0;
      if(loadingEnabled){
        await loadingWithSuccessOrErrorWidget.startAnimation();
      }
      if(userSelected.value == "Todos"){
        if(withOperator){
          moneyPouchGetViewController = await _moneyPouchService.getAllPouchInformation(UserType.operator);
        }
        else{
          moneyPouchGetViewController = await _moneyPouchService.getAllPouchInformation(UserType.treasury);
        }
      }
      else{
        var selected = users.firstWhere((element) => element.name == userSelected.value);

        moneyPouchGetViewController = await _moneyPouchService.getPouchInformation(selected.id ??  "");
      }

      if(moneyPouchGetViewController != null){
        fullValue.value = moneyPouchGetViewController!.fullValue;
        pouchQuantity.value = moneyPouchGetViewController!.moneyPouchValueList.length;
      }

      update(["list-pouch"]);
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
            warningMessage: "Erro ao atualizar a lista! Verifique sua conexão ou tente novamente mais tarde.",
          );
        },
      );
    }
  }
}