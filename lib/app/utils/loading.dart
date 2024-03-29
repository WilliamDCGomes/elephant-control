import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/pages/widgetsShared/loading_widget.dart';
import '../views/pages/widgetsShared/loading_with_success_or_error_widget.dart';

class Loading{
  static Future startAndPauseLoading(Function action, LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget) async {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    await loadingWithSuccessOrErrorWidget.startAnimation();

    await Future.delayed(Duration(seconds: 1));
    await action();

    await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
  }

  static Future starAnimationAndCallOtherPage(
      Function action,
      LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget,
      Widget destinationPage,
  ) async {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    await loadingWithSuccessOrErrorWidget.startAnimation();

    await Future.delayed(Duration(seconds: 1));
    await action();

    await loadingWithSuccessOrErrorWidget.stopAnimation(
      destinationPage: destinationPage
    );
  }

  static Future startAndPauseLoadingLogin(Function action, LoadingWidget loadingWidget) async {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    await loadingWidget.startAnimation();

    await Future.delayed(Duration(seconds: 1));
    await action();

    await loadingWidget.stopAnimation(justLoading: true);
  }
}