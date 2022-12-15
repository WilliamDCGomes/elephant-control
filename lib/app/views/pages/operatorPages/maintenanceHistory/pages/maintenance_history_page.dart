import 'package:elephant_control/app/utils/date_format_to_brazil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../utils/paths.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/button_widget.dart';
import '../../../widgetsShared/information_container_widget.dart';
import '../../../widgetsShared/text_widget.dart';
import '../../../widgetsShared/title_with_back_button_widget.dart';
import '../../occurrence/page/occurrence_page.dart';
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
                                () => ListView.builder(
                                  itemCount: controller.maintenanceCardWidgetList.length,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.symmetric(horizontal: 2.h),
                                  itemBuilder: (context, index){
                                    return Stack(
                                      children: [
                                        controller.maintenanceCardWidgetList[index],
                                        Visibility(
                                          visible: controller.maintenanceCardWidgetList[index].status == "Pendente",
                                          child: Padding(
                                            padding: EdgeInsets.all(1.h),
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: InkWell(
                                                onTap: () => controller.removeItemList(index),
                                                child: Icon(
                                                  Icons.close,
                                                  color: AppColors.backgroundColor,
                                                  size: 3.h,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(2.h, 2.h, 2.h, 1.h),
                              child: ButtonWidget(
                                hintText: "Adicionar Ocorrência",
                                fontWeight: FontWeight.bold,
                                widthButton: double.infinity,
                                onPressed: () => Get.to(() => OccurrencePage()),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(2.h, 1.h, 2.h, 2.h),
                              child: ButtonWidget(
                                hintText: "Montar nova lista de atendimento",
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
