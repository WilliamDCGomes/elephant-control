import 'package:elephant_control/app/views/pages/widgetsShared/rich_text_two_different_widget.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/text_button_widget.dart';
import 'package:elephant_control/app/views/stylePages/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../utils/format_numbers.dart';
import '../operatorPages/maintenanceHistory/widgets/maintenance_header_card_widget.dart';

class SafeBoxCardWidget extends StatelessWidget {
  final String operatorName;
  final String machineName;
  final double amount;

  SafeBoxCardWidget(
      { Key? key,
        required this.operatorName,
        required this.machineName,
        required this.amount,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: TextButtonWidget(
        onTap: (){
          /*BottomSheetPopup.showAlert(
            context,
            MaintenanceInformationPopup.getWidgetList(
              context,
              widget.machineName,
              widget.clock1,
              widget.clock2,
              widget.teddy,
              widget.status.value,
              widget.workPriority,
              widget.priorityColor,
              widget.pouchCollected,
            ),
          );*/
        },
        componentPadding: EdgeInsets.zero,
        widgetCustom: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MaintenanceHeaderCardWidget(
              machineName: machineName,
              done: true,
              operatorDeletedMachine: false.obs,
            ),
            Container(
              height: 6.h,
              width: double.infinity,
              color: AppColors.backgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 44.w,
                    color: AppColors.grayBackgroundPictureColor,
                    padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
                    child: Center(
                      child: RichTextTwoDifferentWidget(
                        firstText: "Nome Operador: ",
                        firstTextColor: AppColors.blackColor,
                        firstTextFontWeight: FontWeight.normal,
                        firstTextSize: 14.5.sp,
                        secondText: operatorName,
                        secondTextColor: AppColors.blackColor,
                        secondTextFontWeight: FontWeight.bold,
                        secondTextSize: 14.5.sp,
                        secondTextDecoration: TextDecoration.none,
                        maxLines: 2,
                      ),
                    ),
                  ),
                  Container(
                    width: 44.w,
                    color: AppColors.grayBackgroundPictureColor,
                    padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 8.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Center(
                            child: RichTextTwoDifferentWidget(
                              firstText: "Valor Recolhido: \n",
                              firstTextColor: AppColors.blackColor,
                              firstTextFontWeight: FontWeight.normal,
                              firstTextSize: 14.5.sp,
                              secondText: "R\$ " + FormatNumbers.numbersToString(amount),
                              secondTextColor: AppColors.blackColor,
                              secondTextFontWeight: FontWeight.bold,
                              secondTextSize: 14.5.sp,
                              secondTextDecoration: TextDecoration.none,
                              maxLines: 2,
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
    );
  }
}