import 'package:elephant_control/app/views/pages/widgetsShared/popups/information_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../base/services/stokist_plush_service.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';

class AddPlushInStockController extends GetxController {
  late TextEditingController plushQuantity;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late StokistPlushService _stokistPlushService;

  AddPlushInStockController() {
    _initializeVariables();
  }

  _initializeVariables() {
    plushQuantity = TextEditingController();
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
    _stokistPlushService = StokistPlushService();
  }

  Future<void> addOrRemoveBalanceStuffedAnimalsOperator() async {
    try {
      if (plushQuantity.text == "0") {
        return showDialog(
          context: Get.context!,
          builder: (context) => InformationPopup(
            warningMessage: "Informe uma quantidade válida!",
          ),
        );
      }
      await loadingWithSuccessOrErrorWidget.startAnimation();
      final addStuffedAnimals = await _stokistPlushService.insertOrRemovePlushies(
        int.parse(plushQuantity.text),
      );

      if (!addStuffedAnimals) throw Exception();

      await loadingWithSuccessOrErrorWidget.stopAnimation();
      await showDialog(
        context: Get.context!,
        builder: (context) => InformationPopup(
          warningMessage: "Pelúcias adicionadas com sucesso",
        ),
      );

      return Get.back();
    } catch (_) {
      await loadingWithSuccessOrErrorWidget.stopAnimation(fail: true);
      return showDialog(
        context: Get.context!,
        builder: (context) => InformationPopup(
          warningMessage: "Não foi possível adicionar o saldo de pelúcias ao estoque",
        ),
      );
    }
  }
}