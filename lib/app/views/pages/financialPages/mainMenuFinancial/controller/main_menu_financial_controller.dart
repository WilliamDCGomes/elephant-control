import 'package:carousel_slider/carousel_controller.dart';
import 'package:elephant_control/base/models/user/user.dart';
import 'package:elephant_control/base/services/money_pouch_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../../base/services/interfaces/imoney_pouch_service.dart';
import '../../../../../utils/date_format_to_brazil.dart';
import '../../../../../utils/format_numbers.dart';
import '../../../../../utils/get_profile_picture_controller.dart';
import '../../../../../utils/logged_user.dart';
import '../../../../../utils/paths.dart';
import '../../../administratorPages/mainMenuAdministrator/widgets/card_main_menu_administrator_widget.dart';
import '../../../widgetsShared/popups/confirmation_popup.dart';

class MainMenuFinancialController extends GetxController {
  late int activeStep;
  late int pouchQuantityWithOperators;
  late RxBool hasPicture;
  late RxBool loadingPicture;
  late RxBool screenLoading;
  late RxString profileImagePath;
  late RxString nameProfile;
  late RxString nameInitials;
  late RxString welcomePhrase;
  late RxDouble safeBoxAmount;
  late RxInt pouchQuantity;
  late DateTime quantityLastUpdate;
  late DateTime valueLastUpdate;
  late SharedPreferences sharedPreferences;
  late RxBool _isLoadingQuantity;
  late CarouselController carouselController;
  late IMoneyPouchService _moneyPouchService;
  late RxList<CardMainMenuAdministratorWidget> cardMainMenuAdministratorList;

  MainMenuFinancialController() {
    _initializeVariables();
  }
  //Getters
  bool get isLoadingQuantity => _isLoadingQuantity.value;

  @override
  void onInit() async {
    sharedPreferences = await SharedPreferences.getInstance();
    await loadScreen();
    await _checkFingerPrintUser();
    super.onInit();
  }

  _initializeVariables() {
    activeStep = 0;
    pouchQuantityWithOperators = 0;
    hasPicture = false.obs;
    loadingPicture = true.obs;
    screenLoading = true.obs;
    profileImagePath = "".obs;
    nameProfile = "".obs;
    nameInitials = "".obs;
    safeBoxAmount = 0.0.obs;
    pouchQuantity = 0.obs;
    quantityLastUpdate = DateTime.now();
    valueLastUpdate = DateTime.now();
    _isLoadingQuantity = false.obs;
    carouselController = CarouselController();
    _moneyPouchService = MoneyPouchService();
    cardMainMenuAdministratorList = [
      CardMainMenuAdministratorWidget(
        firstText: "Quantidade no Cofre: ",
        secondText: "R\$ 0,00",
        thirdText: "Última Atualização: ",
        fourthText: DateFormatToBrazil.formatDateAndHour(DateTime.now()),
        imagePath: Paths.Money,
      ),
      CardMainMenuAdministratorWidget(
        firstText: "Quantidade de Malotes: ",
        secondText: "0",
        thirdText: "Última Atualização: ",
        fourthText: DateFormatToBrazil.formatDateAndHour(DateTime.now()),
        imagePath: Paths.Malote_Com_Tesouraria,
      ),
      CardMainMenuAdministratorWidget(
        firstText: "Total Malotes com os Operadores: ",
        secondText: "0",
        imagePath: Paths.Malote,
      ),
    ].obs;
  }

  _getPouchUser() async {
    try {
      pouchQuantityWithOperators = 0;

      var moneyPouchOperator = await _moneyPouchService.getAllPouchInformation(UserType.operator);

      if (moneyPouchOperator != null) {
        pouchQuantityWithOperators = moneyPouchOperator.moneyPouchValueList.length;
      }
    } catch (_) {
      pouchQuantityWithOperators = 0;
    }
  }

  loadScreen() async {
    loadingPicture.value = true;
    screenLoading.value = true;
    _getNameUser();
    _getWelcomePhrase();
    await getQuantityData();
    await _getPouchUser();
    await _loadCards();
    await GetProfilePictureController.loadProfilePicture(
      loadingPicture,
      hasPicture,
      profileImagePath,
      sharedPreferences,
    );
    screenLoading.value = false;
  }

  _loadCards() {
    cardMainMenuAdministratorList.value = [
      CardMainMenuAdministratorWidget(
        firstText: "Quantidade no Cofre: ",
        secondText: FormatNumbers.numbersToMoney(safeBoxAmount.value),
        thirdText: "Última Atualização: ",
        fourthText: DateFormatToBrazil.formatDateAndHour(valueLastUpdate),
        imagePath: Paths.Money,
      ),
      CardMainMenuAdministratorWidget(
        firstText: "Quantidade de Malotes: ",
        secondText: FormatNumbers.scoreIntNumber(pouchQuantity.value),
        thirdText: "Última Atualização: ",
        fourthText: DateFormatToBrazil.formatDateAndHour(quantityLastUpdate),
        imagePath: Paths.Malote_Com_Tesouraria,
      ),
      CardMainMenuAdministratorWidget(
        firstText: "Total Malotes com os Operadores: ",
        secondText: FormatNumbers.scoreIntNumber(pouchQuantityWithOperators),
        imagePath: Paths.Malote,
      ),
    ];
  }

  _getNameUser() {
    switch (LoggedUser.userType) {
      case UserType.admin:
        LoggedUser.userTypeName = "ADMINISTRATIVO";
        break;
      case UserType.treasury:
        LoggedUser.userTypeName = "TESOURARIA";
        break;
      case UserType.stockist:
        LoggedUser.userTypeName = "ESTOQUISTA";
        break;
      case UserType.operator:
      default:
        LoggedUser.userTypeName = "OPERADOR";
        break;
    }
    var names = LoggedUser.name.trim().split(" ");

    if (names.isNotEmpty && names.first != "") {
      nameProfile.value = names[0];
      LoggedUser.nameAndLastName = names[0];
      nameInitials.value = nameProfile.value[0];
      if (names.length > 1 && names.last != "") {
        nameInitials.value += names.last[0];
        LoggedUser.nameAndLastName += " ${names.last}";
      }
      LoggedUser.nameInitials = nameInitials.value;
    }
  }

  _getWelcomePhrase() {
    int currentHour = DateTime.now().hour;
    if (currentHour >= 0 && currentHour < 12)
      welcomePhrase = "Bom dia!".obs;
    else if (currentHour >= 12 && currentHour < 18)
      welcomePhrase = "Boa tarde!".obs;
    else
      welcomePhrase = "Boa noite!".obs;
  }

  _checkFingerPrintUser() async {
    bool? useFingerPrint = await sharedPreferences.getBool("user_finger_print");
    if (useFingerPrint == null && await LocalAuthentication().canCheckBiometrics) {
      await showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ConfirmationPopup(
            title: "Aviso",
            subTitle: "Deseja habilitar o login por digital?",
            firstButton: () async => await sharedPreferences.setBool("user_finger_print", false),
            secondButton: () async => await sharedPreferences.setBool("user_finger_print", true),
          );
        },
      );
    }
  }

  Future<void> getQuantityData() async {
    try {
      _isLoadingQuantity.value = true;
      final moneyPouch = await MoneyPouchService().getMoneyPouchValue();
      if (moneyPouch == null) throw Exception();
      pouchQuantity.value = moneyPouch.quantity;
      quantityLastUpdate = moneyPouch.lastUpdateQuantity;
      valueLastUpdate = moneyPouch.lastUpdateValue;
      safeBoxAmount.value = moneyPouch.value;
    } catch (_) {
    } finally {
      _isLoadingQuantity.value = false;
    }
  }
}
