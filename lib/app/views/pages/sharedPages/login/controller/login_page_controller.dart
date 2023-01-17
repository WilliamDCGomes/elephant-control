import 'package:elephant_control/app/utils/date_format_to_brazil.dart';
import 'package:elephant_control/app/utils/format_numbers.dart';
import 'package:elephant_control/app/utils/logged_user.dart';
import 'package:elephant_control/app/views/pages/administratorPages/mainMenuAdministrator/page/main_menu_administrator_page.dart';
import 'package:elephant_control/app/views/pages/financialPages/mainMenuFinancial/page/main_menu_financial_page.dart';
import 'package:elephant_control/app/views/pages/sharedPages/login/page/login_page_page.dart';
import 'package:elephant_control/base/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../../base/models/user/user.dart';
import '../../../../../../base/services/interfaces/iuser_service.dart';
import '../../../../../../base/viewControllers/authenticate_response.dart';
import '../../../operatorPages/mainMenuOperator/page/main_menu_operator_page.dart';
import '../../../stockistPages/mainMenuStokist/page/main_menu_stokist_page.dart';
import '../../../widgetsShared/loading_widget.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/popups/information_popup.dart';

class LoginPageController extends GetxController {
  late bool _cancelFingerPrint;
  late RxBool cpfInputHasError;
  late RxBool passwordInputHasError;
  late RxBool passwordFieldEnabled;
  late RxBool keepConected;
  late RxString appVersion;
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
  late IUserService _userService;
  late User? _user;

  LoginPageController(this._cancelFingerPrint) {
    _initializeVariables();
  }

  @override
  void onInit() async {
    sharedPreferences = await SharedPreferences.getInstance();
    appVersion.value = (await PackageInfo.fromPlatform()).version;
    userInputController.text = FormatNumbers.stringToCpf(await sharedPreferences.getString("user_logged") ?? "");
    if (kDebugMode) {
      passwordInputController.text = "Elephant@2022";
    }
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
    _user = null;
    cpfInputHasError = false.obs;
    passwordInputHasError = false.obs;
    passwordFieldEnabled = true.obs;
    keepConected = false.obs;
    appVersion = "".obs;
    userLogged = null;
    formKey = GlobalKey<FormState>();
    userInputController = TextEditingController();
    passwordInputController = TextEditingController();
    passwordInputFocusNode = FocusNode();
    loginButtonFocusNode = FocusNode();
    fingerPrintAuth = LocalAuthentication();
    loadingWidget = LoadingWidget();
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
    _userService = UserService();
  }

  _checkBiometricSensor() async {
    try {
      bool? useFingerPrint = await sharedPreferences.getBool("user_finger_print");
      if (await fingerPrintAuth.canCheckBiometrics && (useFingerPrint ?? false)) {
        var authenticate = await fingerPrintAuth.authenticate(
          localizedReason: "Utilize a sua digital para fazer o login.",
        );

        if (authenticate) {
          await loadingWidget.startAnimation();

          await _doLoginServer(true);
          await _getUserInformations();

          if (userLogged != null) {
            LoggedUser.userType = userLogged!.userType!;
            await _saveOptions();

            await loadingWidget.stopAnimation();
            _goToNextPage();
          }
        }
      }
    } catch (e) {
      await loadingWidget.stopAnimation();
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

  loginPressed() async {
    try {
      if (formKey.currentState!.validate()) {
        await loadingWidget.startAnimation();

        if (!await _doLoginServer(false) || !await _getUserInformations()) {
          throw Exception();
        }

        loginButtonFocusNode.requestFocus();

        if (userLogged != null) {
          LoggedUser.userType = userLogged!.userType!;

          await _saveOptions();
          await sharedPreferences.setString("password", passwordInputController.text);

          await sharedPreferences.setBool("keep-connected", keepConected.value);

          await loadingWidget.stopAnimation();
          _goToNextPage();
        } else {
          if (loadingWidget.animationController.isAnimating) await loadingWidget.stopAnimation();
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
      if (loadingWidget.animationController.isAnimating) await loadingWidget.stopAnimation();
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
    if (oldUser == null) {
      await sharedPreferences.setString("user_logged", userInputController.text.replaceAll('.', '').replaceAll('-', ''));
    } else if (oldUser != userInputController.text.replaceAll('.', '').replaceAll('-', '')) {
      // await sharedPreferences.clear();
      await sharedPreferences.remove("user_finger_print");
      await sharedPreferences.setString("user_logged", userInputController.text.replaceAll('.', '').replaceAll('-', ''));
    }

    await sharedPreferences.setBool("keep-connected", keepConected.value);

    if (_user != null) {
      await sharedPreferences.setString("name", _user!.name);
      await sharedPreferences.setString("birthdate", DateFormatToBrazil.formatDate(_user!.birthdayDate));
      await sharedPreferences.setString("balanceMoney", _user!.balanceMoney.toString());
      await sharedPreferences.setString("pouchLastUpdate", _user!.pouchLastUpdate.toString());
      await sharedPreferences.setString("balanceStuffedAnimals", _user!.balanceStuffedAnimals.toString());
      await sharedPreferences.setString("stuffedAnimalsLastUpdate", _user!.stuffedAnimalsLastUpdate.toString());
      switch (_user!.gender) {
        case TypeGender.masculine:
          await sharedPreferences.setString("gender", "Masculino");
          LoggedUser.gender = "Masculino";
          break;
        case TypeGender.feminine:
          await sharedPreferences.setString("gender", "Feminino");
          LoggedUser.gender = "Feminino";
          break;
        case TypeGender.other:
          await sharedPreferences.setString("gender", "Outro");
          LoggedUser.gender = "Outro";
          break;
        case TypeGender.none:
          await sharedPreferences.setString("gender", "Não Informado");
          LoggedUser.gender = "Não Informado";
          break;
      }
      await sharedPreferences.setString("cpf", _user!.document ?? "");
      await sharedPreferences.setString("cep", _user!.cep ?? "");
      await sharedPreferences.setString("city", _user!.city ?? "");
      await sharedPreferences.setString("street", _user!.address ?? "");
      await sharedPreferences.setString("houseNumber", _user!.number ?? "");
      await sharedPreferences.setString("neighborhood", _user!.district ?? "");
      await sharedPreferences.setString("complement", _user!.complement ?? "");
      await sharedPreferences.setString("phone", _user!.tellphone ?? "");
      await sharedPreferences.setString("cellPhone", _user!.cellphone ?? "");
      await sharedPreferences.setString("email", _user!.email ?? "");
      await sharedPreferences.setString("uf", _user!.uf ?? "");
      await sharedPreferences.setString("code", _user!.code.toString());
      LoggedUser.birthdate = DateFormatToBrazil.formatDate(_user!.birthdayDate);
      LoggedUser.cpf = _user!.document ?? "";
      LoggedUser.cep = _user!.cep ?? "";
      LoggedUser.city = _user!.city ?? "";
      LoggedUser.street = _user!.address ?? "";
      LoggedUser.houseNumber = _user!.number ?? "";
      LoggedUser.neighborhood = _user!.district ?? "";
      LoggedUser.complement = _user!.complement ?? "";
      LoggedUser.phone = _user!.tellphone ?? "";
      LoggedUser.cellPhone = _user!.cellphone ?? "";
      LoggedUser.email = _user!.email ?? "";
      LoggedUser.uf = _user!.uf ?? "";
      LoggedUser.balanceMoney = _user!.balanceMoney;
      LoggedUser.pouchLastUpdate = _user!.pouchLastUpdate;
      LoggedUser.balanceStuffedAnimals = _user!.balanceStuffedAnimals;
      LoggedUser.stuffedAnimalsLastUpdate = _user!.stuffedAnimalsLastUpdate;
    }

    if (userLogged != null) {
      LoggedUser.nameAndLastName = userLogged!.name!;
      LoggedUser.name = userLogged!.name!.split(' ').first;
      LoggedUser.userType = userLogged!.userType!;
      LoggedUser.id = userLogged!.id!;
      LoggedUser.password = passwordInputController.text;

      await sharedPreferences.setString("user_name_and_last_name", userLogged!.name!);
      await sharedPreferences.setString("user_name", userLogged!.name!.split(' ').first);
      await sharedPreferences.setInt("user_type", LoggedUser.userType.index);
      await sharedPreferences.setString("user_id", userLogged!.id!);
    }
  }

  Future<bool> _doLoginServer(bool fromBiometric) async {
    try {
      String? username = "";
      String? password = "";

      if (fromBiometric) {
        username = await sharedPreferences.getString("user_logged");
        password = await sharedPreferences.getString("password");

        if (username == null || password == null) {
          await _resetLogin("Erro ao se autenticar com a digital.\nPor favor, utilize o login e a senha para continuar.");
          return false;
        }
      }

      userLogged = await _userService
          .authenticate(
            username: fromBiometric ? username : userInputController.text.replaceAll('.', '').replaceAll('-', '').toLowerCase().trim(),
            password: fromBiometric ? password : passwordInputController.text.trim(),
          )
          .timeout(Duration(seconds: 30));
      if(!fromBiometric) {
        await sharedPreferences.setString("password", passwordInputController.text);
      }
      if (userLogged?.success == false) {
        await _resetLogin("Usuário e/ou senha incorretos");
        return false;
      }
      await sharedPreferences.setString('Token', userLogged!.token!);
      await sharedPreferences.setString('ExpiracaoToken', userLogged!.expirationDate!.toIso8601String());
      return true;
    } catch (e) {
      await _resetLogin("Erro ao se conectar com o servidor.");
      return false;
    }
  }

  Future<bool> _getUserInformations() async {
    try {
      _user = await _userService.getUserInformation();

      return _user != null;
    } catch (_) {
      return false;
    }
  }

  _goToNextPage() {
    if (userLogged!.userType == UserType.operator) {
      Get.offAll(() => MainMenuOperatorPage());
    } else if (userLogged!.userType == UserType.treasury) {
      Get.offAll(() => MainMenuFinancialPage());
    } else if (userLogged!.userType == UserType.admin) {
      Get.offAll(() => MainMenuAdministratorPage());
    } else if (userLogged!.userType == UserType.stockist) {
      Get.offAll(() => MainMenuStokistPage());
    }
  }

  _resetLogin(String message) async {
    await loadingWidget.stopAnimation();
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
