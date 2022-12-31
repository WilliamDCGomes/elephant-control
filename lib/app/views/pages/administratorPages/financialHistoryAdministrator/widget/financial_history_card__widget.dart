import 'package:elephant_control/app/views/pages/widgetsShared/rich_text_two_different_widget.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/text_button_widget.dart';
import 'package:elephant_control/app/views/stylePages/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../../base/viewControllers/safe_box_financial_viewcontroller.dart';
import '../../../../../utils/format_numbers.dart';
import '../../../operatorPages/maintenanceHistory/widgets/maintenance_header_card_widget.dart';
import '../../../widgetsShared/popups/bottom_sheet_popup.dart';
import '../popup/financial_history_popup.dart';

class FinancialHistoryCardWidget extends StatelessWidget {
  final SafeBoxFinancialViewController safeBoxFinancialViewController;

  const FinancialHistoryCardWidget(
      { Key? key,
        required this.safeBoxFinancialViewController,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: TextButtonWidget(
        onTap: (){
          BottomSheetPopup.showAlert(
            context,
            FinancialHistoryPopup.getWidgetList(
              context,
              safeBoxFinancialViewController,
            ),
          );
        },
        componentPadding: EdgeInsets.zero,
        widgetCustom: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MaintenanceHeaderCardWidget(
              machineName: safeBoxFinancialViewController.machineName,
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
                  firstText: "Valor Lançado: ",
                  firstTextColor: AppColors.blackColor,
                  firstTextFontWeight: FontWeight.normal,
                  firstTextSize: 16.sp,
                  secondText: FormatNumbers.numbersToMoney(safeBoxFinancialViewController.moneyWithDrawalQuantity),
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