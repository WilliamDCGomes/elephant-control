import 'dart:convert';
import 'package:elephant_control/app/enums/enums.dart';
import 'package:elephant_control/app/utils/logged_user.dart';
import 'package:elephant_control/app/utils/position_util.dart';
import 'package:elephant_control/app/views/pages/operatorPages/occurrence/controller/occurrence_controller.dart';
import 'package:elephant_control/app/views/pages/operatorPages/occurrence/page/occurrence_page.dart';
import 'package:elephant_control/base/models/visit/visit.dart';
import 'package:elephant_control/base/models/visitMedia/visit_media.dart';
import 'package:elephant_control/base/services/user_visit_machine_service.dart';
import 'package:elephant_control/base/services/visit_media_service.dart';
import 'package:elephant_control/base/services/visit_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uuid/uuid.dart';
import '../../../../../../base/models/machine/machine.dart';
import '../../../../../../base/models/media/media.dart';
import '../../../../../../base/services/incident_service.dart';
import '../../../../../utils/date_format_to_brazil.dart';
import '../../../../../utils/valid_average.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/popups/images_picture_widget.dart';
import '../../../widgetsShared/popups/information_popup.dart';
import '../../../widgetsShared/text_widget.dart';
import '../../mainMenuOperator/controller/main_menu_operator_controller.dart';

class MaintenanceController extends GetxController {
  Machine? machineSelected;
  late RxString priority;
  late RxString machineSelectedListener;
  late RxString lastMaintenance;
  late RxInt priorityColor;
  late RxBool yes;
  late RxBool no;
  late RxBool _showReminders;
  late TextEditingController operatorName;
  late TextEditingController maintenanceDate;
  late TextEditingController clock1;
  late TextEditingController clock2;
  late TextEditingController observations;
  late TextEditingController teddyAddMachine;
  late ImagesPictureWidget imageClock;
  late ImagesPictureWidget beforeMaintenanceImageClock;
  late ImagesPictureWidget afterMaintenanceImageClock;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late final VisitService _visitService;
  late final VisitMediaService _visitMediaService;
  late final IncidentService _incidentService;
  late final RxList<Machine> _machines;
  late final Visit _visit;
  late final String visitId;
  late final List<IncidentObject> _incidents;

  MaintenanceController() {
    _initializeVariables();
  }

  _initializeVariables() {
    visitId = const Uuid().v4();
    _showReminders = false.obs;
    _incidents = <IncidentObject>[];
    _visitService = VisitService();
    _visitMediaService = VisitMediaService();
    _machines = <Machine>[].obs;
    _incidentService = IncidentService();
    machineSelectedListener = "".obs;
    priority = "ALTA".obs;
    priorityColor = AppColors.redColor.value.obs;
    lastMaintenance = "".obs;
    _visit = Visit.emptyConstructor();

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
    _initializeMethods();
  }

  //Getters
  List<Machine> get machines => _machines;
  bool get showReminders => _showReminders.value;

  onDropdownButtonWidgetChanged(String? machineId) {
    machineSelected = _machines.firstWhere((element) => element.id == machineId);
    machineSelectedListener.value = machineSelected?.name ?? "";
    lastMaintenance.value = DateFormatToBrazil.formatDate(machineSelected?.lastVisit);
  }

  Future<void> _initializeMethods() async {
    try {
      await getMachines();
    } catch (_) {
    }
  }

  Future<void> getMachines() async {
    try {
      _machines.clear();
      final listTodayMachine = await UserVisitMachineService().getUserVisitMachineByUserIdAndVisitDay(DateTime.now());
      _machines.addAll(listTodayMachine
          .map((e) => Machine(name: e.machineName, id: e.machineId, lastVisit: e.lastVisit, reminders: e.reminders)));
      if (_machines.isNotEmpty) {
        _machines.sort((a, b) => a.name.trim().toLowerCase().compareTo(b.name.trim().toLowerCase()));
        onDropdownButtonWidgetChanged(_machines.first.id);
        update(["dropdown-button"]);
      }
    } catch (_) {
      _machines.clear();
    }
  }

  void setShowReminders() => _showReminders.value = !_showReminders.value;

  openIncident(BuildContext context) async {
    if (machineSelected == null) {
      return await showDialog(
          context: context,
          builder: ((context) => InformationPopup(warningMessage: "Selecione uma máquina para criar uma ocorrência")));
    }
    final incident = await Get.to(() => OccurrencePage(machine: machineSelected!, visitId: visitId));
    if (incident is IncidentObject) _incidents.add(incident);
  }

  saveMaintenance() async {
    try {
      if (!fieldsValidate()) return;
      await loadingWithSuccessOrErrorWidget.startAnimation();
      int teddy = clock2.text == "" ? 0 : int.parse(clock2.text);
      _visit.stuffedAnimalsQuantity = teddy;
      _visit.machineId = machineSelected!.id!;
      _visit.moneyQuantity = double.parse(clock1.text);
      _visit.moneyWithDrawal = yes.isTrue;
      if (_visit.moneyWithDrawal) _visit.moneyWithdrawalQuantity = double.parse(clock2.text);
      _visit.status = _visit.moneyWithDrawal ? VisitStatus.moneyWithdrawal : VisitStatus.realized;
      _visit.stuffedAnimalsReplaceQuantity = int.parse(teddyAddMachine.text);
      _visit.observation = observations.text;
      _visit.id = visitId;
      final position = await PositionUtil.determinePosition();
      _visit.latitude = position?.latitude == null ? null : position?.latitude.toString();
      _visit.longitude = position?.longitude == null ? null : position?.longitude.toString();

      double averageValue = 0;
      if(clock1.text != "" && clock2.text != "" && int.parse(clock2.text) != 0){
        averageValue = int.parse(clock1.text) / int.parse(clock2.text);
      }

      bool showAveragePopup = await ValidAverage().valid(_visit.machineId, clock1.text, clock2.text);

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
            type: MediaType.machineBefore,
            extension: MediaExtension.jpeg,
          ));
        final bytesAfterImage = await afterMaintenanceImageClock.picture?.readAsBytes();
        if (bytesAfterImage != null)
          medias.add(VisitMedia(
            visitId: _visit.id!,
            base64: base64Encode(bytesAfterImage),
            type: MediaType.machineAfter,
            extension: MediaExtension.jpeg,
          ));

        if (medias.isNotEmpty) createdVisit = await _visitMediaService.createVisitMedia(medias);
      }
      if (!createdVisit) throw Exception();
      for (var _incident in _incidents) {
        final bool createdIncident = await _incidentService.createIncident(_incident.incident);
        if (createdIncident) await _incidentService.createIncidentMedia(_incident.medias);
      }
      await loadingWithSuccessOrErrorWidget.stopAnimation();

      if(showAveragePopup){
        await showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return InformationPopup(
              warningMessage: "A média dessa máquina está fora do programado!\nMédia: ${averageValue
                  .toStringAsFixed(2).replaceAll('.', ',')}",
              fontSize: 18.sp,
              popupColor: AppColors.redColor,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning,
                    color: AppColors.yellowDarkColor,
                    size: 4.h,
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  TextWidget(
                    "AVISO",
                    textColor: AppColors.whiteColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Icon(
                    Icons.warning,
                    color: AppColors.yellowDarkColor,
                    size: 4.h,
                  ),
                ],
              ),
            );
          },
        );
      }

      await showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Atendimento salvo com sucesso!",
          );
        },
      );
      await Future.microtask(
          () => Get.find<MainMenuOperatorController>(tag: "main-menu-operator-controller").getOperatorInformation());
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
    if (!kDebugMode && (beforeMaintenanceImageClock.picture == null || beforeMaintenanceImageClock.picture!.path.isEmpty)) {
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
    if (!kDebugMode && (imageClock.picture == null || imageClock.picture!.path.isEmpty)) {
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
    if (!kDebugMode && (afterMaintenanceImageClock.picture == null || afterMaintenanceImageClock.picture!.path.isEmpty)) {
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