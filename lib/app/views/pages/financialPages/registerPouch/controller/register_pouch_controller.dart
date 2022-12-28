import 'package:elephant_control/base/services/visit_service.dart';
import 'package:elephant_control/base/viewControllers/money_pouch_viewcontroller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../base/models/visit/model/visit.dart';
import '../../../../../../base/services/money_pouch_service.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/popups/information_popup.dart';

class RegisterPouchController extends GetxController {
  Visit? pouchSelected;
  late RxList<Visit> pouchs;
  late RxDouble fullValue;
  late RxDouble estimateValue;
  late RxBool loadingAnimation;
  late TextEditingController pouchValue;
  late TextEditingController credCardValue;
  late TextEditingController debtCardValue;
  late TextEditingController pixValue;
  late TextEditingController observations;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;

  RegisterPouchController() {
    _inicializeList();
    _initializeVariables();
    _getMoneyPouchReceived();
  }

  _inicializeList() {
    pouchs = <Visit>[].obs;
  }

  _initializeVariables() {
    loadingAnimation = false.obs;
    fullValue = 0.0.obs;
    estimateValue = 0.00.obs;
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget(
      loadingAnimation: loadingAnimation,
    );
    pouchValue = TextEditingController();
    credCardValue = TextEditingController();
    debtCardValue = TextEditingController();
    pixValue = TextEditingController();
    observations = TextEditingController();
  }

  Future<void> _getMoneyPouchReceived() async {
    loadingAnimation.value = true;
    pouchs.addAll(await MoneyPouchService().getMoneyPouchReceived());
    loadingAnimation.value = false;
  }

  onDropdownButtonWidgetChanged(String? visitId) {
    pouchSelected = pouchs.firstWhereOrNull((element) => element.id == visitId);
    if (pouchSelected != null) estimateValue.value = pouchSelected!.moneyQuantity;
  }

  calculeNewValue() {
    fullValue.value = 0;
    if (credCardValue.text.isNotEmpty) {
      fullValue.value += double.parse(credCardValue.text.replaceAll('.', '').replaceAll(',', '.').replaceAll('R\$ ', ''));
    }
    if (debtCardValue.text.isNotEmpty) {
      fullValue.value += double.parse(debtCardValue.text.replaceAll('.', '').replaceAll(',', '.').replaceAll('R\$ ', ''));
    }
    if (pixValue.text.isNotEmpty) {
      fullValue.value += double.parse(pixValue.text.replaceAll('.', '').replaceAll(',', '.').replaceAll('R\$ ', ''));
    }
    if (pouchValue.text.isNotEmpty) {
      fullValue.value += double.parse(pouchValue.text.replaceAll('.', '').replaceAll(',', '.').replaceAll('R\$ ', ''));
    }
  }

  String getDifference() {
    double currentValue = estimateValue.value - fullValue.value;

    if (currentValue < 0) {
      currentValue *= -1;
    }

    return currentValue.toStringAsFixed(2).replaceAll('.', ',');
  }

  Future<void> save() async {
    try {
      loadingAnimation.value = true;
      final moneyPouchViewController = MoneyPouchViewController(pouchValue: fullValue.value, differenceValue: estimateValue.value - fullValue.value <= 0 ? null : estimateValue.value - fullValue.value, cardValue: 0, observation: observations.text, visitId: pouchSelected!.id!);
      moneyPouchViewController.valueMatch = false;
      final result = await VisitService().changeStatusMoneyPouchReceivedToMoneyPouchLaunched(moneyPouchViewController);
      if (result) {
        Get.back();
        showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return InformationPopup(
              warningMessage: "Malote lançado com sucesso",
            );
          },
        );
      }
    } catch (_) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Não foi possível lançar o malote",
          );
        },
      );
    } finally {
      loadingAnimation.value = false;
    }
  }
}
