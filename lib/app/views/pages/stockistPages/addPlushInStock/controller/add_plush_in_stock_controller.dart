import 'package:elephant_control/app/views/pages/widgetsShared/popups/information_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../base/services/stokist_plush_service.dart';
import '../../../../../utils/format_numbers.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';

class AddPlushInStockController extends GetxController {
  final bool removePlush;
  late TextEditingController plushQuantity;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late StokistPlushService _stokistPlushService;

  AddPlushInStockController(this.removePlush) {
    _initializeVariables();
  }

  _initializeVariables() {
    plushQuantity = TextEditingController();
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
    _stokistPlushService = StokistPlushService();
  }

  addOrRemoveBalanceStuffedAnimalsOperator() async {
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
      if(removePlush){
        var stock = await _stokistPlushService.getPlushies();
        if(stock != null && stock.balanceStuffedAnimals < int.parse(plushQuantity.text)){
          loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
          return showDialog(
            context: Get.context!,
            builder: (context) => InformationPopup(
              warningMessage: "Não é possível remover mais do que existe no estoque!\nSaldo atual do estoque: " +
                  FormatNumbers.scoreIntNumber(stock.balanceStuffedAnimals),
            ),
          );
        }
      }

      final addStuffedAnimals = await _stokistPlushService.insertOrRemovePlushies(
        removePlush ? -1 * int.parse(plushQuantity.text) : int.parse(plushQuantity.text),
      );

      if (!addStuffedAnimals) throw Exception();

      await loadingWithSuccessOrErrorWidget.stopAnimation();
      await showDialog(
        context: Get.context!,
        builder: (context) => InformationPopup(
          warningMessage: "Pelúcias " + (removePlush ? "removidas " : "adicionadas ") + "com sucesso",
        ),
      );

      return Get.back();
    } catch (_) {
      await loadingWithSuccessOrErrorWidget.stopAnimation(fail: true);
      return showDialog(
        context: Get.context!,
        builder: (context) => InformationPopup(
          warningMessage: "Não foi possível " + (removePlush ? "remover " : "adicionar ") + " o saldo de pelúcias ao estoque",
        ),
      );
    }
  }
}