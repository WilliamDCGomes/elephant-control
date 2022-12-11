import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../../../base/services/interfaces/iuser_service.dart';
import '../../../../../../base/services/user_service.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/popups/information_popup.dart';
import '../../login/page/login_page_page.dart';

class ForgotInformationController extends GetxController {
  late TextEditingController emailInputController;
  late RxBool loadingAnimation;
  late RxBool emailInputHasError;
  late final GlobalKey<FormState> formKey;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late UserService _userService;

  ForgotInformationController() {
    _inicializeVariables();
  }

  _inicializeVariables() {
    emailInputController = TextEditingController();
    loadingAnimation = false.obs;
    emailInputHasError = false.obs;
    formKey = GlobalKey<FormState>();
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget(
      loadingAnimation: loadingAnimation,
    );
    _userService = UserService();
  }

  sendButtonPressed() async {
    try {
      // if(formKey.currentState!.validate()){
      //   loadingAnimation.value = true;
      //   await loadingWithSuccessOrErrorWidget.startAnimation();
      //   if(await _userService.resetPassword(emailInputController.text)){
      //     await loadingWithSuccessOrErrorWidget.stopAnimation();
      //     await showDialog(
      //       context: Get.context!,
      //       barrierDismissible: false,
      //       builder: (BuildContext context) {
      //         return InformationPopup(
      //           warningMessage: "Enviamos em seu E-mail as instruções para recuperar sua conta.",
      //         );
      //       },
      //     );
      //     await Get.offAll(() => LoginPage());
      //   }
      //   throw Exception();
      // }
    } catch (_) {
      await loadingWithSuccessOrErrorWidget.stopAnimation(fail: true);
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Erro durante a recuperação!\nTente novamente mais tarde.",
          );
        },
      );
    }
  }
}
