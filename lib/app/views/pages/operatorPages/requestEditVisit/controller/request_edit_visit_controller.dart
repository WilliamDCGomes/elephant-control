import 'package:elephant_control/app/enums/enums.dart';
import 'package:elephant_control/app/utils/logged_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../base/models/visit/visit.dart';
import '../../../../../utils/date_format_to_brazil.dart';
import '../../../../../utils/valid_average.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/popups/images_picture_widget.dart';
import '../../../widgetsShared/popups/information_popup.dart';
import '../../mainMenuOperator/controller/main_menu_operator_controller.dart';

class RequestEditVisitController extends GetxController {
  late Visit visit;
  late RxString machineSelected;
  late RxString priority;
  late RxString requestTitle;
  late RxString lastMaintenance;
  late RxInt priorityColor;
  late RxBool yes;
  late RxBool no;
  late RxList<String> machinesPlaces;
  late TextEditingController operatorName;
  late TextEditingController maintenanceDate;
  late TextEditingController clock1;
  late TextEditingController clock2;
  late TextEditingController observations;
  late TextEditingController teddyAddMachine;
  late ImagesPictureWidget imageClock;
  late ImagesPictureWidget beforeMaintenanceImageClock;
  late ImagesPictureWidget afterMaintenanceImageClock;
  late MainMenuOperatorController _mainMenuController;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;

  RequestEditVisitController(this.visit) {
    _inicializeList();
    _initializeVariables();
  }

  _initializeVariables() {
    machineSelected = machinesPlaces[0].obs;
    requestTitle = machinesPlaces[0].obs;
    priority = "ALTA".obs;
    priorityColor = AppColors.redColor.value.obs;
    lastMaintenance = DateFormatToBrazil.formatDate(DateTime.now().add(Duration(days: -5))).obs;
    requestTitle.listen((value) {
      switch (value) {
        case "Shopping Boulevard":
          priority.value = "ALTA";
          priorityColor.value = AppColors.redColor.value;
          lastMaintenance.value = DateFormatToBrazil.formatDate(DateTime.now().add(Duration(days: -5)));
          break;
        case "Supermercado Central":
          priority.value = "NORMAL";
          priorityColor.value = AppColors.greenColor.value;
          lastMaintenance.value = DateFormatToBrazil.formatDate(DateTime.now().add(Duration(days: -3)));
          break;
        case "Cinema Alameda":
          priority.value = "NORMAL";
          priorityColor.value = AppColors.greenColor.value;
          lastMaintenance.value = DateFormatToBrazil.formatDate(DateTime.now().add(Duration(days: -1)));
          break;
      }
    });

    yes = false.obs;
    no = false.obs;

    operatorName = TextEditingController();
    maintenanceDate = TextEditingController();
    clock1 = TextEditingController();
    clock2 = TextEditingController();
    observations = TextEditingController();
    teddyAddMachine = TextEditingController();

    operatorName.text = LoggedUser.name;
    maintenanceDate.text = DateFormatToBrazil.formatDate(DateTime.now());

    imageClock = ImagesPictureWidget(origin: imageOrigin.camera);
    beforeMaintenanceImageClock = ImagesPictureWidget(origin: imageOrigin.camera);
    afterMaintenanceImageClock = ImagesPictureWidget(origin: imageOrigin.camera);

    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
  }

  _inicializeList() {
    machinesPlaces = [
      "Shopping Boulevard",
      "Supermercado Central",
      "Cinema Alameda",
    ].obs;
  }

  onDropdownButtonWidgetChanged(String? selectedState) {
    machineSelected.value = selectedState ?? "";
    if (selectedState != null) {
      requestTitle.value = selectedState;
    }
  }

  saveMaintenance() async {
    try {
      if (!fieldsValidate()) return;
      await loadingWithSuccessOrErrorWidget.startAnimation();
      await Future.delayed(Duration(seconds: 2));
      _mainMenuController = Get.find(tag: "main-menu-operator-controller");
      int teddy = clock2.text == "" ? 0 : int.parse(teddyAddMachine.text);
      if (yes.value) {
        _mainMenuController.amountPouch.value++;
        LoggedUser.balanceMoney = _mainMenuController.amountPouch.value;
      }
      _mainMenuController.amountTeddy.value -= teddy;
      LoggedUser.balanceStuffedAnimals = _mainMenuController.amountTeddy.value;

      bool showAveragePopup = await ValidAverage().valid(visit.machineId, clock1.text, clock2.text);

      await loadingWithSuccessOrErrorWidget.stopAnimation();
      await showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Solicitação de alteração no atendimento realizado com sucesso!",
          );
        },
      );
      Get.back();
    } catch (_) {
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

  bool fieldsValidate() {
    if (beforeMaintenanceImageClock.picture == null || beforeMaintenanceImageClock.picture!.path.isEmpty) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Tire a foto da máquina pré atendimento",
          );
        },
      );
      return false;
    }
    if (imageClock.picture == null || imageClock.picture!.path.isEmpty) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Tire a foto dos relógios",
          );
        },
      );
      return false;
    }
    if (clock1.text.isEmpty) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Informe o valor do primeiro relógio!",
          );
        },
      );
      return false;
    }
    if (clock2.text.isEmpty) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Informe o valor do segundo relógio!",
          );
        },
      );
      return false;
    }
    if (teddyAddMachine.text.isEmpty) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Informe a quantidade de pelúcias recolocadas na máquina!",
          );
        },
      );
      return false;
    }
    if (!yes.value && !no.value) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Informe se o malote foi retirado da máquina!",
          );
        },
      );
      return false;
    }
    if (afterMaintenanceImageClock.picture == null || afterMaintenanceImageClock.picture!.path.isEmpty) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Tire a foto da máquina pós atendimento",
          );
        },
      );
      return false;
    }
    return true;
  }
}
