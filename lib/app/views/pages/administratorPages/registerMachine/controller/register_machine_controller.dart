import 'package:elephant_control/base/services/machine_service.dart';
import 'package:elephant_control/base/viewControllers/return_machine_viewcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../base/models/addressInformation/address_information.dart';
import '../../../../../../base/models/machine/machine.dart';
import '../../../../../../base/services/consult_cep_service.dart';
import '../../../../../../base/services/interfaces/iconsult_cep_service.dart';
import '../../../../../../base/services/interfaces/imachine_service.dart';
import '../../../../../utils/brazil_address_informations.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/popups/information_popup.dart';

class RegisterMachineController extends GetxController {
  late bool edit;
  late RxString ufSelected;
  late RxList<String> ufsList;
  late RxList<ReturnMachineViewController> returnMachineViewControllers;
  ReturnMachineViewController? returnMachineViewControllerSelected;
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
  late TextEditingController externalCodeMachineController;
  late IConsultCepService consultCepService;
  Machine? _machine;
  late IMachineService _machineService;
  late final List<int> _externalIds;

  RegisterMachineController(this._machine, this.edit, this._externalIds) {
    _initializeVariables();
  }

  @override
  void onInit() async {
    await _getUfsNames();
    await getMachinesVmPay();
    if (_machine == null) {
    } else {
      returnMachineViewControllerSelected =
          returnMachineViewControllers.firstWhereOrNull((element) => element.id == _machine!.externalId!);
      await searchAddressInformation();
    }

    super.onInit();
  }

  _initializeVariables() {
    ufSelected = "".obs;
    ufsList = [""].obs;
    returnMachineViewControllers =
        <ReturnMachineViewController>[ReturnMachineViewController(asset_number: "Não encontrado", id: -1)].obs;
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
    machineNameTextController = TextEditingController(text: _machine?.name);
    machineTypeTextController = TextEditingController();
    externalCodeMachineController = TextEditingController(text: _machine?.externalId?.toString());
    minAverageTextController =
        TextEditingController(text: _machine == null ? null : _machine?.minimumAverageValue.toInt().toString());
    maxAverageTextController =
        TextEditingController(text: _machine == null ? null : _machine?.maximumAverageValue.toInt().toString());
    firstClockTextController =
        TextEditingController(text: _machine == null ? null : (_machine?.prize ?? 0.0).toStringAsFixed(0));
    secondClockTextController =
        TextEditingController(text: _machine == null ? null : (_machine?.balanceStuffedAnimals ?? 0.0).toStringAsFixed(0));
    periodVisitsTextController = TextEditingController(text: _machine == null ? null : _machine?.daysToNextVisit.toString());
    cepTextController = TextEditingController(text: _machine == null ? null : _machine?.cep);
    cityTextController = TextEditingController(text: _machine == null ? null : _machine?.city);
    streetTextController = TextEditingController(text: _machine == null ? null : _machine?.address);
    houseNumberTextController = TextEditingController(text: _machine == null ? null : _machine?.number);
    neighborhoodTextController = TextEditingController(text: _machine == null ? null : _machine?.district);
    complementTextController = TextEditingController(text: _machine == null ? null : _machine?.complement);
    consultCepService = ConsultCepService();
    _machineService = MachineService();
    if (_machine == null) {
      minAverageTextController.text = "0";
      maxAverageTextController.text = "0";
      firstClockTextController.text = "0";
      secondClockTextController.text = "0";
      periodVisitsTextController.text = "0";
    }
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

  getMachinesVmPay() async {
    try {
      returnMachineViewControllers.insertAll(1, await _machineService.getMachinesReturn(_externalIds));
    } catch (_) {
      returnMachineViewControllers.clear();
    } finally {
      returnMachineViewControllers.refresh();
    }
  }

  onChangedUfSelected(String? selectedState) {
    if (selectedState == null) {
      return;
    }
    ufSelected.value = selectedState;
  }

  void onChangedRegisterMachineSelected(String? id) {
    if (id == null) {
      returnMachineViewControllerSelected = returnMachineViewControllers.firstWhere((element) => element.id == -1);
    } else {
      returnMachineViewControllerSelected =
          returnMachineViewControllers.firstWhere((element) => element.id == int.parse(id));
    }
    update(['returnMachineViewControllerSelected']);
  }

  saveNewMachine() async {
    try {
      if (!_validFields()) {
        return;
      }
      await loadingWithSuccessOrErrorWidget.startAnimation();
      _machine ??= Machine(name: machineNameTextController.text);
      _machine!.name = machineNameTextController.text;
      _machine!.daysToNextVisit = int.parse(periodVisitsTextController.text);
      _machine!.prize = secondClockTextController.text.isNotEmpty ? double.tryParse(firstClockTextController.text) : null;
      _machine!.balanceStuffedAnimals =
          firstClockTextController.text.isNotEmpty ? double.tryParse(firstClockTextController.text) : null;
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
      _machine!.externalId = returnMachineViewControllerSelected?.id == -1
          ? externalCodeMachineController.text.isEmpty
              ? null
              : int.parse(externalCodeMachineController.text)
          : returnMachineViewControllerSelected?.id;

      Get.back(result: _machine);
      /*if (await _machineService.createOrUpdateMachine(_machine!)) {
        await loadingWithSuccessOrErrorWidget.stopAnimation();
        await showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return InformationPopup(
              warningMessage: "Máquina " + (edit ? "atualizada " : " cadastrada ") + "com sucesso!",
            );
          },
        );
        Get.back();
      }
      throw Exception();*/
    } catch (_) {
      await loadingWithSuccessOrErrorWidget.stopAnimation(fail: true);
      await showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Erro ao " + (edit ? "atualizar " : " cadastrar ") + "máquina! Tente novamente mais tarde.",
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
    if (minAverageTextController.text.isNotEmpty &&
        maxAverageTextController.text.isNotEmpty &&
        int.parse(minAverageTextController.text) > int.parse(maxAverageTextController.text)) {
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
