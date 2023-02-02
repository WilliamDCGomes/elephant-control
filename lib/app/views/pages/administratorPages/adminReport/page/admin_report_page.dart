import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../widgetsShared/shimmer/default_shimmer.dart';
import '../controller/admin_report_controller.dart';
import '../widgets/admin_report_after_load_widget.dart';

class AdminReportPage extends StatefulWidget {
  const AdminReportPage({Key? key}) : super(key: key);

  @override
  State<AdminReportPage> createState() => _AdminReportPageState();
}

class _AdminReportPageState extends State<AdminReportPage> {
  late AdminReportController controller;

  @override
  void initState() {
    controller = Get.put(AdminReportController(), tag: "admin-report-controller");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => controller.screenLoading.value ?
        DefaultShimmer(
          pageTitle: "Relatórios",
          showSecondFilterField: true,
          showThirdFilterField: true,
          showButton: true,
          mainCardSize: 14.h,
          cardsSize: 10.h,
        ) :
        AdminReportAfterLoadWidget(),
      ),
    );
  }
}
