import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';

class RegisterPouchController extends GetxController {
  late RxString pouchSelected;
  late RxList<String> pouchs;
  late RxDouble fullValue;
  late RxDouble estimateValue;
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
    fullValue = 0.0.obs;
    estimateValue = 15000.00.obs;
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

  calculeNewValue(){
    fullValue.value = 0;
    if(credCardValue.text.isNotEmpty){
      fullValue.value += double.parse(credCardValue.text.replaceAll('.', '').replaceAll(',', '.').replaceAll('R\$ ', ''));
    }
    if(debtCardValue.text.isNotEmpty){
      fullValue.value += double.parse(debtCardValue.text.replaceAll('.', '').replaceAll(',', '.').replaceAll('R\$ ', ''));
    }
    if(pixValue.text.isNotEmpty){
      fullValue.value += double.parse(pixValue.text.replaceAll('.', '').replaceAll(',', '.').replaceAll('R\$ ', ''));
    }
    if(pouchValue.text.isNotEmpty){
      fullValue.value += double.parse(pouchValue.text.replaceAll('.', '').replaceAll(',', '.').replaceAll('R\$ ', ''));
    }
  }

  String getDifference(){
    double currentValue = estimateValue.value - fullValue.value;

    if(currentValue < 0){
      currentValue *= -1;
    }

    return currentValue.toStringAsFixed(2).replaceAll('.', ',');
  }
}