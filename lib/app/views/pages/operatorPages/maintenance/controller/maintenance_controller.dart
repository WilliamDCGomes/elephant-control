import 'package:elephant_control/app/utils/logged_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/date_format_to_brazil.dart';
import '../../../widgetsShared/popups/images_picture_widget.dart';

class MaintenanceController extends GetxController {
  late RxString machineSelected;
  late RxString requestTitle;
  late RxBool yes;
  late RxBool no;
  late RxList<String> machinesPlaces;
  late TextEditingController operatorName;
  late TextEditingController maintenanceDate;
  late TextEditingController clock1;
  late TextEditingController clock2;
  late TextEditingController observations;
  late ImagesPictureWidget firstImageClock;
  late ImagesPictureWidget secondImageClock;
  late ImagesPictureWidget beforeMaintenanceImageClock;
  late ImagesPictureWidget afterMaintenanceImageClock;

  MaintenanceController(){
    _inicializeList();
    _initializeVariables();
  }

  _initializeVariables(){
    machineSelected = machinesPlaces[0].obs;
    requestTitle = machinesPlaces[0].obs;

    yes = false.obs;
    no = true.obs;

    operatorName = TextEditingController();
    maintenanceDate = TextEditingController();
    clock1 = TextEditingController();
    clock2 = TextEditingController();
    observations = TextEditingController();

    operatorName.text = LoggedUser.name;
    maintenanceDate.text = DateFormatToBrazil.formatDate(DateTime.now());

    firstImageClock = ImagesPictureWidget();
    secondImageClock = ImagesPictureWidget();
    beforeMaintenanceImageClock = ImagesPictureWidget();
    afterMaintenanceImageClock = ImagesPictureWidget();
  }

  _inicializeList(){
    machinesPlaces = [
      "Shopping Boulevard",
      "Supermercado Central",
      "Cinema Alameda",
    ].obs;
  }

  onDropdownButtonWidgetChanged(String? selectedState){
    machineSelected.value = selectedState ?? "";
    if(selectedState != null){
      requestTitle.value = selectedState;
    }
  }
}