import 'package:elephant_control/base/models/user/model/user.dart';
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
  late RxBool loadingAnimation;
  late RxString userSelected;
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
    loadingAnimation.value = true;
    await loadingWithSuccessOrErrorWidget.startAnimation();
    await _getUsers();
    super.onInit();
  }

  _initializeVariables(){
    loadingAnimation = false.obs;
    userSelected = "".obs;
    fullValue = 0.0.obs;
    users = <User>[].obs;
    usersName = <String>[].obs;
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget(
      loadingAnimation: loadingAnimation,
    );
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
              late List<String> nomeUsuarioMeta;
              nomeUsuarioMeta = users[i].name.trim().split(' ');
              if (nomeUsuarioMeta.length > 1) {
                users[i + 1].name += " - ${int.parse(nomeUsuarioMeta.last) + 1}";
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
    }
  }

  getPouchUser(String user) async {
    try{
      loadingAnimation.value = true;
      await loadingWithSuccessOrErrorWidget.startAnimation();
      if(user == "Todos"){
        if(withOperator){
          moneyPouchGetViewController = await _moneyPouchService.getAllPouchInformation(UserType.operator);
        }
        else{
          moneyPouchGetViewController = await _moneyPouchService.getAllPouchInformation(UserType.treasury);
        }
      }
      else{
        var selected = users.firstWhere((element) => element.name == user);

        moneyPouchGetViewController = await _moneyPouchService.getPouchInformation(selected.id ??  "");
      }

      if(moneyPouchGetViewController != null){
        fullValue.value = moneyPouchGetViewController!.fullValue;
      }

      update(["list-pouch"]);
      await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
    }
    catch(_){
      await loadingWithSuccessOrErrorWidget.stopAnimation(fail: true);
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