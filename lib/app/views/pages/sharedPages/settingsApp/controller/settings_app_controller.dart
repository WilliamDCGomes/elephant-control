import 'package:elephant_control/app/enums/enums.dart';
import 'package:elephant_control/app/views/stylePages/app_colors.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import '../../../../../utils/paths.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widget/card_profile_tab_list_widget.dart';

class SettingsAppController extends GetxController {
  late SharedPreferences sharedPreferences;
  late final LocalAuthentication fingerPrintAuth;
  late RxList<CardProfileTabListWidget> cardSettingsList;

  SettingsAppController(){
    _initializeVariables();
    _initializeList();
  }

  @override
  void onInit() async {
    sharedPreferences = await SharedPreferences.getInstance();
    super.onInit();
  }

  _initializeVariables(){
    cardSettingsList = <CardProfileTabListWidget>[].obs;
    fingerPrintAuth = LocalAuthentication();
  }

  _initializeList() async {
    if(await fingerPrintAuth.canCheckBiometrics){
      cardSettingsList.add(
        CardProfileTabListWidget(
          iconCard: Image.asset(
            Paths.Icone_Configuracao_Biometria,
            height: 4.5.h,
            width: 4.5.h,
            color: AppColors.defaultColor,
          ),
          titleIconPath: "Configuração da Digital",
          page: destinationsPages.fingerPrintSetting,
        ),
      );
    }
    cardSettingsList.add(
      CardProfileTabListWidget(
        iconCard: Image.asset(
          Paths.Icone_Redefinir_Senha,
          height: 4.5.h,
          width: 4.5.h,
          color: AppColors.defaultColor,
        ),
        titleIconPath: "Redefinir Senha",
        page: destinationsPages.resetPassword,
      ),
    );
  }
}