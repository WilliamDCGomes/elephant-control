import 'dart:async';

import 'package:elephant_control/app/utils/internet_connection.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/popups/information_popup.dart';
import 'package:elephant_control/base/context/elephant_context.dart';
import 'package:elephant_control/base/models/user/user.dart';
import 'package:elephant_control/base/models/visit/visit.dart';
import 'package:elephant_control/base/services/machine_service.dart';
import 'package:elephant_control/base/services/reminder_machine_service.dart';
import 'package:elephant_control/base/services/user_machine_service.dart';
import 'package:elephant_control/base/services/user_service.dart';
import 'package:elephant_control/base/services/user_visit_machine_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../../base/services/base/iservice_post.dart';
import '../../../../../../base/services/incident_media_service.dart';
import '../../../../../../base/services/incident_service.dart';
import '../../../../../../base/services/visit_media_service.dart';
import '../../../../../../base/services/visit_service.dart';
import '../../../../../utils/get_profile_picture_controller.dart';
import '../../../../../utils/logged_user.dart';
import '../../../widgetsShared/popups/confirmation_popup.dart';
import '../../maintenance/page/maintenance_page.dart';
import '../../maintenanceHistory/pages/maintenance_history_page.dart';

class MainMenuOperatorController extends GetxController {
  late RxBool screenLoading;
  late RxBool hasPicture;
  late RxBool loadingPicture;
  late RxString profileImagePath;
  late RxString nameProfile;
  late RxString nameInitials;
  late RxString welcomePhrase;
  late RxInt amountPouch;
  late RxInt amountTeddy;
  late Rx<DateTime> pouchLastChange;
  late Rx<DateTime> teddyLastChange;
  late SharedPreferences sharedPreferences;
  late List<Visit> visitsUser;
  late List<Visit> visitsWithMoneydrawal;
  late Completer<bool> _offlineCompleter;

  MainMenuOperatorController() {
    _initializeVariables();
    _getNameUser();
    _getWelcomePhrase();
  }

  @override
  void onInit() async {
    sharedPreferences = await SharedPreferences.getInstance();
    _sincronizeData();
    _sincronizePostData();
    await GetProfilePictureController.loadProfilePicture(
      loadingPicture,
      hasPicture,
      profileImagePath,
      sharedPreferences,
    );
    await _checkFingerPrintUser();
    await getOperatorInformation();
    screenLoading.value = false;
    // if(kDebugMode) {
    //   await PositionUtil.determinePosition();
    // }
    super.onInit();
  }

  _initializeVariables() {
    screenLoading = true.obs;
    hasPicture = false.obs;
    visitsUser = [];
    visitsWithMoneydrawal = [];
    loadingPicture = true.obs;
    profileImagePath = "".obs;
    nameProfile = "".obs;
    nameInitials = "".obs;
    amountPouch = (LoggedUser.balanceMoney ?? 0).obs;
    amountTeddy = (LoggedUser.balanceStuffedAnimals ?? 0).obs;
    pouchLastChange = (LoggedUser.pouchLastUpdate ?? DateTime.now()).obs;
    teddyLastChange = (LoggedUser.stuffedAnimalsLastUpdate ?? DateTime.now()).obs;
    _offlineCompleter = Completer<bool>();
  }

  bool get sincronismCompleted => _offlineCompleter.isCompleted;

  _getNameUser() {
    switch (LoggedUser.userType) {
      case UserType.admin:
        LoggedUser.userTypeName = "ADMINISTRATIVO";
        break;
      case UserType.treasury:
        LoggedUser.userTypeName = "TESOURARIA";
        break;
      case UserType.stockist:
        LoggedUser.userTypeName = "ESTOQUISTA";
        break;
      case UserType.operator:
      default:
        LoggedUser.userTypeName = "OPERADOR";
        break;
    }
    var names = LoggedUser.name.trim().split(" ");

    if (names.isNotEmpty && names.first != "") {
      nameProfile.value = names[0];
      LoggedUser.nameAndLastName = names[0];
      nameInitials.value = nameProfile.value[0];
      if (names.length > 1 && names.last != "") {
        nameInitials.value += names.last[0];
        LoggedUser.nameAndLastName += " ${names.last}";
      }
      LoggedUser.nameInitials = nameInitials.value;
    }
  }

  _getWelcomePhrase() {
    int currentHour = DateTime.now().hour;
    if (currentHour >= 0 && currentHour < 12)
      welcomePhrase = "Bom dia!".obs;
    else if (currentHour >= 12 && currentHour < 18)
      welcomePhrase = "Boa tarde!".obs;
    else
      welcomePhrase = "Boa noite!".obs;
  }

  _checkFingerPrintUser() async {
    bool? useFingerPrint = await sharedPreferences.getBool("user_finger_print");
    if (useFingerPrint == null && await LocalAuthentication().canCheckBiometrics) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ConfirmationPopup(
            title: "Aviso",
            subTitle: "Deseja habilitar o login por digital?",
            firstButton: () => sharedPreferences.setBool("user_finger_print", false),
            secondButton: () => sharedPreferences.setBool("user_finger_print", true),
          );
        },
      );
    }
  }

  _sincronizeData() async {
    if (!(sharedPreferences.getBool("SincronismExecuted") ?? false)) {
      _offlineCompleter.complete(true);
    }
    if (!await InternetConnection.checkConnection()) {
      if (!_offlineCompleter.isCompleted) _offlineCompleter.complete(false);
      return;
    }
    List<MixinService> services = [
      MachineService(),
      UserMachineService(),
      UserVisitMachineService(),
      ReminderMachineService(),
      // IncidentMediaService(),
      // IncidentService(),
      // VisitMediaService(),
      // VisitService(),
    ];
    bool error = false;
    for (var element in services) {
      try {
        final response = await element.getOffline();
        print(response.length);
      } catch (_) {
        error = true;
      }
    }
    if (!error) {
      sharedPreferences.setBool("SincronismExecuted", true);
      if (!_offlineCompleter.isCompleted) _offlineCompleter.complete(true);
    } else {
      if (!_offlineCompleter.isCompleted) _offlineCompleter.complete(false);
    }
  }

  _sincronizePostData() async {
    if (!(sharedPreferences.getBool("SincronismExecuted") ?? false)) {
      return;
    }
    if (!await InternetConnection.checkConnection()) {
      return;
    }
    List<MixinService> services = [
      // MachineService(),
      // UserMachineService(),
      UserVisitMachineService(),
      // ReminderMachineService(),
      VisitService(),
      VisitMediaService(),
      IncidentService(),
      IncidentMediaService(),
    ];
    bool error = false;
    for (var element in services) {
      try {
        final response = await element.postOffline();
        print(response.length);
      } catch (_) {
        print(_);
        error = true;
      }
    }
    if (error) {
      print(error);
    }
  }

  Future<void> getOperatorInformation() async {
    try {
      final operatorInformations = await UserService().getOperatorInformation();
      if (operatorInformations == null) throw Exception();
      amountPouch.value = operatorInformations.balanceMoney;
      amountTeddy.value = operatorInformations.balanceStuffedAnimals;
      pouchLastChange.value = operatorInformations.pouchLastUpdate ?? DateTime.now();
      teddyLastChange.value = operatorInformations.stuffedAnimalsLastUpdate ?? DateTime.now();
      visitsUser = operatorInformations.visitsUser;
      visitsWithMoneydrawal = operatorInformations.visitsWithMoneydrawal;
      LoggedUser.pouchLastUpdate = operatorInformations.pouchLastUpdate ?? DateTime.now();
      LoggedUser.stuffedAnimalsLastUpdate = operatorInformations.stuffedAnimalsLastUpdate ?? DateTime.now();
    } catch (_) {}
  }

  void openMaintenancePage(BuildContext context, ScreenOperator screenOperator) async {
    if (await InternetConnection.checkConnection()) {
      return screenOperator == ScreenOperator.maintenanceHistory
          ? Get.to(() => MaintenanceHistoryPage(offline: false))
          : Get.to(() => MaintenancePage(offline: false));
    } else {
      if (sharedPreferences.getBool("SincronismExecuted") ?? false) {
        return screenOperator == ScreenOperator.maintenanceHistory
            ? Get.to(() => MaintenanceHistoryPage(offline: true))
            : Get.to(() => MaintenancePage(offline: true));
      } else {
        try {
          if (!_offlineCompleter.isCompleted) screenLoading.value = true;
          if (await _offlineCompleter.future) {
            return screenOperator == ScreenOperator.maintenanceHistory
                ? Get.to(() => MaintenanceHistoryPage(offline: true))
                : Get.to(() => MaintenancePage(offline: true));
          } else {
            return showDialog(
                context: context,
                builder: (context) => InformationPopup(
                      warningMessage: screenOperator == ScreenOperator.maintenanceHistory
                          ? "Não foi possível acessar o histórico de visitas. Tente novamente mais tarde."
                          : "Não foi possível acessar a página de visitas. Tente novamente mais tarde.",
                    ));
          }
        } catch (_) {
        } finally {
          screenLoading.value = false;
        }
      }
    }
  }
}

enum ScreenOperator { maintenanceHistory, maintenanceCreate }
