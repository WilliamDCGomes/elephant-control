import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../widgetsShared/shimmer/default_shimmer.dart';
import '../controller/operetors_visit_period_filter_controller.dart';
import '../widget/operetors_visit_period_filter_after_load_widget.dart';

class OperatorsVisitsPeriodFilterPage extends StatefulWidget {
  const OperatorsVisitsPeriodFilterPage({Key? key}) : super(key: key);

  @override
  State<OperatorsVisitsPeriodFilterPage> createState() => _OperatorsVisitsPeriodFilterPageState();
}

class _OperatorsVisitsPeriodFilterPageState extends State<OperatorsVisitsPeriodFilterPage> {
  late OperatorsVisitsPeriodFilterController controller;

  @override
  void initState() {
    controller = Get.put(OperatorsVisitsPeriodFilterController(), tag: "operators-visits-period-filter-controller");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => controller.screenLoading.value ?
        DefaultShimmer(
          pageTitle: "Visitas dos Operadores",
          showSecondFilterField: true,
          showButton: true,
          mainCardSize: 18.h,
          cardsSize: 10.h,
        ) :
        OperatorsVisitsPeriodFilterAfterLoadWidget(),
      ),
    );
  }
}