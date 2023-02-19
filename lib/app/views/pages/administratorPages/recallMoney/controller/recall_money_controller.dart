import 'package:elephant_control/app/utils/format_numbers.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/loading_with_success_or_error_widget.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/popups/confirmation_popup.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/popups/default_popup_widget.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/popups/information_popup.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/text_field_widget.dart';
import 'package:elephant_control/base/services/user_service.dart';
import 'package:elephant_control/base/viewControllers/recall_money_viewcontroller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../../base/services/interfaces/iuser_service.dart';
import '../../../../../../base/services/visit_service.dart';
import '../../../../../utils/money_mask.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/button_widget.dart';

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

  _initializeVariables() {
    screenLoading = true.obs;
    searchUsers = TextEditingController();
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
    _visitService = VisitService();
    _userService = UserService();
    _users = <RecallMoneyViewController>[].obs;
  }

  //Getters
  List<RecallMoneyViewController> get users => searchUsers.text.toLowerCase().trim().isEmpty
      ? _users.toList()
      : _users.where((p0) => p0.name.toLowerCase().trim().contains(searchUsers.text.toLowerCase().trim())).toList();

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
    bool personalizedValue = false;
    try {
      await showDialog(
          context: Get.context!,
          builder: (context) => ConfirmationPopup(
                title: "Recolher Dinheiro",
                subTitle:
                    "Deseja digitar um valor para recolher? Caso não irá recolher o valor ${FormatNumbers.numbersToMoney(recallMoneyViewController.totalValue)} de ${recallMoneyViewController.name}",
                firstButton: () => personalizedValue = false,
                secondButton: () => personalizedValue = true,
              ));
      double? value = personalizedValue ? 0 : null;
      if (personalizedValue) {
        final controller = TextEditingController();
        await showDialog(
            context: Get.context!,
            builder: (context) => DefaultPopupWidget(
                  title: "Digite o valor que deseja recolher",
                  children: [
                    SizedBox(height: 1.h),
                    TextFieldWidget(
                      controller: controller,
                      hintText: "Digite o valor",
                      height: 9.h,
                      keyboardType: TextInputType.number,
                      maskTextInputFormatter: [FilteringTextInputFormatter.digitsOnly, MoneyMask()],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ButtonWidget(
                          hintText: "Cancelar",
                          heightButton: 5.h,
                          widthButton: 32.w,
                          fontWeight: FontWeight.bold,
                          backgroundColor: AppColors.whiteColor,
                          borderColor: AppColors.defaultColor,
                          textColor: AppColors.defaultColor,
                          onPressed: () {
                            Get.back();
                          },
                        ),
                        SizedBox(width: 2.w),
                        ButtonWidget(
                          hintText: "Confirmar",
                          heightButton: 5.h,
                          widthButton: 32.w,
                          fontWeight: FontWeight.bold,
                          onPressed: () {
                            if (FormatNumbers.stringToNumber(controller.text) > recallMoneyViewController.totalValue)
                              return showDialog(
                                  context: Get.context!,
                                  builder: (context) => InformationPopup(
                                        warningMessage: "O valor digitado é maior que o valor total do usuário!",
                                      ));
                            value = FormatNumbers.stringToNumber(controller.text);

                            confirm = true;
                            Get.back();
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                  ],
                ));
      } else {
        confirm = true;
      }
      if (value == 0) return;
      // await showDialog(
      //     context: Get.context!,
      //     builder: (context) => ConfirmationPopup(
      //           title: "Recolher Dinheiro",
      //           subTitle:
      //               "Deseja recolher ${FormatNumbers.numbersToMoney(recallMoneyViewController.totalValue)} de ${recallMoneyViewController.name}?",
      //           firstButton: () => confirm = false,
      //           secondButton: () => confirm = true,
      //         ));
      if (confirm != true) return;
      await loadingWithSuccessOrErrorWidget.startAnimation();
      final finished = await _visitService.recallMoneyVisitsByUserId(recallMoneyViewController.id, value);
      if (!finished) throw Exception();
      await loadingWithSuccessOrErrorWidget.stopAnimation();
      await showDialog(
          context: Get.context!, builder: (context) => InformationPopup(warningMessage: "Dinheiro recolhido com sucesso"));
    } catch (_) {
      await loadingWithSuccessOrErrorWidget.stopAnimation(fail: true);
      await showDialog(
          context: Get.context!,
          builder: (context) => InformationPopup(warningMessage: "Não foi possível recolher o dinheiro"));
    } finally {
      if (confirm == true) await _getTreasuryUsersWithMoneyPouchLaunched();
    }
  }
}
