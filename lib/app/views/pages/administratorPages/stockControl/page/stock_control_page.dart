import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../widgetsShared/shimmer/default_shimmer.dart';
import '../controller/stock_control_controller.dart';
import '../widget/stock_control_after_load_widget.dart';

class StockControlPage extends StatefulWidget {
  const StockControlPage({Key? key}) : super(key: key);

  @override
  State<StockControlPage> createState() => _StockControlPageState();
}

class _StockControlPageState extends State<StockControlPage> {
  late final StockControlController controller;
  @override
  void initState() {
    controller = Get.put(StockControlController(), tag: "stock-control-controller");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => controller.screenLoading.value
            ? DefaultShimmer(
                pageTitle: "Controle de Estoque",
                mainCardSize: 3.h,
                cardsSize: 10.h,
              )
            : StockControlAfterLoadWidget(),
      ),
    );
  }
}
