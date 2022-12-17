import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../utils/paths.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/information_container_widget.dart';
import '../../../widgetsShared/popups/confirmation_popup.dart';
import '../../../widgetsShared/text_widget.dart';
import '../../../widgetsShared/title_with_back_button_widget.dart';
import '../controller/maintenance_history_controller.dart';

class AppNewMaintenancePage extends StatefulWidget {
  final String title;
  final MaintenanceHistoryController controller;

  const AppNewMaintenancePage({
    Key? key,
    required this.title,
    required this.controller,
  }) : super(key: key);

  @override
  State<AppNewMaintenancePage> createState() => _AppNewMaintenancePageState();
}

class _AppNewMaintenancePageState extends State<AppNewMaintenancePage> {
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
                        child: Row(
                          children: [
                            Expanded(
                              child: TitleWithBackButtonWidget(
                                title: "Visitas Pendentes",
                              ),
                            ),
                            SizedBox(
                              width: 15.w,
                            ),
                            InkWell(
                              onTap: () => widget.controller.callFilterMaintenanceList(),
                              child: Icon(
                                Icons.filter_alt,
                                color: AppColors.whiteColor,
                                size: 3.h,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InformationContainerWidget(
                              iconPath: Paths.Pelucia,
                              textColor: AppColors.whiteColor,
                              backgroundColor: AppColors.defaultColor,
                              informationText: "",
                              customContainer: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TextWidget(
                                    "Selecione uma das máquinas para adicionar a sua lista",
                                    textColor: AppColors.whiteColor,
                                    fontSize: 18.sp,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.h),
                                child: Obx(
                                  () => ListView.builder(
                                    itemCount: widget.controller.allMaintenanceCardWidgetFilteredList.length,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.symmetric(horizontal: 2.h),
                                    itemBuilder: (context, index){
                                      return InkWell(
                                        onTap: () async {
                                          await showDialog(
                                            context: Get.context!,
                                            builder: (BuildContext context) {
                                              return ConfirmationPopup(
                                                title: "Aviso",
                                                subTitle: "Deseja realmente adicionar a máquina ${widget.controller.allMaintenanceCardWidgetFilteredList[index].machineName} na sua lista de atendimentos?",
                                                firstButton: () {},
                                                secondButton: () {
                                                  widget.controller.allMaintenanceCardWidgetFilteredList[index].showMap = true;
                                                  widget.controller.maintenanceCardWidgetList.add(widget.controller.allMaintenanceCardWidgetFilteredList[index]);
                                                  widget.controller.allMaintenanceCardWidgetList.remove(widget.controller.allMaintenanceCardWidgetFilteredList[index]);
                                                  widget.controller.allMaintenanceCardWidgetFilteredList.removeAt(index);
                                                  widget.controller.maintenanceCardWidgetList.sort(
                                                    (a, b) => a.operatorDeletedMachine.toString().compareTo(
                                                      b.operatorDeletedMachine.toString(),
                                                    ),
                                                  );
                                                  Get.back();
                                                },
                                              );
                                            },
                                          );
                                        },
                                        child: IgnorePointer(
                                          ignoring: true,
                                          child: widget.controller.allMaintenanceCardWidgetFilteredList[index],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}