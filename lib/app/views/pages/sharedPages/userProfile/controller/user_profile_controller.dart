import 'package:elephant_control/app/enums/enums.dart';
import 'package:elephant_control/base/services/consult_cep_service.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../../../../base/models/addressInformation/model/address_information.dart';
import '../../../../../../base/models/user/model/user.dart';
import '../../../../../../base/services/interfaces/iconsult_cep_service.dart';
import '../../../../../utils/brazil_address_informations.dart';
import '../../../../../utils/get_profile_picture_controller.dart';
import '../../../../../utils/internet_connection.dart';
import '../../../../../utils/logged_user.dart';
import '../../../../../utils/masks_for_text_fields.dart';
import '../../../../../utils/text_field_validators.dart';
import '../../../../../utils/valid_cellphone_mask.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../administratorPages/mainMenuAdministrator/controller/main_menu_administrator_controller.dart';
import '../../../financialPages/mainMenuFinancial/controller/main_menu_financial_controller.dart';
import '../../../operatorPages/mainMenuOperator/controller/main_menu_operator_controller.dart';
import '../../../operatorPages/mainMenuOperator/page/main_menu_operator_page.dart';
import '../../../widgetsShared/loading_profile_picture_widget.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/popups/confirmation_popup.dart';
import '../../../widgetsShared/popups/information_popup.dart';
import '../../../widgetsShared/snackbar_widget.dart';
import '../widget/user_profile_tabs_widget.dart';

class UserProfileController extends GetxController {
  late bool imageChanged;
  late RxString nameInitials;
  late RxString userName;
  late RxString ufSelected;
  late RxString buttonText;
  late RxString genderSelected;
  late RxBool currentPasswordFieldEnabled;
  late RxBool newPasswordFieldEnabled;
  late RxBool confirmNewPasswordFieldEnabled;
  late RxBool profileIsDisabled;
  late RxBool loadingAnimation;
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
  late User _user;
  late LoadingProfilePictureWidget loadingProfilePicture;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late MainMenuOperatorController? mainMenuOperatorController;
  late MainMenuFinancialController? mainMenuFinancialController;
  late MainMenuAdministratorController? mainMenuAdministratorController;
  late IConsultCepService _consultCepService;

  UserProfileController(this.mainMenuOperatorController, this.mainMenuFinancialController, this.mainMenuAdministratorController) {
    _initializeVariables();
    _initializeLists();
  }

  @override
  void onInit() async {
    await _getUfsNames();
    _getUserInformation();
    super.onInit();
  }

  _initializeVariables() {
    imageChanged = false;
    nameInitials = LoggedUser.nameInitials.obs;
    userName = LoggedUser.nameAndLastName.obs;
    ufSelected = "".obs;
    buttonText = "EDITAR".obs;
    genderSelected = "".obs;
    profileIsDisabled = true.obs;
    loadingAnimation = false.obs;
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
      loadingAnimation: mainMenuOperatorController != null ?
      mainMenuOperatorController!.loadingPicture :
      mainMenuFinancialController != null ?
      mainMenuFinancialController!.loadingPicture :
      mainMenuAdministratorController!.loadingPicture,
    );
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget(
      loadingAnimation: loadingAnimation,
    );
    _user = User.emptyConstructor();
    _consultCepService = ConsultCepService();
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

  _getUserInformation() {
    nameTextController.text = LoggedUser.name;
    birthDateTextController.text = LoggedUser.birthdate;
    genderSelected.value = LoggedUser.gender;
    cpfTextController.text = LoggedUser.cpf;
    cepTextController.text = LoggedUser.cep;
    cityTextController.text = LoggedUser.city;
    streetTextController.text = LoggedUser.street;
    houseNumberTextController.text = LoggedUser.houseNumber.toString();
    neighborhoodTextController.text = LoggedUser.neighborhood;
    complementTextController.text = LoggedUser.complement;
    phoneTextController.text = LoggedUser.phone ?? "";
    cellPhoneTextController.text = LoggedUser.cellPhone ?? "";
    emailTextController.text = LoggedUser.email;
    confirmEmailTextController.text = LoggedUser.email;
    ufSelected.value = LoggedUser.uf;
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
    _user.name = nameTextController.text;
    // _user.birthdate = birthDateTextController.text;
    // _user.gender = genderSelected.value;
    // _user.cep = cepTextController.text;
    // _user.uf = ufSelected.value;
    // _user.city = cityTextController.text;
    // _user.street = streetTextController.text;
    // _user.houseNumber = houseNumberTextController.text;
    // _user.neighborhood = neighborhoodTextController.text;
    // _user.complement = complementTextController.text;
    // _user.phone = phoneTextController.text;
    // _user.cellPhone = cellPhoneTextController.text;
    // _user.email = emailTextController.text;
    _user.id = LoggedUser.id;
    // _user.cpf = LoggedUser.cpf;
    // _user.includeDate = LoggedUser.includeDate;
    // _user.lastChange = DateTime.now();
  }

  _updateLocaleUser() {
    // nameTextController.text = _user.name;
    // birthDateTextController.text = _user.birthdate;
    // genderSelected.value = _user.gender;
    // cepTextController.text = _user.cep;
    // ufSelected.value = _user.uf;
    // cityTextController.text = _user.city;
    // streetTextController.text = _user.street;
    // houseNumberTextController.text = _user.houseNumber ?? "";
    // neighborhoodTextController.text = _user.neighborhood;
    // complementTextController.text = _user.complement;
    // phoneTextController.text = _user.phone ?? "";
    // cellPhoneTextController.text = _user.cellPhone ?? "";
    // emailTextController.text = _user.email;
    // LoggedUser.id = _user.id;
    // LoggedUser.cpf = _user.cpf;
    // LoggedUser.includeDate = _user.includeDate;
  }

  editButtonPressed() async {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    if (profileIsDisabled.value) {
      buttonText.value = "SALVAR";
      profileIsDisabled.value = false;
    } else {
      loadingAnimation.value = true;
      await loadingWithSuccessOrErrorWidget.startAnimation();

      await Future.delayed(Duration(seconds: 1));

      if (!await InternetConnection.validInternet(
        "É necessário uma conexão com a internet para fazer o cadastro",
        loadingAnimation,
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
          _updateLocaleUser();
          buttonText.value = "EDITAR";
          profileIsDisabled.value = true;
          Get.offAll(() => MainMenuOperatorPage());
        }
      }
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

      String? neighborhoodValidation = TextFieldValidators.standardValidation(neighborhoodTextController.text, "Informe o Bairro");
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
      if(mainMenuOperatorController != null){
        mainMenuOperatorController!.loadingPicture.value = true;
      }
      else if(mainMenuFinancialController != null){
        mainMenuFinancialController!.loadingPicture.value = true;
      }
      else{
        mainMenuAdministratorController!.loadingPicture.value = true;
      }

      profilePicture = await _picker.pickImage(source: origin == imageOrigin.camera ? ImageSource.camera : ImageSource.gallery);
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
      if(mainMenuOperatorController != null){
        mainMenuOperatorController!.loadingPicture.value = false;
      }
      else if(mainMenuFinancialController != null){
        mainMenuFinancialController!.loadingPicture.value = false;
      }
      else{
        mainMenuAdministratorController!.loadingPicture.value = false;
      }
    }
  }

  Future<bool> _saveProfilePicture() async {
    if (profilePicture != null && profilePicture!.path.isNotEmpty) {
      if(mainMenuOperatorController != null){
        mainMenuOperatorController!.profileImagePath.value = profilePicture!.path;
        return await mainMenuOperatorController!.sharedPreferences.setString(
          "profile_picture",
          profilePicture!.path,
        );
      }
      else if(mainMenuFinancialController != null){
        mainMenuFinancialController!.profileImagePath.value = profilePicture!.path;
        return await mainMenuFinancialController!.sharedPreferences.setString(
          "profile_picture",
          profilePicture!.path,
        );
      }
      else{
        mainMenuAdministratorController!.profileImagePath.value = profilePicture!.path;
        return await mainMenuAdministratorController!.sharedPreferences.setString(
          "profile_picture",
          profilePicture!.path,
        );
      }
    }
    return false;
  }

  Future<bool> _saveUser() async {
    int trys = 0;

    while (true) {
      try {
        //if(await _userService.updateUser(user)) {
        if (true) {
          return true;
        } else {
          throw Exception();
        }
      } catch (_) {
        if (trys < 2) {
          trys++;
          continue;
        }
        await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
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
      loadingAnimation.value = true;
      await loadingWithSuccessOrErrorWidget.startAnimation();

      if(mainMenuOperatorController != null){
        imageChanged = await mainMenuOperatorController!.sharedPreferences.remove(
          "profile_picture",
        );
      }
      else if(mainMenuFinancialController != null){
        imageChanged = await mainMenuFinancialController!.sharedPreferences.remove(
          "profile_picture",
        );
      }
      else{
        imageChanged = await mainMenuAdministratorController!.sharedPreferences.remove(
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

      if(mainMenuOperatorController != null){
        await GetProfilePictureController.loadProfilePicture(
          mainMenuOperatorController!.loadingPicture,
          mainMenuOperatorController!.hasPicture,
          mainMenuOperatorController!.profileImagePath,
          mainMenuOperatorController!.sharedPreferences,
        );
      }
      else if(mainMenuFinancialController != null){
        await GetProfilePictureController.loadProfilePicture(
          mainMenuFinancialController!.loadingPicture,
          mainMenuFinancialController!.hasPicture,
          mainMenuFinancialController!.profileImagePath,
          mainMenuFinancialController!.sharedPreferences,
        );
      }
      else{
        await GetProfilePictureController.loadProfilePicture(
          mainMenuAdministratorController!.loadingPicture,
          mainMenuAdministratorController!.hasPicture,
          mainMenuAdministratorController!.profileImagePath,
          mainMenuAdministratorController!.sharedPreferences,
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
