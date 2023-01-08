import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../../base/models/reminderMachine/reminder_machine.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/maintenance_card_widget.dart';
import '../../../widgetsShared/text_field_widget.dart';
import '../../../widgetsShared/title_with_back_button_widget.dart';
import '../controller/reminders_controller.dart';

class ReminderPage extends StatefulWidget {
  final List<ReminderMachine> reminders;
  final String machineId;
  const ReminderPage({super.key, required this.reminders, required this.machineId});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  late final ReminderController controller;

  @override
  void initState() {
    controller = Get.put(ReminderController(
      widget.reminders,
      widget.machineId,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: AppColors.backgroundFirstScreenColor,
              ),
            ),
            child: Stack(
              children: [
                Scaffold(
                  backgroundColor: AppColors.transparentColor,
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 8.h,
                        color: AppColors.defaultColor,
                        padding: EdgeInsets.symmetric(horizontal: 2.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TitleWithBackButtonWidget(
                                title: "Lembretes",
                              ),
                            ),
                            InkWell(
                              onTap: () => controller.createOrEditReminder(null),
                              child: Icon(
                                Icons.add_circle,
                                color: AppColors.whiteColor,
                                size: 3.h,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(2.h, 2.h, 2.h, 0),
                        child: TextFieldWidget(
                          controller: controller.searchReminders,
                          hintText: "Pesquisar Lembretes",
                          height: 9.h,
                          width: double.infinity,
                          iconTextField: Icon(
                            Icons.search,
                            color: AppColors.defaultColor,
                            size: 3.h,
                          ),
                          keyboardType: TextInputType.name,
                          onChanged: (value) => controller.updateList(),
                        ),
                      ),
                      Expanded(
                          child: Obx(
                        () => Padding(
                          padding: EdgeInsets.fromLTRB(2.h, 0, 2.h, 1.h),
                          child: ListView.builder(
                            itemCount: controller.reminders.length,
                            itemBuilder: (context, index) {
                              final reminder = controller.reminders[index];
                              return MaintenanceCardWidget(
                                machineName: reminder.description,
                                maxLines: 3,
                                onTap: () => controller.createOrEditReminder(reminder),
                                city: "",
                                status: "",
                                workPriority: "",
                                priorityColor: 0,
                                clock1: "0",
                                clock2: "0",
                                teddy: "0",
                                pouchCollected: false,
                                showPriorityAndStatus: false,
                                machineContainerColor: AppColors.defaultColor,
                                childMaintenanceHeaderCardWidget: [
                                  SizedBox(width: 1.h),
                                  Icon(
                                    reminder.realized ? Icons.check_box : Icons.check_box_outline_blank_outlined,
                                    color: AppColors.whiteColor,
                                    size: 3.h,
                                  ),
                                  SizedBox(width: 2.h),
                                  GestureDetector(onTap: () => controller.deleteReminder(reminder), child: Icon(Icons.delete, color: AppColors.whiteColor, size: 3.h)),
                                ],
                                child: const SizedBox(),
                              );
                            },
                          ),
                        ),
                      ))
                    ],
                  ),
                ),
                controller.loadingWithSuccessOrErrorWidget,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
