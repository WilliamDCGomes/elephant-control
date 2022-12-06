import 'package:elephant_control/app/utils/logged_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/date_format_to_brazil.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/popups/images_picture_widget.dart';
import '../../../widgetsShared/popups/information_popup.dart';
import '../../mainMenu/controller/main_menu_controller.dart';

class MaintenanceController extends GetxController {
  late RxString machineSelected;
  late RxString requestTitle;
  late RxBool yes;
  late RxBool no;
  late RxBool loadingAnimation;
  late RxList<String> machinesPlaces;
  late TextEditingController operatorName;
  late TextEditingController maintenanceDate;
  late TextEditingController clock1;
  late TextEditingController clock2;
  late TextEditingController observations;
  late ImagesPictureWidget firstImageClock;
  late ImagesPictureWidget secondImageClock;
  late ImagesPictureWidget beforeMaintenanceImageClock;
  late ImagesPictureWidget afterMaintenanceImageClock;
  late MainMenuController _mainMenuController;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;

  MaintenanceController(){
    _inicializeList();
    _initializeVariables();
  }

  _initializeVariables(){
    machineSelected = machinesPlaces[0].obs;
    requestTitle = machinesPlaces[0].obs;

    yes = false.obs;
    no = true.obs;
    loadingAnimation = false.obs;

    operatorName = TextEditingController();
    maintenanceDate = TextEditingController();
    clock1 = TextEditingController();
    clock2 = TextEditingController();
    observations = TextEditingController();

    operatorName.text = LoggedUser.name;
    maintenanceDate.text = DateFormatToBrazil.formatDate(DateTime.now());

    firstImageClock = ImagesPictureWidget();
    secondImageClock = ImagesPictureWidget();
    beforeMaintenanceImageClock = ImagesPictureWidget();
    afterMaintenanceImageClock = ImagesPictureWidget();

    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget(
      loadingAnimation: loadingAnimation,
    );
  }

  _inicializeList(){
    machinesPlaces = [
      "Shopping Boulevard",
      "Supermercado Central",
      "Cinema Alameda",
    ].obs;
  }

  onDropdownButtonWidgetChanged(String? selectedState){
    machineSelected.value = selectedState ?? "";
    if(selectedState != null){
      requestTitle.value = selectedState;
    }
  }

  saveMaintenance() async {
    try{
      loadingAnimation.value = true;
      await loadingWithSuccessOrErrorWidget.startAnimation();
      await Future.delayed(Duration(seconds: 2));
      _mainMenuController = Get.find(tag: "main_menu_controller");
      int teddy = clock2.text == "" ? 0 : int.parse(clock2.text);
      if(yes.value)
        _mainMenuController.amountPouch.value++;
      _mainMenuController.amountTeddy.value -= teddy;

      await loadingWithSuccessOrErrorWidget.stopAnimation();
      await showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Atendimento salvo com sucesso!",
          );
        },
      );
      Get.back();
    }
    catch(_){
      await loadingWithSuccessOrErrorWidget.stopAnimation(fail: true);
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Erro ao salvar o atendimento!",
          );
        },
      );
    }
  }
}