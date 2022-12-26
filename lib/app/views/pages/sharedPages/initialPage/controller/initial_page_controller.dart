import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../../base/models/user/model/user.dart';
import '../../../../../utils/logged_user.dart';
import '../../../financialPages/mainMenuFinancial/page/main_menu_financial_page.dart';
import '../../../operatorPages/mainMenuOperator/page/main_menu_operator_page.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../login/page/login_page_page.dart';

class InitialPageController extends GetxController {
  late RxBool loadingAnimationSuccess;
  late SharedPreferences sharedPreferences;
  late final LocalAuthentication fingerPrintAuth;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;

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
    loadingAnimationSuccess = false.obs;
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget(
      loadingAnimation: loadingAnimationSuccess,
    );
    fingerPrintAuth = LocalAuthentication();
  }

  _loadFirstScreen() async {
    await Future.delayed(Duration(seconds: 2));
    if(await sharedPreferences.getBool("keep-connected") ?? false){
      if(await fingerPrintAuth.canCheckBiometrics && (await sharedPreferences.getBool("always_request_finger_print") ?? false)){
        var authenticate = await fingerPrintAuth.authenticate(
          localizedReason: "Utilize a sua digital para fazer o login.",
        );

        if (authenticate) {
          loadingAnimationSuccess.value = true;

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
    }
    else if (LoggedUser.userType == UserType.admin) {
      Get.offAll(() => MainMenuOperatorPage());
    }
    else {
      Get.offAll(() => MainMenuFinancialPage());
    }
  }

  Future<void> _doLoginServerKeepConnected() async {
    try{
      LoggedUser.nameAndLastName = await sharedPreferences.getString("user_name_and_last_name") ?? "";
      LoggedUser.name = await sharedPreferences.getString("user_name",) ?? "";
      LoggedUser.userType = await UserType.values[sharedPreferences.getInt("user_type") ?? 4];
      LoggedUser.id = await sharedPreferences.getString("user_id") ?? "";
    }
    catch(_){

    }
  }
}