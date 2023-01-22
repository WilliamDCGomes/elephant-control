import 'package:elephant_control/app/utils/date_format_to_brazil.dart';
import 'package:elephant_control/app/utils/format_numbers.dart';
import 'package:elephant_control/base/services/visit_service.dart';
import 'package:elephant_control/base/viewControllers/money_pouch_viewcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../base/models/visit/visit.dart';
import '../../../../../../base/services/money_pouch_service.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/popups/information_popup.dart';
import '../../mainMenuFinancial/controller/main_menu_financial_controller.dart';

class RegisterPouchController extends GetxController {
  Visit? pouchSelected;
  late RxList<Visit> pouchs;
  late RxDouble fullValue;
  late RxDouble estimateValue;
  late RxString lastVisit;
  late RxString inclusionVisit;
  late TextEditingController pouchValue;
  late TextEditingController credCardValue;
  late TextEditingController debtCardValue;
  late TextEditingController pixValue;
  late TextEditingController observations;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;

  RegisterPouchController() {
    _inicializeList();
    _initializeVariables();
  }

  @override
  void onInit() async {
    await Future.delayed(Duration(milliseconds: 200));
    await _getMoneyPouchReceived();
    super.onInit();
  }

  _inicializeList() {
    pouchs = <Visit>[].obs;
  }

  _initializeVariables() {
    lastVisit = "".obs;
    inclusionVisit = "".obs;
    fullValue = 0.0.obs;
    estimateValue = 0.00.obs;
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
    pouchValue = TextEditingController();
    credCardValue = TextEditingController();
    debtCardValue = TextEditingController();
    pixValue = TextEditingController();
    observations = TextEditingController();
  }

  Future<void> _getMoneyPouchReceived() async {
    try {
      await loadingWithSuccessOrErrorWidget.startAnimation();
      pouchs.addAll(await MoneyPouchService().getMoneyPouchReceived());
      await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
    } catch (_) {
      await loadingWithSuccessOrErrorWidget.stopAnimation(fail: true);
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Erro ao receber informações para lançar o malote!\nTente novamente mais tarde.",
          );
        },
      );
      Get.back();
    }
  }

  onDropdownButtonWidgetChanged(String? visitId) {
    pouchSelected = pouchs.firstWhereOrNull((element) => element.id == visitId);
    if (pouchSelected != null) {
      estimateValue.value = pouchSelected!.moneyQuantity;
      lastVisit.value = DateFormatToBrazil.formatDateAndHour(pouchSelected?.machine?.lastVisit);
      inclusionVisit.value = DateFormatToBrazil.formatDateAndHour(pouchSelected?.inclusion);
      debtCardValue.text = pouchSelected?.debit == null ? "" : FormatNumbers.numbersToMoney(pouchSelected!.debit);
      credCardValue.text = pouchSelected?.credit == null ? "" : FormatNumbers.numbersToMoney(pouchSelected!.credit);
    }
    calculeNewValue();
  }

  calculeNewValue() {
    fullValue.value = 0;
    if (credCardValue.text.isNotEmpty) {
      fullValue.value += FormatNumbers.stringToNumber(credCardValue.text);
      // double.parse(credCardValue.text.replaceAll('.', '').replaceAll(',', '.').replaceAll('R\$ ', ''));
    }
    if (debtCardValue.text.isNotEmpty) {
      fullValue.value += FormatNumbers.stringToNumber(debtCardValue
          .text); //double.parse(debtCardValue.text.replaceAll('.', '').replaceAll(',', '.').replaceAll('R\$ ', ''));
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
      await loadingWithSuccessOrErrorWidget.startAnimation();
      final moneyPouchViewController = MoneyPouchViewController(
          pouchValue: fullValue.value,
          differenceValue: estimateValue.value - fullValue.value <= 0 ? null : estimateValue.value - fullValue.value,
          cardValue: 0,
          observation: observations.text,
          visitId: pouchSelected!.id!);
      moneyPouchViewController.valueMatch = false;
      final result = await VisitService().changeStatusMoneyPouchReceivedToMoneyPouchLaunched(moneyPouchViewController);
      if (result) {
        await loadingWithSuccessOrErrorWidget.stopAnimation();
        Future.microtask(() async =>
            await Get.find<MainMenuFinancialController>(tag: 'main_menu_financial_controller').getQuantityData());
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
      await loadingWithSuccessOrErrorWidget.stopAnimation(fail: true);
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Não foi possível lançar o malote",
          );
        },
      );
    }
  }
}
