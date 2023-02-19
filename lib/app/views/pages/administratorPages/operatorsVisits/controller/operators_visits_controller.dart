import 'package:elephant_control/base/services/user_service.dart';
import 'package:elephant_control/base/services/visit_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../base/models/user/user.dart';
import '../../../../../../base/services/interfaces/iuser_service.dart';
import '../../../../../../base/services/interfaces/ivisit_service.dart';
import '../../../../../../base/viewControllers/visits_of_operators_viewcontroller.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/popups/information_popup.dart';

class OperatorsVisitsController extends GetxController {
  late DateTime dateFilter;
  late RxInt visitsQuantity;
  late RxBool screenLoading;
  late RxString userSelected;
  late RxList<String> usersName;
  late RxList<User> users;
  late RxList<VisitOfOperatorsViewController> operatorVisitList;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late IUserService _userService;
  late IVisitService _visitService;
  late RxBool showInfos;

  OperatorsVisitsController() {
    _initializeVariables();
  }

  @override
  void onInit() async {
    await _getUsers();
    super.onInit();
  }

  _initializeVariables() {
    dateFilter = DateTime.now();
    screenLoading = true.obs;
    visitsQuantity = 0.obs;
    userSelected = "".obs;
    usersName = <String>[].obs;
    users = <User>[].obs;
    operatorVisitList = <VisitOfOperatorsViewController>[].obs;
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
    _userService = UserService();
    _visitService = VisitService();
    showInfos = true.obs;
  }

  _getUsers() async {
    try {
      users.value = await _userService.getAllUserByType(UserType.operator);

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

      screenLoading.value = false;
    } catch (_) {
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
    try {
      visitsQuantity.value = 0;
      if (loadingEnabled) {
        await loadingWithSuccessOrErrorWidget.startAnimation();
      }

      User? user = null;
      if (userSelected.value != "Todos") {
        user = users.firstWhere((element) => element.name == userSelected.value);
      }

      operatorVisitList.value = (await _visitService.getVisitsOfOperatorsByUserId(
        user != null ? user.id ?? null : null,
        dateFilter,
      ))
        ..sort((a, b) => (a.machineName).compareTo(b.machineName))
        ..sort((a, b) {
          if (a.hasIncident || b.hasIncident) {
            if (a.hasIncident && b.hasIncident) {
              return 0;
            } else if (a.hasIncident) {
              return -1;
            } else {
              return 1;
            }
          } else {
            return 0;
          }
        })
        ..sort((a, b) => (a.status?.index ?? 10).compareTo(b.status?.index ?? 10));
      visitsQuantity.value = operatorVisitList.length;
      update(["visit-list"]);
      if (loadingEnabled) {
        await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
      }
    } catch (_) {
      if (loadingEnabled) {
        await loadingWithSuccessOrErrorWidget.stopAnimation(fail: true);
      }
      await showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Erro buscar as visitas do operador! Tente novamente mais tarde.",
          );
        },
      );
    }
  }

  filterPerDate() async {
    DateTime auxDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      helpText: "SELECIONE UMA DATA",
      confirmText: "Selecionar",
      cancelText: "Cancelar",
      initialDate: dateFilter,
      firstDate: DateTime(auxDate.year - 2, auxDate.month, auxDate.day),
      lastDate: auxDate,
    );

    if (picked != null && picked != dateFilter) {
      dateFilter = picked;
      update(["date-filter"]);
    }
  }
}
