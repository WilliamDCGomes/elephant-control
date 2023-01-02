import 'package:elephant_control/app/utils/date_format_to_brazil.dart';
import 'package:elephant_control/base/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../../base/models/user/model/user.dart';
import '../../../../../../base/services/interfaces/iuser_service.dart';
import '../../../../../utils/logged_user.dart';
import '../../../administratorPages/mainMenuAdministrator/page/main_menu_administrator_page.dart';
import '../../../financialPages/mainMenuFinancial/page/main_menu_financial_page.dart';
import '../../../operatorPages/mainMenuOperator/page/main_menu_operator_page.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/popups/information_popup.dart';
import '../../login/page/login_page_page.dart';

class InitialPageController extends GetxController {
  late SharedPreferences sharedPreferences;
  late final LocalAuthentication fingerPrintAuth;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late IUserService _userService;

  InitialPageController(){
    _initializeVariables();
  }

  @override
  void onInit() async {
    sharedPreferences = await SharedPreferences.getInstance();
    await _loadFirstScreen();
    super.onInit();
  }

  _initializeVariables(){
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
    fingerPrintAuth = LocalAuthentication();
    _userService = UserService();
  }

  _loadFirstScreen() async {
    await Future.delayed(Duration(seconds: 2));
    if(await sharedPreferences.getBool("keep-connected") ?? false){
      if(await fingerPrintAuth.canCheckBiometrics && (await sharedPreferences.getBool("always_request_finger_print") ?? false)){
        var authenticate = await fingerPrintAuth.authenticate(
          localizedReason: "Utilize a sua digital para fazer o login.",
        );

        if (authenticate) {
          await loadingWithSuccessOrErrorWidget.stopAnimation(duration: 2);
          await _doLoginServerKeepConnected();
          _goToNextPage();
        }
        else{
          Get.offAll(() => LoginPage());
        }
      }
      else{
        await _doLoginServerKeepConnected();
        _goToNextPage();
      }
    }
    else{
      Get.offAll(() => LoginPage());
    }
  }

  _goToNextPage(){
    if (LoggedUser.userType == UserType.operator) {
      Get.offAll(() => MainMenuOperatorPage());
    } else if (LoggedUser.userType == UserType.treasury) {
      Get.offAll(() => MainMenuFinancialPage());
    } else if (LoggedUser.userType == UserType.admin) {
      Get.offAll(() => MainMenuAdministratorPage());
    } else if (LoggedUser.userType == UserType.stockist) {}
  }

  Future<void> _doLoginServerKeepConnected() async {
    try{
      LoggedUser.nameAndLastName = await sharedPreferences.getString("user_name_and_last_name") ?? "";
      LoggedUser.name = await sharedPreferences.getString("user_name",) ?? "";
      LoggedUser.userType = await UserType.values[sharedPreferences.getInt("user_type") ?? 4];
      LoggedUser.id = await sharedPreferences.getString("user_id") ?? "";
      await _doLoginServer();
    }
    catch(_){

    }
  }

  Future<bool> _doLoginServer() async {
    try {
      String? username = await sharedPreferences.getString("user_logged");
      String? password = await sharedPreferences.getString("password");

      if (username == null || password == null) {
        await _resetLogin("Erro ao se autenticar com a digital.\nPor favor, utilize o login e a senha para continuar.");
        return false;
      }

      var userLogged = await _userService
      .authenticate(
        username: username,
        password: password,
      ).timeout(Duration(seconds: 30));

      if (userLogged?.success == false) {
        await _resetLogin("Usuário e/ou senha incorretos");
        return false;
      }

      await sharedPreferences.setString('Token', userLogged!.token!);
      await sharedPreferences.setString('ExpiracaoToken', DateFormatToBrazil.formatDateAmerican(userLogged.expirationDate));
      return true;
    } catch (e) {
      await _resetLogin("Erro ao se conectar com o servidor.");
      return false;
    }
  }

  _resetLogin(String message) async {
    await loadingWithSuccessOrErrorWidget.stopAnimation(fail: true);
    await showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return InformationPopup(
          warningMessage: message,
        );
      },
    );
    Get.offAll(LoginPage(
      cancelFingerPrint: true,
    ));
  }
}