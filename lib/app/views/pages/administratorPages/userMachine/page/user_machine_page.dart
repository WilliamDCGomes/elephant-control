import 'package:elephant_control/app/views/pages/widgetsShared/maintenance_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../utils/paths.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/information_container_widget.dart';
import '../../../widgetsShared/popups/confirmation_popup.dart';
import '../../../widgetsShared/text_widget.dart';
import '../../../widgetsShared/title_with_back_button_widget.dart';
import '../controller/user_machine_controller.dart';

class UserMachinePage extends StatefulWidget {
  final String machineId;
  const UserMachinePage({super.key, required this.machineId});

  @override
  State<UserMachinePage> createState() => _UserMachinePageState();
}

class _UserMachinePageState extends State<UserMachinePage> {
  late final UserMachineController controller;
  @override
  void initState() {
    controller = Get.put(UserMachineController(widget.machineId));
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
                          children: [
                            Expanded(
                              child: TitleWithBackButtonWidget(
                                title: "Usuários da máquina",
                              ),
                            ),
                            GestureDetector(
                              onTap: () async => await controller.addUser(),
                              child: Icon(
                                Icons.add_circle,
                                color: AppColors.whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InformationContainerWidget(
                        iconPath: Paths.Icone_Perfil,
                        textColor: AppColors.whiteColor,
                        backgroundColor: AppColors.defaultColor,
                        informationText: "",
                        customContainer: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextWidget(
                              "Usuários que conseguem visualizar a máquina",
                              textColor: AppColors.whiteColor,
                              fontSize: 16.sp,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.h),
                          child: Obx(
                            () => ListView.builder(
                              itemCount: controller.users.length,
                              itemBuilder: (context, index) {
                                final user = controller.users[index];
                                return MaintenanceCardWidget(
                                  machineName: user.name,
                                  city: user.name,
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
                                  child: const SizedBox(),
                                  childMaintenanceHeaderCardWidget: [
                                    GestureDetector(
                                      onTap: () async => showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return ConfirmationPopup(
                                            title: "Aviso",
                                            subTitle: "Tem certeza que deseja apagar o operador?",
                                            firstButton: () {},
                                            secondButton: () async => await controller.deleteMachine(user),
                                          );
                                        },
                                      ),
                                      child: Icon(
                                        Icons.delete,
                                        color: AppColors.whiteColor,
                                        size: 3.h,
                                      ),
                                    ),
                                  ],
                                  visitDate: DateTime.now(),
                                );
                              },
                            ),
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
