import 'package:elephant_control/app/utils/date_format_to_brazil.dart';
import 'package:elephant_control/app/utils/logged_user.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../administratorPages/operatorsVisits/controller/operators_visits_controller.dart';
import '../../../administratorPages/operetorsVisitPeriodFilter/controller/operetors_visit_period_filter_controller.dart';
import '../../../sharedPages/visitDetails/page/visit_details_page.dart';
import '../../../widgetsShared/button_widget.dart';
import '../../../widgetsShared/checkbox_list_tile_widget.dart';
import '../../../widgetsShared/rich_text_two_different_widget.dart';
import '../../../widgetsShared/text_widget.dart';
import '../controller/maintenance_history_controller.dart';

class MaintenanceInformationPopup {
  static String getAverage(String clock1, String clock2) {
    if (clock1 != "" && clock2 != "" && double.parse(clock2) != 0) {
      return (double.parse(clock1) / double.parse(clock2)).toStringAsFixed(2).replaceAll('.', ',');
    }
    return "0,00";
  }

  static List<Widget> getWidgetList(
      context,
      final String machineName,
      final String clock1,
      final String clock2,
      final String teddy,
      final String status,
      final String priority,
      final int priorityColor,
      final bool pouchCollected,
      final String? responsibleName,
      final String visitId,
      final DateTime visitDate,
      MaintenanceHistoryController? controller,
      {
        OperatorsVisitsController? operatorsVisitsController,
        OperatorsVisitsPeriodFilterController? operatorsVisitsPeriodFilterController,
        bool editPictures = true,
        bool offline = false,
      }) {
    return [
      Center(
        child: Container(
          height: .5.h,
          width: 40.w,
          color: AppColors.grayBackgroundPictureColor,
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Container(
          height: 5.h,
          decoration: BoxDecoration(
            color: AppColors.defaultColor,
            borderRadius: BorderRadius.circular(1.h),
          ),
          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
          child: Center(
            child: TextWidget(
              machineName,
              textColor: AppColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
              textDecoration: TextDecoration.none,
              maxLines: 1,
            ),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: RichTextTwoDifferentWidget(
          firstText: "Nome Operador: ",
          firstTextColor: AppColors.blackColor,
          firstTextFontWeight: FontWeight.normal,
          firstTextSize: 16.sp,
          secondText: responsibleName ?? LoggedUser.name,
          secondTextColor: AppColors.blackColor,
          secondTextFontWeight: FontWeight.bold,
          secondTextSize: 16.sp,
          secondTextDecoration: TextDecoration.none,
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: RichTextTwoDifferentWidget(
          firstText: "Data do Atendimento: ",
          firstTextColor: AppColors.blackColor,
          firstTextFontWeight: FontWeight.normal,
          firstTextSize: 16.sp,
          secondText: DateFormatToBrazil.formatDateAndHour(visitDate),
          secondTextColor: AppColors.blackColor,
          secondTextFontWeight: FontWeight.bold,
          secondTextSize: 16.sp,
          secondTextDecoration: TextDecoration.none,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 2.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: .5.h),
                  child: TextWidget(
                    "Prioridade:",
                    textColor: AppColors.blackColor,
                    fontSize: 16.sp,
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  height: 5.h,
                  width: 44.w,
                  color: AppColors.grayBackgroundPictureColor,
                  padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
                  child: Center(
                    child: TextWidget(
                      priority,
                      textColor: Color(priorityColor),
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: .5.h),
                  child: TextWidget(
                    "Status:",
                    textColor: AppColors.blackColor,
                    fontSize: 16.sp,
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  height: 5.h,
                  width: 44.w,
                  color: AppColors.grayBackgroundPictureColor,
                  padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
                  child: Center(
                    child: TextWidget(
                      status,
                      textColor: AppColors.defaultColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: .5.h),
                  child: TextWidget(
                    "Relógio Numeração:",
                    textColor: AppColors.blackColor,
                    fontSize: 16.sp,
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  height: 5.h,
                  width: 44.w,
                  color: AppColors.grayBackgroundPictureColor,
                  padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
                  child: Center(
                    child: TextWidget(
                      double.parse(clock1).toStringAsFixed(0),
                      textColor: AppColors.defaultColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: .5.h),
                  child: TextWidget(
                    "Relógio de Prêmios:",
                    textColor: AppColors.blackColor,
                    fontSize: 16.sp,
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  height: 5.h,
                  width: 44.w,
                  color: AppColors.grayBackgroundPictureColor,
                  padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
                  child: Center(
                    child: TextWidget(
                      double.parse(clock2).toStringAsFixed(0),
                      textColor: AppColors.defaultColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.only(bottom: 1.h),
        child: TextWidget(
          "Média da Máquina na Visita:",
          textColor: AppColors.blackColor,
          fontSize: 16.sp,
          textAlign: TextAlign.start,
          maxLines: 1,
        ),
      ),
      Container(
        height: 5.h,
        color: AppColors.grayBackgroundPictureColor,
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
        child: Center(
          child: TextWidget(
            getAverage(clock1, clock2),
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
            textColor: AppColors.defaultColor,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: TextWidget(
          "Pelúcias Recolocadas na Máquina:",
          textColor: AppColors.blackColor,
          fontSize: 16.sp,
          textAlign: TextAlign.start,
          maxLines: 1,
        ),
      ),
      Container(
        height: 5.h,
        color: AppColors.grayBackgroundPictureColor,
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
        child: Center(
          child: TextWidget(
            teddy,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
            textColor: AppColors.defaultColor,
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: TextWidget(
              "Malote Retirado da Máquina?",
              textColor: AppColors.defaultColor,
              fontSize: 16.sp,
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),
          Expanded(
            child: CheckboxListTileWidget(
              radioText: "Sim",
              size: 4.h,
              checked: pouchCollected,
              justRead: true,
              onChanged: () {},
            ),
          ),
          SizedBox(
            width: 1.w,
          ),
          Expanded(
            child: CheckboxListTileWidget(
              radioText: "Não",
              size: 4.h,
              spaceBetween: 1.w,
              checked: !pouchCollected,
              justRead: true,
              onChanged: () {},
            ),
          ),
        ],
      ),
      if (!offline)
        Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: ButtonWidget(
              hintText: "VER DETALHES",
              fontWeight: FontWeight.bold,
              widthButton: 75.w,
              onPressed: () async {
                Get.back();
                await Get.to(() => VisitDetailsPage(
                      visitId: visitId,
                      editPictures: editPictures,
                    ));
                if (controller != null) {
                  await controller.getVisitsOperatorByUserId(showLoad: false);
                }
                if(operatorsVisitsController != null){
                  await operatorsVisitsController.getVisitsUser();
                }
                if(operatorsVisitsPeriodFilterController != null){
                  await operatorsVisitsPeriodFilterController.getVisitsUser();
                }
              },
            )),
      Padding(
        padding: EdgeInsets.only(top: 2.h),
        child: ButtonWidget(
          hintText: "FECHAR",
          fontWeight: FontWeight.bold,
          widthButton: 75.w,
          onPressed: () => Get.back(),
        ),
      ),
    ];
  }
}
