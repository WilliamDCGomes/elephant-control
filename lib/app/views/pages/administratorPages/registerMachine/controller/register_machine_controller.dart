import 'package:elephant_control/base/services/machine_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../base/models/addressInformation/model/address_information.dart';
import '../../../../../../base/models/machine/model/machine.dart';
import '../../../../../../base/services/consult_cep_service.dart';
import '../../../../../../base/services/interfaces/iconsult_cep_service.dart';
import '../../../../../../base/services/interfaces/imachine_service.dart';
import '../../../../../utils/brazil_address_informations.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/popups/information_popup.dart';

class RegisterMachineController extends GetxController {
  late RxString ufSelected;
  late RxList<String> ufsList;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late TextEditingController machineNameTextController;
  late TextEditingController machineTypeTextController;
  late TextEditingController minAverageTextController;
  late TextEditingController maxAverageTextController;
  late TextEditingController firstClockTextController;
  late TextEditingController secondClockTextController;
  late TextEditingController periodVisitsTextController;
  late TextEditingController cepTextController;
  late TextEditingController cityTextController;
  late TextEditingController streetTextController;
  late TextEditingController houseNumberTextController;
  late TextEditingController neighborhoodTextController;
  late TextEditingController complementTextController;
  late IConsultCepService consultCepService;
  late Machine? _machine;
  late IMachineService _machineService;

  RegisterMachineController() {
    _initializeVariables();
  }

  @override
  void onInit() async {
    await _getUfsNames();
    super.onInit();
  }

  _initializeVariables() {
    ufSelected = "".obs;
    ufsList = [""].obs;
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
    machineNameTextController = TextEditingController();
    machineTypeTextController = TextEditingController();
    minAverageTextController = TextEditingController();
    maxAverageTextController = TextEditingController();
    firstClockTextController = TextEditingController();
    secondClockTextController = TextEditingController();
    periodVisitsTextController = TextEditingController();
    cepTextController = TextEditingController();
    cityTextController = TextEditingController();
    streetTextController = TextEditingController();
    houseNumberTextController = TextEditingController();
    neighborhoodTextController = TextEditingController();
    complementTextController = TextEditingController();
    minAverageTextController.text = "0";
    maxAverageTextController.text = "0";
    firstClockTextController.text = "0";
    secondClockTextController.text = "0";
    periodVisitsTextController.text = "0";
    consultCepService = ConsultCepService();
    _machine = null;
    _machineService = MachineService();
  }

  searchAddressInformation() async {
    int trys = 1;
    while (true) {
      try {
        if (cepTextController.text.length == 9) {
          AddressInformation? addressInformation = await consultCepService.searchCep(cepTextController.text);
          if (addressInformation != null) {
            ufSelected.value = addressInformation.uf;
            cityTextController.text = addressInformation.city;
            streetTextController.text = addressInformation.street;
            neighborhoodTextController.text = addressInformation.neighborhood;
            complementTextController.text = addressInformation.complement;
            break;
          } else {
            ufSelected.value = "";
            cityTextController.text = "";
            streetTextController.text = "";
            neighborhoodTextController.text = "";
            complementTextController.text = "";
          }
        }
      } catch (_) {
        ufSelected.value = "";
        cityTextController.text = "";
        streetTextController.text = "";
        neighborhoodTextController.text = "";
        complementTextController.text = "";
      } finally {
        trys++;
        if (trys > 3) {
          break;
        } else {
          continue;
        }
      }
    }
  }

  _getUfsNames() async {
    try {
      ufsList.clear();
      List<String> states = await BrazilAddressInformations.getUfsNames();
      for (var uf in states) {
        ufsList.add(uf);
      }
    } catch (_) {
      ufsList.clear();
    }
  }

  saveNewMachine() async {
    try {
      if (_validFields()) {
        loadingWithSuccessOrErrorWidget.startAnimation();
        _machine = Machine(name: machineNameTextController.text);
        _machine!.daysToNextVisit = int.parse(periodVisitsTextController.text);
        _machine!.prize = secondClockTextController.text.isNotEmpty ? double.tryParse(firstClockTextController.text) : null;
        _machine!.balance = firstClockTextController.text.isNotEmpty ? double.tryParse(firstClockTextController.text) : null;
        _machine!.selected = false;
        _machine!.localization = "";
        _machine!.longitude = "";
        _machine!.latitude = "";
        _machine!.cep = cepTextController.text;
        _machine!.uf = ufSelected.value;
        _machine!.city = cityTextController.text;
        _machine!.address = streetTextController.text;
        _machine!.number = houseNumberTextController.text;
        _machine!.district = neighborhoodTextController.text;
        _machine!.complement = complementTextController.text;
        _machine!.minimumAverageValue = double.tryParse(minAverageTextController.text) ?? 0.0;
        _machine!.maximumAverageValue = double.tryParse(maxAverageTextController.text) ?? 0.0;
        if (await _machineService.createMachine(_machine!)) {
          await loadingWithSuccessOrErrorWidget.stopAnimation();
          await showDialog(
            context: Get.context!,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return InformationPopup(
                warningMessage: "Máquina cadastrada com sucesso!",
              );
            },
          );
          Get.back();
        }
        throw Exception();
      }
    } catch (_) {
      await loadingWithSuccessOrErrorWidget.stopAnimation(fail: true);
      await showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Erro ao cadastrar máquina! Tente novamente mais tarde.",
          );
        },
      );
    }
  }

  bool _validFields() {
    if (machineNameTextController.text.isEmpty) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Informe o Nome da Máquina!",
          );
        },
      );
      return false;
    }
    if (machineTypeTextController.text.isEmpty) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Informe o Tipo da Máquina!",
          );
        },
      );
      return false;
    }
    if (minAverageTextController.text.isNotEmpty && maxAverageTextController.text.isNotEmpty && int.parse(minAverageTextController.text) > int.parse(maxAverageTextController.text)) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Valor mínimo não pode ser maior do que o valor máximo!",
          );
        },
      );
      return false;
    }
    /// Alessandro pediu para deixar sem obrigatoriedade de cadastro de endereço por hora
    /*if (cepTextController.text.isEmpty) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Informe o Cep da Máquina!",
          );
        },
      );
      return false;
    }
    if (ufSelected.value.isEmpty) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Selecione o Estado!",
          );
        },
      );
      return false;
    }
    if (cityTextController.text.isEmpty) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Informe a Cidade da Máquina!",
          );
        },
      );
      return false;
    }
    if (streetTextController.text.isEmpty) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Informe o Logradouro da Máquina!",
          );
        },
      );
      return false;
    }
    if (neighborhoodTextController.text.isEmpty) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Informe o Bairro da Máquina!",
          );
        },
      );
      return false;
    }*/
    return true;
  }
}
