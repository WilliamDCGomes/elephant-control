import 'package:elephant_control/app/utils/date_format_to_brazil.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/maintenance_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../utils/paths.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/button_widget.dart';
import '../../../widgetsShared/information_container_widget.dart';
import '../../../widgetsShared/text_widget.dart';
import '../../../widgetsShared/title_with_back_button_widget.dart';
import '../controller/maintenance_history_controller.dart';

class MaintenanceHistoryPage extends StatefulWidget {
  const MaintenanceHistoryPage({Key? key}) : super(key: key);

  @override
  State<MaintenanceHistoryPage> createState() => _MaintenanceHistoryPageState();
}

class _MaintenanceHistoryPageState extends State<MaintenanceHistoryPage> {
  late MaintenanceHistoryController controller;

  @override
  void initState() {
    Get.delete<MaintenanceHistoryController>();
    controller = Get.put(MaintenanceHistoryController());
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 8.h,
                        color: AppColors.defaultColor,
                        padding: EdgeInsets.symmetric(horizontal: 2.h),
                        child: TitleWithBackButtonWidget(
                          title: "Visitas",
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InformationContainerWidget(
                              iconPath: Paths.Pelucia,
                              textColor: AppColors.whiteColor,
                              backgroundColor: AppColors.defaultColor,
                              informationText: "",
                              customContainer: TextWidget(
                                "Visitas do dia: ${DateFormatToBrazil.formatDate(DateTime.now())}",
                                textColor: AppColors.whiteColor,
                                fontSize: 18.sp,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Obx(
                                () => Visibility(
                                  visible: controller.visits.isNotEmpty,
                                  replacement: Center(child: TextWidget("Nenhuma visita encontrada", textColor: AppColors.blackColor)),
                                  child: ListView.builder(
                                    itemCount: controller.visits.length,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.symmetric(horizontal: 2.h),
                                    itemBuilder: (context, index) {
                                      final visit = controller.visits[index];
                                      return Stack(
                                        children: [
                                          MaintenanceCardWidget(
                                            machineName: visit.machineName,
                                            city: "",
                                            status: visit.status?.description ?? "Pendente",
                                            workPriority: "NORMAL",
                                            priorityColor: AppColors.greenColor.value,
                                            clock1: visit.moneyQuantity.toString(),
                                            clock2: visit.stuffedAnimalsQuantity.toString(),
                                            teddy: visit.stuffedAnimalsReplaceQuantity.toString(),
                                            pouchCollected: visit.moneyPouchRetired,
                                          )

                                          // Obx(
                                          //   () => Padding(
                                          //     padding: EdgeInsets.all(1.h),
                                          //     child: Align(
                                          //       alignment: Alignment.topRight,
                                          //       child: InkWell(
                                          //         onTap: () {
                                          //           if(controller.maintenanceCardWidgetList[index].status == "Pendente" && !controller.maintenanceCardWidgetList[index].operatorDeletedMachine.value){
                                          //             controller.removeItemList(index);
                                          //           }
                                          //           else{
                                          //             Get.to(() => RequestEditVisitPage());
                                          //           }
                                          //         },
                                          //         child: Icon(
                                          //           controller.maintenanceCardWidgetList[index].status == "Pendente"
                                          //           && !controller.maintenanceCardWidgetList[index].operatorDeletedMachine.value ?
                                          //           Icons.close : Icons.edit,
                                          //           color: AppColors.backgroundColor,
                                          //           size: controller.maintenanceCardWidgetList[index].status == "Pendente"
                                          //           && !controller.maintenanceCardWidgetList[index].operatorDeletedMachine.value ?
                                          //           3.h : 2.5.h,
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // )
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(2.h, 1.h, 2.h, 2.h),
                              child: ButtonWidget(
                                hintText: "Adicionar máquina para a visita",
                                fontWeight: FontWeight.bold,
                                widthButton: double.infinity,
                                onPressed: () async => controller.newItem(),
                              ),
                            ),
                          ],
                        ),
                      ),
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
