import 'package:elephant_control/base/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../utils/get_profile_picture_controller.dart';
import '../../../../../utils/logged_user.dart';
import '../../../widgetsShared/popups/confirmation_popup.dart';

class MainMenuFinancialController extends GetxController {
  late RxBool hasPicture;
  late RxBool loadingPicture;
  late RxString profileImagePath;
  late RxString nameProfile;
  late RxString nameInitials;
  late RxString welcomePhrase;
  late RxDouble safeBoxAmount;
  late DateTime pouchLastChange;
  late DateTime teddyLastChange;
  late SharedPreferences sharedPreferences;

  MainMenuFinancialController(){
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
    super.onInit();
  }

  _initializeVariables(){
    hasPicture = false.obs;
    loadingPicture = true.obs;
    profileImagePath = "".obs;
    nameProfile = "".obs;
    nameInitials = "".obs;
    safeBoxAmount = 15689.00.obs;
    pouchLastChange = DateTime.now();
    teddyLastChange = DateTime.now();
  }

  _getNameUser(){
    switch(LoggedUser.userType){
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

    if(names.isNotEmpty && names.first != ""){
      nameProfile.value = names[0];
      LoggedUser.nameAndLastName = names[0];
      nameInitials.value = nameProfile.value[0];
      if(names.length > 1 && names.last != ""){
        nameInitials.value += names.last[0];
        LoggedUser.nameAndLastName += " ${names.last}";
      }
      LoggedUser.nameInitials = nameInitials.value;
    }
  }

  _getWelcomePhrase() {
    int currentHour = DateTime.now().hour;
    if(currentHour >= 0 && currentHour < 12)
      welcomePhrase = "Bom dia!".obs;
    else if(currentHour >= 12 && currentHour < 18)
      welcomePhrase = "Boa tarde!".obs;
    else
      welcomePhrase = "Boa noite!".obs;
  }

  _checkFingerPrintUser() async {
    bool? useFingerPrint = await sharedPreferences.getBool("user_finger_print");
    if(useFingerPrint == null && await LocalAuthentication().canCheckBiometrics){
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
}