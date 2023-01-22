import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/paths.dart';
import '../../../widgetsShared/shimmer/default_menu_shimmer.dart';
import '../controller/main_menu_stokist_controller.dart';
import '../widget/main_menu_stokist_after_load_widget.dart';

class MainMenuStokistPage extends StatefulWidget {
  const MainMenuStokistPage({Key? key}) : super(key: key);

  @override
  State<MainMenuStokistPage> createState() => _MainMenuStokistPageState();
}

class _MainMenuStokistPageState extends State<MainMenuStokistPage> {
  late MainMenuStokistController controller;

  @override
  void initState() {
    controller = Get.put(MainMenuStokistController(), tag: "main_menu_stokist_controller");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => controller.screenLoading.value
            ? DefaultMenuShimmer(
                pageTitle: "CENTRAL ESTOQUISTA",
                firstCardIconPath: Paths.Money,
                firstCardText: "Quantidade no Cofre: ",
                secondCardIconPath: Paths.Malote,
                secondCardText: "Quantidade de Malotes: ",
              )
            : MainMenuStokistAfterLoadWidget(),
      ),
    );
  }
}
