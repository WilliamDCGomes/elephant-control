import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/paths.dart';
import '../../../widgetsShared/shimmer/default_menu_shimmer.dart';
import '../controller/main_menu_operator_controller.dart';
import '../widget/main_menu_operator_after_load_widget.dart';

class MainMenuOperatorPage extends StatefulWidget {
  const MainMenuOperatorPage({Key? key}) : super(key: key);

  @override
  State<MainMenuOperatorPage> createState() => _MainMenuOperatorPageState();
}

class _MainMenuOperatorPageState extends State<MainMenuOperatorPage> {
  late MainMenuOperatorController controller;

  @override
  void initState() {
    controller = Get.put(MainMenuOperatorController(), tag: "main-menu-operator-controller");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => controller.screenLoading.value ?
        DefaultMenuShimmer(
          pageTitle: "CENTRAL OPERADOR",
          firstCardIconPath: Paths.Malote,
          firstCardText: "Quantidade de Malote(s): ",
          secondCardIconPath: Paths.Pelucia,
          secondCardText: "Saldo de Pelúcias: ",
        ) :
        MainMenuOperatorAfterLoadWidget(),
      ),
    );
  }
}
