import 'dart:convert';
import 'package:elephant_control/app/enums/enums.dart';
import 'package:elephant_control/base/models/incident/incident.dart';
import 'package:elephant_control/base/models/machine/machine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../base/models/media/media.dart';
import '../../../../../../base/models/visitMedia/visit_media.dart';
import '../../../../../utils/date_format_to_brazil.dart';
import '../../../../../utils/logged_user.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/popups/images_picture_widget.dart';
import '../../../widgetsShared/popups/information_popup.dart';
import '../../../widgetsShared/popups/videos_picture_widget.dart';

class OccurrenceController extends GetxController {
  late RxString machineSelected;
  late TextEditingController operatorName;
  late TextEditingController maintenanceDate;
  late TextEditingController observations;
  late ImagesPictureWidget machineOccurrencePicture;
  late ImagesPictureWidget extraMachineOccurrencePicture;
  late VideosPictureWidget machineOccurrenceVideo;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late final Machine _machine;
  late final String _visitId;

  OccurrenceController(this._machine, this._visitId) {
    _initializeVariables();
  }

  _initializeVariables() {
    machineSelected = _machine.name.obs;
    operatorName = TextEditingController();
    maintenanceDate = TextEditingController();
    observations = TextEditingController();
    machineOccurrencePicture = ImagesPictureWidget(origin: imageOrigin.camera);
    extraMachineOccurrencePicture = ImagesPictureWidget(origin: imageOrigin.camera);
    machineOccurrenceVideo = VideosPictureWidget();

    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();

    operatorName.text = LoggedUser.name;
    maintenanceDate.text = DateFormatToBrazil.formatDate(DateTime.now());
  }

  onDropdownButtonWidgetChanged(String? selectedState) {
    machineSelected.value = selectedState ?? "";
  }

  saveOccurrence() async {
    try {
      if (!fieldsValidate()) return;
      final _incident = Incident(status: IncidentStatus.realized, machineId: _machine.id!, visitId: _visitId, description: observations.text);
      List<VisitMedia> medias = [];
      final bytesClockImage = await machineOccurrencePicture.picture?.readAsBytes();
      if (bytesClockImage != null)
        medias.add(VisitMedia(
          visitId: _incident.id!,
          base64: base64Encode(bytesClockImage),
          type: MediaType.moneyWatch,
          extension: MediaExtension.jpeg,
        ));
      final bytesBeforeImage = await extraMachineOccurrencePicture.picture?.readAsBytes();
      if (bytesBeforeImage != null)
        medias.add(VisitMedia(
          visitId: _incident.id!,
          base64: base64Encode(bytesBeforeImage),
          type: MediaType.machine,
          extension: MediaExtension.jpeg,
        ));
      final bytesAfterImage = await machineOccurrenceVideo.picture?.readAsBytes();
      if (bytesAfterImage != null)
        medias.add(VisitMedia(
          visitId: _incident.id!,
          base64: base64Encode(bytesAfterImage),
          type: MediaType.machine,
          extension: MediaExtension.jpeg,
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
      await Get.delete<OccurrenceController>(force: true);
      Get.back(result: IncidentObject(_incident, medias));
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
  final Incident incident;
  final List<VisitMedia> medias;

  IncidentObject(this.incident, this.medias);
}
