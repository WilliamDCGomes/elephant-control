import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';

class ReceivePouchFromOperatorController extends GetxController {
  late RxString operatorSelected;
  late RxList<String> operators;
  late RxBool loadingAnimation;
  late TextEditingController operatorCode;
  late TextEditingController pouchQuantity;
  late TextEditingController observations;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;

  ReceivePouchFromOperatorController(){
    _inicializeList();
    _initializeVariables();
  }

  _inicializeList(){
    operators = [
      "José Carlos",
      "Vínicius Moretto",
      "Vagnar Torres",
    ].obs;
  }

  _initializeVariables(){
    operatorSelected = operators[0].obs;
    loadingAnimation = false.obs;
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget(
      loadingAnimation: loadingAnimation,
    );
    operatorCode = TextEditingController();
    pouchQuantity = TextEditingController();
    observations = TextEditingController();
  }

  onDropdownButtonWidgetChanged(String? selectedState){
    operatorSelected.value = selectedState ?? "";
  }
}