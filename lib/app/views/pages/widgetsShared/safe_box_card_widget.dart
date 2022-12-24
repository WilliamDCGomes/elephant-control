import 'package:elephant_control/app/utils/date_format_to_brazil.dart';
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
  final double? amount;
  final DateTime? deliveryDate;
  final bool pouchHistory;

  SafeBoxCardWidget(
      { Key? key,
        required this.operatorName,
        required this.machineName,
        this.amount,
        this.deliveryDate,
        required this.pouchHistory,
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
              color: AppColors.grayBackgroundPictureColor,
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 8.w),
              child: Center(
                child: RichTextTwoDifferentWidget(
                  firstText: pouchHistory ? "Data Recebimento: " : "Valor Malote: ",
                  firstTextColor: AppColors.blackColor,
                  firstTextFontWeight: FontWeight.normal,
                  firstTextSize: 16.sp,
                  secondText: pouchHistory ? DateFormatToBrazil.formatDate(deliveryDate) :
                  FormatNumbers.numbersToMoney(amount),
                  secondTextColor: AppColors.blackColor,
                  secondTextFontWeight: FontWeight.bold,
                  secondTextSize: 16.sp,
                  secondTextDecoration: TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}