import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../operatorPages/mainMenu/page/main_menu_page.dart';
import '../../../widgetsShared/loading_widget.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/popups/information_popup.dart';

class LoginPageController extends GetxController {
  late bool _cancelFingerPrint;
  late RxBool raInputHasError;
  late RxBool passwordInputHasError;
  late RxBool passwordFieldEnabled;
  late RxBool loadingAnimation;
  late RxBool loadingAnimationSuccess;
  late RxBool keepConected;
  late LoadingWidget loadingWidget;
  late TextEditingController raInputController;
  late TextEditingController passwordInputController;
  late FocusNode passwordInputFocusNode;
  late FocusNode loginButtonFocusNode;
  late SharedPreferences sharedPreferences;
  late final LocalAuthentication fingerPrintAuth;
  late final GlobalKey<FormState> formKey;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;

  LoginPageController(this._cancelFingerPrint){
    _initializeVariables();
  }

  @override
  void onInit() async {
    sharedPreferences = await SharedPreferences.getInstance();
    await _getKeepConnected();
    if(!_cancelFingerPrint){
      await _checkBiometricSensor();
    }
    super.onInit();
  }

  _getKeepConnected() async {
    keepConected.value = await sharedPreferences.getBool("keep-connected") ?? false;
  }

  _initializeVariables(){
    raInputHasError = false.obs;
    passwordInputHasError = false.obs;
    passwordFieldEnabled = true.obs;
    loadingAnimation = false.obs;
    loadingAnimationSuccess = false.obs;
    keepConected = false.obs;
    formKey = GlobalKey<FormState>();
    loadingWidget= LoadingWidget(loadingAnimation: loadingAnimation);
    raInputController = TextEditingController();
    passwordInputController = TextEditingController();
    passwordInputFocusNode = FocusNode();
    loginButtonFocusNode = FocusNode();
    fingerPrintAuth = LocalAuthentication();
    if (kDebugMode){
      raInputController.text = "";
      passwordInputController.text = "";
    }
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget(
      loadingAnimation: loadingAnimationSuccess,
    );
  }

  _checkBiometricSensor() async {
    try {
      bool? useFingerPrint = await sharedPreferences.getBool("user_finger_print");
      if(await fingerPrintAuth.canCheckBiometrics && (useFingerPrint ?? false)){
        var authenticate = await fingerPrintAuth.authenticate(
          localizedReason: "Utilize a sua digital para fazer o login.",
        );

        if (authenticate) {
          loadingAnimationSuccess.value = true;
          await loadingWithSuccessOrErrorWidget.stopAnimation(duration: 2);
          Get.offAll(() => MainMenuPage());
        }
      }
    }
    catch(e){

    }
  }

  loginPressed() async {
    try{
      if(formKey.currentState!.validate()){
        loadingAnimation.value = true;
        await loadingWidget.startAnimation();
        loginButtonFocusNode.requestFocus();

        await loadingWidget.stopAnimation(justLoading: true);

        if(true){
          Get.offAll(() => MainMenuPage());
        }
        else{
          await showDialog(
            context: Get.context!,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return InformationPopup(
                warningMessage: "Usuário ou a Senha estão incorreto.",
              );
            },
          );
        }
      }
    }
    catch(_){
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Erro ao fazer Login!\nTente novamente mais tarde.",
          );
        },
      );
    }
  }
}

