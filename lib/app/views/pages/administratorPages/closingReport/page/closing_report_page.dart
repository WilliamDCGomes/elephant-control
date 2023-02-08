import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../widgetsShared/shimmer/default_shimmer.dart';
import '../controller/closing_report_controller.dart';
import '../widgets/closing_report_after_load_widget.dart';

class ClosingReportPage extends StatefulWidget {
  const ClosingReportPage({Key? key}) : super(key: key);

  @override
  State<ClosingReportPage> createState() => _ClosingReportPageState();
}

class _ClosingReportPageState extends State<ClosingReportPage> {
  late ClosingReportController controller;

  @override
  void initState() {
    controller = Get.put(ClosingReportController(), tag: "closing-report-controller");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => controller.screenLoading.value ?
        DefaultShimmer(
          pageTitle: "Relatório de Fechamento",
          showSecondFilterField: true,
          showThirdFilterField: true,
          showButton: true,
          mainCardSize: 4.h,
          cardsSize: 10.h,
        ) :
        ClosingReportAfterLoadWidget(),
      ),
    );
  }
}