import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';

class FingerPrintSettingController extends GetxController {
  late RxBool loadingAnimation;
  late RxBool fingerPrintLoginChecked;
  late RxBool alwaysRequestFingerPrintChecked;
  late RxBool enableAlwaysRequestFingerPrint;
  late RxBool fingerPrintChangePasswordChecked;
  late RxBool fingerPrintToGeneratePouchCode;
  late RxBool fingerPrintToReceivePouch;
  late FocusNode saveButtonFocusNode;
  late SharedPreferences sharedPreferences;
  late final LocalAuthentication fingerPrintAuth;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;

  FingerPrintSettingController(){
    _initializeVariables();
  }

  @override
  void onInit() async {
    sharedPreferences = await SharedPreferences.getInstance();
    await _getSettingsFingerPrint();
    super.onInit();
  }

  _initializeVariables(){
    fingerPrintLoginChecked = false.obs;
    alwaysRequestFingerPrintChecked = false.obs;
    enableAlwaysRequestFingerPrint = true.obs;
    fingerPrintChangePasswordChecked = false.obs;
    fingerPrintToGeneratePouchCode = false.obs;
    fingerPrintToReceivePouch = false.obs;
    loadingAnimation = false.obs;
    saveButtonFocusNode = FocusNode();

    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget(
      loadingAnimation: loadingAnimation,
    );
    fingerPrintAuth = LocalAuthentication();
  }

  _getSettingsFingerPrint() async {
    fingerPrintLoginChecked.value = await sharedPreferences.getBool("user_finger_print") ?? false;
    alwaysRequestFingerPrintChecked.value = await sharedPreferences.getBool("always_request_finger_print") ?? false;
    fingerPrintToGeneratePouchCode.value = await sharedPreferences.getBool("finger_print_to_generate_pouch_code") ?? false;
    fingerPrintToReceivePouch.value = await sharedPreferences.getBool("finger_print_to_receive_pouch") ?? false;
    fingerPrintChangePasswordChecked.value = await sharedPreferences.getBool("finger_print_change_password") ?? false;

    enableAlwaysRequestFingerPrint.value = !fingerPrintLoginChecked.value;
  }

  fingerPrintLoginPressed(){
    fingerPrintLoginChecked.value = !fingerPrintLoginChecked.value;
    if(!fingerPrintLoginChecked.value){
      alwaysRequestFingerPrintChecked.value = false;
      enableAlwaysRequestFingerPrint.value = true;
    }
    else{
      enableAlwaysRequestFingerPrint.value = false;
    }
  }

  alwaysRequestFingerPrintPressed(){
    alwaysRequestFingerPrintChecked.value = !alwaysRequestFingerPrintChecked.value;
  }

  fingerPrintChangePasswordPressed(){
    fingerPrintChangePasswordChecked.value = !fingerPrintChangePasswordChecked.value;
  }

  fingerPrintToGeneratePouchCodePressed(){
    fingerPrintToGeneratePouchCode.value = !fingerPrintToGeneratePouchCode.value;
  }

  fingerPrintToReceivePouchPressed(){
    fingerPrintToReceivePouch.value = !fingerPrintToReceivePouch.value;
  }

  _checkFingerPrint() async {
    if(await fingerPrintAuth.canCheckBiometrics){
      var authenticate = await fingerPrintAuth.authenticate(
        localizedReason: "Utilize a sua digital para salvar as configurações.",
      );

      if (authenticate) {
        return true;
      }
      return false;
    }
    return true;
  }

  saveButtonPressed() async {
    try{
      if(await _checkFingerPrint()){
        loadingAnimation.value = true;
        await loadingWithSuccessOrErrorWidget.startAnimation();
        await sharedPreferences.setBool("user_finger_print", fingerPrintLoginChecked.value);
        await sharedPreferences.setBool("always_request_finger_print", alwaysRequestFingerPrintChecked.value);
        await sharedPreferences.setBool("finger_print_change_password", fingerPrintChangePasswordChecked.value);
        await sharedPreferences.setBool("finger_print_to_generate_pouch_code", fingerPrintToGeneratePouchCode.value);
        await sharedPreferences.setBool("finger_print_to_receive_pouch", fingerPrintToReceivePouch.value);

        await loadingWithSuccessOrErrorWidget.stopAnimation();
        Get.back();
      }
    }
    catch(_){
      await loadingWithSuccessOrErrorWidget.stopAnimation(fail: true);
    }
  }
}