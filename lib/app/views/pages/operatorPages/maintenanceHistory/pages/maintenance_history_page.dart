import 'package:elephant_control/app/views/pages/widgetsShared/shimmer/default_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../controller/maintenance_history_controller.dart';
import '../widgets/maintenance_history_after_load_widget.dart';

class MaintenanceHistoryPage extends StatefulWidget {
  final bool offline;
  const MaintenanceHistoryPage({Key? key, required this.offline}) : super(key: key);

  @override
  State<MaintenanceHistoryPage> createState() => _MaintenanceHistoryPageState();
}

class _MaintenanceHistoryPageState extends State<MaintenanceHistoryPage> {
  late MaintenanceHistoryController controller;

  @override
  void initState() {
    Get.delete<MaintenanceHistoryController>();
    controller = Get.put(MaintenanceHistoryController(widget.offline), tag: "maintenance-history-controller");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => controller.screenLoading.value
            ? DefaultShimmer(
                pageTitle: "Visitas",
                showSearchField: false,
                mainCardSize: 3.h,
              )
            : MaintenanceHistoryAfterLoadWidget(),
      ),
    );
  }
}
