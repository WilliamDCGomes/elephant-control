import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/popups/information_popup.dart';

class ForgotInformationController extends GetxController {
  late TextEditingController emailInputController;
  late RxBool emailInputHasError;
  late final GlobalKey<FormState> formKey;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;

  ForgotInformationController() {
    _inicializeVariables();
  }

  _inicializeVariables() {
    emailInputController = TextEditingController();
    emailInputHasError = false.obs;
    formKey = GlobalKey<FormState>();
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
  }

  sendButtonPressed() async {
    try {
      // if(formKey.currentState!.validate()){
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
