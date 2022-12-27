import 'dart:convert';
import 'package:elephant_control/app/utils/logged_user.dart';
import 'package:elephant_control/base/models/visit/model/visit.dart';
import 'package:elephant_control/base/models/visitMedia/model/visit_media.dart';
import 'package:elephant_control/base/services/visit_media_service.dart';
import 'package:elephant_control/base/services/visit_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../base/models/machine/model/machine.dart';
import '../../../../../../base/models/media/model/media.dart';
import '../../../../../../base/services/machine_service.dart';
import '../../../../../utils/date_format_to_brazil.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/popups/images_picture_widget.dart';
import '../../../widgetsShared/popups/information_popup.dart';
import '../../mainMenuOperator/controller/main_menu_operator_controller.dart';

class MaintenanceController extends GetxController {
  Machine? machineSelected;
  late RxString priority;
  late RxString requestTitle;
  late RxString lastMaintenance;
  late RxInt priorityColor;
  late RxBool yes;
  late RxBool no;
  late RxBool loadingAnimation;
  late TextEditingController operatorName;
  late TextEditingController maintenanceDate;
  late TextEditingController clock1;
  late TextEditingController clock2;
  late TextEditingController observations;
  late TextEditingController teddyAddMachine;
  late ImagesPictureWidget imageClock;
  late ImagesPictureWidget beforeMaintenanceImageClock;
  late ImagesPictureWidget afterMaintenanceImageClock;
  late MainMenuOperatorController _mainMenuOperatorController;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late final MachineService _machineService;
  late final VisitService _visitService;
  late final VisitMediaService _visitMediaService;
  late final RxList<Machine> _machines;
  late final Visit _visit;

  MaintenanceController() {
    _initializeVariables();
  }

  _initializeVariables() {
    _machineService = MachineService();
    _visitService = VisitService();
    _visitMediaService = VisitMediaService();
    _machines = <Machine>[].obs;
    // machineSelected = machinesPlaces[0].obs;
    requestTitle = "".obs;
    priority = "ALTA".obs;
    priorityColor = AppColors.redColor.value.obs;
    lastMaintenance = DateFormatToBrazil.formatDate(DateTime.now().add(Duration(days: -5))).obs;
    _visit = Visit.emptyConstructor();
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
    loadingAnimation = false.obs;

    operatorName = TextEditingController();
    maintenanceDate = TextEditingController();
    clock1 = TextEditingController();
    clock2 = TextEditingController();
    observations = TextEditingController();
    teddyAddMachine = TextEditingController();

    operatorName.text = LoggedUser.name;
    maintenanceDate.text = DateFormatToBrazil.formatDate(DateTime.now());

    imageClock = ImagesPictureWidget();
    beforeMaintenanceImageClock = ImagesPictureWidget();
    afterMaintenanceImageClock = ImagesPictureWidget();

    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget(
      loadingAnimation: loadingAnimation,
    );
    _initializeMethods();
  }

  //Getters
  List<Machine> get machines => _machines;

  onDropdownButtonWidgetChanged(String? machineId) {
    machineSelected = _machines.firstWhere((element) => element.id == machineId);
    requestTitle.value = machineSelected?.name ?? "";
  }

  Future<void> _initializeMethods() async {
    try {
      // await loadingWithSuccessOrErrorWidget.startAnimation();
      await getMachines();
    } catch (_) {
      print(_);
    } finally {
      // await loadingWithSuccessOrErrorWidget.stopAnimation();
    }
  }

  Future<void> getMachines() async {
    try {
      // await loadingWithSuccessOrErrorWidget.startAnimation();
      _machines.clear();
      _machines.addAll(await _machineService.getMachinesByUserId());
      if (_machines.isNotEmpty) {
        _machines.sort((a, b) => a.name.compareTo(b.name));
        onDropdownButtonWidgetChanged(_machines.first.id);
        update(["dropdown-button"]);
      }
    } catch (_) {
      _machines.clear();
    }
  }

  saveMaintenance() async {
    try {
      if (!fieldsValidate()) return;
      loadingAnimation.value = true;
      await loadingWithSuccessOrErrorWidget.startAnimation();
      await Future.delayed(Duration(seconds: 2));
      _mainMenuOperatorController = Get.find(tag: "main_menu_controller");
      int teddy = clock2.text == "" ? 0 : int.parse(teddyAddMachine.text);
      if (yes.value) {
        _mainMenuOperatorController.amountPouch.value++;
        LoggedUser.amountPouch++;
      }
      _mainMenuOperatorController.amountTeddy.value -= teddy;
      LoggedUser.amountTeddy -= teddy;

      // double averageValue = int.parse(clock1.text) / int.parse(clock2.text);
      // if (averageValue < 25 || averageValue > 40) {
      //   return await showDialog(
      //     context: Get.context!,
      //     barrierDismissible: false,
      //     builder: (BuildContext context) {
      //       return InformationPopup(
      //         warningMessage: "A média dessa máquina está fora do programado!\nMédia: ${averageValue.toStringAsFixed(2).replaceAll('.', ',')}",
      //         fontSize: 18.sp,
      //         popupColor: AppColors.redColor,
      //         title: Row(
      //           mainAxisSize: MainAxisSize.min,
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             Icon(
      //               Icons.warning,
      //               color: AppColors.yellowDarkColor,
      //               size: 4.h,
      //             ),
      //             SizedBox(
      //               width: 2.w,
      //             ),
      //             TextWidget(
      //               "AVISO",
      //               textColor: AppColors.whiteColor,
      //               fontSize: 18.sp,
      //               fontWeight: FontWeight.bold,
      //             ),
      //             SizedBox(
      //               width: 2.w,
      //             ),
      //             Icon(
      //               Icons.warning,
      //               color: AppColors.yellowDarkColor,
      //               size: 4.h,
      //             ),
      //           ],
      //         ),
      //       );
      //     },
      //   );
      // }
      _visit.addedProducts = teddy;
      _visit.machineId = machineSelected!.id!;
      _visit.moneyQuantity = double.parse(clock1.text);
      _visit.moneyWithDrawal = yes.isTrue;
      if (_visit.moneyWithDrawal) _visit.moneyWithdrawalQuantity = double.parse(clock2.text);
      _visit.status = _visit.moneyWithDrawal ? VisitStatus.moneyWithdrawal : VisitStatus.realized;
      _visit.stuffedAnimalsQuantity = 0;
      _visit.observation = observations.text;
      bool createdVisit = await _visitService.createVisit(_visit);
      if (createdVisit) {
        List<VisitMedia> medias = [];
        final bytesClockImage = await imageClock.picture?.readAsBytes();
        if (bytesClockImage != null)
          medias.add(VisitMedia(
            visitId: _visit.id!,
            base64: base64Encode(bytesClockImage),
            type: MediaType.moneyWatch,
            extension: MediaExtension.jpeg,
          ));
        final bytesBeforeImage = await beforeMaintenanceImageClock.picture?.readAsBytes();
        if (bytesBeforeImage != null)
          medias.add(VisitMedia(
            visitId: _visit.id!,
            base64: base64Encode(bytesBeforeImage),
            type: MediaType.machine,
            extension: MediaExtension.jpeg,
          ));
        final bytesAfterImage = await afterMaintenanceImageClock.picture?.readAsBytes();
        if (bytesAfterImage != null)
          medias.add(VisitMedia(
            visitId: _visit.id!,
            base64: base64Encode(bytesAfterImage),
            type: MediaType.machine,
            extension: MediaExtension.jpeg,
          ));

        if (medias.isNotEmpty) createdVisit = await _visitMediaService.createVisitMedia(medias);
      }
      if (!createdVisit) throw Exception();
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
    if (machineSelected == null) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Selecione a Máquina da Visita!",
          );
        },
      );
      return false;
    }
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
