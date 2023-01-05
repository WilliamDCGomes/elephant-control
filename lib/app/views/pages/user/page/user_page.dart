import 'package:elephant_control/app/views/pages/widgetsShared/maintenance_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../stylePages/app_colors.dart';
import 'package:get/get.dart';
import '../../widgetsShared/text_field_widget.dart';
import '../../widgetsShared/title_with_back_button_widget.dart';
import '../controller/user_controller.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late final UserController controller;
  @override
  void initState() {
    controller = Get.put(UserController());
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
                                title: "Usuários",
                              ),
                            ),
                            InkWell(
                              onTap: () => controller.editUser(null),
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
                          controller: controller.searchUsers,
                          hintText: "Pesquisar Usuários",
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
                            itemCount: controller.users.length,
                            itemBuilder: (context, index) {
                              final machine = controller.users[index];
                              return MaintenanceCardWidget(
                                machineName: machine.name,
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
                                  GestureDetector(
                                    onTap: () async => await controller.editUser(machine),
                                    child: Icon(
                                      Icons.edit,
                                      color: AppColors.whiteColor,
                                      size: 3.h,
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  GestureDetector(
                                    onTap: () async => await controller.deleteUser(machine),
                                    child: Icon(
                                      Icons.delete,
                                      color: AppColors.whiteColor,
                                      size: 3.h,
                                    ),
                                  ),
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
