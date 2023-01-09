import 'package:elephant_control/app/utils/format_numbers.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/loading_with_success_or_error_widget.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/popups/confirmation_popup.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/popups/information_popup.dart';
import 'package:elephant_control/base/services/user_service.dart';
import 'package:elephant_control/base/viewControllers/recall_money_viewcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import '../../../../../../base/services/interfaces/iuser_service.dart';
import '../../../../../../base/services/visit_service.dart';

class RecallMoneyController extends GetxController {
  late RxBool screenLoading;
  late TextEditingController searchUsers;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late final VisitService _visitService;
  late final IUserService _userService;
  late final RxList<RecallMoneyViewController> _users;

  RecallMoneyController() {
    _initializeVariables();
  }
  @override
  onInit() async {
    await _getTreasuryUsersWithMoneyPouchLaunched();
    super.onInit();
  }

  _initializeVariables(){
    screenLoading = true.obs;
    searchUsers = TextEditingController();
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
    _visitService = VisitService();
    _userService = UserService();
    _users = <RecallMoneyViewController>[].obs;
  }

  //Getters
  List<RecallMoneyViewController> get users => searchUsers.text.toLowerCase().trim().isEmpty ? _users.toList() : _users.where((p0) => p0.name.toLowerCase().trim().contains(searchUsers.text.toLowerCase().trim())).toList();

  Future<void> _getTreasuryUsersWithMoneyPouchLaunched() async {
    try {
      _users.clear();
      _users.addAll(await _userService.getTreasuryUsersWithMoneyPouchLaunched());
      _users.refresh();
      _users.sort((a, b) => a.name.trim().toLowerCase().compareTo(b.name.trim().toLowerCase()));
      screenLoading.value = false;
    } catch (e) {
      await showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Erro buscar os usuários! Tente novamente mais tarde.",
          );
        },
      );
      Get.back();
    }
  }

  void updateList() {
    _users.refresh();
  }

  Future<void> finishVisit(RecallMoneyViewController recallMoneyViewController) async {
    bool? confirm;
    try {
      await showDialog(
          context: Get.context!,
          builder: (context) => ConfirmationPopup(
                title: "Recolher Dinheiro",
                subTitle: "Deseja recolher ${FormatNumbers.numbersToMoney(recallMoneyViewController.totalValue)} de ${recallMoneyViewController.name}?",
                firstButton: () => confirm = false,
                secondButton: () => confirm = true,
              ));
      if (confirm != true) return;
      await loadingWithSuccessOrErrorWidget.startAnimation();
      final finished = await _visitService.recallMoneyVisitsByUserId(recallMoneyViewController.id);
      if (!finished) throw Exception();
      await showDialog(context: Get.context!, builder: (context) => InformationPopup(warningMessage: "Dinheiro recolhido com sucesso"));
    } catch (_) {
      await showDialog(context: Get.context!, builder: (context) => InformationPopup(warningMessage: "Não foi possível recolher o dinheiro"));
    } finally {
      if (confirm == true) await _getTreasuryUsersWithMoneyPouchLaunched();
      await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
    }
  }
}
