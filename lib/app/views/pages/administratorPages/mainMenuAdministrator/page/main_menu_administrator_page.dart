import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/main_menu_administrator_controller.dart';
import '../shimmer/main_menu_administrator_shimmer.dart';
import '../widgets/main_menu_administrator_after_load_widget.dart';

class MainMenuAdministratorPage extends StatefulWidget {
  const MainMenuAdministratorPage({Key? key}) : super(key: key);

  @override
  State<MainMenuAdministratorPage> createState() => _MainMenuAdministratorPageState();
}

class _MainMenuAdministratorPageState extends State<MainMenuAdministratorPage> {
  late MainMenuAdministratorController controller;

  @override
  void initState() {
    controller = Get.put(MainMenuAdministratorController(), tag: "main_menu_administrator_controller");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => controller.screenLoading.value ?
        MainMenuAdministratorShimmer() :
        MainMenuAdministratorAfterLoadWidget(),
      ),
    );
  }
}
