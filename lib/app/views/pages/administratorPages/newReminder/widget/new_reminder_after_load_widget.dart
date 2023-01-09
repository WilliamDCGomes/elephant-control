import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../utils/paths.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/information_container_widget.dart';
import '../../../widgetsShared/maintenance_card_widget.dart';
import '../../../widgetsShared/text_field_widget.dart';
import '../../../widgetsShared/text_widget.dart';
import '../../../widgetsShared/title_with_back_button_widget.dart';
import '../controller/new_reminder_controller.dart';
import '../../reminders/page/reminders_page.dart';

class NewReminderAfterLoadWidget extends StatefulWidget {
  const NewReminderAfterLoadWidget({super.key});

  @override
  State<NewReminderAfterLoadWidget> createState() => _NewReminderAfterLoadWidgetState();
}

class _NewReminderAfterLoadWidgetState extends State<NewReminderAfterLoadWidget> {
  late final NewReminderController controller;

  @override
  void initState() {
    controller = Get.find(tag: "new-reminder-controller");
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
                        child: TitleWithBackButtonWidget(
                          title: "Novo Lembrete",
                        ),
                      ),
                      InformationContainerWidget(
                        iconPath: Paths.Novo_Lembrete,
                        textColor: AppColors.whiteColor,
                        backgroundColor: AppColors.defaultColor,
                        informationText: "",
                        customContainer: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextWidget(
                              "Selecione a máquina que deseja adicionar o lembrete",
                              textColor: AppColors.whiteColor,
                              fontSize: 16.sp,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(2.h, 2.h, 2.h, 0),
                        child: TextFieldWidget(
                          controller: controller.searchMachines,
                          hintText: "Pesquisar Máquinas",
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
                                itemCount: controller.machines.length,
                                itemBuilder: (context, index) {
                                  final machine = controller.machines[index];
                                  return MaintenanceCardWidget(
                                    machineName: machine.name,
                                    city: machine.city,
                                    onTap: () => Get.to(() => ReminderPage(
                                      reminders: machine.reminders ?? [],
                                      machineId: machine.id!,
                                      machineName: machine.name,
                                    )),
                                    status: "",
                                    workPriority: "",
                                    priorityColor: 0,
                                    clock1: "0",
                                    clock2: "0",
                                    teddy: "0",
                                    pouchCollected: false,
                                    showPriorityAndStatus: false,
                                    machineContainerColor: AppColors.defaultColor,
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