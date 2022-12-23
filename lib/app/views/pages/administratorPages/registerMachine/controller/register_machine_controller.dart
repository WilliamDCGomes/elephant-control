import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../base/models/address_information.dart';
import '../../../../../../base/services/consult_cep_service.dart';
import '../../../../../../base/services/interfaces/iconsult_cep_service.dart';
import '../../../../../utils/brazil_address_informations.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';

class RegisterMachineController extends GetxController {
  late RxBool loadingAnimation;
  late RxString ufSelected;
  late RxList<String> ufsList;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late TextEditingController machineNameTextController;
  late TextEditingController minAverageTextController;
  late TextEditingController maxAverageTextController;
  late TextEditingController periodVisitsTextController;
  late TextEditingController cepTextController;
  late TextEditingController cityTextController;
  late TextEditingController streetTextController;
  late TextEditingController houseNumberTextController;
  late TextEditingController neighborhoodTextController;
  late TextEditingController complementTextController;
  late IConsultCepService consultCepService;

  RegisterMachineController(){
    _initializeVariables();
  }

  @override
  void onInit() async {
    await _getUfsNames();
    super.onInit();
  }

  _initializeVariables(){
    loadingAnimation = false.obs;
    ufSelected = "".obs;
    ufsList = [""].obs;
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget(
      loadingAnimation: loadingAnimation,
    );
    machineNameTextController = TextEditingController();
    minAverageTextController = TextEditingController();
    maxAverageTextController = TextEditingController();
    periodVisitsTextController = TextEditingController();
    cepTextController = TextEditingController();
    cityTextController = TextEditingController();
    streetTextController = TextEditingController();
    houseNumberTextController = TextEditingController();
    neighborhoodTextController = TextEditingController();
    complementTextController = TextEditingController();
    consultCepService = ConsultCepService();
  }

  searchAddressInformation() async {
    int trys = 1;
    while(true){
      try{
        if(cepTextController.text.length == 9){
          AddressInformation? addressInformation = await consultCepService.searchCep(cepTextController.text);
          if(addressInformation != null){
            ufSelected.value = addressInformation.uf;
            cityTextController.text = addressInformation.city;
            streetTextController.text = addressInformation.street;
            neighborhoodTextController.text = addressInformation.neighborhood;
            complementTextController.text = addressInformation.complement;
            break;
          }
          else{
            ufSelected.value = "";
            cityTextController.text = "";
            streetTextController.text = "";
            neighborhoodTextController.text = "";
            complementTextController.text = "";
          }
        }
      }
      catch(_){
        ufSelected.value = "";
        cityTextController.text = "";
        streetTextController.text = "";
        neighborhoodTextController.text = "";
        complementTextController.text = "";
      }
      finally{
        trys++;
        if(trys > 3){
          break;
        }
        else {
          continue;
        }
      }
    }
  }

  _getUfsNames() async {
    try{
      ufsList.clear();
      List<String> states = await BrazilAddressInformations.getUfsNames();
      for(var uf in states) {
        ufsList.add(uf);
      }
    }
    catch(_){
      ufsList.clear();
    }
  }
}