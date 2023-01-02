import 'package:elephant_control/base/services/money_pouch_service.dart';
import 'package:elephant_control/base/services/visit_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../../base/models/user/model/user.dart';
import '../../../../../../base/models/visit/model/visit.dart';
import '../../../../../../base/viewControllers/add_money_pouch_viewcontroller.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/popups/information_popup.dart';
import '../../../widgetsShared/snackbar_widget.dart';
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
  late SharedPreferences sharedPreferences;
  late final LocalAuthentication fingerPrintAuth;

  ReceivePouchFromOperatorController() {
    _inicializeList();
    _initializeVariables();
  }

  @override
  void onInit() async {
    sharedPreferences = await SharedPreferences.getInstance();
    await Future.delayed(Duration(milliseconds: 200));
    await _getData();
    super.onInit();
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
    fingerPrintAuth = LocalAuthentication();
  }

  Future<void> _getData() async {
    try {
      loadingAnimation.value = true;
      await loadingWithSuccessOrErrorWidget.startAnimation();
      await _getOperatorUsersWithVisitStatusMoneyWithdrawal();
      await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
    } catch (_) {
      await loadingWithSuccessOrErrorWidget.stopAnimation(fail: true);
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Erro ao receber informações para receber o malote!\nTente novamente mais tarde.",
          );
        },
      );
      Get.back();
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
      SnackbarWidget(
        warningText: "Operador não selecionado",
        informationText: "Por favor, selecione um operador",
        backgrondColor: AppColors.defaultColor,
      );
      return;
    }
    if (!formKey.currentState!.validate()) return;
    if (int.parse(operatorCode.text) != operatorSelected?.code) {
      SnackbarWidget(
        warningText: "Código de operador inválido",
        informationText: "Por favor, verifique o código digitado",
        backgrondColor: AppColors.defaultColor,
      );
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
        await loadingWithSuccessOrErrorWidget.startAnimation();
        await _getMoneyPouchMoneyWithdrawal(operatorSelected!.id!);
        await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
      }
    } catch (_) {
      await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
      operatorSelected = null;
    }
  }

  selectedPouch() async {
    Get.back();
  }

  Future<bool> _checkBiometricSensor() async {
    try {
      bool? useFingerPrint = await sharedPreferences.getBool("finger_print_to_receive_pouch");
      if (await fingerPrintAuth.canCheckBiometrics && (useFingerPrint ?? false)) {
        var authenticate = await fingerPrintAuth.authenticate(
          localizedReason: "Utilize a sua digital para receber o malote.",
        );

        return authenticate;
      }
      return true;
    } catch (e) {
      loadingAnimation.value = true;
      await loadingWithSuccessOrErrorWidget.stopAnimation(fail: true);
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Erro ao receber o malote!\nTente novamente mais tarde.",
          );
        },
      );
      return false;
    }
  }

  Future<void> saveReceivedPouch() async {
    if (pouchsSelectedList.isEmpty) {
      SnackbarWidget(
        warningText: "Nenhum saque selecionado",
        informationText: "Por favor, selecione pelo menos um saque",
        backgrondColor: AppColors.defaultColor,
      );
      return;
    }
    bool enviado = false;
    List<String> pouchsWithErrors = [];
    try {
      if(!await _checkBiometricSensor()){
        return;
      }
      loadingAnimation.value = true;
      await loadingWithSuccessOrErrorWidget.startAnimation();
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
      await loadingWithSuccessOrErrorWidget.stopAnimation();
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
      await loadingWithSuccessOrErrorWidget.stopAnimation(fail: true);
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Não foi possível receber os malotes: ${pouchsWithErrors.join('\n')}",
          );
        },
      );
    }
  }
}
