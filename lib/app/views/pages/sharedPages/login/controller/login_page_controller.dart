import 'package:elephant_control/app/utils/logged_user.dart';
import 'package:elephant_control/base/models/user.dart';
import 'package:elephant_control/base/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../../base/viewControllers/authenticate_response.dart';
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
  late TextEditingController userInputController;
  late TextEditingController passwordInputController;
  late FocusNode passwordInputFocusNode;
  late FocusNode loginButtonFocusNode;
  late SharedPreferences sharedPreferences;
  late final LocalAuthentication fingerPrintAuth;
  late final GlobalKey<FormState> formKey;
  late AuthenticateResponse? userLogged;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;

  LoginPageController(this._cancelFingerPrint) {
    _initializeVariables();
  }

  @override
  void onInit() async {
    sharedPreferences = await SharedPreferences.getInstance();
    await _getKeepConnected();
    if (!_cancelFingerPrint) {
      await _checkBiometricSensor();
    }
    super.onInit();
  }

  _getKeepConnected() async {
    keepConected.value = await sharedPreferences.getBool("keep-connected") ?? false;
  }

  _initializeVariables() {
    raInputHasError = false.obs;
    passwordInputHasError = false.obs;
    passwordFieldEnabled = true.obs;
    loadingAnimation = false.obs;
    loadingAnimationSuccess = false.obs;
    keepConected = false.obs;
    userLogged = null;
    formKey = GlobalKey<FormState>();
    loadingWidget = LoadingWidget(loadingAnimation: loadingAnimation);
    userInputController = TextEditingController();
    passwordInputController = TextEditingController();
    passwordInputFocusNode = FocusNode();
    loginButtonFocusNode = FocusNode();
    fingerPrintAuth = LocalAuthentication();
    if (kDebugMode) {
      userInputController.text = "william";
      passwordInputController.text = "12345678";
    }
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget(
      loadingAnimation: loadingAnimationSuccess,
    );
  }

  _checkBiometricSensor() async {
    try {
      bool? useFingerPrint = await sharedPreferences.getBool("user_finger_print");
      if (await fingerPrintAuth.canCheckBiometrics && (useFingerPrint ?? false)) {
        var authenticate = await fingerPrintAuth.authenticate(
          localizedReason: "Utilize a sua digital para fazer o login.",
        );

        if (authenticate) {
          loadingAnimation.value = true;
          await loadingWidget.startAnimation();

          String? username = await sharedPreferences.getString("Login");
          String? password = await sharedPreferences.getString("Senha");

          if(username == null || password == null)
            throw Exception();

          userLogged = await UserService().authenticate(
            username: username,
            password: password,
          );

          if(userLogged != null){
            LoggedUser.userType = userLogged!.userType;
            await _saveOptions();

            await loadingWidget.stopAnimation();
            Get.offAll(() => MainMenuPage());
          }
        }
      }
    } catch (e) {
      await loadingWidget.stopAnimation();
      loadingAnimationSuccess.value = true;
      await loadingWithSuccessOrErrorWidget.stopAnimation(fail: true);
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

  _saveOptions() async {
    String? oldUser = await sharedPreferences.getString("user_logged");
    if(oldUser == null){
      await sharedPreferences.setString("user_logged", userInputController.text);
    }
    else if(oldUser != userInputController.text){
      await sharedPreferences.clear();
      await sharedPreferences.setString("user_logged", userInputController.text);
    }

    await sharedPreferences.setBool("keep-connected", keepConected.value);

    if(userLogged != null){
      LoggedUser.nameAndLastName = userLogged!.name;
      LoggedUser.name = userLogged!.name;
      LoggedUser.name = userLogged!.name.split(' ').first;
      LoggedUser.userType = userLogged!.userType;
      LoggedUser.id = userLogged!.id;
      LoggedUser.password = passwordInputController.text;
    }
  }

  loginPressed() async {
    try {
      if (formKey.currentState!.validate()) {
        loadingAnimation.value = true;
        await loadingWidget.startAnimation();
        userLogged = await UserService().authenticate(username: userInputController.text, password: passwordInputController.text);
        loginButtonFocusNode.requestFocus();

        if (userLogged != null) {
          sharedPreferences.setString("Token", userLogged!.token);
          sharedPreferences.setString("ExpiracaoToken", userLogged!.expirationDate.toIso8601String());
          sharedPreferences.setString("Login", userInputController.text);
          sharedPreferences.setString("Senha", passwordInputController.text);

          LoggedUser.userType = userLogged!.userType;

          await _saveOptions();

          if (keepConected.value) {
            await sharedPreferences.setBool("keep-connected", true);
          } else {
            await sharedPreferences.setBool("keep-connected", false);
          }

          await loadingWidget.stopAnimation();

          if (userLogged!.userType == UserType.operator) {
            Get.offAll(() => MainMenuPage());
          }
          else if (userLogged!.userType == UserType.admin) {
            Get.offAll(() => MainMenuPage());
          }
          else {
            Get.offAll(() => MainMenuPage());
          }
        }
        else {
          await loadingWidget.stopAnimation();
          loadingAnimationSuccess.value = true;
          await loadingWithSuccessOrErrorWidget.stopAnimation(fail: true);
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
    } catch (_) {
      await loadingWidget.stopAnimation();
      loadingAnimationSuccess.value = true;
      await loadingWithSuccessOrErrorWidget.stopAnimation(fail: true);
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
