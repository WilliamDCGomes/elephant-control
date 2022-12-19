import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';

class RegisterPouchController extends GetxController {
  late RxString pouchSelected;
  late RxList<String> pouchs;
  late RxBool loadingAnimation;
  late TextEditingController pouchValue;
  late TextEditingController credCardValue;
  late TextEditingController debtCardValue;
  late TextEditingController pixValue;
  late TextEditingController observations;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;

  RegisterPouchController(){
    _inicializeList();
    _initializeVariables();
  }

  _inicializeList(){
    pouchs = [
      "Boulevard Shopping",
      "Shopping Central",
      "Mercado Central",
    ].obs;
  }

  _initializeVariables(){
    pouchSelected = pouchs[0].obs;
    loadingAnimation = false.obs;
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget(
      loadingAnimation: loadingAnimation,
    );
    pouchValue = TextEditingController();
    credCardValue = TextEditingController();
    debtCardValue = TextEditingController();
    pixValue = TextEditingController();
    observations = TextEditingController();
  }

  onDropdownButtonWidgetChanged(String? selectedState){
    pouchSelected.value = selectedState ?? "";
  }
}