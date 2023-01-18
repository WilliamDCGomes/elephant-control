import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../base/models/user/user.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';

class AddRemoveOperatorBalancePlushController extends GetxController {
  late RxBool screenLoading;
  late RxList<User> operators;
  late TextEditingController plushQuantity;
  late TextEditingController observations;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late User? operatorSelected;

  AddRemoveOperatorBalancePlushController() {
    _initializeVariables();
    _inicializeList();
  }

  @override
  void onInit() async {
    screenLoading.value = false;
    super.onInit();
  }

  _initializeVariables() {
    screenLoading = true.obs;
    operatorSelected = null;
    plushQuantity = TextEditingController();
    observations = TextEditingController();
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
  }

  _inicializeList() {
    operators = <User>[].obs;
  }

  void onDropdownButtonWidgetChanged(String? selectedState) async {
    try {
      operatorSelected = operators.firstWhereOrNull((element) => element.id == selectedState);
      if (operatorSelected != null) {
        await loadingWithSuccessOrErrorWidget.startAnimation();
        await Future.delayed(Duration(seconds: 2));
        await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
      }
    } catch (_) {
      await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
      operatorSelected = null;
    }
  }
}