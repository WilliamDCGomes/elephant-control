import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../operatorPages/mainMenu/page/main_menu_page.dart';
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
          Get.offAll(() => MainMenuPage());
        }
        else{
          Get.offAll(() => LoginPage());
        }
      }
      else{
        Get.offAll(() => MainMenuPage());
      }
    }
    else{
      Get.offAll(() => LoginPage());
    }
  }
}