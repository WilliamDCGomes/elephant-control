import 'package:elephant_control/app/enums/enums.dart';
import 'package:elephant_control/app/utils/date_format_to_brazil.dart';
import 'package:elephant_control/app/views/pages/stockistPages/mainMenuStokist/page/main_menu_stokist_page.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/popups/images_picture_widget.dart';
import 'package:elephant_control/base/services/consult_cep_service.dart';
import 'package:elephant_control/base/services/user_service.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../../base/models/addressInformation/address_information.dart';
import '../../../../../../base/models/user/user.dart';
import '../../../../../../base/services/interfaces/iconsult_cep_service.dart';
import '../../../../../../base/services/interfaces/iuser_service.dart';
import '../../../../../utils/brazil_address_informations.dart';
import '../../../../../utils/get_profile_picture_controller.dart';
import '../../../../../utils/internet_connection.dart';
import '../../../../../utils/logged_user.dart';
import '../../../../../utils/masks_for_text_fields.dart';
import '../../../../../utils/text_field_validators.dart';
import '../../../../../utils/valid_cellphone_mask.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../administratorPages/mainMenuAdministrator/controller/main_menu_administrator_controller.dart';
import '../../../administratorPages/mainMenuAdministrator/page/main_menu_administrator_page.dart';
import '../../../financialPages/mainMenuFinancial/controller/main_menu_financial_controller.dart';
import '../../../financialPages/mainMenuFinancial/page/main_menu_financial_page.dart';
import '../../../operatorPages/mainMenuOperator/controller/main_menu_operator_controller.dart';
import '../../../operatorPages/mainMenuOperator/page/main_menu_operator_page.dart';
import '../../../stockistPages/mainMenuStokist/controller/main_menu_stokist_controller.dart';
import '../../../widgetsShared/loading_profile_picture_widget.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/popups/confirmation_popup.dart';
import '../../../widgetsShared/popups/information_popup.dart';
import '../../../widgetsShared/snackbar_widget.dart';
import '../widgets/user_profile_tabs_widget.dart';

class UserProfileController extends GetxController {
  late bool imageChanged;
  late RxString nameInitials;
  late RxString userName;
  late RxString ufSelected;
  late RxString buttonText;
  late RxString genderSelected;
  late RxBool screenLoading;
  late RxBool currentPasswordFieldEnabled;
  late RxBool newPasswordFieldEnabled;
  late RxBool confirmNewPasswordFieldEnabled;
  late RxBool profileIsDisabled;
  late RxBool nameInputHasError;
  late RxBool birthdayInputHasError;
  late RxBool cepInputHasError;
  late RxBool cityInputHasError;
  late RxBool streetInputHasError;
  late RxBool neighborhoodInputHasError;
  late RxBool phoneInputHasError;
  late RxBool cellPhoneInputHasError;
  late RxBool emailInputHasError;
  late RxBool confirmEmailInputHasError;
  late TabController tabController;
  late TextEditingController nameTextController;
  late TextEditingController birthDateTextController;
  late TextEditingController cpfTextController;
  late TextEditingController cepTextController;
  late TextEditingController cityTextController;
  late TextEditingController streetTextController;
  late TextEditingController houseNumberTextController;
  late TextEditingController neighborhoodTextController;
  late TextEditingController complementTextController;
  late TextEditingController phoneTextController;
  late TextEditingController cellPhoneTextController;
  late TextEditingController emailTextController;
  late TextEditingController confirmEmailTextController;
  late TextEditingController currentPasswordTextController;
  late TextEditingController newPasswordTextController;
  late TextEditingController confirmNewPasswordTextController;
  late TextEditingController controllerCode;
  late FocusNode birthDateFocusNode;
  late FocusNode streetFocusNode;
  late FocusNode houseNumberFocusNode;
  late FocusNode neighborhoodFocusNode;
  late FocusNode complementFocusNode;
  late FocusNode cellPhoneFocusNode;
  late FocusNode emailFocusNode;
  late FocusNode confirmEmailFocusNode;
  late FocusNode confirmPasswordFocusNode;
  late MaskTextInputFormatter maskCellPhoneFormatter;
  late List<String> genderList;
  late List<Widget> tabsList;
  late RxList<String> ufsList;
  late XFile? profilePicture;
  late final ImagePicker _picker;
  late User? _user;
  late LoadingProfilePictureWidget loadingProfilePicture;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late MainMenuOperatorController? mainMenuOperatorController;
  late MainMenuFinancialController? mainMenuFinancialController;
  late MainMenuAdministratorController? mainMenuAdministratorController;
  late MainMenuStokistController? mainMenuStokistController;
  late SharedPreferences sharedPreferences;
  late IConsultCepService _consultCepService;
  late IUserService _userService;

  UserProfileController(this.mainMenuOperatorController, this.mainMenuFinancialController,
      this.mainMenuAdministratorController, this.mainMenuStokistController) {
    _initializeVariables();
    _initializeLists();
  }

  @override
  void onInit() async {
    sharedPreferences = await SharedPreferences.getInstance();
    await _getUfsNames();
    _user = await _userService.getUserInformation();
    await _getUserInformation();
    screenLoading.value = false;
    super.onInit();
  }

  _initializeVariables() {
    imageChanged = false;
    nameInitials = LoggedUser.nameInitials.obs;
    userName = LoggedUser.nameAndLastName.obs;
    ufSelected = "".obs;
    buttonText = "EDITAR".obs;
    genderSelected = "".obs;
    screenLoading = true.obs;
    profileIsDisabled = true.obs;
    currentPasswordFieldEnabled = true.obs;
    newPasswordFieldEnabled = true.obs;
    confirmNewPasswordFieldEnabled = true.obs;
    nameInputHasError = false.obs;
    birthdayInputHasError = false.obs;
    cepInputHasError = false.obs;
    cityInputHasError = false.obs;
    streetInputHasError = false.obs;
    neighborhoodInputHasError = false.obs;
    phoneInputHasError = false.obs;
    cellPhoneInputHasError = false.obs;
    emailInputHasError = false.obs;
    confirmEmailInputHasError = false.obs;
    ufsList = [""].obs;
    nameTextController = TextEditingController();
    birthDateTextController = TextEditingController();
    cpfTextController = TextEditingController();
    cepTextController = TextEditingController();
    cityTextController = TextEditingController();
    streetTextController = TextEditingController();
    houseNumberTextController = TextEditingController();
    neighborhoodTextController = TextEditingController();
    complementTextController = TextEditingController();
    phoneTextController = TextEditingController();
    cellPhoneTextController = TextEditingController();
    emailTextController = TextEditingController();
    confirmEmailTextController = TextEditingController();
    currentPasswordTextController = TextEditingController();
    newPasswordTextController = TextEditingController();
    confirmNewPasswordTextController = TextEditingController();
    controllerCode = TextEditingController();
    birthDateFocusNode = FocusNode();
    streetFocusNode = FocusNode();
    houseNumberFocusNode = FocusNode();
    neighborhoodFocusNode = FocusNode();
    complementFocusNode = FocusNode();
    cellPhoneFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    confirmEmailFocusNode = FocusNode();
    confirmPasswordFocusNode = FocusNode();
    _picker = ImagePicker();
    maskCellPhoneFormatter = MasksForTextFields.phoneNumberAcceptExtraNumberMask;
    loadingProfilePicture = LoadingProfilePictureWidget(
      internalLoadingAnimation: mainMenuOperatorController != null
          ? mainMenuOperatorController!.loadingPicture
          : mainMenuFinancialController != null
              ? mainMenuFinancialController!.loadingPicture
              : mainMenuAdministratorController != null
                  ? mainMenuAdministratorController!.loadingPicture
                  : mainMenuStokistController!.loadingPicture,
    );
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
    _user = User.emptyConstructor();
    _consultCepService = ConsultCepService();
    _userService = UserService();
  }

  _getUfsNames() async {
    ufsList.clear();
    List<String> states = await BrazilAddressInformations.getUfsNames();
    for (var uf in states) {
      ufsList.add(uf);
    }
  }

  _initializeLists() {
    genderList = [
      "Masculino",
      "Feminino",
      "Prefiro não dizer",
    ];

    tabsList = UserProfileTabsWidget.getList(this);
  }

  _getUserInformation() async {
    nameTextController.text = await sharedPreferences.getString("name") ?? "";
    birthDateTextController.text = await sharedPreferences.getString("birthdate") ?? "";
    genderSelected.value = await sharedPreferences.getString("gender") ?? "";
    cpfTextController.text = await sharedPreferences.getString("cpf") ?? "";
    cepTextController.text = await sharedPreferences.getString("cep") ?? "";
    cityTextController.text = await sharedPreferences.getString("city") ?? "";
    streetTextController.text = await sharedPreferences.getString("street") ?? "";
    houseNumberTextController.text = await sharedPreferences.getString("houseNumber") ?? "";
    neighborhoodTextController.text = await sharedPreferences.getString("neighborhood") ?? "";
    complementTextController.text = await sharedPreferences.getString("complement") ?? "";
    phoneTextController.text = await sharedPreferences.getString("phone") ?? "";
    cellPhoneTextController.text = await sharedPreferences.getString("cellPhone") ?? "";
    emailTextController.text = await sharedPreferences.getString("email") ?? "";
    confirmEmailTextController.text = await sharedPreferences.getString("email") ?? "";
    ufSelected.value = await sharedPreferences.getString("uf") ?? "";
    controllerCode.text = int.tryParse(await sharedPreferences.getString("code").toString()) == null
        ? "Não Informado"
        : await sharedPreferences.getString("code").toString();
  }

  _saveInformations() async {
    try {
      await sharedPreferences.setString("uf", ufSelected.value);
      await sharedPreferences.setString("email", confirmEmailTextController.text);
      await sharedPreferences.setString("email", emailTextController.text);
      await sharedPreferences.setString("cellPhone", cellPhoneTextController.text);
      await sharedPreferences.setString("phone", phoneTextController.text);
      await sharedPreferences.setString("complement", complementTextController.text);
      await sharedPreferences.setString("neighborhood", neighborhoodTextController.text);
      await sharedPreferences.setString("houseNumber", houseNumberTextController.text);
      await sharedPreferences.setString("street", streetTextController.text);
      await sharedPreferences.setString("city", cityTextController.text);
      await sharedPreferences.setString("cep", cepTextController.text);
      await sharedPreferences.setString("cpf", cpfTextController.text);
      await sharedPreferences.setString("gender", genderSelected.value);
      await sharedPreferences.setString("birthdate", birthDateTextController.text);
      await sharedPreferences.setString("name", nameTextController.text);
      return true;
    } catch (_) {
      return false;
    }
  }

  bool _validPersonalInformationAndAdvanceNextStep() {
    if (genderSelected.value == "") {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Informe o seu sexo.",
          );
        },
      );
      return false;
    }
    return true;
  }

  phoneTextFieldEdited(String cellPhoneTyped) {
    cellPhoneTextController.value = ValidCellPhoneMask.updateCellPhoneMask(
      cellPhoneTyped,
      maskCellPhoneFormatter,
    );
  }

  searchAddressInformation() async {
    int trys = 1;
    while (true) {
      try {
        if (cepTextController.text.length == 9) {
          AddressInformation? addressInformation = await _consultCepService.searchCep(cepTextController.text);
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

  _setUserToUpdate() {
    if (_user != null) {
      _user!.name = nameTextController.text;
      _user!.birthdayDate = DateFormatToBrazil.formatDateFromTextField(birthDateTextController.text);
      switch (genderSelected.value) {
        case "Masculino":
          _user!.gender = TypeGender.masculine;
          break;
        case "Feminino":
          _user!.gender = TypeGender.feminine;
          break;
        case "Outro":
          _user!.gender = TypeGender.other;
          break;
        default:
          _user!.gender = TypeGender.none;
          break;
      }
      _user!.cep = cepTextController.text;
      _user!.uf = ufSelected.value;
      _user!.city = cityTextController.text;
      _user!.address = streetTextController.text;
      _user!.number = houseNumberTextController.text;
      _user!.district = neighborhoodTextController.text;
      _user!.complement = complementTextController.text;
      _user!.tellphone = phoneTextController.text;
      _user!.cellphone = cellPhoneTextController.text;
      _user!.email = emailTextController.text;
      _user!.id = LoggedUser.id;
      _user!.document = cpfTextController.text;
      _user!.alteration = DateTime.now();
    }
  }

  editButtonPressed() async {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    if (profileIsDisabled.value) {
      buttonText.value = "SALVAR";
      profileIsDisabled.value = false;
    } else {
      await loadingWithSuccessOrErrorWidget.startAnimation();

      await Future.delayed(Duration(seconds: 1));

      if (!await InternetConnection.validInternet(
        "É necessário uma conexão com a internet para fazer o cadastro",
        loadingWithSuccessOrErrorWidget,
      )) {
        return;
      }

      if (!_validProfile()) {
        return;
      } else if (_validPersonalInformationAndAdvanceNextStep()) {
        _setUserToUpdate();

        if (await _saveUser()) {
          await loadingWithSuccessOrErrorWidget.stopAnimation();
          await showDialog(
            context: Get.context!,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return InformationPopup(
                warningMessage: "Perfil atualizado com sucesso!",
              );
            },
          );
          buttonText.value = "EDITAR";
          profileIsDisabled.value = true;
          _goToNextPage();
        }
      }
    }
  }

  _goToNextPage() {
    if (LoggedUser.userType == UserType.operator) {
      Get.offAll(() => MainMenuOperatorPage());
    } else if (LoggedUser.userType == UserType.treasury) {
      Get.offAll(() => MainMenuFinancialPage());
    } else if (LoggedUser.userType == UserType.admin) {
      Get.offAll(() => MainMenuAdministratorPage(accessValidate: false));
    } else if (LoggedUser.userType == UserType.stockist) {
      Get.offAll(() => MainMenuStokistPage());
    } else if (LoggedUser.userType == UserType.adminPrivileges) {
      Get.offAll(() => MainMenuAdministratorPage(accessValidate: true));
    }
  }

  bool _validProfile() {
    try {
      if (nameTextController.text == "") {
        nameInputHasError.value = true;
        tabController.index = 0;
        throw "Informe o seu Nome";
      } else {
        nameInputHasError.value = false;
      }

      String? birthDateValidation = TextFieldValidators.birthDayValidation(birthDateTextController.text, "de Nascimento");
      if (birthDateValidation != null && birthDateValidation != "") {
        birthdayInputHasError.value = true;
        tabController.index = 0;
        throw birthDateValidation;
      } else {
        birthdayInputHasError.value = false;
      }

      String? cepValidation = TextFieldValidators.minimumNumberValidation(
        cepTextController.text,
        9,
        "Cep",
      );
      if (cepValidation != null && cepValidation != "") {
        cepInputHasError.value = true;
        tabController.index = 1;
        throw cepValidation;
      } else {
        cepInputHasError.value = false;
      }

      String? cityValidation = TextFieldValidators.standardValidation(cityTextController.text, "Informe a Cidade");
      if (cityValidation != null && cityValidation != "") {
        cityInputHasError.value = true;
        tabController.index = 1;
        throw cityValidation;
      } else {
        cityInputHasError.value = false;
      }

      String? streetValidation = TextFieldValidators.standardValidation(streetTextController.text, "Informe o Logradouro");
      if (streetValidation != null && streetValidation != "") {
        streetInputHasError.value = true;
        tabController.index = 1;
        throw streetValidation;
      } else {
        streetInputHasError.value = false;
      }

      String? neighborhoodValidation =
          TextFieldValidators.standardValidation(neighborhoodTextController.text, "Informe o Bairro");
      if (neighborhoodValidation != null && neighborhoodValidation != "") {
        neighborhoodInputHasError.value = true;
        tabController.index = 1;
        throw neighborhoodValidation;
      } else {
        neighborhoodInputHasError.value = false;
      }

      String? phoneValidation = TextFieldValidators.phoneValidation(phoneTextController.text);
      if (phoneValidation != null && phoneValidation != "") {
        phoneInputHasError.value = true;
        tabController.index = 2;
        throw phoneValidation;
      } else {
        phoneInputHasError.value = false;
      }

      String? cellPhoneValidation = TextFieldValidators.cellPhoneValidation(cellPhoneTextController.text);
      if (cellPhoneValidation != null && cellPhoneValidation != "") {
        cellPhoneInputHasError.value = true;
        tabController.index = 2;
        throw cellPhoneValidation;
      } else {
        cellPhoneInputHasError.value = false;
      }

      String? emailValidation = TextFieldValidators.emailValidation(emailTextController.text);
      if (emailValidation != null && emailValidation != "") {
        emailInputHasError.value = true;
        tabController.index = 2;
        throw emailValidation;
      } else {
        emailInputHasError.value = false;
      }

      String? confirmEmailvalidation = TextFieldValidators.emailConfirmationValidation(
        emailTextController.text,
        confirmEmailTextController.text,
      );
      if (confirmEmailvalidation != null && confirmEmailvalidation != "") {
        confirmEmailInputHasError.value = true;
        tabController.index = 2;
        throw confirmEmailvalidation;
      } else {
        confirmEmailInputHasError.value = false;
      }
      return true;
    } catch (e) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: e.toString(),
          );
        },
      );
      return false;
    }
  }

  getProfileImage(imageOrigin origin) async {
    try {
      if (mainMenuOperatorController != null) {
        mainMenuOperatorController!.loadingPicture.value = true;
      } else if (mainMenuFinancialController != null) {
        mainMenuFinancialController!.loadingPicture.value = true;
      } else if (mainMenuAdministratorController != null) {
        mainMenuAdministratorController!.loadingPicture.value = true;
      } else {
        mainMenuStokistController!.loadingPicture.value = true;
      }

      final ImageSource source = origin == imageOrigin.camera ? ImageSource.camera : ImageSource.gallery;

      profilePicture = await _picker.pickImage(source: source);

      profilePicture = await ImagesPictureWidget(
        origin: origin == imageOrigin.camera ? imageOrigin.camera : imageOrigin.gallery,
      ).compressFile(profilePicture);

      if (profilePicture != null) {
        if (await _saveProfilePicture()) {
          imageChanged = true;
          SnackbarWidget(
            warningText: "Aviso",
            informationText: "Foto de perfil alterada com sucesso.",
            backgrondColor: AppColors.defaultColor,
          );
        }
      }
    } catch (e) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Erro ao atualizar a imagem de perfil.",
          );
        },
      );
    } finally {
      if (mainMenuOperatorController != null) {
        mainMenuOperatorController!.loadingPicture.value = false;
      } else if (mainMenuFinancialController != null) {
        mainMenuFinancialController!.loadingPicture.value = false;
      } else if (mainMenuAdministratorController != null) {
        mainMenuAdministratorController!.loadingPicture.value = false;
      } else {
        mainMenuStokistController!.loadingPicture.value = false;
      }
    }
  }

  Future<bool> _saveProfilePicture() async {
    if (profilePicture != null && profilePicture!.path.isNotEmpty) {
      if (mainMenuOperatorController != null) {
        mainMenuOperatorController!.profileImagePath.value = profilePicture!.path;
        return await mainMenuOperatorController!.sharedPreferences.setString(
          "profile_picture",
          profilePicture!.path,
        );
      } else if (mainMenuFinancialController != null) {
        mainMenuFinancialController!.profileImagePath.value = profilePicture!.path;
        return await mainMenuFinancialController!.sharedPreferences.setString(
          "profile_picture",
          profilePicture!.path,
        );
      } else if (mainMenuAdministratorController != null) {
        mainMenuAdministratorController!.profileImagePath.value = profilePicture!.path;
        return await mainMenuAdministratorController!.sharedPreferences.setString(
          "profile_picture",
          profilePicture!.path,
        );
      } else {
        mainMenuStokistController!.profileImagePath.value = profilePicture!.path;
        return await mainMenuStokistController!.sharedPreferences.setString(
          "profile_picture",
          profilePicture!.path,
        );
      }
    }
    return false;
  }

  Future<bool> _saveUser() async {
    try {
      if (await _userService.editUser(_user!) && await _saveInformations()) {
        return true;
      }
      throw Exception();
    } catch (_) {
      await loadingWithSuccessOrErrorWidget.stopAnimation(fail: true);
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Erro ao atualizar o perfil.\n Tente novamente mais tarde",
          );
        },
      );
      return false;
    }
  }

  confirmationDeleteProfilePicture() async {
    await Future.delayed(Duration(milliseconds: 200));
    await showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return ConfirmationPopup(
          title: "Aviso",
          subTitle: "Tem certeza que deseja apagar a foto de perfil",
          firstButton: () {},
          secondButton: () => _deleteProfilePicture(),
        );
      },
    );
  }

  _deleteProfilePicture() async {
    try {
      await loadingWithSuccessOrErrorWidget.startAnimation();

      if (mainMenuOperatorController != null) {
        imageChanged = await mainMenuOperatorController!.sharedPreferences.remove(
          "profile_picture",
        );
      } else if (mainMenuFinancialController != null) {
        imageChanged = await mainMenuFinancialController!.sharedPreferences.remove(
          "profile_picture",
        );
      } else if (mainMenuAdministratorController != null) {
        imageChanged = await mainMenuAdministratorController!.sharedPreferences.remove(
          "profile_picture",
        );
      } else {
        imageChanged = await mainMenuStokistController!.sharedPreferences.remove(
          "profile_picture",
        );
      }

      await loadingWithSuccessOrErrorWidget.stopAnimation();
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Imagem de perfil apagada com sucesso!",
          );
        },
      );

      if (mainMenuOperatorController != null) {
        await GetProfilePictureController.loadProfilePicture(
          mainMenuOperatorController!.loadingPicture,
          mainMenuOperatorController!.hasPicture,
          mainMenuOperatorController!.profileImagePath,
          mainMenuOperatorController!.sharedPreferences,
        );
      } else if (mainMenuFinancialController != null) {
        await GetProfilePictureController.loadProfilePicture(
          mainMenuFinancialController!.loadingPicture,
          mainMenuFinancialController!.hasPicture,
          mainMenuFinancialController!.profileImagePath,
          mainMenuFinancialController!.sharedPreferences,
        );
      } else if (mainMenuAdministratorController != null) {
        await GetProfilePictureController.loadProfilePicture(
          mainMenuAdministratorController!.loadingPicture,
          mainMenuAdministratorController!.hasPicture,
          mainMenuAdministratorController!.profileImagePath,
          mainMenuAdministratorController!.sharedPreferences,
        );
      } else {
        await GetProfilePictureController.loadProfilePicture(
          mainMenuStokistController!.loadingPicture,
          mainMenuStokistController!.hasPicture,
          mainMenuStokistController!.profileImagePath,
          mainMenuStokistController!.sharedPreferences,
        );
      }
    } catch (_) {
      await loadingWithSuccessOrErrorWidget.stopAnimation(fail: true);
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Erro ao apagar a foto de perfil.\n Tente novamente mais tarde",
          );
        },
      );
    }
  }

  editProfilePicture() async {
    await Future.delayed(Duration(milliseconds: 200));
    await showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return ConfirmationPopup(
          title: "Aviso",
          subTitle: "Escolha o método desejado para adicionar a foto de perfil!",
          firstButtonText: "GALERIA",
          secondButtonText: "CÂMERA",
          firstButton: () async => await getProfileImage(imageOrigin.gallery),
          secondButton: () async => await getProfileImage(imageOrigin.camera),
        );
      },
    );
  }
}
