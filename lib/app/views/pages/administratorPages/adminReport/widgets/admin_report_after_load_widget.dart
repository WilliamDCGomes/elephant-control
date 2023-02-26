import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../utils/date_format_to_brazil.dart';
import '../../../../../utils/paths.dart';
import '../../../../../utils/platform_type.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/button_widget.dart';
import '../../../widgetsShared/information_container_widget.dart';
import '../../../widgetsShared/rich_text_two_different_widget.dart';
import '../../../widgetsShared/text_widget.dart';
import '../../../widgetsShared/title_with_back_button_widget.dart';
import '../controller/admin_report_controller.dart';
import 'all_machines_report_information_widget.dart';
import 'machine_report_information_widget.dart';

class AdminReportAfterLoadWidget extends StatefulWidget {
  const AdminReportAfterLoadWidget({Key? key}) : super(key: key);

  @override
  State<AdminReportAfterLoadWidget> createState() => _AdminReportAfterLoadWidgetState();
}

class _AdminReportAfterLoadWidgetState extends State<AdminReportAfterLoadWidget> {
  late AdminReportController controller;

  @override
  void initState() {
    controller = Get.find(tag: "admin-report-controller");
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
                              child: Obx(
                                () => TitleWithBackButtonWidget(
                                  title: "Relatório Geral",
                                  rightIcon: controller.showInfos.value ? Icons.visibility_off : Icons.visibility,
                                  onTapRightIcon: () => controller.showInfos.value = !controller.showInfos.value,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => controller.generateReportPdf(),
                              child: Padding(
                                padding: EdgeInsets.only(left: 4.w),
                                child: Icon(
                                  Icons.print_outlined,
                                  color: AppColors.backgroundColor,
                                  size: 3.h,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Obx(
                        () => Visibility(
                          visible: controller.showInfos.value,
                          child: InformationContainerWidget(
                            iconPath: Paths.Relatorio,
                            textColor: AppColors.whiteColor,
                            backgroundColor: AppColors.defaultColor,
                            informationText: "",
                            customContainer: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextWidget(
                                  "Selecione uma máquina para visualizar um relatório sobre ela em específico.",
                                  textColor: AppColors.whiteColor,
                                  fontSize: 16.sp,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Scrollbar(
                          trackVisibility: true,
                          thumbVisibility: true,
                          child: ListView(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 2.h, top: 1.h, right: 2.h, bottom: 2.h),
                                child: InkWell(
                                  onTap: () async => controller.selectedMachines(),
                                  child: Container(
                                    height: PlatformType.isTablet(context) ? 5.6.h : 6.5.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: AppColors.defaultColor,
                                        width: .25.h,
                                      ),
                                    ),
                                    padding: EdgeInsets.all(.5.h),
                                    margin: EdgeInsets.only(top: 1.h),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Obx(
                                        () => TextWidget(
                                          controller.machineSelected.value,
                                          textColor: AppColors.blackColor,
                                          fontSize: 16.sp,
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () async => await controller.filterPerInitialDate(),
                                        child: Container(
                                          height: PlatformType.isTablet(context) ? 5.6.h : 6.5.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(
                                              color: AppColors.defaultColor,
                                              width: .25.h,
                                            ),
                                          ),
                                          padding: EdgeInsets.all(.5.h),
                                          margin: EdgeInsets.only(top: 1.h, bottom: 2.h),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: GetBuilder(
                                              id: "initial-date-filter",
                                              init: controller,
                                              builder: (_) => RichTextTwoDifferentWidget(
                                                firstText: "Data Inicial: ",
                                                firstTextColor: AppColors.blackColor,
                                                firstTextFontWeight: FontWeight.normal,
                                                firstTextSize: 16.sp,
                                                secondText: DateFormatToBrazil.formatDate(controller.initialDateFilter),
                                                secondTextColor: AppColors.blackColor,
                                                secondTextFontWeight: FontWeight.bold,
                                                secondTextSize: 16.sp,
                                                secondTextDecoration: TextDecoration.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 3.w,
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () async => await controller.filterPerFinalDate(),
                                        child: Container(
                                          height: PlatformType.isTablet(context) ? 5.6.h : 6.5.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(
                                              color: AppColors.defaultColor,
                                              width: .25.h,
                                            ),
                                          ),
                                          padding: EdgeInsets.all(.5.h),
                                          margin: EdgeInsets.only(top: 1.h, bottom: 2.h),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: GetBuilder(
                                              id: "final-date-filter",
                                              init: controller,
                                              builder: (_) => RichTextTwoDifferentWidget(
                                                firstText: "Data Final: ",
                                                firstTextColor: AppColors.blackColor,
                                                firstTextFontWeight: FontWeight.normal,
                                                firstTextSize: 16.sp,
                                                secondText: DateFormatToBrazil.formatDate(controller.finalDateFilter),
                                                secondTextColor: AppColors.blackColor,
                                                secondTextFontWeight: FontWeight.bold,
                                                secondTextSize: 16.sp,
                                                secondTextDecoration: TextDecoration.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2.h),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () async => await controller.filterPerInitialHour(),
                                        child: Container(
                                          height: PlatformType.isTablet(context) ? 5.6.h : 6.5.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(
                                              color: AppColors.defaultColor,
                                              width: .25.h,
                                            ),
                                          ),
                                          padding: EdgeInsets.all(.5.h),
                                          margin: EdgeInsets.only(top: 1.h, bottom: 2.h),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: GetBuilder(
                                              id: "initial-hour-filter",
                                              init: controller,
                                              builder: (_) => RichTextTwoDifferentWidget(
                                                firstText: "Hora Inicial: ",
                                                firstTextColor: AppColors.blackColor,
                                                firstTextFontWeight: FontWeight.normal,
                                                firstTextSize: 16.sp,
                                                secondText: DateFormatToBrazil.formatHour(controller.initialHourFilter),
                                                secondTextColor: AppColors.blackColor,
                                                secondTextFontWeight: FontWeight.bold,
                                                secondTextSize: 16.sp,
                                                secondTextDecoration: TextDecoration.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 3.w,
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () async => await controller.filterPerFinalHour(),
                                        child: Container(
                                          height: PlatformType.isTablet(context) ? 5.6.h : 6.5.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(
                                              color: AppColors.defaultColor,
                                              width: .25.h,
                                            ),
                                          ),
                                          padding: EdgeInsets.all(.5.h),
                                          margin: EdgeInsets.only(top: 1.h, bottom: 2.h),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: GetBuilder(
                                              id: "final-hour-filter",
                                              init: controller,
                                              builder: (_) => RichTextTwoDifferentWidget(
                                                firstText: "Hora Final: ",
                                                firstTextColor: AppColors.blackColor,
                                                firstTextFontWeight: FontWeight.normal,
                                                firstTextSize: 16.sp,
                                                secondText: DateFormatToBrazil.formatHour(controller.finalHourFilter),
                                                secondTextColor: AppColors.blackColor,
                                                secondTextFontWeight: FontWeight.bold,
                                                secondTextSize: 16.sp,
                                                secondTextDecoration: TextDecoration.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GetBuilder(
                                id: 'report-information',
                                init: controller,
                                builder: (_) => Padding(
                                  padding: EdgeInsets.only(bottom: 2.h),
                                  child: controller.reportViewController != null
                                      ? Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 2.h),
                                          child: Visibility(
                                            visible: controller.showOneReport.value,
                                            child: MachineReportInformationWidget(
                                              reportViewController: controller.reportViewController!,
                                            ),
                                            replacement: AllMachinesReportInformationWidget(
                                              reportViewController: controller.reportViewController!,
                                            ),
                                          ),
                                        )
                                      : Center(
                                          child: TextWidget(
                                            "Não existe informações nesse período",
                                            textColor: AppColors.grayTextColor,
                                            fontSize: 14.sp,
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(2.h),
                        child: ButtonWidget(
                          hintText: "FILTRAR",
                          fontWeight: FontWeight.bold,
                          widthButton: double.infinity,
                          onPressed: () => controller.getReport(),
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
