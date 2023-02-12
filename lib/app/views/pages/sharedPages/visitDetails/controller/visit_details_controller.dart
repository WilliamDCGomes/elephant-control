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
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../../base/models/machine/machine.dart';
import '../../../../../../base/models/media/media.dart';
import '../../../../../../base/services/incident_service.dart';
import '../../../../../../base/services/machine_service.dart';
import '../../../../../../base/services/user_service.dart';
import '../../../../../../base/viewControllers/visit_viewcontroller.dart';
import '../../../../../utils/date_format_to_brazil.dart';
import '../../../../../utils/files_helper.dart';
import '../../../../../utils/valid_average.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../operatorPages/mainMenuOperator/controller/main_menu_operator_controller.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/popups/confirmation_popup.dart';
import '../../../widgetsShared/popups/images_picture_widget.dart';
import '../../../widgetsShared/popups/information_popup.dart';
import '../../../widgetsShared/text_widget.dart';

class VisitDetailsController extends GetxController {
  late int plushQuantity;
  final bool editPictures;
  final String visitId;
  late String maintenanceDate;
  late RxInt priorityColor;
  late RxBool yes;
  late RxBool no;
  late RxBool machineCloseYes;
  late RxBool machineCloseNo;
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
  late final VisitService _visitService;
  late final UserService _userService;
  late final MachineService _machineService;
  late final VisitMediaService _visitMediaService;
  late final IncidentService _incidentService;
  late final Visit _visit;
  late Machine _machine;
  late IncidentObject? incident;

  VisitDetailsController(this.visitId, this.editPictures) {
    _initializeVariables();
  }

  @override
  void onInit() async {
    await Future.delayed(Duration(milliseconds: 200));
    await loadingWithSuccessOrErrorWidget.startAnimation();
    await _getVisitInformation();
    await _getIncidentInformation();
    await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
    super.onInit();
  }

  _initializeVariables() {
    plushQuantity = 0;
    maintenanceDate = "";
    incident = null;
    visitViewController = null;
    _visitService = VisitService();
    _userService = UserService();
    _machineService = MachineService();
    _visitMediaService = VisitMediaService();
    _incidentService = IncidentService();
    _visit = Visit.emptyConstructor();
    _machine = Machine.emptyConstructor();
    priorityColor = AppColors.redColor.value.obs;

    yes = false.obs;
    no = false.obs;
    machineCloseYes = false.obs;
    machineCloseNo = false.obs;

    operatorName = TextEditingController();
    clock1 = TextEditingController();
    clock2 = TextEditingController();
    observations = TextEditingController();
    teddyAddMachine = TextEditingController();

    operatorName.text = LoggedUser.name;

    afterMaintenanceImageClock = ImagesPictureWidget(origin: imageOrigin.camera);
    imageClock = ImagesPictureWidget(origin: imageOrigin.camera);
    beforeMaintenanceImageClock = ImagesPictureWidget(origin: imageOrigin.camera);

    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
  }

  _getVisitInformation() async {
    try {
      visitViewController = await _visitService.getResumeVisitById(visitId);
      if (visitViewController == null) {
        throw Exception();
      }

      var machineReturn = await _machineService.getMachineById(visitViewController!.machineId);
      if (machineReturn != null) {
        _machine = machineReturn;
      }

      maintenanceDate = DateFormatToBrazil.formatDateAndHour(visitViewController!.inclusion);
      clock1.text = visitViewController!.firstClock.ceil().toString();
      clock2.text = (visitViewController!.secondClock ?? 0).toString();
      teddyAddMachine.text = visitViewController!.replacedPlush.toString();
      if (teddyAddMachine.text != "") {
        plushQuantity = int.parse(teddyAddMachine.text);
      }
      observations.text = visitViewController!.observation ?? "";
      yes.value = visitViewController!.collectedDrawal;
      no.value = !visitViewController!.collectedDrawal;
      machineCloseYes.value = visitViewController!.visitMonthClosure;
      machineCloseNo.value = !visitViewController!.visitMonthClosure;

      bool after = true;

      for (var media in visitViewController!.mediasList) {
        switch (media.mediaType) {
          case MediaType.moneyWatch:
            imageClock.picture = await FilesHelper.createXFileFromBase64(
              media.image,
            );
            break;
          case MediaType.machineBefore:
            if (after) {
              after = false;
              beforeMaintenanceImageClock.picture = await FilesHelper.createXFileFromBase64(
                media.image,
              );
            } else {
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
          case MediaType.firstOccurrencePicture:
            break;
          case MediaType.secondOccurrencePicture:
            break;
          case MediaType.occurrenceVideo:
            break;
        }
      }
      update(["visit-details"]);

      if (imageClock.picture != null) {
        imageClock.imagesPictureWidgetState.refreshPage();
      }
      if (beforeMaintenanceImageClock.picture != null) {
        beforeMaintenanceImageClock.imagesPictureWidgetState.refreshPage();
      }
    } catch (e) {
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
    }
  }

  _getIncidentInformation() async {
    try {
      var _incident = await _incidentService.getIncidentByVisitId(visitId);
      if (_incident != null && _incident.id != null && _incident.id != "") {
        var _midias = await _incidentService.getIncidentMediaByIncidentId(_incident.id!);
        if (_midias.isNotEmpty) {
          var incidentObject = IncidentObject(
            _incident,
            _midias,
          );
          incident = incidentObject;
          update(["incident"]);
        }
      }
    } catch (e) {
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
    }
  }

  openIncident(BuildContext context) async {
    final newIncident = await Get.to(() => OccurrencePage(
          machine: _machine,
          visitId: visitId,
          incident: incident,
          edit: editPictures,
        ));

    if (newIncident is IncidentObject) incident = newIncident;
  }

  deleteVisit(BuildContext context) async {
    try{
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ConfirmationPopup(
            title: "Aviso",
            subTitle: "Tem certeza que deseja apagar essa visita? Todas as informações e imagens serão excluidas permanentemente.",
            firstButton: () {},
            secondButton: () async => await _executeDeleteVisit(),
          );
        },
      );
    }
    catch(_){
      await showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Erro ao apagar a visita!",
          );
        },
      );
    }
  }

  _executeDeleteVisit() async {
    try{
      await loadingWithSuccessOrErrorWidget.startAnimation();
      await _visitService.deleteVisit(visitId);
      await loadingWithSuccessOrErrorWidget.stopAnimation();
      await showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Visita apagada com sucesso!",
          );
        },
      );
      Get.back();
    }
    catch(_){
      await loadingWithSuccessOrErrorWidget.stopAnimation(fail: true);
      await showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Erro ao apagar a visita!",
          );
        },
      );
    }
  }

  editMaintenance() async {
    try {
      if (!fieldsValidate()) return;
      await loadingWithSuccessOrErrorWidget.startAnimation();

      if (int.parse(clock2.text) > int.parse(clock1.text)) {
        String clock1Aux = clock1.text;
        clock1.text = clock2.text;
        clock2.text = clock1Aux;
      }

      int teddy = clock2.text == "" ? 0 : int.parse(clock2.text);
      _visit.stuffedAnimalsQuantity = teddy;
      _visit.machineId = visitViewController!.machineId;
      _visit.moneyQuantity = double.parse(clock1.text);
      _visit.moneyWithDrawal = yes.isTrue;
      _visit.monthClosure = machineCloseYes.isTrue;
      if (_visit.moneyWithDrawal) _visit.moneyWithdrawalQuantity = double.parse(clock2.text);
      _visit.status = _visit.moneyWithDrawal ? VisitStatus.moneyWithdrawal : VisitStatus.realized;
      _visit.stuffedAnimalsReplaceQuantity = int.parse(teddyAddMachine.text);
      _visit.observation = observations.text;
      _visit.id = visitId;
      final position = await PositionUtil.determinePosition();
      _visit.latitude = position?.latitude == null ? null : position?.latitude.toString();
      _visit.longitude = position?.longitude == null ? null : position?.longitude.toString();

      double averageValue = 0;
      if (clock1.text != "" && clock2.text != "" && int.parse(clock2.text) != 0) {
        averageValue = int.parse(clock1.text) / int.parse(clock2.text);
      }

      bool showAveragePopup = await ValidAverage().valid(_visit.machineId, clock1.text, clock2.text);

      bool updateVisit = await _visitService.updateVisit(_visit);
      if (updateVisit) {
        List<VisitMedia> medias = [];
        final bytesClockImage = await imageClock.picture?.readAsBytes();
        if (bytesClockImage != null)
          medias.add(VisitMedia(
            mediaId: visitViewController!.mediasList.firstWhere((media) => media.mediaType == MediaType.moneyWatch).mediaId,
            visitId: _visit.id!,
            media: base64Encode(bytesClockImage),
            type: MediaType.moneyWatch,
            extension: MediaExtension.jpeg,
          ));
        final bytesBeforeImage = await beforeMaintenanceImageClock.picture?.readAsBytes();
        if (bytesBeforeImage != null)
          medias.add(VisitMedia(
            mediaId:
                visitViewController!.mediasList.firstWhere((media) => media.mediaType == MediaType.machineBefore).mediaId,
            visitId: _visit.id!,
            media: base64Encode(bytesBeforeImage),
            type: MediaType.machineBefore,
            extension: MediaExtension.jpeg,
          ));
        final bytesAfterImage = await afterMaintenanceImageClock.picture?.readAsBytes();
        if (bytesAfterImage != null)
          medias.add(VisitMedia(
            mediaId:
                visitViewController!.mediasList.firstWhere((media) => media.mediaType == MediaType.machineAfter).mediaId,
            visitId: _visit.id!,
            media: base64Encode(bytesAfterImage),
            type: MediaType.machineAfter,
            extension: MediaExtension.jpeg,
          ));

        if (medias.isNotEmpty) updateVisit = await _visitMediaService.updateVisitMedia(medias);
      }
      if (!updateVisit) throw Exception();

      if (incident != null) {
        await _incidentService.updateIncident(incident!.incident);
        if (incident!.medias.isNotEmpty) await _incidentService.updateIncidentMedia(incident!.medias);
      }

      int quantity = plushQuantity - int.parse(teddyAddMachine.text);
      if (quantity < 0) {
        quantity *= -1;
      }

      await _userService.AddOrRemoveBalanceStuffedAnimalsJustOperator(
        LoggedUser.id,
        quantity,
        observations.text,
        plushQuantity - int.parse(teddyAddMachine.text) < 0,
      );

      if (position != null) {
        await _machineService.setMachineLocation(
          visitViewController!.machineId,
          position.latitude,
          position.longitude,
        );
      }

      if (LoggedUser.balanceStuffedAnimals == null) {
        LoggedUser.balanceStuffedAnimals = 0;
      } else {
        LoggedUser.balanceStuffedAnimals = LoggedUser.balanceStuffedAnimals! - int.parse(teddyAddMachine.text);
        if (LoggedUser.balanceStuffedAnimals! < 0) {
          LoggedUser.balanceStuffedAnimals = 0;
        }
      }
      LoggedUser.stuffedAnimalsLastUpdate = DateTime.now();

      await loadingWithSuccessOrErrorWidget.stopAnimation();

      if (showAveragePopup) {
        await showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return InformationPopup(
              warningMessage:
                  "A média dessa máquina está fora do programado!\nMédia: ${averageValue.toStringAsFixed(2).replaceAll('.', ',')}",
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
            warningMessage: "Visita editada com sucesso!",
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
            warningMessage: "Erro ao editar a visita!",
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
    if (!yes.value && !no.value) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Informe se é o fechamento da máquina!",
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
