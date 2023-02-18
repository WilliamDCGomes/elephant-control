import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../administratorPages/mainMenuAdministrator/shimmer/main_menu_administrator_shimmer.dart';
import '../controller/main_menu_financial_controller.dart';
import '../widget/main_menu_financial_after_load_widget.dart';

class MainMenuFinancialPage extends StatefulWidget {
  const MainMenuFinancialPage({Key? key}) : super(key: key);

  @override
  State<MainMenuFinancialPage> createState() => _MainMenuFinancialPageState();
}

class _MainMenuFinancialPageState extends State<MainMenuFinancialPage> {
  late MainMenuFinancialController controller;

  @override
  void initState() {
    controller = Get.put(MainMenuFinancialController(), tag: "main_menu_financial_controller");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => controller.screenLoading.value ?
        MainMenuAdministratorShimmer(
          pageTitle: "CENTRAL TESOURARIA",
          showJust3Itens: true,
        ) :
        MainMenuFinancialAfterLoadWidget(),
      ),
    );
  }
}
