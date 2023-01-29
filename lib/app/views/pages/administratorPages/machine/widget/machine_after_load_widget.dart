import 'package:elephant_control/app/views/pages/administratorPages/userMachine/page/user_machine_page.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/maintenance_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get/get.dart';
import '../../../../../utils/paths.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/information_container_widget.dart';
import '../../../widgetsShared/text_field_widget.dart';
import '../../../widgetsShared/text_widget.dart';
import '../../../widgetsShared/title_with_back_button_widget.dart';
import '../controller/machine_controller.dart';

class MachineAfterLoadWidget extends StatefulWidget {
  const MachineAfterLoadWidget({super.key});

  @override
  State<MachineAfterLoadWidget> createState() => _MachineAfterLoadWidgetState();
}

class _MachineAfterLoadWidgetState extends State<MachineAfterLoadWidget> {
  late final MachineController controller;
  @override
  void initState() {
    controller = Get.find(tag: "machine-controller");
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
                                title: "Máquinas",
                              ),
                            ),
                            InkWell(
                              onTap: () => controller.editMachine(null),
                              child: Icon(
                                Icons.add_circle,
                                color: AppColors.whiteColor,
                                size: 3.h,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InformationContainerWidget(
                        iconPath: Paths.Maquina_Pelucia,
                        textColor: AppColors.whiteColor,
                        backgroundColor: AppColors.defaultColor,
                        informationText: "",
                        customContainer: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextWidget(
                              "Máquinas cadastradas no sistema",
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
                                    status: "",
                                    workPriority: "",
                                    priorityColor: 0,
                                    clock1: "0",
                                    clock2: "0",
                                    teddy: "0",
                                    visitId: "",
                                    pouchCollected: false,
                                    showPriorityAndStatus: false,
                                    machineContainerColor: AppColors.defaultColor,
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
                                      GestureDetector(
                                        onTap: () async => Get.to(() => UserMachinePage(machineId: machine.id!)),
                                        child: Icon(
                                          Icons.person_add,
                                          color: AppColors.whiteColor,
                                          size: 3.h,
                                        ),
                                      ),
                                    ],
                                    child: const SizedBox(),
                                    visitDate: DateTime.now(),
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