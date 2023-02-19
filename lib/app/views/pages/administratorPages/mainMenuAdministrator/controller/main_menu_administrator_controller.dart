import 'package:carousel_slider/carousel_controller.dart';
import 'package:elephant_control/base/models/user/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../../base/services/interfaces/imoney_pouch_service.dart';
import '../../../../../../base/services/interfaces/ivisit_service.dart';
import '../../../../../../base/services/money_pouch_service.dart';
import '../../../../../../base/services/visit_service.dart';
import '../../../../../../base/viewControllers/safe_box_financial_viewcontroller.dart';
import '../../../../../../base/viewControllers/total_main_menu_operator_view_controller.dart';
import '../../../../../utils/get_profile_picture_controller.dart';
import '../../../../../utils/logged_user.dart';
import '../../../../../utils/paths.dart';
import '../../../widgetsShared/popups/confirmation_popup.dart';
import '../widgets/card_main_menu_administrator_widget.dart';

class MainMenuAdministratorController extends GetxController {
  late int activeStep;
  late RxInt visitsQuantity;
  late RxInt incidentQuantity;
  late int pouchQuantityWithOperators;
  late int pouchQuantityWithFinancial;
  late double fullValuePouchOperators;
  late double fullValuePouchFinancial;
  late double allSafeBoxAmount;
  late RxBool hasPicture;
  late RxBool loadingPicture;
  late RxBool screenLoading;
  late RxString profileImagePath;
  late RxString nameProfile;
  late RxString nameInitials;
  late RxString welcomePhrase;
  late RxDouble safeBoxAmount;
  late RxInt pouchQuantity;
  late DateTime pouchLastChange;
  late DateTime teddyLastChange;
  late SharedPreferences sharedPreferences;
  late List<TotalMainMenuOperatorViewcontroller> operatorVisitList;
  late RxList<CardMainMenuAdministratorWidget> cardMainMenuAdministratorList;
  late CarouselController carouselController;
  late IVisitService _visitService;
  late IMoneyPouchService _moneyPouchService;

  MainMenuAdministratorController() {
    _initializeVariables();
    _getNameUser();
    _getWelcomePhrase();
  }

  @override
  void onInit() async {
    sharedPreferences = await SharedPreferences.getInstance();
    await loadScreen();
    await _checkFingerPrintUser();
    super.onInit();
  }

  _initializeVariables() {
    activeStep = 0;
    visitsQuantity = 0.obs;
    incidentQuantity = 0.obs;
    pouchQuantityWithOperators = 0;
    pouchQuantityWithFinancial = 0;
    fullValuePouchOperators = 0.0;
    fullValuePouchFinancial = 0.0;
    allSafeBoxAmount = 0.0;
    screenLoading = false.obs;
    hasPicture = false.obs;
    loadingPicture = true.obs;
    profileImagePath = "".obs;
    nameProfile = "".obs;
    nameInitials = "".obs;
    safeBoxAmount = 15689.00.obs;
    pouchQuantity = 5.obs;
    pouchLastChange = DateTime.now();
    teddyLastChange = DateTime.now();
    carouselController = CarouselController();
    operatorVisitList = <TotalMainMenuOperatorViewcontroller>[];
    cardMainMenuAdministratorList = [
      CardMainMenuAdministratorWidget(
        firstText: "Total Visitas no dia: ",
        secondText: "0",
        complementFirstText: "Ocorrências no dia: ",
        complementSecondText: "0",
        thirdText: "Última Máquina Visitada: ",
        fourthText: "Sem Registro",
        imagePath: Paths.Manutencao,
      ),
      CardMainMenuAdministratorWidget(
        firstText: "Total Malotes com Operadores: ",
        secondText: "0",
        thirdText: "Valor Total: ",
        fourthText: "R\$ 0,00",
        imagePath: Paths.Malote,
      ),
      CardMainMenuAdministratorWidget(
        firstText: "Total Malotes com Tesouraria: ",
        secondText: "0",
        thirdText: "Valor Total: ",
        fourthText: "R\$ 0,00",
        imagePath: Paths.Malote_Com_Tesouraria,
      ),
      CardMainMenuAdministratorWidget(
        firstText: "Valor Total dos Cofres: ",
        secondText: "R\$ 0,00",
        imagePath: Paths.Cofre,
      ),
    ].obs;
    _visitService = VisitService();
    _moneyPouchService = MoneyPouchService();
  }

  loadScreen() async {
    loadingPicture.value = true;
    screenLoading.value = true;
    await GetProfilePictureController.loadProfilePicture(
      loadingPicture,
      hasPicture,
      profileImagePath,
      sharedPreferences,
    );
    await getVisitsUser();
    await _getPouchUser();
    await _getSafeBoxValue();
    screenLoading.value = false;
  }

  getVisitsUser() async {
    try {
      visitsQuantity.value = 0;
      incidentQuantity.value = 0;
      operatorVisitList = (await _visitService.getTotalMainMenuAdmin());

      operatorVisitList.sort((a, b) => a.inclusion.compareTo(b.inclusion));

      visitsQuantity.value = operatorVisitList.length;
      incidentQuantity.value = operatorVisitList.where((element) => element.hasIncident).length;
    } catch (_) {
      incidentQuantity.value = 0;
      visitsQuantity.value = 0;
    }
  }

  _getPouchUser() async {
    try {
      fullValuePouchOperators = 0.0;
      fullValuePouchFinancial = 0.0;
      pouchQuantityWithOperators = 0;
      pouchQuantityWithFinancial = 0;

      var moneyPouchOperator = await _moneyPouchService.getAllPouchInformation(UserType.operator);
      var moneyPouchFinancial = await _moneyPouchService.getAllPouchInformation(UserType.treasury);

      if (moneyPouchOperator != null && moneyPouchFinancial != null) {
        fullValuePouchOperators = moneyPouchOperator.fullValue;
        pouchQuantityWithOperators = moneyPouchOperator.moneyPouchValueList.length;
        fullValuePouchFinancial = moneyPouchFinancial.fullValue;
        pouchQuantityWithFinancial = moneyPouchFinancial.moneyPouchValueList.length;
      }
    } catch (_) {
      fullValuePouchOperators = 0.0;
      fullValuePouchFinancial = 0.0;
      pouchQuantityWithOperators = 0;
      pouchQuantityWithFinancial = 0;
    }
  }

  _getSafeBoxValue() async {
    try {
      allSafeBoxAmount = 0.0;

      List<SafeBoxFinancialViewController> safeBoxHistoryList = await _visitService.getVisitsOfFinancialByUserId(
        null,
      );

      safeBoxHistoryList.forEach((element) {
        allSafeBoxAmount += element.moneyWithDrawalQuantity ?? 0;
      });
    } catch (_) {
      allSafeBoxAmount = 0.0;
    }
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
      showDialog(
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
}
