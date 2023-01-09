import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get/get.dart';
import '../../../widgetsShared/shimmer/default_shimmer.dart';
import '../controller/recall_money_controller.dart';
import '../widget/recall_money_after_load_widget.dart';

class RecallMoneyPage extends StatefulWidget {
  const RecallMoneyPage({super.key});

  @override
  State<RecallMoneyPage> createState() => _RecallMoneyPageState();
}

class _RecallMoneyPageState extends State<RecallMoneyPage> {
  late final RecallMoneyController controller;
  @override
  void initState() {
    controller = Get.put(RecallMoneyController(), tag: "recall-money-controller");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => controller.screenLoading.value ?
        DefaultShimmer(
          pageTitle: "Recolher Dinheiro",
          mainCardSize: 3.h,
          cardsSize: 10.h,
        ) :
        RecallMoneyAfterLoadWidget(),
      ),
    );
  }
}
