import 'package:elephant_control/app/views/pages/widgetsShared/maintenance_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get/get.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/text_field_widget.dart';
import '../../../widgetsShared/title_with_back_button_widget.dart';
import '../controller/visit_controller.dart';

class VisitPage extends StatefulWidget {
  const VisitPage({super.key});

  @override
  State<VisitPage> createState() => _VisitPageState();
}

class _VisitPageState extends State<VisitPage> {
  late final VisitController controller;
  @override
  void initState() {
    controller = Get.put(VisitController());
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
                                title: "Atendimentos",
                              ),
                            ),
                            // InkWell(
                            //   onTap: () => controller.editVisit(null),
                            //   child: Icon(
                            //     Icons.add_circle,
                            //     color: AppColors.whiteColor,
                            //     size: 3.h,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(2.h, 2.h, 2.h, 0),
                        child: TextFieldWidget(
                          controller: controller.searchVisits,
                          hintText: "Pesquisar Atendimentos",
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
                            itemCount: controller.visits.length,
                            itemBuilder: (context, index) {
                              final visit = controller.visits[index];
                              return MaintenanceCardWidget(
                                machineName: visit.machine!.name,
                                city: "",
                                status: "",
                                workPriority: "",
                                priorityColor: 0,
                                clock1: "0",
                                clock2: "0",
                                teddy: "0",
                                pouchCollected: false,
                                showPriorityAndStatus: false,
                                visitId: visit.id ?? "",
                                machineContainerColor: AppColors.defaultColor,
                                childMaintenanceHeaderCardWidget: [
                                  // GestureDetector(
                                  //   onTap: () async => await controller.editVisit(visit),
                                  //   child: Icon(
                                  //     Icons.edit,
                                  //     color: AppColors.whiteColor,
                                  //     size: 3.h,
                                  //   ),
                                  // ),
                                  SizedBox(width: 2.w),
                                  GestureDetector(
                                    onTap: () async => await controller.deleteVisit(visit),
                                    child: Icon(
                                      Icons.delete,
                                      color: AppColors.whiteColor,
                                      size: 3.h,
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  // GestureDetector(
                                  //   onTap: () async => await controller.resetPassword(visit),
                                  //   child: Icon(
                                  //     Icons.key,
                                  //     color: AppColors.whiteColor,
                                  //     size: 3.h,
                                  //   ),
                                  // ),
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
