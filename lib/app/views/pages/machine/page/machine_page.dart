import 'package:elephant_control/app/views/pages/machine/controller/machine_controller.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/loading_with_success_or_error_widget.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/maintenance_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../utils/paths.dart';
import '../../../stylePages/app_colors.dart';
import '../../administratorPages/registerMachine/page/register_machine_page.dart';
import '../../widgetsShared/title_with_back_button_widget.dart';

class MachinePage extends StatefulWidget {
  const MachinePage({super.key});

  @override
  State<MachinePage> createState() => _MachinePageState();
}

class _MachinePageState extends State<MachinePage> {
  late final MachineController controller;
  @override
  void initState() {
    controller = Get.put(MachineController());
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
                      Expanded(
                        child: Obx(
                          () => ListView.builder(
                            itemCount: controller.machines.length,
                            itemBuilder: (context, index) {
                              final machine = controller.machines[index];
                              return MaintenanceCardWidget(
                                machineName: machine.name,
                                city: machine.city,
                                status: "",
                                workPriority: "",
                                priorityColor: 0,
                                clock1: "0",
                                clock2: "0",
                                teddy: "0",
                                pouchCollected: false,
                                showPriorityAndStatus: false,
                                machineContainerColor: Color(0xFF7a7878),
                                childMaintenanceHeaderCardWidget: [
                                  GestureDetector(
                                    onTap: () async => await controller.editMachine(machine),
                                    child: Icon(
                                      Icons.edit,
                                      color: AppColors.whiteColor,
                                      size: 3.h,
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  GestureDetector(
                                    onTap: () async => await controller.deleteMachine(machine),
                                    child: Icon(
                                      Icons.delete,
                                      color: AppColors.whiteColor,
                                      size: 3.h,
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  Icon(
                                    Icons.person_add,
                                    color: AppColors.whiteColor,
                                    size: 3.h,
                                  ),
                                ],
                                child: const SizedBox(),
                              );
                            },
                          ),
                        ),
                      )
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
