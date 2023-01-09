import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../widgetsShared/shimmer/default_shimmer.dart';
import '../controller/new_reminder_controller.dart';
import '../widget/new_reminder_after_load_widget.dart';

class NewReminderPage extends StatefulWidget {
  const NewReminderPage({super.key});

  @override
  State<NewReminderPage> createState() => _NewReminderPageState();
}

class _NewReminderPageState extends State<NewReminderPage> {
  late final NewReminderController controller;

  @override
  void initState() {
    controller = Get.put(NewReminderController(), tag: "new-reminder-controller");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => controller.screenLoading.value ?
        DefaultShimmer(
          pageTitle: "Novo Lembrete",
          mainCardSize: 3.h,
          cardsSize: 10.h,
        ) :
        NewReminderAfterLoadWidget(),
      ),
    );
  }
}
