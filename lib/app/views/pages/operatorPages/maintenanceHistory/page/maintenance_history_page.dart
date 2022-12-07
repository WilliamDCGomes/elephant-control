import 'package:elephant_control/app/utils/date_format_to_brazil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../utils/paths.dart';
import '../../../../stylePages/app_colors.dart';
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
                          title: "Atendimentos",
                          titleColor: AppColors.backgroundColor,
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
                                    "Atendimentos do dia: ${DateFormatToBrazil.formatDate(DateTime.now())}",
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
                              child: ListView.builder(
                                itemCount: controller.maintenanceCardWidgetList.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.symmetric(horizontal: 2.h),
                                itemBuilder: (context, index){
                                  return controller.maintenanceCardWidgetList[index];
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                  floatingActionButton: FloatingActionButton.extended(
                    backgroundColor: AppColors.defaultColor,
                    foregroundColor: AppColors.backgroundColor,
                    elevation: 3,
                    icon: Icon(
                      Icons.add,
                      size: 4.5.h,
                      color: AppColors.backgroundColor,
                    ),
                    label: TextWidget(
                      "Montar nova lista de atendimento",
                      maxLines: 1,
                      textColor: AppColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {

                    },
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
