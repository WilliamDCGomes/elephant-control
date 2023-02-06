import 'package:elephant_control/app/utils/logged_user.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/popups/information_popup.dart';
import 'package:elephant_control/base/services/interfaces/iuser_service.dart';
import 'package:elephant_control/base/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../base/models/user/user.dart';
import '../../../../../../base/services/stokist_plush_service.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';

class AddRemoveOperatorBalancePlushController extends GetxController {
  late RxList<User> operators;
  late TextEditingController plushQuantity;
  late TextEditingController observations;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late User? operatorSelected;
  late final IUserService userService;
  late StokistPlushService _stokistPlushService;
  final bool addPluch;

  AddRemoveOperatorBalancePlushController(this.addPluch) {
    _initializeVariables();
    _inicializeList();
  }

  @override
  void onInit() async {
    await getUserByType();
    super.onInit();
  }

  _initializeVariables() {
    _stokistPlushService = StokistPlushService();
    userService = UserService();
    operatorSelected = null;
    plushQuantity = TextEditingController();
    observations = TextEditingController();
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
  }

  _inicializeList() {
    operators = <User>[].obs;
  }

  Future<void> getUserByType() async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      await loadingWithSuccessOrErrorWidget.startAnimation();
      operators.addAll(await userService.getAllUserByType(UserType.operator));
      if (!addPluch) {
        operators.removeWhere((element) => (element.balanceStuffedAnimals ?? 0) <= 0);
      }
    } catch (_) {
      operators.clear();
    } finally {
      operators.refresh();
      await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
    }
  }

  void onDropdownButtonWidgetChanged(String? selectedState) async {
    try {
      operatorSelected = operators.firstWhereOrNull((element) => element.id == selectedState);
      // if (operatorSelected != null) {
      //   await loadingWithSuccessOrErrorWidget.startAnimation();
      //   await Future.delayed(Duration(seconds: 2));
      //   await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
      // }
    } catch (_) {
      // await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
      operatorSelected = null;
    }
  }

  Future<void> addOrRemoveBalanceStuffedAnimalsOperator() async {
    try {
      if (operatorSelected == null) {
        return showDialog(
          context: Get.context!,
          builder: (context) => InformationPopup(
            warningMessage: "Selecione um usuário operador",
          ),
        );
      }
      await loadingWithSuccessOrErrorWidget.startAnimation();
      if(!addPluch){
        var operator = await userService.getUserById(operatorSelected!.id!);
        if(operator != null && operator.balanceStuffedAnimals != null && operator.balanceStuffedAnimals! < int.parse(plushQuantity.text)){
          loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
          return showDialog(
            context: Get.context!,
            builder: (context) => InformationPopup(
              warningMessage: "Saldo do operador é menor do que o você está "
                  "tentando remover!\nSaldo atual do operador: " +
                  operator.balanceStuffedAnimals!.toString(),
            ),
          );
        }
      }

      final addOrRemoveStuffedAnimals = await userService.addOrRemoveBalanceStuffedAnimalsOperator(
        operatorSelected!.id!,
        int.parse(plushQuantity.text),
        observations.text,
        addPluch,
      );

      if(addOrRemoveStuffedAnimals){
        await _stokistPlushService.insertOrRemovePlushies(
          addPluch ? (-1 * int.parse(plushQuantity.text)) : int.parse(plushQuantity.text),
        );
      }

      if (!addOrRemoveStuffedAnimals) throw Exception();

      await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: false);
      await showDialog(
        context: Get.context!,
        builder: (context) =>
          InformationPopup(
            warningMessage: "Pelúcias ${addPluch ? "adicionadas" : "removidas"} com sucesso",
          ),
      );

      await Future.microtask(() async {
        final user = await UserService().getUserInformation();
        LoggedUser.balanceStuffedAnimals = user?.balanceStuffedAnimals;
        LoggedUser.stuffedAnimalsLastUpdate = user?.stuffedAnimalsLastUpdate;
      });
      return Get.back();
    } catch (_) {
      await loadingWithSuccessOrErrorWidget.stopAnimation(fail: true);
      return showDialog(
        context: Get.context!,
        builder: (context) => InformationPopup(
          warningMessage: "Não foi possível ${addPluch ? "adicionar" : "remover"} o saldo de pelúcias do operador",
        ),
      );
    }
  }
}
