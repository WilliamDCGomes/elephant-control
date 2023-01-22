import 'dart:convert';
import 'dart:io';
import 'package:easy_image_viewer/easy_image_viewer.dart';
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
import 'package:image_picker/image_picker.dart';
import '../../../../../../base/models/machine/machine.dart';
import '../../../../../../base/models/media/media.dart';
import '../../../../../../base/services/incident_service.dart';
import '../../../../../../base/services/machine_service.dart';
import '../../../../../../base/viewControllers/visit_viewcontroller.dart';
import '../../../../../utils/date_format_to_brazil.dart';
import '../../../../../utils/files_helper.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../operatorPages/mainMenuOperator/controller/main_menu_operator_controller.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/popups/images_picture_widget.dart';
import '../../../widgetsShared/popups/information_popup.dart';

class VisitDetailsController extends GetxController {
  final String visitId;
  late String maintenanceDate;
  late RxInt priorityColor;
  late RxBool yes;
  late RxBool no;
  late TextEditingController operatorName;
  late TextEditingController clock1;
  late TextEditingController clock2;
  late TextEditingController observations;
  late TextEditingController teddyAddMachine;
  late ImagesPictureWidget imageClock;
  late ImagesPictureWidget beforeMaintenanceImageClock;
  late ImagesPictureWidget afterMaintenanceImageClock;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late VisitViewController? visitViewController;
  late final MachineService _machineService;
  late final VisitService _visitService;
  late final VisitMediaService _visitMediaService;
  late final IncidentService _incidentService;
  late final Visit _visit;
  late final Machine _machine;
  late final List<IncidentObject> _incidents;

  VisitDetailsController(this.visitId) {
    _initializeVariables();
  }

  @override
  void onInit() async {
    await Future.delayed(Duration(milliseconds: 200));
    await loadingWithSuccessOrErrorWidget.startAnimation();
    await _getVisitInformation();
    super.onInit();
  }

  _initializeVariables() {
    maintenanceDate = "";
    _incidents = <IncidentObject>[];
    visitViewController = null;
    _visitService = VisitService();
    _machineService = MachineService();
    _visitMediaService = VisitMediaService();
    _incidentService = IncidentService();
    _visit = Visit.emptyConstructor();
    _machine = Machine.emptyConstructor();
    priorityColor = AppColors.redColor.value.obs;

    yes = false.obs;
    no = false.obs;

    operatorName = TextEditingController();
    clock1 = TextEditingController();
    clock2 = TextEditingController();
    observations = TextEditingController();
    teddyAddMachine = TextEditingController();

    operatorName.text = LoggedUser.name;

    imageClock = ImagesPictureWidget(origin: imageOrigin.camera);
    beforeMaintenanceImageClock = ImagesPictureWidget(origin: imageOrigin.camera);
    afterMaintenanceImageClock = ImagesPictureWidget(origin: imageOrigin.camera);

    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
  }

  _getVisitInformation() async {
    try{
      visitViewController = await _visitService.getResumeVisitById(visitId);
      if(visitViewController == null){
        throw Exception();
      }
      maintenanceDate = DateFormatToBrazil.formatDateWithHour(visitViewController!.inclusion);
      clock1.text = visitViewController!.firstClock.ceil().toString();
      clock2.text = (visitViewController!.secondClock ?? 0).toString();
      teddyAddMachine.text = visitViewController!.replacedPlush.toString();
      observations.text = visitViewController!.observation ?? "";
      yes.value = visitViewController!.collectedDrawal;
      no.value = !visitViewController!.collectedDrawal;

      bool after = true;
      for(var media in visitViewController!.mediasList){
        switch(media.visitType){
          case MediaType.moneyWatch:
            imageClock.picture = await FilesHelper.createXFileFromBase64(
              media.image,
            );
            break;
          case MediaType.machineBefore:
            if(after){
              after = false;
              beforeMaintenanceImageClock.picture = await FilesHelper.createXFileFromBase64(
                media.image,
              );
            }
            else{
              afterMaintenanceImageClock.picture = await FilesHelper.createXFileFromBase64(
                media.image,
              );
            }
            break;
          case MediaType.machineAfter:
            afterMaintenanceImageClock.picture = await FilesHelper.createXFileFromBase64(
              media.image,
            );
            break;
          case MediaType.stuffedAnimals:
            break;
        }
      }
      update(["visit-details"]);
      imageClock.imagesPictureWidgetState.refreshPage();
      beforeMaintenanceImageClock.imagesPictureWidgetState.refreshPage();
      afterMaintenanceImageClock.imagesPictureWidgetState.refreshPage();
      await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
    }
    catch(e){
      await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
      await showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Erro ao carregar visita. Tente novamente mais tarde.",
          );
        },
      );
      Get.back();
      Get.back();
    }
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

  openImage(XFile? xfile){
    if(xfile != null){
      showImageViewer(
        Get.context!,
        Image.memory(
          File(xfile.path).readAsBytesSync(),
        ).image,
      );
    }
    else{
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Não é possível abrir a imagem.",
          );
        },
      );
    }
  }
}