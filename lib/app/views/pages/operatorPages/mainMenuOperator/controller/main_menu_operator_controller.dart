import 'package:elephant_control/app/views/pages/widgetsShared/loading_with_success_or_error_widget.dart';
import 'package:elephant_control/base/models/user/user.dart';
import 'package:elephant_control/base/models/visit/visit.dart';
import 'package:elephant_control/base/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../utils/get_profile_picture_controller.dart';
import '../../../../../utils/logged_user.dart';
import '../../../widgetsShared/popups/confirmation_popup.dart';

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
  late DateTime pouchLastChange;
  late DateTime teddyLastChange;
  late SharedPreferences sharedPreferences;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late List<Visit> visitsUser;
  late List<Visit> visitsWithMoneydrawal;

  MainMenuOperatorController() {
    _initializeVariables();
    _getNameUser();
    _getWelcomePhrase();
  }

  @override
  void onInit() async {
    sharedPreferences = await SharedPreferences.getInstance();
    await GetProfilePictureController.loadProfilePicture(
      loadingPicture,
      hasPicture,
      profileImagePath,
      sharedPreferences,
    );
    await _checkFingerPrintUser();
    await getOperatorInformation();
    screenLoading.value = false;
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
    pouchLastChange = LoggedUser.pouchLastUpdate ?? DateTime.now();
    teddyLastChange = LoggedUser.stuffedAnimalsLastUpdate ?? DateTime.now();
    loadingWithSuccessOrErrorWidget = loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
  }

  _getNameUser() {
    switch (LoggedUser.userType) {
      case UserType.admin:
        LoggedUser.userTypeName = "ADMINISTRATIVO";
        break;
      case UserType.operator:
        LoggedUser.userTypeName = "OPERADOR";
        break;
      case UserType.treasury:
        LoggedUser.userTypeName = "TESOURARIA";
        break;
      case UserType.stockist:
        LoggedUser.userTypeName = "ESTOQUISTA";
        break;
      case UserType.none:
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

  Future<void> getOperatorInformation() async {
    try {
      await loadingWithSuccessOrErrorWidget.startAnimation();
      final operatorInformations = await UserService().getOperatorInformation();
      if (operatorInformations == null) throw Exception();
      amountPouch.value = operatorInformations.balanceMoney;
      amountTeddy.value = operatorInformations.balanceStuffedAnimals;
      pouchLastChange = operatorInformations.pouchLastUpdate ?? DateTime.now();
      teddyLastChange = operatorInformations.stuffedAnimalsLastUpdate ?? DateTime.now();
      visitsUser = operatorInformations.visitsUser;
      visitsWithMoneydrawal = operatorInformations.visitsWithMoneydrawal;
    } catch (_) {
    } finally {
      await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
    }
  }
}
