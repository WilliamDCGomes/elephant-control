import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../utils/platform_type.dart';
import '../../../widgetsShared/loading_with_success_or_error_tablet_phone_widget.dart';

class InitialPageController extends GetxController {
  late RxBool loadingAnimationSuccess;
  late SharedPreferences sharedPreferences;
  late final LocalAuthentication fingerPrintAuth;
  late LoadingWithSuccessOrErrorTabletPhoneWidget loadingWithSuccessOrErrorTabletPhoneWidget;

  InitialPageController(){
    _initializeVariables();
  }

  @override
  void onInit() async {
    sharedPreferences = await SharedPreferences.getInstance();
    await Firebase.initializeApp();
    await _loadFirstScreen();
    super.onInit();
  }

  _initializeVariables(){
    loadingAnimationSuccess = false.obs;
    loadingWithSuccessOrErrorTabletPhoneWidget = LoadingWithSuccessOrErrorTabletPhoneWidget(
      loadingAnimation: loadingAnimationSuccess,
    );
    fingerPrintAuth = LocalAuthentication();
  }

  _loadFirstScreen() async {
    await Future.delayed(Duration(seconds: 2));
    if(PlatformType.isPhone(Get.context!) || PlatformType.isTablet(Get.context!)) {
      if(await sharedPreferences.getBool("show-welcome-page-key") ?? true){
        await sharedPreferences.setBool("show-welcome-page-key", false);
        Get.offAll(() => WelcomePageTabletPhonePage());
      }
      else if(await sharedPreferences.getBool("keep-connected") ?? false){
        if(await fingerPrintAuth.canCheckBiometrics && (await sharedPreferences.getBool("always_request_finger_print") ?? false)){
          var authenticate = await fingerPrintAuth.authenticate(
            localizedReason: "Utilize a sua digital para fazer o login.",
          );

          if (authenticate) {
            loadingAnimationSuccess.value = true;

            await loadingWithSuccessOrErrorTabletPhoneWidget.stopAnimation(duration: 2);
            Get.offAll(() => MainMenuTabletPhonePage());
          }
          else{
            Get.offAll(() => LoginPageTabletPhone());
          }
        }
        else{
          Get.offAll(() => MainMenuTabletPhonePage());
        }
      }
      else{
        Get.offAll(() => LoginPageTabletPhone());
      }
    }
  }
}