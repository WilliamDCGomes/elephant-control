import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../widgetsShared/shimmer/default_shimmer.dart';
import '../controller/operators_visits_controller.dart';
import '../widgets/operators_visits_after_load_widget.dart';

class OperatorsVisitsPage extends StatefulWidget {
  const OperatorsVisitsPage({Key? key}) : super(key: key);

  @override
  State<OperatorsVisitsPage> createState() => _OperatorsVisitsPageState();
}

class _OperatorsVisitsPageState extends State<OperatorsVisitsPage> {
  late OperatorsVisitsController controller;

  @override
  void initState() {
    controller = Get.put(OperatorsVisitsController(), tag: "operators-visits-controller");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => controller.screenLoading.value ?
        DefaultShimmer(
          pageTitle: "Visitas dos Operadores",
          showSecondFilterFild: true,
          showButton: true,
          mainCardSize: 18.h,
          cardsSize: 10.h,
        ) :
        OperatorsVisitsAfterLoadWidget(),
      ),
    );
  }
}