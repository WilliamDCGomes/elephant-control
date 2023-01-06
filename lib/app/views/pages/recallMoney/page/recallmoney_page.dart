import 'package:elephant_control/app/views/pages/widgetsShared/maintenance_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../stylePages/app_colors.dart';
import 'package:get/get.dart';
import '../../widgetsShared/text_field_widget.dart';
import '../../widgetsShared/title_with_back_button_widget.dart';

import '../controller/recallmoney_controller.dart';

class RecallMoneyPage extends StatefulWidget {
  const RecallMoneyPage({super.key});

  @override
  State<RecallMoneyPage> createState() => _RecallMoneyPageState();
}

class _RecallMoneyPageState extends State<RecallMoneyPage> {
  late final RecallMoneyController controller;
  @override
  void initState() {
    controller = Get.put(RecallMoneyController());
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
                                title: "Recolher Dinheiro",
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
                                machineContainerColor: AppColors.defaultColor,
                                childMaintenanceHeaderCardWidget: [
                                  GestureDetector(
                                    onTap: () async => await controller.finishVisit(visit),
                                    child: Icon(
                                      Icons.attach_money_rounded,
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
