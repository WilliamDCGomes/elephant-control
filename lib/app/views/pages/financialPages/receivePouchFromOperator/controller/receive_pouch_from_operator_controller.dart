import 'package:elephant_control/base/services/money_pouch_service.dart';
import 'package:elephant_control/base/services/visit_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../base/models/user/model/user.dart';
import '../../../../../../base/models/visit/model/visit.dart';
import '../../../../../../base/viewControllers/add_money_pouch_viewcontroller.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/popups/information_popup.dart';
import '../../mainMenuFinancial/controller/main_menu_financial_controller.dart';
import '../popup/receive_pouch_popup.dart';

class ReceivePouchFromOperatorController extends GetxController {
  User? operatorSelected;
  late RxList<User> operators;
  late RxList<Visit> pouchListBase;
  late RxList<Visit> pouchList;
  late RxBool loadingAnimation;
  late TextEditingController operatorCode;
  late TextEditingController observations;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late final GlobalKey<FormState> _formKey;

  ReceivePouchFromOperatorController() {
    _inicializeList();
    _initializeVariables();
    _getData();
  }

  //Getters
  GlobalKey<FormState> get formKey => _formKey;
  List<Visit> get pouchsSelectedList => pouchList.where((element) => element.checked).toList();

  _inicializeList() {
    operators = <User>[].obs;
    pouchList = <Visit>[].obs;
    pouchListBase = <Visit>[].obs;
  }

  _initializeVariables() {
    loadingAnimation = false.obs;
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget(
      loadingAnimation: loadingAnimation,
    );
    operatorCode = TextEditingController();
    observations = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  void _getData() async {
    try {
      loadingAnimation.value = true;
      await _getOperatorUsersWithVisitStatusMoneyWithdrawal();
    } catch (_) {
    } finally {
      loadingAnimation.value = false;
    }
  }

  Future<void> _getOperatorUsersWithVisitStatusMoneyWithdrawal() async {
    try {
      operators.addAll(await VisitService().getOperatorUsersWithVisitStatusMoneyWithdrawal());
    } catch (_) {
      operators.clear();
    }
  }

  Future<void> _getMoneyPouchMoneyWithdrawal(String operatorUserId) async {
    try {
      pouchList.clear();
      pouchList.addAll(await MoneyPouchService().getMoneyPouchMoneyWithdrawal(operatorUserId));
    } catch (_) {
      pouchList.clear();
    }
  }

  openPouchList() {
    if (operatorSelected == null) {
      Get.snackbar('Operador não selecionado', 'Por favor, selecione um operador', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (!formKey.currentState!.validate()) return;
    if (int.parse(operatorCode.text) != operatorSelected?.code) {
      Get.snackbar('Código de operador inválido', 'Por favor, verifique o código digitado', snackPosition: SnackPosition.BOTTOM);
    } else {
      showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return ReceivePouchPopup(
            controller: this,
          );
        },
      );
    }
  }

  void onDropdownButtonWidgetChanged(String? selectedState) async {
    try {
      operatorSelected = operators.firstWhereOrNull((element) => element.id == selectedState);
      if (operatorSelected != null) {
        loadingAnimation.value = true;
        await _getMoneyPouchMoneyWithdrawal(operatorSelected!.id!);
        loadingAnimation.value = false;
      }
    } catch (_) {
      operatorSelected = null;
    }
  }

  selectedPouch() async {
    Get.back();
  }

  Future<void> saveReceivedPouch() async {
    if (pouchsSelectedList.isEmpty) {
      Get.snackbar('Nenhum saque selecionado', 'Por favor, selecione pelo menos um saque', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    bool enviado = false;
    List<String> pouchsWithErrors = [];
    try {
      loadingAnimation.value = true;
      for (var moneyPouch in pouchsSelectedList) {
        final addMoneyPouchViewController = AddMoneyPouchViewController(
          userOperatorId: operatorSelected!.id!,
          code: int.parse(operatorCode.text),
          visitId: moneyPouch.id!,
          observation: observations.text,
        );
        enviado = await VisitService().changeStatusMoneyWithdrawalToMoneyPouchReceived(addMoneyPouchViewController);
        if (!enviado) {
          pouchsWithErrors.add(moneyPouch.machine!.name);
        }
      }
      Get.back();
      if (pouchsWithErrors.isNotEmpty) throw Exception();
      Future.microtask(() async => await Get.find<MainMenuFinancialController>(tag: 'main_menu_financial_controller').getQuantityData());
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Malotes recebidos com sucesso",
          );
        },
      );
    } catch (_) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Não foi possível receber os malotes: ${pouchsWithErrors.join('\n')}",
          );
        },
      );
    } finally {
      loadingAnimation.value = false;
    }
  }
}
