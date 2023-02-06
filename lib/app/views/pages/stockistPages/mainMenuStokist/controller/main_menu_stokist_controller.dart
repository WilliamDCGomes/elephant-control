import 'package:elephant_control/base/models/user/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../../base/models/stokistPlush/stokist_plush.dart';
import '../../../../../../base/services/stokist_plush_service.dart';
import '../../../../../utils/get_profile_picture_controller.dart';
import '../../../../../utils/logged_user.dart';
import '../../../widgetsShared/popups/confirmation_popup.dart';

class MainMenuStokistController extends GetxController {
  late RxBool hasPicture;
  late RxBool loadingPicture;
  late RxBool screenLoading;
  late RxInt plushQuantity;
  late RxString profileImagePath;
  late RxString nameProfile;
  late RxString nameInitials;
  late RxString welcomePhrase;
  late Rx<DateTime> quantityLastUpdate;
  late SharedPreferences sharedPreferences;
  late RxBool _isLoadingQuantity;
  late StokistPlush? stokistPlush;
  late StokistPlushService _stokistPlushService;

  MainMenuStokistController() {
    _initializeVariables();
  }
  //Getters
  bool get isLoadingQuantity => _isLoadingQuantity.value;

  @override
  void onInit() async {
    sharedPreferences = await SharedPreferences.getInstance();
    _getNameUser();
    _getWelcomePhrase();
    await getQuantityData();
    await GetProfilePictureController.loadProfilePicture(
      loadingPicture,
      hasPicture,
      profileImagePath,
      sharedPreferences,
    );
    screenLoading.value = false;
    await _checkFingerPrintUser();
    super.onInit();
  }

  _initializeVariables() {
    hasPicture = false.obs;
    loadingPicture = true.obs;
    screenLoading = true.obs;
    plushQuantity = 0.obs;
    profileImagePath = "".obs;
    nameProfile = "".obs;
    nameInitials = "".obs;
    quantityLastUpdate = DateTime.now().obs;
    _isLoadingQuantity = false.obs;
    stokistPlush = null;
    _stokistPlushService = StokistPlushService();
  }

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
            firstButton: () async => await sharedPreferences.setBool("user_finger_print", false),
            secondButton: () async => await sharedPreferences.setBool("user_finger_print", true),
          );
        },
      );
    }
  }

  Future<void> getQuantityData() async {
    try {
      _isLoadingQuantity.value = true;
      stokistPlush = await _stokistPlushService.getPlushies();
      if(stokistPlush != null){
        plushQuantity.value = stokistPlush!.balanceStuffedAnimals;
        LoggedUser.balanceStuffedAnimals = plushQuantity.value;
        if(stokistPlush!.alteration != null) {
          quantityLastUpdate.value = stokistPlush!.alteration!;
        }
      }
    } catch (_) {
    } finally {
      _isLoadingQuantity.value = false;
    }
  }
}