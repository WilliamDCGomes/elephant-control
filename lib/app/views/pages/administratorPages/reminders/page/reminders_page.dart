import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../../base/models/reminderMachine/reminder_machine.dart';
import '../../../widgetsShared/shimmer/default_shimmer.dart';
import '../controller/reminders_controller.dart';
import '../widget/reminders_after_load_widget.dart';

class ReminderPage extends StatefulWidget {
  final List<ReminderMachine> reminders;
  final String machineId;
  final String machineName;

  const ReminderPage({
    super.key,
    required this.reminders,
    required this.machineId,
    required this.machineName,
  });

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  late final ReminderController controller;

  @override
  void initState() {
    controller = Get.put(
      ReminderController(
        widget.reminders,
        widget.machineId,
      ),
      tag: "reminder-controller",
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => controller.screenLoading.value ?
        DefaultShimmer(
          pageTitle: "Lembretes",
          mainCardSize: 3.h,
          cardsSize: 10.h,
        ) :
        RemindersAfterLoadWidget(
          reminders: widget.reminders,
          machineId: widget.machineId,
          machineName: widget.machineName,
        ),
      ),
    );
  }
}
