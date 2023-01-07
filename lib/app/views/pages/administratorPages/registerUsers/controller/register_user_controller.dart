import 'package:elephant_control/app/utils/date_format_to_brazil.dart';
import 'package:elephant_control/base/models/user/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../base/models/addressInformation/address_information.dart';
import '../../../../../../base/services/consult_cep_service.dart';
import '../../../../../../base/services/interfaces/iconsult_cep_service.dart';
import '../../../../../../base/services/interfaces/iuser_service.dart';
import '../../../../../../base/services/user_service.dart';
import '../../../../../utils/brazil_address_informations.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/popups/information_popup.dart';

class RegisterUsersController extends GetxController {
  late RxString userTypeSelected;
  late RxString userGenderSelected;
  late RxString ufSelected;
  late RxList<String> ufsList;
  late RxList<String> userTypeList;
  late RxList<String> userGenderList;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late TextEditingController userNameTextController;
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
  User? _user;
  late IConsultCepService consultCepService;

  RegisterUsersController(this._user) {
    _initializeVariables();
    _initializeList();
  }

  @override
  void onInit() async {
    await _getUfsNames();
    if (_user != null) {
      await searchAddressInformation();
    }
    super.onInit();
  }

  _initializeVariables() {
    userTypeSelected = "".obs;
    userGenderSelected = "".obs;
    ufSelected = "".obs;
    ufsList = <String>[].obs;
    userTypeList = <String>[].obs;
    userGenderList = <String>[].obs;
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
    userNameTextController = TextEditingController(text: _user?.name);
    documentTextController = TextEditingController(text: _user?.document);
    birthDayTextController = TextEditingController(text: _user?.birthdayDate != null ? DateFormatToBrazil.formatDate(_user!.birthdayDate!) : "");
    emailTextController = TextEditingController(text: _user?.email);
    phoneTextController = TextEditingController(text: _user?.tellphone);
    cellPhoneTextController = TextEditingController(text: _user?.cellphone);
    cepTextController = TextEditingController(text: _user?.cep);
    cityTextController = TextEditingController(text: _user?.city);
    streetTextController = TextEditingController(text: _user?.address);
    houseNumberTextController = TextEditingController(text: _user?.number);
    neighborhoodTextController = TextEditingController(text: _user?.district);
    complementTextController = TextEditingController(text: _user?.complement);
    if (_user != null) {
      userTypeSelected.value = _user!.type.description;
    }
    consultCepService = ConsultCepService();
  }

  _initializeList() {
    userTypeList.addAll([
      "Administrativo",
      "Estoquista",
      "Operador",
      "Tesouraria",
    ]);

    userGenderList.addAll([
      "Masculino",
      "Feminino",
      "Outro",
    ]);

    userGenderSelected.value = userGenderList.first;
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

  saveNewUser() async {
    try {
      if (_validFields()) {
        loadingWithSuccessOrErrorWidget.startAnimation();

        late UserType userType;
        late TypeGender typeGender;

        switch (userTypeSelected.value) {
          case "Administrativo":
            userType = UserType.admin;
            break;
          case "Estoquista":
            userType = UserType.stockist;
            break;
          case "Operador":
            userType = UserType.operator;
            break;
          case "Tesouraria":
            userType = UserType.treasury;
            break;
          default:
            userType = UserType.none;
            break;
        }

        switch (userGenderSelected.value) {
          case "Masculino":
            typeGender = TypeGender.masculine;
            break;
          case "Feminino":
            typeGender = TypeGender.feminine;
            break;
          case "Outro":
            typeGender = TypeGender.other;
            break;
          default:
            typeGender = TypeGender.none;
            break;
        }

        _user ??= User(
          name: userNameTextController.text,
          tellphone: phoneTextController.text,
          document: documentTextController.text,
          balanceMoney: null,
          balanceStuffedAnimals: null,
          type: userType,
          pouchLastUpdate: DateTime.now(),
          stuffedAnimalsLastUpdate: DateTime.now(),
        );
        _user?.name = userNameTextController.text;
        _user?.tellphone ??= phoneTextController.text;
        _user?.document ??= documentTextController.text;
        _user?.balanceMoney = null;
        _user?.balanceStuffedAnimals = null;
        _user?.type = userType;
        _user?.pouchLastUpdate ??= DateTime.now();
        _user?.stuffedAnimalsLastUpdate ??= DateTime.now();

        if (birthDayTextController.text.isNotEmpty) {
          _user!.birthdayDate = DateFormatToBrazil.formatDateFromTextField(
            birthDayTextController.text,
          );
        } else {
          _user!.birthdayDate = null;
        }
        _user!.cep = cepTextController.text;
        _user!.uf = ufSelected.value;
        _user!.city = cityTextController.text;
        _user!.address = streetTextController.text;
        _user!.number = houseNumberTextController.text;
        _user!.district = neighborhoodTextController.text;
        _user!.complement = complementTextController.text;
        _user!.cellphone = cellPhoneTextController.text;
        _user!.email = emailTextController.text;
        _user!.gender = typeGender;

        // if(await _userService.createUser(_user!)){
        //   await loadingWithSuccessOrErrorWidget.stopAnimation();
        //   await showDialog(
        //     context: Get.context!,
        //     barrierDismissible: false,
        //     builder: (BuildContext context) {
        //       return InformationPopup(
        //         warningMessage: "Usuário cadastrado com sucesso!",
        //       );
        //     },
        //   );
        //   Get.back();
        // }
        Get.back(result: _user);
      }
    } catch (_) {
      await loadingWithSuccessOrErrorWidget.stopAnimation(fail: true);
      await showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Erro ao cadastrar usuário! Tente novamente mais tarde.",
          );
        },
      );
    }
  }

  bool _validFields() {
    if (userNameTextController.text.isEmpty) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Informe o Nome do Usuário!",
          );
        },
      );
      return false;
    }
    if (userTypeSelected.value.isEmpty) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Selecione o Tipo do Usuário!",
          );
        },
      );
      return false;
    }
    if (documentTextController.text.isEmpty) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Informe o Cpf do Usuário!",
          );
        },
      );
      return false;
    }

    /// Alessandro pediu para deixar sem obrigatoriedade de cadastro de endereço por hora
    /*if (emailTextController.text.isEmpty) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Informe o E-mail do Usuário!",
          );
        },
      );
      return false;
    }
    if (cellPhoneTextController.text.isEmpty) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Informe o Celular do Usuário!",
          );
        },
      );
      return false;
    }
    if (cepTextController.text.isEmpty) {
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
