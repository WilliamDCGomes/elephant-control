import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../widgetsShared/shimmer/default_shimmer.dart';
import '../controller/machine_controller.dart';
import '../widget/machine_after_load_widget.dart';

class MachinePage extends StatefulWidget {
  const MachinePage({super.key});

  @override
  State<MachinePage> createState() => _MachinePageState();
}

class _MachinePageState extends State<MachinePage> {
  late final MachineController controller;
  @override
  void initState() {
    controller = Get.put(MachineController(), tag: "machine-controller");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => controller.screenLoading.value ?
        DefaultShimmer(
          pageTitle: "Máquinas",
          mainCardSize: 3.h,
          cardsSize: 10.h,
        ) :
        MachineAfterLoadWidget(),
      ),
    );
  }
}
