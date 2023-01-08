import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/maintenance_card_widget.dart';
import '../../../widgetsShared/text_field_widget.dart';
import '../../../widgetsShared/title_with_back_button_widget.dart';
import '../controller/list_machine_controller.dart';
import '../../reminders/page/reminders_page.dart';

class ListMachinePage extends StatefulWidget {
  const ListMachinePage({super.key});

  @override
  State<ListMachinePage> createState() => _ListMachinePageState();
}

class _ListMachinePageState extends State<ListMachinePage> {
  late final ListMachineController controller;

  @override
  void initState() {
    controller = Get.put(ListMachineController());
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
                          title: "Máquinas",
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
                                onTap: () => Get.to(() => ReminderPage(reminders: machine.reminders ?? [], machineId: machine.id!)),
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
