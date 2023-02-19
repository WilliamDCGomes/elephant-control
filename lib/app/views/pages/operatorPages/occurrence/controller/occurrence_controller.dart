import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:elephant_control/app/enums/enums.dart';
import 'package:elephant_control/app/views/pages/administratorPages/mainMenuAdministrator/controller/main_menu_administrator_controller.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/popups/confirmation_popup.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/snackbar_widget.dart';
import 'package:elephant_control/app/views/stylePages/app_colors.dart';
import 'package:elephant_control/base/models/incident/incident.dart';
import 'package:elephant_control/base/models/machine/machine.dart';
import 'package:elephant_control/base/services/incident_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../../../base/models/media/media.dart';
import '../../../../../../base/models/visitMedia/visit_media.dart';
import '../../../../../utils/date_format_to_brazil.dart';
import '../../../../../utils/files_helper.dart';
import '../../../../../utils/logged_user.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/popups/images_picture_widget.dart';
import '../../../widgetsShared/popups/information_popup.dart';
import '../../../widgetsShared/popups/videos_picture_widget.dart';

class OccurrenceController extends GetxController {
  final bool edit;
  late RxString machineSelected;
  late String operatorName;
  late String maintenanceDate;
  late TextEditingController observations;
  late ImagesPictureWidget machineOccurrencePicture;
  late ImagesPictureWidget extraMachineOccurrencePicture;
  late VideosPictureWidget machineOccurrenceVideo;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late final Machine _machine;
  late final String _visitId;
  late RxBool showFinalizeIncident;
  late IncidentObject? _incident;

  OccurrenceController(this._machine, this._visitId, this._incident, this.edit) {
    _initializeVariables();
  }

  @override
  void onInit() async {
    await Future.delayed(Duration(milliseconds: 200));
    await loadingWithSuccessOrErrorWidget.startAnimation();
    await getOccurrenceInformations();
    await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
    super.onInit();
  }

  _initializeVariables() {
    machineSelected = _machine.name.obs;
    operatorName = "";
    maintenanceDate = "";
    observations = TextEditingController();

    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();

    machineOccurrencePicture = ImagesPictureWidget(
      origin: imageOrigin.camera,
    );
    extraMachineOccurrencePicture = ImagesPictureWidget(
      origin: imageOrigin.camera,
    );
    machineOccurrenceVideo = VideosPictureWidget(
      showPlayIcon: !edit,
      loadingWithSuccessOrErrorWidget: loadingWithSuccessOrErrorWidget,
    );

    operatorName = LoggedUser.name;
    maintenanceDate = DateFormatToBrazil.formatDate(DateTime.now());
    showFinalizeIncident =
        _incident?.incident == null ? true.obs : (_incident!.incident.status == IncidentStatus.realized).obs;
  }

  getOccurrenceInformations() async {
    try {
      if (_incident != null) {
        observations.text = _incident!.incident.description ?? "";

        for (var media in _incident!.medias) {
          switch (media.type) {
            case MediaType.firstOccurrencePicture:
              machineOccurrencePicture.picture = await FilesHelper.createXFileFromBase64(
                media.media,
              );
              break;
            case MediaType.secondOccurrencePicture:
              extraMachineOccurrencePicture.picture = await FilesHelper.createXFileFromBase64(
                media.media,
              );
              break;
            case MediaType.occurrenceVideo:
              machineOccurrenceVideo.picture = await FilesHelper.createXFileFromBase64(
                media.media,
                name: DateTime.now().millisecondsSinceEpoch.toString() + ".mp4",
              );
              machineOccurrenceVideo.base64 = media.media;
              break;
            case MediaType.stuffedAnimals:
              break;
            case MediaType.moneyWatch:
              break;
            case MediaType.machineBefore:
              break;
            case MediaType.machineAfter:
              break;
          }
        }
        update(["informations"]);

        if (machineOccurrencePicture.picture != null) {
          machineOccurrencePicture.imagesPictureWidgetState.refreshPage();
        }
        if (extraMachineOccurrencePicture.picture != null) {
          extraMachineOccurrencePicture.imagesPictureWidgetState.refreshPage();
        }
        if (machineOccurrenceVideo.picture != null) {
          machineOccurrenceVideo.videosPictureWidgetState.refreshPage();
        }
      }
    } catch (_) {
      await loadingWithSuccessOrErrorWidget.stopAnimation(fail: true);
      await showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Erro ao abrir a ocorrência! Tente novamente mais tarde.",
          );
        },
      );
      Get.back();
    }
  }

  Future<File?> getVideoFile(String base64String) async {
    try {
      Uint8List bytes = base64.decode(base64String);
      String dir = (await getApplicationDocumentsDirectory()).path;
      File file = File(
        "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".mp4",
      );
      await file.writeAsBytes(bytes);
      return file;
    } catch (_) {
      await showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Erro ao abrir o vídeo.",
          );
        },
      );
      return null;
    }
  }

  void finalizeIncident() async {
    bool refreshIncident = false;
    await showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ConfirmationPopup(
          title: "Finalizar Ocorrência",
          subTitle: "Deseja finalizar a ocorrência?",
          secondButton: () => refreshIncident = true,
          firstButton: () => refreshIncident = false,
        );
      },
    );
    if (refreshIncident) {
      await loadingWithSuccessOrErrorWidget.startAnimation();
      final incident = _incident!.incident;
      incident.status = IncidentStatus.finished;
      final incidentRefreshed = await IncidentService().updateIncident(incident);
      await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
      SnackbarWidget(
          warningText: incidentRefreshed ? "Ocorrência finalizada" : "Erro ao finalizar a ocorrência",
          informationText: incidentRefreshed
              ? "Ocorrência finalizada com sucesso!"
              : "Erro ao finalizar a ocorrência! Tente novamente mais tarde.",
          backgrondColor: incidentRefreshed ? AppColors.defaultColor : AppColors.redColor);
      if (incidentRefreshed) {
        showFinalizeIncident.value = false;
        Future.microtask(() async =>
            await Get.find<MainMenuAdministratorController>(tag: "main_menu_administrator_controller").getVisitsUser());
      }
    }
  }

  onDropdownButtonWidgetChanged(String? selectedState) {
    machineSelected.value = selectedState ?? "";
  }

  saveOccurrence() async {
    try {
      if (!fieldsValidate()) return;
      bool newIncident = _incident == null;
      if (newIncident) {
        _incident = IncidentObject(
          Incident(
            status: IncidentStatus.realized,
            machineId: _machine.id!,
            visitId: _visitId,
            description: observations.text,
          ),
          [],
        );
      } else {
        _incident!.incident.description = observations.text;
      }
      List<VisitMedia> medias = [];
      final bytesClockImage = await machineOccurrencePicture.picture?.readAsBytes();
      VisitMedia? mediaPicture = null;

      if (_incident!.medias.any((media) => media.type == MediaType.firstOccurrencePicture)) {
        mediaPicture = _incident!.medias.firstWhere((media) => media.type == MediaType.firstOccurrencePicture);
      }

      if (bytesClockImage != null)
        medias.add(VisitMedia(
          visitId: _incident!.incident.id!,
          media: base64Encode(bytesClockImage),
          type: MediaType.firstOccurrencePicture,
          extension: MediaExtension.jpeg,
          mediaId: newIncident
              ? null
              : mediaPicture != null
                  ? mediaPicture.mediaId
                  : null,
        ));
      final bytesBeforeImage = await extraMachineOccurrencePicture.picture?.readAsBytes();
      VisitMedia? mediaExtraPicture = null;

      if (_incident!.medias.any((media) => media.type == MediaType.secondOccurrencePicture)) {
        mediaExtraPicture = _incident!.medias.firstWhere((media) => media.type == MediaType.secondOccurrencePicture);
      }

      if (bytesBeforeImage != null)
        medias.add(VisitMedia(
          visitId: _incident!.incident.id!,
          media: base64Encode(bytesBeforeImage),
          type: MediaType.secondOccurrencePicture,
          extension: MediaExtension.jpeg,
          mediaId: newIncident
              ? null
              : mediaExtraPicture != null
                  ? mediaExtraPicture.mediaId
                  : null,
        ));
      final bytesAfterImage = await machineOccurrenceVideo.picture?.readAsBytes();
      VisitMedia? mediaVideo = null;

      if (_incident!.medias.any((media) => media.type == MediaType.occurrenceVideo)) {
        mediaVideo = _incident!.medias.firstWhere((media) => media.type == MediaType.occurrenceVideo);
      }

      if (bytesAfterImage != null)
        medias.add(VisitMedia(
          visitId: _incident!.incident.id!,
          media: base64Encode(bytesAfterImage),
          type: MediaType.occurrenceVideo,
          extension: MediaExtension.mp4,
          mediaId: newIncident
              ? null
              : mediaVideo != null
                  ? mediaVideo.mediaId
                  : null,
        ));
      await showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Ocorrência salva com sucesso!",
          );
        },
      );
      _incident!.medias = medias;

      Get.back(result: _incident);
    } catch (_) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Erro ao salvar a ocorrência!",
          );
        },
      );
    }
  }

  bool fieldsValidate() {
    if (machineOccurrencePicture.picture == null || machineOccurrencePicture.picture!.path.isEmpty) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Tire a foto da máquina da ocorrência",
          );
        },
      );
      return false;
    }
    if (observations.text.isEmpty) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Informe o ocorrido!",
          );
        },
      );
      return false;
    }
    return true;
  }
}

class IncidentObject {
  Incident incident;
  List<VisitMedia> medias;

  IncidentObject(this.incident, this.medias);
}
