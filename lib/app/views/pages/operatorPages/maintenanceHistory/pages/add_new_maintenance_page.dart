import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../widgetsShared/shimmer/default_shimmer.dart';
import '../controller/maintenance_history_controller.dart';
import '../widgets/add_new_maintenance_after_load_widget.dart';

class AppNewMaintenancePage extends StatefulWidget {
  final String title;
  final MaintenanceHistoryController controller;

  const AppNewMaintenancePage({
    Key? key,
    required this.title,
    required this.controller,
  }) : super(key: key);

  @override
  State<AppNewMaintenancePage> createState() => _AppNewMaintenancePageState();
}

class _AppNewMaintenancePageState extends State<AppNewMaintenancePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 200));
      await widget.controller.getMachineVisitByUserId(showLoad: false);
      controller.nextScreenLoading.value = false;
    });
  }

  MaintenanceHistoryController get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => controller.nextScreenLoading.value ?
        DefaultShimmer(
          pageTitle: "Visitas Pendentes",
          mainCardSize: 5.h,
        ) :
        AppNewMaintenanceAfterLoadWidget(
          title: widget.title,
          controller: widget.controller,
        ),
      ),
    );
  }
}
