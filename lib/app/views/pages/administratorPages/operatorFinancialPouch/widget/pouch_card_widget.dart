import 'package:elephant_control/app/views/pages/widgetsShared/popups/bottom_sheet_popup.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/rich_text_two_different_widget.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/text_button_widget.dart';
import 'package:elephant_control/app/views/stylePages/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../../base/viewControllers/money_pouch_value_list_viewcontroller.dart';
import '../../../../../utils/date_format_to_brazil.dart';
import '../../../operatorPages/maintenanceHistory/widgets/maintenance_header_card_widget.dart';
import '../popup/pouch_information_popup.dart';

class PouchCardWidget extends StatefulWidget {
  final MoneyPouchValueListViewController moneyPouchValueList;

  const PouchCardWidget(
  { Key? key,
    required this.moneyPouchValueList,
  }) : super(key: key);

  @override
  State<PouchCardWidget> createState() => _PouchCardWidgetState();
}

class _PouchCardWidgetState extends State<PouchCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: TextButtonWidget(
        onTap: (){
          BottomSheetPopup.showAlert(
            context,
            PouchInformationPopup.getWidgetList(
              context,
              widget.moneyPouchValueList.name,
              widget.moneyPouchValueList.userName,
              widget.moneyPouchValueList.alteration,
              widget.moneyPouchValueList.moneyQuantity,
            ),
          );
        },
        componentPadding: EdgeInsets.zero,
        widgetCustom: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MaintenanceHeaderCardWidget(
              machineName: widget.moneyPouchValueList.name,
              done: true,
              operatorDeletedMachine: RxBool(false),
            ),
            Container(
              height: 5.h,
              width: double.infinity,
              color: AppColors.grayBackgroundPictureColor,
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
              child: Center(
                child: RichTextTwoDifferentWidget(
                  firstText: "Última Atualização do Malote: ",
                  firstTextColor: AppColors.blackColor,
                  firstTextFontWeight: FontWeight.bold,
                  firstTextSize: 14.5.sp,
                  secondText: DateFormatToBrazil.formatDate(widget.moneyPouchValueList.alteration),
                  secondTextColor: AppColors.greenColor,
                  secondTextFontWeight: FontWeight.bold,
                  secondTextSize: 14.5.sp,
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