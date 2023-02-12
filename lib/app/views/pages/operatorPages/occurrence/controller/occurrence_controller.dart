import 'dart:convert';
import 'package:elephant_control/app/enums/enums.dart';
import 'package:elephant_control/base/models/incident/incident.dart';
import 'package:elephant_control/base/models/machine/machine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    machineOccurrencePicture = ImagesPictureWidget(origin: imageOrigin.camera);
    extraMachineOccurrencePicture = ImagesPictureWidget(origin: imageOrigin.camera);
    machineOccurrenceVideo = VideosPictureWidget();

    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();

    operatorName = LoggedUser.name;
    maintenanceDate = DateFormatToBrazil.formatDate(DateTime.now());
  }

  getOccurrenceInformations() async {
    try{
      if(_incident != null){
        observations.text = _incident!.incident.description ?? "";

        for(var media in _incident!.medias){
          if(media.base64 != null && media.base64 != ""){
            switch(media.type){
              case MediaType.firstOccurrencePicture:
                machineOccurrencePicture.picture = await FilesHelper.createXFileFromBase64(
                  media.base64!,
                );
                break;
              case MediaType.secondOccurrencePicture:
                extraMachineOccurrencePicture.picture = await FilesHelper.createXFileFromBase64(
                  media.base64!,
                );
                break;
              case MediaType.occurrenceVideo:
                machineOccurrenceVideo.picture = await FilesHelper.createXFileFromBase64(
                  media.base64!,
                );
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
        }
        update(["informations"]);

        if(machineOccurrencePicture.picture != null){
          machineOccurrencePicture.imagesPictureWidgetState.refreshPage();
        }
        if(extraMachineOccurrencePicture.picture != null){
          extraMachineOccurrencePicture.imagesPictureWidgetState.refreshPage();
        }
        if(machineOccurrenceVideo.picture != null){
          machineOccurrenceVideo.videosPictureWidgetState.refreshPage();
        }
      }
    }
    catch(_){
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

  onDropdownButtonWidgetChanged(String? selectedState) {
    machineSelected.value = selectedState ?? "";
  }

  saveOccurrence() async {
    try {
      if (!fieldsValidate()) return;
      bool newIncident = _incident == null;
      if(newIncident) {
        _incident = IncidentObject(
          Incident(
            status: IncidentStatus.realized,
            machineId: _machine.id!,
            visitId: _visitId,
            description: observations.text,
          ),
          [],
        );
      }
      List<VisitMedia> medias = [];
      final bytesClockImage = await machineOccurrencePicture.picture?.readAsBytes();
      if (bytesClockImage != null)
        medias.add(VisitMedia(
          visitId: _incident!.incident.id!,
          base64: base64Encode(bytesClockImage),
          type: MediaType.firstOccurrencePicture,
          extension: MediaExtension.jpeg,
          mediaId: newIncident ? null : _incident!.medias.firstWhere((media) => media.type == MediaType.firstOccurrencePicture).mediaId,
        ));
      final bytesBeforeImage = await extraMachineOccurrencePicture.picture?.readAsBytes();
      if (bytesBeforeImage != null)
        medias.add(VisitMedia(
          visitId: _incident!.incident.id!,
          base64: base64Encode(bytesBeforeImage),
          type: MediaType.secondOccurrencePicture,
          extension: MediaExtension.jpeg,
          mediaId: newIncident ? null : _incident!.medias.firstWhere((media) => media.type == MediaType.secondOccurrencePicture).mediaId,
        ));
      final bytesAfterImage = await machineOccurrenceVideo.picture?.readAsBytes();
      if (bytesAfterImage != null)
        medias.add(VisitMedia(
          visitId: _incident!.incident.id!,
          base64: base64Encode(bytesAfterImage),
          type: MediaType.occurrenceVideo,
          extension: MediaExtension.mp4,
          mediaId: newIncident ? null : _incident!.medias.firstWhere((media) => media.type == MediaType.occurrenceVideo).mediaId,
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
