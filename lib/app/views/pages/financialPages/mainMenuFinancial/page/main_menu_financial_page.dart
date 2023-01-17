import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/paths.dart';
import '../../../widgetsShared/shimmer/default_menu_shimmer.dart';
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
        DefaultMenuShimmer(
          pageTitle: "CENTRAL TESOURARIA",
          firstCardIconPath: Paths.Money,
          firstCardText: "Quantidade no Cofre: ",
          secondCardIconPath: Paths.Malote,
          secondCardText: "Quantidade de Malotes: ",
        ) :
        MainMenuFinancialAfterLoadWidget(),
      ),
    );
  }
}
