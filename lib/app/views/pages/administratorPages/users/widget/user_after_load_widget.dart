import 'package:elephant_control/app/views/pages/administratorPages/trackOperator/pages/track_operator_page.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/maintenance_card_widget.dart';
import 'package:elephant_control/base/models/user/user.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get/get.dart';
import '../../../../../utils/paths.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/information_container_widget.dart';
import '../../../widgetsShared/text_field_widget.dart';
import '../../../widgetsShared/text_widget.dart';
import '../../../widgetsShared/title_with_back_button_widget.dart';
import '../controller/user_controller.dart';

class UserAfterLoadWidget extends StatefulWidget {
  const UserAfterLoadWidget({super.key});

  @override
  State<UserAfterLoadWidget> createState() => _UserAfterLoadWidgetState();
}

class _UserAfterLoadWidgetState extends State<UserAfterLoadWidget> {
  late final UserController controller;
  @override
  void initState() {
    controller = Get.find(tag: "user-controller");
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
                      InformationContainerWidget(
                        iconPath: Paths.Novo_Usuario,
                        textColor: AppColors.whiteColor,
                        backgroundColor: AppColors.defaultColor,
                        informationText: "",
                        customContainer: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextWidget(
                              "Usuários do aplicativo",
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
                                  final user = controller.users[index];
                                  return MaintenanceCardWidget(
                                    machineName: user.name,
                                    city: "",
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
                                      if(user.type == UserType.operator)
                                        GestureDetector(
                                          onTap: () => Get.to(() => TrackOperatorPage(
                                            operator: user,
                                          )),
                                          child: Icon(
                                            Icons.location_on,
                                            color: AppColors.whiteColor,
                                            size: 3.h,
                                          ),
                                        ),
                                      if(user.type == UserType.operator)
                                        SizedBox(width: 2.w),
                                      GestureDetector(
                                        onTap: () async => await controller.editUser(user),
                                        child: Icon(
                                          Icons.edit,
                                          color: AppColors.whiteColor,
                                          size: 3.h,
                                        ),
                                      ),
                                      SizedBox(width: 2.w),
                                      GestureDetector(
                                        onTap: () async => await controller.deleteUser(user),
                                        child: Icon(
                                          Icons.delete,
                                          color: AppColors.whiteColor,
                                          size: 3.h,
                                        ),
                                      ),
                                      SizedBox(width: 2.w),
                                      GestureDetector(
                                        onTap: () async => await controller.resetPassword(user),
                                        child: Icon(
                                          Icons.key,
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