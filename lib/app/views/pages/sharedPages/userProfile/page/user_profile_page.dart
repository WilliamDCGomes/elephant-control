import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../administratorPages/mainMenuAdministrator/controller/main_menu_administrator_controller.dart';
import '../../../financialPages/mainMenuFinancial/controller/main_menu_financial_controller.dart';
import '../../../operatorPages/mainMenuOperator/controller/main_menu_operator_controller.dart';
import '../../../stockistPages/mainMenuStokist/controller/main_menu_stokist_controller.dart';
import '../controller/user_profile_controller.dart';
import '../shimmer/user_profile_shimmer.dart';
import '../widgets/user_profile_after_load_wdiget.dart';

class UserProfilePage extends StatefulWidget {
  late final MainMenuOperatorController? mainMenuOperatorController;
  late final MainMenuFinancialController? mainMenuFinancialController;
  late final MainMenuAdministratorController? mainMenuAdministratorController;
  late final MainMenuStokistController? mainMenuStokistController;

  UserProfilePage({
    Key? key,
    this.mainMenuOperatorController,
    this.mainMenuFinancialController,
    this.mainMenuAdministratorController,
    this.mainMenuStokistController,
  }) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> with SingleTickerProviderStateMixin {
  late UserProfileController controller;

  @override
  void initState() {
    controller = Get.put(
      UserProfileController(
        widget.mainMenuOperatorController,
        widget.mainMenuFinancialController,
        widget.mainMenuAdministratorController,
        widget.mainMenuStokistController,
      ),
      tag: 'user_profile_controller',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => controller.screenLoading.value ?
        UserProfileShimmer() :
        UserProfileAfterLoadWidget(
          mainMenuAdministratorController: widget.mainMenuAdministratorController,
          mainMenuFinancialController: widget.mainMenuFinancialController,
          mainMenuOperatorController: widget.mainMenuOperatorController,
          mainMenuStokistController: widget.mainMenuStokistController,
        ),
      ),
    );
  }
}