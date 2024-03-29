import 'package:elephant_control/app/utils/logged_user.dart';
import 'package:elephant_control/base/models/user/user.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';

class FingerPrintSettingController extends GetxController {
  late RxBool showReceivePouchOptionAnimation;
  late RxBool fingerPrintLoginChecked;
  late RxBool alwaysRequestFingerPrintChecked;
  late RxBool enableAlwaysRequestFingerPrint;
  late RxBool fingerPrintChangePasswordChecked;
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
    showReceivePouchOptionAnimation = false.obs;
    fingerPrintLoginChecked = false.obs;
    alwaysRequestFingerPrintChecked = false.obs;
    enableAlwaysRequestFingerPrint = true.obs;
    fingerPrintChangePasswordChecked = false.obs;
    fingerPrintToReceivePouch = false.obs;
    saveButtonFocusNode = FocusNode();

    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
    fingerPrintAuth = LocalAuthentication();
  }

  _getSettingsFingerPrint() async {
    showReceivePouchOptionAnimation.value = LoggedUser.userType == UserType.treasury;
    fingerPrintLoginChecked.value = await sharedPreferences.getBool("user_finger_print") ?? false;
    alwaysRequestFingerPrintChecked.value = await sharedPreferences.getBool("always_request_finger_print") ?? false;
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
        await loadingWithSuccessOrErrorWidget.startAnimation();
        await sharedPreferences.setBool("user_finger_print", fingerPrintLoginChecked.value);
        await sharedPreferences.setBool("always_request_finger_print", alwaysRequestFingerPrintChecked.value);
        await sharedPreferences.setBool("finger_print_change_password", fingerPrintChangePasswordChecked.value);
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