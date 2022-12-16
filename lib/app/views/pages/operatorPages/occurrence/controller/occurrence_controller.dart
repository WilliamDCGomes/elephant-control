import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/date_format_to_brazil.dart';
import '../../../../../utils/logged_user.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/popups/images_picture_widget.dart';
import '../../../widgetsShared/popups/information_popup.dart';
import '../../../widgetsShared/popups/videos_picture_widget.dart';

class OccurrenceController extends GetxController {
  late RxBool loadingAnimation;
  late RxString machineSelected;
  late RxList<String> machinesPlaces;
  late TextEditingController operatorName;
  late TextEditingController maintenanceDate;
  late TextEditingController observations;
  late ImagesPictureWidget machineOccurrencePicture;
  late ImagesPictureWidget extraMachineOccurrencePicture;
  late VideosPictureWidget machineOccurrenceVideo;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;

  OccurrenceController(){
    _inicializeList();
    _initializeVariables();
  }

  _inicializeList(){
    machinesPlaces = [
      "Shopping Boulevard",
      "Supermercado Central",
      "Cinema Alameda",
    ].obs;
  }

  _initializeVariables(){
    machineSelected = machinesPlaces[0].obs;
    loadingAnimation = false.obs;
    operatorName = TextEditingController();
    maintenanceDate = TextEditingController();
    observations = TextEditingController();

    machineOccurrencePicture = ImagesPictureWidget();
    extraMachineOccurrencePicture = ImagesPictureWidget();
    machineOccurrenceVideo = VideosPictureWidget();

    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget(
      loadingAnimation: loadingAnimation,
    );

    operatorName.text = LoggedUser.name;
    maintenanceDate.text = DateFormatToBrazil.formatDate(DateTime.now());
  }

  onDropdownButtonWidgetChanged(String? selectedState){
    machineSelected.value = selectedState ?? "";
  }

  saveOccurrence() async {
    try{
      if(!fieldsValidate())
        return;
      loadingAnimation.value = true;
      await loadingWithSuccessOrErrorWidget.startAnimation();
      await Future.delayed(Duration(seconds: 2));

      await loadingWithSuccessOrErrorWidget.stopAnimation();
      await showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Ocorrência salva com sucesso!",
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
            warningMessage: "Erro ao salvar a ocorrência!",
          );
        },
      );
    }
  }

  bool fieldsValidate() {
    if(machineOccurrencePicture.picture == null || machineOccurrencePicture.picture!.path.isEmpty){
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
    if(observations.text.isEmpty){
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