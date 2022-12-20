import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../popup/receive_pouch_popup.dart';
import '../widget/pouch_widget.dart';

class ReceivePouchFromOperatorController extends GetxController {
  late RxString operatorSelected;
  late RxList<String> operators;
  late RxList<PouchWidget> pouchWidgetList;
  late RxList<PouchWidget> pouchWidgetViewList;
  late RxList<PouchWidget> pouchsSelectedList;
  late RxBool loadingAnimation;
  late TextEditingController operatorCode;
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

    pouchWidgetList = <PouchWidget>[
      PouchWidget(
        title: "Shopping Boulevard",
        operatorName: "José Carlos",
      ),
      PouchWidget(
        title: "Supermercado Central",
        operatorName: "José Carlos",
      ),
      PouchWidget(
        title: "Cinema Alameda",
        operatorName: "José Carlos",
      ),
      PouchWidget(
        title: "Shopping Oeste",
        operatorName: "Vínicius Moretto",
      ),
      PouchWidget(
        title: "Supermercado Oeste",
        operatorName: "Vínicius Moretto",
      ),
      PouchWidget(
        title: "Cinepólis",
        operatorName: "Vagnar Torres",
      ),
    ].obs;

    pouchWidgetViewList = <PouchWidget>[].obs;
    pouchsSelectedList = <PouchWidget>[].obs;
  }

  _initializeVariables(){
    operatorSelected = operators[0].obs;
    refreshPouchList();
    loadingAnimation = false.obs;
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget(
      loadingAnimation: loadingAnimation,
    );
    operatorCode = TextEditingController();
    observations = TextEditingController();
  }

  openPouchList(){
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return ReceivePouchPopup(
          controller: this,
        );
      },
    );
  }

  refreshPouchList(){
    pouchWidgetViewList.clear();
    pouchWidgetList.forEach((element) {
      if(element.operatorName == operatorSelected.value){
        pouchWidgetViewList.add(element);
      }
    });
  }

  onDropdownButtonWidgetChanged(String? selectedState){
    operatorSelected.value = selectedState ?? "";
    refreshPouchList();
  }

  selectedPouch(){
    pouchsSelectedList.clear();
    pouchWidgetViewList.forEach((element) {
      if(element.checked.value){
        pouchsSelectedList.add(element);
      }
    });
    Get.back();
  }
}