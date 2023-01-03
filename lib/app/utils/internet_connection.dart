import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/pages/widgetsShared/loading_with_success_or_error_widget.dart';
import '../views/pages/widgetsShared/popups/information_popup.dart';

class InternetConnection {
  static Future<bool> checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } on SocketException catch (_) {
      return false;
    }
  }

  static Future<bool> validInternet(String errorMessage, LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget) async {
    try {
      await loadingWithSuccessOrErrorWidget.startAnimation();
      await Future.delayed(Duration(seconds: 1));

      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
        return true;
      }
      throw Exception();
    }
    catch (_) {
      await loadingWithSuccessOrErrorWidget.stopAnimation(fail: true);
      await showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: errorMessage,
          );
        },
      );
      return false;
    }
  }
}