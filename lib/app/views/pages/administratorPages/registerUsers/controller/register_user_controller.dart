import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../base/models/addressInformation/model/address_information.dart';
import '../../../../../../base/services/consult_cep_service.dart';
import '../../../../../../base/services/interfaces/iconsult_cep_service.dart';
import '../../../../../utils/brazil_address_informations.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';

class RegisterUsersController extends GetxController {
  late RxBool loadingAnimation;
  late RxString userTypeSelected;
  late RxString ufSelected;
  late RxList<String> ufsList;
  late RxList<String> userTypeList;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late TextEditingController userNameTextController;
  late TextEditingController userTextController;
  late TextEditingController documentTextController;
  late TextEditingController birthDayTextController;
  late TextEditingController emailTextController;
  late TextEditingController phoneTextController;
  late TextEditingController cellPhoneTextController;
  late TextEditingController cepTextController;
  late TextEditingController cityTextController;
  late TextEditingController streetTextController;
  late TextEditingController houseNumberTextController;
  late TextEditingController neighborhoodTextController;
  late TextEditingController complementTextController;
  late IConsultCepService consultCepService;

  RegisterUsersController(){
    _initializeVariables();
    _initializeList();
  }

  @override
  void onInit() async {
    await _getUfsNames();
    super.onInit();
  }

  _initializeVariables(){
    loadingAnimation = false.obs;
    userTypeSelected = "".obs;
    ufSelected = "".obs;
    ufsList = <String>[].obs;
    userTypeList = <String>[].obs;
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget(
      loadingAnimation: loadingAnimation,
    );
    userNameTextController = TextEditingController();
    userTextController = TextEditingController();
    documentTextController = TextEditingController();
    birthDayTextController = TextEditingController();
    emailTextController = TextEditingController();
    phoneTextController = TextEditingController();
    cellPhoneTextController = TextEditingController();
    cepTextController = TextEditingController();
    cityTextController = TextEditingController();
    streetTextController = TextEditingController();
    houseNumberTextController = TextEditingController();
    neighborhoodTextController = TextEditingController();
    complementTextController = TextEditingController();
    consultCepService = ConsultCepService();
  }

  _initializeList(){
    userTypeList.addAll([
      "Administrativo",
      "Estoquista",
      "Operador",
      "Tesouraria",
    ]);
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