import 'dart:convert';
import 'package:elephant_control/app/enums/enums.dart';
import 'package:elephant_control/app/utils/logged_user.dart';
import 'package:elephant_control/app/utils/position_util.dart';
import 'package:elephant_control/app/views/pages/operatorPages/occurrence/controller/occurrence_controller.dart';
import 'package:elephant_control/app/views/pages/operatorPages/occurrence/page/occurrence_page.dart';
import 'package:elephant_control/base/models/visit/visit.dart';
import 'package:elephant_control/base/models/visitMedia/visit_media.dart';
import 'package:elephant_control/base/services/visit_media_service.dart';
import 'package:elephant_control/base/services/visit_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../base/models/machine/machine.dart';
import '../../../../../../base/models/media/media.dart';
import '../../../../../../base/services/incident_service.dart';
import '../../../../../../base/services/machine_service.dart';
import '../../../../../utils/date_format_to_brazil.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../operatorPages/mainMenuOperator/controller/main_menu_operator_controller.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/popups/images_picture_widget.dart';
import '../../../widgetsShared/popups/information_popup.dart';

class VisitDetailsController extends GetxController {
  final String visitId;
  late RxString priority;
  late RxString lastMaintenance;
  late RxInt priorityColor;
  late RxBool yes;
  late RxBool no;
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
  late final MachineService _machineService;
  late final VisitMediaService _visitMediaService;
  late final IncidentService _incidentService;
  late final Visit _visit;
  late final Machine _machine;
  late final List<IncidentObject> _incidents;

  VisitDetailsController(this.visitId) {
    _initializeVariables();
  }

  _initializeVariables() {
    _incidents = <IncidentObject>[];
    _visitService = VisitService();
    _machineService = MachineService();
    _visitMediaService = VisitMediaService();
    _incidentService = IncidentService();
    _visit = Visit.emptyConstructor();
    _machine = Machine.emptyConstructor();
    priority = "ALTA".obs;
    priorityColor = AppColors.redColor.value.obs;
    lastMaintenance = "".obs;

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

  openIncident(BuildContext context) async {
    final incident = await Get.to(() => OccurrencePage(machine: _machine, visitId: visitId));
    if (incident is IncidentObject) _incidents.add(incident);
  }

  editMaintenance() async {
    try {
      if (!fieldsValidate()) return;
      await loadingWithSuccessOrErrorWidget.startAnimation();
      int teddy = clock2.text == "" ? 0 : int.parse(clock2.text);
      _visit.stuffedAnimalsQuantity = teddy;
      _visit.machineId = _machine.id!;
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
      for (var _incident in _incidents) {
        final bool createdIncident = await _incidentService.createIncident(_incident.incident);
        if (createdIncident) await _incidentService.createIncidentMedia(_incident.medias);
      }
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
      await Future.microtask(() => Get.find<MainMenuOperatorController>(tag: "main-menu-operator-controller").getOperatorInformation());
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